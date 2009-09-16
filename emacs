;; -*- lisp -*-

;; Emacs packages used by this config file:
;; auctex	integrated document editing environment for TeX etc.
;; bbdb		The Insidious Big Brother Database (email rolodex) for Emacs
;; cscope	Interactively examine a C program source
;; debian-el	Emacs helpers specific to Debian users
;; devscripts-el
;; dpkg-dev-el	Emacs helpers specific to Debian development
;; emacsen-common	Common facilities for all emacsen
;; emacs-goodies-el	Miscellaneous add-ons for Emacs
;; erc		an IRC client for Emacs
;; gnus		A versatile News and mailing list reader for Emacsen.
;; gnus-bonus-el Miscellaneous add-ons for Gnus
;; gnuserv	Allows you to attach to an already running Emacs
;; mule-ucs	universal encoding system for Mule
;; muse-el	Author and publish projects using Wiki-like markup
;; planner-el	personal information manager for Emacs
;; remember-el	remember text within Emacs
;; speedbar	Everything browser, or Dired on steroids
;; w3m-el	simple Emacs interface of w3m
;; planner-el	personal information manager for Emacs

;; Planed to be used:
;; namazu2	Full text search engine (namazu binary and cgi)v

;; Répertoire des scripts
(add-to-list 'load-path "~/.elisp")

(server-start)
;;(require 'gnuserv-compat)
;;(gnuserv-start)

;;(require 'tramp nil t)

;;(require 'mule)
;;(require 'un-define)

(require 'cl)

(add-to-list 'load-path "~/.elisp/bongo")
(autoload 'bongo "bongo"
  "Start Bongo by switching to a Bongo buffer.")
(require 'bongo)

;;(add-to-list 'load-path "~/.elisp/emms/lisp")
;;(require 'emms-setup)
;;(emms-devel)
;;(emms-default-players)


(setq-default scroll-step 1)  ; turn off jumpy scroll
(setq-default visible-bell t) ; no beeps, flash on errors
;; Syntaxe highlighting pour tout
;;css
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level 8)

(require 'magit nil t)
(require 'git-blame nil t)
(require 'vc-git nil t)

(setq git-append-signed-off-by t)

;;(require 'ecb)

(if (require 'font-lock nil t)
    (progn
      (setq initial-major-mode
	    (lambda ()
	      (text-mode)
	      (font-lock-mode)))
      (setq font-lock-mode-maximum-decoration t
	    font-lock-use-default-fonts t
	    font-lock-use-default-colors t)

      (setq font-lock-maximum-size nil)	; trun off limit on font lock mode
      (global-font-lock-mode t)
      ))

;;(condition-case nil
;;    (require 'w3m)
;;  (file-error nil))


;; Ajout de la date ,de l'heure,de la ligne et de la colonne dans la modeline
(setq display-time-string-forms
      '((format "[%s:%s]-[%s/%s/%s]" 24-hours minutes day month year)))
(setq line-number-mode t)
(setq display-time-24hr-format t)
(setq column-number-mode t)
(display-time)

(setq next-line-add-newlines t)
(setq scroll-preserve-screen-position t); pour pouvoir scroller normalement
(auto-compression-mode t)               ; permet d'ouvrir les gz a la volee
(transient-mark-mode t)

;; this replaces iswitchb
(require 'ido)
(ido-mode t)

(setq ido-execute-command-cache nil)
 (defun ido-execute-command ()
   (interactive)
   (call-interactively
    (intern
     (ido-completing-read
      "M-x "
      (progn
        (unless ido-execute-command-cache
          (mapatoms (lambda (s)
                      (when (commandp s)
                        (setq ido-execute-command-cache
                              (cons (format "%S" s) ido-execute-command-cache))))))
        ido-execute-command-cache)))))

 (add-hook 'ido-setup-hook
           (lambda ()
             (setq ido-enable-flex-matching t)
             (global-set-key "\M-x" 'ido-execute-command)))
  (defun my-ido-find-tag ()
    "Find a tag using ido"
    (interactive)
    (tags-completion-table)
    (let (tag-names)
      (mapc (lambda (x)
              (unless (integerp x)
                (push (prin1-to-string x t) tag-names)))
            tags-completion-table)
      (find-tag (ido-completing-read "Tag: " tag-names))))

;; Pour avoir le module AucTeX
;;(require 'tex-site)

;; Pour avoir le hello world
;; (require 'hello-world)

;;(require 'gnuserv)
;;(gnuserv-start)
;; If you want you can specify the gnuserv binary so you
;; don't use the XEmacs gnuserv binary by accident.
;; (setq server-program "/usr/local/gnuserv-2.1alpha/gnuserv")
;;(setq gnuserv-frame (selected-frame))


;;**********
;;
;; Définition des locales
;;
;;********************

;; On veut les accents
;; Deprecated
;; (standard-display-european 1)
(require 'iso-transl nil t)
;;(require 'utf-8)
(standard-display-8bit 160 255)
(set-input-mode t nil 0 7)
(set-language-environment 'UTF-8)

;;
;;
;; mailcrypt
;;

;; (require 'mailcrypt-init)
;; (load-library "mailcrypt")
;; (mc-setversion "gpg")

;; (autoload 'mc-install-write-mode "mailcrypt" nil t)
;; (autoload 'mc-install-read-mode "mailcrypt" nil t)
;; (add-hook 'mail-mode-hook 'mc-install-write-mode)
;; (add-hook 'gnus-summary-mode-hook 'mc-install-read-mode)
;; (add-hook 'message-mode-hook 'mc-install-write-mode)
;; (add-hook 'news-reply-mode-hook 'mc-install-write-mode)

;; (setq mc-encrypt-for-me t)
;; (setq mc-always-replace t)
;; (setq mc-passwd-timeout 600)
;; ;; Key server at UPC (Barcelona, Spain)
;; (setq mc-pgp-keyserver-address "goliat.upc.es")
;; (setq mc-pgp-keyserver-port 80)
;; (setq mc-pgp-keyserver-url-template
;;       "/cgi-bin/pks-extract-key.pl?op=get&search=%s")
;; (setq mc-pgp-comment nil)

;; ;; ;; If you have more than one key, specify the one to use
;; (setq mc-gpg-user-id "0xC24B9018")

;; ;; fix rmsism.
;; (if (not (fboundp 'comint-read-noecho)) (defalias 'comint-read-noecho 'read-passwd))

;; ;; ;; Always sign encrypted messages
;; (setq mc-pgp-always-sign t)
;; ;; ;; How long should mailcrypt remember your passphrase

;; (add-hook 'message-send-hook 'my-sign-message)
;; (defun my-sign-message ()
;; ;;  (if (yes-or-no-p "Sign message? ")
;;   (if (not (string-match "BEGIN PGP MESSAGE" (buffer-string)))
;;       (mc-sign-message)))
;; ;;)

;; (add-hook 'gnus-select-article-hook 'my-verify-sign)
;; (add-hook 'mc-post-decryption-hook 'decode-buffer)
;; (add-hook 'mc-pre-decryption-hook 'hello_world)

;; (defun my-verify-sign ()
;;   ( mc-verify ))

(require 'erc)
(setq erc-input-line-position -2)
(setq erc-timestamp-format "[%H:%M] ")


;; (defun xa1-scroll-to-bottom (&optional arg)
;;   (interactive)
;;   (progn
;;     (recenter (1- (- scroll-conservatively)))
;;     ))
;; (remove-hook 'erc-send-completed-hook 'xa1-scroll-to-bottom)

(defun recode-buffer ()
  "Recodes buffer in UTF-8"
  (interactive)
  (setq coding-system 'utf-8)
  (let ((buffer-read-only nil)
	(text (buffer-string)))
    (erase-buffer)
    (insert (decode-coding-string (string-make-unibyte text) coding-system)))
  )

(defun recode-region (start end &optional coding-system)
  "Replace the region with a recoded text."
  (interactive "r\n\zCoding System (utf-8): ")
  (setq coding-system (or coding-system 'utf-8))
  (let ((buffer-read-only nil)
	(text (buffer-substring start end)))
    (delete-region start end)
    (insert (decode-coding-string (string-make-unibyte text) coding-system))))

;; Un petit morceau de code qui permet de supprimer les espaces
;; qui restent en fin de ligne.
;; Origine :  lutzeb@cs.tu-berlin.de (Dirk Lutzebaeck) (1992)
(defun delete-trailing-space ()
  "Deletes trailing space from all lines in buffer."
  (interactive)
  (or buffer-read-only
      (save-excursion
        (message "Deleting trailing spaces ... ")
        (goto-char (point-min))
        (while (< (point) (point-max))
          (end-of-line nil)
          (delete-horizontal-space)
          (forward-line 1))
        (message "Deleting trailing spaces ... done.")))
  nil) ; indicates buffer-not-saved for write-file-hook
(define-key ctl-x-map " " 'delete-trailing-space)

;; la nouvelle fonction est associée au raccourci C-x espace

;; mpd
(if (require 'libempd nil t)
    (progn
      (setq empd-hostname "ayamaru.cxhome.ath.cx")
))


(defun match-paren (arg)
  "Go to the matching parenthesis."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
               ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
               (t (self-insert-command (or arg 1)))))

(global-set-key [(meta n)] 'gnus)
(global-set-key [(control \;)] 'comment-region)

;; screw GNUS let's use MEW
;; (global-set-key [(meta m)] 'mew)
;; (require 'mew)

;; (autoload 'mew "mew" nil t)
;; (autoload 'mew-send "mew" nil t)

;; ;; (setq mew-icon-directory "/usr/local/share/emacs/site-lisp/mew/etc")

;; ;; Optional setup (Read Mail menu for Emacs 21):
;; (if (boundp 'read-mail-command)
;;     (setq read-mail-command 'mew))

;; ;; Optional setup (e.g. C-xm for sending a message):
;; (autoload 'mew-user-agent-compose "mew" nil t)
;; (if (boundp 'mail-user-agent)
;;     (setq mail-user-agent 'mew-user-agent))
;; (if (fboundp 'define-mail-user-agent)
;;     (define-mail-user-agent
;;       'mew-user-agent
;;       'mew-user-agent-compose
;;       'mew-draft-send-message
;;       'mew-draft-kill
;;       'mew-send-hook))

;;   bbdb
;;  (require 'bbdb)

;;  (setq bbdb-north-american-phone-numbers-p nil)
;;  (setq bbdb-check-zip-codes-p nil)
;;  (autoload 'bbdb-insinuate-mew      "bbdb-mew"   "Hook BBDB into Mew")
;;  (add-hook 'mew-init-hook 'bbdb-insinuate-mew)
(setq bbdb-send-mail-style 'gnus)

;;  (setq
;;   bbdb-offer-save 'auto
;;   bbdb/news-auto-create-p nil
;;   bbdb/mail-auto-create-p nil
;;   bbdb-north-american-phone-numbers-p nil
;;   bbdb-default-area-code nil
;;   bbdb-complete-name-allow-cycling t
;;   bbdb-complete-name-full-completion t
;;   bbdb-notice-auto-save-file t
;;   bbdb-completion-type 'primary-or-name
;;  )

;; Insane Big brother DataBase (Adressbook)
(if (require 'bbdb nil t)
    (progn
      ;; (setq load-path (cons (concat "/usr/share/emacs21/site-lisp/bbdb") load-path))
      ;; (setq load-path (cons (concat "/usr/share/emacs/site-lisp/bbdb/lisp") load-path))
      ;; (provide 'bbdb/load-path)
      ;; (load-library "bbdb")
      ;; (provide 'bbdb-autoloads)
      ;; (load-library "bbdb-com")
      (load-library "bbdb-gnus")
      ;;(bbdb-initialize)
      (bbdb-initialize 'gnus 'message)
      (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
      (add-hook 'mail-setup-hook 'bbdb-define-all-aliases)
      (setq
       bbdb-offer-save 'auto
       bbdb/news-auto-create-p nil
       bbdb/mail-auto-create-p nil
       bbdb/gnus-summary-known-poster-mark "+"
       bbdb/gnus-summary-mark-known-posters t
       bbdb/gnus-summary-show-bbdb-names t
       bbdb/gnus-summary-prefer-bbdb-data t
       bbdb/gnus-summary-prefer-real-names 'bbdb
       bbdb-north-american-phone-numbers-p nil
       bbdb-default-area-code nil
       bbdb-complete-name-allow-cycling t
       bbdb-complete-name-full-completion t
       bbdb-notice-auto-save-file t
       bbdb-completion-type 'primary-or-name
       )
      (setq bbdb-display-layout nil)
      (setq bbdb-use-pop-up '(quote horiz))
      (setq bbdb-use-pop-up nil)
      (setq bbdb-pop-up-target-lines 5)
      (setq bbdb-pop-up-display-layout nil)
      (setq bbdb-pop-up-elided-display nil)
      (message "BBDB initialized")
      ))

;; Handy little redo function.
(global-set-key [(control x)(control r)] 'redo)

;; replace y-e-s by y
(fset 'yes-or-no-p 'y-or-n-p)

;; pour le menu
;; Pour les personnes qui veulent le menu uniquement quand necessaire
;; control alt m affiche/efface le menu (On peut aussi faire M-x menu-bar-<B style="color:black;background-color:#A0FFFF">mode</B>)
;;(defun hideshow-menubar ()
  ;;  "affiche/enleve la menubar"
  ;; (interactive)
;;  (if (eq (specifier-specs menubar-visible-p 'global) 't)
;;      (set-specifier menubar-visible-p nil 'global)
;;    (set-specifier menubar-visible-p t 'global)
;;    )
;;  )
;; On associe la touche qui fera le swap du menu


(global-set-key [?\M-\C-'] 'menu-bar-mode)
(global-set-key [?\M-\C-,] 'tool-bar-mode)
(global-set-key [?\C-:]    'goto-line)

;; IRC buffers are constantly growing.  If you want to see as much as
;; possible at all times, you would want the prompt at the bottom of the
;; window when possible.  The following snippet uses a local value for
;; `scroll-conservatively' to achieve this:
(rcirc-track-minor-mode 1)
(add-hook 'rcirc-mode-hook
	  (lambda ()
	    (set (make-local-variable 'scroll-conservatively)
		 8192)))
;; The following code activates Fly Spell Mode for `rcirc' buffers:
     (add-hook 'rcirc-mode-hook (lambda ()
                                  (flyspell-mode 1)))

(setq rcirc-default-user-name "xaiki")
(setq rcirc-default-user-full-name "Niv Sardi")


;; If you're chatting from a laptop, then you might be familiar with
;; this problem: When your laptop falls asleep and wakes up later,
;; your IRC client doesn't realize that it has been disconnected.  It
;; takes several minutes until the client decides that the connection
;; has in fact been lost.  The simple solution is to use `M-x rcirc'.
;; The problem is that this opens an _additional_ connection, so
;; you'll have two copies of every channel buffer -- one dead and one
;; live.
;;   The real answer, therefore, is a `/reconnect' command:
(eval-after-load 'rcirc
  '(defun-rcirc-command reconnect (arg)
     "Reconnect the server process."
     (interactive "i")
     (unless process
       (error "There's no process for this target"))
     (let* ((server (car (process-contact process)))
	    (port (process-contact process :service))
	    (nick (rcirc-nick process))
	    channels query-buffers)
       (dolist (buf (buffer-list))
	 (with-current-buffer buf
	   (when (eq process (rcirc-buffer-process))
	     (remove-hook 'change-major-mode-hook
			  'rcirc-change-major-mode-hook)
	     (if (rcirc-channel-p rcirc-target)
		 (setq channels (cons rcirc-target channels))
	       (setq query-buffers (cons buf query-buffers))))))
       (delete-process process)
       (rcirc-connect server port nick
		      rcirc-default-user-name
		      rcirc-default-user-full-name
		      channels))))

;; Zenirc
;;(setq zenirc-server-alist
;;      '(("irc.freenode.net" nil nil "xaiki-emacs" nil)))

;; On supprime les menus et la scroll bar (vim-like)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; On veut editer fvwmrc
(setq auto-mode-alist
      (append '(("\\.[A-Za-z]*wm$" . winmgr-mode)
		("\\.[A-Za-z]*wm2rc" . winmgr-mode))
	      auto-mode-alist))

(autoload 'winmgr-mode "winmgr-mode"
  "Mode for editing window manager config files")

(add-hook 'winmgr-mode-hook
        '(lambda ()
           (font-lock-mode t)
           (setq font-lock-keywords winmgr-font-lock-keywords)
           (font-lock-fontify-buffer)))


(require 'xcscope nil t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Torvalds a dit:
(defun linux-c-mode ()
  "C mode with adjusted values for the linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))

(setq tab-width 8)
(setq indent-tabs-mode t)
(setq c-basic-offset 8)
(setq perl-indent-level 8)
(setq sh-basic-offset 8)

(require 'pabbrev)
(setq auto-mode-alist (cons '("~/src/.*linux.*/.*\\.[ch]$" . linux-c-mode)
			    auto-mode-alist))

(defun vlc-c-mode ()
  "C mode with adjusted values for videolan."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4))

(setq auto-mode-alist (cons '("~/src/.*vlc.*/.*\\.[ch]$" . vlc-c-mode)
			    auto-mode-alist))


;; C-Mode par défaut
;;(add-hook 'c-mode-common-hook
	  ;; (lambda () (c-toggle-auto-hungry-state 1))
;;	  ;; remap RET with C-j (newline-and-indent)
;;	  (lambda () (define-key c-mode-base-map "\C-m" 'c-context-line-break))
;;	  )
;;
;;(add-hook 'c-mode-common-hook
;;	  (lambda () (define-key c-mode-base-map "\:-m" 'goto-line))
;;	  )

;; Python
;; (require 'pycomplete)
;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; (autoload 'python-mode "python-mode" "Python editing mode." t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (setq interpreter-mode-alist(cons '("python" . python-mode)
;; 				  interpreter-mode-alist))

;; Hooks pour le texte
(add-hook 'text-mode-hook
	  '(lambda()
	     (flyspell-mode)
	     (turn-on-auto-fill)
	     (setq fill-column 70)))

;; shell-mode
;;(remove-hook 'comint-output-filter-functions
;;           'ansi-color-apply)
(setq shell-file-name "/bin/sh")
(setq ansi-color-for-comint-mode t)
(setq comint-prompt-read-only t)
(setq comint-move-point-for-output 'all)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun xa1-prompt-in-shell (&optional ignore)
  (backward-char 2)
  (while (search-forward "$" nil t) (replace-match (concat list-buffers-directory "$")nil t))
  )

(add-hook 'comint-output-filter-functions 'xa1-prompt-in-shell)
(add-hook 'comint-output-filter-functions
	     'comint-strip-ctrl-m)


;; ;; Eshell
;; (defun eshell/clear (&optional n) (recenter (if n n 0)))
;; (defun eshell/emacs (&rest files) (mapc 'find-file (mapcar 'expand-file-name files)))
;; (add-hook 'shell-mode-hook 'n-shell-mode-hook)
;; (defun n-shell-mode-hook ()
;;   "12Jan2002 - sailor, shell mode customizations."
;;   (local-set-key '[up] 'comint-previous-input)
;;   (local-set-key '[down] 'comint-next-input)
;;   (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
;;   (setq comint-input-sender 'n-shell-simple-send)
;;   )

;; (defun n-shell-simple-send (proc command)
;;   "17Jan02 - sailor. Various commands pre-processing before sending to shell."
;;   (cond
;;    ;; Checking for clear command and execute it.
;;    ((string-match "^[ \t]*clear[ \t]*$" command)
;;     (comint-send-string proc "\n")
;;     (erase-buffer)
;;     )
;;    ;; Checking for man command and execute it.
;;    ((string-match "^[ \t]*man[ \t]*\\(.*\\)$" command)
;;     (comint-send-string proc "\n")
;;     (funcall 'man (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
;;     )

;;    ((string-match "^[ \t]*\\(?:emacs\\|vi\\)[ \t]*\\(.*\\)$" command)
;;     (comint-send-string proc "\n")

;;     ;;(message (format "command %s command" command))
;;     (funcall 'find-file-other-window (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
;;     )

;;    ((string-match "^[ \t]*\\(?:more\\|less\\)[ \t]*\\(.*\\)$" command)
;;     (comint-send-string proc "\n")

;;     ;;(message (format "command %s command" command))
;;     (funcall 'find-file-other-window (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
;;     )

;;    ;; Send other commands to the default handler.
;;    (t (comint-simple-send proc command))
;;    )
;;   )

;; Theme
;;(color-theme-blue-mood)
;;(color-theme-parus)
;;(color-theme-deep-blue)
;;(color-theme-resolve)
;;(color-theme-subtle-hacker)
;;(color-theme-whateveryouwant)
;;(color-theme-word-perfect)

(setq window-system-default-frame-alist
      '((x
	 (alpha . 90)
	 (font . "Monospace-6")
	 (background-color . "gray20")
	 (foreground-color . "gray85")
	 )))
  ;;    (set-fontset-font (frame-parameter nil 'font)
  ;;      'han '("cwTeXHeiBold" . "unicode-bmp"))

;; Surligne les parenthèses
(show-paren-mode 1)
(blink-cursor-mode -1)

;; On zone quand emacs est inactif depuis t en secondes.
;;(require 'zone)
;; (zone-when-idle 600)

;; Gestion de la souris et de la molette
(setq mouse-wheel-mode t)
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)

(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

;;********************
;;
;; Fonctions lispiennes :
;;
;;********************

;; Fonction d'occurence
(defun call-occur()
(interactive)
(occur (current-word)))
(global-set-key (quote [f3]) 'call-occur)

;; On crée un backup directory pour avoir les "~" dans un seul et unique répertoire.
(defun make-backup-file-name (file)
  (concat "~/.backup/" (file-name-nondirectory file) "~"))

(setq browse-url-epiphany-new-window-is-tab t)

;;**********
;;
;; Raccourci clavier F1, F2 ....
;;
;;********************

;; F1 libre

;; Permet de savoir ce qu'il reste dans la battery
(global-set-key (quote [f2]) 'battery)

;; F3 non-libre

;; Ferme un buffer rapidement
(global-set-key (quote [f4]) 'kill-this-buffer)

;; F5 libre
;; F6 libre
;; F7 libre
;; F8 libre

;; Compilation automatique
(global-set-key (quote [f9]) 'compile)

;; F10 libre

;; F11 libre

;; Next error
(global-set-key (quote [f12]) 'next-error)


(setq default-buffer-file-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

;; Calendar
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)

;; Org mode
;; The following lines are always needed.  Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-font-lock-mode 1)                     ; for all buffers
(add-hook 'org-mode-hook 'turn-on-font-lock)  ; org-mode buffers only
(add-hook 'mail-mode-hook 'turn-on-orgstruct)
(add-hook 'mail-mode-hook 'turn-on-orgtbl)

;; Planner
(if (require 'planner nil t)
    (progn
      (setq planner-project "MainPlanner")

      (setq muse-project-alist
	    '(("MainPlanner"
	       ("~/Plans"           ;; where your Planner pages are located
		:default "TaskPool" ;; use value of `planner-default-page'
		:major-mode planner-mode
		:visit-link planner-visit-link)

	       ;; This next part is for specifying where Planner pages
	       ;; should be published and what Muse publishing style to
	       ;; use.  In this example, we will use the XHTML publishing
	       ;; style.

	      (:base "planner-xhtml"
		     ;; where files are published to
		     ;; (the value of `planner-publishing-directory', if
		     ;;  you have a configuration for an older version
		     ;;  of Planner)
		     :path "~/public_html/Plans"))))

      (if (require 'planner-gnus nil t)
	  (progn (planner-gnus-insinuate)))

      (defun planner-gnus-annotation-from-summary ()
	"If called from a Gnus summary buffer, return an annotation.
Suitable for use in `planner-annotation-functions'."
	(when (equal major-mode 'gnus-summary-mode)
	  (let ((articles (gnus-summary-work-articles nil)))
	    (planner-make-link
	     (concat "gnus://" gnus-newsgroup-name "/"
		     (mapconcat (lambda (article-number)
				  (planner-gnus-get-message-id article-number))
				(gnus-summary-work-articles nil) "\\|"))
	     (if (= 1 (length articles))
		 (let ((headers (gnus-data-header (assq (car articles)
							gnus-newsgroup-data))))
		   (if (gnus-news-group-p gnus-newsgroup-name)
		       (concat "Post "
			       (if (and planner-ignored-from-addresses
				       (string-match
					planner-ignored-from-addresses
					(mail-header-from headers)))
				   ""
				 (concat "from "
					 (planner-get-name-from-address
					  (mail-header-from headers))
					 " "))
			       "on "
			      gnus-newsgroup-name)
		     (concat "E-Mail "
			     (if (and planner-ignored-from-addresses
				     (mail-header-from headers)
				     (string-match planner-ignored-from-addresses
						   (mail-header-from headers))
				     (assq 'To
					   (mail-header-extra headers)))
				 ;; Mail from me, so use the To: instead
				 (concat "to " (planner-get-name-from-address
						(cdr (assq 'To
							   (mail-header-extra
							    headers)))))
			       ;; Mail to me, so use the From:
			       (concat "from " (planner-get-name-from-address
						(mail-header-from headers))))
			     (concat " [" (mail-header-subject headers) "]"))))
	      (concat (number-to-string (length articles))
		      " E-Mails from folder " gnus-newsgroup-name))
	     t))))

      (require 'planner-log-edit nil t)

      ;; Remember
      (if (require 'remember nil t)
	  (progn
	    ;;(org-remember-insinuate)
	    (setq org-directory "~/org/")
	    (setq org-default-notes-file (concat org-directory "/notes.org"))
	    (define-key global-map "\C-cr" 'org-remember)

	    (setq remember-annotation-functions '(org-remember-annotation))
	    (setq remember-handler-functions '(org-remember-handler))
	    (add-hook 'remember-mode-hook 'org-remember-apply-template)

	    (if (require 'remember-planner nil t)
		(progn
		  (setq remember-handler-functions '(remember-planner-append))
		  (setq remember-annotation-functions planner-annotation-functions)))

	    (autoload 'remember "remember" nil t)
	    (autoload 'remember-region "remember" nil t)

	    (define-key global-map "\C-R" 'remember)
	    (define-key global-map "\M-R" 'remember-region)
	    ))
      ))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(calendar-today-marker (quote calendar-today))
 '(column-number-mode t)
 '(cscope-display-cscope-buffer nil)
 '(debian-changelog-full-name "Niv Sardi")
 '(debian-changelog-mailing-address "xaiki@debian.org")
 '(display-time-mode t)
 '(ecb-options-version "2.32")
 '(ecb-source-path (quote ("~/Wrk" "~/src")))
 '(erc-modules (quote (autojoin button completion dcc fill irccontrols list match menu move-to-prompt netsplit networks noncommands readonly ring scrolltobottom services stamp spelling track truncate)))
 '(gnuserv-frame t)
 '(jabber-nickname "xaiki")
 '(jabber-server "gmail.com")
 '(jabber-username "0xa1f00")
 '(lcomp-enable t nil (lcomp))
 '(minibuffer-complete-cycle (quote auto) nil (minibuffer-complete-cycle))
 '(mm-inline-text-html-with-images t)
 '(org-agenda-files (quote ("~/.org/TODO")))
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(smime-keys (quote (("xaiki@cxhome.ath.cx" "/dev/null" ("")))))
 '(text-mode-hook (quote (turn-on-auto-fill (lambda nil (flyspell-mode) (turn-on-auto-fill) (setq fill-column 70)) text-mode-hook-identify)))
 '(transient-mark-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(use-file-dialog nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(calendar-today ((t (:inverse-video t :underline t))))
 '(completions-common-part ((t (:inherit default :weight bold))))
 '(custom-button-unraised ((t (:inherit underline :background "white" :foreground "black" :inverse-video t))))
 '(custom-group-tag ((t (:inherit custom-variable-tag-face :foreground "blue" :underline t))))
 '(custom-variable-button ((t (:background "black" :foreground "white" :underline t :weight bold))))
 '(custom-variable-tag ((t (:foreground "magenta" :underline t :weight bold :height 1.6))))
 '(diff-added ((t (:inherit diff-changed :foreground "green3"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red3"))))
 '(erc-button ((t (:inherit link :weight bold))))
 '(erc-input-face ((t (:foreground "brown1"))))
 '(gnus-button ((t (:foreground "violet" :weight bold))))
 '(gnus-signature ((t (:foreground "dark red" :slant italic))))
 '(message-header-subject ((t (:foreground "light blue" :weight bold))))
 '(mode-line ((t (:background "blue4" :foreground "#d4d4d4" :box (:line-width -1 :style released-button)))))
 '(widget-button ((t (:inherit link :underline nil :weight bold))))
 '(widget-field ((t (:background "gray85" :foreground "black"))))
 '(widget-single-line-field ((t (:background "gray85" :foreground "black")))))


