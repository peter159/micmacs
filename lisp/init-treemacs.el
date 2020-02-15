;;; init-treemacs.el ---                             -*- lexical-binding: t; -*-

;; Copyright (C) 2019  

;; Author:  <peter.linyi@DESKTOP-PMTGUNT>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(mark-time-here)

(use-package treemacs
  :ensure t
  ;; :pin melpa-stable
  :commands (treemacs-follow-mode
	     treemacs-current-visibility
	     treemacs-select-window
	     treemacs--window-number-ten
             treemacs-filewatch-mode
             treemacs-fringe-indicator-mode
             ;; treemacs-git-mode
	     )
  :bind (([f8]        . treemacs)
	 ("C-`"       . treemacs-select-window)
	 ("M-0"       . treemacs-select-window)
	 ("C-x 1"     . treemacs-delete-other-windows)
	 ("C-x t 1"   . treemacs-delete-other-windows)
	 ("C-x t t"   . treemacs)
	 ("C-x t b"   . treemacs-bookmark)
	 ("C-x t C-t" . treemacs-find-file)
	 ("C-x t M-t" . treemacs-find-tag)
	 :map treemacs-mode-map
	 ([mouse-1]   . treemacs-single-click-expand-action))
  :hook (treemacs-mode . (lambda ()
			   (display-line-numbers-mode -1)
			   (hl-line-mode -1)))
  :init
  (define-key winum-keymap (kbd "M-0") 'treemacs-select-window)
  :config
  (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
	treemacs-sorting                       'alphabetic-case-insensitive-desc
	treemacs-follow-after-init             t
	treemacs-is-never-other-window         t
	treemacs-silent-filewatch              t
	treemacs-silent-refresh                t
	treemacs-width                         30)

  (treemacs-follow-mode t)
  (treemacs-filewatch-mode nil)		; WORKAROUND to avoid treemacs--process-file-events error
  (treemacs-fringe-indicator-mode t)
  (pcase (cons (not (null (executable-find "git")))
               (not (null (executable-find "python3"))))
    (`(t . t)
     (treemacs-git-mode 'extended))
    (`(t . _)
     (treemacs-git-mode 'simple))))

(use-package treemacs-evil
  :ensure t
  ;; :pin melpa-stable
  :defer t
  :init
  (with-eval-after-load 'treemacs
    (require 'treemacs-evil))
  :config
  (define-key evil-treemacs-state-map (kbd "F") 'treemacs-create-file)
  (define-key evil-treemacs-state-map (kbd "+") 'treemacs-create-dir))

(use-package treemacs-projectile
  :ensure t
  ;; :pin melpa-stable
  :after treemacs projectile
  :bind (([M-f8] . treemacs-projectile)
	 :map projectile-command-map
	 ("h" . treemacs-projectile)))

(provide 'init-treemacs)
(message "init-treemacs loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-treemacs.el ends here
