;;; init-eshell.el ---                               -*- lexical-binding: t; -*-

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
(mark-time-here)			;TODO need to transplant from spacemacs

(defun shell/init-eshell ()
  (use-package eshell
    :defer t
    :init
    (progn
      (spacemacs/register-repl 'eshell 'eshell)
      (setq eshell-cmpl-cycle-completions nil
            ;; auto truncate after 20k lines
            eshell-buffer-maximum-lines 20000
            ;; history size
            eshell-history-size 350
            ;; no duplicates in history
            eshell-hist-ignoredups t
            ;; buffer shorthand -> echo foo > #'buffer
            eshell-buffer-shorthand t
            ;; my prompt is easy enough to see
            eshell-highlight-prompt nil
            ;; treat 'echo' like shell echo
            eshell-plain-echo-behavior t
            ;; cache directory
            eshell-directory-name (concat spacemacs-cache-directory "eshell/"))

      (when shell-protect-eshell-prompt
        (add-hook 'eshell-after-prompt-hook 'spacemacs//protect-eshell-prompt))

      (autoload 'eshell-delchar-or-maybe-eof "em-rebind")

      (add-hook 'eshell-mode-hook 'spacemacs//init-eshell)
      (add-hook 'eshell-mode-hook 'spacemacs/disable-hl-line-mode))
    :config
    (progn

      ;; Work around bug in eshell's preoutput-filter code.
      ;; Eshell doesn't call preoutput-filter functions in the context of the eshell
      ;; buffer. This breaks the xterm color filtering when the eshell buffer is updated
      ;; when it's not currently focused.
      ;; To remove if/when fixed upstream.
      (defun eshell-output-filter@spacemacs-with-buffer (fn process string)
        (let ((proc-buf (if process (process-buffer process)
                          (current-buffer))))
          (when proc-buf
            (with-current-buffer proc-buf
              (funcall fn process string)))))
      (advice-add
       #'eshell-output-filter
       :around
       #'eshell-output-filter@spacemacs-with-buffer)

      (require 'esh-opt)

      ;; quick commands
      (defalias 'eshell/e 'find-file-other-window)
      (defalias 'eshell/d 'dired)
      (setenv "PAGER" "cat")

      ;; support `em-smart'
      (when shell-enable-smart-eshell
        (require 'em-smart)
        (setq eshell-where-to-jump 'begin
              eshell-review-quick-commands nil
              eshell-smart-space-goes-to-end t)
        (add-hook 'eshell-mode-hook 'eshell-smart-initialize))

      ;; Visual commands
      (require 'em-term)
      (mapc (lambda (x) (add-to-list 'eshell-visual-commands x))
            '("el" "elinks" "htop" "less" "ssh" "tmux" "top"))

      ;; automatically truncate buffer after output
      (when (boundp 'eshell-output-filter-functions)
        (add-hook 'eshell-output-filter-functions #'eshell-truncate-buffer)))))

(provide 'init-eshell)
(message "init-eshell loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-eshell.el ends here
