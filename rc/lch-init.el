;; -*- coding:utf-8; -*-

;;; INIT.EL
;;
;; Copyright (c)  Chao LU 2005 2006-2011
;;
;; Author:  Chao Lu <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; License: GNU
;; 
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Initialization settings

;;; CODE
(message "=> lch-init: loading...")

;; Parentheses
;; Paren color set in color-theme-lch.el
(when (fboundp 'show-paren-mode)
  (show-paren-mode 1)
  (setq show-paren-delay 0)
  ;; (setq show-paren-style 'expression)
  (setq show-paren-style 'parentheses))

;; Allow pasting selection outside of Emacs
(setq x-select-enable-clipboard t)

;; Smart pairing for all
;; -- automatically insert the other paren.
;; Only works under Emacs24
;; So switch to paredit.el instead.
;; (electric-pair-mode t)

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Frame title
;; that show either a file or a buffer name
(setq frame-title-format
      '("" invocation-name " LooChao - " (:eval (if (buffer-file-name)
                                                    (abbreviate-file-name (buffer-file-name))
                                                  "%b"))))

;; 'y' for 'yes', 'n' for 'no'
(fset 'yes-or-no-p 'y-or-n-p)

;; Don't beep at me
(setq visible-bell t)

;; Don't blink cursor
(when (fboundp 'blink-cursor-mode) 
  (blink-cursor-mode (- (*) (*) (*))))

;; Display column & line number
(when (fboundp 'line-number-mode)
  (line-number-mode 1))
(when (fboundp 'column-number-mode)
  (column-number-mode 1))

;; Sever-start
;; Start the emacs server only if another instance of the server is not running.
(require 'server)
(if (eq (server-running-p server-name) nil)
                (server-start))
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

;; enable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; enabled change region case commands
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Backup policy
(setq backup-directory-alist '(("" . "~/.emacs.var/backup")))

(setq make-backup-files t
      version-control t
      kept-old-versions 2
      kept-new-versions 5
      delete-old-versions t
      backup-by-copying t
      backup-by-copying-when-linked t
      backup-by-copying-when-mismatch t)

;; If we don't want backup files
;; (setq make-backup-files nil backup-inhibited t)

;; File local variables specifications 
;; are obeyed, without query -- RISKY!
(setq enable-local-variables t)

;; obey `eval' variables -- RISKY!
(setq enable-local-eval t)

;; More info:
;; (info "(emacs)Variables")
;; (info "(emacs)Directory Variables")


;; User info
(setq user-full-name "LooChao<LooChao@gmail.com>")
(setq user-mail-address "LooChao@gmail.com")

;; Death to the tabs!  However, tabs historically indent to the next
;; 8-character offset; specifying anything else will cause *mass*
;; confusion, as it will change the appearance of every existing file.
;; In some cases (python), even worse -- it will change the semantics
;; (meaning) of the program.
;;
;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
;; 
;; The settings below can be tested by enable whitespace mode
;; And see what <tab> does. Under the settings below, tab will insert
;; 8 whitespaces instead of a tab, which is nice.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Time setting
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-interval 10)
;; (setq display-time-format "<%V-%u> %m/%d/%H:%M")
(setq display-time-format "%a(%V) %m-%d/%H:%M")
(display-time)

;; Grammar highlight
;; Significant functionality depends on font-locking being active.
;; For all buffers
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; Delete the selection with a keypress
;; Remove text in active region if inserting text
(delete-selection-mode 1)

;; Truncate lines
;; t means aaaaa->
(set-default 'truncate-lines nil)

;; Display picture
(auto-image-file-mode)

;; Auto save
;; Put autosave files (i.e. #foo#) in one place, *NOT*
;; scattered all over the file system!

;; auto-save every 100 input events
(setq auto-save-interval 100)

;; auto-save after 15 seconds idle time
(setq auto-save-timeout 15)

(defvar autosave-dir
  (concat "~/.emacs.var/auto-save-list/" (user-login-name) "/"))
(make-directory autosave-dir t)

;;; PROVIDE
(provide 'lch-init)
(message "~~ lch-init: done.")


;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
