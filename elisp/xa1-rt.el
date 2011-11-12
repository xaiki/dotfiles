(when (require 'rt-liberation nil t)
  (progn
    (setq rt-liber-rt-binary "/usr/bin/rt-4"
	  rt-liber-rt-version "4.0.2"
	  rt-liber-username "xaiki"
	  rt-liber-host "rt.covetel.com.ve"
	  rt-liber-base-url "https://rt.covetel.com.ve/")
    (require 'rt-liberation-update nil t)
    (setq rt-liber-update-default-queue "CNTI")
    (require 'rt-liberation-storage nil t)
    (require 'rt-liberation-multi nil t)


    (defun xa1/rt-get-passwd (host user)
      (let* ((auth-source-creation-prompts
	      '((user . "RT user at %h: ")
		(secret . "RT password for %u@%h: ")))
	     (found (nth 0 (auth-source-search :max 1
					       :host host
					       :port "rt"
					       :require '(:user :secret)
					       :create nil))))
	(if found
	    (list (plist-get found :user)
		  (let ((secret (plist-get found :secret)))
		    (progn
		      (setenv "RTPASSWD" (if (functionp secret)
					     (funcall secret)
					   secret))
		      (setenv "RTUSER" user)
		      (setenv "RTSERVER" (concat "http://" host))))
		  (plist-get found :save-function))
	  (message "not found")
	  nil)))

    (xa1/rt-get-passwd rt-liber-host rt-liber-username)

    (defun xa1/rt-display-queue (queue-id)
      "Display queue in the ticket-browser."
      (interactive "MQueue: ")
      (rt-liber-browse-query
       (rt-liber-compile-query
	(queue queue-id))))


    (defun xa1/rt-display-user (user)
      "Display tickets for user in the ticket-browser."
      (interactive "Muser: ")
      (rt-liber-browse-query
       (rt-liber-compile-query
	(owner user))))

    (defun xa1/rt-display-mine ()
      (interactive)
      (xa1/rt-display-user rt-liber-username))

    (defun xa1/rt-display-unassigned ()
      (interactive)
      (rt-liber-browse-query
       (rt-liber-compile-query
	(or (and (owner "Nobody") (status "new"))
	    (and (owner "Nobody") (status "open"))
	    ))))

    (defun rt-liber-ticketlist-browser-redraw-f (ticket)
      "Display TICKET."
      (insert (rt-liber-format "* %S %s [%i]" ticket))
      (add-text-properties (point-at-bol)
			   (point-at-eol)
			   '(face rt-liber-ticket-face))
      (newline)
      (insert (rt-liber-format "    <%c>" ticket))
      (let ((p (point)))
	(insert (rt-liber-format "    %A" ticket))
	(add-text-properties p (point)
			     '(face font-lock-comment-face)))
      (newline)
      (insert (rt-liber-format "    %o <== %R" ticket)))

    (setq rt-org-todo-keywords
	  '((sequence "new(n)" "|" "open(o)" "|" "resolved(r)" "|" "invalid" )))
    (provide 'xa1-rt)
    ))
