;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; W32
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author:  Chao LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Control file of which one to load

;;; CODE
(message "=> lch-w32: loading...")
;;; Setting
(defvar cygwin-root "e:/VAR/VPgm/EMUnixNT/Unix/Cygwin")
(defvar cygwin-bin (concat cygwin-root "/bin"))

(when lch-win32-p
  (progn
    (setenv "PATH"
            (concat
	     "C:\\cygwin\\usr\\local\\bin" ";"
             "C:\\cygwin\\usr\\bin" ";"
             "C:\\cygwin\\bin" ";"
             "/usr/bin" ";"
             (getenv "PATH")))

    (setq exec-path
          `(
            "C:/Program Files/ErgoEmacs 1.8.1/msys/bin/"
            ,cygwin-root
            ,cygwin-bin
            (concat cygwin-root "usr/bin/")
            "C:/Program Files/Java/jdk1.6.0_14/bin/"
            "C:/Program Files (x86)/Emacs/EmacsW32/gnuwin32/bin/"
            "C:/Windows/system32/"
            "C:/Windows/"
            "C:/Windows/System32/Wbem/"
            ))))

;;; Cygwin-mount
;; (require 'cygwin-mount)
;; (cygwin-mount-activate)

;;; Print-w32
(if lch-win32-p
    (progn
      (require 'w32-winprint)
      (define-key global-map (kbd "<f2> p") 'w32-winprint-print-buffer-htmlize)
      (define-key global-map (kbd "<f2> P") 'w32-winprint-print-buffer-notepad)))


;;; W32 max/restore frame
;; (if lch-win32-p
;;     (when (fboundp 'w32-send-sys-command)
;;       (progn
;;         (defun w32-restore-frame ()
;;           "Restore a minimized frame"
;;           (interactive)
;;           (w32-send-sys-command 61728))
;;         (defun w32-maximize-frame ()
;;           "Maximize the current frame"
;;           (interactive)
;;           (w32-send-sys-command 61488))
;;         (define-key global-map (kbd "<f11> m") 'w32-maximize-frame))))

;;; PROVIDE
(provide 'lch-w32)
(message "~~ lch-w32: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
