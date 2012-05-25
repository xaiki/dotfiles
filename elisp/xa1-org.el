(require 'org-mime)

(run-at-time "00:59" 3600 'org-save-all-org-buffers)
(add-to-list 'auto-mode-alist '("\\org\\'" . org-mode))
(setq org-directory "~/Documents/org/")
(setq org-mobile-inbox-for-pull "~/Documents/org/from-mobile.org")
(setq org-mobile-directory "~/Dropbox/MobileOrg")

(setq org-export-latex-classes nil)
(when (require 'org-latex nil t)
  (add-to-list 'org-export-latex-packages-alist '("" "listings"))
  (add-to-list 'org-export-latex-packages-alist '("" "color"))
  (setq org-export-latex-listings t))
(setq org-indent-mode nil)
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

(setq org-export-latex-classes '(("article"
     "\\documentclass[11pt]{article}"
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
    ("report"
     "\\documentclass[11pt]{report}"
     ("\\part{%s}" . "\\part*{%s}")
     ("\\chapter{%s}" . "\\chapter*{%s}")
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
    ("book"
     "\\documentclass[11pt]{book}"
     ("\\part{%s}" . "\\part*{%s}")
     ("\\chapter{%s}" . "\\chapter*{%s}")
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
    ("beamer"
     "\\documentclass{beamer}"
     org-beamer-sectioning
     )))

(add-to-list 'org-export-latex-classes
          '("article"
             "\\documentclass{scrartcl}"
             ("\\section{%s}" . "\\section*{%s}")
             ("\\subsection{%s}" . "\\subsection*{%s}")
             ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
             ("\\paragraph{%s}" . "\\paragraph*{%s}")
             ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


(add-to-list 'org-export-latex-classes
          '("koma-article"
             "\\documentclass{scrartcl}"
             ("\\section{%s}" . "\\section*{%s}")
             ("\\subsection{%s}" . "\\subsection*{%s}")
             ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
             ("\\paragraph{%s}" . "\\paragraph*{%s}")
             ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-export-latex-classes
          '("koma-report"
             "\\documentclass{scrreprt}"
	     ("\\chapter{%s}" . "\\chapter*{%s}")
             ("\\section{%s}" . "\\section*{%s}")
             ("\\subsection{%s}" . "\\subsection*{%s}")
             ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
             ("\\paragraph{%s}" . "\\paragraph*{%s}")))

(add-to-list 'org-export-latex-classes
          '("moderncv"
             "\\documentclass{moderncv}\\moderncvtheme[black]{classic}"
             ("\\section{%s}" . "\\section*{%s}")
             ("\\subsection{%s}" . "\\subsection*{%s}")
             ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
             ("\\paragraph{%s}" . "\\paragraph*{%s}")
             ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; (add-to-list 'org-export-latex-classes
;;   ;; beamer class, for presentations
;;   '("beamer"
;;      "\\documentclass[11pt]{beamer}\n
;;       \\mode<{{{beamermode}}}>\n
;;       \\usetheme{{{{beamertheme}}}}\n
;;       \\usecolortheme{{{{beamercolortheme}}}}\n
;;       \\beamertemplateballitem\n
;;       \\setbeameroption{show notes}
;;       \\usepackage[utf8]{inputenc}\n
;;       \\usepackage[T1]{fontenc}\n
;;       \\usepackage{hyperref}\n
;;       \\usepackage{color}
;;       \\usepackage{listings}
;;       \\lstset{numbers=none,language=[ISO]C++,tabsize=4,
;;   frame=single,
;;   basicstyle=\\small,
;;   showspaces=false,showstringspaces=false,
;;   showtabs=false,
;;   keywordstyle=\\color{blue}\\bfseries,
;;   commentstyle=\\color{red},
;;   }\n
;;       \\usepackage{verbatim}\n
;;       \\institute{{{{beamerinstitute}}}}\n
;;        \\subject{{{{beamersubject}}}}\n"

;;      ("\\section{%s}" . "\\section*{%s}")

;;      ("\\begin{frame}[fragile]\\frametitle{%s}"
;;        "\\end{frame}"
;;        "\\begin{frame}[fragile]\\frametitle{%s}"
;;        "\\end{frame}")))

(add-to-list 'org-export-latex-classes
  ;; beamer-covetel class, for presentations
  '("beamer-covetel"
     "\\input{preambulo.tex}\n"
     org-beamer-sectioning
     ))

(setq org-export-html-postamble-format '(
("en" "<p class=\"author\">Author: %a (%e)</p>\n<p class=\"date\">Date: %d</p>\n<p class=\"creator\">Generated by %c</p>\n<p class=\"xhtml-validation\">%v</p><p class=\"licence\">Licencia: <href a=\"http://creativecommons.org/licenses/by-sa/2.5/\">this work is released under the Creative Commons Attribution-ShareAlike 2.5 Generic (CC BY-SA 2.5) Licence\n</href></p>")
("es" "<p class=\"author\">Autor: %a (%e)</p>\n<p class=\"date\">Fecha: %d</p>\n<p class=\"creator\">Generado por %c</p>\n<p class=\"xhtml-validation\">%v</p><p class=\"licence\">Licencia: <href a=\"http://creativecommons.org/licenses/by-sa/2.5/ar\">este trabajo esta liberado bajo la Licencia Atribución-CompartirIgual 2.5 Argentina (CC BY-SA 2.5)\n</href></p>")))

(defun org-mode-reftex-setup ()
  (load-library "reftex")
  (and (buffer-file-name)
       (file-exists-p (buffer-file-name))
       (reftex-parse-all))
  (define-key org-mode-map (kbd "C-c )") 'reftex-citation)
  )
(add-hook 'org-mode-hook 'org-mode-reftex-setup)

(defun org-switch-language ()
  "Switch language for Org file, if a `#+LANGUAGE:' meta-tag is on top 14
lines."
  (save-excursion
    (goto-line 15)
    (if (re-search-backward "#\\+LANGUAGE: +\\([A-Za-z_]*\\)" 1 t)
	(ispell-change-dictionary (match-string 1)))))

(defun org-export-latex-format-image (path caption label attr &optional shortn)
  "Format the image element, depending on user settings."
  (let (ind floatp wrapp multicolumnp placement figenv)
    (setq floatp (or caption label))
    (setq ind (org-get-text-property-any 0 'original-indentation path))
    (when (and attr (stringp attr))
      (if (string-match "[ \t]*\\<wrap\\>" attr)
	  (setq wrapp t floatp nil attr (replace-match "" t t attr)))
      (if (string-match "[ \t]*\\<float\\>" attr)
	  (setq wrapp nil floatp t attr (replace-match "" t t attr)))
      (if (string-match "[ \t]*\\<multicolumn\\>" attr)
	  (setq multicolumnp t attr (replace-match "" t t attr))))

    (setq placement
	  (cond
	   (wrapp "{l}{0.5\\textwidth}")
	   (floatp (concat "[" org-latex-default-figure-position "]"))
	   (t "")))

    (when (and attr (stringp attr)
	       (string-match "[ \t]*\\<placement=\\(\\S-+\\)" attr))
      (setq placement (match-string 1 attr)
	    attr (replace-match "" t t attr)))
    (setq attr (and attr (org-trim attr)))
    (when (or (not attr) (= (length attr) 0))
      (setq attr (cond (floatp "width=0.7\\textwidth")
		       (wrapp "width=0.48\\textwidth")
		       (t attr))))
    (setq figenv
	  (cond
	   (wrapp "\\begin{wrapfigure}%placement
\\centering
\\includegraphics[%attr]{%path}
\\end{wrapfigure}")
	   (multicolumnp "\\begin{figure*}%placement
\\centering
\\includegraphics[%attr]{%path}
\\end{figure*}")
	   (floatp "\\begin{figure}%placement
\\centering
\\includegraphics[%attr]{%path}
\\end{figure}")
	   (t "\\includegraphics[%attr]{%path}")))


    (setq figenv (mapconcat 'identity (split-string figenv "\n")
			    (save-excursion (beginning-of-line 1)
					    (looking-at "[ \t]*")
					    (concat "\n" (match-string 0)))))

    (if (and (not label) (not caption)
	     (string-match "^\\\\caption{.*\n" figenv))
	(setq figenv (replace-match "" t t figenv)))

    (org-add-props
	(org-fill-template
	 figenv
	 (list (cons "path"
		     (if (file-name-absolute-p path)
			 (expand-file-name path)
		       path))
	       (cons "attr" attr)
	       (cons "shortn" (if shortn (format "[%s]" shortn) ""))
	       (cons "labelcmd" (if label (format "\\label{%s}"
						  label)""))
	       (cons "caption" (or caption ""))
	       (cons "placement" (or placement ""))))
	nil 'original-indentation ind)))

(require 'org-remember)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (dot . t)
         (ditaa . t)
         (R . t)
         (python . t)
         (ruby . t)
         (gnuplot . t)
         (clojure . t)
         (sh . t)
         (ledger . t)
         (org . t)
         (plantuml . t)
         (latex . t))))

(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-agenda-files (let ((result))
			 (dolist (word '("/TODO.org" "/WORK.org" "/PERSONAL.org" "/w.org" "/notes.org"))
			   (setq result (cons (concat org-directory word) result)))
			 result))
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

;; [[info:org#Breaking%20down%20tasks][info:org#Breaking down tasks]]
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
(setq org-hierarchical-todo-statistics nil)
(setq org-provide-todo-statistics t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d!)")
	(sequence "AI(a)" "|" "CLOSED(t!)")
	(seqence  "TEST(T)" "KO(k@/!)" "|" "OK(o!)")
	(sequence "|" "MEETING(m)")
	(sequence "|" "TOREAD(R)")
	(sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "FIXME(F)" "|" "FIXED(f!)")
	(sequence "|" "CANCELED(c!)")))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("MEETING" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("FIXME" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-remember-templates
      '(("Meeting" ?m "* MEETING %^{Meeting Date and Time}T%? %:subject\n:PROPERTIES:\n:LOCATION: %^{Location}\n:END:\n %i\n %a" (concat org-directory "/WORK.org") "Meetings")
	("Todo" ?t "* TODO %?\n  %i\n  %a" (concat org-directory "/TODO.org") "Tasks")
	("Journal" ?j "* %U %?\n\n  %i\n  %a" (concat org-directory "/JOURNAL.org"))
	("Idea" ?i "* %^{Title}\n  %i\n  %a" (concat org-directory "/JOURNAL.org") "New Ideas")))

(setq org-icalendar-store-UID t)
(setq org-clock-persist 'history)
(when (require 'org-clock nil t)
  (org-clock-persistence-insinuate))

(setq org-src-fontify-natively t)
(add-hook 'org-mode-hook 'org-switch-language); auto-select ispell dict
(add-hook 'org-mode-hook 'turn-on-font-lock)  ; org-mode buffers only
(add-hook 'org-mode-hook 'org-indent-mode)    ; org-mode buffers only
(add-hook 'mail-mode-hook 'turn-on-orgstruct++)
;;(add-hook 'mail-mode-hook 'turn-on-orgstruct)
(add-hook 'mail-mode-hook 'turn-on-orgtbl++)
(setq org-agenda-include-diary t)
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))

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
  (appt-activate 1))

(provide 'xa1-org)
