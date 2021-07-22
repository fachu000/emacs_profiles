
(setq help-window-select t)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(tool-bar-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(custom-enabled-themes (quote (wheatgrass)))
 '(elpy-rpc-python-command
   "/Users/dani/Dropbox/signal_processing_stuff/code/python/environments/generic_mac/bin/python")
 '(elpy-rpc-timeout 6)
 '(elpy-rpc-virtualenv-path (quote current))
 '(exec-path
   (quote
    ("/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_14" "/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_14" "/Applications/Emacs.app/Contents/MacOS/libexec" "/Applications/Emacs.app/Contents/MacOS/bin" "/Library/Tex/texbin")))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (jedi company-c-headers lsp-mode use-package sublimity-scroll sublimity ggtags smartparens helm direx idle-highlight-mode flyspell-correct flycheck elpy)))
 '(python-shell-interpreter "python")
 '(pyvenv-activate
   "/Users/dani/Dropbox/signal_processing_stuff/code/python/environments/generic_mac"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(header-line ((t (:inherit mode-line :background "gray56" :foreground "grey90" :box nil)))))

(setq ispell-program-name "/usr/local/bin/ispell")

;;(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)





(defun compileltx ( )
  (interactive)
  (progn
    (save-buffer)
    (setq name (buffer-name))
    (setq outvalue (call-process "pdflatex" nil "pdflatex"  nil name) )
    (if (> outvalue 0) (switch-to-buffer "pdflatex")
      (progn
        (setq posdot (string-match "\\." name ))
        (setq pdfname (concat (substring name 0  posdot) ".pdf" ) )
                                        ; (call-process "evincescript.sh" nil  nil nil pdfname)
        (start-process "my-process" "foo" "atril" pdfname))
      )
    )
  )

;; (defun compileltx ( )
;; (interactive)
;; (progn
;;  (save-buffer)
;;  (setq name (buffer-name))
;;  (setq outvalue (call-process "latex" nil "latex"  nil name) )
;;  (if (> outvalue 0) (switch-to-buffer "latex")
;;   (progn
;;     (setq posdot (string-match "\\." name ))
;;     (setq dviname (concat (substring name 0  posdot) ".dvi" ) )
;;     (setq outvalue (call-process "dvipdf" nil "dvipdf"  nil dviname) )
;;       (if (> outvalue 0) (switch-to-buffer "dvipdf")
;;              (setq pdfname (concat (substring name 0  posdot) ".pdf" ) )
;;              (start-process "my-process" "foo" "evince" pdfname))
;;       )
;; )
;; )
;; )


                                        ; A) BIBTEX + PDFLATEX:
(defun compileltx ( ) 
  (interactive)
  (progn
    (save-buffer)
    (setq name (buffer-name))

    (progn
      (setq posdot (string-match "\\." name ))
      (setq pdfname (concat (substring name 0  posdot) ".pdf" ) )

      (setq posdot (string-match "\\." name ))
      (setq auxname (concat (substring name 0  posdot) ".aux" ) )

      (call-process "bibtex" nil "bibtex"  nil auxname)

      (setq outvalue (call-process "pdflatex" nil "pdflatex"  nil name) )
      (if (> outvalue 0) (switch-to-buffer "pdflatex")
        (progn
          (setq posdot (string-match "\\." name ))
          (setq pdfname (concat (substring name 0  posdot) ".pdf" ) )
                                        ; (call-process "evincescript.sh" nil  nil nil pdfname)
          (start-process "my-process" "foo" "atril" pdfname))
        )
      )
    )
  )


; Problem hub compilation
(defun ph-compile ( )
  (print "inside ph-compile")

  (setq ph-buffer-name "ph-latex")
  (if (member ph-buffer-name (mapcar 'buffer-name (buffer-list)) ) 
      (kill-buffer ph-buffer-name)
    )

  
  (setq outvalue (call-process "/Users/dani/Dropbox/signal_processing_stuff/code/python/environments/generic_mac/bin/python" nil ph-buffer-name  nil "/Users/dani/Dropbox/signal_processing_stuff/websites/django/psite/problemhub/latex.py" buffer-file-name))

                                        ;  (switch-to-buffer ph-buffer-name)
  (if (> outvalue 0)
      (switch-to-buffer ph-buffer-name)
    (progn
      (with-current-buffer ph-buffer-name (setq pdf_fi_name (buffer-string))
                           )
      (setq pdf_fi_name (substring pdf_fi_name 0 -1))
                                        ;   (print "hello")
      (print pdf_fi_name)
      
      ;; (setq posdot (string-match "\\." name ))
      ;; (setq pdfname (concat (substring parent_file_name 0  posdot) ".pdf" ) )
      ;; (call-process "evincescript.sh" nil  nil nil pdfname)
      ;;(start-process "my-process" "foo" "open" pdf_fi_name))
      (call-process "/usr/bin/open" nil "openbf" nil pdf_fi_name)
      )
    )
  )


(defun compileltx-file (parent_file_name)
  (interactive)

    (progn  ; we change to the folder where the parent file is
                                        ;    (setq parent_file_name "../file.tex")
      (setq pos 0)
      (setq pos_new 0)
      (while
          (setq pos_new (string-match "/" parent_file_name (+ pos 1)) )
        (progn
                                        ;	(print pos)
                                        ;	(print pos_new)
                                        ;	(print "uuuu")
          (setq pos pos_new)
          )
        ) ; after this while, pos contains the position of the last match

      (if
          (> pos 0)
          (progn
            (setq relative_path  (substring parent_file_name 0  (+ 1 pos)))
            (setq default-directory
                  (format "%s%s" (file-name-directory (or load-file-name buffer-file-name)) relative_path )
                  )
            (setq parent_file_name (substring parent_file_name (+ 1 pos) nil  ))
            )
					; else
        (progn (setq default-directory (file-name-directory (or load-file-name buffer-file-name)))
                                        ;	     (print default-directory)
               )
        )
                                        ;    (print default-directory)
                                        ;    (print parent_file_name)
      )

    (progn   ; latex to pdf
      (setq posdot (string-match "\\." parent_file_name ))
      (setq pdfname (concat (substring parent_file_name 0  posdot) ".pdf" ) )

      (setq auxname (concat (substring parent_file_name 0  posdot) ".aux" ) )

      (call-process "/Library/TeX/texbin/bibtex" nil "bibtex"  nil auxname)

      (setq outvalue (call-process "pdflatex" nil "pdflatex"  nil parent_file_name) )
      (if (> outvalue 0) (switch-to-buffer "pdflatex")
        (progn
					;	  (setq posdot (string-match "\\." name ))
          (setq pdfname (concat (substring parent_file_name 0  posdot) ".pdf" ) )
					; (call-process "evincescript.sh" nil  nil nil pdfname)
          (start-process "my-process" "foo" "open" pdfname))
        )
      )
    )
  

;  This is the version that takes the (optional) name of the parent file from the current buffer
(defun compileltx ( )
  (interactive)

  (progn
    (save-buffer)    
    (progn ; setting the name of the parent file. It depends on whether there is a line
                                        ; containing the text "% parent file: name_of_the_parent_file.tex" or not
      (setq initial_pos (point))

      (goto-line 0)
      (if (setq start_point (search-forward "%% ph_def_problem" nil t))
          (progn
            (goto-char initial_pos)
            (ph-compile)
            )
        (progn
          (goto-line 0)
          (if (setq start_point (search-forward "% parent file: " nil t))
					; if there is a line with the text "% parent file: "
              (progn (setq end_point (search-forward ".tex" nil t))
                     (setq parent_file_name (buffer-substring-no-properties start_point end_point))
                     (goto-char initial_pos)
                     (compileltx-file parent_file_name)
                     )
					; else
            (progn (setq parent_file_name (buffer-name))
                   (goto-char initial_pos)
                   (compileltx-file parent_file_name)
                   )
            )
          )

        )
      )
    )
  )




(global-set-key (kbd "<f5>") 'compileltx)
(global-set-key "\C-c\C-w" 'compileltx)
(global-set-key "\C-z" 'elpy-yapf-fix-code)

(global-set-key [(control tab)] 'increase-left-margin)
(global-set-key [(control meta tab)]  'decrease-left-margin)


; execute the following with M-x replace-latex-command
(defun replace-latex-command (old-name new-name)
      "Replace the command '\old-name' by the command
'\new-name'. Answer ! to replace all following matches. Do not
use backslash!!"
      (interactive "sOld command name (no backslash): \nsNew command name (no backslash): ")
      (progn
	(setq prev-point (point))
	(setq case-fold-search nil)  ; case sensitive
	(replace-regexp (concat "\\\\" old-name "\\([^[:alpha:]]\\)") (concat "\\\\" new-name "\\1"))
	(setq case-fold-search t)  ; back to case insensitive
	(goto-char prev-point)
	)
)

; non-interactive latex command replacement
;(progn
;  (setq case-fold-search nil)  ; case sensitive
;  (setq old-name  "by")
;  (setq new-name  "yvec")
;  (query-replace-regexp (concat "\\\\" old-name "\\([^[:alpha:]]\\)") (concat "\\\\" new-name "\\1"))
; )




;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "https://melpa.org/packages/")
   t))
;; (require 'package)
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/"))





(package-initialize)



;(when (load "flycheck" t t)
;  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;  (add-hook 'elpy-mode-hook 'flycheck-mode))



;QuickPdfNote

(defun figure-from-new-qpn (fname)
  "Bring a figure from a new QPN figure"
  (interactive "sFigure name (no '.pdf'):")
  (figure-from-qpn fname  "QPN_figure.pdf")
  )

(defun figure-from-edited-qpn (fname)
  "Bring a figure from a new QPN figure"
  (interactive "sFigure name (no '.pdf'):")
  (figure-from-qpn fname  "edited_figure.pdf")
  )

(defun figure-to-edit-qpn (fname)
  "Moves figure figs/fname.pdf to [QPN folder]/figure_to_edit.pdf"
  (interactive "sFigure name (no '.pdf'):")
  (progn
        (setq qpn_file_name "figure_to_edit.pdf")
	(setq filename (concat fname
			       ".pdf"))
	(setq local_filename (concat "figs/" filename))
					;	(rename-file "/Users/dani/Dropbox/Apps/QuickPdfNote/QPN_figure.pdf" local_filename)
	(copy-file  local_filename (concat "/Users/dani/Dropbox/Apps/QuickPdfNote/" qpn_file_name) 1)

	)
        (message "Now you can edit the figure in QPN pressing \"EDIT FIGURE\"")
  )

(defun figure-from-qpn (fname qpn_file_name)
      "Bring a figure from QPN"
      (interactive "sFigure name (no '.pdf'):")
      (progn
	(setq str_before "\\begin{figure}[bhtp]
  \\centering
  \\includegraphics[width=1.0\\textwidth]{")
	(setq str_middle "}
  \\caption{    }
  \\label{fig:")
	(setq str_after "}
\\end{figure}
")

	(mkdir "figs" 1)
	(setq filename (concat fname
			       ;"-"
			       ;(format-time-string "%Y-%m-%dT%T")
			       ".pdf"))
	(setq local_filename (concat "figs/" filename))
					;	(rename-file "/Users/dani/Dropbox/Apps/QuickPdfNote/QPN_figure.pdf" local_filename)
	(copy-file (concat "/Users/dani/Dropbox/Apps/QuickPdfNote/" qpn_file_name) local_filename 1)
	(setq local_ps_filename (concat "figs/" fname "-flattened.ps"))
;	(start-process "pdf2ps" "pdf2ps" "/usr/local/bin/pdf2ps" local_filename local_ps_filename)
	(call-process  "/usr/local/bin/pdf2ps" nil "pdf2ps" nil  local_filename local_ps_filename)
	(setq flattened_pdf_filename (concat "figs/" fname "-flattened.pdf"))
	(start-process "ps2pdf" "ps2pdf" "/usr/local/bin/ps2pdf" local_ps_filename flattened_pdf_filename)

	(insert str_before flattened_pdf_filename str_middle fname str_after)
	)
      )


; Hide code
(global-set-key (kbd "C-,") 'hs-hide-level)
(global-set-key (kbd "C-.") 'hs-toggle-hiding)
                                        ;(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'prog-mode-hook 'hs-minor-mode)
(add-hook 'prog-mode-hook 'idle-highlight-mode)

;; Smartparens --> for closing parentheses
(add-hook 'prog-mode-hook 'smartparens-mode)
;; EXPLORE:
;; (require 'smartparens-config)
;; (setq sp-base-key-bindings 'paredit)
;; (setq sp-autoskip-closing-pair 'always)
;; (setq sp-hybrid-kill-entire-symbol nil)
;; (sp-use-paredit-bindings)
;; (show-smartparens-global-mode +1)


; Line numbers
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook (lambda () (setq display-line-numbers-width 3)))


; elpy shell
(defun my-restart-python-console ()
  "Restart python console before evaluate buffer or region to avoid various uncanny conflicts, like not reloding modules even when they are changed"
  (interactive)
  (if (get-buffer "*Python*")
      (let ((kill-buffer-query-functions nil)) (kill-buffer "*Python*")))
  (elpy-shell-send-region-or-buffer))

(global-set-key (kbd "C-c C-x C-c") 'my-restart-python-console)


;; Navigation options
;;keep cursor at same position when scrolling
(setq scroll-preserve-screen-position nil); another option is 1
;;scroll window up/down by one line
;; (global-set-key (kbd "M-n") (kbd "C-u 10 C-n"))
;; (global-set-key (kbd "M-p") (kbd "C-u 10 C-p"))
(global-set-key (kbd "M-n") (lambda () (interactive) (forward-line 10)))
(global-set-key (kbd "M-p") (lambda () (interactive) (previous-line 10)))



;; Display function on top
(which-function-mode)
(setq-default header-line-format
              '((which-func-mode ("" which-func-format " "))))
(setq mode-line-misc-info
            ;; We remove Which Function Mode from the mode line, because it's mostly
            ;; invisible here anyway.
            (assq-delete-all 'which-func-mode mode-line-misc-info))


;; Key rebindings for modifier keys in Mac --> done at a system level since other applications (e.g. the terminal, Chrome, etc) use also the control key.
;; (when (eq system-type 'darwin)
;;   (setq
;;    ns-command-modifier 'meta
;;    ns-option-modifier 'control
;;    ns-control-modifier 'super
;;    ns-function-modifier 'hyper))

;; This fixes a bug in the installed version: "bad request" when
;; downloading a package.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;   BEGIN HELM
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; An alternative can be the package counsel. Install it and set:
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "C-c g") 'counsel-git) ; will override the keybinding for `magit-file-dispatch'
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)

;; HELM
;; Useful commands
;; helm-imenu (C-x c i) --> to browse the functions in a file
(require 'helm-config)
(helm-mode 1)
(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
(define-key global-map [remap execute-extended-command] 'helm-M-x)
(define-key global-map [remap apropos-command] 'helm-apropos)
(unless (boundp 'completion-in-region-function)
  (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
  (define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point))


(require 'helm)
;; (require 'helm-config)

;; ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
;; (global-set-key (kbd "C-c h") 'helm-command-prefix)
;; (global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(define-key helm-map (kbd "C-j") 'helm-maybe-exit-minibuffer) ; select action with C-j

;; (when (executable-find "curl")
;;   (setq helm-google-suggest-use-curl-p t))

;; (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
;;       helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
;;       helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
;;       helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
;;       helm-ff-file-name-history-use-recentf t
;;       helm-echo-input-in-header-line t)

;; (defun spacemacs//helm-hide-minibuffer-maybe ()
;;   "Hide minibuffer in Helm session if we use the header line as input field."
;;   (when (with-helm-buffer helm-echo-input-in-header-line)
;;     (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
;;       (overlay-put ov 'window (selected-window))
;;       (overlay-put ov 'face
;;                    (let ((bg-color (face-background 'default nil)))
;;                      `(:background ,bg-color :foreground ,bg-color)))
;;       (setq-local cursor-type nil))))


;; (add-hook 'helm-minibuffer-set-up-hook
;;           'spacemacs//helm-hide-minibuffer-maybe)

;; (setq helm-autoresize-max-height 0)
;; (setq helm-autoresize-min-height 20)
;; (helm-autoresize-mode 1)

;; (helm-mode 1)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; END HELM
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Brought from prelude-global-keybindings.el
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one
;; A complementary binding to the apropos-command (C-h a)
(define-key 'help-command "A" 'apropos)
;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; recommended avy keybindings
(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)

;; additional avy keybindings
(global-set-key (kbd "s-,") 'avy-goto-char)
(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "C-c v") 'avy-goto-word-or-subword-1)




;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Brought from prelude-editor.el
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; delete the selection with a keypress
(delete-selection-mode t)
;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; use shift + arrow keys to switch between visible buffers
(require 'windmove)
(windmove-default-keybindings)

;; enable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; enabled change region case commands
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


;; anzu-mode enhances isearch & query-replace by showing total matches and current match position
(require 'anzu)
(diminish 'anzu-mode)
(global-anzu-mode)

(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)


;; smarter kill-ring navigation
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)
(global-set-key (kbd "s-y") 'browse-kill-ring)

;;;;;;;;;
;; automatically indenting yanked text if in programming-modes
(defun yank-advised-indent-function (beg end)
  "Do indentation, as long as the region isn't too large."
  (if (<= (- end beg) prelude-yank-indent-threshold)
      (indent-region beg end nil)))

(defmacro advise-commands (advice-name commands class &rest body)
  "Apply advice named ADVICE-NAME to multiple COMMANDS.

The body of the advice is in BODY."
  `(progn
     ,@(mapcar (lambda (command)
                 `(defadvice ,command (,class ,(intern (concat (symbol-name command) "-" advice-name)) activate)
                    ,@body))
               commands)))
(defcustom prelude-yank-indent-modes '(LaTeX-mode TeX-mode)
  "Modes in which to indent regions that are yanked (or yank-popped).
Only modes that don't derive from `prog-mode' should be listed here."
  :type 'list
  :group 'prelude)

(defcustom prelude-yank-indent-threshold 1000
  "Threshold (# chars) over which indentation does not automatically occur."
  :type 'number
  :group 'prelude)

(defcustom prelude-indent-sensitive-modes
  '(conf-mode coffee-mode haml-mode python-mode slim-mode yaml-mode)
  "Modes for which auto-indenting is suppressed."
  :type 'list
  :group 'prelude)

(advise-commands "indent" (yank yank-pop) after
  "If current mode is one of `prelude-yank-indent-modes',
indent yanked text (with prefix arg don't indent)."
  (if (and (not (ad-get-arg 0))
           (not (member major-mode prelude-indent-sensitive-modes))
           (or (derived-mode-p 'prog-mode)
               (member major-mode prelude-yank-indent-modes)))
      (let ((transient-mark-mode nil))
        (yank-advised-indent-function (region-beginning) (region-end)))))

;; diff-hl
;; diff-hl-mode highlights uncommitted changes on the left side of the window, allows you to jump between and revert them selectively.(global-diff-hl-mode +1)
(add-hook 'dired-mode-hook 'diff-hl-dired-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages that we may explore
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; crux (useful extensions for navigation, e.g. creating new lines)
;; hippie-expand or dabbrev for expanding abbreviations
;; abbrev --> expand abbreviations https://www.emacswiki.org/emacs/AbbrevMode

;; EditorConfig helps maintain consistent coding styles for multiple developers working on the same project across various editors and IDEs. The EditorConfig project consists of a file format for defining coding styles and a collection of text editor plugins that enable editors to read the file format and adhere to defined styles. EditorConfig files are easily readable and they work nicely with version control systems.

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Try
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; diminish keeps the modeline tidy
;; (require 'diminish)


;; ;; meaningful names for buffers with the same name
;; (require 'uniquify)
;; (setq uniquify-buffer-name-style 'forward)
;; (setq uniquify-separator "/")
;; (setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
;; (setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers


;; ;; automatically save buffers associated with files on buffer switch
;; ;; and on windows switch
;; (require 'super-save)
;; ;; add integration with ace-window
;; (add-to-list 'super-save-triggers 'ace-window)
;; (super-save-mode +1)
;; (diminish 'super-save-mode)


;; (require 'volatile-highlights)
;; (volatile-highlights-mode t)
;; (diminish 'volatile-highlights-mode)
;; ;; note - this should be after volatile-highlights is required
;; ;; add the ability to cut the current line, without marking it
;; (require 'rect)
;; (crux-with-region-or-line kill-region)


;; dired --> to see folders

;; ;; supercharge your undo/redo with undo-tree
;; (require 'undo-tree)
;; ;; autosave the undo-tree history
;; (setq undo-tree-history-directory-alist
;;       `((".*" . ,temporary-file-directory)))
;; (setq undo-tree-auto-save-history t)
;; (global-undo-tree-mode)
;; (diminish 'undo-tree-mode)


;; ;; enable winner-mode to manage window configurations
;; (winner-mode +1)


;; ;; easy-kill
;; (global-set-key [remap kill-ring-save] 'easy-kill)
;; (global-set-key [remap mark-sexp] 'easy-mark)

;; Additional minor modes enabled in prelude for a .py file:
;; Anaconda  Async-Bytecomp-Package
;; Auto-Composition Auto-Compression Auto-Encryption
;; Company Delete-Selection Diff-Auto-Refine Diff-Hl
;; Editorconfig Eldoc Electric-Indent Erc-Spelling Erc-Track Erc-Truncate
;; File-Name-Shadow Flycheck Flyspell Font-Lock Global-Anzu
;; Global-Auto-Revert Global-Company Global-Diff-Hl
;; Global-Display-Line-Numbers Global-Eldoc Global-Flycheck
;; Global-Font-Lock Global-Hl-Line Global-Hl-Todo Guru
;; Hl-Todo Ivy Line-Number Menu-Bar Mouse-Wheel Recentf
;; Save-Place Shell-Dirtrack Show-Smartparens
;; Show-Smartparens-Global Size-Indication  Subword Super-Save
;; Tex-Pdf Tooltip Transient-Mark Volatile-Highlights
;; Which-Function Which-Key Whitespace

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; C IDE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(package-install 'use-package)
(use-package company :ensure t); this downloads the package if not installed
(use-package ggtags :ensure t); this downloads the package if not installed
;; (add-hook 'ggtags-mode-hook 
;;           (define-key ggtags-navigation-map (kbd "M-<") 'beginning-of-buffer)
;;           )

;; Add to this list the folders containing GTAGS files where you want
;; the search to be performed besides the current folder. Separate by
;; ":".
(setenv "GTAGSLIBPATH" "/home/pi/code/libnl")

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
    ;; in ggtags use (recall that C-c is the prefix in C-mode):
    ;;   M-. to go to a definition
    ;;   C-c M-p (ggtags-prev-mark) to go back
    ;;   M-, abort
    ;;   RET done
    ;; OTHER KEYS
    ;; ;; Globally bound to `M-g p'.
    ;; ;; (define-key m "\M-'" 'previous-error)
    ;; (define-key m (kbd "M-DEL") 'ggtags-delete-tags)
    ;; (define-key m "\M-p" 'ggtags-prev-mark)
    ;; (define-key m "\M-n" 'ggtags-next-mark)
    ;; (define-key m "\M-f" 'ggtags-find-file)
    ;; (define-key m "\M-o" 'ggtags-find-other-symbol)
    ;; (define-key m "\M-g" 'ggtags-grep)
    ;; (define-key m "\M-i" 'ggtags-idutils-query)
    ;; (define-key m "\M-b" 'ggtags-browse-file-as-hypertext)
    ;; (define-key m "\M-k" 'ggtags-kill-file-buffers)
    ;; (define-key m "\M-h" 'ggtags-view-tag-history)
    ;; (define-key m "\M-j" 'ggtags-visit-project-root)
    ;; (define-key m "\M-/" 'ggtags-view-search-history)
    ;; (define-key m (kbd "M-SPC") 'ggtags-save-to-register)
    ;; (define-key m (kbd "M-%") 'ggtags-query-replace)
    ;; (define-key m "\M-?" 'ggtags-show-definition)
    (ggtags-mode t)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; SMOOTH SCROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package sublimity :ensure t)
 (require 'sublimity)
 (require 'sublimity-scroll)
; (sublimity-mode 1) ; disabled in RBP
 (setq auto-window-vscroll nil)

 (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
 (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
 (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq scroll-conservatively 10000)
(setq scroll-step           1
      scroll-conservatively 10000)

;; Jump to the definition of a function in a system header
(semantic-mode t)
(defun semantic-display-tag (&optional pt)
  "Display tag at point."
  (interactive "d")
  (unless pt (setq pt (point)))
  (let (analyze tag buf loc start pt)
    (when (and (setq analyze (semantic-analyze-current-context pt))
               (setq tag (semantic-analyze-interesting-tag analyze))
               (setq buf (semantic-tag-buffer tag))
               (setq start (semantic-tag-start tag)))
      (with-selected-window (display-buffer buf #'display-buffer-pop-up-window)
        (goto-char start)
        (recenter))
      )))

(global-set-key (kbd "C-c , d") #'semantic-display-tag)
(easy-menu-add-item cedet-menu-map '("Navigate Tags") ["Display Tag" semantic-display-tag (semantic-active-p)] 'semantic-complete-jump-local)

;; Jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

;;;
(elpy-enable)

(global-set-key (kbd "C-c c r") 'comment-region)
(global-set-key (kbd "C-c u r") 'uncomment-region)
(global-set-key (kbd "C-c p p") 'pop-tag-mark)


;;;
(add-hook 'shell-mode-hook 'compilation-shell-minor-mode)

;;;
;; Use M-<left>, M-<up>, etc to switch to other windows. 
(windmove-default-keybindings 'meta)
