;;; oc-tools.el --- Character Database utility

;; Copyright (C) 1998 MORIOKA Tomohiko.

;; Author: MORIOKA Tomohiko <morioka@jaist.ac.jp>

;; This version: Otfried Cheong
;; (Modified to work with oc-unicode)

;; oc-tools.el is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; Unicode-char.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with XEmacs; see the file COPYING.  If not, write to the Free
;; Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA.

;;; Code:

(defvar unicode-data-path
  "/ftp@ftp.unicode.org:/Public/UNIDATA/UnicodeData-Latest.txt"
  "Unicode character database filename.")

(defun unicode-what (char)
  (interactive (list (char-after)))
  (let ((buf (get-buffer-create "*Character Description*"))
	(the-buf (current-buffer)))
    ;;(pop-to-buffer buf)
    (set-buffer buf)
    ;;(make-local-variable 'what-character-original-window-configuration)
    ;;(setq what-character-original-window-configuration win-conf)
    (setq buffer-read-only nil)
    (erase-buffer)
    (let (charset h l)
      (let ((sc (split-char char)))
	(setq charset (car sc)
	      h (nth 1 sc)
	      l (nth 2 sc)))
      (insert (format "%c\n%s (%s): "
		      char charset (charset-description charset)))
      (insert (if l
		  (format "#x%02X%02X, %02d-%02d\n"
			  h l (- h 32) (- l 32))
		(format "#x%02X, %d/%d\n"
			h (lsh h -4) (logand h 15))))
      ;; compute Unicode of character
      (let ((ucs (char-to-ucs char)))
	(when ucs
	  (insert (format "    UCS: %08X" ucs))
	  (if unicode-data-path
	      (let ((str
		     (with-current-buffer
			 (find-file-noselect unicode-data-path)
		       (goto-char (point-min))
		       (if (re-search-forward (format "^%04X;\\(.*\\)$" ucs) 
					      nil t)
			   (buffer-substring (match-beginning 1)
					     (match-end 1))))))
		(if str
		    (let ((data (split-string str ";")))
		      (insert (format " (%s)\n" (nth 0 data)))
		      (insert
		       (format "    General Category: %s\n"
			       (cdr
				(assoc
				 (nth 1 data)
				 '(;; Normative
				   ("Mn" . "Mark, Non-Spacing")
				   ("Mc" . "Mark, Spacing Combining")
				   ("Me" . "Mark, Enclosing")
				   ("Nd" . "Number, Decimal Digit")
				   ("Nl" . "Number, Letter")
				   ("No" . "Number, Other")
				   ("Zs" . "Separator, Space")
				   ("Zl" . "Separator, Line")
				   ("Zp" . "Separator, Paragraph")
				   ("Cc" . "Other, Control")
				   ("Cf" . "Other, Format")
				   ("Cs" . "Other, Surrogate")
				   ("Co" . "Other, Private Use")
				   ("Cn" . "Other, Not Assigned")
				   ;; Informative
				   ("Lu" . "Letter, Uppercase")
				   ("Ll" . "Letter, Lowercase")
				   ("Lt" . "Letter, Titlecase")
				   ("Lm" . "Letter, Modifier")
				   ("Lo" . "Letter, Other")
				     
				   ("Pc" . "Punctuation, Connector")
				   ("Pd" . "Punctuation, Dash")
				   ("Ps" . "Punctuation, Open")
				   ("Pe" . "Punctuation, Close")
				   ("Pi" .
				    "Punctuation, Initial quote (may behave like Ps or Pe depending on usage)")
				   ("Pf" . "Punctuation, Final quote (may behave like Ps or Pe depending on usage)")
				   ("Po" . "Punctuation, Other")
				   
				   ("Sm" . "Symbol, Math")
				   ("Sc" . "Symbol, Currency")
				   ("Sk" . "Symbol, Modifier")
				   ("So" . "Symbol, Other")
				   )))))
		      (or (string= (nth 2 data) "")
			  (insert
			   (format "    Canonical Combining Classes: %s\n"
				   (nth 2 data))))
		      (or (string= (nth 3 data) "")
			  (insert (format "    Bidirectional Category: %s\n"
					  (nth 3 data))))
		      (or (string= (nth 4 data) "")
			  (insert (format "    Character Decomposition: %s\n"
					  (nth 4 data))))
		      (or (string= (nth 5 data) "")
			  (insert (format "    Decimal digit value: %s\n"
					  (nth 5 data))))
		      (or (string= (nth 6 data) "")
			  (insert (format "    Digit value: %s\n"
					  (nth 6 data))))
		      (or (string= (nth 7 data) "")
			  (insert (format "    Numeric value: %s\n"
					  (nth 7 data))))
		      (or (string= (nth 8 data) "")
			  (insert (format "    Mirror-able: %s\n"
					  (nth 8 data))))
		      (or (string= (nth 9 data) "")
			  (insert (format "    Unicode 1.0 Name: %s\n"
					  (nth 9 data))))
		      (or (string= (nth 10 data) "")
			  (insert (format "    10646 Comment: %s\n"
					  (nth 10 data))))
		      (or (string= (nth 11 data) "")
			  (insert (format "    Uppercase = %s\n"
					  (nth 11 data))))
		      (or (string= (nth 12 data) "")
			  (insert (format "    Lowercase = %s\n"
					  (nth 12 data))))
		      (or (string= (nth 13 data) "")
			  (insert (format "    Title-case = %s\n"
					  (nth 13 data))))
		      )
		  (insert "\n"))
		)))))
    (set-buffer-modified-p nil)
    (view-buffer-other-window buf)
    ;;(view-mode-enter the-buf (lambda (buf)
    ;;(set-window-configuration
    ;;what-character-original-window-configuration)))
    (goto-char (point-min))))

(provide 'oc-tools)

;;; oc-tools.el ends here
