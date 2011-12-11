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
    (require 'rt-liberation-gnus)

    ;; FIXME, this is going to bite later.
    (setq org-todo-keyword-faces
	  '(("rejected" . org-warning)))

    (global-set-key "\C-ctm" (lambda () (interactive)
			       (xa1/rt-display-mine)))

    (global-set-key "\C-ctu" (lambda () (interactive)
			       (xa1/rt-display-unassigned)))

    (global-set-key "\C-ctU" (lambda (user)
			       (interactive "Muser: ")
			       (xa1/rt-display-user user)))

    (setq rt-liber-gnus-comment-address "casos@covetel.com.ve"
           rt-liber-gnus-address        "casos@covetel.com.ve"
	   rt-liber-gnus-subject-name    "COVETEL"
           rt-liber-gnus-answer-headers  '(("From" . "xaiki@covetel.com.ve")
					   ("Gcc" . "nnml:Send-Mail")
					   ("X-Ethics" . "Use GNU"))
           rt-liber-gnus-signature       "--
Saludos bichitos"

	   rt-org-todo-keywords "new(n) open(o) | resolved(r) | invalid rejected")

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

    ;; hack around the clock tonight.
    (defalias 'rt-liber-query-runner-old (symbol-function 'rt-liber-query-runner))
    (defun rt-liber-query-runner (op query-string)
      (xa1/rt-get-passwd rt-liber-host rt-liber-username)
      (rt-liber-query-runner-old op query-string))

    (defun xa1/rt-sort-by-status (ticket-list)
      "Sort TICKET-LIST lexicographically by owner."
      (rt-liber-sort-ticket-list
       ticket-list
       #'(lambda (a b)
	   (rt-liber-lex-lessthan-p a b "Status"))))

    (setq rt-liber-browser-default-sorting-function 'xa1/rt-sort-by-status)

    (defun xa1/rt-display-queue (queue-id)
      "Display queue in the ticket-browser."
      (interactive "MQueue: ")
      (rt-liber-browse-query
       (rt-liber-compile-query
	(queue queue-id))))


     (defun xa1/rt-display-ticket (ticket-id)
       "Display ticket with TICKET-ID in the ticket-browser."
       (interactive "MTicket ID: ")
       (rt-liber-browse-query
        (rt-liber-compile-query
     	 (id ticket-id))))

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
      (xa1/rt-display-new-open "Nobody"))

    (defun xa1/rt-display-new-open (user)
      (interactive "Muser: ")
      (rt-liber-browse-query
       (rt-liber-compile-query
	(or (and (owner user) (status "new"))
	    (and (owner user) (status "open"))
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
    (provide 'xa1-rt)
    ))
