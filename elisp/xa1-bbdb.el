(require 'bbdb-autoloads nil t)
(require 'bbdb)
(load "bbdb-com" t)
(bbdb-initialize 'gnus 'message);; 'reportmail 'w3)
(bbdb-insinuate-message)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(bbdb-insinuate-sc)
(bbdb-insinuate-w3)
(setq bbdb-north-american-phone-numbers-p nil
      bbdb-check-zip-codes-p nil
      bbdb-offer-save 'always-save
      bbdb-notice-hook (quote (bbdb-auto-notes-hook))
      bbdb/mail-auto-create-p t
      bbdb/news-auto-create-p nil)
(provide 'xa1-bbdb)