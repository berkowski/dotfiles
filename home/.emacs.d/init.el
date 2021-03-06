
;; packages
(require 'package)
(setq package-archives '(
			 ("gnu" . "http://elpa.gnu.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")
			 ("melpa" . "http://melpa.org/packages/")
                         ("melpa-stable" . "http://stable.melpa.org/packages/")
			)
)

(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package))
  (require package))

(package-initialize)

;;
;; Appearance
;;

;; Disable menu, tool, and scrollbars
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; powerline
(require-package 'powerline)
(powerline-vim-theme)

;; Set the color theme
(load-theme 'wombat)
(require-package 'color-theme-approximate)
(color-theme-approximate-on)

;; Give each variable a unique color by scope
(require-package 'color-identifiers-mode)
(add-hook 'after-init-hook 'global-color-identifiers-mode)

;; But don't highlight language keywords
;; (let ((faces '(font-lock-comment-face font-lock-comment-delimiter-face font-lock-constant-face font-lock-type-face font-lock-function-name-face font-lock-variable-name-face font-lock-keyword-face font-lock-string-face font-lock-builtin-face font-lock-preprocessor-face font-lock-warning-face font-lock-doc-face)))
;;   (dolist (face faces)
;;     (set-face-attribute face nil :foreground nil :weight 'normal :slant 'normal)))
;; 
;; (set-face-attribute 'font-lock-comment-delimiter-face nil :slant 'italic)
;; (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
;; (set-face-attribute 'font-lock-doc-face nil :slant 'italic)
;; (set-face-attribute 'font-lock-keyword-face nil :weight 'bold)
;; (set-face-attribute 'font-lock-builtin-face nil :weight 'bold)
;; (set-face-attribute 'font-lock-preprocessor-face nil :weight 'bold)

;; Colorize delimiters
(require-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;
;; Evil-Mode
;;

(require-package 'evil-surround)
(global-evil-surround-mode t)

(require-package 'evil)
(evil-mode t)

;;
;; Programing (General)
;;
(require-package 'company)
(add-hook 'prog-mode-hook #'global-company-mode)


;;
;; Rust
;;
(require-package 'rust-mode)
(add-hook 'rust-mode-hook #'racer-mode)

(require-package 'cargo)
(add-hook 'rust-mode-hook #'cargo-minor-mode)

;; racer completion backend
(require-package 'racer)
(setq racer-cmd "~/.cargo/bin/racer")
(setq racer-rust-src-path "~/repos/external/rust/src")

(add-hook 'racer-mode-hook #'company-mode)

(global-set-key (kbd "TAB") #'company-indent-or-complete-common) ;
(setq company-tooltip-align-annotations t)

;; flycheck syntax checker
(require-package 'flycheck-rust)
(setq flycheck-rust-cargo-executable "~/.cargo/bin/cargo")
(setq flycheck-rust-executable "~/.cargo/bin/rustc")
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
