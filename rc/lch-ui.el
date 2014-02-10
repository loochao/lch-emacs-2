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
(require 'lch-key-util)
;;; Fullscreen
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
       (set-frame-parameter nil 'fullscreen
                            (if (equal 'fullboth current-value)
                                (if (boundp 'old-fullscreen) old-fullscreen nil)
                                (progn (setq old-fullscreen current-value)
                                       'fullboth)))))
(define-key global-map (kbd "<f11> <f11>") 'toggle-fullscreen)

;;; Fill-column-indicator
(require 'fill-column-indicator)
(setq fci-rule-width 1)
(setq fci-rule-color "pink")

(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
;; (global-fci-mode 1)

(define-key global-map (kbd "<f11> f") 'fci-mode)

;;; Rainbow-delimiter
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)
;;; Maxframe
;; FIXME: Not working under some monitor.
;; (require 'maxframe)
;; (add-hook 'window-setup-hook 'maximize-frame t)
(autoload 'mf-max-display-pixel-width "maxframe" "" nil)
(autoload 'mf-max-display-pixel-height "maxframe" "" nil)
(autoload 'maximize-frame "maxframe" "" t)
(autoload 'restore-frame "maxframe" "" t)

(when lch-mac-p
  (eval-after-load 'maxframe
    '(progn
       (fset 'maximize-frame 'x-maximize-frame)
       (fset 'restore-frame 'x-restore-frame))))

(when lch-mac-p
  (setq mf-display-padding-width 4
        mf-offset-x 0
        mf-offset-y 0
        mf-display-padding-height (if (when (boundp 'ns-auto-hide-menu-bar)
                                        ns-auto-hide-menu-bar)
                                      23
                                    (+ 27 23))))

(add-hook 'after-make-frame-functions 'maximize-frame)
(add-hook 'after-init-hook 'maximize-frame)
;;; Color-theme
(defvar emacs-theme-dir (concat emacs-lib-dir "/themes"))
(lch-add-subdirs-to-load-path emacs-theme-dir)

(require 'color-theme)
(require 'color-theme-loochao)
(color-theme-loochao)
(define-key global-map (kbd "<f11> <f2>") 
  (lambda () (interactive) "" (color-theme-loochao) (message "Color-theme-loochao loaded.")))

(autoload 'color-theme-lazycat "color-theme-lazycat" "" t)
(define-key global-map (kbd "<f11> <f3>") 
  (lambda () (interactive) (color-theme-lazycat) (message "Color-theme-lazycat loaded.")))

;;; Fonts
(if lch-linux-p (set-face-attribute 'default nil :height 160))
(when lch-win32-p 
  ;; (set-face-attribute 'default nil :height 160)
  (set-default-font "Courier New:pixelsize=24"))


;;; Tabbar
(require 'tabbar)
(tabbar-mode 1)

(defadvice tabbar-forward (around tabbar-forward-w3m activate)
  ""
  (if (derived-mode-p 'w3m-mode)
      (w3m-next-buffer 1)
    ad-do-it))

(defadvice tabbar-backward (around tabbar-backward-w3m activate)
  ""
  (if (derived-mode-p 'w3m-mode)
      (w3m-previous-buffer 1)
    ad-do-it))

(lch-set-key
 '(("s-h"  . tabbar-backward)
   ("s-l"    . tabbar-forward)
   ("s-7"  . tabbar-backward-group)
   ("s-8"    . tabbar-forward-group))
 tabbar-mode-map)

;;; Senu
;; line number
(require 'setnu)
;;; Cycle-color
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


;;; Modeline
;; (defun get-lines-4-mode-line ()
;;   "get line numbers of current buffer"
;;   (let ((lines (count-lines
;;                 (point-min) (point-max))))
;;     (format " %dL" lines)))

;; (defun get-size-indication-format ()
;;   (if (and transient-mark-mode mark-active)
;;       (format " (%dLs,%dCs)"
;;               (count-lines (region-beginning) (region-end))
;;               (abs (- (mark t) (point))))
;;     ""))

;; (defun set-mode-line-format ()
;;   "set mode-line-format"
;;   (setq-default mode-line-format
;;                 '((:eval
;;                    (if (eql buffer-read-only t)
;;                        (propertize " --RO--" 'face
;;                                    '(:foreground "Deepskyblue" :family "BN Elements"))
;;                      (propertize " --W/R--" 'face
;;                                  '(:foreground "Deepskyblue" :family "BN Elements"))))
;;                   (:eval
;;                    (propertize " %b"
;;                                'face (if (buffer-modified-p)
;;                                          '(:foreground "SpringGreen" :slant italic)
;;                                        '(:foreground "SpringGreen"))))
;;                   (:eval
;;                    (propertize (get-lines-4-mode-line)
;;                                'face '(:foreground "grey90")))
;;                   (:eval
;;                    (propertize (get-size-indication-format)
;;                                'face '(:foreground "yellow")))
;;                   (:eval
;;                    (propertize " (%l,%c)"
;;                                'face '(:foreground "#00eedd")))
;;                   (:eval
;;                    (propertize " ("
;;                                'face '(:foreground "White")))
;;                   (:eval
;;                    (propertize "%m"
;;                                'face '(:foreground "LightSkyBlue")))
;;                   minor-mode-alist
;;                   (:eval
;;                    (propertize ") "
;;                                'face '(:foreground "White")))
;;                   which-func-format
;;                   (:eval
;;                    (propertize (format-time-string " %H:%M ")
;;                                'face '(:foreground "White")
;;                                'help-echo
;;                                (concat (format-time-string "%c; ")
;;                                        (emacs-uptime "Uptime:%hh")))))))

;; (defun mode-line-setting ()
;;   "setings for modeline"
;;   (set-mode-line-format)
;;   (column-number-mode 1)
;;   ;; display log and buffer name on frame title
;;   (setq frame-title-format
;;         '((:eval
;;            (let ((login-name (getenv-internal "LOGNAME")))
;;              (if login-name (concat login-name "@") "")))
;;           (:eval (system-name))
;;           ":"
;;           (:eval (or (buffer-file-name) (buffer-name))))))

;; (mode-line-setting)

;;; Powerline
(when (and (>= emacs-major-version 24) (>= emacs-minor-version 3))
    (require 'powerline)
    (powerline-default-theme))

;;; PROVIDE
(provide 'lch-ui)

(message "~~ lch-ui: done.")
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:

