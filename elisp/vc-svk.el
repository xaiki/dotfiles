;;;; vc-svk.el --- vc-svn.el =~ s/svn/svk/g
;;;; Sam Vilain <sam@vilain.net> --- Feb 2006

;;;; Other than the challenging task of replacing "svn" with "svk"
;;;; everywhere, the vc-svk-registered function needed to be a little
;;;; bit more complicated.

;;;; ok, so I find another implementation of vc-svk that does a lot
;;;; more than mine in ways that I could only begin to compete with.
;;;; on the other hand, mine seems to work and his doesn't.  so, I'll
;;;; try and pull nice parts of his much better code into mine.

;;;; vc-svn.el by
;;;; Jim Blandy <jimb@red-bean.com> --- July 2002

;;; Writing this back end has shown up some problems in VC: bugs,
;;; shortcomings in the back end interface, and so on.  But I want to
;;; first produce code that SVK users can use with an already
;;; released Emacs distribution.
;;;
;;; So for now we're working within the limitations of the released
;;; VC; once we've got something functional, then we can start writing
;;; VC patches.

;;; To make this file load on demand, put this file into a directory
;;; in `load-path', and add this line to a startup file:
;;;
;;;     (add-to-list 'vc-handled-backends 'SVK)

;;; To do here:
;;; Provide more of the optional VC backend functions:
;;; - dir-state
;;; - merge across arbitrary revisions
;;;
;;; Maybe we want more info in mode-line-string.  Status of props?  Status
;;; compared to what's in the repository (svn st -u) ?
;;;
;;; VC passes the vc-svn-register function a COMMENT argument, which
;;; is like the file description in CVS and RCS.  Could we store the
;;; COMMENT as a SVK property?  Would that show up in fancy DAV
;;; web folder displays, or would it just languish in obscurity, the
;;; way CVS and RCS descriptions do?
;;;
;;; After manual merging, need some way to run `svn resolved'.  Perhaps
;;; we should just prompt for approval when somebody tries to commit a
;;; conflicted file?
;;;
;;; vc-svn ought to handle more gracefully an attempted commit that
;;; fails with "Transaction is out of date".  Probably the best
;;; approach is to ask "file is not up-to-date; do you want to merge
;;; now?"  I think vc-cvs does this.
;;;
;;; Perhaps show the "conflicted" marker in the modeline?
;;;
;;; If conflicted, before committing or merging, ask the user if they
;;; want to mark the file as resolved.
;;;
;;; Won't searching for strings in svn output cause trouble if the
;;; locale language is not English?
;;;
;;; After merging news, need to recheck our idea of which workfile
;;; version we have.  Reverting the file does this but we need to
;;; force it.  Note that this can be necessary even if the file has
;;; not changed.
;;;
;;; Does everything work properly if we're rolled back to an old
;;; revision?
;;;
;;; Perhaps need to implement vc-svk-latest-on-branch-p?

;;; To do in VC:
;;;
;;; Make sure vc's documentation for `workfile-unchanged-p' default
;;; function mentions that it must not run asynchronously, and the
;;; symptoms if it does.
;;;
;;; Fix logic for finding log entries.
;;;
;;; Allow historical diff to choose an appropriate default previous
;;; revision number.  I think this entails moving vc-previous-revision
;;; et al into the back end.
;;;
;;; Should vc-BACKEND-checkout really have to set the workfile version
;;; itself?
;;;
;;; Fix smerge for svk conflict markers.
;;;
;;; We can have files which are not editable for reasons other than
;;; needing to be checked out.  For example, they might be a read-only
;;; view of an old revision opened with [C-x v ~].  (See vc-merge)
;;;
;;; Would be nice if there was a way to mark a file as
;;; just-checked-out, aside from updating the checkout-time property
;;; which in theory is not to be changed by backends.

(eval-when-compile (require 'cl))
(add-to-list 'vc-handled-backends 'SVK)

(defcustom vc-svk-program-name "svk"
  "*Name of SVK client program, for use by Emacs's VC package."
  :type 'string
  :group 'vc
  :version "21.2.90.2")

(defcustom vc-svk-diff-switches nil
  "*A string or list of strings specifying extra switches for `svk diff' under VC."
  :type '(repeat string)
  :group 'vc
  :version "21.2.90.2")

(setf vc-svk-checkout-paths ())

(defun vc-svk-registered (file)
  "Return true if FILE is registered under SVK."
  ;; First, a quick false positive test: is there a `.svk/entries' file?
  (vc-svk-read-config)
  (let ((dirname (or (replace-regexp-in-string "/\$" ""
                                             (file-name-directory
                                              (file-truename file))) ""))
        ;; make sure that the file name is searched case-sensitively
        (case-fold-search nil))
    (let ((found nil))
      (while (and (not found)
                (> (length dirname) 0))
      (if (member dirname vc-svk-checkout-paths)
          (setq found t)
        )
      (setf dirname (replace-regexp-in-string "/[^/]*$" "" dirname))
      )
        (and found (vc-svk-run-status file))))
  )

; This method assumes ~/.svk/config was saved with $YAML::indent = 2
; and that keys are only ever quoted with single quotes
; note - ph34r my ub3r lisp p0w3rs - mugwump.
;(defstruct checkoutpath path true)
(defun vc-svk-read-config ()
  "reads the SVK config file in and sets relevant variables"
  (with-temp-buffer
    (vc-insert-file "~/.svk/config")
    (goto-char (point-min))
    (re-search-forward "^checkout:")
    (let ((start (re-search-forward "^  hash:.*$"))
        (end (re-search-forward "^  [^ ]+:.*$")))
      (setf vc-svk-checkout-paths ())
    (goto-char start)
    (while (< (point) end)
      (if (or (looking-at "^    \\(.*\\):$")
            (looking-at "^    '\\(.*\\)':$")
            )
        (setf vc-svk-checkout-paths (cons (match-string 1) vc-svk-checkout-paths))
      )
      (goto-char (+ (point) 1))
      (if (re-search-forward "^    [^ ]" nil t)
          (goto-char (- (point) 5))
        (setf end (point)))
      )
    vc-svk-checkout-paths
    )
  ))

(put 'vc-svk-with-output-buffer 'lisp-indent-function 0)
(defmacro vc-svk-with-output-buffer (&rest body)
  "Save excursion, switch to buffer ` *SVK Output*', and erase it."
  `(save-excursion
     ;; Let's not delete this buffer when we're done --- leave
     ;; it around for debugging.
     (set-buffer (get-buffer-create " *SVK Output*"))
     (erase-buffer)
     ,@body))

(defun vc-svk-pop-up-error (&rest args)
  "Pop up the SVK output buffer, and raise an error with ARGS."
  (pop-to-buffer " *SVK Output*")
  (goto-char (point-min))
  (shrink-window-if-larger-than-buffer)
  (apply 'error args))

(defun vc-svk-run-status (file &optional update)
  "Run `svk status -v' on FILE, and return the result.
If optional arg UPDATE is true, pass the `-u' flag to check against
the repository, across the network.
See `vc-svk-parse-status' for a description of the result."
  (vc-svk-with-output-buffer

    ;; We should call vc-do-command here, but SVK exits with an
    ;; error status if FILE isn't under its control, and we want to
    ;; return that as nil, not display it to the user.  We can tell
    ;; vc-do-command to

    (let ((status (apply 'call-process vc-svk-program-name nil t nil
                         (append '("status" "-v")
                                 (if update '("-u") '())
                                 (list file)))))
      (goto-char (point-min))
      (if (not (equal 0 status)) ; not zerop; status can be a string
          ;; If you ask for the status of a file that isn't even in a
          ;; SVK-controlled directory, then SVK exits with
          ;; this error.
          (if (or (looking-at "\\(.*\n\\)*.*is not a working copy")
                  (looking-at "\\(.*\n\\)*.*is not a versioned resource")
                  (looking-at "\\(.*\n\\)*.*: No such file or directory"))
              nil
            ;; Other errors we should actually report to the user.
            (vc-svk-pop-up-error
             "Error running SVK to check status of `%s'"
             (file-name-nondirectory file)))

        ;; Otherwise, we've got valid status output in the buffer, so
        ;; just parse that.
        (vc-svk-parse-status)))))

;(vc-svk-run-status "/home/samv/src/Tangram.trunk/t/README.pod")
;('vc-svk-program-name)

(defun vc-svk-parse-status ()
  "Parse the output from `svk status -v' at point.
We return nil for a file not under SVK's control,
or (STATE LOCAL CHANGED) for files that are, where:
STATE is the file's VC state (see the documentation for `vc-state'),
LOCAL is the base revision in the working copy, and
CHANGED is the last revision in which it was changed.
Both LOCAL and CHANGED are strings, not numbers.
If we passed `svk status' the `-u' flag, then CHANGED could be a later
revision than LOCAL.
If the file is newly added, LOCAL is \"0\" and CHANGED is nil."
  (let ((state (vc-svk-parse-state-only)))
    (cond
     ((not state) nil)
     ;; A newly added file has no revision.
     ((looking-at "Unknown target") nil)
     ((looking-at "....\\s-+\\(\\*\\s-+\\)?[-0]\\s-+\\?")
      (list state "0" nil))
     ((looking-at "....\\s-+\\(\\*\\s-+\\)?\\([0-9]+\\)\\s-+\\([0-9]+\\)")
      (list state
            (match-string 2)
            (match-string 3)))
     ((looking-at "^I +") nil)       ;; An ignored file
     ((looking-at " \\{40\\}") nil)  ;; A file that is not in the wc nor svk?
     (t (error "Couldn't parse output from `svk status -v'")))))

(defun vc-svk-parse-state-only ()
  "Parse the output from `svk status -v' at point, and return a state.
The documentation for the function `vc-state' describes the possible values."
  (cond
   ;; Be careful --- some of the later clauses here could yield false
   ;; positives, if the clauses preceding them didn't screen those
   ;; out.  Making a pattern more selective could break something.

   ;; nil                 The given file is not under version control,
   ;;                     or does not exist.
   ((looking-at "\\?\\|^$") nil)

   ;; 'needs-patch        The file has not been edited by the
   ;;                     user, but there is a more recent version
   ;;                     on the current branch stored in the
   ;;                     master file.
   ((looking-at "  ..\\s-+\\*") 'needs-patch)

   ;; 'up-to-date         The working file is unmodified with
   ;;                     respect to the latest version on the
   ;;                     current branch, and not locked.
   ;;
   ;;                     This is also returned for files which do not
   ;;                     exist, as will be the case when finding a
   ;;                     new file in a svk-controlled directory.  That
   ;;                     case is handled in vc-svk-parse-status.
   ((looking-at "  ") 'up-to-date)

   ;; 'needs-merge        The file has been edited by the user,
   ;;                     and there is also a more recent version
   ;;                     on the current branch stored in the
   ;;                     master file.  This state can only occur
   ;;                     if locking is not used for the file.
   ((looking-at "\\S-+\\s-+\\*") 'needs-merge)

   ;; 'edited             The working file has been edited by the
   ;;                     user.  If locking is used for the file,
   ;;                     this state means that the current
   ;;                     version is locked by the calling user.
   (t 'edited)))

;;; Is it really safe not to check for updates?  I haven't seen any
;;; cases where failing to check causes a problem that is not caught
;;; in some other way.  However, there *are* cases where checking
;;; needlessly causes network delay, such as C-x v v.  The common case
;;; is for the commit to be OK; we can handle errors if they occur. -- mbp
(defun vc-svk-state (file)
  "Return the current version control state of FILE.
For a list of possible return values, see `vc-state'.

This function should do a full and reliable state computation; it is
usually called immediately after `C-x v v'.  `vc-svk-state-heuristic'
provides a faster heuristic when visiting a file.

For svk this does *not* check for updates in the repository, because
that needlessly slows down vc when the repository is remote.  Instead,
we rely on SVK to trap situations such as needing a merge
before commit."
  (car (vc-svk-run-status file)))

(defun vc-svk-state-heuristic (file)
  "Estimate the version control state of FILE at visiting time.
For a list of possible values, see the doc string of `vc-state'.
This is supposed to be considerably faster than `vc-svk-state'.  It
just runs `svk status -v', without the `-u' flag, so it's a strictly
local operation."
  (car (vc-svk-run-status file)))

(defun vc-svk-workfile-version (file)
  "Return the current workfile version of FILE."
  (cadr (vc-svk-run-status file)))

(defun vc-svk-checkout-model (file)
  'implicit)

(defun vc-svk-register (file &optional rev comment)
  "Register FILE with SVK.
REV is an initial revision; SVK ignores it.
COMMENT is an initial description of the file; currently this is ignored."
  (vc-svk-with-output-buffer
    (let ((status (call-process vc-svk-program-name nil t nil "add" file)))
      (or (equal 0 status) ; not zerop; status can be a string
          (vc-svk-pop-up-error "Error running SVK to add `%s'"
                               (file-name-nondirectory file))))))

(defun vc-svk-checkin (file rev comment)
  (apply 'vc-do-command nil 0 vc-svk-program-name file
         "commit" (if comment (list "-m" comment) '())))

(defun vc-svk-checkout (file &optional editable rev destfile)
  "Check out revision REV of FILE into the working area.
The EDITABLE argument must be non-nil, since SVK doesn't
support locking.
If REV is non-nil, that is the revision to check out (default is
current workfile version).  If REV is the empty string, that means to
check out the head of the trunk.  For SVK, that's equivalent to
passing nil.
If optional arg DESTFILE is given, it is an alternate filename to
write the contents to; we raise an error."
  (unless editable
    (error "VC asked SVK to check out a read-only copy of file"))
  (when destfile
    (error "VC asked SVK to check out a file under another name"))
  (when (equal rev "")
    (setq rev nil))
  (apply 'vc-do-command nil 0 vc-svk-program-name file
         "update" (if rev (list "-r" rev) '()))
  (vc-file-setprop file 'vc-workfile-version nil))

(defun vc-svk-revert (file &optional contents-done)
  "Revert FILE back to the current workfile version.
If optional arg CONTENTS-DONE is non-nil, then the contents of FILE
have already been reverted from a version backup, and this function
only needs to update the status of FILE within the backend.  This
function ignores the CONTENTS-DONE argument."
  (vc-do-command nil 0 vc-svk-program-name file "revert"))

(defun vc-svk-merge-news (file)
  "Merge recent changes into FILE.

This calls `svk update'.  In the case of conflicts, SVK puts
conflict markers into the file and leaves additional temporary files
containing the `ancestor', `mine', and `other' files.

You may need to run `svk resolved' by hand once these conflicts have
been resolved.

Returns a vc status, which is used to determine whether conflicts need
to be merged."
  (prog1
      (vc-do-command nil 0 vc-svk-program-name file "update")

    ;; This file may not have changed in the revisions which were
    ;; merged, which means that its mtime on disk will not have been
    ;; updated.  However, the workfile version may still have been
    ;; updated, and we want that to be shown correctly in the
    ;; modeline.

    ;; vc-cvs does something like this
    (vc-file-setprop file 'vc-checkout-time 0)
    (vc-file-setprop file 'vc-workfile-version
                     (vc-svk-workfile-version file))))

(defun vc-svk-print-log (file)
  "Insert the revision log of FILE into the *vc* buffer."
  (vc-do-command nil 'async vc-svk-program-name file "log"))

(defun vc-svk-show-log-entry (version)
  "Search the log entry for VERSION in the current buffer.
Make sure it is displayed in the buffer's window."
  (when (re-search-forward (concat "^-+\n\\(rev\\) "
                                   (regexp-quote version)
                                   ":[^|]+|[^|]+| [0-9]+ lines?" nil t))
    (goto-char (match-beginning 1))
    (recenter 1)))

(defun vc-svk-diff (file &optional rev1 rev2)
  "Insert the diff for FILE into the *vc-diff* buffer.
If REV1 and REV2 are non-nil, report differences from REV1 to REV2.
If REV1 is nil, use the current workfile version (as found in the
repository) as the older version; if REV2 is nil, use the current
workfile contents as the newer version.
This function returns a status of either 0 (no differences found), or
1 (either non-empty diff or the diff is run asynchronously)."
  (let* ((diff-switches-list
          ;; In Emacs 21.3.50 or so, the `vc-diff-switches-list' macro
          ;; started requiring its symbol argument to be quoted.
          (condition-case nil
              (vc-diff-switches-list svk)
            (void-variable (vc-diff-switches-list 'SVK))))
         (status (vc-svk-run-status file))
         (local (elt status 1))
         (changed (elt status 2))

         ;; If rev1 is the default (the base revision) set it to nil.
         ;; This is nice because it lets us recognize when the diff
         ;; will run locally, and thus when we shouldn't bother to run
         ;; it asynchronously.  But it's also necessary, since a diff
         ;; for vc-default-workfile-unchanged-p *must* run
         ;; synchronously, or else you'll end up with two diffs in the
         ;; *vc-diff* buffer.  `vc-diff-workfile-unchanged-p' passes
         ;; the base revision explicitly, but this kludge lets us
         ;; recognize that we can run the diff synchronously anyway.
         ;; Fragile, no?
         (rev1 (if (and rev1 (not (equal rev1 local))) rev1))

         (rev-switches-list
          (cond
           ;; Given base rev against given rev.
           ((and rev1 rev2) (list "-r" (format "%s:%s" rev1 rev2)))
           ;; Given base rev against working copy.
           (rev1 (list "-r" rev1))
           ;; Working copy base against given rev.
           (rev2 (list "-r" (format "%s:%s" local rev2)))
           ;; Working copy base against working copy.
           (t '())))

         ;; Run diff asynchronously if we're going to have to go
         ;; across the network.
         (async (or rev1 rev2)))

    (let ((status (apply 'vc-do-command "*vc-diff*" (if async 'async 0)
                         vc-svk-program-name file
                         (append '("diff") rev-switches-list))))
      (if (or async (> (buffer-size (get-buffer "*vc-diff*")) 0))
          1 0))))

(defun vc-svk-find-version (file rev buffer)
  (vc-do-command buffer 0 vc-svk-program-name file
         "cat" "-r" rev))

(provide 'vc-svk)
