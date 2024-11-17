;; init.el
;; TODO company kinda wonkey but works
;; TODO color hex colors
;; TODO -nw support
;; mickeynp/combobulate
;; TODO modernemacs.com
;; TODO svg todo and header
;; emacs 29:
;; TODO smooth scroll
;; TODO new lsp and tree-sitter stuffs
;;; Init stuff
;; Increasing garbage collection threshold during startup significantly lowers init times.
(setq gc-cons-threshold (* 50 1000 1000))	; 100MB
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold (* 2 1000 1000)))) ; 2MB

;; Straight
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

;;; Misc.
(setq ring-bell-function 'ignore)	; Turn off beep

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; (desktop-save-mode 1)		; Save open windows and buffers
;; (setq frame-resize-pixelwise t) 	; Play nice with tiling wms

(straight-use-package 'project)		; eglot breaks without this

(straight-use-package 'smartparens)	; Close brackets
(require 'smartparens-config)
(add-hook 'prog-mode-hook 'smartparens-mode)

(setq evil-undo-system 'undo-redo)	; Evil redo

(straight-use-package 'pdf-tools)
(pdf-loader-install) ; On demand loading, leads to faster startup time


(straight-use-package 'dashboard)
(dashboard-setup-startup-hook)
(setq dashboard-startup-banner 'logo)
(setq dashboard-projects-backend 'project-el)
(setq dashboard-items '((recents  . 5)
                        (projects . 5)))
(add-hook 'dashboard-mode 'dashboard-jump-to-recents)

(savehist-mode)

(setq dired-recursive-deletes 'always)
(setq dired-dwim-target 't)
(setq delete-by-moving-to-trash 't)

(straight-use-package 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(add-to-list 'display-buffer-alist '("*Async Shell Command*" display-buffer-no-window (nil)))
(setq async-shell-command-buffer 'rename-buffer)

(straight-use-package 'bluetooth)

(recentf-mode)				; dashboard mode forgets tramp files else



(straight-use-package
 '(eat :files ("*.el" ("term" "term/*.el") "*.texi"
               "*.ti" ("terminfo/e" "terminfo/e/*")
               ("terminfo/65" "terminfo/65/*")
               ("integration" "integration/*")
               (:exclude ".dir-locals.el" "*-tests.el"))))


;;;; Org mode
;;;;; outshine
(straight-use-package 'outshine)	; Comment headers
(add-hook 'prog-mode-hook 'outshine-mode)

;;;;; org main
(straight-use-package 'org)
(require 'org)
(add-hook 'org-mode-hook 'org-indent-mode)

;;;;; org latex
(straight-use-package 'cdlatex)
(straight-use-package 'xenops)
(straight-use-package 'auctex)
(add-hook 'org-mode-hook #'turn-on-org-cdlatex)
(add-hook 'org-mode-hook #'xenops-mode)
(setq org-preview-latex-default-process 'dvisvgm)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))
(setq xenops-math-image-scale-factor 1.3)
(setq cdlatex-command-alist
      '(("vc" "Insert \\vec{}" "\\vec{?}" cdlatex-position-cursor nil nil t)
	("int" "Insert integral" "\\int \\limits_{?}^{} \\,{}" cdlatex-position-cursor nil nil t)
	("aln" "Insert align* env" "" cdlatex-environment ("align*") t nil)
	))
(setq cdlatex-math-modify-alist
      '((98 "\\mathbb" nil t nil nil)))
(setq org-agenda-files (directory-files-recursively "~/Documents/" "\\.org$"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(custom-enabled-themes '(dracula))
 '(org-agenda-files
   '("/home/karl/Documents/uni/wi24/orga.org" "/home/karl/Documents/uni/wi24/sus/tut1.org"))
 '(org-babel-load-languages '((emacs-lisp . t) (C . t) (python . t)))
 '(org-confirm-babel-evaluate nil)
 '(warning-suppress-types '((frameset))))

;;;;; org agenda
(setq org-agenda-window-setup 'current-window)

;;; EXWM
(straight-use-package 'exwm)
(require 'exwm)
(setq exwm-workspace-index-map (lambda (i) (number-to-string (1+ i))))
(setq my/exwm-normal-workspace-number 4)
(setq my/exwm-special-workspace-number 1)
(setq exwm-workspace-number (+ my/exwm-normal-workspace-number my/exwm-special-workspace-number))

;; Make buffer name more meaningful
(add-hook 'exwm-update-class-hook
          (lambda ()
            (exwm-workspace-rename-buffer exwm-class-name)))

(setq exwm-layout-show-all-buffers t)
(setq exwm-workspace-show-all-buffers t)

(setq exwm-input-simulation-keys
      '(([a] . [b])
	))

(setq exwm-manage-configurations
      '(((string= exwm-class-name "Spotify") workspace 4)
        ;; ((string= exwm-class-name "firefox") char-mode t)
	))


(add-hook 'exwm-init-hook (lambda () (interactive)
			    (async-shell-command "spotify")
			    ))





;;; Completion Framework
(straight-use-package 'vertico)         ; Completion framework
(vertico-mode)
(setq-default vertico-count 25)		; Show 25 options
(setq read-file-name-completion-ignore-case t ; Be case insensitive
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

(straight-use-package 'savehist)        ; Save history for completion framework
(savehist-mode)

(straight-use-package 'marginalia)	; Show explanations in vertico margin
(marginalia-mode)

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


(straight-use-package 'orderless)       ; Complete by searching for space-separated snippets
(setq completion-styles '(orderless basic)
      completion-caterogy-defaults nil
      completion-category-overrides '((file (stylef partial-completion))))

;;; IDE tools
(require 'project)
(setq project-switch-commands 'project-find-file)

(straight-use-package 'direnv)
(direnv-mode)

;;;; Tree sitter
;; (require 'treesit)
;; (straight-use-package 'treesit-auto)
;; (require 'treesit-auto)
;; (global-treesit-auto-mode)
;; (setq treesit-auto-install 'prompt)

;;;; LSP
;; (setq read-process-output-max (* 1024 1024)) ; Better performance
;; (straight-use-package 'lsp-mode)
;; (setq lsp-headerline-breadcrumb-segments '(project file symbols))
;; (straight-use-package 'consult-lsp)
(straight-use-package 'eglot)

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
(global-hl-line-mode)			; Highlight current line
(add-to-list 'default-frame-alist '(font . "fira code nerd font-13")) ; Font

;; (setq inhibit-startup-message t)	; Disable splash screen
;; (setq initial-scratch-message nil)

(setq-default display-line-numbers 'relative) ; Show line numbers
(setq-default display-line-numbers-width 3)


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


;; ;;;;; Gruvbox
;; ;;;;;; Light
;; (defun gruv-light ()
;;   (interactive)
;;   (straight-use-package 'gruvbox-theme)
;;   (load-theme 'gruvbox-light-medium t)

;;   (custom-theme-set-faces
;;    'gruvbox-light-medium
;;    '(outshine-level-1 ((t (
;; 			   :foreground "#d65d0e"
;; 			   ))))
;;    '(outshine-level-2 ((t (
;; 			   :foreground "#d79921"
;; 			   ))))
;;    '(outshine-level-3 ((t (
;; 			   :foreground "#458588"
;;  			   ))))
;;    '(outshine-level-4 ((t (
;; 			   :foreground "#689d6a"
;; 			   ))))
;;    '(outshine-level-5 ((t (
;; 			   :foreground "#98971a"
;; 			   ))))
;;    )
;;   (enable-theme 'gruvbox-light-medium)
;;   )

;;;;;; Dark
;; (defun gruv-dark ()
;; (interactive)
;; (straight-use-package 'gruvbox-theme)
;; (load-theme 'gruvbox-dark-medium t)
					;
;;   (custom-theme-set-faces
;;    'gruvbox-dark-medium
;;    '(outshine-level-1 ((t (
;; 			   :foreground "#ff8700"
;; 			   ))))
;;    '(outshine-level-2 ((t (
;; 			   :foreground "#ffaf00"
;; 			   ))))
;;    '(outshine-level-3 ((t (
;; 			   :foreground "#87afaf"
;; 			   ))))
;;    '(outshine-level-4 ((t (
;; 			   :foreground "#87af87"
;; 			   ))))
;;    '(outshine-level-5 ((t (
;; 			   :foreground "#afaf00"
;; 			   ))))
;;    )
;;   (enable-theme 'gruvbox-dark-medium)
;;   )

;; (defun lightmode ()
;;   (interactive)
;;   (catppuccin)
;; (setq catppuccin-flavor 'latte) ;; or 'latte, 'macchiato, or 'mocha
;; (catppuccin-reload)
;; )

(defun darkmode ()
  (interactive)
  (dracula))

(darkmode)


;; ;;;; Margins
;; (straight-use-package 'perfect-margin)
;; (require 'perfect-margin)
;; (setq perfect-margin-visible-width 120)
;; (perfect-margin-mode 1)
;; (add-hook 'org-mode-hook 'visual-line-mode)

;;;; Indenting guide
(straight-use-package 'highlight-indent-guides)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)
(setq highlight-indent-guides-auto-character-face-perc 30)
(setq highlight-indent-guides-responsive 'top)
(setq highlight-indent-guides-delay 0)
(setq highlight-indent-guides-auto-top-character-face-perc 60)

;;;; Modeline
(straight-use-package 'doom-modeline)
(setq doom-modeline-height 31)
(setq doom-modeline-bar-width 8)
(setq doom-modeline-buffer-file-name-style 'truncate-nil)
(setq doom-modeline-buffer-state-icon nil)
(setq doom-modeline-buffer-encoding nil)
(display-battery-mode)
(setq display-time-24hr-format t)
(display-time)
(straight-use-package 'exwm-modeline)
(add-hook 'exwm-init-hook #'exwm-modeline-mode)
(doom-modeline-mode)

;;;; Outline
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(outshine-level-1 ((t (:family "Victor Mono" :height 1.75 :weight extra-bold :slant italic :underline t))))
 '(outshine-level-2 ((t (:family "Victor Mono" :height 1.5 :weight extra-bold :slant italic :underline t))))
 '(outshine-level-3 ((t (:family "Victor Mono" :height 1.25 :weight bold :slant italic :underline t))))
 '(outshine-level-4 ((t (:family "Victor Mono" :weight bold :height 1.25 :weight bold :slant italic :underline t))))
 '(outshine-level-5 ((t (:family "Victor Mono" :height 1.0 :weight bold :slant italic :underline t)))))

;; ;;;; Org-mode
;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.75))

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

;; ;;;; Symbols
;; ;; NOTE https://raw.githubusercontent.com/jming422/fira-code-mode/master/fonts/FiraCode-Regular-Symbol.otf
;; ;;;;; Fira Code ligatures
;; (add-hook 'haskell-mode-hook 'my-set-hasklig-ligatures)
;; (straight-use-package '(ligature :type git :host github :repo "mickeynp/ligature.el"))
;; (global-ligature-mode)
;; ;;;;;; Fundamental mode
;; (ligature-set-ligatures 't '("www" "Fl" "Tl" "fi" "fj" "fl"))
;; ;;;;;; Prog mode
;; (ligature-set-ligatures 'prog-mode '("++" "--" "**" "&&" "||" "||="
;; 				     "->" "=>" "::" "__"
;; 				     "==" "===" "!=" "=/="
;; 				     "<<" "<<<" ">>" ">>>" "|=" "^="
;; 				     "<=" ">=" "<=>"
;; 				     ":="
;; 				     ))
;; ;;;;;; Org-mode
;; (ligature-set-ligatures 'org-mode '("<=" ">=" "<=>"))
;; ;;;;;; HTML
;; (ligature-set-ligatures '(html-mode nxml-mode web-mode) '("</" "<!--" "</>" "-->" "/>"))
;; ;;;;;; Emacs lisp
;; (ligature-set-ligatures 'emacs-lisp-mode '(";;"))
;; ;;;;; Prettify symbols mode
;; (global-prettify-symbols-mode)
;; ;;;;;; Emacs lisp
;; (add-hook 'emacs-lisp-mode-hook (lambda () (setq prettify-symbols-alist '(
;; 									  ("lambda" . ?λ)
;; 									  ))))

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
(defun my/exwm-toggle-special ()
  "toggle special workspace"
  (interactive)
  (if (equal exwm-workspace-current-index my/exwm-normal-workspace-number)
      (exwm-workspace-switch my/exwm-toggle-special--last-ws)
    (setq my/exwm-toggle-special--last-ws exwm-workspace-current-index)
    (exwm-workspace-switch my/exwm-normal-workspace-number)))

(defun my/exwm-copy ()
  "send copy, uses priv fns so might break"
  (interactive)
  (exwm-input--fake-key ?\C-c))

(require 'xdg)
(defun my/run-program ()
  ""
  (interactive)
  (let ((hash (make-hash-table :test #'equal))
	(data-dirs (xdg-data-dirs))
        result)
    (dolist (dir data-dirs)
      (when (file-exists-p dir)
        (let ((dir (file-name-as-directory dir)))
          ;; Function `directory-files-recursively' added in Emacs 25.1.
          (dolist (file (directory-files-recursively dir "\\.desktop\\'"))
            (let ((id (subst-char-in-string ?/ ?- (file-relative-name file dir))))
              (when (and (not (gethash id hash)) (file-readable-p file))
                (push (cons id file) result)
                (puthash id file hash)))))))
    (prin1 result))
  )
;; (completing-read "Run: " '(("a") ("b") ("c"))))




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

(straight-use-package 'evil)            ; vim emulation
(straight-use-package 'evil-snipe)	; snipe letter
(setq evil-snipe-scope 'whole-visible)
(setq evil-snipe-enable-highlight nil)
(setq evil-snipe-enable-incremental-highlight nil)
(evil-mode)
(evil-set-initial-state 'dashboard-mode 'emacs)

(straight-use-package 'general)         ; Keybind wrapper
(general-auto-unbind-keys)              ; Fixes some prefix key issues

(straight-use-package 'hydra)
(straight-use-package 'pretty-hydra)


(defun fix-ci-cm ()			; C-i and C-m are identical to TAB and RET. This moves C-i and C-m to H-i and C-m. Doesnt work in TTY mode
  (define-key input-decode-map (kbd "C-i") (kbd "H-i"))
  (define-key input-decode-map (kbd "C-m") (kbd "H-m")))
(add-hook 'window-setup-hook 'fix-ci-cm) ; Run fix-ci-cm for each new frame. Cant just run in init when using emacs as a server.


;;;; Binds
;;;;; Evil
(general-def '(normal visual motion)
  "m" 'evil-backward-char
  "n" 'evil-next-line
  "e" 'evil-previous-line
  "i" 'evil-forward-char

  "f" 'evil-forward-WORD-end
  "b" 'evil-backward-WORD-begin

  "k" 'evil-search-next
  "K" 'evil-search-previous

  "s" 'evil-snipe-s
  "S" 'evil-snipe-S

  "(" 'evil-jump-item			; matching bracket


  "H-m" 'outline-up-heading
  "C-n" 'outline-forward-same-level
  "C-e" 'outline-backward-same-level
  "H-i" 'outline-next-visible-heading

  "/" 'consult-line

  "SPC" nil
  "C-d" nil
  )

(general-def 'normal
  "a" 'evil-insert
  "A" 'evil-insert-line
  "t" 'evil-append
  "T" 'evil-append-line
  )

(general-def 'visual
  "A" 'evil-insert
  "T" 'evil-append
  )

(general-def 'insert
  "H-m" 'left-char
  "C-n" 'next-line
  "C-e" 'previous-line
  "H-i" 'right-char
  "C-S-m" 'left-word
  "C-S-n" 'forward-paragraph
  "C-S-e" 'backward-paragraph
  "C-S-i" 'right-word
  )

;;;;; Eglot
(general-def eglot-mode-map
  "TAB" 'completion-at-point)

;;;;; lisp
(general-def emacs-lisp-mode-map
  "TAB" 'completion-at-point)

;;;;; Vertico
(general-def vertico-map
  "C-n" 'vertico-next
  "C-e" 'vertico-previous)

;; ;;;; Company
;; (general-def company-mode-map
;;   "C-t" 'company-select-next
;;   "C-s" 'company-select-previous
;;   )

;;;;; Dired
(general-def dired-mode-map
  "n" 'dired-next-line
  "e" 'dired-previous-line
  "SPC" 'hydra-leader/body
  "/" 'dired-goto-file
  )
(general-def 'visual dired-mode-map
  "m" 'dired-mark			; normal behaviour, needs to be doubled down on cause idk
  )

;;;;; Org-mode
(general-def '(normal insert) org-mode-map
  "<tab>" 'org-cycle
  "M-m" 'org-metaleft
  "M-n" 'org-metadown
  "M-e" 'org-metaup
  "M-i" 'org-metaright
  )

(general-def '(normal) org-mode-map
  "M" 'org-shiftleft
  "I" 'org-shiftright
  )

;;;;; Org CDLaTeX
(general-def '(insert) org-cdlatex-mode-map
  "<tab>" 'cdlatex-tab
  "C-l" 'cdlatex-dollar
  )

(general-def  org-cdlatex-mode-map
  "C-l" 'org-latex-preview)

;;;;; Hydras
(general-def '(normal visual motion)
  "SPC" 'hydra-leader/body)
(general-def '(insert replace operator)
  "C-SPC" 'hydra-leader/body)

;;;;; DocView
(general-def 'doc-view-mode-map
  "SPC"  'hydra-leader/body
  "n" 'doc-view-next-page
  "e" 'doc-view-previous-page
  "gg" 'doc-view-first-page
  "G" 'doc-view-last-page
  )

(general-def 'pdf-view-mode-map
  "SPC"  'hydra-leader/body
  "n" 'pdf-view-next-page-command
  "e" 'pdf-view-previous-page-command
  "gg" 'pdf-view-first-page
  "G" 'pdf-view-last-page
  )

;;;;; Dashboard
(general-def dashboard-mode-map
  "r" 'dashboard-jump-to-recents
  "p" 'dashboard-jump-to-projects
  "n" 'next-line
  "e" 'previous-line
  "." 'find-file
  "SPC" 'hydra-leader/body
  )

;;;;; EXWM
(defun my/pactl-volume ()
  (interactive)
  (let ((pactl-output (shell-command-to-string "pactl get-sink-volume 0")))
    (string-match (rx (group line-start "Volume: front-left: " (1+ digit) " / " (0+ " ")
			     (group (1+ digit) "%")))
		  pactl-output)

    (message "%s" (match-string 2 pactl-output))))


(setq exwm-input-global-keys
      `((,(kbd "C-d") . my/exwm-copy)

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

	(,(kbd "s-n") . evil-window-next)
	(,(kbd "s-e") . evil-window-prev)

	(,(kbd "s-t") . (lambda () (interactive) (save-window-excursion (let ((default-directory "~")) (async-shell-command "firefox")))))

	(,(kbd "s-s") . my/exwm-toggle-special)
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
(pretty-hydra-define hydra-leader (:color blue)
  ;; ("SPC" projectile-find-file)		; find file in project
  ("EMACS"
   (("ESC" restart-emacs "restart emacs")
    ("w" hydra-window/body "window")
    ("b" hydra-buffer/body "buffer")
    ("h" hydra-help/body "help")
    (";" execute-extended-command "M-x")
    (":" pp-eval-expression "M-:"))
   ;; ("p" hydra-projectile/body)
   "editing"
   (("g" hydra-go/body "go")
    ("o" hydra-outline/body "outline")
    ("p" hydra-project/body "project")
    ("e" hydra-eglot/body "eglot")
    ("c" comment-dwim "comment"))
   "misc"
   (("." find-file "find file")
    ("SPC" project-find-file "find file in project")
    ("t" eat "term"))
   )
  )

;;;;; Window Hydra
(pretty-hydra-define hydra-window (:color blue)
  ("Select"
   (("n" evil-window-next "next")
    ("e" evil-window-prev "prev"))
   "Split"
   (("h" evil-window-split "hor. split")
    ("i" evil-window-vsplit "ver. split"))
   "Delete"
   (("k" delete-window "delete")
    ("K" delete-other-windows "delete other"))
   )
  )

;;;;; Buffer Hydra
(pretty-hydra-define hydra-buffer (:color blue)
  ("Buffer"
   (("SPC" consult-buffer "consult")
    ("s" basic-save-buffer "save")		; Save
    ("k" kill-current-buffer "kill")
    ("b" mode-line-other-buffer "other")
    ("i" my/indent-buffer "indent buffer"))
   )
  )

;;;;; Help Hydra
(pretty-hydra-define hydra-help (:color blue)
  ("Help"
   (("k" describe-key "key")
    ("a" consult-apropos "apropos")
    ("f" describe-function "function")
    ("v" describe-variable "variable")
    ("m" describe-keymap "keymap"))
   )
  )

;;;;; Project Hydra
(pretty-hydra-define hydra-project (:color blue)
  ("Project"
   (("SPC" project-switch-project "switch")
    ("t" eat-project "terminal")
    ("c" project-compile "compile")
    ("r" project-recompile "recompile")
    ("m" magit "magit"))
   )
  )
;; ;;;;; Projectile Hydra
;; (defhydra hydra-projectile (:color blue)
;;   ("SPC" projectile-switch-project)
;;   ("a" projectile-add-known-project)
;;   ("i" projectile-invalidate-cache)
;;   ("d" projectile-remove-known-project)
;;   ("k" projectile-remove-known-project)
;; )

;;;;; Outline/Org Hydra
(pretty-hydra-define hydra-outline (:color blue)
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
   )
  )

(pretty-hydra-define hydra-org-latex  (:color blue)
  ("resize"
   (("e" xenops-increase-size "+" :color red)
    ("n" xenops-decrease-size "-" :color red))
   "edit"
   (("b" cdlatex-environment "begin"))
   )
  )


;; ;;;;; LSP Hydra
;; (defhydra hydra-lsp (:color blue)
;;   ("r" lsp-rename)
;;   ("e" consult-lsp-diagnostics)
;; )

;;;;; Go Hydra
(pretty-hydra-define hydra-go (:color blue)
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
    ("l" evil-show-marks "list markers")
    ("g" consult-imenu "consult"))
   )
  )

;;;;; Eglot Hydra
(pretty-hydra-define hydra-eglot (:color blue)
  ("Eglot"
   (("f" eglot-code-action-quickfix "quickfix")
    ("d" eldoc "doc")
    ("r" eglot-rename "rename"))
   )
  )


(exwm-enable)

;; init.el ends here




