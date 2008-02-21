(defun sudo-open-file ()
  (interactive)
  (let* ((file (read-from-minibuffer "File: " "/"))
	 (process
	 (start-process-shell-command file (generate-new-buffer file) 
				      (concat "sudo cat " file))))
    (set-process-sentinel process
			  (lambda (proc change)
			    (switch-to-buffer (process-buffer proc))))
    process
    )
  )
