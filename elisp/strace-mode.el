(eval-when-compile
  (require 'cl))

(require 'regexp-opt)
(require 'faces)

(defgroup strace nil
  "Colorize Strace Output (minimal)."
  :tag "Str"
  :group 'help)

(defface strace-hl-face '((t (:bold t)))
  "*Font used by strace for highlighting first match."
  :group 'strace)

(defface strace-comment-face '((t (:foreground "red") (:bold nil)))
  "*Font used by strace for comments, after first match."
  :group 'strace)

(setq strace-mode-=regexp "= \\([-0-9]+\\)\\(?: \\([A-Z]*\\)\\(?: \(\\(.*\\)\)\\)?\\)?")

;; match host >$ commands -i subarg --args `sub-commands` # comments
;; match host ># commands -i subarg --args `sub-commands` # comments
(setq strace-lock-keywords
      '(("^\\([0-9]+\\)" 0 font-lock-preprocessor-face keep)
	("^\\([^ ]*\\)\(" 1 font-lock-function-name-face keep)
	("= \\([-0-9xa-f]+\\)\\(?: \\([A-Z]*\\)\\(?: \(\\(.*\\)\)\\)?\\)?" 1 font-lock-variable-name-face keep)
	("= \\([-0-9xa-f]+\\) \\([A-Z]*\\)\\(?: \(\\(.*\\)\)\\)?" 2 font-lock-type-face keep)
	("= \\([-0-9xa-f]+\\)\\(?: \\([A-Z]*\\)\\)? \(\\(.*\\)\)" 3 font-lock-comment-face prepend)
	("\"[^\"]+\"" 0 font-lock-string-face prepend)
	("/\\*.*\\*/" 0 font-lock-comment-face keep)
;;	("0x[0-9a-f]+" 0 font-lock-builtin-face prepend)
	("PROT_READ\\|PROT_WRITE\\|PROT_EXEC\\|PROT_NONE" 0 font-lock-builtin-face)
	("MAP_PRIVATE\\|MAP_DENYWRITE\\|MAP_FIXED\\|MAP_ANONYMOUS\\|MAP_SHARED" 0 font-lock-builtin-face)
	("NULL\\|R_OK" 0 font-lock-builtin-face)
	("O_RDONLY\\|O_RDWR\\|O_CREAT\\|O_EXCL\\|O_NONBLOCK\\|O_LARGEFILE\\|O_DIRECTORY" 0 font-lock-builtin-face)
	("F_SETFD\\|" 0 font-lock-builtin-face keep)
	("SIG_BLOCK\\|" 0 font-lock-builtin-face keep)
	("S_IFDIR\\|S_IFREG" 0 font-lock-builtin-face keep)
	("FD_CLOEXEC\\|" 0 font-lock-builtin-face keep)
	("FUTEX_WAKE\\|FUTEX_WAIT" 0 font-lock-builtin-face keep)
	("CLOCK_MONOTONIC\\|CLOCK_REALTIME" 0 font-lock-builtin-face keep)
	("POLLPRI\\|POLLFD \\|POLLIN" 0 font-lock-builtin-face keep)
	("SOCK_STREAM\\|SOCK_DGRAM" 0 font-lock-builtin-face keep)
	("PF_FILE\\|PF_INET" 0 font-lock-builtin-face keep)
	("CLONE_VM\\|CLONE_FS\\|CLONE_FILES\\|CLONE_SIGHAND\\|CLONE_THREAD\\|CLONE_SYSVSEM\\|CLONE_SETTLS\\|CLONE_PARENT_SETTID\\|CLONE_CHILD_CLEARTID" 0 font-lock-builtin-face keep)
	("NULL\\|R_OK" 0 font-lock-builtin-face)
	("TRAP\\|ABRT" 0 font-lock-warning-face keep)
	("SIG[^[ |]]+" 0 font-lock-warning-face keep)
	("<unfinished \\.\\.\\.>" 0 font-lock-warning-face keep)
	("<\\.\\.\\..*resumed>" 0 font-lock-warning-face keep)
	("<\\.\\.\\. \\([^ ]+\\) resumed" 1 font-lock-function-name-face prepend)
))

(defun strace-turn-on ()
  "Turn on font-lock for strace-mode"
  (font-lock-add-keywords nil strace-lock-keywords))

(defun strace-turn-off ()
  "Turn off font-lock for strace-mode"
  (font-lock-remove-keywords nil '(,@strace-lock-keywords)))

;;;###autoload
(define-minor-mode strace-minor-mode
  "Minor Mode for Coloring strace output"
  :lighter " strace"
  (progn
    (if strace-minor-mode
	(strace-turn-on)
      (strace-turn-off)
      (font-lock-mode 1))))
;;;###autoload
(define-derived-mode strace-mode makefile-gmake-mode "Strace" "Major Mode for Coloring strace output"
  (strace-minor-mode))

(provide 'strace-mode)
