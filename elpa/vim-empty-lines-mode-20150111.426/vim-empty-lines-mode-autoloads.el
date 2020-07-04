;;; vim-empty-lines-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "vim-empty-lines-mode" "vim-empty-lines-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from vim-empty-lines-mode.el

(autoload 'vim-empty-lines-mode "vim-empty-lines-mode" "\
Display `vim-empty-lines-indicator' on visible lines after the end of the buffer.

This differs from `indicate-empty-lines' in the way that it deals
with trailing newlines.

\(fn &optional ARG)" t nil)

(defvar global-vim-empty-lines-mode nil "\
Non-nil if Global Vim-Empty-Lines mode is enabled.
See the `global-vim-empty-lines-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-vim-empty-lines-mode'.")

(custom-autoload 'global-vim-empty-lines-mode "vim-empty-lines-mode" nil)

(autoload 'global-vim-empty-lines-mode "vim-empty-lines-mode" "\
Toggle Vim-Empty-Lines mode in all buffers.
With prefix ARG, enable Global Vim-Empty-Lines mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Vim-Empty-Lines mode is enabled in all buffers where
`(lambda nil (unless (or (minibufferp) (string-match-p \\*Echo Area [0-9]+\\* (buffer-name))) (vim-empty-lines-mode 1)))' would do it.
See `vim-empty-lines-mode' for more information on Vim-Empty-Lines mode.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "vim-empty-lines-mode" '("vim-empty-lines-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; vim-empty-lines-mode-autoloads.el ends here
