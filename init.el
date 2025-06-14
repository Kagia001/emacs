;; Init.el
;; TODO company kinda wonkey but works
;; TODO color hex colors
;; TODO -nw support
;; Mickeyn/combobulate
;; TODO modernemacs.com
;; TODO svg todo and header
;; emacs 29:
;; TODO smooth scroll
;; TODO new lsp and tree-sitter stuffs
;;; Init stuff
;; Increasing garbage collection threshold during startup significantly lowers init times.
(setq gc-cons-threshold (* 50 1000 1000))	; 100MB
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold (* 2 1000 1000)))) ; 2MB

;; * Straight
(setq straight-check-for-modifications '(watch-files find-when-checking)) ; Speeds up straight startup

;; This whack shit is how you install straight apparently
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'project) ; workaround for https://github.com/radian-software/straight.el/issues/1146

;;; Misc.
(setq load-path  (append (list "~/.emacs.d/load" ) load-path))
(let ((default-directory "~/.emacs.d/load"))
  (normal-top-level-add-subdirs-to-load-path))

;; Don't clutter up directories with files~
(setq backup-directory-alist '(("." . "~/.emacs.d/backup-files")))

;; Don't clutter with #files either
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name (concat "~/.emacs.d/" "backup-file")))))

(setq ring-bell-function 'ignore)	; Turn off beep

(straight-use-package 'nameless)
(add-hook 'emacs-lisp-mode-hook #'nameless-mode)
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

;; (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
;; (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;; (setq scroll-step 1) ;; keyboard scroll one line at a time

(straight-use-package '(ultra-scroll :type git :host github :repo "jdtsmith/ultra-scroll"))
(setq scroll-conservatively 101)
(ultra-scroll-mode)


;; (desktop-save-mode 1)		; Save open windows and buffers
;; (setq frame-resize-pixelwise t) 	; Play nice with tiling wms

(straight-use-package 'smartparens)	; Close brackets
(require 'smartparens-config)
(add-hook 'prog-mode-hook 'smartparens-mode)

(straight-use-package 'pdf-tools)
(pdf-loader-install) ; On demand loading, leads to faster startup time

(straight-use-package '(screenshot :host github :repo "tecosaur/screenshot"))

(straight-use-package 'dashboard)
(dashboard-setup-startup-hook)
(setq dashboard-startup-banner 'logo)
(setq dashboard-projects-backend 'projectile)
(setq dashboard-items '((recents  . 5)
                        (projects . 5)))
(add-hook 'dashboard-mode 'dashboard-jump-to-recents)

(savehist-mode)

;;(require ')
(setq dired-recursive-deletes 'always)
(setq dired-dwim-target 't)
(setq delete-by-moving-to-trash 't)
(when (executable-find "unrar")		; support unraring in dired
  (require 'dired-aux)
  (add-to-list 'dired-compress-file-suffixes '("\\.rar\\'" "" "unrar x %i")))

(straight-use-package 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(add-to-list 'display-buffer-alist '("*Async Shell Command*" display-buffer-no-window (nil)))
(setq async-shell-command-buffer 'rename-buffer)

(straight-use-package 'bluetooth)

;; (straight-use-package 'tramp-container) ;; gives a warning but whatever
(require 'tramp-container)

(recentf-mode)				; dashboard mode forgets tramp files else
(add-hook 'buffer-list-update-hook #'recentf-track-opened-file)
(add-hook 'find-file-hook #'recentf-save-list)
(setq recentf-max-saved-items 1000)

(global-visual-line-mode)

;; (straight-use-package 'popwin)
;; (setq popwin:popup-window-position 'right)
;; (popwin-mode)
;; (push '("*Help*" :noselect t) popwin:special-display-config)

(defun pmx-split-window-conservatively (&optional window)
  "Split WINDOW only if absolutely necessary.
Only split if there is no split, and only split into left & right
windows."
  (interactive)
  (let ((window (or window (selected-window))))
    (when (and ;; (window-splittable-p window t) ;idk why but this doesnt really work
           (= (length (window-list)) 1))
      (with-selected-window window
        (split-window-right)))))

(setq split-window-preferred-function #'pmx-split-window-conservatively)

;; Did I mention that I have a preferred function?  Could you like, not?
(setq warning-display-at-bottom nil)
(setq ediff-split-window-function 'split-window-horizontally)

(straight-use-package
 '(eat :files ("*.el" ("term" "term/*.el") "*.texi"
               "*.ti" ("terminfo/e" "terminfo/e/*")
               ("terminfo/65" "terminfo/65/*")
               ("integration" "integration/*")
               (:exclude ".dir-locals.el" "*-tests.el"))))

;;;; Org mode
;;;;; outshine
;; (straight-use-package 'outshine)	; Comment headers
;; (add-hook 'emacs-lisp-mode-hook 'outline-minor-mode)
(add-hook 'c-mode-hook (lambda () (setq outline-regexp "# \\*+")))

;;;;; org main
(straight-use-package 'org)
(require 'org)
(add-hook 'org-mode-hook 'org-indent-mode)
(straight-use-package 'org-bullets)
(add-hook 'org-mode-hook 'org-bullets-mode)
(add-hook 'org-mode-hook 'variable-pitch-mode)
(set-face-attribute 'variable-pitch nil :family "DejaVu Serif" :height 1.1)

;;;;; org plantuml
(straight-use-package 'plantuml-mode)
(setq org-plantuml-jar-path (expand-file-name "plantuml.jar"))
(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
(org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))

;;;;; org latex
(straight-use-package 'cdlatex)
(straight-use-package 'xenops)
(straight-use-package 'auctex)

;; (setq org-pretty-entities t)
(add-hook 'org-mode-hook #'turn-on-org-cdlatex)
(add-hook 'org-mode-hook #'xenops-mode)
(setq org-preview-latex-default-process 'dvisvgm)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))
(setq xenops-math-image-scale-factor 1.3)

;;;;; CDLaTeX
(setq cdlatex-command-alist
      '(("vc" "Insert \\vec{}" "\\vec{?}" cdlatex-position-cursor nil nil t)
	("intinf" "Insert integral from -\\infty to \\infty" "\\int\\limits_{-\\infty}^{\\infty} ?" cdlatex-position-cursor nil nil t)
	("suminf" "Infinite sum" "\\sum\\limits_{?=-\\infty}^{\\infty}" cdlatex-position-cursor nil nil t)
	("prodl" "Product w limints" "\\prod\\limits_{?}^{}" cdlatex-position-cursor nil nil t)
	("ali" "Insert align* env" "" cdlatex-environment ("align*") t nil)
	("equ" "Insert equation* env" "" cdlatex-environment ("equation*") t nil)

	("pmat" "insert parenthesees matrix" "" cdlatex-environment ("pmatrix") nil t)
	("bmat" "insert square braket matrix" "" cdlatex-environment ("bmatrix") nil t)
	))

(setq cdlatex-math-modify-alist
      '((?b "\\mathbb" nil t nil nil)))

(setq cdlatex-math-symbol-alist
      '((?l ("\\lambda" "\\ell" "\\laplace"))
	(?f ("\\phi" "\\varphi" "\\fourier"))
	(?. ("\\cdot" "\\dots"))
	(?\r ("\\\\\n"))
	(?\t (" & "))))

(setq cdlatex-env-alist
      '(("equation*" "\\begin{equation*}
?
\\end{equation*}" nil)))


(setq org-agenda-files (directory-files-recursively "~/Documents/" "\\.org$"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(custom-safe-themes
   '("a5270d86fac30303c5910be7403467662d7601b821af2ff0c4eb181153ebfc0a"
     "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c"
     "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3"
     default))
 '(org-agenda-files
   '("/home/karl/Documents/uni/wi24/orga.org"
     "/home/karl/Documents/uni/wi24/sus/tut1.org"))
 '(org-babel-load-languages '((emacs-lisp . t) (C . t) (python . t)))
 '(org-confirm-babel-evaluate nil)
 '(safe-local-variable-directories '("/home/karl/Documents/cerberus/"))
 '(safe-local-variable-values '((vhdl-basic-offset . 4)))
 '(screenshot-border-width 20)
 '(screenshot-font-size 12)
 '(screenshot-line-numbers-p nil)
 '(screenshot-radius 10)
 '(screenshot-shadow-offset-horizontal -2)
 '(screenshot-shadow-offset-vertical 6)
 '(screenshot-shadow-radius 5)
 '(screenshot-text-only-p nil)
 '(warning-suppress-types '((frameset))))

;;;;; org agenda
(setq org-agenda-window-setup 'current-window)

;;;;; org inline pdf
(straight-use-package 'org-inline-pdf)
(add-hook 'org-mode-hook #'org-inline-pdf-mode)
;; (setq org-inline-pdf-cache-directory "/home/karl/.emacs.d/org-inline-pdf-cache")
(setq org-inline-pdf-cache-directory ())

;;;;; org inline images
(setq org-startup-with-inline-images t)

;;; EXWM
(straight-use-package 'exwm)
(require 'exwm)
(setq workspace-index-map (lambda (i) (number-to-string (1+ i))))
(setq my/exwm-normal-workspace-number 5)
(setq my/exwm-special-workspace-number 2)
(setq exwm-workspace-number (+ my/exwm-normal-workspace-number my/exwm-special-workspace-number))

;; Make buffer name more meaningful
(add-hook 'exwm-update-class-hook
          (lambda ()
            (exwm-workspace-rename-buffer exwm-class-name)))

(setq exwm-layout-show-all-buffers t)
(setq exwm-workspace-show-all-buffers t)

(setq exwm-manage-configurations
      `(((string= exwm-class-name "Spotify") workspace ,my/exwm-normal-workspace-number)
	((string= exwm-class-name "firefox") workspace ,(1+ my/exwm-normal-workspace-number))
        ;; ((string= exwm-class-name "firefox") char-mode t)
	))


(add-hook 'exwm-init-hook (lambda () (interactive)
			    (async-shell-command "spotify")
			    (async-shell-command "firefox")
			    ))


;;; Completion Framework
(straight-use-package 'vertico)         ; Completion framework
(vertico-mode)
(setq-default vertico-count 10)		; Show 25 options
(setq read-file-name-completion-ignore-case t ; Be case insensitive
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; (straight-use-package 'vertico-posframe)
;; (vertico-posframe-mode)
;; (setq vertico-posframe-parameters
;;       '((internal-border-width . 2)
;; 	))
;; (set-face-attribute 'vertico-posframe-border nil :background "#3c3836")

(straight-use-package 'savehist)        ; Save history for completion framework
(savehist-mode)

(straight-use-package 'marginalia)	; Show explanations in vertico margin
(marginalia-mode)

(straight-use-package 'prescient)
(straight-use-package 'vertico-prescient)
(vertico-prescient-mode)
(prescient-persist-mode)

;; (straight-use-package 'mini-frame)	; Minibuffer in center when typing
;; (setq mini-frame-show-parameters '((top . 0) (width . 0.7) (left . 0.5)))
;; (mini-frame-mode)

(straight-use-package 'consult)		; Completion for more things
(setq xref-show-xrefs-function #'consult-xref)
(setq xref-show-definitions-function #'consult-xref)
;; Use `consult-completion-in-region' if Vertico is enabled.
;; Otherwise use the default `completion--in-region' function.
(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

(defun consult-info-emacs ()
  "Search through Emacs info pages."
  (interactive)
  (consult-info "emacs" "efaq" "elisp" "cl" "compat"))

(straight-use-package 'orderless)       ; Complete by searching for space-separated snippets
(setq completion-styles '(orderless basic)
      completion-caterogy-defaults nil
      completion-category-overrides '((file (stylef partial-completion))))

;;; IDE tools
;;;; Project
;; (require 'project)
;; (setq project-switch-commands 'project-find-file)
(straight-use-package 'projectile)


(straight-use-package 'python-pytest)
;;;; Direnv
(straight-use-package 'direnv)
(setq direnv-always-show-summary nil)
(direnv-mode)

;;;; Completion
;; (straight-use-package 'corfu)
;; (straight-use-package 'corfu-prescient)
;; (corfu-prescient-mode)

;; (setq corfu-auto 't)
;; (setq corfu-auto        t
;;       corfu-auto-delay  0.1
;;       corfu-auto-prefix 3)
;; (keymap-unset corfu-map "RET")
;; (add-hook 'prog-mode-hook 'corfu-mode)


;;Tree sitter
(require 'treesit)
(straight-use-package 'treesit-auto)
(require 'treesit-auto)			; needed for some reason
(global-treesit-auto-mode)
(setq treesit-auto-install 'prompt)

;;;; LSP
;; (setq read-process-output-max (* 1024 1024)) ; Better performance
;; (straight-use-package 'lsp-mode)
;; (setq lsp-headerline-breadcrumb-segments '(project file symbols))
;; (straight-use-package 'consult-lsp)
(straight-use-package 'eglot)
(add-hook 'eglot-inlay-hints-mode-hook (lambda () (when eglot-inlay-hints-mode (eglot-inlay-hints-mode -1))))

(setq eldoc-idle-delay 0)


;; DAP
(straight-use-package 'dap-mode)


;; ;;;; Yasnippet
;; (straight-use-package 'yasnippet)
;; (straight-use-package 'yasnippet-snippets)
;; (yas-global-mode 1)

;; ;;;; Company
;; (straight-use-package 'company)
;; (add-hook 'prog-mode-hook 'company-mode)
;; (setq company-idle-delay 0)
;; (setq company-minimum-prefix-length 0)
;; ;;(straight-use-package 'company-tabnine)
;; ;; (setq company-backends '((company-tabnine company-capf)))
;; ;; (setq company-backends '(company-yasnippet))
;; (setq lsp-completion-provider :none)
;; (setq company-backends '((company-capf :with company-yasnippet)))
;;;; Magit
(straight-use-package 'magit)

;;; Language modes
;;;; VHDL
(straight-use-package 'vhdl-ext)
(setq vhdl-ext-feature-list
      '(font-lock
        xref
        capf
        hierarchy
        eglot
        lsp
        ;lsp-bridge
        ;lspce
        ;flycheck
        beautify
        navigation
        template
        compilation
        imenu
        which-func
        hideshow
        time-stamp
        ports))
(require 'vhdl-ext)
;; (add-hook 'vhdl-ext-mode-hook (lambda () (vhdl-ext-eglot-set-server 've-rust-hdl))) ; Have to set in hook in case of direnv
(vhdl-ext-mode-setup)
(setq vhdl-modify-date-on-saving nil)
(add-hook 'vhdl-mode-hook #'vhdl-ext-mode)
;;;; Scilab mode
					;(require 'scilab)
					;(add-hook 'scilab-mode-hook (lambda () (load "scilab-startup")))
;; (setq scilab-shell-command "flatpak run org.scilab.Scilab -nw")

;;;; Arduino-mode
(straight-use-package 'arduino-mode)
;; (define-derived-mode my/arduino-micro-mode c-mode "arduino"
;;   "My own mode which is a wrapper for c-mode for editing arduino files.")
;; (add-to-list 'auto-mode-alist '("\\.ino\\'" . arduino-mode))
;; (add-hook 'arduino-mode-hook #'eglot-ensure)
;; (add-to-list 'eglot-server-programs 
;;              '(my/arduino-micro-mode . ("arduino-language-server" "-fqbn" "arduino:avr:micro")))
;; ;;;; Web-mode
;; (straight-use-package 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.svelte\\'" . web-mode))
;; (add-hook 'web-mode-hook #'lsp-deferred)
;; ;; (add-hook 'web-mode-hook (lambda () (setq-local outline-regexp "<!--\\|//\\|/\* [*]\\{1,8\\}'")))

;;; Visual
;;;; Vanilla emacs
(menu-bar-mode -1)                      ; Remove menu line at the top
(scroll-bar-mode -1)			; Remove scroll bar
(tool-bar-mode -1)                      ; Remove tool bar
(blink-cursor-mode -1)
;; (global-hl-line-mode)			; Highlight current line
(add-to-list 'default-frame-alist '(font . "fira code nerd font-13")) ; Font

;; (setq inhibit-startup-message t)	; Disable splash screen
;; (setq initial-scratch-message nil)

;; (setq-default display-line-numbers 'relative) ; Show line numbers
;; (setq-default display-line-numbers-width 3)


;;;; Theme
;; ;;;;; Catppuccin
;;   (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; (load-theme 'catppuccin t)
;; (defun catppuccin ()
;;   (enable-theme 'catppuccin)
;; )
;;;;; Dracula
(defun dracula ()
  (interactive)
  (straight-use-package 'dracula-theme)
  (load-theme 'dracula t)
  (custom-theme-set-faces
   'dracula
   '(outshine-level-1 ((t (
			   :foreground "#bd93f9"
			   ))))
   '(outshine-level-2 ((t (
			   :foreground "#8be9fd"
			   ))))
   '(outshine-level-3 ((t (
			   :foreground "#50fa7b"
			   ))))
   '(outshine-level-4 ((t (
			   :foreground "#ffb86c"
			   ))))
   '(outshine-level-5 ((t (
			   :foreground "#ff79c6"
			   ))))
   )
  (enable-theme 'dracula)
  )


;;;;; Gruvbox
;;;;;; Light
(defun gruv-light ()
  (interactive)
  (straight-use-package 'gruvbox-theme)
  (load-theme 'gruvbox-light-hard t)

  (custom-theme-set-faces
   'gruvbox-light-hard
   '(hl-line ((t (
		  :background "#fbf1c7"
		  ))))
   '(region ((t (
		 :background "#fbf1c7"
		 ;; :box (:line-width (-1 . -1))
		 ))))

   '(mode-line ((t (
		    :background "#ebdbb2"
		    ))))
   )
  (enable-theme 'gruvbox-light-hard)
  )

;;;;;; Dark
(defun gruv-dark ()
  (interactive)
  (straight-use-package 'gruvbox-theme)
  (load-theme 'gruvbox-dark-medium t)
  
  (custom-theme-set-faces
   'gruvbox-dark-medium
   '(outshine-level-1 ((t (
			   :foreground "#ff8700"
			   ))))
   '(outshine-level-2 ((t (
			   :foreground "#ffaf00"
			   ))))
   '(outshine-level-3 ((t (
			   :foreground "#87afaf"
			   ))))
   '(outshine-level-4 ((t (
			   :foreground "#87af87"
			   ))))
   '(outshine-level-5 ((t (
			   :foreground "#afaf00"
			   ))))
   )
  (enable-theme 'gruvbox-dark-medium)
  )

;;;;; Solarized
(defun solarized-light ()
  (interactive)
  (straight-use-package 'solarized-theme)
  (load-theme 'solarized-light t)
  
  ;; (custom-theme-set-faces
  ;;  'gruvbox-dark-medium
  ;;  '(outshine-level-1 ((t (
  ;; 			   :foreground "#ff8700"
  ;; 			   ))))
  ;;  '(outshine-level-2 ((t (
  ;; 			   :foreground "#ffaf00"
  ;; 			   ))))
  ;;  '(outshine-level-3 ((t (
  ;; 			   :foreground "#87afaf"
  ;; 			   ))))
  ;;  '(outshine-level-4 ((t (
  ;; 			   :foreground "#87af87"
  ;; 			   ))))
  ;;  '(outshine-level-5 ((t (
  ;; 			   :foreground "#afaf00"
  ;; 			   ))))
  ;;  )
  (enable-theme 'solarized-light)
  )

;; (defun lightmode ()
;;   (interactive)
;;   (catppuccin)
;; (setq catppuccin-flavor 'latte) ;; or 'latte, 'macchiato, or 'mocha
;; (catppuccin-reload)
;; )

(defun darkmode ()
  (interactive)
  (dracula))

;; (darkmode)
(gruv-light)
;; (solarized-light)


;; ;;;; Margins
;; (straight-use-package 'perfect-margin)
;; ;; (require 'perfect-margin)
;; (setq perfect-margin-visible-width 120)
;; (perfect-margin-mode 1)
;; (add-hook 'org-mode-hook 'visual-line-mode)

;;;; Indenting guide
;; (straight-use-package 'highlight-indent-guides)
;; (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
;; (setq highlight-indent-guides-method 'character)
;; (setq highlight-indent-guides-auto-character-face-perc 30)
;; (setq highlight-indent-guides-responsive 'top)
;; (setq highlight-indent-guides-delay 0)
;; (setq highlight-indent-guides-auto-top-character-face-perc 60)

;; Modeline
					; (straight-use-package 'doom-modeline)
					; (setq doom-modeline-height 31)
					; (setq doom-modeline-bar-width 8)
					; (setq doom-modeline-buffer-file-name-style 'truncate-nil)
					; (setq doom-modeline-buffer-state-icon nil)
					; (setq doom-modeline-buffer-encoding nil)
(display-battery-mode)
(setq display-time-24hr-format t)
(display-time)
(straight-use-package 'exwm-modeline)
(add-hook 'exwm-init-hook #'exwm-modeline-mode)
;; (doom-modeline-mode)

;;;; Outline
(set-face-attribute 'outline-1 nil :inherit 'org-level-1)
(set-face-attribute 'outline-2 nil :inherit 'org-level-2)
(set-face-attribute 'outline-3 nil :inherit 'org-level-3)
(set-face-attribute 'outline-4 nil :inherit 'org-level-4)
(set-face-attribute 'outline-5 nil :inherit 'org-level-5)
(set-face-attribute 'outline-6 nil :inherit 'org-level-6)
(set-face-attribute 'outline-7 nil :inherit 'org-level-7)
(set-face-attribute 'outline-8 nil :inherit 'org-level-8)
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(outshine-level-1 ((t (:family "Victor Mono" :height 1.75 :weight extra-bold :slant italic :underline t))))
;;  '(outshine-level-2 ((t (:family "Victor Mono" :height 1.5 :weight extra-bold :slant italic :underline t))))
;;  '(outshine-level-3 ((t (:family "Victor Mono" :height 1.25 :weight bold :slant italic :underline t))))
;;  '(outshine-level-4 ((t (:family "Victor Mono" :weight bold :height 1.25 :weight bold :slant italic :underline t))))
;;  '(outshine-level-5 ((t (:family "Victor Mono" :height 1.0 :weight bold :slant italic :underline t)))))

;;;; Org-mode
(set-face-attribute 'org-level-1 nil :height 1.3 :weight 'semi-bold)
(set-face-attribute 'org-table nil :inherit 'fixed-pitch)
;;; Syntax highlighting
;; ;;;; Treesitter
;; ;; Tree siter does some cool parsing stuff. Probably the best syntax highlighting, doesnt support that many languages though as of now
;; (straight-use-package 'tree-sitter)
;; (straight-use-package 'tree-sitter-langs)


;; (global-tree-sitter-mode)
;; (add-hook 'tree-sitter-after-on-hook 'tree-sitter-hl-mode)
;; (add-to-list 'tree-sitter-major-mode-language-alist '(svelte-mode . svelte))

;;;;; Elisp
;; Stolen from doom emacs
(defvar init--emacs-lisp-font-lock-face nil)
(defun init-emacs-lisp-font-lock-vars-and-faces (end)
  "Match defined variables and functions.
Functions are differentiated into special forms, built-in functions and
library/userland functions"
  (catch 'matcher
    (while (re-search-forward "\\(?:\\sw\\|\\s_\\)+" end t)
      (let ((ppss (save-excursion (syntax-ppss))))
        (cond ((nth 3 ppss)  ; strings
               (search-forward "\"" end t))
              ((nth 4 ppss)  ; comments
               (forward-line +1))
              ((let ((symbol (intern-soft (match-string-no-properties 0))))
                 (and (cond ((null symbol) nil)
                            ((eq symbol t) nil)
                            ((keywordp symbol) nil)
                            ((special-variable-p symbol)
                             (setq init--emacs-lisp-font-lock-face 'font-lock-variable-name-face))
                            ((and (fboundp symbol)
                                  (eq (char-before (match-beginning 0)) ?\()
                                  (not (memq (char-before (1- (match-beginning 0)))
                                             (list ?\' ?\`))))
                             (let ((unaliased (indirect-function symbol)))
                               (unless (or (macrop unaliased)
                                           (special-form-p unaliased))
                                 (let (unadvised)
                                   (while (not (eq (setq unadvised (ad-get-orig-definition unaliased))
                                                   (setq unaliased (indirect-function unadvised)))))
                                   unaliased)
                                 (setq init--emacs-lisp-font-lock-face
                                       (if (subrp unaliased)
                                           'font-lock-constant-face
                                         'font-lock-function-name-face))))))
                      (throw 'matcher t)))))))
    nil))

(font-lock-add-keywords
 'emacs-lisp-mode
 ;; highlight defined, special variables & functions
 '((init-emacs-lisp-font-lock-vars-and-faces . init--emacs-lisp-font-lock-face)))
(straight-use-package 'lisp-extra-font-lock) ; More lisp syntax highlighting
(lisp-extra-font-lock-global-mode 1)
(straight-use-package 'highlight-numbers) ; Highlight numbers
(add-hook 'emacs-lisp-mode-hook 'highlight-numbers-mode)

;; ;;;;; Keywords
(straight-use-package 'hl-todo)
(setq hl-todo-keyword-faces
      `(("TODO" warning bold)
	("FIXME" error bold)
	("HACK" font-lock-constant-face bold)
	("REVIEW" font-lock-keyword-face bold)
	("NOTE" success bold)
	("DEPRECATED" font-lock-doc-face bold)
	("BUG" error bold)
	("XXX" font-lock-constant-face bold)))
(global-hl-todo-mode)

;;;; Symbols
;; NOTE https://raw.githubusercontent.com/jming422/fira-code-mode/master/fonts/FiraCode-Regular-Symbol.otf
;;;;; Fira Code ligatures
;; (add-hook 'haskell-mode-hook 'my-set-hasklig-ligatures)
(straight-use-package '(ligature :type git :host github :repo "mickeynp/ligature.el"))
(global-ligature-mode)
;; ;;;;;; Fundamental mode
;; (ligature-set-ligatures 't '("www" "Fl" "Tl" "fi" "fj" "fl"))
;; ;;;;;; Prog mode

;; (ligature-set-ligatures '(prog-mode text-mode) '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
;; 						 ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
;; 						 "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
;; 						 "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
;; 						 "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
;; 						 "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
;; 						 "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
;; 						 "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
;; 						 "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
;; 						 "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
(ligature-set-ligatures 'prog-mode
                        '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                          ;; =:= =!=
                          ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                          ;; ;; ;;;
                          (";" (rx (+ ";")))
                          ;; && &&&
                          ("&" (rx (+ "&")))
                          ;; !! !!! !. !: !!. != !== !~
                          ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                          ;; ?? ??? ?:  ?=  ?.
                          ("?" (rx (or ":" "=" "\." (+ "?"))))
                          ;; %% %%%
                          ("%" (rx (+ "%")))
                          ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                          ;; |->>-||-<<-| |- |== ||=||
                          ;; |==>>==<<==<=>==//==/=!==:===>
                          ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                          "-" "=" ))))
                          ;; \\ \\\ \/
                          ("\\" (rx (or "/" (+ "\\"))))
                          ;; ++ +++ ++++ +>
                          ("+" (rx (or ">" (+ "+"))))
                          ;; :: ::: :::: :> :< := :// ::=
                          (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                          ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                          ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                          "="))))
                          ;; .. ... .... .= .- .? ..= ..<
                          ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                          ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                          ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                          ;; *> */ *)  ** *** ****
                          ("*" (rx (or ">" "/" ")" (+ "*"))))
                          ;; www wwww
                          ("w" (rx (+ "w")))
                          ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                          ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                          ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                          ;; << <<< <<<<
                          ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                          "-"  "/" "|" "="))))
                          ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                          ;; >> >>> >>>>
                          (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                          ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                          ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                       (+ "#"))))
                          ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                          ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                          ;; __ ___ ____ _|_ __|____|_
                          ("_" (rx (+ (or "_" "|"))))
                          ;; Fira code: 0xFF 0x12
                          ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                          ;; Fira code:
                          "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                          ;; The few not covered by the regexps.
                          "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))


;; Enables ligature checks globally in all buffers. You can also do it
;; per mode with `ligature-mode'.
(global-ligature-mode t)
(add-hook 'vhdl-mode-hook (lambda () (ligature-mode -1)))

;; Prettify symbols mode
(global-prettify-symbols-mode)
;;; Emacs lisp
(add-hook 'emacs-lisp-mode-hook (lambda () (setq prettify-symbols-alist '(("lambda" . "λ")
								     ("interactive" . "")
								     ;; ("lambda () (interactive)" . "λ")
								     ))))
;; (add-hook 'org-mode-hook (lambda () (setq prettify-symbols-alist '(("TODO" . "󰅇")
;; 							      ("DONE" . "󰅎")))))
;;; My functions and modes
;; ;;;; mkoppg
;; (defun mkoppg (fmt)
;;   "Make file with set file format named oppg-YEAR-MONTH-DAY.FILE_FORMAT."
;;   (interactive "sFile format: ")
;;   (find-file (s-concat (format-time-string "oppg-%Y-%m-%d.") fmt)))
;; (defun my/foot-here ()
;;   "open foot terminal"
;;   (interactive)
;;   (save-window-excursion
;;     (async-shell-command "foot")))

;;;; indent-buffer
(defun my/indent-buffer ()
  "Indent each nonblank line in the buffer."
  (interactive)
  (indent-region (point-min) (point-max)))


;;;; exwm
(defun my/exwm-workspace-next ()
  "Switch to next exwm workspace"
  (interactive)
  (exwm-workspace-switch (mod (1+ exwm-workspace-current-index) my/exwm-normal-workspace-number ))
  )

(defun my/exwm-workspace-prev ()
  "Switch to prev exwm workspace"
  (interactive)
  (exwm-workspace-switch (mod (1- exwm-workspace-current-index) my/exwm-normal-workspace-number ))
  )

(setq my/exwm-toggle-special--last-ws 0)
(defun my/exwm-toggle-special (&optional n)
  "toggle special workspace"
  (interactive)
  (unless n (setq n 0))
  (if (= exwm-workspace-current-index (+ n my/exwm-normal-workspace-number))
      ;; Toggle out
      (exwm-workspace-switch my/exwm-toggle-special--last-ws)
    (when (< exwm-workspace-current-index my/exwm-normal-workspace-number)
      ;; Not special, save
      (setq my/exwm-toggle-special--last-ws exwm-workspace-current-index))
    ;; Toggle in
    (exwm-workspace-switch (+ n my/exwm-normal-workspace-number))))

(defun my/exwm-copy ()
  "send copy, uses priv fns so might break"
  (interactive)
  (exwm-input--fake-key ?\C-c))

(defun my/eval-buffer ()
  "Execute the current buffer as Lisp code.
Top-level forms are evaluated with `eval-defun' so that `defvar'
and `defcustom' forms reset their default values."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (forward-sexp)
      (eval-defun nil))))


;; (require 'xdg)
;; (defun my/run-program ()
;;   ""
;;   (interactive)
;;   (let ((hash (make-hash-table :test #'equal))
;; 	(data-dirs (xdg-data-dirs))
;;         result)
;;     (dolist (dir data-dirs)
;;       (when (file-exists-p dir)
;;         (let ((dir (file-name-as-directory dir)))
;;           ;; Function `directory-files-recursively' added in Emacs 25.1.
;;           (dolist (file (directory-files-recursively dir "\\.desktop\\'"))
;;             (let ((id (subst-char-in-string ?/ ?- (file-relative-name file dir))))
;;               (when (and (not (gethash id hash)) (file-readable-p file))
;;                 (push (cons id file) result)
;;                 (puthash id file hash)))))))
;;     (prin1 result))
;;   )
;; ;; (completing-read "Run: " '(("a") ("b") ("c"))))

;;;; Center document
(defvar center-document-desired-width 100
  "The desired width of a document centered in the window.")
(add-hook 'org-mode-hook (lambda ()
			   (make-local-variable 'center-document-desired-width)
			   (setq center-document-desired-width 80)))

(defun center-document--adjust-margins ()
  ;; Reset margins first before recalculating
  (set-window-parameter nil 'min-margins nil)
  (set-window-margins nil nil)

  ;; Adjust margins if the mode is on
  (when center-document-mode
    (let ((margin-width (max 0
			     (truncate
			      (/ (- (window-width)
				    center-document-desired-width)
				 2.0)))))
      (when (> margin-width 0)
	(set-window-parameter nil 'min-margins '(0 . 0))
	(set-window-margins nil margin-width margin-width)))))

(define-minor-mode center-document-mode
  "Toggle centered text layout in the current buffer."
  :lighter " Centered"
  :group 'editing
  (if center-document-mode
      (add-hook 'window-configuration-change-hook #'center-document--adjust-margins 'append 'local)
    (remove-hook 'window-configuration-change-hook #'center-document--adjust-margins 'local))
  (center-document--adjust-margins))

(add-hook 'text-mode-hook #'center-document-mode)
(add-hook 'prog-mode-hook #'center-document-mode)
(add-hook 'text-mode-hook (lambda () (setq center-document-desired-width 120)))
(add-hook 'prog-mode-hook (lambda () (setq center-document-desired-width 120)))



;;;; Hide-outline-body-mode
(define-minor-mode my/hide-outline-body-mode
  "Hides outline bodies"
  :global t
  (if my/hide-outline-body-mode
      (outline-hide-body)
    (outline-show-all)
    )
  )
;;; Keybinds
;;;; Keybind Packages
					;(require 'ryo-combobulate)
(require 'cerberus)
					;(cerberus-global-mode)
(straight-use-package 'meow)
(straight-use-package 'meow-tree-sitter)
(require 'meow-tree-sitter)
(meow-tree-sitter-register-defaults)
;; (straight-use-package 'combobulate)
;; (straight-use-package 'paredit)

(require 'meow)
(setq meow-cheatsheet-layout meow-cheatsheet-layout-colemak-dh)

(add-to-list 'meow-mode-state-list '(eshell-mode . insert))
(add-to-list 'meow-mode-state-list '(eat-mode . insert))

(meow-motion-overwrite-define-key
 '("n" . meow-next)
 '("e" . meow-prev)
 '("SPC" . hydra-leader/body)
 '("<escape>" . ignore))

(defun meow-negative-find () (interactive)
       (let ((current-prefix-arg -1)) (call-interactively 'meow-find)))

(defun meow-negative-line () (interactive)
       (let ((current-prefix-arg -1)) (call-interactively 'meow-line)))

(defun meow-tab-dwim () (interactive)
       ;; (call-interactively 'negative-argument))
       (if meow--selection
	   (call-interactively 'meow-reverse)
	 (cond ((if (eq major-mode 'org-mode) (org-at-heading-p) nil) (call-interactively 'org-cycle))
	       (t (call-interactively 'negative-argument)))))

(defun narrow-dwim () (interactive)
       (cond ((eq major-mode 'org-mode) (org-narrow-to-subtree))
	     ((bound-and-true-p outshine-mode) (outshine-narrow-to-subtree))
	     (t (narrow-to-defun))))

(defun testtest () (interactive)
       (widen))

(defun toggle-narrow-dwim () (interactive)
       (if (buffer-narrowed-p)
	   (widen)
	 (narrow-dwim)))

(defun my/meow-open-below ()
  "Open a newline below and switch to INSERT state."
  (interactive)
  (if meow--temp-normal
      (progn
        (message "Quit temporary normal mode")
        (meow--switch-state 'motion))
    (meow--switch-state 'insert)
    (goto-char (line-end-position))
    (call-interactively 'newline)))

(defun meow-interactive-next-thing (thing)
  "Select the next THING."
  (interactive (list (meow-thing-prompt "Next: ")))
  (save-window-excursion
    (meow-next-thing meow-symbol-thing '(select . transient) 1)))



;; (defun meow-esc-dwim () (interactive)
;;        (if meow--selection
;; 	   (call-interactively 'meow-cancel-selection)
;; 	 (call-interactively 'meow-append)))
(dolist (k '("C-i" "C-m"))
  (define-key input-decode-map (kbd k) (kbd (concat "<" k ">"))))

(meow-leader-define-key
 '("?" . meow-cheatsheet)
 ;; To execute the originally e in MOTION state, use SPC e.  '("e" . "H-e")
 '("1" . meow-digit-argument)
 '("2" . meow-digit-argument)
 '("3" . meow-digit-argument)
 '("4" . meow-digit-argument)
 '("5" . meow-digit-argument)
 '("6" . meow-digit-argument)
 '("7" . meow-digit-argument)
 '("8" . meow-digit-argument)
 '("9" . meow-digit-argument)
 '("0" . meow-digit-argument))

(meow-normal-define-key
 '("<escape>" . meow-cancel-selection)
 '("0" . meow-expand-0)
 '("1" . meow-expand-1)
 '("2" . meow-expand-2)
 '("3" . meow-expand-3)
 '("4" . meow-expand-4)
 '("5" . meow-expand-5)
 '("6" . meow_expand-6)
 '("7" . meow-expand-7)
 '("8" . meow-expand-8)
 '("9" . meow-expand-9)

 '("<escape>" . meow-cancel-selection)
 '("0" . meow-expand-0)
 '("1" . meow-expand-1)
 '("2" . meow-expand-2)
 '("3" . meow-expand-3)
 '("4" . meow-expand-4)
 '("5" . meow-expand-5)
 '("6" . meow_expand-6)
 '("7" . meow-expand-7)
 '("8" . meow-expand-8)
 '("9" . meow-expand-9)
 
 '("<tab>" . meow-tab-dwim)
 '("q" . meow-quit)
 '("w" . meow-mark-word)
 '("W" . meow-mark-symbol)
 '("f" . meow-next-symbol)
 '("F" . meow-next-word)
 '("p" . meow-yank)
 '("b" . meow-back-symbol)
 '("B" . meow-back-word)
 '("j" . meow-join)
 '("l" . meow-line)
 '("L" . meow-negative-line)
 '("u" . meow-undo)
 '("U" . meow-undo-in-selection)
 '("y" . meow-save)
 '("'" . repeat)

 '("a" . meow-insert)
 '("A" . meow-open-above)
 '("r" . meow-replace)
 '("R" . undo-redo)
 '("s" . meow-find)
 '("S" . meow-negative-find)
 '("t" . meow-append)
 '("T" . my/meow-open-below)
 '("g" . meow-cancel-selection)
 '("G" . meow-grab)
 '("m" . meow-left)
 '("M" . meow-left-expand)
 '("n" . meow-next)
 '("N" . meow-next-expand)
 '("e" . meow-prev)
 '("E" . meow-prev-expand)
 '("i" . meow-right)
 '("I" . meow-right-expand)
 '("o" . meow-block)
 '("O" . meow-to-block)
 '("(" . meow-beginning-of-thing)
 '(")" . meow-end-of-thing)

 '("z" . meow-pop-selection)
 '("x" . meow-delete)
 '("X" . meow-backward-delete)
 '("d" . meow-kill)
 '("c" . meow-change)
 '("v" . meow-visit)
 '("/" . consult-line)
 '("h" . meow-search)
 '("H" . meow-mark-symbol)
 '("," . meow-inner-of-thing)
 '("." . meow-bounds-of-thing)
 '("-" . meow-tab-dwim)

 '("SPC" . hydra-leader/body)
 )

(meow-define-keys 'insert
  ;; '("<tab>" . completion-at-point)
  '("<C-m>" . meow-left)
  '("C-n" . next-line)
  '("C-e" . meow-prev)
  '("<C-i>" . meow-right)
  )

(meow-global-mode)

;; (define-key prog-mode-map (kbd "<return>") #'newline)

(setq meow-keypad-leader-dispatch "H-C-M-1") ; More or less disable keypad
;; (define-key mode-specific-map (kbd "t") #'toggle-narrow-dwim)

(define-key prog-mode-map (kbd "<tab>") #'completion-at-point)

(define-key emacs-lisp-mode-map (kbd "C-<return>") #'eval-region)

(define-key vertico-map (kbd "C-n") #'vertico-next)
(define-key vertico-map (kbd "C-e") #'vertico-previous)

(define-key org-mode-map (kbd "<tab>") #'org-cycle)
(define-key org-mode-map (kbd "M-m") #'org-metaleft)
(define-key org-mode-map (kbd "M-n") #'org-metadown)
(define-key org-mode-map (kbd "M-e") #'org-metaup)
(define-key org-mode-map (kbd "M-i") #'org-metaright)
(define-key org-mode-map (kbd "C-M-m") #'org-shiftright)
(define-key org-mode-map (kbd "C-M-i") #'org-shiftleft)
(define-key org-mode-map (kbd "<C-m>") #'outline-up-heading)
(define-key org-mode-map (kbd "<return>") #'newline)
(define-key org-mode-map (kbd "C-n") #'outline-forward-same-level)
(define-key org-mode-map (kbd "C-e") #'outline-backward-same-level)
(define-key org-mode-map (kbd "<C-i>") #'outline-next-visible-heading)
(define-key org-mode-map (kbd "M-<return>") (lambda () (interactive) (org-meta-return) (meow-insert)))
(define-key org-mode-map (kbd "C-<return>") (lambda () (interactive) (org-insert-heading-respect-content) (meow-insert)))


(define-key org-cdlatex-mode-map (kbd "<tab>") #'cdlatex-tab)
(define-key org-cdlatex-mode-map (kbd "C-d") (lambda () (interactive) (cdlatex-dollar) (meow-insert)))
(define-key org-cdlatex-mode-map (kbd "C-a") (lambda () (interactive) (cdlatex-environment "align*")))
(define-key org-cdlatex-mode-map (kbd "C-s") #'cdlatex-math-symbol)
(define-key org-cdlatex-mode-map (kbd "C-f") #'cdlatex-math-modify)

(define-key outline-minor-mode-map (kbd "C-m") #'outline-up-heading)
(define-key outline-minor-mode-map (kbd "C-n") #'outline-forward-same-level)
(define-key outline-minor-mode-map (kbd "C-e") #'outline-backward-same-level)
(define-key outline-minor-mode-map (kbd "C-i") #'outline-next-visible-heading)

;; (define-key eshell-mode-map (kbd "RET") #'eshell-send-input)

(setq meow-goto-line-function 'consult-goto-line)
(setq meow-use-clipboard t)
(setq meow-cursor-type-default 'box)
(setq meow-cursor-type-normal '(bar . 2))
(setq meow-cursor-type-motion 'box)
(setq meow-cursor-type-insert '(bar . 2))
(setq meow-cursor-type-keypad 'hollow)

;; Fix because meow goes by binds and not fns
(keymap-global-set "H-f" 'forward-char)
(setq meow--kbd-forward-char "H-f")
(keymap-global-set "H-n" 'next-line)
(setq meow--kbd-forward-line "H-n")
(keymap-global-set "H-w" 'delete-char)
(setq meow--kbd-delete-char "H-w")





;; (meow-global-mode 1)

;; (straight-use-package 'general)         ; Keybind wrapper
;; (general-auto-unbind-keys)              ; Fixes some prefix key issues

(straight-use-package 'hydra)
(straight-use-package 'pretty-hydra)


;; ;;;;; DocView
;; (general-def 'doc-view-mode-map
;;   "SPC"  'hydra-leader/body
;;   "n" 'doc-view-next-page
;;   "e" 'doc-view-previous-page
;;   "gg" 'doc-view-first-page
;;   "G" 'doc-view-last-page
;;   )

;; (general-def 'pdf-view-mode-map
;;   "SPC"  'hydra-leader/body
;;   "n" 'pdf-view-next-page-command
;;   "e" 'pdf-view-previous-page-command
;;   "gg" 'pdf-view-first-page
;;   "G" 'pdf-view-last-page
;;   )

;;;;; EXWM
(defun my/pactl-volume ()
  (interactive)
  (let ((pactl-output (shell-command-to-string "pactl get-sink-volume 0")))
    (string-match (rx (group line-start "Volume: front-left: " (1+ digit) " / " (0+ " ")
			     (group (1+ digit) "%")))
		  pactl-output)

    (message "%s" (match-string 2 pactl-output))))

;; C-d => C-c
(exwm-input-set-simulation-key [?\C-d] [?\C-c])

(setq exwm-input-global-keys
      `((,(kbd "S-ESC") . my/exwm-copy)

	(,(kbd "<XF86MonBrightnessDown>") . (lambda () (interactive) (let ((default-directory "~")) (async-shell-command "light -U 10"))))
	(,(kbd "<XF86MonBrightnessUp>") . (lambda () (interactive) (let ((default-directory "~")) (async-shell-command "light -A 10"))))

	(,(kbd "<XF86MonBrightnessDown>") . (lambda () (interactive) (let ((default-directory "~")) (async-shell-command "light -U 10"))))
	(,(kbd "<XF86MonBrightnessUp>") . (lambda () (interactive) (let ((default-directory "~")) (async-shell-command "light -A 10"))))
	(,(kbd "<XF86AudioRaiseVolume>") . (lambda () (interactive) (let ((default-directory "~")) (shell-command "pactl set-sink-volume 0 +2%") (my/pactl-volume))))
	(,(kbd "<XF86AudioLowerVolume>") . (lambda () (interactive) (let ((default-directory "~")) (shell-command "pactl set-sink-volume 0 -2%") (my/pactl-volume))))
	(,(kbd "<XF86AudioMute>") . (lambda () (interactive) (let ((default-directory "~")) (async-shell-command "pactl set-sink-mute 0 toggle"))))
	
	(,(kbd "s-u") . enlarge-window-horizontally)
	(,(kbd "s-l") . shrink-window-horizontally)

	(,(kbd "s-SPC") . hydra-leader/body)

	(,(kbd "s-m") . other-window)
	(,(kbd "s-n") . next-buffer)
	(,(kbd "s-e") . previous-buffer)
	(,(kbd "s-i") . other-window)

	;; (,(kbd "s-t") . (lambda () (interactive) (save-window-excursion (let ((default-directory "~")) (async-shell-command "")))))

	(,(kbd "s-s") . my/exwm-toggle-special)
	(,(kbd "s-t") . (lambda () (interactive) (my/exwm-toggle-special 1)))
	(,(kbd "s-d") . kill-buffer-and-window)
	(,(kbd "s-f") . exwm-layout-toggle-fullscreen)

	(,(kbd "s-k") . my/exwm-workspace-prev)
	(,(kbd "s-h") . my/exwm-workspace-next)

	,@(mapcar (lambda (i)
		    `(,(kbd (format "s-%d" (1+ i))) .
		      (lambda ()
			(interactive)
			(exwm-workspace-switch ,i))))
		  (number-sequence 0 my/exwm-normal-workspace-number))


	,@(let ((shift-list  '("!" "@" "#" "$" "%" "&" "/" "*" "(")))
	    (mapcar (lambda (i)
		      `(,(kbd (format "s-%s" (nth i shift-list))) .
			(lambda ()
			  (interactive)
			  (exwm-workspace-move-window ,i))))
		    (number-sequence 0 my/exwm-normal-workspace-number)))

	))

;;;; Hydras
;;;;; Leader Hydra
(pretty-hydra-define hydra-leader (:color blue :idle 1)
  ;; ("SPC" projectile-find-file)		; find file in project
  ("EMACS"
   (("ESC" restart-emacs "restart emacs")
    ("w" hydra-window/body "window")
    ("b" hydra-buffer/body "buffer")
    ("h" hydra-help/body "help")
    (";" execute-extended-command "M-x")
    ("'" pp-eval-expression "M-:")
    ("s" basic-save-buffer "save")		; Save
    ("<tab>" toggle-narrow-dwim "Toggle Narrowing"))
   ;; ("p" hydra-projectile/body)
   "editing"
   (("g" hydra-go/body "go")
    ("o" hydra-outline/body "outline")
    ("p" hydra-projectile/body "project")
    ("e" hydra-eglot/body "eglot")
    ("c" comment-dwim "comment"))
   "misc"
   (("SPC" recentf "recent file")
    ("." find-file "find file")
    ("t" eshell "eshell")
    ("r" async-shell-command "run")
    ("d" dired "dired"))
   )
  )

;;;;; Window Hydra
(pretty-hydra-define hydra-window (:color blue :idle 1)
  ("Select"
   (("n" other-window "next"))
   "Split"
   (("h" split-window-below "hor. split")
    ("i" split-window-right "ver. split"))
   "Delete"
   (("d" delete-window "delete")
    ("D" delete-other-windows "delete other"))
   )
  )

;;;;; Buffer Hydra
(pretty-hydra-define hydra-buffer (:color blue :idle 1)
  ("Buffer"
   (("SPC" consult-buffer "consult")
    ("k" kill-current-buffer "kill")
    ("b" mode-line-other-buffer "other")
    ("i" my/indent-buffer "indent buffer")
    ("e" my/eval-buffer "eval buffer"))
   )
  )

;;;;; Help Hydra
(pretty-hydra-define hydra-help (:color blue :idle 1)
  ("Help"
   (("k" describe-key "key")
    ("a" consult-apropos "apropos")
    ("f" describe-function "function")
    ("v" describe-variable "variable")
    ("m" describe-keymap "keymap"))
   )
  )

;;;;; Projectile Hydra
(pretty-hydra-define hydra-projectile (:color blue :idle 1)
  ("Projectile"
   (("SPC" projectile-switch-project "switch")
    ("a" projectile-add-known-project "add")
    ("c" projectile-compile-project "compile")
    ("g" consult-grep "replace")
    ("m" magit "magit")
    ("r" projectile-replace-regexp "replace")
    ("s" projectile-save-project-buffers "save")
    ("t" projectile-run-eshell "eshell"))))

;; ;;;;; Projectile Hydra
;; (defhydra hydra-projectile (:color blue :idle 1)
;;   ("SPC" projectile-switch-project)
;;   ("a" projectile-add-known-project)
;;   ("i" projectile-invalidate-cache)
;;   ("d" projectile-remove-known-project)
;;   ("k" projectile-remove-known-project)
;; )

;;;;; Outline/Org Hydra
(pretty-hydra-define hydra-outline (:color blue :idle 1)
  ("Edit"
   (("m" outline-promote "promote")
    ("i" outline-demote "demote")
    ("n" outline-move-subtree-down "move down")
    ("e" outline-move-subtree-up "move up")
    ("a" outline-insert-heading "insert"))
   "Misc"
   (("SPC" consult-outline "consult")		; go to outline header
    ("t" my/hide-outline-body-mode "toggle bodies")
    ("c" org-agenda "agenda")
    ("l" hydra-org-latex/body "latex hyra"))
   "Display"
   (("p" org-toggle-inline-images "toggle inline images"))
   )
  )

(pretty-hydra-define hydra-org-latex  (:color blue :idle 1)
  ("resize"
   (("e" xenops-increase-size "+" :color red)
    ("n" xenops-decrease-size "-" :color red))
   "edit"
   (("b" cdlatex-environment "begin"))
   )
  )


;; ;;;;; LSP Hydra
;; (defhydra hydra-lsp (:color blue :idle 1)
;;   ("r" lsp-rename)
;;   ("e" consult-lsp-diagnostics)
;; )

;;;;; Go Hydra
(pretty-hydra-define hydra-go (:color blue :idle 1)
  ("Go"
   (("f" find-file-at-point "file")
    ("d" xref-find-definitions "definition")
    ("r" xref-find-references "references")
    ("u" xref-go-back "back"))
   "Markers"
   (("a" evil-set-marker "set marker")
    ("m" evil-goto-mark-line "go to marker")
    ("n" evil-next-mark-line "next marker")
    ("e" evil-previous-mark-line "previous marker")
    ("l" evil-show-marks "list markers"))
   "Other"
   (("SPC" consult-imenu "consult"))
   )
  )

;;;;; Eglot Hydra
(pretty-hydra-define hydra-eglot (:color blue :idle 1)
  ("Eglot"
   (("f" eglot-code-action-quickfix "quickfix")
    ("d" eldoc "doc")
    ("r" eglot-rename "rename"))
   )
  )


(exwm-enable)

;; init.el ends here




(put 'narrow-to-region 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
