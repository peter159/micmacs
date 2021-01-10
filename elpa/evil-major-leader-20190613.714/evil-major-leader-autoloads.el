;;; evil-major-leader-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "evil-major-leader" "evil-major-leader.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from evil-major-leader.el

(autoload 'global-evil-major-leader-mode "evil-major-leader" "\
Global minor mode for <major-leader> support.

If called interactively, toggle `Global Evil-Major-Leader mode'.
If the prefix argument is positive, enable the mode, and if it is
zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'evil-major-leader-mode "evil-major-leader" "\
Minor mode to enable <major-leader> support.

If called interactively, toggle `Evil-Major-Leader mode'.  If the
prefix argument is positive, enable the mode, and if it is zero
or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'evil-major-leader/set-leader "evil-major-leader" "\
Set leader key to `key'

\(fn KEY)" nil nil)

(register-definition-prefixes "evil-major-leader" '("evil-major-leader"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; evil-major-leader-autoloads.el ends here
