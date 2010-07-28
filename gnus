;; -*- mode: emacs-lisp; coding: utf-8; -*-
;; Time-stamp: <30/07/2006 16:22 seki@petisuix.seki.fr>
;;+----------------------------------------------------------+
;;|                                                          |
;;|                      Seki's dotgnus                      |
;;|                                                          |
;;+----------------------------------------------------------+
;; Merci à Nicolas Bareil <nbareil@mouarf.org>
;;       à Mathieu Roy <yeupou@gnu.org>
;; et aux différentes listes et newsgroups d'entraide d'utilisateurs :
;; fr.comp.applications.emacs
;; gnu.emacs.help
;; voir ici pour les listes : http://savannah.gnu.org/mail/?group_id=40

(copy-face 'default 'gnus-default)
;;(set-face-attribute 'gnus-default nil :font "ProFontWindows-9")

(copy-face 'gnus-default 'mysubject)
(setq gnus-face-1 'mysubject)

(setq my-gnus-group-line-groupname-unread-face-1 nil)
(copy-face 'gnus-default 'my-gnus-group-line-groupname-unread-face-1)
(set-face-foreground 'my-gnus-group-line-groupname-unread-face-1 "yellow")

(setq my-gnus-group-line-groupname-read-face-3 nil)
(copy-face 'gnus-default 'my-gnus-group-line-groupname-read-face-3)
(set-face-foreground 'my-gnus-group-line-groupname-read-face-3 "green")

(setq my-gnus-group-line-groupname-unread-face-3 nil)
(copy-face 'gnus-default 'my-gnus-group-line-groupname-unread-face-3)
(set-face-foreground 'my-gnus-group-line-groupname-unread-face-3 "red")

(setq gnus-mouse-face-5 nil)
(copy-face 'gnus-default 'gnus-mouse-face-5)
(set-face-foreground 'gnus-mouse-face-5 "yellow")

(copy-face 'gnus-default 'mytime)
(set-face-foreground 'mytime "indianred4")
(setq gnus-face-2 'mytime)

(copy-face 'gnus-default 'mythreads)
(set-face-foreground 'mythreads "indianred4")
(setq gnus-face-3 'mythreads)

(copy-face 'gnus-default 'mygrey)
(set-face-foreground 'mygrey "grey")
(setq gnus-face-4 'mygrey)

(copy-face 'gnus-default 'myblack)
(set-face-foreground 'myblack "grey60")
(setq gnus-face-5 'myblack)

(copy-face 'gnus-default 'mybiggernumbers)
(set-face-foreground 'mybiggernumbers "indianred4")
(setq gnus-face-6 'mybiggernumbers)

;; ====== Réglages validés =================================

;; dossiers
(setq gnus-home-directory  "~/.gnus.d")
(setq message-directory    "~/.gnus.d/Mail")
(setq gnus-directory       "~/.gnus.d/News")
(setq gnus-agent-directory "~/.gnus.d/agent")

;;----- identité --------------------------------------------
(setq user-full-name "Niv Sardi")

;; l'adresse mail DOIT être valide pour l'envoi SMTP (indiqué dans l'enveloppe)
;;(setq user-mail-address "sebastien.kirche@free.fr")
(setq user-mail-address "niv.sardi@smartjog.com")

;; mes autre adresses : en répondant à un message permet de réutiliser
;; l'adresse du To:/From:/CC: de ce message
(setq message-alternative-emails
      (regexp-opt (cons user-mail-address
			'("xaiki@cxhome.ath.cx"
			  "xaiki@debian.org"
			  "xaiki@evilgiggle.com"
			  "nsardi@smartjog.com"
			  "niv.sardi@smartjog.com"
;;			  "xaiki@sgi.com"
;;			  "xaiki@openwide.fr"
			  "xaiki+.*@cxhome.ath.cx"
			  ))))

;; mes addresses sont à supprimer dans les wide-reply
(setq message-dont-reply-to-names message-alternative-emails)

;; afficher les noms des destinataires à la place du mien pour les
;; messages que j'ai envoyés
(setq gnus-ignored-from-addresses "Niv Sardi") ;; 8e9 = é latin-1 /
					       ;; f69 = é latin-9

;; si on veut bidouiller l'adresse pour le MAIL, utiliser la ligne
;;suivante (setq smtpmail-mail-address
;;"sebastien.kirche.no@spam.free.fr.invalid") pour bidouiller
;;l'adresse pour les NEWS, voir le champ From: dans les posting styles
(setq message-user-organization "GZi")


;;----- réglages des sources (select methods) et des envois ---------------
;; Mode par défaut : gnus-agent
(setq gnus-agent t) ;plus nécessaire en 21.3.50 ?
;;(setq gnus-agent nil
;;          gnus-agent-cache nil)

(setq gnus-asynchronous t)

;; setup imap
(setq imap-log nil)
(setq imap-debug nil)
(setq imap-store-password t)
(setq nnimap-request-list-method 'imap-mailbox-list)

;;serveur news principal
(setq gnus-select-method
      '(nnmaildir "LocalMail"
		  (directory "~/Mail/")
		  (directory-files nnheader-directory-files-safe)
		  (get-new-mail nil)))
(defun turn-off-backup ()
  (set (make-local-variable 'backup-inhibited) t))

;; Set in GNUS with B blah ...
(setq gnus-secondary-select-methods
      '((nnfolder "patches"
		  (nnfolder-directory "~/Wrk/pending-patches/")
		  (nnfolder-active-file "~/Wrk/pending-patches/active")
;;		  (nnfolder-save-buffer-hook 'turn-off-backup)
		  (nnfolder-get-new-mail t))
	))

;; on peut créer un .authinfo sur le modále :
;;machine foo.bar.com login your_username password your_pass
;; qui peut être (si accás anonyme possible et pb de liste de groupes)
;;machine foo.bar.com login your_username password your_pass force yes
;;et
;;machine localhost login foo password bar

;;serveur(s) secondaires
;;(add-to-list 'gnus-secondary-select-methods '(nntp "autre.serveur.de.news"))

;; serveur mail
;;voir les backends dispo (1 fichier/serveur 1 fichier/groupe ou 1 fichier/msg)
;;(add-to-list 'gnus-secondary-select-methods '(nnml "")
;;(setq mail-sources
;;      '((pop :server "pop.fai.org"
;;           :user "moi"
;;           :password "pwd")))


;;======= comportement du gnus ==============================
;;usage du cache !
(setq gnus-use-cache t)

; Veut plus qu'il me demande si je veut récupérer
; la derniáre sauvegarde (auto-save)
(setq gnus-always-read-dribble-file t )

;; On dégage les messages en double
(setq nnmail-treat-duplicates 'delete)

; Ne pas créér de fichier IncomingXXXX
;(setq mail-source-delete-incoming t)

;relit la liste des groupes depuis l'active-file
(setq gnus-read-active-file 'some)

;demande les nouveaux groupes au serveur
(setq gnus-check-new-newsgroups 'ask-server)

;; corrige les problámes de mixed latin-1 / latin-9
(setq message-default-charset 'utf-8
      ;; ??? gnus-default-posting-charset (quote iso-8859-15)
      mm-body-charset-encoding-alist '((iso-8859-1 . 8bit)
				       (iso-8859-15 . 8bit)))
(add-to-list 'mm-charset-synonym-alist '(iso8859-15 . iso-8859-15))
(add-to-list 'mm-charset-synonym-alist '(iso885915 . iso-8859-15))

;;========== réglages des GROUPES ===================================
;(setq gnus-group-line-format "%M%S%5y: %(%G%)\n")
;à tester
;; From ding@gnus.org - Larsi
;;(setq gnus-group-line-format "%M%S%p%P %3y %~(ignore 0)2U%G\n")

;; Quel article lire le premier lorsqu'on sélectionne le groupe
;; avec <SPACE> ?
;;                  - nil  : N'affiche aucun message
;;                  - best : L'article le mieux scoré
;;                  - t    : Le premier article non-lu.
(setq gnus-auto-select-first 'best)

;; Scorage des groupes les plus lus
(add-hook 'gnus-summary-exit-hook
	  'gnus-summary-bubble-group)

;; Classer les groupes en fonction de leur hits
(setq gnus-group-sort-function '(gnus-group-sort-by-unread
				 gnus-group-sort-by-rank))

;; Mise en place des 'Topics' pour un affichage structuré des groupes
;; Introduction rapide : T n - create new topic
;;                       T m - move group
;;                       C-k - cut group and ...
;;                       C-y - ... insert it here
;;                     T C-h - Overview about the commands
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

(setq  gnus-topic-display-empty-topics nil      ;nil = cacher les topics vides
       gnus-topic-indent-level 2)

;; Format d'affichage des topics
;; Format disponible dans le chapitre 2.16.1 du manuel Gnus
;;(setq gnus-topic-line-format "%i[ %n -- %A/%g]\n")
(setq gnus-topic-line-format
      "%6v            %5(%5{%7A %}%)%* %5(%5{ ==> %-31n%)%}\n" )

;;========== SUMMARY ===================================
;;présentation des messages alignés avec indication des fils
;; l'hyperlien nom-score-taille-sujet est délimité par les %( %)
(setq gnus-summary-line-format
      (concat
       "%*%5{%U%R%z%}"
       "%4{|%}"
       "%2{%-10&user-date;%}"
       "%4{|%}"
       "%2{ %}%(%f (%t)%-38="
       "%4{|%}"
       "%2{%5i%}"
       "%4{|%}"
       "%2{%6t %}"
       "%4{|%}"
       "%2{ %}%3{%B%}%1{%s%}%)\n"))

;;(gnus-user-format-function-test "blah")

;;(defun gnus-user-format-function-test (arg)
;;  (concat "tested: " arg))

;; affichage de la date en relatif
(setq gnus-user-date-format-alist
      '(((gnus-seconds-today) . "     %k:%M")		;dans la journée =      14:39
	((+ 86400 (gnus-seconds-today)) . "Yest %k:%M")	;hier            = hier 14:39
	((+ 604800 (gnus-seconds-today)) . "%a  %k:%M") ;dans la semaine = sam  14:39
	((gnus-seconds-month) . "%a  %d")		;ce mois         = sam  28
	((gnus-seconds-year) . "%b  %d")		;durant l'année  = mai  28
	(t . "%b %d '%y")))				;le reste        = mai  28 '05

; Indentation des threads
(setq gnus-thread-indent-level 2)

; Méthode d'identification des messages orhpelins
(setq gnus-summary-gather-subject-limit 'fuzzy)

; Ne pas ouvrir les threads lors du démarrage
(setq gnus-thread-hide-subtree t)

; Supprimer les threads au score inférieur à celui requis
;(setq gnus-thread-expunge-below t )

; Lorsqu'on 'kill' un thread, celui-ci est caché
(setq gnus-thread-hide-killed t)

; Trier les threads en fonctions du score, puis par date
(setq gnus-thread-sort-functions
      '(gnus-thread-sort-by-total-score
	gnus-thread-sort-by-date
	))

; Ne mettre en cache que les articles définis comme persistants
;(setq gnus-use-cache 'passive)

; Lorsqu'on sauvegarde un article, conserver tous les headers
(setq gnus-save-all-headers t)

; Quel format utilisé pour l'archivage par défault ? mbox.
(setq gnus-default-article-saver
      'gnus-summary-save-in-mail)

(setq gnus-emphasis-alist
      '(
	("^\>?\s?\\([+-][+-][+-] \\)" 0 1 diff-header)
	("^\>?\s?[+-][+-][+-] \\(.*\\)$" 1 1 diff-file-header)
	("^\>?\s?\\(@@ .* @@.*\\)$" 0 1 diff-header)
	("^\>?\s?\\([+][^+].*\\)" 0 1 diff-added)
	("^\>?\s?\\([-][^-].*\\)" 0 1 diff-removed)
	))
; Je suis un peu mégalomane, donc je veux voir mon pseudo s'afficher en
; gras-souligné
;; (setq gnus-emphasis-alist
;;       '(
;;         ;; ("_\\(\\w+\\)_"      0 1 gnus-emphasis-underline)
;;         ("\\*\\(\\w+\\)\\*"  0 1 gnus-emphasis-bold)
;;      ("\\(nbareil\\)"     0 1 gnus-emphasis-underline-bold)
;;      ("\\(offset\\)"      0 1 gnus-emphasis-underline-bold)
;;      ("\\(madchat\\)"     0 1 gnus-emphasis-underline-bold)
;;      ("\\(matoufou\\)"     0 1 gnus-emphasis-underline-bold)
;;      ))

;;===== Quotage (de goret)===================================
; [Format] Snip des messages (W-W-c)
; Format disponible dans le chapitre 3.16.3 du manuel Gnus
(setq gnus-cited-lines-visible '(0 . 4))
(setq gnus-cited-closed-text-button-line-format
      "\[ Snip %n lines (%l Characters) \]\n")

; Couper les lignes trop longues
(setq-default gnus-treat-fill-long-lines nil)
(setq gnus-article-strip-blank-lines t)

; Mise en couleur de la signature
(setq gnus-treat-highlight-signature 'last)

(setq gnus-treat-unsplit-urls t)
(setq gnus-treat-hide-citation t)
(setq gnus-treat-x-pgp-sig 'head)

; Veut pas des gorets !
;(add-hook 'gnus-part-display-hook 'gnus-article-hide-citation-maybe)

; Remplacer la date par X-Sent
(setq gnus-treat-date-lapsed 'head)
; Ne pas afficher les secondes défilées
(gnus-stop-date-timer)
; Remplace l'header Date:
(setq gnus-article-date-lapsed-new-header t);nil)

;; Ajouter des boutons
(setq gnus-treat-buttonize t)
(setq gnus-treat-buttonize-head 'head)

;; Supprimer les retours charriots (^M)
(setq gnus-treat-strip-cr 'last)

; Provient du manuel Gnus (Node 3.16.7)
(setq gnus-signature-separator
      '("^-- $"		; The standard
	"^-- *$"	; A common mangling
	"^-------*$"    ; Many people just use a looong
	; line of dashes.  Shame!
	"^ *--------*$" ; Double-shame!
	"^________*$"   ; Underscores are also popular
	"^----- Original Message -----$"
	)) ; Pervert!

; Ne pas inclure la signature lors d'une réponse
(setq message-cite-function 'message-cite-original-without-signature)

; Supprimer les messages en double
(setq gnus-suppress-duplicates t)

;; Nettoyer les messages d'un coup
;; http://my.gnus.org/node/view/94
(defun bhaak-wash-this-article ()
  (interactive)
  (gnus-article-outlook-deuglify-article)
  (gnus-article-fill-cited-article nil '70)
  (gnus-article-capitalize-sentences))
(define-key gnus-summary-mode-map "\C-c\w" 'bhaak-wash-this-article)

;; ===== Messages ===================================

;;dictionnaire par défaut
(setq ispell-local-dictionary "english");plutýt ispell-dictionary ?

; Couper les lignes à X caractáres pour rédiger
;;(require 'filladapt)
(defun sk-gnus-message-hook ()
  (set-fill-column 72)
  (turn-on-auto-fill)
;;  (filladapt-mode)
  (flyspell-mode)
  (setq default-justification 'left)
  (setq footnote-spaced-footnotes nil
	footnote-section-tag "")
  (footnote-mode)
  )
(add-hook 'message-mode-hook 'sk-gnus-message-hook)

; Mes ch'tits headers
;(setq gnus-ignored-headers ".*")
(setq gnus-visible-headers
      "^To:\\|^Reply-To:\\|^Cc:\\|^From:\\|^Date:\\|^Subject:\\|^X-Sent:\\|^X-Mailer:\\|^User-Agent:\\|^X-Newsreader:\\|^Organization:\\|^Newsgroups:\\|^Followup-to:\\|^X-Spam-Status:\\|^Approved:\\|^Message-ID:")

; Retirer les headers à dormir debout
(setq gnus-boring-article-headers '(empty many-to newsgroup))
(setq gnus-treat-hide-boring-header 'head)

; Je ne veux pas de HTML, ni de richText, non mais oh !
(setq mm-discouraged-alternatives '("text/html" "text/richtext"))
(setq mm-text-html-renderer 'w3m-standalone);'w3m

; Répertoire par défaut des attachements
(setq gnus-summary-save-parts-last-directory "~/Wrk/")
(setq mm-default-directory gnus-summary-save-parts-last-directory)

; Il y a des fonctions appellées en doubles, mais c'est pas grave
; du moment que ca marche !  TODO : ben justement faudra faire du ménage...

(add-hook 'gnus-article-display-hook 'gnus-article-highlight)
;; cache les cles PGP
;(add-hook 'gnus-article-display-hook 'gnus-article-hide-pgp)
;; cache les headers indésirables
(add-hook 'gnus-article-display-hook 'gnus-article-hide-headers-if-wanted)
;; marre des gorets
(add-hook 'gnus-article-display-hook  'gnus-treat-hide-citation-maybe)
;; vire certains headers s'ils sont vides
(add-hook 'gnus-article-display-hook 'gnus-article-hide-boring-headers)
;; vire le QP
(add-hook 'gnus-article-display-hook 'gnus-article-de-quoted-unreadable)
;; met en valeur les *machins* et autres _trucs_
(add-hook 'gnus-article-display-hook 'gnus-article-emphasize)

;; Pour ne pas afficher les tags débiles des ML...
(setq gnus-list-identifiers
      '("\\[spam\\]"
	"\\[exces\\]"
	"\\[ppm\\]"))

;; ne pas scroller le message si le reste n'est que quote+signature
(setq gnus-article-skip-boring t)

;; Je veux mes smileys :)
;;(setq gnus-treat-display-smileys t) TODO : rajouter pour le mac
(setq gnus-treat-display-smileys t)
;;(setq smiley-data-directory
;;"/Applications/Emacs.app/Contents/Resources/etc/smilies")

(add-hook 'gnus-article-display-hook 'gnus-smiley-display t)

;; Nécessite le package compface
(setq gnus-treat-display-x-face 'nil)

;; Afficher les liens avec lynx si on est en mode console
(require 'browse-url)
;(setq browse-url-browser-function
;      (if window-system 'browse-url-galeon 'browse-url-lynx-emacs))

;; (if (string-match "\\`obelix" system-name)
;;      (progn
;;        (setq browse-url-browser-function (quote browse-url-galeon))
;;        (setq browse-url-galeon-arguments (quote ("-n")))))

;;(remove-hook 'gnus-summary-mode-hook
;;         (global-set-key [w] 'gnus-article-hide-citation))
(setq gnus-summary-mode-hook nil)
(add-hook 'gnus-summary-mode-hook
	  (lambda ()
	    (setq header-line-format "Flags   Date               From           Score   Size          Subject " )
	    ))

;; décodage des parties mml
;; auteur : drkm de fr.comp.applications.emacs
(when (require 'drkm-mml nil t)
  ;;(autoload 'drkm-mml:decode-parts "drkm-mml")
  (add-hook 'gnus-part-display-hook 'drkm-mml:decode-parts)
  (push '("nntp+news.cuq.org:fr.comp.applications.emacs" . emacs-lisp-mode)
	drkm-mml:group-alist)
  )

;; ===== Rédaction de message ===================================

;; (defun face-insert ()
;;   (with-temp-buffer nil
;;     (insert-file-contents "~/Gnus/xfaces/face")
;;     (buffer-string)))

; Pour tout le monde
;;(setq gnus-posting-styles nil)
(setq gnus-posting-styles
       '((".*"
	  (eval (ispell-change-dictionary "english"))
	  (signature "Niv Sardi")
	  (eval (setq tc-time-format "%H:%M on %b %e %Y" ;; FIXME : format-time-string & localized names
		      ;;                      ;;         fonction de LC_TIME
;;                      ;;         voir pour définir une fonction de mapping
;;                      tc-make-attribution 'sk-tc-attribution-en)))
		      )))))
;; ;;        ((message-mail-p)
;;          ;;(From    "Sébastien Kirche <sebastien.kirche@free.fr>"))
;; ;;         (From    "Niv Sardi <xaiki@cxhome.ath.cx>")
;; ;;         (X-GPG-Key-ID "C89C1296")
;; ;;         (X-GPG-Key "http://keyserver.mine.nu/pks/lookup?op=get&search=0x91486A51C89C1296")
;; ;;         (X-GPG-Fingerprint "018A FECD F20B D90F 74E9  DB74 9148 6A51 C89C 1296")
;;          ;;              (eval (let ((dico (completing-read
;;          ;;                                                     "Use new dictionary (RET for current, SPC to complete): "
;;          ;;                                                     (and (fboundp 'ispell-valid-dictionary-list)
;;          ;;                                                              (mapcar 'list (ispell-valid-dictionary-list)))
;;          ;;                                                     nil t)))
;;          ;;                              (ispell-change-dictionary dico)))
;; ;;         )
;;         ((message-news-p)               ;".*"
;;          (From    "Niv Sardi <xaiki.invalid@cxhome.ath.cx>")
;;          (Reply-To "Niv Sardi <xaiki@cxhome.ath.cx>"))
;;         ("^\\(.*:\\)?fr\..*$"
;;          (eval (ispell-change-dictionary "francais"))
;;          (eval (setq tc-time-format "%e %B %Y à %H:%M"
;;                      tc-make-attribution 'sk-tc-attribution-fr)))
;;         ;;("^us" (eval (ispell-change-dictionary "american"))            )
;;         )
;;       )

;;remplacement des posting styles : gnus-alias ===============================================
;; (defalias 'message-functionp 'functionp) ;; workaround : Gnus ne définit plus message-functionp
;; (autoload 'gnus-alias-determine-identity "gnus-alias" "" t)
;; (add-hook 'message-setup-hook 'gnus-alias-determine-identity)

;; (eval-after-load "gnus-alias"
;;   '(progn
;;       (define-key message-mode-map (kbd "C-c i") 'gnus-alias-select-identity)
;;       (setq gnus-alias-point-position 'empty-header-or-body
;;                 gnus-alias-unknown-identity-rule 'default
;;                 gnus-alias-default-identity "standard")
;;       (setq gnus-alias-identity-alist '(
;;                                                                         ;;identité = (ident refers from org extra body sig)
;;                                                                         ("standard" nil
;;                                                                              "Sébastien Kirche <seki@seki.fr>"
;;                                                                              message-user-organization
;;                                                                              (("X-Face" . sk:x-face))
;;                                                                              nil
;;                                                                              user-full-name)
;;                                                                         ("news" "standard"
;;                                                                              "Sébastien Kirche <sebastien.kirche.no@spam.free.fr.invalid>"
;;                                                                              nil
;;                                                                              (("Reply-To" .  "Sébastien Kirche <sebastien.kirche@free.fr>"))
;;                                                                              nil
;;                                                                              nil)
;;                                                                         ("fmbl" "news"
;;                                                                              nil
;;                                                                              nil
;;                                                                              (("X-Face" . ""))
;;                                                                              nil
;;                                                                              "Séki")
;;                                                                         ("dinos" "news"
;;                                                                              nil
;;                                                                              nil
;;                                                                              (("X-Face" . "")
;;                                                                               ("Approved" . "seki"))
;;                                                                              nil
;;                                                                              nil)
;;                                                                         ))
;;       (setq gnus-alias-identity-rules '(
;;                                                                         ("fmbl" ("Newsgroups" "fr.misc.bavardages.linux" current) "fmbl")
;;                                                                         ("fmbd" ("Newsgroups" "fr.misc.bavardages.dinosaures" current) "dinos")
;;                                                                         ("news défaut" ("Newsgroups" ".*" current) "news")
;;                                                                         ("mail" message-mail-p "standard")
;;                                                                         ))
;;       ))

;(setq gnus-alias-identity-rules
;      '(("Envoie un mail à toto@titi.com avec l'identité test"
;         ("to" "toto@titi.com" current) "test")))


;;       (address "nbareil@mouarf.org")
;;       (organization "madchat (http://www.madchat.org/)")
;;       ("X-GnuPG-Key" "0x09223052")
;; ;         (eval (ispell-change-dictionary "french"))
;;          ;; ("Face" face-insert)
;;          )
;;         )
;;       )

;; Keep ispell from checking attachments!
(add-to-list 'ispell-skip-region-alist '("^<#mml" . "^<#/mml>"))
(add-to-list 'ispell-skip-region-alist '("^<#part" . "^<#/part>"))
(add-to-list 'ispell-skip-region-alist '("^<#secure" . ">$"))
(add-to-list 'ispell-skip-region-alist '("^>" . "$"))
;
(add-to-list 'ispell-skip-region-alist '("^--.*--"))
(add-to-list 'ispell-skip-region-alist '("--text follows this line--"))


;; ne marche pas pas comme je veux : check seulement à l'envoi :(
;; (setq ispell-message-dictionary-alist
;;       '(
;;              (".*" . "english")
;;              ("^Newsgroups:[ \t]*fr\\.*" . "francais")
;; ))

;(add-hook 'message-setup-hook 'fortune-to-signature)

;(setq message-default-mail-headers "Gcc: INBOX.Sent\n")
;(setq message-default-news-headers "Gcc: INBOX.Sent\n")

; colorier le buffer de réponse utilisé le hook
; gnus-message-setup-hook n'est documenté que dans gnus-msg.el
; comme quoi, il faut lire les sources parfois (From Nicolas Chuche)
(add-hook 'gnus-message-setup-hook 'font-lock-fontify-buffer)

; Ne pas conserver les buffers de message
(setq message-kill-buffer-on-exit t)

;; Afficher le From avec des <> ;parentháses
(setq message-from-style 'angles);'parens)

;; supprimer le (was: ...) dans le sujet ?
(setq message-strip-subject-was 'ask)

;; Ne pas sauter à la ligne aprás les caractáres insecables
;; ou aprás certaines ponctuations.
;; Par Damien Wyart sur fr.comp.application.emacs
;; (defun my-fill-nobreak-predicate ()
;;   (save-match-data
;;     (or (looking-at "[ \t]*[])}»!?;:]")
;;      (save-excursion
;;        (skip-chars-backward " \t")
;;        (backward-char 1)
;;        (looking-at "[([{«]")))))

;; (add-hook 'message-mode-hook
;;        '(lambda ()
;;           (setq fill-nobreak-predicate
;;                 #'my-fill-nobreak-predicate)))


;;(add-hook 'message-mode-hook 'iso-accents-mode) ; Non ! (cf f.c.a.emacs)

;; Contenu du User-Agent
;(setq gnus-user-agent '(emacs gnus config)) ;; défaut = '(emacs gnus type)
(setq gnus-user-agent '(emacs gnus config))

;; évite de justifier le champ User-Agent
;;(add-to-list 'message-field-fillers '(User-Agent ignore))

;;on n'ajoute pas de champ Cancel-Lock:
(setq message-insert-canlock nil)

;;===== Scoring ===================================
(setq gnus-use-scoring t)

; Répertoire courant pour les fichier de scoring
;(setq gnus-kill-files-directory "~/.gnus.d/etc/score/")

; Suffixe employé pour les fichiers
(setq gnus-score-file-suffix "Score")

; Score par défault
(setq gnus-summary-default-score 0)

; Ne pas afficher le message, si le score < 500
(setq gnus-summary-expunge-below -499)

; Méthode pour trouver le fichier Scorefile
(setq gnus-score-find-score-files-function 'gnus-score-find-bnews)

; Adaptive scoring
(setq gnus-use-adaptive-scoring t);nil
(defvar gnus-default-adaptive-score-alist
  '((gnus-unread-mark)
    (gnus-ticked-mark (from 4))
    (gnus-dormant-mark (from 5))
    (gnus-del-mark (from -4) (subject -1))
    (gnus-read-mark (from 4) (subject 2))
    (gnus-expirable-mark (from -1) (subject -1))
    (gnus-killed-mark (from -1) (subject -3))
    (gnus-kill-file-mark)
    (gnus-ancient-mark)
    (gnus-low-score-mark)
    (gnus-catchup-mark (from -1) (subject -1))))

;; Scoring sur mes headers.
;; Nécessite de regenerer la base NOV
(setq gnus-extra-headers '(To Cc Newsgroups Keywords)
      nnmail-extra-headers gnus-extra-headers)

;;===== Divers ===================================
;;archivage de mes messages / posts
(setq gnus-gcc-mark-as-read t)
(setq gnus-message-archive-method
      '(nnfolder "archives"
		 (nnfolder-directory "~/.gnus.d/archives")
		 (nnfolder-active-file "~/.gnus.d/archives/active")
		 (nnfolder-get-new-mail nil)))
(setq gnus-message-archive-group
      '((if (message-news-p)
	    (concat "nnfolder+archives:News-sent." (format-time-string "%Y-%m"))
	  (concat "nnfolder+archives:Mail-sent." (format-time-string "%Y-%m"))
	  )))

;; Lorsqu'un article n'est plus disponible dans le serveur NNTP, on utilise
;; google.com
;; Message-id : <m3wurdqusg.fsf@fermat.mts.jhu.edu>
;; This snippet comes from the info docs Gnus->Finding the Parent.
(setq gnus-refer-article-method
      '(current
	(nnimap "imap-eu.smartjog.net")
	(nntp "news.gmane.org")
	(nnweb "google" (nnweb-type google))))
(when
    (cond
     ((executable-find "curl")
      (setq
       mm-url-arguments
       `("--silent"
	 ;;               ,(concat "-A\" Mozilla/5.0 (Windows; U; Windows NT 5.0; "
	 ;;                               "en-US; rv:1.3a) Gecko/20021207 Phoenix/0.5\" ")
	 ;;              "-e http://groups.google.com/advanced_search"
	 "-A mm-url"
	 "-L"
	 )
       mm-url-program "curl"))

     ((executable-find "wget")
      (setq
       mm-url-arguments
       `("--quiet"
	 ;;                      ,(concat "-U=\"Mozilla/5.0 (Windows; U; Windows NT 5.0; "
	 ;;                                       "en-US; rv:1.3a) Gecko/20021207 Phoenix/0.5\"")
	 "-U mm-url"
	 )
       mm-url-program "wget"))
     )
  (setq mm-url-use-external t))

; Niveau de verbosité
(setq gnus-verbose 42
      gnus-verbose-backends 42)
(setq message-interactive t)

;; supprimer rapidement un thread
(defun cg-gnus-summary-ignore-thread ()
  (interactive)
  (let* ((hdr (gnus-summary-article-header))
	 (subj (aref hdr 1)))
    (gnus-summary-score-entry "Subject" subj 'S' -1000
			      (current-time-string))
    (recenter scroll-conservatively)
    ))

(define-key gnus-summary-mode-map  "i" 'cg-gnus-summary-ignore-thread)

(defun xa1-gnus-summary-next-article ()
  (interactive)
  (progn
    (gnus-summary-next-unread-article)
    (recenter scroll-conservatively)
    ))

(define-key gnus-summary-mode-map  "n" 'xa1-gnus-summary-next-article)

;;  -*-*-*-*-*-{   trivial cite   }-*-*-*-*-*-*-
;;  ( http://shasta.cs.uiuc.edu/~lrclause/tc.html )
;;(autoload 'trivial-cite "tc" t t)

;;(setq message-cite-function 'trivial-cite)
(setq message-cite-function 'message-cite-original-without-signature)
;; we want a space after the citation-char '>'
;(setq tc-citation-string "> ")
;;(setq tc-citation-string "> ")
;; we want to toggle with S-mouse-2 (tc-unfill-paragraph) the auto. filled
;; paragraphes (they are highlighted if you move the mouse over it)
;;(setq tc-mouse-overlays t)
;; This can avoid the "malformed field" error
;;(setq tc-gnus-nntp-header-hack t)
;; customize the attribution
;(setq tc-make-attribution 'tc-fancy-attribution)

;; phrase d'introduction custom -> modifié : utilise trivial-cite
;;(defun message-insert-citation-line ()
;;  "La fonction qui insere une ligne aux reponses"
;;  (when message-reply-headers
;;    ;; In savannah-hackers group, we talk english
;;    (if (string-equal gnus-newsgroup-name "savannah-hackers")
;;    (insert (mail-header-from message-reply-headers) " said:\n\n")
;;      (insert (mail-header-from message-reply-headers) " a tapoté :\n\n")
;;      )))
;(setq mail-extr-ignore-single-names nil) ;permet de considérer un real-name d'un seul mot
;;(remove-hook 'mail-citation-hook 'trivial-cite) ;aussi pour le mail

(setq gnus-supercite-regexp "^\\(\\([ 	]*[_.[:word:]]+>+\\|[ 	]*[]>]\\)+\\)? *>>>>> +\"\\([^\")
]+\\)\" +==")
(setq message-cite-prefix-regexp "\\([ 	]*[_.[:word:]]+>+\\|[ 	]*[]>]\\)+")
(setq tc-debug-level 1
      mail-extr-ignore-single-names nil
      mail-extr-ignore-realname-equals-mailbox-name nil
      tc-normal-citemarks  ">:"
      tc-fill-long-lines   't
      ;;tc-time-format "%e %B %Y à %H:%m"
      ;;tc-make-attribution 'sk-tc-attribution
      )
;      tc-make-attribution 'tc-fancy-attribution
;      tc-groups-functions '(("alt.sysadmin.recovery" . nix-tc-bofh-group-attribution)
;                            ("bofh." . nix-tc-bofh-group-attribution))
(defun sk-tc-attribution-fr ()
  "Générer l'attribution."
  (let ((style (random 4))
	(date (cdr (assoc "date" tc-strings-list)))
	(email (cdr (assoc "email-addr" tc-strings-list)))
	(name (cdr (assoc "real-name" tc-strings-list))))
    (cond ((= style 0)
	   (concat "Le " date ", " (or name email) " a dit :\n\n"))
	  ((= style 1)
	   (concat "Le " date ", " (or name email) " s'est exprimé ainsi :\n\n"))
	  ((= style 2)
	   (concat "Le " date ", " (or name email) " vraute :\n\n"))
	  ((= style 3)
	   (concat "Le " date ", " (or name email) " a formulé :\n\n"))
	  (t
	   (concat "Le " date ", " (or name email) " écrivit :\n\n")))))

(defun sk-tc-attribution-en ()
  "Générer l'attribution."
  (let ((style (random 1))
	(date (cdr (assoc "date" tc-strings-list)))
	(email (cdr (assoc "email-addr" tc-strings-list)))
	(name (cdr (assoc "real-name" tc-strings-list))))
    (cond ((= style 0)
	   (concat "At " date ", " (or name email) " said :\n\n"))
	  (t
	   (concat "At " date ", " (or name email) " wrote :\n\n")))))

;; ====== Zone expérimentale ================================


;comment envoyer les msg
(setq smtpmail-smtp-server "smtp-eu.smartjog.net")

(setq send-mail-function 'sendmail-send-it)
(setq message-send-mail-function 'sendmail-send-it)

;(setq smtp-default-server smtpmail-default-smtp-server)
;(setq smtp-server smtpmail-default-smtp-server)
(setq smtp-service "smtp")
;(setq smtp-local-domain "free.fr")
;(setq smtp-debug-info t)
(autoload 'smtpmail-send-it "smtpmail")
;;(setq user-full-name "YOUR NAME HERE")

;; To queue mail, set smtpmail-queue-mail to t and use
;; smtpmail-send-queued-mail to send.

;; ;(setq gnus-secondary-select-methods
;; (setq gnus-secondary-select-methods
;;       '((nnimap "metz-exchange"
;;                 (nnimap-server-port 143)
;;                 (nnimap-address "metz-exchange")
;;     (nnimap-expunge-on-close never))
;;   (nnml "")))

;; (setq mail-sources
;;    '((file :path "~/gnusspool")))

;; (setq nnmail-split-methods
;;    '(("localhost" "")))

;; (setq mm-discouraged-alternatives
;;    '("text/html" "text/richtext"))

;; (setq nnimap-split-predicate
;;    '("UNDELETED"))

;---------

;; (setq gnus-secondary-select-methods
;;       '((nnimap "metz-exchange")
;;  )
;;       imap-username "SAGE_METZ/seki"
;; )
;
;(setq gnus-secondary-select-methods
;      ;; slashdot
;      '((nnslashdot "")
;      ;; exchange server
;      (nnimap "Exchange"
;              (nnimap-address "metz-exchange")
;              (imap-username "SAGE_METZ/seki/seki"))))
;
;(setq gnus-select-method (quote (nntp "news.free.fr")))

;affichage des anciens message lus (assez pour afficher les threads)
(setq gnus-fetch-old-headers t) ;'some)
(setq gnus-build-sparse-threads 'more) ;'some)

;; On garde les threads en un seul morceau meme si le sujet change
;(setq gnus-gather-loose-threads t) ;???
(setq gnus-summary-thread-gathering-function
      'gnus-gather-threads-by-subject) ;'gnus-gather-threads-by-references

;;archivage des messages
(defun sk-archive-article (&optional n)
  "Copies one or more article(s) to a corresponding `nnml:' group, e.g.
`gnus.ding' goes to `nnml:1.gnus.ding'. And `nnml:List-gnus.ding' goes
to `nnml:1.List-gnus-ding'.

Use process marks or mark a region in the summary buffer to archive
more then one article."
  (interactive "P")
  (let ((archive-name
	 (format
	  "nnml:1.%s"
	  (if (featurep 'xemacs)
	      (replace-in-string gnus-newsgroup-name "^.*:" "")
	    (replace-regexp-in-string "^.*:" "" gnus-newsgroup-name)))))
    (gnus-summary-copy-article n archive-name)))

(setq gnus-buffer-configuration
  '((group
     (vertical 1.0
	       (group 1.0 point)
	       (if gnus-carpal '(group-carpal 4))))
    (summary
     (vertical 1.0
	       (summary 1.0 point)
	       (if gnus-carpal '(summary-carpal 4))))
    (article
     (cond
      (gnus-use-trees
       '(vertical 1.0
		  (summary 0.25 point)
		  (tree 0.25)
		  (article 1.0)))
      (t
       '(vertical 1.0
		  (summary 0.25 point)
		  (if gnus-carpal '(summary-carpal 4))
		  (article 1.0)))))
    (server
     (vertical 1.0
	       (server 1.0 point)
	       (if gnus-carpal '(server-carpal 2))))
    (browse
     (vertical 1.0
	       (browse 1.0 point)
	       (if gnus-carpal '(browse-carpal 2))))
    (message
     (vertical 1.0
	       (message 1.0 point)))
    (pick
     (vertical 1.0
	       (article 1.0 point)))
    (info
     (vertical 1.0
	       (info 1.0 point)))
    (summary-faq
     (vertical 1.0
	       (summary 0.25)
	       (faq 1.0 point)))
    (edit-article
     (vertical 1.0
	       (article 1.0 point)))
    (edit-form
     (vertical 1.0
	       (group 0.5)
	       (edit-form 1.0 point)))
    (edit-score
     (vertical 1.0
	       (summary 0.25)
	       (edit-score 1.0 point)))
    (edit-server
     (vertical 1.0
	       (server 0.5)
	       (edit-form 1.0 point)))
    (post
     (vertical 1.0
	       (post 1.0 point)))
    (reply
     (vertical 1.0
	       (article 0.5)
	       (message 1.0 point)))
    (forward
     (vertical 1.0
	       (message 1.0 point)))
    (reply-yank
     (vertical 1.0
	       (message 1.0 point)))
    (mail-bounce
     (vertical 1.0
	       (article 0.5)
	       (message 1.0 point)))
    (pipe
     (vertical 1.0
	       (summary 0.25 point)
	       (if gnus-carpal '(summary-carpal 4))
	       ("*Shell Command Output*" 1.0)))
    (bug
     (vertical 1.0
	       (if gnus-bug-create-help-buffer '("*Gnus Help Bug*" 0.5))
	       ("*Gnus Bug*" 1.0 point)))
    (score-trace
     (vertical 1.0
	       (summary 0.5 point)
	       ("*Score Trace*" 1.0)))
    (score-words
     (vertical 1.0
	       (summary 0.5 point)
	       ("*Score Words*" 1.0)))
    (split-trace
     (vertical 1.0
	       (summary 0.5 point)
	       ("*Split Trace*" 1.0)))
    (category
     (vertical 1.0
	       (category 1.0)))
    (compose-bounce
     (vertical 1.0
	       (article 0.5)
	       (message 1.0 point)))
    (display-term
     (vertical 1.0
	       ("*display*" 1.0)))
    (mml-preview
     (vertical 1.0
	       (message 0.5)
	       (mml-preview 1.0 point)))))

;; (setq gnus-use-trees t
;;       gnus-generate-tree-function 'gnus-generate-horizontal-tree
;;       gnus-tree-minimize-window nil)

;;  (gnus-add-configuration
;;   '(summary
;;     (horizontal 1.0 (vertical 25 (group 1.0))
;;                 (vertical 1.0 (summary 1.0 point))
;;                         )))

;;(gnus-add-configuration
;; '(article
;;   (horizontal 1.0
;;               (vertical 0.3
;;                         (group 1.0)
;;                         (tree 0.3))
;;               (vertical 1.0
;;                         (summary 0.3)
;;                         (article 1.0)))))

;; (gnus-add-configuration
;;  '(article
;;    (vertical 1.0
;; 	     (horizontal 0.25
;; 			 (summary 1.0))
;; 	     (article 1.0))))

;; (gnus-add-configuration
;;  '(summary
;;    (horizontal 1.0
;; 	       (vertical 0.2 (group 1.0))
;; 	       (vertical 1.0 (summary 1.0 point)))))

;; permet la saisie d'un message dans une nouvelle frame
;; (gnus-add-configuration
;;  '(message (frame 1.0
;;                                (if (not (buffer-live-p gnus-summary-buffer))
;;                                        (car (cdr (assoc 'group gnus-buffer-configuration)))
;;                                      (car (cdr (assoc 'summary gnus-buffer-configuration))))
;;                                (vertical ((user-position . t) (top . 1) (left . 1)
;;                                                       (name . "Message"))
;;                                                      (message 1.0 point)))))


;  (require 'message)
;  (add-to-list 'message-syntax-checks '(sender . disabled))

;  (setq gnus-posting-styles
;    '((".*"
;(name "moi"))))
  ;(address "sebastien.kirchaaaaae@wanadoo.fr")
 ;        (sender  "alerim@wanadoo.fr"))
;(sender "ssss")
;)
;));

    ;; (setq gnus-posting-styles
;;            '((".*"
;;               (signature-file "~/.signature")
;;               (name "User Name")
;;               ("X-Home-Page" (getenv "WWW_HOME"))
;;               (organization "People's Front Against MWM"))
;;              ("^rec.humor"
;;               (signature my-funny-signature-randomizer))
;;              ((equal (system-name) "gnarly")
;;               (signature my-quote-randomizer))
;;              ((message-news-p)
;;               (signature my-news-signature))
;;              (header "From\\|To" "larsi.*org"
;;                      (Organization "Somewhere, Inc."))
;;              ((posting-from-work-p)
;;               (signature-file "~/.work-signature")
;;               (address "user@bar.foo")
;;               (body "You are fired.\n\nSincerely, your boss.")
;;               (organization "Important Work, Inc"))
;;              ("nnml:.*"
;;               (From (save-excursion
;;                       (set-buffer gnus-article-buffer)
;;                       (message-fetch-field "to"))))
;;              ("^nn.+:"
;;               (signature-file "~/.mail-signature"))))

;; (setq gnus-posting-styles
;;         '((".*"
;;            (signature
;;             (format "Your Name Here\nURL: %s\nE-Mail: %s" "http://your.doma.in" user-mail-address)

;;             ))))

(if (or
     (string-match "\\`obelix" system-name)
     (string-match "\\`petisuix" system-name)
     (string-match "\\`goudurix" system-name)
     (string-match "\\`zebigbos" system-name))
    (when window-system;obelix
      (setq gnus-sum-thread-tree-root "\x490b3 ")     ; "> "
      ;;(setq gnus-sum-thread-tree-root "\x4912f ")                          ; "> "
      ;;(setq gnus-sum-thread-tree-false-root "\x490f8 ")                    ; "> "
      ;;(setq gnus-sum-thread-tree-false-root "\x4912f ")                    ; "> "
      (setq gnus-sum-thread-tree-false-root "\x490b3 ") ; "> "
      ;;(setq gnus-sum-thread-tree-single-indent "\x4912e ")                 ; ""
      ;;(setq gnus-sum-thread-tree-single-indent "\x490b3 ")                 ; ""
      (setq gnus-sum-thread-tree-single-indent "  ") ; ""
      (setq gnus-sum-thread-tree-leaf-with-other "\x4903c\x49020\x490fb ") ; "+-> "
      (setq gnus-sum-thread-tree-vertical "\x49022") ; "| "
      ;;(setq gnus-sum-thread-tree-single-leaf "\x490b0\x49020\x490fa "))   ; "\\-> "
      (setq gnus-sum-thread-tree-single-leaf "\x49034\x49020\x490fb ")) ; "\\-> "
  (when window-system                                      ;autre
    (setq gnus-sum-thread-tree-root "> ")                  ; "> "
    (setq gnus-sum-thread-tree-false-root "> ")            ; "> "
    (setq gnus-sum-thread-tree-single-indent "")           ; ""
    (setq gnus-sum-thread-tree-leaf-with-other "+-> ")     ; "+-> "
    (setq gnus-sum-thread-tree-vertical "| ")              ; "| "
    (setq gnus-sum-thread-tree-single-leaf "`-> ")))       ; "\\-> "

 (setq gnus-summary-same-subject "")

;; test group summary
; Group-line
; See also: (gnus)Formatting Variables
; Its kinda hard to read I think, without the different faces it would
; look like this: (setq gnus-group-line-format "%4i  %7U  %7y %* %B%-45G\n")
; The text between the brackets will be formated with different faces:
; Between "%2{" and "%}" gnus will use gnus-face-2. Similar gnus will use
; gnus-mouse-face-1 between "%1(" and "%)".
; More Info: (gnus)Formatting Fonts
;;(setq gnus-group-line-format "%1(%1{%4i %}%)%{ %}%2(%2{%7U %}%)%{ %}%3(%3{%7y %}%)%{%* %}%4(%B%-45G%)\n" )
(setq gnus-group-line-format "%1(%1{%6i %}%)%{ %}%2(%2{%7U %}%)%{ %}%3(%3{%7y %}%)%{%* %}%4(%B%-45G%)\n" )
; Faces to use for the group-names ("%-45G") ...
; More about that: (gnus)Group Highlighting
(setq gnus-group-highlight nil)
;;;       ;; ... if the group has no unread articles, depending on the level
;;;       '(((and (= level 1) (= unread 0)). my-gnus-group-line-groupname-read-face-1)
;;; 	((and (= level 2) (= unread 0)). my-gnus-group-line-groupname-read-face-2)
;;; 	((and (= level 3) (= unread 0)). my-gnus-group-line-groupname-read-face-3)
;;; 	((and (= level 4) (= unread 0)). my-gnus-group-line-groupname-read-face-4)
;;; 	;; ... if the group has unread articles, depending on the level too
;;; 	((and (= level 1) (> unread 0)). my-gnus-group-line-groupname-unread-face-1)
;;; 	((and (= level 2) (> unread 0)). my-gnus-group-line-groupname-unread-face-2)
;;; 	((and (= level 3) (> unread 0)). my-gnus-group-line-groupname-unread-face-3)
;;; 	((and (= level 4) (> unread 0)). my-gnus-group-line-groupname-unread-face-4)
;;; 	;; If the group doesn't match the rules above
;;; 	(t . my-gnus-group-line-groupname-face)))
; Header-line
(if (require 'hl-line)
    (progn
      (set-face-background 'hl-line "yellow4")
      (add-hook 'gnus-group-mode-hook
		(lambda ()
		  (hl-line-mode)))
      (add-hook 'gnus-summary-mode-hook
		(lambda ()
		  (hl-line-mode)))
))

(add-hook 'gnus-group-mode-hook
	  (lambda ()
	    (setq header-line-format "    Ticked    New     Unread   Group" )))

;; change les citations.
;(add-hook 'gnus-part-display-hook 'sk-change-cite-mark)
(require 'message)      ; for message-cite-prefix-regexp

;;(defun gnus-check-reasonable-setup ()
;;  )

(defun sk-change-cite-mark ()
  "Change la marque de citation."
  (interactive)
  (save-excursion
    (let ((inhibit-point-motion-hooks t)
	  buffer-read-only)
      (article-goto-body)
      (while (re-search-forward (concat "^"  message-cite-prefix-regexp) nil t)
	(replace-match (make-string (length (match-string 0)) 124)))
      (message ""))))


;; gestion des dictionnaires
;;-----------essai 1 avec fonctions ispell----------------------------------------
;;teste les regexps sur les entêtes du message
;; (setq ispell-message-dictionary-alist '(
;;                                                                              ("^Newsgroups:[ \t]*fr\\." . "francais")
;;                                                                              ("^Newsgroups:[ \t]*gnu\\." . "american")
;;                                                                              (".*" . "francais") ;;défaut
;;                                                                              ))
;; (add-hook 'gnus-message-setup-hook 'ispell-message)
;;-----------essai 2 code zedek----------------------------------------------------
;; ;; code de Xavier Maillard <zedek at gno-rox dot org>
;; (gnus-define-group-parameter
;;  dictionary
;;  :function-document
;;  "Return the dictionary used for the current group (if any)."
;;  :variable-document
;;  "Alist of regexps (to match group names) and default dictionary to use when composing a new message."
;;  :parameter-type '(string :tag "dictionary")
;;  :parameter-document "\
;; The default dictionary to use in the group.")

;; ;;; FIXME: optimize
;; (defun gnus-setup-dictionary (group)
;;   "Decide which dictionary to use for group `group`."
;;   (let ((group (or group ""))
;;         dictionary)

;;     (setq dictionary (gnus-parameter-dictionary group))
;;     (message "Dictionary used: %s in group %s" dictionary group)

;;     (when dictionary
;;       (set (make-local-variable 'ispell-local-dictionary) dictionary))
;;     ))

;; (add-hook 'gnus-message-setup-hook ;gnus-select-group-hook
;;           (lambda ()
;;             (gnus-setup-dictionary
;;              (if (boundp 'gnus-newsgroup-name)
;;                  gnus-newsgroup-name ""))
;;             (sit-for 1)))

;; ;;; EXEMPLES D UTILISATION:
;; ;; (setq gnus-parameters
;; ;;       '((""
;; ;;          (dictionary . "francais"))
;; ;;         ("list.debian-user-french"
;; ;;          (dictionary . "francais"))))

;; (setq gnus-parameter-dictionary-alist
;;       '(
;;         ("\\(^fr\\|french\\|france\\).*" . "francais")
;;         (".*" . "american")))

;; ;;(Gnus-setup-dictionary "list.debian-user-french")
;;--------------essai 3 ---- alexandre de fcae--------------
;nécessite de paramétrer les posting styles
;; (defadvice gnus-group-mail (around prompt-for-group activate)
;;   "Always prompt for a group from which to take posting-styles."
;;   (ad-set-arg 0 t)
;;   ad-do-it)
;; (defadvice gnus-summary-mail-other-window (around prompt-for-group activate)
;;   "Always prompt for a group from which to take posting-styles."
;;   (ad-set-arg 0 1)
;;   ad-do-it)
;; (defadvice gnus-summary-news-other-window (around prompt-for-group activate)
;;   "Always prompt for a group to post."
;;   (ad-set-arg 0 t)
;;   ad-do-it)
;; ;; (defadvice gnus-summary-followup (around prompt-for-group activate)
;;   "Always prompt for a group from which to take posting-styles."
;;   (let ((gnus-newsgroup-name (completing-read "Use group: " gnus-active-hashtb nil nil))
;;              )
;;     ad-do-it))

;;----------------------------------------------------------


;;modification de message-expand-name pour chercher dans eudc si défini
;;puis dans bbdb
(setq message-expand-name-databases '(eudc bbdb));'(eudc bbdb))
;; (defun message-expand-name ()
;;   (let ((res nil) (dbs message-expand-name-databases))
;;      (while (and dbs (null res))
;;        (let ((db (first dbs)))
;;              (when (and (equal db 'eudc)
;;                                 (boundp 'eudc-protocol))
;;                (setq res (eudc-expand-inline)))
;;              (when (and (equal db 'bbdb)
;;                                 (fboundp 'bbdb-complete-name))
;;                (setq res (bbdb-complete-name))))
;;        (setq dbs (cdr dbs)))
;;      (or res (expand-abbrev))))


;; Invocation du Démon pour màj périodique des nouveaux messages
(require 'gnus-demon)

(setq level 2)

(defun sk-demon-notify-message ()
  (if (> number-of-unread last-time-number-of-unread)
      (progn
	(if (> number-of-unread 0)
	    (beep))
	(message (let ((number-of-new (- number-of-unread last-time-number-of-unread)))
		   (concat
		    "***** "
		    (int-to-string number-of-new)
		    " new mail"
		    (if (> number-of-new 1)
			"s" "")
		    " received *****"
		    (if (> number-of-unread last-time-number-of-unread)
			(concat " ("
				(int-to-string (- number-of-unread number-of-new))
				" old)"))
		    )
		   )
		 )
	)
    (if (= number-of-unread 0)
	(message "No mail")
      (message
       (concat
	(int-to-string number-of-unread)
	" old unread mail"
	(if (> number-of-unread 1)
	    "s" "")
	))
      )
    )
  )

(defun sk-gnus-demon-handler ()
  (message "Checking new mail ...")
  (save-window-excursion
    (save-excursion
      (when (gnus-alive-p)
	(set-buffer gnus-group-buffer)
	(gnus-group-get-new-news level))))
  (setq last-time-number-of-unread number-of-unread)
  (setq number-of-unread (gnus-group-number-of-unread-mail level))
  (sk-demon-notify-message)
  )

(setq gnus-demon-timestep 10)

(gnus-demon-add-handler 'sk-gnus-demon-handler 30 30)
(gnus-demon-add-handler 'gnus-group-get-new-news 30 30)
;(gnus-demon-add-handler 'gnus-demon-scan-news 5 10)
(gnus-demon-init)

;;fermeture auto de la fenêtre de composition
(message-add-action 'delete-frame 'exit 'postpone 'kill)

;; Anti spam ==================
(require 'spam) ;;???
(spam-initialize)

;; Processsor for splitting incoming mail
;(setq spam-use-bogofilter t)

;; Where to put incoming mail
(setq spam-split-group "nnfolder:spam")

;; méthodes de détection
(setq gnus-spam-autodetect-methods
      '(
	(".*" . (spam-use-blacklist
		 ;;spam-use-BBDB
		 ;;spam-use-bogofilter
		 spam-use-gmane-xref))
	))
(setq gnus-spam-autodetect '(("^nntp\\+news\\.cuq\\.org:[^f].*" . t))) ;ou t ?

;; Declare spam and ham groups.
(setq spam-junk-mailgroups nil)
(setq gnus-spam-newsgroup-contents
      '(("^nnfolder:spam" gnus-group-spam-classification-spam)
	("^nntp.*" gnus-group-spam-classification-ham)))

;; Train spam detection tools.
(setq spam-process-ham-in-spam-groups t)
(setq gnus-spam-process-newsgroups
      '(
	("^nntp\\+news\\.gmane\\.org:"
	 ((spam spam-use-gmane)
	  ;;(spam spam-use-bogofilter)
	  ))
	("^nntp\\+news\\.cuq\\.org:"
	 (
	  ;;(spam spam-use-bogofilter)
	  ;;(ham spam-use-bogofilter)
	  ))
	;;("^nnfolder:.*"
	;; ((spam spam-use-bogofilter)
	;;  (ham spam-use-bogofilter)))))
	))
;; Move processed spam.
(setq spam-move-spam-nonspam-groups-only t)
(setq spam-mark-only-unseen-as-spam t)
(setq gnus-spam-process-destinations
      '(
	("^nntp\\+news\\.gmane\\.org:" "nnfolder:spam")
	("^nntp\\+news\\.cuq\\.org:" "nnfolder:spam")
	;;("^nnfolder:.*" "nnfolder:spam")
	))

;; Move processed ham.
(setq spam-mark-ham-unread-before-move-from-spam-group t)
(setq gnus-ham-process-destinations
      '(("^nnfolder:spam" "nnfolder:reclassify")))


;;(setq gnus-install-group-spam-parameters nil) ;; ..
;(setq spam-use-gmane-xref t)
;;(setq spam-report-gmane-use-article-number nil) ;; Don't abuse on spam report
;;(setq spam-mark-only-unseen-as-spam nil)
;;(setq spam-report-url-ping-function 'spam-report-url-ping-plain) ;;'spam-report-url-to-file)
;; Here I define general anti-spam things
;; it only say that on exiting all groups matching nnml:private.*,
;; we launch the spam processor and ham processor (using bogofilter)
;;(setq ;;gnus-spam-process-newsgroups
          ;;'(;;("nnml:.*" (gnus-group-spam-exit-processor-bogofilter ;; définitions à voir
                ;;                      gnus-group-ham-exit-processor-bogofilter))
        ;;      )

          ;;gnus-spam-autodetect-methods '((".*" . (spam-use-blacklist
                                                                                          ;;spam-use-BBDB
                ;;                                                                        spam-use-bogofilter
                ;;                                                                        spam-use-gmane-xref)));default
          ;;gnus-spam-autodetect t;'(("nntp.*" . t))
          ;;spam-use-stat t

          ;; All messages marked as spam in these groups should go to spambox
          ;;gnus-spam-process-destinations '(("nnml:.*" "nnml:spambox"))
          ;; and ham found into the spambox should be moved to reclassify group
          ;;gnus-ham-process-destinations '(("nnml:spambox" "nnml:reclassify"))
          ;;spam-junk-mailgroups '("nnml:spambox")
          ;;spam-split-group "nnml:spambox")

(setq gnus-parameters
      '(("^gmane\\..*"                  ;"^nntp\\+.*:gmane\\..*"
	 (spam-autodetect-methods spam-use-gmane-xref spam-use-BBDB)
	 (spam-autodetect . t)
	 (spam-process '(spam spame-use-gmane))
	 (gnus-agent-consider-all-articles . t)
	 (gnus-agent-enable-expiration . (quote (DISABLE)))
	 (spam-contents gnus-group-spam-classification-ham)
	 (agent-predicate . true) ;; and (not spam) (not old))
	 )
	)
      )
;;paramátres Ted Zlatanov
;;((spam-autodetect-methods spam-use-blacklist spam-use-BBDB spam-use-bogofilter
;;spam-use-gmane-xref)
;; (spam-autodetect t)
;; (spam-process-destination . "nnimap+lifelogs.com:INBOX.train"))

;;probláme du font-lock de message
;; (setq gnus-emphasis-alist '(("\\(\\s-\\|^\\|\\=\\|[-\"]\\|\\s(\\)\\(\\*\\(\\w+\\(\\s-+\\w+\\)*[.,]?\\)\\*\\)\\(\\([-,.;:!?\"]\\|\\s)\\)+\\s-\\|[?!.]\\s-\\|\\s)\\|\\s-\\)" 2 3 gnus-emphasis-bold)
;;  ("\\(\\s-\\|^\\|\\=\\|[-\"]\\|\\s(\\)\\(_\\(\\w+\\(\\s-+\\w+\\)*[.,]?\\)_\\)\\(\\([-,.;:!?\"]\\|\\s)\\)+\\s-\\|[?!.]\\s-\\|\\s)\\|\\s-\\)" 2 3 gnus-emphasis-underline)
;;  ("\\(\\s-\\|^\\|\\=\\|[-\"]\\|\\s(\\)\\(/\\(\\w+\\(\\s-+\\w+\\)*[.,]?\\)/\\)\\(\\([-,.;:!?\"]\\|\\s)\\)+\\s-\\|[?!.]\\s-\\|\\s)\\|\\s-\\)" 2 3 gnus-emphasis-italic)
;;  ("\\(\\s-\\|^\\|\\=\\|[-\"]\\|\\s(\\)\\(_/\\(\\w+\\(\\s-+\\w+\\)*[.,]?\\)/_\\)\\(\\([-,.;:!?\"]\\|\\s)\\)+\\s-\\|[?!.]\\s-\\|\\s)\\|\\s-\\)" 2 3 gnus-emphasis-underline-italic)
;;  ("\\(\\s-\\|^\\|\\=\\|[-\"]\\|\\s(\\)\\(_\\*\\(\\w+\\(\\s-+\\w+\\)*[.,]?\\)\\*_\\)\\(\\([-,.;:!?\"]\\|\\s)\\)+\\s-\\|[?!.]\\s-\\|\\s)\\|\\s-\\)" 2 3 gnus-emphasis-underline-bold)
;;  ("\\(\\s-\\|^\\|\\=\\|[-\"]\\|\\s(\\)\\(\\*/\\(\\w+\\(\\s-+\\w+\\)*[.,]?\\)/\\*\\)\\(\\([-,.;:!?\"]\\|\\s)\\)+\\s-\\|[?!.]\\s-\\|\\s)\\|\\s-\\)" 2 3 gnus-emphasis-bold-italic)
;;  ("\\(\\s-\\|^\\|\\=\\|[-\"]\\|\\s(\\)\\(_\\*/\\(\\w+\\(\\s-+\\w+\\)*[.,]?\\)/\\*_\\)\\(\\([-,.;:!?\"]\\|\\s)\\)+\\s-\\|[?!.]\\s-\\|\\s)\\|\\s-\\)" 2 3 gnus-emphasis-underline-bold-italic)
;;  ("\\(\\s-\\|^\\)\\(-\\(\\(\\w\\|-[^-]\\)+\\)-\\)\\(\\s-\\|[?!.,;]\\)" 2 3 gnus-emphasis-strikethru)
;;  ("\\(\\s-\\|^\\)\\(_\\(\\(\\w\\|_[^_]\\)+\\)_\\)\\(\\s-\\|[?!.,;]\\)" 2 3 gnus-emphasis-underline)))


;;;========== configuration GPG / PGG ==============================
;;**EC 2005-08-16 21:13 - PGG auto sign or encrypt !
(setq pgg-cache-passphrase t
      pgg-passphrase-cache-expiry 1800
      pgg-default-user-id "xaiki@cxhome.ath.cx" ;;<<<<----- là tu dois mettre _ton_ ID
      pgg-encrypt-for-me nil
      ;;pgg-gpg-program "/opt/local/bin/gpg" ;; vérifie que c'est juste !
      pgg-query-keyserver t)

(autoload 'pgg-encrypt-region "pgg" "Encrypt the current region." t)
(autoload 'pgg-decrypt-region "pgg" "Decrypt the current region." t)
(autoload 'pgg-sign-region    "pgg" "Sign the current region."    t)
(autoload 'pgg-verify-region  "pgg" "Verify the current region."  t)
(autoload 'pgg-insert-key     "pgg"  "Insert the ASCII armored public key." t)
(autoload 'pgg-snarf-keys-region "pgg" "Import public keys in the current region." t)

;; Tells Gnus to inline the part
(eval-after-load "mm-decode"
  '(add-to-list 'mm-inlined-types "application/pgp$"))
;; Tells Gnus how to display the part when it is requested
(eval-after-load "mm-decode"
  '(add-to-list 'mm-inline-media-tests '("application/pgp$"
					 mm-inline-text identity)))
;; Tell Gnus not to wait for a request, just display the thing
;; straight away.
(eval-after-load "mm-decode"
  '(add-to-list 'mm-automatic-display "application/pgp$"))
;; But don't display the signatures, please.
(eval-after-load "mm-decode"
  (quote (setq mm-automatic-display (remove "application/pgp-signature"
					    mm-automatic-display))))

;; verify GnuPG signature on incoming mail
(setq mm-verify-option 'always)

;; decrypt mails on incoming mail
(setq mm-decrypt-option 'always)

;; add buttons
(setq gnus-buttonized-mime-types '("multipart/encrypted" "multipart/signed"))

;; Faire ensorte que tout les mails (pas news) soient encrypté si le
;; receveur à une clé publique
(defun sk-securise-messages ()
  (cond ((message-mail-p)
	 (let ((toheader (message-fetch-field "To")))
	   (let ((recipient (nth 1 (mail-extract-address-components toheader nil))))
	     (message recipient)
	     (cond ((and (not (null recipient))
			 (or
			  (pgg-lookup-key recipient)
			  (and
			   (pgg-fetch-key pgg-default-keyserver-address recipient)
			   (pgg-lookup-key recipient)) ;; we might have added some keys but not the right one !
			  )
			 )
		    (mml-secure-message-encrypt-pgpmime))
		   ;; Active ces 2 lignes si tu veux que tout tes mails soient signés !
		   ;; Cela permet au receveur de vérifier si le mail vient bien de toi et
		   ;; qu'il n'a pas été modifié ... Le mail n'est toutefois pas encrypté car
		   ;; ton interlocuteur n'a pas de clé publique connue
		   ;;(t
		   ;; (mml-secure-message-sign-pgpmime))
		   ))))
	;;((message-news-p)
	;; (mml-secure-message-sign-pgpmime))
	))
;; desactivé à cause du proxy (add-hook 'message-send-hook 'sk-securise-messages)
;;;========== configuration GPG / PGG ==============================
;; Index
(require 'nnmairix)

;; speed-up !
(gnus-compile)


;; Local Variables:
;; time-stamp-format: "%02d/%02m/%:y %02H:%02M %u@%s"
;; End:
