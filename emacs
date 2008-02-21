;; -*- lisp -*-
;;(server-start)
(require 'gnuserv-compat)
(gnuserv-start)

(require 'tramp)

(require 'mule)
;;(require 'un-define)

(require 'cl)

(setq-default scroll-step 1)  ; turn off jumpy scroll
(setq-default visible-bell t) ; no beeps, flash on errors
;; Syntaxe highlighting pour tout
;;css
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level 8)


(require 'ecb)

(require 'font-lock)
(setq initial-major-mode
      (lambda ()
	(text-mode)
	(font-lock-mode)))
(setq font-lock-mode-maximum-decoration t
      font-lock-use-default-fonts t
      font-lock-use-default-colors t)

(setq font-lock-maximum-size nil)	; trun off limit on font lock mode
(global-font-lock-mode t)


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

;; completion du nom du buffer a selectionner en tapant une partie du nom
;; seulement et pas uniquement un prefixe
(require 'iswitchb)
(iswitchb-default-keybindings)

;; Répertoire des scripts
(add-to-list 'load-path "~/.elisp")

;; Pour avoir le module AucTeX
;;(require 'tex-site)

;; Pour avoir les thèmes
(require 'color-theme)



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
(require 'iso-transl)
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
(require 'libempd)
(setq empd-hostname "ayamaru.cxhome.ath.cx")


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
(require 'bbdb)
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


;;

;; eom

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





;; Zenirc
;;(setq zenirc-server-alist
;;      '(("irc.freenode.net" nil nil "xaiki-emacs" nil)))



;; On supprime les menus et la scroll bar (vim-like)
(tool-bar-mode nil)
(menu-bar-mode nil)
(scroll-bar-mode nil)

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


(require 'xcscope)

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

;; Hooks pour le texte
(add-hook 'text-mode-hook
	  '(lambda()
	     (flyspell-mode)
	     (turn-on-auto-fill)
	     (setq fill-column 70)))

;; Eshell
(defun eshell/clear (&optional n) (recenter (if n n 0)))
(defun eshell/emacs (&rest files) (mapc 'find-file (mapcar 'expand-file-name files)))
(add-hook 'shell-mode-hook 'n-shell-mode-hook)
(defun n-shell-mode-hook ()
  "12Jan2002 - sailor, shell mode customizations."
  (local-set-key '[up] 'comint-previous-input)
  (local-set-key '[down] 'comint-next-input)
  (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
  (setq comint-input-sender 'n-shell-simple-send)
  )

(defun n-shell-simple-send (proc command)
  "17Jan02 - sailor. Various commands pre-processing before sending to shell."
  (cond
   ;; Checking for clear command and execute it.
   ((string-match "^[ \t]*clear[ \t]*$" command)
    (comint-send-string proc "\n")
    (erase-buffer)
    )
   ;; Checking for man command and execute it.
   ((string-match "^[ \t]*man[ \t]*\\(.*\\)$" command)
    (comint-send-string proc "\n")
    (funcall 'man (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
    )
   
   ((string-match "^[ \t]*\\(?:emacs\\|vi\\)[ \t]*\\(.*\\)$" command)
    (comint-send-string proc "\n")

    ;;(message (format "command %s command" command))
    (funcall 'find-file-other-window (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
    )

   ((string-match "^[ \t]*\\(?:more\\|less\\)[ \t]*\\(.*\\)$" command)
    (comint-send-string proc "\n")

    ;;(message (format "command %s command" command))
    (funcall 'find-file-other-window (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
    )

   ;; Send other commands to the default handler.
   (t (comint-simple-send proc command))
   )
  )

;; Theme
;;(color-theme-blue-mood)
;;(color-theme-parus)
;;(color-theme-deep-blue)
;;(color-theme-resolve)
;;(color-theme-subtle-hacker)
;;(color-theme-whateveryouwant)
;;(color-theme-word-perfect)

;; Fixer la taille de la police employée sous X
(set-face-attribute 'default nil :font "ProFontWindows-10")

(if window-system (progn 
		    ;;	(set-default-font "-*-terminus-*-r-*-*-*-*-*-*-*-*-*-*")
		    (color-theme-blue-mood)))

  ;;    (set-fontset-font (frame-parameter nil 'font)
  ;;      'han '("cwTeXHeiBold" . "unicode-bmp"))

;; Surligne les parenthèses
(show-paren-mode 1)

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
(setq locale-preferred-coding-systems 'utf-8)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(debian-changelog-full-name "Niv Sardi")
 '(debian-changelog-mailing-address "xaiki@debian.org")
 '(display-time-mode t)
 '(ecb-options-version "2.32")
 '(ecb-source-path (quote ("~/Wrk" "~/src")))
 '(gnuserv-frame t)
 '(jabber-nickname "xaiki")
 '(jabber-server "gmail.com")
 '(jabber-username "0xa1f00")
 '(mm-inline-text-html-with-images t)
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
 '(diff-added ((t (:inherit diff-changed :foreground "green3"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red3"))))
 '(gnus-signature ((t (:foreground "dark red" :slant italic)))))


