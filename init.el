;; TODO company kinda wonkey but works
;; TODO color hex colors
;; TODO -nw support
;; mickeynp/combobulate
;; TODO modernemacs.com
;; TODO svg todo and header
;;; Init stuff
;; (add-to-list 'load-path "~/.emacs.d/my-packages/tree-sitter-langs")

;; ;; Increasing garbage collection threshold during startup significantly lowers init times.
(setq gc-cons-threshold (* 50 1000 1000))	; 100MB
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold (* 2 1000 1000)))) ; 2MB

;;; Straight
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
(straight-use-package 'projectile)	; Project management
(projectile-mode +1)

(straight-use-package 'restart-emacs)

(desktop-save-mode 1)			; Save open windows and buffers

(straight-use-package 'figlet)		; ascii art text

(straight-use-package 'vterm)		; Terminal emulator

(setq frame-resize-pixelwise t) 	; Play nice with tiling wms

(straight-use-package 'smartparens)	; Close brackets
(require 'smartparens-config)
(add-hook 'prog-mode-hook 'smartparens-mode)

(setq evil-undo-system 'undo-redo)	; Evil redo

(straight-use-package 'outshine)	; Comment headers
(add-hook 'prog-mode-hook 'outshine-mode)

(straight-use-package 'all-the-icons)

(straight-use-package 'esup)		; Startup time benchmarking

(defun rung-bell-function () nil)	; Turn off beeping

(setq xref-prompt-for-identifier nil)

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

(straight-use-package 'mini-frame)	; Minibuffer in center when typing
(setq mini-frame-show-parameters '((top . 0) (width . 0.7) (left . 0.5)))
(mini-frame-mode)

(straight-use-package 'consult)		; Completion for more things
(setq xref-show-xrefs-function #'consult-xref)
(setq xref-show-definitions-function #'consult-xref)


(straight-use-package 'orderless)       ; Complete by searching for space-separated snippets
(setq completion-styles '(orderless basic)
      completion-caterogy-defaults nil
      completion-category-overrides '((file (stylef partial-completion))))

;;; IDE tools
;;;; LSP
(setq read-process-output-max (* 1024 1024)) ; Better performance
(straight-use-package 'lsp-mode)
(setq lsp-headerline-breadcrumb-segments '(project file symbols))
;;;; Company
(straight-use-package 'company)
(add-hook 'prog-mode-hook 'company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 0)
(straight-use-package 'company-tabnine)
;; (setq company-backends '((company-tabnine company-capf)))
(setq company-backends '(company-tabnine))

;;; Language modes
;;;; Web-mode
(straight-use-package 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . web-mode))
(add-hook 'web-mode-hook #'lsp-deferred)
;; (add-hook 'web-mode-hook (lambda () (setq-local outline-regexp "<!--\\|//\\|/\* [*]\\{1,8\\}'")))

;;; Visual
;;;; Vanilla emacs
(menu-bar-mode -1)                      ; Remove menu line at the top
(scroll-bar-mode -1)			; Remove scroll bar
(tool-bar-mode -1)                      ; Remove tool bar
(blink-cursor-mode -1)
(global-hl-line-mode)			; Highlight current line
(add-to-list 'default-frame-alist '(font . "fira code nerd font-12"))

;;;; Theme
;;;;; Light
;;;;;; Color Theme
(defun lightmode ()
  (interactive)
  (straight-use-package 'gruvbox-theme)
  (load-theme 'gruvbox-light-medium t)

;;;;;; Outline Header Colors
  (custom-theme-set-faces
   'gruvbox-light-medium
   '(outshine-level-1 ((t (
			   :foreground "#d65d0e"
			   ))))
   '(outshine-level-2 ((t (
			   :foreground "#d79921"
			   ))))
   '(outshine-level-3 ((t (
			   :foreground "#458588"
			   ))))
   '(outshine-level-4 ((t (
			   :foreground "#689d6a"
			   ))))
   '(outshine-level-5 ((t (
			   :foreground "#98971a"
			   ))))
   )
  (enable-theme 'gruvbox-light-medium)
  )

;;;;; Dark
;;;;;; Color Theme
(defun darkmode ()
  (interactive)
  (straight-use-package 'gruvbox-theme)
  (load-theme 'gruvbox-dark-medium t)

;;;;;; Outline Header Colors
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

(lightmode)

;;;; Splash screen
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;;;; Line numbers
(setq-default display-line-numbers 'relative)
(setq-default display-line-numbers-width 3)

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
(doom-modeline-mode)

;;;; Outline
;;;;; Outline Level 1
(custom-set-faces '(outshine-level-1 ((t (
					  :family "Victor Mono"
					  :height 1.75
					  :weight extra-bold
					  :slant italic
					  :underline t))))
;;;;; Outline Level 2
		  '(outshine-level-2 ((t (
					  :family "Victor Mono"
					  :height 1.5
					  :weight extra-bold
					  :slant italic
					  :underline t
					  ))))
;;;;; Outline Level 3
		  '(outshine-level-3 ((t (
					  :family "Victor Mono"
					  :height 1.25
					  :weight bold
					  :slant italic
					  :underline t
					  ))))
;;;;; Outline Level 4
		  '(outshine-level-4 ((t (
					  :family "Victor Mono"
					  :weight bold
					  :height 1.25
					  :weight bold
					  :slant italic
					  :underline t
					  ))))
;;;;; Outline Level 5
		  '(outshine-level-5 ((t (
					  :family "Victor Mono"
					  :height 1.0
					  :weight bold
					  :slant italic
					  :underline t
					  ))))
		  )
;;; Syntax highlighting
;;;; Treesitter
;; Tree sitter does some cool parsing stuff. Probably the best syntax highlighting, doesnt support that many languages though as of now
(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)


(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook 'tree-sitter-hl-mode)
(add-to-list 'tree-sitter-major-mode-language-alist '(svelte-mode . svelte))

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

;;;;; Keywords
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
(add-hook 'haskell-mode-hook 'my-set-hasklig-ligatures)
(straight-use-package '(ligature :type git :host github :repo "mickeynp/ligature.el"))
(global-ligature-mode)
;;;;;; Fundamental mode
(ligature-set-ligatures 't '("www" "Fl" "Tl" "fi" "fj" "fl"))
;;;;;; Prog mode
(ligature-set-ligatures 'prog-mode '("++" "--" "**" "&&" "||" "||="
				     "->" "=>" "::" "__"
				     "==" "===" "!=" "=/="
				     "<<" "<<<" ">>" ">>>" "|=" "^="
				     "<=" ">=" "<=>"
				     ":="
				     ))
;;;;;; HTML
(ligature-set-ligatures '(html-mode nxml-mode web-mode) '("</" "<!--" "</>" "-->" "/>"))
;;;;;; Emacs lisp
(ligature-set-ligatures 'emacs-lisp-mode '(";;"))
;;;;; Prettify symbols mode
(global-prettify-symbols-mode)
;;;;;; Emacs lisp
(add-hook 'emacs-lisp-mode-hook (lambda () (setq prettify-symbols-alist '(
									  ("lambda" . ?λ)
									  ))))

;;; My Functions
;;;; mkoppg
(defun mkoppg (fmt)
  "Make file with set file format named oppg-YEAR-MONTH-DAY.FILE_FORMAT."
  (interactive "sFile format: ")
  (find-file (s-concat (format-time-string "oppg-%Y-%m-%d.") fmt)))

;;;; indent-buffer
(defun indent-buffer ()
  "Indent each nonblank line in the buffer."
  (interactive)
  (indent-region (point-min) (point-max)))
(provide 'my-functions)

;;; Keybinds
;;;; Keybind Packages
(straight-use-package 'evil)            ; vim emulation
(straight-use-package 'evil-snipe)	; snipe letter
(setq evil-snipe-scope 'whole-visible)
(setq evil-snipe-enable-highlight nil)
(setq evil-snipe-enable-incremental-highlight nil)
(evil-mode)

(straight-use-package 'general)         ; Keybind wrapper

(general-auto-unbind-keys)              ; Fixes some prefix key issues

(defun fix-ci-cm ()			; C-i and C-m are identical to TAB and RET. This moves C-i and C-m to H-i and C-m. Doesnt work in TTY mode
  (define-key input-decode-map (kbd "C-i") (kbd "H-i"))
  (define-key input-decode-map (kbd "C-m") (kbd "H-m")))
(fix-ci-cm)
(add-hook 'window-setup-hook 'fix-ci-cm) ; Run fix-ci-cm for each new frame. Cant just run in init when using emacs as a server.

;;;; Evil
;;;;; Movement
(general-def '(normal visual motion)
;;;;;; Evil movement
  "m" 'evil-backward-char
  "n" 'evil-next-line
  "e" 'evil-previous-line
  "i" 'evil-forward-char

  "f" 'evil-forward-WORD-end

  "k" 'evil-search-next
  "K" 'evil-search-previous

  "s" 'evil-snipe-s
  "S" 'evil-snipe-S

  "(" 'evil-jump-item			; matching bracket
;;;;;; Outline movement
  "H-m" 'outline-up-heading
  "C-n" 'outline-forward-same-level
  "C-e" 'outline-backward-same-level
  "H-i" 'outline-next-visible-heading
  ;; "H-m" 'keybinds--outline-up-recenter
  ;; "C-n" 'keybinds--outline-forward-recenter
  ;; "C-e" 'keybinds--outline-backward-recenter
  ;; "H-i" 'keybinds--outline-next-recenter

;;;;;; Unbind
  "SPC" nil
  )

;;;;; Normal mode
(general-def 'normal
  "a" 'evil-insert
  "t" 'evil-append
  )

;;;;; Visual mode
(general-def 'visual
  "A" 'evil-insert
  "T" 'evil-append
  )

;;;;; Insert mode
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

;;;; Leader
;;;;; Leader only
(general-def '(normal insert visual replace operator motion)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"

  "SPC" 'projectile-find-file		; find file in project
  ";" 'execute-extended-command		; M-x
  ":" 'pp-eval-expression		; M-:
  "." 'find-file
  "t" 'vterm				; terminal emulator
  "ESC" 'restart-emacs
  )

;;;;; Buffer
(general-def '(normal insert visual replace operator motion)
  :prefix "SPC b"
  :non-normal-prefix "M-SPC b"

  "SPC" 'view-buffer

  "s" 'basic-save-buffer		; Save
  "d" 'kill-current-buffer
  "k" 'kill-current-buffer
  "n" 'next-buffer
  "e" 'previous-buffer
  "b" 'mode-line-other-buffer
  "i" 'indent-buffer
  )

;;;;; Window
(general-def '(normal insert visual replace operator motion)
  :prefix "SPC w"
  :non-normal-prefix "M-SPC w"

  "n" 'evil-window-next
  "e" 'evil-window-prev
  "h" 'evil-window-split		; horisontal split
  "i" 'evil-window-vsplit		; vertical split
  "d" 'delete-window
  "D" 'delete-other-windows
  "k" 'delete-window
  "K" 'delete-other-windows
  )

;;;;; Help
(general-def '(normal insert visual replace operator motion)
  :prefix "SPC h"
  :non-normal-prefix "M-SPC h"

  "k" 'describe-key
  "a" 'consult-apropos
  "f" 'describe-function
  "v" 'describe-variable
  "w" 'where-is
  )

;;;;; Projectile
(general-def '(normal insert visual replace operator motion)
  :prefix "SPC p"
  :non-normal-prefix "M-SPC p"

  "SPC" 'projectile-switch-project
  "a" 'projectile-add-known-project
  "i" 'projectile-invalidate-cache
  "d" 'projectile-remove-known-project
  "k" 'projectile-remove-known-project
  )

;;;;; Outline Show/Hide
(general-def '(normal insert visual replace operator motion)
  :prefix "SPC n"
  :non-normal-prefix "M-SPC n"

  ;; "a" 'origami-forward-toggle-node
  ;; "o" 'origami-open-all-nodes
  ;; "c" 'origami-close-all-nodes
  ;; "s" 'origami-show-only-node
  "a" 'outline-hide-leaves
  "t" 'outline-show-subtree
  "s" 'outline-show-all
  "b" 'outline-hide-body
  "o" 'outline-hide-other
  )

;;;;; Outline Edit
(general-def '(normal)
  :prefix "SPC d"

  "SPC" 'consult-outline		; go to outline header

  "a" 'outline-insert-heading

  "m" 'outline-promote
  "i" 'outline-demote

  "n" 'outline-move-subtree-down
  "e" 'outline-move-subtree-up
  )
;;;; Go
(general-def '(normal)
  :prefix "g"

  "f" 'find-file-at-point               ; go to file, target guessed by cursor
  "d" 'xref-find-definitions
  "r" 'xref-find-references
  "u" 'pop-global-mark
  )
;;;; Vertico
(general-def vertico-map
  "C-n" 'vertico-next
  "C-e" 'vertico-previous)
;;;; LSP
(general-def '(normal) lsp-mode-map
  :prefix "SPC l"

  "r" 'lsp-rename
  )
;;;; Company
(general-def company-mode-map
  "C-t" 'company-select-next
  "C-s" 'company-select-previous
  )

(provide 'init)
;;; init.el ends here
