
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(custom-enabled-themes (quote (manoj-dark)))
 '(elpy-rpc-python-command
   "/Users/dani/Dropbox/signal_processing_stuff/code/python/environments/generic_mac/bin/python")
 '(elpy-rpc-timeout 3)
 '(exec-path
   (quote
    ("/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_14" "/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_14" "/Applications/Emacs.app/Contents/MacOS/libexec" "/Applications/Emacs.app/Contents/MacOS/bin" "/Library/Tex/texbin")))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (idle-highlight-mode flyspell-correct flycheck elpy)))
 '(pyvenv-activate
   "/Users/dani/Dropbox/signal_processing_stuff/code/python/environments/generic_mac"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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



;  This is the version that takes the (optional) name of the parent file from the current buffer
(defun compileltx ( )
  (interactive)
  
(progn
  (save-buffer) 

  (progn ; setting the name of the parent file. It depends on whether there is a line
	; containing the text "% parent file: name_of_the_parent_file.tex" or not  
    (setq initial_pos (point))
    (goto-line 0)
    (if (setq start_point (search-forward "% parent file: " nil t))
					; if there is a line with the text "% parent file: "
	(progn (setq end_point (search-forward ".tex" nil t))
	       (setq parent_file_name (buffer-substring-no-properties start_point end_point))
	       )
					; else
      (setq parent_file_name (buffer-name))	     
      )
    (goto-char initial_pos)

    )


  (progn  ; we change to the folder where the parent folder is
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
    
    (if (> pos 0)
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



(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))



(package-initialize)
(elpy-enable)



;(when (load "flycheck" t t)
;  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;  (add-hook 'elpy-mode-hook 'flycheck-mode))


				   
;QuickPdfNote

(defun figure-from-qpn (fname)
      "Bring a figure from QPN"
      (interactive "sFigure name (no '.pdf'):")
      (progn
	(setq str_before "\\begin{figure}[bhtp]
  \\centering
  \\includegraphics[width=1.0\\textwidth]{")
	(setq str_middel "}
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
	(copy-file "/Users/dani/Dropbox/Apps/QuickPdfNote/QPN_figure.pdf" local_filename)
	(setq local_ps_filename (concat "figs/" fname "-flattened.ps"))
;	(start-process "pdf2ps" "pdf2ps" "/usr/local/bin/pdf2ps" local_filename local_ps_filename)
	(call-process  "/usr/local/bin/pdf2ps" nil "pdf2ps" nil  local_filename local_ps_filename)
	(setq flattened_pdf_filename (concat "figs/" fname "-flattened.pdf"))
	(start-process "ps2pdf" "ps2pdf" "/usr/local/bin/ps2pdf" local_ps_filename flattened_pdf_filename)
	
	(insert str_before flattened_pdf_filename str_middel fname str_after)
	)
      )


; Hide code 
(global-set-key (kbd "C-,") 'hs-hide-level)
(global-set-key (kbd "C-.") 'hs-toggle-hiding)
(add-hook 'python-mode-hook 'hs-minor-mode)

; Line numbers
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'python-mode-hook 'display-line-numbers-mode)
(add-hook 'python-mode-hook (lambda () (setq display-line-numbers-width 3)))
