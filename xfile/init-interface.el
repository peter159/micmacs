;; init-interface.el --- setup for interface thing

;; commentary

;; code

;; hide menu-bar, tool-bar, scroll-bar and open with global line number mode
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-linum-mode 1)
(scroll-bar-mode -1)
(electric-pair-mode 1)

(require 'recentf)
(recentf-mode 1)

;; forbid emacs startup screen and make full screen default
(setq inhibit-splash-screen t)
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;; use utf-8 as default encoding
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)

;; display time
(display-time-mode t) 
(setq display-time-24hr-format t) 
(setq display-time-day-and-date t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Should set before loading 'use-package'
(eval-and-compile
  (setq use-package-always-ensure t)
  (setq use-package-always-defer t)
  (setq use-package-expand-minimally t)
  (setq use-package-enable-imenu-support t))

(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  ;; (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

(use-package company
  ;; :ensure t
  :config
  (global-company-mode)
  (setq company-idle-delay 0.2)
  (setq company-selection-wrap-around t)
  (define-key company-active-map [tab] 'company-complete)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

(use-package quelpa
  :config
  (setq quelpa-self-upgrade-p nil)
  (setq quelpa-update-melpa-p nil)
  (setq quelpa-checkout-melpa-p nil))

(use-package quelpa-use-package
  :config
  ;; (require 'quelpa-use-package)
  (setq use-package-ensure-function 'quelpa))

(use-package font-lock+
  :quelpa
  (font-lock+ :repo "emacsmirror/font-lock-plus" :fetcher github))

(provide 'init-interface)
