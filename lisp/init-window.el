;;; init-window.el ---                               -*- lexical-binding: t; -*-

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

(use-package ace-window
  :ensure t
  :custom
  (aw-keys '(?j ?k ?l ?i ?o ?h ?y ?u ?p))
  :custom-face
  (aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c"))))
  :init
  (progn
    (setq aw-scope 'frame)
    (global-set-key (kbd "C-x O") 'other-frame)
    (global-set-key [remap other-window] 'ace-window)))

(use-package winum
  :ensure t
  :init
  (winum-mode)
  :config
  (define-key winum-keymap (kbd "M-1") 'winum-select-window-1)
  (define-key winum-keymap (kbd "M-2") 'winum-select-window-2)
  (define-key winum-keymap (kbd "M-3") 'winum-select-window-3)
  (define-key winum-keymap (kbd "M-4") 'winum-select-window-4)
  (define-key winum-keymap (kbd "M-5") 'winum-select-window-5)
  (define-key winum-keymap (kbd "M-6") 'winum-select-window-6)
  (define-key winum-keymap (kbd "M-7") 'winum-select-window-7)
  (define-key winum-keymap (kbd "M-8") 'winum-select-window-8))

(use-package popwin
  :ensure t
  :hook (after-init . popwin-mode)
  :config
  (progn
    ;; (require 'popwin)
    ;; (popwin-mode 1)

    ;; don't use default value but manage it ourselves
    (setq popwin:special-display-config nil)

    ;; buffers that we manage
    (push '("*Help*"                 :dedicated t :position bottom :stick t :noselect t   :height 0.4) popwin:special-display-config)
    (push '("*Process List*"         :dedicated t :position bottom :stick t :noselect nil :height 0.4) popwin:special-display-config)
    (push '("*compilation*"          :dedicated t :position bottom :stick t :noselect t   :height 0.5) popwin:special-display-config)
    (push '("*Shell Command Output*" :dedicated t :position bottom :stick t :noselect nil            ) popwin:special-display-config)
    (push '("*Async Shell Command*"  :dedicated t :position bottom :stick t :noselect nil            ) popwin:special-display-config)
    (push '(" *undo-tree*"           :dedicated t :position right  :stick t :noselect nil :width   60) popwin:special-display-config)
    (push '("*undo-tree Diff*"       :dedicated t :position bottom :stick t :noselect nil :height 0.3) popwin:special-display-config)
    (push '("*ert*"                  :dedicated t :position bottom :stick t :noselect nil            ) popwin:special-display-config)
    (push '("*grep*"                 :dedicated t :position bottom :stick t :noselect nil            ) popwin:special-display-config)
    (push '("*nosetests*"            :dedicated t :position bottom :stick t :noselect nil            ) popwin:special-display-config)
    (push '("*Backtrace*"            :dedicated t :position bottom :stick t :noselect nil            ) popwin:special-display-config)
    (push '("^\*WoMan.+\*$" :regexp t             :position bottom                                   ) popwin:special-display-config)
    (push '("*Google Translate*"     :dedicated t :position bottom :stick t :noselect t   :height 0.4) popwin:special-display-config)
    (push '("^\\*Flycheck.+\\*$" :regexp t :dedicated t :position bottom :stick t :noselect t) popwin:special-display-config)
    ))


;; center window
(use-package olivetti
  :ensure t
  :diminish
  :bind ("<f7>" . olivetti-mode)
  :init (setq olivetti-body-width 0.56))

;; (use-package writeroom-mode
;;   :ensure t
;;   :init
;;   (setq writeroom-maximize-window nil
;; 	writeroom-fullscreen-effect 'maximized
;; 	writeroom-mode-line t
;; 	writeroom-width 100)
;;   :config
;;   (define-key writeroom-mode-map (kbd "C-M-<") #'writeroom-decrease-width)
;;   (define-key writeroom-mode-map (kbd "C-M->") #'writeroom-increase-width)
;;   (define-key writeroom-mode-map (kbd "C-M-=") #'writeroom-adjust-width))

(provide 'init-window)
(message "init-window loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-window.el ends here
