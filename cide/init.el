;; This fixes a bug in the installed version: "bad request" when
;; downloading a package.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (company-yasnippet company-posframe company-postframe lazy-set-key use-package clang-capf company-c-headers ggtags))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "https://melpa.org/packages/")
   t))

;; To run this, install use-package from melpa
(use-package company :ensure t); this downloads the package if not installed
(require 'company)
(company-mode-on)
;; more info at https://tuhdo.github.io/c-ide.html
;; For clang auto completion, you need to install clang with apt
;; Check this if it does not work: M-x find-variable RET company-clang-executable RET
(add-hook 'after-init-hook 'global-company-mode)
; company-c-headers picks the headers from the folders in company-c-headers-path-system
(add-to-list 'company-backends 'company-c-headers)
;; Add some key bindings
(defun init-c-keys ()
  (progn
    ;; Press TAB for completing a function that we are typing
    (define-key c-mode-map  [(tab)] 'company-complete)
    (define-key c++-mode-map  [(tab)] 'company-complete)
    ;; To open a header file, just place the point in the include line
    ;; and type the following. If not placed on an include line, it
    ;; switches between the .c and .h of the file opened in the
    ;; current buffer.
    (define-key c-mode-map  (kbd "C-c o") 'ff-find-other-file)

    ;; I used this for debugging
    ;(setq c-keys-initialized t)
    )
  )
(add-hook 'c-mode-hook 'init-c-keys)
;;clang-capf
