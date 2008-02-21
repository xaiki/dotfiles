(defun mpc-connect () 
  (interactive)
  (unless empd-hostname
    (setq empd-hostname (read-from-minibuffer "Enter MPD hostname :")))
  (unless empd-port
    (setq empd-port (read-from-minibuffer "Enter MPD port: ")))
  (print (concat "trying to connect to " empd-hostname ":" empd-port))
  (empd-open-connection empd-hostname empd-port)
  (and empd-ping-handler (cancel-timer empd-ping-handler))
  (when empd-ping-interval 
    (setq empd-ping-handler
	  (run-with-timer
	   4 (print "ping")
	   (lambda (buf)
	     (when (buffer-live-p buf)
	       (with-current-buffer buf
		 (empd->ping))))
	   (current-buffer)))))
		       
    (empd->status)))
	;;		 "*mpd*"
		;;	 "mpd-debug" 
			;; empd-hostname
;; empd-port)))
(defun empd-keep-alive ()
  (if empd-ping-handler empd-kill-connection)
  (setq empd-ping-handler (run-with-timer 1 empd-ping-interval (lambda () (empd->currentsong)))
	))

(set-process-filter empd-connection nil)

(defun xa1-filter (proc out)
  (if (string-match "^OK" out)
      (print "got Ok")))

(setq empd-ping-handler 'xa1-filter)

(setq blah-string "file: RAGGEA/RAGGA/Asian Dub Foundation - Conscious Party/Asian Dub Foundation - Conscious Party - 12 - Charge (ADF sound system remix).ogg
Artist: Asian Dub Foundation
Album: Conscious Party
Track: 12
Title: Charge (ADF sound system remix)
Time: 307
Pos: 2096
Id: 2096
OK")

(string-match "^Track:" blah-string)
(match-data)

(defun empd-kill-connection ()
  (if empd-ping-handler
      ((cancel-timer empd-ping-handler)
       (setq empd-ping-handler nil))))

(setq empd-ping-interval 10)
(cancel-timer xa1)

(defvar empd-ping-handler nil
  )
(make-variable-buffer-local 'empd-ping-handler)

(setq empd-ping-interval 5)

(setq empd-hostname "cxhome.ath.cx")
(setq empd-port "6600")
(setq empd-process-buffer "*mpd-debug*")

(setq empd-connection (open-network-stream "*mpd*" "mpd" empd-hostname empd-port))
(empd->password "your password ")
(empd->ping)
(empd->status)
(empd->currentsong)
(empd->currentsong-test)
(empd->listall-xa1)
(empd->next)
(empd->stop)
(empd->close)
(empd-read-status)
(empd->play "1")
(empd->crossfade "1")
(empd->playlistinfo)

(defun test ()
  (insert-button 
   "next" 
   'action (if (empd->next) (print "salut"))
   'mouse-action (print "salut")
   'follow-link t
   'help-echo "mouse")
  (insert 
  (print "Hello"))
(test)