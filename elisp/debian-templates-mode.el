;;; debian-templates-mode.el --- major mode for Debian/Debconf templates files

;; ripped from the debian-control-mode.el
;; Copyright (C) 2001, 2003 Free Software Foundation, Inc.
;; Copyright (C) 2003, 2004 Peter S Galbraith <psg@debian.org>

;; Author: Colin Walters <walters@debian.org>
;; Maintainer: Peter S Galbraith <psg@debian.org>
;; Created: 29 Nov 2001
;; Version: 0.8
;; X-RCS: $Id: debian-control-mode.el,v 1.7 2005/02/08 02:45:13 psg Exp $
;; Keywords: convenience

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; debian-control-mode.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with your Debian installation, in /usr/share/common-licenses/GPL
;; If not, write to the Free Software Foundation, 675 Mass Ave,
;; Cambridge, MA 02139, USA.

;;; Commentary:

;; debian-templates-mode.el is developed under Emacs 21, and is targeted
;; for use in Emacs 21 and relatively recent versions of XEmacs.

;;; Change Log:

;; rev 0: font-lock only

;;; Bugs:

;; Filling doesn't work on XEmacs.  I have no idea why.
;; Mouse stuff doesn't work on XEmacs.
;; Emacs 20 isn't supported.

;;; Code:

(require 'easymenu)
(require 'font-lock)
(eval-when-compile
  (require 'cl))

;; XEmacs compatibility
(eval-and-compile
  (unless (fboundp 'line-beginning-position)
    (defun line-beginning-position ()
      (save-excursion
	(beginning-of-line)z 
	(point))))
  (unless (fboundp 'line-end-position)
    (defun line-end-position ()
      (save-excursion
	(end-of-line)
	(point))))
  (unless (fboundp 'match-string-no-properties)
    (defalias 'match-string-no-properties 'match-string)))

(defgroup debian-templates nil "Debian/Debconf Templates file maintenance"
  :group 'tools)

(defcustom debian-templates-package-name-face 'font-lock-type-face
  "The face to use for highlighting package name."
  :type 'face
  :group 'debian-templates)

(defcustom debian-templates-option-face 'font-lock-variable-name-face
  "The face to use for highlighting option."
  :type 'face
  :group 'debian-templates)

;; FIXME: As of policy 3.5.6.0, the allowed characters in a field name
;; are not specified.  So we just go with "word constituent" or '-'
;; characters before a colon.
(defvar debian-templates-field-regexp "^\\(\\(\\sw\\|-\\)+:\\)")
(defvar debian-templates-package-name-regexp "\\(([-a-zA-Z0-9+.]*)+?\\)")

(defvar debian-templates-mode-package-name-keymap (make-sparse-keymap))

(defvar debian-templates-fields
  '("Template" "Type" "Default" "Description" "Choices")
  "Valid templates field, collected from tutorial.")

(defvar debian-templates-data-types
  '("string" "boolean" "select" "multiselect" "note" "text" "password")
  "Valid data-types, collected from tutorial.")

(defvar debian-templates-fields-regexp
  (concat
   "^\\("
   (let ((max-specpdl-size 1000))
     (regexp-opt debian-templates-fields t))
   "\\):")
  "font-lock regexp matching known fields in templates.")

(defvar debian-templates-data-types-regexp
  (concat
   "^Type: \\("
   (let ((max-specpdl-size 1000))
     (regexp-opt debian-templates-data-types t))
   "\\)")
  "font-lock regexp matching known data-types in templates.")

(defvar debian-templates-font-lock-keywords
  `((,(concat "^Template: \\("
	      debian-templates-package-name-regexp
	      "\\)")
     (1 font-lock-keyword-face)
     ,(list 2
	    (if (featurep 'xemacs)
		'(symbol-value debian-templates-package-name-face)
	      '(list 'face debian-templates-package-name-face))
	   nil nil))
    (,debian-templates-fields-regexp
     (1 font-lock-keyword-face))
    (,debian-templates-data-types-regexp
     (1 font-lock-function-name-face))))

(defvar debian-templates-mode-menu nil)

;;;###autoload
(define-derived-mode debian-templates-mode fundamental-mode "Debian Templates"
  "A major mode for editing Debian/Debconf Templates files (i.e. debian/*.templates)."
  (if (< emacs-major-version 21)
      (message "debian-templates-mode only supports emacsen version >= 21; disabling features")
    (progn
      (set (make-local-variable 'font-lock-defaults)
	   '((debian-templates-font-lock-keywords) t))
      (set (make-local-variable 'fill-paragraph-function)
	   #'debian-templates-mode-fill-paragraph)
      (make-local-variable 'after-change-functions)
      (push 'debian-templates-mode-after-change-function after-change-functions)
      (set (make-local-variable 'imenu-generic-expression)
        '((nil "^\\(Package\\|Source\\):\\s-*\\([-a-zA-Z0-9+.]+?\\)\\s-*$" 2)))

      (define-key debian-templates-mode-map (kbd "C-c C-b") 'debian-control-view-package-bugs)
      (define-key debian-templates-mode-map (kbd "C-c C-p") 'debian-control-visit-policy)
      (define-key debian-templates-mode-map (kbd "C-c C-a") 'debian-control-mode-add-field)
      (define-key debian-templates-mode-package-name-keymap (if (featurep 'xemacs)
							      [(control down-mouse-2)]
							    [(C-mouse-2)])
	'debian-templates-mode-bugs-mouse-click)
      (easy-menu-add debian-templates-mode-menu)
      (if (and (featurep 'goto-addr) goto-address-highlight-p)
        (goto-address))
      (let ((after-change-functions nil))
	(debian-templates-mode-after-change-function (point-min) (point-max) 0)))))

(defun debian-templates-mode-after-change-function (beg end len)
  (save-excursion
    (let ((modified (buffer-modified-p))
	  (buffer-read-only nil)
          (data (match-data)))
      (unwind-protect
	  (progn
	    (goto-char beg)
	    (beginning-of-line)
	    (while (< (point) end)
	      (cond ((looking-at (concat "^\\(Source:\\)\\s-*"
					 debian-templates-package-name-regexp
					 "\\s-*$"))
		     (add-text-properties
		      (match-beginning 2) (match-end 2)
		      `(mouse-face
			highlight
			debian-templates-mode-package ,(match-string 2)
			help-echo "C-mouse-2: View bugs for this source package"
			keymap ,debian-templates-mode-package-name-keymap)))
		    ((looking-at (concat "^\\(Package:\\)\\s-*"
					 debian-templates-package-name-regexp
					 "\\s-*$"))
		     (add-text-properties
		      (match-beginning 2) (match-end 2)
		      `(mouse-face
			highlight
			debian-control-mode-package ,(match-string 2)
			help-echo "C-mouse-2: View bugs for this binary package"
			keymap ,debian-templates-mode-package-name-keymap)))
		    (t nil))
	      (forward-line 1)))
	 (set-match-data data)
         (set-buffer-modified-p modified)))))

(easy-menu-define
 debian-templates-mode-menu debian-templates-mode-map "Debian Templates Mode Menu"
 '("Templates"
   ["Add field at point" debian-templates-mode-add-field t]
   "--"
   "Policy"
    ["View upgrading-checklist" (debian-templates-visit-policy 'checklist)
     (file-exists-p "/usr/share/doc/debian-policy/upgrading-checklist.txt.gz")]
    ["View policy (text)" (debian-templates-visit-policy 'text)
     (file-exists-p "/usr/share/doc/debian-policy/policy.txt.gz")]
    ["View policy (HTML)" (debian-templates-visit-policy 'html) t]
   "--"
   "Access www.debian.org"
   ["Bugs for package" debian-templates-view-package-bugs t]
   ["Specific bug number" (debian-changelog-web-bug) nil]
;;   ["Package list (all archives)" (debian-changelog-web-packages) t]
;;  ("Package web pages..."
;;   ["stable" (debian-changelog-web-package "stable") t]
;;   ["testing" (debian-changelog-web-package "testing") t]
;;   ["unstable" (debian-changelog-web-package "unstable") t])
   "--"
   ["Customize" (customize-group "debian-templates") t]))

(defun debian-templates-mode-fill-paragraph (&rest args)
  (let (beg end)
    (save-excursion
      ;; Are we looking at a field?
      (if (save-excursion
	    (beginning-of-line)
	    (looking-at debian-templates-field-regexp))
	  (setq beg (match-end 0)
		end (line-end-position))
	;; Otherwise, we're looking at a description; handle filling
	;; areas separated with "."  specially
    (setq beg (save-excursion
                 (beginning-of-line)
                 (while (not (or (bobp)
                                 (looking-at "^\\sw-*$")
                                 (looking-at "^ \\.")
                                 (looking-at debian-templates-field-regexp)))
                   (forward-line -1))
                 (unless (eobp)
                   (forward-line 1))
                 (point))
          end (save-excursion
                 (beginning-of-line)
                 (while (not (or (eobp)
                                 (looking-at "^\\sw-*$")
                                 (looking-at debian-templates-field-regexp)
                                 (looking-at "^ \\.")))
                   (forward-line 1))
                 (unless (bobp)
                   (forward-line -1)
		   (end-of-line))
                 (point))))
      (let ((fill-prefix " "))
	(apply #'fill-region beg end args)))))

(defun debian-templates-mode-add-field (binary field)
  "Add a field FIELD to the current package; BINARY means a binary package."
  (interactive
   (let* ((binary-p (if (or (save-excursion
			      (beginning-of-line)
			      (looking-at "^\\(Package\\|Source\\)"))
			    (re-search-backward "^\\(Package\\|Source\\)" nil t))
			(not (not (string-match "Package" (match-string 0))))
		      (error "Couldn't find Package or Source field")))
	  (fields (if binary-p
		      debian-templates-binary-fields
		    debian-templates-fields)))
     (list
      binary-p
      (capitalize
       (completing-read (format "Add %s package field: " (if binary-p "binary" "source"))
			(mapcar #'(lambda (x) (cons x nil)) fields))))))
  (require 'cl)
  (let ((fields (if binary
		    debian-templates-binary-fields
		  debian-templates-fields))
	(beg (save-excursion
	       (beginning-of-line)
	       (while (not (or (bobp)
			       (looking-at "^\\s-*$")))
		 (forward-line -1))
	       (forward-line 1)
	       (point)))
	(end (save-excursion
	       (beginning-of-line)
	       (while (not (or (eobp)
			       (looking-at "^\\s-*$")))
		 (forward-line 1))
	       (point))))
    (save-restriction
      (narrow-to-region beg end)
      (let ((curfields (let ((result nil))
			 (goto-char (point-min))
			 (while (not (eobp))
			   (when (looking-at debian-templates-field-regexp)
			     (push (cons (subseq
					  ;; Text properties are evil
					  (match-string-no-properties 1)
					  0
					  ;; Strip off the ':'
					  (- (match-end 1)
					     (match-beginning 1)
					     1))
					 (match-beginning 0))
				   result))
			   (forward-line 1))
			 result))
	    (x nil))
	;; If the field is already present, just jump to it
	(if (setq x (assoc field curfields))
	    (goto-char (cdr x))
	  (let* ((pos (position field fields :test #'string-equal))
		 (prevfields (subseq fields 0 pos))
		 (nextfields (subseq fields (1+ pos)))
		 (cur nil))
	    (while (or prevfields
		       nextfields)
	      (when prevfields
		(when (setq x (assoc (pop prevfields) curfields))
		  (setq prevfields nil nextfields nil)
		  (goto-char (cdr x))))
	      (when nextfields
		(when (setq x (assoc (pop nextfields) curfields))
		  (setq prevfields nil nextfields nil)
		  (goto-char (cdr x)))))
	    ;; Hack: we don't want to add fields after Description
	    (beginning-of-line)
	    (when (looking-at "^Description")
	      (forward-line -1))
	    (end-of-line)
	    (insert "\n" field ": ")))))))

(defun debian-templates-visit-policy (format)
  "Visit the Debian Policy manual in format FORMAT.
Currently valid FORMATs are `html', `text' and `checklist'.
The last one is not strictly a format, but visits the upgrading-checklist.txt
text file."
  (interactive
   (list (intern
	  (completing-read "Policy format: "
                           (mapcar #'(lambda (x) (cons x 0))
                                   '("html" "text" "checklist"))
			   nil t))))
  (case format
    (text
     (debian-templates-find-file "/usr/share/doc/debian-policy/policy.txt.gz"))
    (checklist
     (debian-templates-find-file
      "/usr/share/doc/debian-policy/upgrading-checklist.txt.gz"))
    (html
     (require 'browse-url)
     (browse-url
      (if (file-exists-p "/usr/share/doc/debian-policy/policy.html/index.html")
	  "file:///usr/share/doc/debian-policy/policy.html/index.html"
	(prog1
	    "http://www.debian.org/doc/debian-policy"
	  (message "Note: package `debian-policy' not installed, using web version")))))
    (t
     (error "Unknown format %s for policy" format))))

(defun debian-templates-find-file (file)
  "Find-file a possibly compressed FILE"
  (require 'jka-compr)
  (let ((installed (jka-compr-installed-p)))
    (if (not installed)
        (auto-compression-mode t))
    (find-file file)
    (if (not installed)
        (auto-compression-mode -1))))

(defun debian-templates-mode-bugs-mouse-click (event)
  "Display the bugs for the package name clicked on."
  (interactive "e")
  (mouse-set-point event)
  (let ((prop (get-text-property (point) 'debian-templates-mode-package)))
    (unless prop
      (error "Couldn't determine package name at point"))
    (debian-templates-view-package-bugs prop)))

(defun debian-templates-mode-bug-package-names ()
  (let ((result nil))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
	(when (looking-at "^\\(Package\\|Source\\):\\s-*\\([-a-zA-Z0-9+.]+?\\)\\s-*$")
	  (push (concat
		 (if (save-match-data (string-match "Source" (match-string 1)))
		     "src:"
		   "")
		 (match-string-no-properties 2)) result))
	(forward-line 1)))
    result))

(defun debian-templates-view-package-bugs (package)
  "View bugs for package PACKAGE via http://bugs.debian.org."
  (interactive
   (list
    (completing-read "View bugs for package: "
		     (mapcar #'(lambda (x) (cons x 0))
			     (debian-templates-mode-bug-package-names))
		     nil t)))
  (browse-url (concat "http://bugs.debian.org/" package)))

(add-to-list 'auto-mode-alist '("/debian/*.templates\\'" . debian-templates-mode))
;;;###autoload(add-to-list 'auto-mode-alist '("/debian/control\\'" . debian-templates-mode))

(provide 'debian-templates-mode)

;;; debian-templates-mode.el ends here
