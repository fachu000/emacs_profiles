;; This fixes a bug in the installed version: "bad request" when
;; downloading a package.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ;; load emacs 24's package system. Add MELPA repository.
;; (when (>= emacs-major-version 24)
;;   (require 'package)
;;   (add-to-list
;;    'package-archives
;;    ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
;;    '("melpa" . "https://melpa.org/packages/")
;;    t))
