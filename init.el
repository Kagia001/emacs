;; Ignore this
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e29a6c66d4c383dbda21f48effe83a1c2a1058a17ac506d60889aba36685ed94" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(global-whitespace-mode nil)
 '(highlight-indent-guides-character 124)
 '(highlight-indent-guides-method 'character)
 '(highlight-indent-guides-responsive 'top)
 '(package-selected-packages
   '(lsp-java yaml-mode ayu-theme company-tabnine flycheck aggressive-indent lsp-ui lsp-mode company company-mode highlight-indent-guides highlight-indentat-guides lua-mode ivy treemacs smart-tabs-mode smart-mode-line xah-fly-keys use-package)))

;; Custom Functions
(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

;; Initialise package system
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)


;; Basic config

;; Remove clutter
(menu-bar-mode -1)                      ; Remove menu line at the top
(toggle-scroll-bar -1)                  ; Remove scroll bar
(tool-bar-mode -1)                      ; Remove tool bar

;; Indentation stuff

(use-package aggressive-indent          ; Always indent
  :config
  (global-aggressive-indent-mode 1))

(setq custom-tab-width 4)
(setq-default python-indent-offset custom-tab-width)
(setq-default evil-shift-width custom-tab-width)
(setq-default indent-tabs-mode nil)


(setq backward-delete-char-untabify-method 'hungry)

;; Other
(setq-default left-fringe-width 50)     ; Left padding
(setq-default right-fringe-width 50)    ; Right padding
(add-to-list 'default-frame-alist '(font . "fira code nerd font 15")) ; Font needs to have this list format to work as daemon
(desktop-save-mode 1)                   ; Remember which buffers are open after closing emacs
(show-paren-mode 1)                                      ; Highlight paranthesees
(define-key key-translation-map (kbd "ESC") (kbd "C-g")) ; Escape key = C-g to cancel minibuffer etc.
(electric-pair-mode 1)                  ; Match second bracket, quotes, etc. where it makes sense
(setq-default cursor-type 'bar)
(global-hl-line-mode)
;; (server-start)



;; Keybinds

(global-set-key (kbd "<return>") 'newline)                                      ; Enter is bound to C-m by default.
(define-key input-decode-map [?\C-i] [C-i])                                     ; C-i is bound to tab by default. Different just because.

(global-set-key (kbd "C-a") 'execute-extended-command)
(global-set-key (kbd "C-m") 'backward-char)
(global-set-key (kbd "C-n") 'next-line)
(global-set-key (kbd "C-e") 'previous-line)
(global-set-key (kbd "<C-i>") 'forward-char)
(global-set-key (kbd "C-S-m") 'beginning-of-line-text)
(global-set-key (kbd "C-S-i") 'end-of-line)

(global-set-key (kbd "C-q") 'delete-window)
(global-set-key (kbd "C-S-q") 'delete-other-windows)
(global-set-key (kbd "C-w") 'split-window-below)
(global-set-key (kbd "C-f") 'split-window-right)
(global-set-key (kbd "C-p") 'other-window)

(global-set-key (kbd "C-u") 'undo)
(global-set-key (kbd "C-c") 'kill-region)
(global-set-key (kbd "C-d") 'kill-ring-save)
(global-set-key (kbd "C-v") 'yank)
(global-set-key (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<C-iso-lefttab>") 'previous-buffer)
(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-/") 'swiper)
(global-set-key (kbd "C-t") 'switch-to-buffer)
;; Packages

(use-package flycheck)
(use-package lsp-ui)
(use-package lsp-mode)
(use-package lsp-java
  :init
  (add-hook 'java-mode-hook #'lsp))

(use-package company-tabnine)
(use-package company                    ; Tab completion
  :after (company-tabnine)
  :config
  (add-to-list 'company-backends #'company-tabnine)
  (setq company-idle-delay 0.0)
  :init
  (add-hook 'prog-mode-hook 'company-mode))

(use-package ivy                        ; Completion framework
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (define-key ivy-minibuffer-map (kbd "<return>") (kbd "C-m")))

(use-package swiper)                    ; Alternative isearch

(use-package counsel                    ; Better alternatives for some completion
  :config
  (counsel-mode 1))

(use-package arduino-mode)

(use-package highlight-indent-guides
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(use-package ayu-theme                  ; Theme
  :config
  (load-theme 'ayu-light t))


(use-package lua-mode)
(use-package yaml-mode)

(use-package treemacs                   ; File tree
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         20
          treemacs-workspace-switch-cleanup      nil)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
