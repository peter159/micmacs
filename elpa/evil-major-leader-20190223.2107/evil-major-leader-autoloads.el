;;; evil-major-leader-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "evil-major-leader" "evil-major-leader.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from evil-major-leader.el

(autoload 'global-evil-major-leader-mode "evil-major-leader" "\
Global minor mode for <major-leader> support.

\(fn &optional ARG)" t nil)

(autoload 'evil-major-leader-mode "evil-major-leader" "\
Minor mode to enable <major-leader> support.

\(fn &optional ARG)" t nil)

(autoload 'evil-major-leader/set-leader "evil-major-leader" "\
Set leader key to `key'

\(fn KEY)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "evil-major-leader" '("evil-major-leader")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; evil-major-leader-autoloads.el ends here
