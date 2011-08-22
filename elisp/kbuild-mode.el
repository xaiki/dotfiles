(eval-when-compile
  (require 'cl))

(require 'regexp-opt)
(require 'faces)

(defgroup kbuild nil
  "Colorize Kernel Config (minimal)."
  :tag "KCo"
  :group 'help)

(defface kbuild-hl-face '((t (:bold t)))
  "*Font used by kbuild for highlighting first match."
  :group 'kbuild)

(defface kbuild-comment-face '((t (:foreground "red") (:bold nil)))
  "*Font used by kbuild for comments, after first match."
  :group 'kbuild)

;; match host >$ commands -i subarg --args `sub-commands` # comments
;; match host ># commands -i subarg --args `sub-commands` # comments
(setq kbuild-lock-keywords
      '(("\\(if\\|endif\\|source\\)" 0 font-lock-preprocessor-face keep)
	(" if " 0 font-lock-preprocessor-face keep)
	("if\\(.*\\)" 0 font-lock-preprocessor-face keep)
	("^\\(\s\\|\t\\)*\\(default\\)" 2 font-lock-keyword-face keep)
	("^\\s-*\\(bool\\|tristate\\|string\\|hex\\|int\\)" 1 font-lock-type-face keep)
	("^\\s-*\\(comment\\|prompt\\|help\\|depends on\\|select\\|option\\)" 1 font-lock-variable-name-face keep)
	("^\\(choice\\|endchoice\\|endmenu\\)" 0 font-lock-keyword-face keep)
	("^\\(menu\\|config\\|menuconfig\\) +" 0 font-lock-keyword-face keep)
	("^\\(menu\\|config\\|menuconfig\\) \\(.*\\)" 2 font-lock-function-name-face prepend)
	("\".*\"" 0 font-lock-string-face prepend)
	("#\\(.*\\)" 1 font-lock-comment-face prepend)
	))

(defun kbuild-turn-on ()
  "Turn on font-lock for kbuild-mode"
  (font-lock-add-keywords nil kbuild-lock-keywords))

(defun kbuild-turn-off ()
  "Turn off font-lock for kbuild-mode"
  (font-lock-remove-keywords nil '(,@kbuild-lock-keywords)))

;;;###autoload
(define-minor-mode kbuild-minor-mode
  "Minor Mode for Coloring shell scripts"
  :lighter " kbuild"
  (progn
    (if kbuild-minor-mode
	(kbuild-turn-on)
      (kbuild-turn-off)
      (font-lock-mode 1))))
;;;###autoload
(define-derived-mode kbuild-mode makefile-gmake-mode "Kbuild" "Major Mode for Coloring shell scripts"
  (kbuild-minor-mode))

(provide 'kbuild-mode)
