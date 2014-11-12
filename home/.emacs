; Lots of this ripped from
;; http://juanjoalvarez.net/en/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/

;; packages
(require 'package)
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
    (package-install package))
  (require package))

;; Raw emacs config
; use spaces instead of tabs for indenting
(setq-default tab-width 4 indent-tabs-mode nil)

; Show matching parens
(show-paren-mode 1)

; Save backup files in their own directory
(setq backup-directory-alist '(("." . "~/.emacs_saves")))

; indent after newlines
(define-key global-map (kbd "RET") 'newline-and-indent)

; highlight changes mode
(global-highlight-changes-mode 1)

;; Trim whitespace
(require-package 'ws-butler)
(ws-butler-global-mode 1)

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
(evil-mode 1)

(require-package 'evil-leader)
(global-evil-leader-mode)
(setq evil-leader/in-all-states 1)

(setq evil-search-module 'evil-search)
(evil-leader/set-key "SPC" 'evil-search-highlight-persist-remove-all)

(require-package 'evil-surround)
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

; quick buffer cycling
(define-key evil-normal-state-map (kbd "[ b") 'previous-buffer)
(define-key evil-normal-state-map (kbd "] b") 'next-buffer)

; quick syntax error jumping
(define-key evil-normal-state-map (kbd "[ q") 'previous-error)
(define-key evil-normal-state-map (kbd "] q") 'next-error)

;; Use evil-surround
(require-package 'evil-surround)
(global-evil-surround-mode 1)

;; Projectile config
(require-package 'projectile)
(projectile-global-mode)

;; Helm config
;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
(require-package 'helm)
(require-package 'helm-projectile)
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
                       ;helm-projectile-sources-list
                       helm-c-source-projectile-files-list
                       helm-c-source-ctags
                       helm-c-source-recentf
                       helm-c-source-locate)
                     "*helm-my-buffers*"))

(global-set-key (kbd "M-p") 'helm-my-buffers)
;; Powerline
(require-package 'powerline)
(require-package 'powerline-evil)
(powerline-evil-vim-color-theme)
(display-time-mode t)

;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

; (Setq flycheck-check-syntax-automatically '(save mode-enabled))
; (setq flycheck-checkers (delq 'emacs-lisp-checkdoc flycheck-checkers))
; (setq flycheck-checkers (delq 'html-tidy flycheck-checkers))
(setq flycheck-standard-error-navigation nil)

(global-flycheck-mode t)

;; flycheck errors on a tooltip (doesnt work on console)
;; (when (display-graphic-p (selected-frame))
;;   (eval-after-load 'flycheck
;;     '(custom-set-variables
;;       '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))

;; Jedi auto-complete
(require-package 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook '(lambda () (setq fill-column 79)))

(setq jedi:complete-on-dot t)

(custom-set-variables
 '(flycheck-python-flake8-executable "/usr/local/bin/flake8"))

(require-package 'diminish)
(diminish 'visual-line-mode)
;(after 'autopair (diminish 'autopair-mode))
(eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
;(after 'auto-complete (diminish 'auto-complete-mode))
(eval-after-load "projectile" '(diminish 'projectile-mode))
;(eval-after-load 'yasnippet (diminish 'yas-minor-mode))
;(eval-after-load 'guide-key (diminish 'guide-key-mode))
;(eval-after-load 'eldoc (diminish 'eldoc-mode))
;(eval-after-load 'smartparens (diminish 'smartparens-mode))
;(eval-after-load 'company (diminish 'company-mode))
;(eval-after-load 'elisp-slime-nav (diminish 'elisp-slime-nav-mode))
;(eval-after-load 'git-gutter+ (diminish 'git-gutter+-mode))
;(eval-after-load 'magit (diminish 'magit-auto-revert-mode))
;(eval-after-load 'hs-minor-mode (diminish 'hs-minor-mode))
(eval-after-load "color-identifiers-mode" '(diminish 'color-identifiers-mode))


;; c/c++ autocompletion with irony
(require-package 'irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)

(defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
		    'irony-completion-at-point-async)
      (define-key irony-mode-map [remap complete-symbol]
		      'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)

; google c/c++ styles
(require-package 'flycheck-google-cpplint)

(eval-after-load 'flycheck
  '(progn
     (require 'flycheck-google-cpplint)
     (flycheck-add-next-checker 'c/c++-cppcheck
                                'c/c++-googlelint 'append)))

(custom-set-variables
 '(flycheck-c/c++-googlelint-executable "/usr/local/bin/cpplint")
 '(flycheck-googlelint-verbose "3")
 '(flycheck-googlelint-filter "-whitespace,+whitespace/braces"))

 ;'(flycheck-c/c++-language-standard "c++0x"))
(add-hook 'c++-mode-hook '(lambda () (flycheck-select-checker 'c/c++-googlelint)))
(add-hook 'c-mode-hook '(lambda () (flycheck-select-checker 'c/c++-googlelint)))


; google-c-cstyle
(require-package 'google-c-style)
;(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

(provide 'emacs)
