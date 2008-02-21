;;; oc-unicode.el

;; Copyright (C) 2000 Otfried Cheong

;; Version 0.72.2
;; (Because it goes with Mule-UCS 0.72)
;;
;; This code extends Mule-UCS to cover more of Unicode and to use
;; Unicode fonts 

;; oc-unicode.el is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; This package is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(require 'oc-charsets)
(require 'un-define)
(require 'oc-tools)

;; use Unicode font
(put-charset-property 'ascii 'x-charset-registry "iso10646")
(put-charset-property 'japanese-jisx0212 'x-charset-registry "iso10646")
(put-charset-property 'japanese-jisx0208 'x-charset-registry "iso10646")
(put-charset-property 'chinese-gb2312 'x-charset-registry "iso10646")
(put-charset-property 'chinese-cns11643-1 'x-charset-registry "iso10646")
(put-charset-property 'chinese-cns11643-2 'x-charset-registry "iso10646")
(put-charset-property 'korean-ksc5601 'x-charset-registry "iso10646")
(put-charset-property 'unicode-a 'x-charset-registry "iso10646")
(put-charset-property 'unicode-b 'x-charset-registry "iso10646")
(put-charset-property 'unicode-c 'x-charset-registry "iso10646")
(put-charset-property 'unicode-d 'x-charset-registry "iso10646")
(put-charset-property 'unicode-e 'x-charset-registry "iso10646")

(defun oc-create-fontset (narrow wide)
  (create-fontset-from-fontset-spec
   (concat narrow ",\n"
	   "unicode-c:" wide ",\n"
	   "unicode-d:" wide ",\n"
	   "unicode-e:" wide ",\n"
	   "korean-ksc5601:" wide ",\n"
	   "japanese-jisx0208:" wide ",\n"
	   "japanese-jisx0212:" wide ",\n"
	   "chinese-gb2312:" wide ",\n"
	   "chinese-cns11643-1:" wide ",\n"
	   "chinese-cns11643-2:" wide) 
   t))

(modify-coding-system-alist 'file "\\.utf\\'" 'utf-8)

(provide 'oc-unicode)
;;; oc-unicode.el ends here
