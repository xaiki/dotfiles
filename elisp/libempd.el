;;; libempd.el --- library for dealing with MPD (Music Player Daemon)

;; Copyright (C) 2004 Mikhail Gusarov <dottedmag@gorodok.net>

;;;; Handlers queue is the queue of server response handlers.
;;;; Terminated by the nil value

; Handler is the function receiving strings from the network stream. To indicate
; finish of processing return `finished' from the handler.

(defvar empd-handlers-queue '(nil))
(defvar empd-handlers-queue-insert-pos
  empd-handlers-queue)

(defvar empd-unprocessed-string "")

(defun empd-handle-line (string)
  (if (car empd-handlers-queue)
	  (if (eq 'finished (funcall (car empd-handlers-queue) string))
			(setq empd-handlers-queue
				  (cdr empd-handlers-queue)))
	(message "Empty handlers-queue")))

(defun empd-handler (process string)
  (setq empd-unprocessed-string (concat empd-unprocessed-string string))
  (while (string-match "\n" empd-unprocessed-string)
	(let* ((line-end (string-match "\n" empd-unprocessed-string))
		  (line (substring empd-unprocessed-string 0 line-end)))
	  (setq empd-unprocessed-string (substring empd-unprocessed-string (1+ line-end)))
	  (empd-handle-line line))))


(defun empd-add-handler (handler)
  (setcar empd-handlers-queue-insert-pos handler)
  (setq empd-handlers-queue-insert-pos
		(setcdr empd-handlers-queue-insert-pos (cons nil nil))))

;;;;;;;;;;;;;;

(defvar empd-connection nil)

(defvar empd-hostname "localhost")
(defvar empd-port "6600")
(defvar empd-process-buffer nil)

(defun empd-execute-command (command handler)
  (if (or (not (processp empd-connection))
		  (not (eq (process-status empd-connection) 'open)))
	  (setq empd-connection (empd-open-connection empd-hostname empd-port)))
  (empd-add-handler handler)
  (process-send-string empd-connection command))

(defun empd-open-connection (host port)
  (setq empd-handlers-queue '(nil))
  (setq empd-handlers-queue-insert-pos empd-handlers-queue)
  (empd-add-handler 'empd-read-banner-handler)
  (setq empd-connection (open-network-stream "*mpd*" empd-process-buffer host port))
  (set-process-coding-system empd-connection 'utf-8)
  (set-process-filter empd-connection 'empd-handler)
  empd-connection)

(defun empd-close-connection ()
  (if (and (processp empd-connection)
		   (eq (process-status empd-connection) 'open))
	  (delete-process empd-connection))
  (setq empd-connection nil))

(defun empd-read-banner-handler (string)
  (if (string-match "^OK " string)
	  (message (substring string 3)))
  'finished)

(defun empd-discard-ok-handler (string)
  'finished)

(defun empd-print-ok-handler (string)
  (if (string-match "^OK" string)
	  'finished
	nil))

(defun empd-extract-title (string)
  (if (string-match "^Title:" string) 
      (print "wouuuuuuuuaiiiiiis")
    (print "oh noooooooo")))

(defun empd-make-list-ok-handler (handler)
  `(lambda (string)
	 (if (string-match "^OK" string)
		 'finished
	   (,handler string))))

;;;;;;;;;;;;;;
(defun isint (value)
  (string-match "^[+-]?[0-9]+$" value))

;; (defun empd->pause (param)
;;   (empd-execute-command (concat "pause " param "\n") 'empd-print-ok-handler))

;; (defun empd->play (song)
;;   (empd-execute-command (concat "play " song "\n") 'empd-print-ok-handler))

;; (defun empd->stop ()
;;   (empd-execute-command "stop\n" 'empd-print-ok-handler))

;; (defun empd->ping ()
;;   (empd-execute-command "ping\n" 'empd-print-ok-handler))

;; (defun empd->listall-xa1 ()
;;   (empd-execute-command "listall\n" 'empd-print-ok-handler))

;; (defun empd->listall (handler)
;;   (empd-execute-command "listall\n" (empd-make-list-ok-handler handler)))

;; (defun empd->password (password)
;;   (empd-execute-command (concat "password " password "\n") 'empd-print-ok-handler))

;; (defun empd->status ()
;;   (empd-execute-command "status\n" 'empd-print-ok-handler))

;; (defun empd->next ()
;;   (empd-execute-command "next\n" 'empd-print-ok-handler))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun empd->add (path)
  (empd-execute-command (concat "add " path "\n") 'epmd-print-ok-handler))
;;         add the file _path_ to the playlist (directories add recursively)
;;         _path_ can also be a single file
;;         increments playlist version by for each song added

(defun empd->clear ()
  (empd-execute-command "clear\n" 'empd-print-ok-handler))
;;         clears the current playlist	
;;         increments playlist version by 1

(defun empd->clearerror	()
  (empd-execute-command "clearerror\n" 'empd-print-ok-handler))
;;         clear the current error message in status
;;         (this is also accomplished by any command that starts playback)

(defun empd->close ()
  (empd-execute-command "close\n" 'empd-print-ok-handler))
;;         close the connection with the MPD

(defun empd->crossfade (seconds)
  (cond ((isint seconds)
	 (empd-execute-command (concat "crossfade " seconds "\n") 'empd-print-ok-handler))))
  ;;         sets crossfading between songs

;; FIXME return value
(defun empd->currentsong-test ()
  (empd-execute-command "currentsong\n" 'empd-extract-title))

(defun empd->currentsong ()
  (empd-execute-command "currentsong\n" 'empd-print-ok-handler))
;;         displays the song info of current song (same song that is identified
;;         in status)


(defun empd->delete (song) 
  (cond ((isint song)
	 (empd-execute-command (concat "delete " song "\n") 'empd-print-ok-handler))))
;;         delete _song_ from playlist
;;         increments playlist version by 1

(defun empd->deleteid (songid)
  (cond ((isint songid)
	 (empd-execute-command (concat "deleteid " songid "\n") 'empd-print-ok-handler))))
;;         delete song with _songid_ from playlist
;;         increments playlist version by 1

;; FIXME return value
(defun empd->find (type what)
  (cond ((string-match "^\(\\|album\\|artist\\|title\\|)+$" type)
	 (empd-execute-command (concat "find " type " " what "\n") 'empd-print-ok-handler))))
;;         finds songs in the db that are exactly _what_
;;         _type_ should be "album", "artist", or "title"
;;         _what_ is what to find

(defun empd->kill ()
  (empd-execute-command "kill\n" 'empd-print-ok-handler))
;;         kill MPD

(defun empd->list (type arg1)
  (cond ((string-match "^\(\\|album\\|artist\\|)+$" type)
	 (empd-execute-command (concat "list " type " " arg1 "\n") 'empd-print-ok-handler))))
;;         list all tags of _type_ 
;;         _type_ should be "album" or "artist"
;;         _arg1_ is an optional parameter when type is album, this specifies
;;                 to list albums by a artist, where artist is specified with
;;                 arg1

(defun empd->listall (path)
  (empd-execute-command (concat "listall " path "\n") 'empd-print-ok-handler))
;;         lists all songs and directories in _path_ (recursively)
;;         _path_ is optional and maybe a directory or path

(defun empd->listallinfo (path)
  (empd-execute-command (concat "listallinfo " path "\n") 'empd-print-ok-handler))
;;         same as listall command, except it also returns metadata info
;;         in the same format as lsinfo

(defun empd->load (name)
  (empd-execute-command (concat "load " name "\n") 'empd-print-ok-handler))
;;         loads the playlist _name_.m3u from the playlist directory
;;         increments playlist version by the number of songs added

(defun empd->lsinfo (directory)
  (empd-execute-command (concat "lsinfo " directory "\n") 'empd-print-ok-handler))
;;         list contents of _directory_, from the db.  _directory_ is optional

(defun empd->move (from to)
  (cond ((and (isint from) (isint to))
	(empd-execute-command (concat "move " from " " to "\n") 'empd-print-ok-handler))))
;;         move song at _from_ to _to_ in the playlist
;;         increments playlist version by 1

(defun empd->moveid (songid to)
  (cond ((and (isint songid) (isint to))
	(empd-execute-command (concat "moveid " songid " " to "\n") 'empd-print-ok-handler))))
;;         move song with _songid_ to  _to_ in the playlist
;;         increments playlist version by 1

(defun empd->next ()
  (empd-execute-command "next\n" 'empd-print-ok-handler))
;;         plays next song in playlist

(defun empd->pause (pause)
  (cond ((string-match "^[01]+$" pause)
	(empd-execute-command (concat "pause " pause "\n") 'empd-print-ok-handler ))))
;;         toggle pause/resume playing
;;         _pause_ is required and should be 0 or 1
;;         NOTE: use of pause command w/o the _pause_ argument is depricated

(defun empd->password (password)
  (empd-execute-command (concat "password " password "\n") 'empd-print-ok-handler))
;;         this is used for authentication with the server.
;;         _password_ is simply the plaintext password

(defun empd->ping ()
  (empd-execute-command "ping\n" 'empd-print-ok-handler))
;;         does nothing but return "OK"

(defun empd->play (song)
  (cond ((isint song)
	 (empd-execute-command (concat "play " song "\n") 'empd-print-ok-handler))))
;;         begin playing playlist at song number _song_, _song_ is optional

(defun empd->playid (songid)
  (cond ((isint songid)
	 (empd-execute-command (concat "songid " songid "\n") 'empd-print-ok-handler))))
;;         begin playing playlist at song with _songid_, _songid_ is optional

;; FIXME return value
(defun empd->playlist ()
  (empd-execute-command "playlist\n" 'empd-print-ok-handler))
;;         displays the current playlist
;;         NOTE: do not use this, instead use 'playlistinfo'

(defun empd->playlistinfo (&optional song)
  (if song 
      (cond ((isint song)
	     (empd-execute-command (concat "playlistinfo " song "\n") 'empd-print-ok-handler)))
    (empd-execute-command "playlistinfo\n" 'empd-print-ok-handler)))
;;         displays list of songs in the playlist
;;         _song_ is optional and species a single song to displa info for

(defun empd->playlistid (&optional songid)
  (if songid
      (cond ((isint songid)
	     (empd-execute-command (concat "playlistid " songid "\n") 'empd-print-ok-handler)))
    (empd-execute-command "playlistid" 'empd-print-ok-handler)))
;;         displays list of songs in the playlist
;;         _songid_ is optional and species a single song to display info for

(defun empd->plchanges (version)
  (cond ((isint version)
	 (empd-execute-command (concat "plchanges " version "\n") 'empd-print-ok-handler))))
;;         displays changed songs currently in the playlist since 
;;         _playlist version_
;;         NOTE: to detect songs that were deleted at the end of the playlist,
;;         use playlistlength returned by status command.

(defun empd->previous ()
  (empd-execute-command "prvious\n" 'empd-print-ok-handler))
;;         plays previous song in playlist

(defun empd->random (state)
  (cond ((isint state)
	 (empd-execute-command (concat "random " state "\n") 'empd-print-ok-handler))))
;;         set random state to _state_, _state_ should be 0 or 1

(defun empd->repeat (state)
  (cond ((isint state)
	 (empd-execute-command (concat "repeat " state "\n") 'empd-print-ok-handler))))
;;         set repeat state to _state_, _state_ should be 0 or 1

(defun empd->rm (name)
  (empd-execute-command (concat "rm " name "\n") 'empd-print-ok-handler))
;;         removes the playlist <name>.m3u from the playlist directory

(defun empd->save (name)
  (empd-execute-command (concat "save " name "\n") 'empd-print-ok-handler))
;;         saves the current playlist to _name_.m3u in the playlist directory

(defun empd->search (type what)
  (cond ((string-match "^\(\\|title\\|artist\\|album\\|filename\\|)+$" type)
	 (empd-execute-command (concat "search " type " " what "\n") 'empd-print-ok-handler))))
;;         searches for any song that contain _what_
;;         _type_ can be "title","artist","album", or "filename"
;;         search is not case sensitive

;; FIMXE song should be optional
(defun empd->seek (song time)
  (cond ((and (isint song) (isint time))
	 (empd-execute-command (concat "seek " song " " time "\n") 'empd-print-ok-handler))))
;;         seeks to the position _time_ (in seconds) of entry _song_ in the 
;;         playlist

;; FIXME songid should be optional
(defun empd->seekid (songid time)
  (cond ((and (isint songid) (isint time))
	 (empd-execute-command (concat "seekid " songid " " time "\n") 'empd-print-ok-handler))))
;;         seeks to the position _time_ (in seconds) of song with _songid_

(defun empd->setvol (vol)
  (cond ((isint  vol)
	 (cond ((and (<= (string-to-number vol) '100) (>= (string-to-number vol) '0))
		(empd-execute-command (concat "setvol " vol "\n") 'empd-print-ok-handler))))))
;;         set volume to _vol_
;;         _vol_ the range of volume is 0-100

(defun empd->drshuffle ()
  (empd-execute-command "drshuffle\n" 'empd-print-ok-handler))
;;         shuffles the current playlist
;;         increments playlist version by 1
 
;; FIXME: return value
(defun empd->stats ()
  (empd-execute-command "stats\n" 'empd-print-ok-handler))
;;         display stats
;;         artists: number of artists
;;         albums: number of albums
;;         songs: number of songs
;;         uptime: daemon uptime in seconds
;;         db_playtime: sum of all song times in db
;;         db_update: last db update in UNIX time
;;         playtime: time length of music played

;; FIXME: return value
(defun empd->status ()
  (empd-execute-command "status\n" 'empd-print-ok-handler))
;;         reports current status of player, and volume level.
;;         volume: (0-100).
;;         repeat: (0 or 1)
;;         playlist: (31-bit unsigned integer, the playlist version number)
;;         playlistlength: (integer, the length of the playlist)
;;         state: ("play", "stop", or "pause")
;;         song: (current song stopped on or playing, playlist song number)
;;         songid: (current song stopped on or playing, playlist songid)
;;         time: <int elapsed>:<time total> (of current playing/paused song)
;;         bitrate: <int bitrate> (instantaneous bitrate in kbps)
;;         xfade: <int seconds> (crossfade in seconds)
;;         audio: <int sampleRate>:<int bits>:<int channels>
;;         updatings_db: <int job id>
;;         error: if there is an error, returns message here

(defun empd->stop ()
  (empd-execute-command "stop\n" 'empd-print-ok-handler))
;;         stop playing

(defun empd->swap (song1 song2)
  (cond ((and (isint song1) (isint song2))
	 (empd-execute-command (concat "swap " song1 " " song2 "\n") 'empd-print-ok-handler))))
;;         swap positions of _song1_ and _song2_
;;         increments playlist version by 1

(defun empd->swapid (songid1 songid2)
  (cond ((and (isiint songid1) (isiint songid2))
	 (empd-execute-command (concat "swapid " songid1 " " songid2 "\n") 'empd-print-ok-handler))))
;;         swap positions of of songs with song id's of _songid1_ and _songid2_
;;         increments playlist version by 1

;; FIXME: return value 
(defun empd->update (&optional path)
  (if path 
      (empd-execute-command (concat "update " path "\n") 'empd-print-ok-handler)
    (empd-execute-command "update\n")))
;;         searches mp3 directory for new music and removes old music from the db
;;         _path_ is an optional argument that maybe a particular directory or 
;;                 song/file to update.
;;         returned:
;;                 updating_db: <int job id>
;;         where job id, is the job id requested for your update, and is displayed
;;         in status, while the requested update is happening
;;         increments playlist version by 1
;;         NOTE: To update a number of paths/songs at once, use command_list,
;;         it will be much more faster/effecient.  Also, if you use a 
;;         command_list for updating, only one update_db job id will be returned
;;         per sequence of updates.

(defun empd->volume (change)
  (cond ((isint change)
	 (empd-execute-command (concat "volume " change "\n") 'empd-print-ok-handler)))) 
;;         change volume by amount _change_
;;         NOTE: volume command is deprecated, use setvol instead

;; FIXME: implement command_list
;;;;;;;;;;;;;;;

(provide 'libempd)

;;; libempd.el ends here
