;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; UI
;;
;; Copyright (c) 2006-2013 Charles LU
;;
;; Author:  Charles LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Settings for interface

;;; CODE
(message "=> lch-ui: loading...")

;; (require 'rainbow-delimiters)
;; (global-rainbow-delimiters-mode)
;;; Maxframe
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)

;;; Color-theme
(defvar emacs-theme-dir (concat emacs-lib-dir "/themes"))
(add-to-list 'load-path emacs-theme-dir)
(require 'color-theme)
(require 'color-theme-loochao)
(color-theme-loochao)

;;; Fonts
;;; Tabbar
(require 'tabbar)
(tabbar-mode 1)

;;; Senu
;; line number
(require 'setnu)
;;; Cycle color
(defun lch-cycle-fg-color (num)
  ""
  (interactive "p")
  (let (colorList colorToUse currentState nextState)
    (setq colorList (list
                     "MistyRose3"  "Wheat3" "Cornsilk"))
    ;; "Wheat2" "OliveDrab" "YellowGreen"
    (setq currentState (if (get 'lch-cycle-fg-color 'state) (get 'lch-cycle-fg-color 'state) 0))
    (setq nextState (% (+ currentState (length colorList) num) (length colorList)))
    (setq colorToUse (nth nextState colorList))
    (set-frame-parameter nil 'foreground-color colorToUse)
    (redraw-frame (selected-frame))
    (message "Current foreColor is %s" colorToUse)
    (put 'lch-cycle-fg-color 'state nextState)))

(defun lch-cycle-fg-color-forward ()
  "Switch to the next color, in the current frame.
See `cycle-color'."
  (interactive)
  (lch-cycle-fg-color 1))
(define-key global-map (kbd "<f11> 1") 'lch-cycle-fg-color-forward)

;; (defun lch-cycle-fg-color-backward ()
;;   "Switch to the next color, in the current frame.
;; See `cycle-color'."
;;   (interactive)
;;   (lch-cycle-fg-color -1))
;; (define-key global-map (kbd "<f11> 2") 'lch-cycle-fg-color-backward)

(defun lch-cycle-bg-color (num)
  ""
  (interactive "p")
  (let (colorList colorToUse currentState nextState)
    (setq colorList (list
                     "Black" "#454545" "DarkSeaGreen" "#dca3ac"))
    ;; "DarkSlateGray"
    (setq currentState (if (get 'lch-cycle-bg-color 'state) (get 'lch-cycle-bg-color 'state) 0))
    (setq nextState (% (+ currentState (length colorList) num) (length colorList)))
    (setq colorToUse (nth nextState colorList))
    (set-frame-parameter nil 'background-color colorToUse)
    (redraw-frame (selected-frame))
    (message "Current backColor is %s" colorToUse)
    (put 'lch-cycle-bg-color 'state nextState)))

(defun lch-cycle-bg-color-forward ()
  "Switch to the next color, in the current frame.
See `cycle-color'."
  (interactive)
  (lch-cycle-bg-color 1))
(define-key global-map (kbd "<f11> 2") 'lch-cycle-bg-color-forward)

;; (defun lch-cycle-bg-color-backward ()
;;   "Switch to the next color, in the current frame.
;; See `cycle-color'."
;;   (interactive)
;;   (lch-cycle-bg-color -1))
;; (define-key global-map (kbd "<f11> 4") 'lch-cycle-bg-color-backward)

(defun lch-frame-black ()
  (interactive)
  (set-frame-parameter nil 'foreground-color "MistyRose")
  (set-frame-parameter nil 'background-color "Black")
  (redraw-frame (selected-frame)))
(define-key global-map (kbd "<f11> 3") 'lch-frame-black)

(defun lch-frame-pink ()
  (interactive)
  (set-frame-parameter nil 'foreground-color "black")
  (set-frame-parameter nil 'background-color "#dca3ac")
  (redraw-frame (selected-frame)))
(define-key global-map (kbd "<f11> 4") 'lch-frame-pink)

(message "~~ lch-ui: done.")


;;; PROVIDE
(provide 'lch-ui)

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:

