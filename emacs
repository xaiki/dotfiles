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

(add-to-list 'load-path "~/.elisp/g-client")
(load-library "g")
(setq g-user-email "0xa1f00@gmail.com")

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '(cssh
	el-get
	vkill
	nxhtml
	xcscope
	yasnippet
	org-mode
	naquadah-theme
	gitsum
	google-maps
	google-weather
	nognus
	gnus-gravatar
	gnus-identities
	offlineimap

     (:name emms
	    :after ((require 'emms-setup)
		    (emms-standard)
		    (emms-default-players)))

     (:name git-commit-mode
	    :after ((add-hook 'git-commit-mode-hook 'turn-on-flyspell)
		    (setq git-append-signed-off-by t)
		    (add-hook 'git-commit-mode-hook (lambda () (toggle-save-place 0)))))
;;     (:name bongo
;;	    :after (lambda () (autoload 'bongo "bongo"
;;				"Start Bongo by switching to a Bongo buffer.")))

     (:name twittering-mode
	    :after ((setq twittering-use-master-password t)
		    (setq twittering-convert-fix-size 64)
		    (setq twittering-status-format "%ZEBRA{       %s (%S) %RT{RT via %s}\n%i%T\n       %@ // from %f %L%r%R}")
		    (setq twittering-icon-mode t)                ; Show icons
		    (setq twittering-timer-interval 300)         ; Update your timeline each 300 seconds (5 minutes)
		    (setq twittering-url-show-status nil)        ; Keeps the echo area from showing all the http processes
		    (add-hook 'twittering-edit-mode-hook (lambda () (ispell-minor-mode) (flyspell-mode)))))
     (:name magit
	    :after (lambda () (global-set-key (kbd "C-x C-z") 'magit-status)))
))

(el-get)

(if (string-match "ads.local" (system-name))
    (progn
      (message "we are @sagemcom")
      (autoload 'smtpmail-send-it "smtpmail")
      (setq user-mail-address "niv.sardi@sagemcom.com")
      (setq smtpmail-smtp-server "vzy08031.vzy.sagem"
	    smtpmail-local-domain "sagemcom.com")

      (setq send-mail-function 'smtpmail-send-it)
      (setq message-send-mail-function 'smtpmail-send-it)

      (setq smtp-service "smtp")

      ;;(setq socks-override-functions 1)
      ;;(setq socks-noproxy '("localhost" "*.sagem" "*.local"))
      ;;(when (require 'socks nil nil)
;;	(setq socks-server '("Default server" "localhost" 9999 5))
	;;(setq erc-server-connect-function 'socks-open-network-stream)
	;;(defalias 'open-network-stream 'socks-open-network-stream)
	;;(defalias 'open-network-stream 'socks-original-open-network-stream)
	;;(setq erc-server-connect-function 'open-network-stream)
;;	))
)
  (progn ;; else
    (message "default settings")
    (setq send-mail-function 'smtpmail-send-it
	  starttls-use-gnutls t
	  message-send-mail-function 'smtpmail-send-it
	  smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
	  smtpmail-auth-credentials '(("smtp.gmail.com" 587 "0xa1f00@gmail.com" nil))
	  smtpmail-smtp-server "smtp.gmail.com"
	  smtpmail-smtp-service 587
	  smtpmail-debug-info t)
    (require 'smtpmail)))

(add-to-list 'load-path "~/.emacs.d/")
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
  (when (require 'auto-complete-clang nil t)
    (defun xa1/ac-cc-mode-setup ()
      (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))

    (add-hook 'c-mode-common-hook 'xa1/ac-cc-mode-setup)
    (ac-config-default)

    (setq ac-auto-start nil)
    (setq ac-quick-help-delay 0.5)
    (ac-set-trigger-key "TAB")))

(when (require 'doxymacs nil t) ;; this comes from README.Debian
  (add-hook 'c-mode-common-hook 'doxymacs-mode)
  (defun xa1/doxymacs-font-lock-hook ()
    (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
        (doxymacs-font-lock)))
  (add-hook 'font-lock-mode-hook 'xa1/doxymacs-font-lock-hook))

;;(require 'tramp nil t)
(defvar find-file-root-prefix (if (featurep 'xemacs) "/[sudo/root@localhost]" "/sudo:root@localhost:" )
  "*The filename prefix used to open a file with `find-file-root'.")

(defvar find-file-root-history nil
  "History list for files found using `find-file-root'.")

(defvar find-file-root-hook nil
  "Normal hook for functions to run after finding a \"root\" file.")

(defun find-file-root ()
  "*Open a file as the root user.
   Prepends `find-file-root-prefix' to the selected file name so that it
   maybe accessed via the corresponding tramp method."

  (interactive)
  (require 'tramp)
  (let* ( ;; We bind the variable `file-name-history' locally so we can
	 ;; use a separate history list for "root" files.
	 (file-name-history find-file-root-history)
	 (name (or buffer-file-name default-directory))
	 (tramp (and (tramp-tramp-file-p name)
		     (tramp-dissect-file-name name)))
	 path dir file)

    ;; If called from a "root" file, we need to fix up the path.
    (when tramp
      (setq path (tramp-file-name-localname tramp)
	    dir (file-name-directory path)))

    (when (setq file (ido-read-file-name "Find file (UID = 0): " dir path))
      (find-file (concat find-file-root-prefix file))
      ;; If this all succeeded save our new history list.
      (setq find-file-root-history file-name-history)
      ;; allow some user customization
      (run-hooks 'find-file-root-hook))))

(global-set-key [(control x) (control r)] 'find-file-root)

;;(require 'mule)
;;(require 'un-define)
(when (require 'term-xaiki nil t)
  (when (require 'multi-term nil t)
    (setq term-term-name "eterm-color")
    (global-set-key [?\M-\C-t] 'multi-term)
    (defun term-send-up    () (interactive) (term-send-raw-string "\e[A"))
    (defun term-send-down  () (interactive) (term-send-raw-string "\e[B"))
    (defun term-send-right () (interactive) (term-send-raw-string "\e[C"))
    (defun term-send-left  () (interactive) (term-send-raw-string "\e[D"))
    (defun term-send-home  () (interactive) (term-send-raw-string "\e[F"))
    (defun term-send-Cr  () (interactive) (term-send-raw-string ""))
    (define-key term-raw-map "\C-r" 'term-send-Cr)
    ))

(require 'cl nil t)

(setq-default scroll-step 1)  ; turn off jumpy scroll
(setq-default visible-bell t) ; no beeps, flash on errors
;; Syntaxe highlighting pour tout
;;css
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level 8)

(require 'git nil t)
(require 'git-blame nil t)
(require 'vc-git nil t)

;;(require 'ecb)

(when (require 'font-lock nil t)
  (setq initial-major-mode
	(lambda ()
	  (text-mode)
	  (font-lock-mode)))
  (setq font-lock-mode-maximum-decoration t
	font-lock-use-default-fonts t
	font-lock-use-default-colors t)

  (setq font-lock-maximum-size nil)	; trun off limit on font lock mode
  (global-font-lock-mode t)
  )

(when (if (= emacs-major-version 23)
	   (require 'w3m-load nil t)
	   (require 'w3m nil t))
  (require 'mime-w3m nil t)
;;  (define-key w3m-mode-map [up] 'previous-line)
;;  (define-key w3m-mode-map [down] 'next-line)
;;  (define-key w3m-mode-map [left] 'backward-char)
;;  (define-key w3m-mode-map [right] 'forward-char)
  (setq w3m-key-binding 'info)
  (setq browse-url-browser-function 'w3m-browse-url)
  (global-set-key "\C-xm" 'browse-url-at-point)
  (global-set-key "\C-xw" 'w3m)
  (setq w3m-use-cookies t)
  (setq w3m-cookie-accept-bad-cookies t)
  (remove-hook 'w3m-mode-hook 'w3m-type-ahead-mode)
)

(require 'gnus)
(require 'message)
(when (require 'bbdb-autoloads nil t)
  (progn
    (require 'bbdb)
    (load "bbdb-com" t)
    (bbdb-initialize 'gnus 'message);; 'reportmail 'w3)
    (bbdb-insinuate-message)
    (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
    (bbdb-insinuate-sc)
    (bbdb-insinuate-w3)
    (setq bbdb-north-american-phone-numbers-p nil
	  bbdb-check-zip-codes-p nil
	  bbdb-offer-save 'always-save
	  bbdb-notice-hook (quote (bbdb-auto-notes-hook))
	  bbdb/mail-auto-create-p t
	  bbdb/news-auto-create-p (quote bbdb-ignore-some-messages-hook))))
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

(require 'iedit nil t)

(when (require 'browse-kill-ring nil 'noerror)
  (browse-kill-ring-default-keybindings))

(global-set-key "\C-cy" '(lambda ()
   (interactive)
   (popup-menu 'yank-menu)))

;; this replaces iswitchb
(when (require 'ido nil t)
  (ido-mode t)

  (setq ido-default-buffer-method 'maybe-frame
	ido-default-file-method 'maybe-frame
	ido-enable-flex-matching t)

  (defun xa1/ido-reset-command-cache ()
    "Reset the ido cache"
    (interactive)
    (setq xa1/ido-execute-command-cache nil))

  (xa1/ido-reset-command-cache)
  (defun xa1/ido-execute-command ()
    (interactive)
    (call-interactively
     (intern
      (ido-completing-read
       "M-x "
       (progn
	 (unless xa1/ido-execute-command-cache
	   (mapatoms (lambda (s)
		       (when (commandp s)
			 (setq xa1/ido-execute-command-cache
			       (cons (format "%S" s) xa1/ido-execute-command-cache))))))
	 xa1/ido-execute-command-cache)))))

  (add-hook 'ido-setup-hook
	    (lambda ()
	      (global-set-key "\M-x" 'xa1/ido-execute-command)))

  (defun xa1/ido-find-tag ()
    "Find a tag using ido"
    (interactive)
    (tags-completion-table)
    (let (tag-names)
      (mapc (lambda (x)
              (unless (integerp x)
                (push (prin1-to-string x t) tag-names)))
            tags-completion-table)
      (find-tag (ido-completing-read "Tag: " tag-names))))
  )

(if (require 'hl-line)
    (progn
      (set-face-background 'hl-line "yellow4")
))

(when (require 'ibuffer nil t)
  (setq ibuffer-saved-filter-groups
	(quote (("default"
		 ("Org" ;; all org-related buffers
		  (mode . org-mode))
		 ("Mail"
		  (or  ;; mail-related buffers
               (mode . message-mode)
               (mode . mail-mode)
	       (mode . gnus)
	       (mode . gnus-article-mode)
	       (mode . gnus-summary-mode)
	       (mode . gnus-group-mode)
               ;; etc.; all your mail related modes
               ))
            ("FFMPEG"
              (filename . "Wrk/FFMPEG"))
            ("Icecast"
	     (filename . "Wrk/FF-Replace")
	     (filename . "Wrk/Icecast"))
            ("Wrk"
              (filename . "Wrk"))
	    ("Programming" ;; prog stuff not already in MyProjectX
              (or
                (mode . c-mode)
                (mode . perl-mode)
                (mode . python-mode)
                (mode . emacs-lisp-mode)
		(mode . cscope-mode)
		(mode . cpp-mode)
                ;; etc
                ))
	    ("Term" (mode . term-mode))
            ("ERC"   (mode . erc-mode))))))

(add-hook 'ibuffer-mode-hook
  (lambda ()
    (ibuffer-switch-to-saved-filter-groups "default")
    (hl-line-mode)
    ))

(global-set-key (kbd "C-x x") 'ibuffer)

  (global-set-key (kbd "C-x x") 'ibuffer)
  )

(when (require 'uniquify nil t)
  (setq uniquify-buffer-name-style 'forward))


(require 'iso-transl nil t)
;;(require 'utf-8)
(standard-display-8bit 160 255)
(set-input-mode t nil 0 7)
(set-language-environment 'UTF-8)

(require 'tls)

(when (require 'erc nil t)
;;        This is actually a bug in Emacs redisplay code, rather than in ERC. A fix for it is to set
;;        erc-input-line-position to a value other than nil or -1.
;;        E.g. do:
(setq erc-input-line-position -2)
(setq erc-timestamp-format "[%H:%M] ")
;;(require 'erc-tab)
;;(erc-tab-mode 1)
(setq erc-current-nick-highlight-type 'nick)
(setq erc-keywords '("\\berc[-a-z]*\\b" "\\bemms[-a-z]*\\b"))
(defun erc-prepare-mode-line-format (arg) ())
(setq erc-track-exclude-types '("JOIN" "PART" "QUIT" "NICK" "MODE"))
(setq erc-track-use-faces t)
(setq erc-track-faces-priority-list
      '(erc-current-nick-face erc-keyword-face))
(setq erc-track-priority-faces-only 'all)
)

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

(when (require 'autopair nil t)
  (autopair-global-mode)
  (setq autopair-autowrap t)
  (setq autopair-blink t))

(defun match-paren (arg)
  "Go to the matching parenthesis."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

(global-set-key [(meta n)] 'gnus)
(global-set-key [(control \;)] 'comment-region)

;; EUDC
(require 'ldap)
;;(require 'eudc nil)
;; (setq ldap-host-parameters-alist
;;       (quote (("auth.dmz-int.fr.lan:636" base "ou=users,dc=smartjog,dc=lan"
;;                binddn "cn=Prenom NOM,ou=users,dc=smartjog,dc=lan"
;;                passwd "NO"))))

;; (setq eudc-default-return-attributes nil
;;       eudc-strict-return-matches nil)

;; (setq ldap-ldapsearch-args (quote ("-tt" "-LLL" "-x")))
;; (setq eudc-inline-query-format '((name)
;;                                  (firstname)
;;                                  (firstname name)
;;                                  (email)
;;                                  ))

;; (eudc-set-server "auth.dmz-int.fr.lan:636" 'ldap t)
;; (setq eudc-server-hotlist '(("auth.dmz-int.fr.lan:636" . ldap)))
;; (setq eudc-inline-expansion-servers 'hotlist)

;; (defun enz-eudc-expand-inline()
;;   (interactive)
;;   (move-end-of-line 1)
;;   (insert "*")
;;   (unless (condition-case nil
;;               (eudc-expand-inline)
;;             (error nil))
;;     (backward-delete-char-untabify 1))
;;   )

;; ;; Adds some hooks

;; (eval-after-load "message"
;;   '(define-key message-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
;; (eval-after-load "sendmail"
;;   '(define-key mail-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
;; (eval-after-load "post"
;;   '(define-key post-mode-map (kbd "TAB") 'enz-eudc-expand-inline))

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
(setq tool-bar-style 'image)
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


(when (require 'xcscope nil t)
  (add-hook 'before-save-hook 'delete-trailing-whitespace))

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

(require 'pabbrev nil t)
(add-to-list 'auto-mode-alist '("~/src/.*linux.*/.*\\.[ch]$" . linux-c-mode))
(add-to-list 'auto-mode-alist '("*.make$" . makefile-gmake-mode))
(add-to-list 'auto-mode-alist '("Makefile.*" . makefile-gmake-mode))

(defun ffmpeg-c-mode ()
  "C mode with adjusted values for videolan."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4))

(defun vlc-c-mode ()
  "C mode with adjusted values for videolan."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4))

(defun sagem-c-mode ()
  "C mode with adjusted values for SAGEM."
  (interactive)
  (c-mode)
  (c-set-style "bsd")
  (setq tab-width 3)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 3))

(add-to-list 'auto-mode-alist '("~/src/.*vlc.*/.*\\.[ch]$" . vlc-c-mode))
(add-to-list 'auto-mode-alist '("~/Wrk/.*[Ii]cecast.*/.*\\.[ch]$" . vlc-c-mode))
(add-to-list 'auto-mode-alist '("~/Wrk/.*[Ff][Ff][Mm].*/.*\\.[ch]$" . vlc-c-mode))

(when (require 'kbuild-mode nil t)
  (add-to-list 'auto-mode-alist '(".*Config\\.in.*" . kbuild-mode)))

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
(require 'naquadah-theme)
(setq window-system-default-frame-alist
      '((x
	 (alpha . 95)
	 (font . "ProFontWindows-10")
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
(when (require 'org nil t)
  (run-at-time "00:59" 3600 'org-save-all-org-buffers)
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (setq org-directory "~/org/")
  (when (require 'org-latex nil t)
    (add-to-list 'org-export-latex-packages-alist '("" "listings"))
    (add-to-list 'org-export-latex-packages-alist '("" "color"))
    (setq org-export-latex-listings t))

  (setq org-export-html-style
	"<style type=\"text/css\">
 <!--/*--><![CDATA[/*><!--*/
.src {
        background-color: #3f3f3f !important;
        color: #d8d8d8 !important;
        border-color: #1E2320 !important;
        }
  /*]]>*/-->
   </style>")

  (setq org-default-notes-file (concat org-directory "/notes.org")
	org-agenda-files '("~/.org/TODO.org" "~/.org/WORK.org" "~/.org/PERSONAL.org" "~/.org/w.org"))
  (global-set-key "\C-cr" 'org-remember)
  (global-set-key "\C-cl" 'org-store-link)
  (global-set-key "\C-ca" 'org-agenda)
  (global-set-key "\C-cb" 'org-iswitchb)
  (setq org-completion-use-ido t)
  (setq org-link-abbrev-alist
	'(("rt" . "https://intranet.fr.smartjog.net/rt/Ticket/Display.html?id=")))

  (add-hook 'org-remember-after-finalize-hook 'org-agenda-to-appt) ;; allows agenda items to be added after meeting remember.

  (defun xa1/org-remember-finalize ()
    "Finalize the remember process."
    (interactive)
    (unless org-remember-mode
      (error "This does not seem to be a remember buffer for Org-mode"))
    (run-hooks 'org-remember-before-finalize-hook)
    (unless (fboundp 'remember-finalize)
      (defalias 'remember-finalize 'remember-buffer))
    (when (and org-clock-marker
	       (equal (marker-buffer org-clock-marker) (current-buffer)))
      ;; the clock is running in this buffer.
      (when (and (equal (marker-buffer org-clock-marker) (current-buffer))
		 (or (eq org-remember-clock-out-on-exit t)
		   (and org-remember-clock-out-on-exit
			(y-or-n-p "The clock is running in this buffer.  Clock out now? "))))
	(let (org-log-note-clock-out) (org-clock-out))))
    (when buffer-file-name
      (do-auto-save))
    (remember-finalize)
    (run-hooks 'org-remember-after-finalize-hook))

  (setq org-todo-keywords
	'((sequence "TODO(t)" "|" "DONE(d!)")
	  (sequence "AI(a)" "|" "CLOSED(t!)")
	  (seqence  "TEST(T)" "KO(k!)" "|" "OK(o!)")
	  (sequence "|" "MEETING(m)")
	  (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f!)")
	  (sequence "|" "CANCELED(c!)")))
  (setq org-log-done 'time)
  (setq org-remember-templates
	'(("Meeting" ?m "* MEETING %^{Meeting Date and Time}T%? %:subject\n:PROPERTIES:\n:LOCATION: %^{Location}\n:END:\n %i\n %a" "~/.org/WORK.org" "Meetings")
	  ("Todo" ?t "* TODO %?\n  %i\n  %a" "~/.org/TODO.org" "Tasks")
	  ("Journal" ?j "* %U %?\n\n  %i\n  %a" "~/.org/JOURNAL.org")
	  ("Idea" ?i "* %^{Title}\n  %i\n  %a" "~/.org/JOURNAL.org" "New Ideas")))

  (setq org-icalendar-store-UID t)
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)

  (setq org-src-fontify-natively t)
  (add-hook 'org-mode-hook 'turn-on-font-lock)  ; org-mode buffers only
  (add-hook 'mail-mode-hook 'turn-on-orgstruct++)
  ;;(add-hook 'mail-mode-hook 'turn-on-orgstruct)
  (add-hook 'mail-mode-hook 'turn-on-orgtbl++)
  (setq org-agenda-include-diary t)
  (add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))


  ;; google maps
  (when (require 'org-location-google-maps)
    (message "Org google maps"))

  ;; google weather
  (when (require 'org-google-weather)
    (message "Org google weather")
    (setq org-google-weather-format "%i %-15L, %-15c, %2l-%-2h %s"))

  ;; Remember
  (when (require 'remember nil t)
    (org-remember-insinuate)

    (setq remember-annotation-functions '(org-remember-annotation))
    (setq remember-handler-functions '(org-remember-handler))
    (add-hook 'remember-mode-hook 'org-remember-apply-template)

    (autoload 'remember "remember" nil t)
    (autoload 'remember-region "remember" nil t)

    (define-key global-map "\M-R" 'remember-region))

  (when (require 'appt nil t) ;; from http://article.gmane.org/gmane.emacs.orgmode/5271
    (add-hook 'diary-display-hook 'diary-fancy-display)
    (setq appt-time-msg-list nil)
    (setq appt-display-format 'echo)
    (setq appt-display-mode-line t)
    (setq appt-message-warning-time 120)
    (org-agenda-to-appt)

    (defadvice  org-agenda-redo (after org-agenda-redo-add-appts)
      "Pressing `r' on the agenda will also add appointments."
      (progn
	(setq appt-time-msg-list nil)
	(org-agenda-to-appt)))

    (ad-activate 'org-agenda-redo)
    (appt-activate 1)
    )
)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/.org/TODO.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(server-start)
;;(require 'gnuserv-compat)
;;(gnuserv-start)
