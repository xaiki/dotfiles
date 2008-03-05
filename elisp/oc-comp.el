;;; oc-comp.el

;;
;; This is a wrapper around mucs-comp.el
;;
;; It sets up additional character sets and tables
;;

(setq unicode-charset-library-alist
  '((ascii . uascii)
    (latin-iso8859-1 . uiso8859-1)
    (latin-jisx0201 . ujisx0201)
    (katakana-jisx0201 . ujisx0201)
    (japanese-jisx0208 . ujisx0208)
    (japanese-jisx0212 . ujisx0212)
    (chinese-cns11643-1 . u-cns-1)
    (chinese-cns11643-2 . u-cns-2)
    (chinese-cns11643-3 . u-cns-3)
    (chinese-cns11643-4 . u-cns-4)
    (korean-ksc5601 . uksc5601)
    (chinese-gb2312 . ugb2312)
    (unicode-a . uuni-a)
    (unicode-b . uuni-b)
    (unicode-c . uuni-c)
    (unicode-d . uuni-d)
    (unicode-e . uuni-e)
    (latin-iso8859-2 . uiso8859-2)
    (latin-iso8859-3 . uiso8859-3)
    (latin-iso8859-4 . uiso8859-4)
    (cyrillic-iso8859-5 . uiso8859-5)
    (arabic-iso8859-6 . uiso8859-6)
    (greek-iso8859-7 . uiso8859-7)
    (hebrew-iso8859-8 . uiso8859-8)
    (latin-iso8859-9 . uiso8859-9)
    (chinese-cns11643-5 . u-cns-5)
    (chinese-cns11643-6 . u-cns-6)
    (chinese-cns11643-7 . u-cns-7)
    (ipa . uipa)))

(let ((load-path (append '("." "./Mule-UCS-0.72") load-path)))
  (require 'oc-charsets)
  (cd "Mule-UCS-0.72")
  (load-library "mucs-comp"))

