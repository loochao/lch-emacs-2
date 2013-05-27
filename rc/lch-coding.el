;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; CODING
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
;; Encoding of Emacs system

;;; CODE
(message "=> lch-coding: loading...")

(if (not (eq system-type 'windows-nt))
    (progn
      (set-language-environment "UTF-8")
      (prefer-coding-system       'utf-8)
      (set-default-coding-systems 'utf-8)
      (set-terminal-coding-system 'utf-8)
      (set-keyboard-coding-system 'utf-8)
      (setq locale-coding-system 'utf-8)
      (set-selection-coding-system 'utf-8)
      (setq file-name-coding-system 'utf-8)
      (setq coding-system-for-read 'utf-8)
      (setq coding-system-for-write 'utf-8)
      (setq buffer-file-coding-system 'utf-8)))

;;; PROVIDE
(provide 'lch-coding)
(message "~~ lch-coding: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
