;;; debian-mr-copyright-mode.el --- major mode for machine-readable debian/copyright files

;; Copyright (C) 2001, 2003 Free Software Foundation, Inc.
;; Copyright (C) 2003, 2004, 2005 Peter S Galbraith <psg@debian.org>
;; Copyright (C) 2008 Vincent Fourmond

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; debian-mr-copyright-mode.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with your Debian installation, in /usr/share/common-licenses/GPL
;; If not, write to the Free Software Foundation, 675 Mass Ave,
;; Cambridge, MA 02139, USA.

;; This mode is really loosely based on debian-control-mode.el

;;; Code:

(require 'font-lock)

(defgroup debian-mr-copyright nil "Machine-readable debian copyright files"
  :group 'tools)

(defcustom debian-mr-copyright-field-face 'font-lock-keyword-face
  "The face to use to highligh fields names"
  :type 'face
  :group 'debian-mr-copyright)

(defcustom debian-mr-copyright-value-face 'font-lock-variable-name-face
  "The face to use to highlight fields values."
  :type 'face
  :group 'debian-mr-copyright)

(defcustom debian-mr-copyright-files-face 'font-lock-type-face
  "The face to use to highlight file globs."
  :type 'face
  :group 'debian-mr-copyright)

(defcustom debian-mr-copyright-invalid-face 'font-lock-warning-face
  "The face to use to highlight invalid licenses."
  :type 'face
  :group 'debian-mr-copyright)



(defvar debian-mr-copyright-syntax-table nil
  "Syntax table used in debian-mr-copyright-mode buffers.")

(if debian-mr-copyright-syntax-table
    ()
  (setq debian-mr-copyright-syntax-table (make-syntax-table))
  ;; Support # style comments
  (modify-syntax-entry ?#  "<"  debian-mr-copyright-syntax-table)
  (modify-syntax-entry ?\n "> " debian-mr-copyright-syntax-table))

(defvar debian-mr-copyright-field-regexp "^\\(\\(\\sw\\|-\\)+:\\)")

;; (defvar debian-mr-copyright-value-regexp 
;;   "[-a-zA-Z0-9+.*,[:blank:]]+")

;; Valid licenses, extracted from the web page
;; http://wiki.debian.org/Proposals/CopyrightFormat
;; 15/03/08
(defvar debian-mr-copyright-valid-licenses
  '("GPL-any" "GPL-1" "GPL-1+" "GPL-2" "GPL-2+" "GPL-3" "GPL-3+"
    "LGPL-any" "LGPL-2" "LGPL-2+" "LGPL-2.1" "LGPL-2.1+" "LGPL-3" "LGPL-3+"
    "PSF" "PSF-2" "GFDL-any" "GFDL-1.2" "GFDL-1.2+" "GAP" "BSD-2" "BSD-3" 
    "BSD-4" "Apache-1.0" "Apache-1.1" "Apache-2.0" "MPL-1.1" "Artistic"
    "Artistic-2.0" "LPPL-1.3a" "ZPL" "ZPL-2.1" "EPL-1.1" "EFL-2" 
    "CC-BY-3" "ZLIB" "other")
  )

(defvar debian-mr-copyright-value-regexp  ".+")

(defvar debian-mr-copyright-imenu-expression 
  '((nil (concat "^\\(Files\\):" 
		 debian-mr-copyright-value-regexp
		 "$") 2))
  "The expression for imenu elements" )

(defvar debian-mr-copyright-fields
  '("Copyright")
  "Valid fields names (but Files and License).")

(defvar debian-mr-copyright-fields-regexp
  (concat
   "^"
   (let ((max-specpdl-size 1000))
     (regexp-opt debian-mr-copyright-fields t))
   ":\\(" 
   debian-mr-copyright-value-regexp
   "\\)$" )
  "font-lock regexp matching known fields.")

(defvar debian-mr-copyright-license-regexp
  (concat
   "^\\(License\\):\\(?:[[:blank:]]*" 
   (let ((max-specpdl-size 1000))
     (regexp-opt debian-mr-copyright-valid-licenses t))
   "[[:blank:]]*\\|\\(.+\\)\\)$" )
  "font-lock regexp matching known or unkown licenses.")


(defvar debian-mr-copyright-files-regexp
  (concat 
   "^\\(Files\\):\\(" 
   debian-mr-copyright-value-regexp
   "\\)$" )
  "font-lock regexp matchin Files: fields.")

(defvar debian-mr-copyright-font-lock-keywords
  `(
    (,debian-mr-copyright-fields-regexp
     (1 debian-mr-copyright-field-face)
     (2 debian-mr-copyright-value-face))
    (,debian-mr-copyright-files-regexp
     (1 debian-mr-copyright-field-face)
     (2 debian-mr-copyright-files-face))
    (,debian-mr-copyright-license-regexp
     (1 debian-mr-copyright-field-face)
     (2 debian-mr-copyright-files-face nil t) ;Not to fail if missing
     (3 debian-mr-copyright-invalid-face)
     )
    )
  )


;;     (,debian-mr-copyright-license-regexp
;;      (1 debian-mr-copyright-field-face)
;;      (2 debian-mr-copyright-files-face))


(defvar debian-mr-copyright-mode-menu nil)

;;;###autoload

(define-derived-mode debian-mr-copyright-mode fundamental-mode "Debian Control"
  "A major mode for editing machine-readable Debian copyright files (i.e. debian/copyright)."
  (if (< emacs-major-version 21)
      (message "debian-mr-copyright-mode only supports emacsen version >= 21; disabling features")
    (progn
      (set-syntax-table debian-mr-copyright-syntax-table)
      ;; Comments
      (make-local-variable 'comment-start-skip)  ;Need this for font-lock...
      (setq comment-start-skip "\\(^\\|\\s-\\);?#+ *") ;;From perl-mode
      (make-local-variable 'comment-start)
      (make-local-variable 'comment-end)
      (setq comment-start "#"
            comment-end "")

      (make-local-variable 'font-lock-defaults)
      (setq font-lock-defaults 
            '(debian-mr-copyright-font-lock-keywords
              nil           ;;; Keywords only? No, let it do syntax via table.
              nil           ;;; case-fold?
              nil           ;;; Local syntax table.
              nil           ;;; Use `backward-paragraph' ? No
              ))
      )
    )
  )


(add-to-list 'auto-mode-alist '("/debian/copyright\\'" . 
				debian-mr-copyright-mode))

;;;###autoload(add-to-list 'auto-mode-alist '("/debian/control\\'" . debian-mr-copyright-mode))

(provide 'debian-mr-copyright-mode)

;;; debian-mr-copyright-mode.el ends here
