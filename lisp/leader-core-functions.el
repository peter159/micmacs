;;; leader-core-functions.el ---                            -*- lexical-binding: t; -*-

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

(defun petmacs/ivy-persp-switch-project-advice (project)
  (let ((persp-reset-windows-on-nil-window-conf t))
    (persp-switch project)))

(defun petmacs/ivy-persp-switch-project (arg)
  (interactive "P")
  (require 'counsel-projectile)
  (advice-add 'counsel-projectile-switch-project-action
	      :before #'petmacs/ivy-persp-switch-project-advice)
  (ivy-read "Switch to Project Perspective: "
            (if (projectile-project-p)
                (cons (abbreviate-file-name (projectile-project-root))
		      (projectile-relevant-known-projects))
	      projectile-known-projects)
            :action #'counsel-projectile-switch-project-action
            :caller 'petmacs/ivy-persp-switch-project)
  (advice-remove 'counsel-projectile-switch-project-action
                 'petmacs/ivy-persp-switch-project-advice))

;; from https://gist.github.com/3402786
(defun petmacs/toggle-maximize-buffer ()
  "Maximize buffer"
  (interactive)
  (save-excursion
    (if (and (= 1 (length (window-list)))
             (assoc ?_ register-alist))
        (jump-to-register ?_)
      (progn
        (window-configuration-to-register ?_)
        (delete-other-windows)))))


;; https://tsdh.wordpress.com/2007/03/28/deleting-windows-vertically-or-horizontally/
(defun petmacs/maximize-horizontally ()
  "Delete all windows to the left and right of the current window."
  (interactive)
  (require 'windmove)
  (save-excursion
    (while (condition-case nil (windmove-left) (error nil))
      (delete-window))
    (while (condition-case nil (windmove-right) (error nil))
      (delete-window))))

(defun petmacs/maximize-vertically ()
  "Delete all windows above and below the current window."
  (interactive)
  (require 'windmove)
  (save-excursion
    (while (condition-case nil (windmove-up) (error nil))
      (delete-window))
    (while (condition-case nil (windmove-down) (error nil))
      (delete-window))))

(defun petmacs/evil-goto-definition-other-window ()
  "Jump to definition around point in other window."
  (interactive)
  (let ((pos (point)))
    (switch-to-buffer-other-window (current-buffer))
    (goto-char pos)
    (evil-goto-definition)))

;; Dos2Unix/Unix2Dos
(defun dos2unix ()
  "Convert the current buffer to UNIX file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix nil))

(defun unix2dos ()
  "Convert the current buffer to DOS file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos nil))

(defun petmacs/copy-file ()
  "Write the file under new name."
  (interactive)
  (call-interactively 'write-file))

(defun petmacs/hidden-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings"
  (interactive)
  (unless buffer-display-table
    (setq buffer-display-table (make-display-table)))
  (aset buffer-display-table ?\^M []))

(defun petmacs/remove-dos-eol ()
  "Replace DOS eol CR LF with Unix eolns CR"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))

(defun petmacs/goto-dashboard ()
  "goto Home buffer"
  (interactive)
  (switch-to-buffer "*dashboard*"))

(defun petmacs/goto-scratch-buffer ()
  "goto Home buffer"
  (interactive)
  (switch-to-buffer "*scratch*"))

;; Revert buffer
(defun petmacs/revert-current-buffer ()
  "Revert the current buffer."
  (interactive)
  (message "Revert this buffer.")
  (ignore-errors
    (widen)
    (text-scale-increase 0)
    (if (fboundp 'fancy-widen)
        (fancy-widen)))
  (revert-buffer t t))
(bind-key "<f5>" #'petmacs/revert-current-buffer)
(if (eq system-type 'darwin)
    (bind-key "s-r" #'petmacs/revert-current-buffer))

(defun petmacs/copy-whole-buffer-to-clipboard ()
  "Copy entire buffer to clipboard"
  (interactive)
  (clipboard-kill-ring-save (point-min) (point-max)))

(defun petmacs/counsel-jump-in-buffer ()
  "Jump in buffer with `counsel-imenu' or `counsel-org-goto' if in org-mode"
  (interactive)
  (call-interactively
   (cond
    ((eq major-mode 'org-mode) 'counsel-org-goto)
    (t 'counsel-imenu))))

(defun petmacs/rename-current-buffer-file (&optional arg)
  "Rename the current buffer and the file it is visiting.
If the buffer isn't visiting a file, ask if it should
be saved to a file, or just renamed.

If called without a prefix argument, the prompt is
initialized with the current filename."
  (interactive "P")
  (let* ((name (buffer-name))
         (filename (buffer-file-name)))
    (if (and filename (file-exists-p filename))
        ;; the buffer is visiting a file
        (let* ((dir (file-name-directory filename))
               (new-name (read-file-name "New name: " (if arg dir filename))))
          (cond ((get-buffer new-name)
                 (error "A buffer named '%s' already exists!" new-name))
                (t
                 (let ((dir (file-name-directory new-name)))
                   (when (and (not (file-exists-p dir))
                              (yes-or-no-p
                               (format "Create directory '%s'?" dir)))
                     (make-directory dir t)))
                 (rename-file filename new-name 1)
                 (rename-buffer new-name)
                 (set-visited-file-name new-name)
                 (set-buffer-modified-p nil)
                 (when (fboundp 'recentf-add-file)
                   (recentf-add-file new-name)
                   (recentf-remove-if-non-kept filename))
                 (when (projectile-project-p)
                   (call-interactively #'projectile-invalidate-cache))
                 (message "File '%s' successfully renamed to '%s'"
                          name (file-name-nondirectory new-name)))))
      ;; the buffer is not visiting a file
      (let ((key))
        (while (not (memq key '(?s ?r)))
          (setq key (read-key (propertize
                               (format
                                (concat "Buffer '%s' is not visiting a file: "
                                        "[s]ave to file or [r]ename buffer?")
                                name)
                               'face 'minibuffer-prompt)))
          (cond ((eq key ?s)            ; save to file
                 ;; this allows for saving a new empty (unmodified) buffer
                 (unless (buffer-modified-p) (set-buffer-modified-p t))
                 (save-buffer))
                ((eq key ?r)            ; rename buffer
                 (let ((new-name (read-string "New buffer name: ")))
                   (while (get-buffer new-name)
                     ;; ask to rename again, if the new buffer name exists
                     (if (yes-or-no-p
                          (format (concat "A buffer named '%s' already exists: "
                                          "Rename again?")
                                  new-name))
                         (setq new-name (read-string "New buffer name: "))
                       (keyboard-quit)))
                   (rename-buffer new-name)
                   (message "Buffer '%s' successfully renamed to '%s'"
                            name new-name)))
                ;; ?\a = C-g, ?\e = Esc and C-[
                ((memq key '(?\a ?\e)) (keyboard-quit))))))))

(defun petmacs--file-path ()
  "Retrieve the file path of the current buffer.

Returns:
  - A string containing the file path in case of success.
  - `nil' in case the current buffer does not have a directory."
  (when-let (file-path (buffer-file-name))
    (file-truename file-path)))

(defun petmacs/copy-directory-path ()
  "Copy and show the directory path of the current buffer.

If the buffer is not visiting a file, use the `list-buffers-directory'
variable as a fallback to display the directory, useful in buffers like the
ones created by `magit' and `dired'."
  (interactive)
  (if-let (directory-path (petmacs--directory-path))
      (message "%s" (kill-new directory-path))
    (message "WARNING: Current buffer does not have a directory!")))

(defun petmacs/copy-file-path ()
  "Copy and show the file path of the current buffer."
  (interactive)
  (if-let (file-path (petmacs--file-path))
      (message "%s" (kill-new file-path))
    (message "WARNING: Current buffer is not attached to a file!")))

(defun petmacs/copy-file-name ()
  "Copy and show the file name of the current buffer."
  (interactive)
  (if-let (file-name (file-name-nondirectory (petmacs--file-path)))
      (message "%s" (kill-new file-name))
    (message "WARNING: Current buffer is not attached to a file!")))

(defun petmacs/projectile-copy-file-path ()
  "Copy and show the file path relative to project root."
  (interactive)
  (if-let (file-path (petmacs--projectile-file-path))
      (message "%s" (kill-new file-path))
    (message "WARNING: Current buffer is not visiting a file!")))

(defun petmacs/pop-eshell (arg)
  "Pop a shell in a side window.
Pass arg to ‘shell’."
  (interactive "P")
  (select-window
   (display-buffer-in-side-window
    (save-window-excursion
      (let ((prefix-arg arg))
        (call-interactively #'eshell))
      (current-buffer))
    '((side . right)
      (window-width . fit-window-to-buffer)))))

(defun petmacs/projectile-pop-eshell ()
  "Open a term buffer at projectile project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (call-interactively 'petmacs/pop-eshell)))


;; Recompile site-lisp directory
(defun recompile-site-lisp ()
  "Recompile packages in site-lisp directory."
  (interactive)
  (let ((dir (concat user-emacs-directory "site-lisp")))
    (if (fboundp 'async-byte-recompile-directory)
        (async-byte-recompile-directory dir)
      (byte-recompile-directory dir 0 t))))

(defun petmacs/find-dotfile ()
  "Edit the `dotfile', in the current window."
  (interactive)
  (find-file "~/.emacs.d/init.el"))
  ;; (find-file-existing (concat user-emacs-directory "init.el")))

(defun petmacs/find-custom-file ()
  "Edit the `dotfile', in the current window."
  (interactive)
  (find-file-existing (concat user-emacs-directory "custom.el")))

(defun petmacs/alternate-buffer (&optional window)
  "Switch back and forth between current and last buffer in the
current window."
  (interactive)
  (let ((current-buffer (window-buffer window)))
    ;; if no window is found in the windows history, `switch-to-buffer' will
    ;; default to calling `other-buffer'.
    (switch-to-buffer
     (cl-find-if (lambda (buffer)
                   (not (eq buffer current-buffer)))
                 (mapcar #'car (window-prev-buffers window)))
     nil t)))

(defun petmacs/frame-killer ()
  "Kill server buffer and hide the main Emacs window"
  (interactive)
  (condition-case nil
      (delete-frame nil 1)
    (error
     (make-frame-invisible nil 1))))


(provide 'leader-core-functions)
(message "leader-core-functions loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; core-functions.el ends here
