(eval-when-compile
  (require 'cl))

(require 'regexp-opt)
(require 'faces)

(defgroup debian-interfaces nil
  "Colorize Debian's /etc/network/interfaces (minimal)."
  :tag "dni"
  :group 'help)

(defface debian-interfaces-hl-face '((t (:bold t)))
  "*Font used by debian-interfaces for highlighting first match."
  :group 'debian-interfaces)

(defface debian-interfaces-comment-face '((t (:foreground "red") (:bold nil)))
  "*Font used by debian-interfaces for comments, after first match."
  :group 'debian-interfaces)

(setq debian-interfaces-lock-keywords
      '(("\\(inet\\|ipx\\|inet6\\)" 0 font-lock-function-name-face keep)
	("\\(loopback\\|static\\|manual\\|dhcp\\|bootp\\|ppp\\|wvdial\\|v4tunnel\\|dynamic\\)" 0 font-lock-keyword-face keep) ;; inet
	("^\\(auto\\|allow-hotplug\\|iface\\|mapping\\)" 0 font-lock-variable-name-face keep)
	("^\\(auto\\|allow-hotplug\\|mapping\\)\\s-+\\([a-z0-9\\-]+\\)" 2 font-lock-type-face keep)
	("^\\(auto\\|allow-hotplug\\|mapping\\)\\s-+\\([a-z0-9\\-]+\\)\\(:[0-9]+\\)" 3 font-lock-warning-face keep)
	("^iface\\s-+\\([a-z0-9]+\\)" 1 font-lock-type-face keep)
	("^iface\\s-+\\([a-z0-9\\-]+\\)\\(:[0-9]+\\)" 2 font-lock-warning-face keep)
	("^iface\\s-+\\([a-z0-9]+\\)\\(-[0-9a-z]+\\)" 2 font-lock-keyword-face)
	("^\s+\\(address\\|netmask\\|broadcast\\|metric\\|gateway\\|pointopoint\\|hwaddress\\|mtu\\)" 0 font-lock-variable-name-face) ;; static
	("^\s+\\(hostname\\|leasehours\\|leasetime\\|vendor\\|client\\|hwaddress\\)" 0 font-lock-variable-name-face) ;; dhcp
	("^\\s-+\\(bootfile\\|server\\|hwaddr\\|provider\\|frame\\|netnum\\)" 0 font-lock-variable-name-face) ;; bootp ppp ipx
	("^\\s-+\\(script\\|map\\)" 0 font-lock-variable-name-face)
	("^\\s-+map\\s-+\\([A-Z]+\\)\\s-+\\([a-z0-9]+\\)" 1 font-lock-keyword-face)
	("^\\s-+map\\s-+\\([A-Z]+\\)\\s-+\\([a-z0-9]+\\)" 2 font-lock-type-face)
	("^\\s-+map\\s-+\\([A-Z]+\\)\\s-+\\([a-z0-9]+\\)\\(-[0-9a-z]+\\)" 3 font-lock-keyword-face)
	("^\\s-+\\(post-\\|pre-\\)?\\(up\\|down\\)" 0 font-lock-variable-name-face)
	("^\\s-+bridge_\\(ports\\|ageing\\|bridgeprio\\|fd\\|gcint\\|hello\\|hw\\|maxage\\|maxwait\\|pathcost\\|portprio\\|stp\\|waitport\\)" 0 font-lock-variable-name-face)
	("#.*" 0 font-lock-comment-face prepend)
	))

(defun debian-interfaces-turn-on ()
  "Turn on font-lock for debian-interfaces-mode"
  (font-lock-add-keywords nil debian-interfaces-lock-keywords))

(defun debian-interfaces-turn-off ()
  "Turn off font-lock for debian-interfaces-mode"
  (font-lock-remove-keywords nil '(,@debian-interfaces-lock-keywords)))

;;;###autoload
(define-minor-mode debian-interfaces-minor-mode
  "Minor Mode for Coloring Debian's /etc/network/interfaces"
  :lighter " debian-interfaces"
  :syntax-table nil
  :abbrev-table nil
  (progn
    (if debian-interfaces-minor-mode
	(debian-interfaces-turn-on)
      (debian-interfaces-turn-off)
      (font-lock-mode 1))))
;;;###autoload
(define-derived-mode debian-interfaces-mode conf-mode "Debian-Interfaces" "Major Mode for Coloring Debian's /etc/network/interfaces"
  (debian-interfaces-minor-mode))

(provide 'debian-interfaces-mode)
