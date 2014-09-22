;; Lots of this ripped from 
;; http://juanjoalvarez.net/en/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/

;; packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                        ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

;; Raw emacs config
; use spaces instead of tabs for indenting
(setq-default tab-width 4 indent-tabs-mode nil)

; Show matching parens
(show-paren-mode 1)

;; Theme config
(load-theme 'wombat)
(require-package 'color-theme-approximate)
(color-theme-approximate-on)

;; Make code colorful
(require-package 'color-identifiers-mode)
(global-color-identifiers-mode)

(require-package 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;; Evil config
(require-package 'evil)
(require-package 'evil-surround)

(evil-mode 1)

; I want my Esc back...
;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

;; Projectile config
(require-package 'projectile)
(projectile-global-mode)

;; Helm config
;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
(require 'helm-config)
(require 'helm-misc)
(require 'helm-projectile)
(require 'helm-locate)
(setq helm-quick-update t)
(setq helm-bookmark-show-location t)
(setq helm-buffers-fuzzy-matching t)

; (after 'projectile
  ; (package 'helm-projectile))

(global-set-key (kbd "M-x") 'helm-M-x)

(defun helm-my-buffers ()
  (interactive)
  (helm-other-buffer '(;helm-c-source-buffers-list
                       helm-c-source-elscreen
                       helm-c-source-projectile-files-list
                       helm-c-source-ctags
                       helm-c-source-recentf
                       helm-c-source-locate)
                     "*helm-my-buffers*"))

;; Powerline
(require-package 'powerline)
(powerline-evil-vim-color-theme)
(display-time-mode t)

;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq flycheck-check-syntax-automatically '(save mode-enabled))
; (setq flycheck-checkers (delq 'emacs-lisp-checkdoc flycheck-checkers))
; (setq flycheck-checkers (delq 'html-tidy flycheck-checkers))
(setq flycheck-standard-error-navigation nil)

(global-flycheck-mode t)

;; flycheck errors on a tooltip (doesnt work on console)
;; (when (display-graphic-p (selected-frame))
;;   (eval-after-load 'flycheck
;;     '(custom-set-variables
;;       '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))
