(eval-when-compile
  (require 'cl))

(require 'regexp-opt)
(require 'faces)

(defgroup sho nil
  "Colorize shell dumps (minimal)."
  :tag "SHo"
  :group 'help)

(defface sho-hl-face '((t (:bold t)))
  "*Font used by sho for highlighting first match."
  :group 'sho)

(defface sho-comment-face '((t (:foreground "red") (:bold nil)))
  "*Font used by sho for comments, after first match."
  :group 'sho)

(defun xa1-test (text)
  (progn
    (message text)
    (put-text-property
     (match-beginning 0) (match-end 0)
     'face '((:bold t))))
  )

;; match host >$ commands -i subarg --args `sub-commands` # comments
;; match host ># commands -i subarg --args `sub-commands` # comments
(defvar sho-lock-keywords nil)
(setq sho-lock-keywords
      '(("[\'\"].*[\'\"]" 0 font-lock-string-face keep)
	("\\( -?-[^ ]+\\)" 1 font-lock-variable-name-face)
	("\\$\\([^ ]*\\)" 1 font-lock-constant-face)
	(">?[\\$\\|#] *\\([^ ]*\\)" 1 font-lock-function-name-face keep)
	("sudo" 0 font-lock-comment-face prepend)
	("(gdb)\\(.*\\)" 1 font-lock-function-name-face keep)
	("(gdb)" 0 font-lock-warning-face prepend)
	("\\(.*>[\\$\\|#]\\||\\|>\\)" 1 font-lock-warning-face prepend)
	(">#" 0 font-lock-comment-delimiter-face prepend)
	(">\\$" 0 font-lock-type-face prepend)
	("×" 0 font-lock-type-face prepend)
	("\\[…\\]" 0 font-lock-type-face prepend)
	(">[\\$\\|#].*\\(#.*\\)" 1 font-lock-doc-face prepend)
	(">[\\$\\|#].*\\(`.*`\\)" 1 font-lock-type-face prepend)
	))

(defun sho-turn-on ()
  "Turn on font-lock for sho-mode"
  (font-lock-add-keywords nil sho-lock-keywords))

(defun sho-turn-off ()
  "Turn off font-lock for sho-mode"
  (font-lock-remove-keywords nil '(,@sho-lock-keywords)))

;;;###autoload
(define-minor-mode sho-minor-mode
  "Minor Mode for Coloring shell scripts"
  :lighter " sho"
  (progn
    (if sho-minor-mode
	(sho-turn-on)
      (sho-turn-off)
      (font-lock-mode 1))))
;;;###autoload
(define-derived-mode sho-mode fundamental-mode "SHo" "Major Mode for Coloring shell scripts"
  (sho-minor-mode))

(provide 'sho-mode)
