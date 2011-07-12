(setq twittering-use-master-password t)
(setq twittering-convert-fix-size 32)
(setq twittering-status-format "!%s (%S), %RT{, ♺%s} %@ from %f%L%r%R:\n%i%FOLD[   ]{%T}") ;"%ZEBRA{       %s (%S) %RT{RT via %s}\n%i%T\n       %@ // from %f %L%r%R}")
(setq twittering-icon-mode t)                ; Show icons
(setq twittering-timer-interval 300)         ; Update your timeline each 300 seconds (5 minutes)
(setq twittering-url-show-status nil)        ; Keeps the echo area from showing all the http processes
(setq twittering-username "xaiki")
(add-hook 'twittering-edit-mode-hook (lambda () (ispell-minor-mode) (flyspell-mode)))

(provide 'xa1-twittering)

