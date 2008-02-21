;;; oc-charsets.el

;; Copyright (C) 2000 Otfried Cheong

;; oc-charsets.el is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This package is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(setq unicode-basic-translation-charset-order-list
      '(ascii
	unicode-a
	unicode-b
	unicode-c
	unicode-d
	unicode-e
	japanese-jisx0208
	japanese-jisx0212
	chinese-gb2312
	chinese-cns11643-1 
	chinese-cns11643-2
	korean-ksc5601
	;;
	latin-iso8859-1
	latin-iso8859-2
	latin-iso8859-3
	latin-iso8859-4
	cyrillic-iso8859-5
	;;
	greek-iso8859-7
	hebrew-iso8859-8
	latin-iso8859-9
	ipa
	chinese-cns11643-3
	chinese-cns11643-4
	chinese-cns11643-5
	chinese-cns11643-6
	chinese-cns11643-7
	latin-jisx0201
	katakana-jisx0201))

(define-charset nil 'unicode-a
  [2 96 1 0 ?0 0 "Unicode A" "Unicode A" "Unicode A"])

(define-charset nil 'unicode-b
  [2 96 1 0 ?1 0 "Unicode B" "Unicode B" "Unicode B"])

(define-charset 151 'unicode-c
  [2 96 2 0 ?2 0 "Unicode C" "Unicode C" "Unicode C"])

(define-charset nil 'unicode-d
  [2 96 2 0 ?3 0 "Unicode D" "Unicode D" "Unicode D"])

(define-charset nil 'unicode-e
  [2 96 2 0 ?4 0 "Unicode E" "Unicode E" "Unicode E"])

;; Tell C code charset ID's of several charsets.
(setup-special-charsets)

(provide 'oc-charsets)
