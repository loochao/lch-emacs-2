;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; VIPER
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
(message "=> lch-viper: loading...")

;; Level 3 and 5 doesn't really make a difference to me
(setq viper-expert-level '3)
(setq viper-inhibit-startup-message t)
(setq viper-toggle-key (kbd "C-c v"))
                
;; If you don't have this line, C-d will not delete in insert state,
;; which can be confusing...  The default binding is to back tab.
(define-key viper-insert-global-user-map (kbd "C-d") 'delete-char) 

;; This next is probadly the most crucial re-binding in this file.
;; If you don't set this line, C-h moves backwards a character.)
(setq viper-want-ctl-h-help 't)

;;; PROVIDE
(provide 'lch-viper)
(message "~~ lch-viper: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
