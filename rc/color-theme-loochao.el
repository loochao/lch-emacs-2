;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; COLOR-THEME-LOOCHAO
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

(require 'color-theme)

(defun color-theme-loochao ()
  "Loochao colour theme by Charles Lu."
  (interactive)
  (color-theme-install
   '(color-theme-loochao
     ((background-color . "Black")
      (background-mode . dark)
      (border-color . "Black")
      (cursor-color . "Sienna1")
      (foreground-color . "MistyRose")
      ;; (foreground-color . "LightSalmon")
      (mouse-color . "sienna1"))

     (region ((t (:background "#454545"))))     
     (show-paren-match-face ((t (:background "#454545" :foreground "White"))))
     (show-paren-mismatch-face ((t (:background "Red" :foreground "White"))))

     (ido-subdir ((t (:foreground "LightSalmon" :background "black"))))

     ;; (font-lock-comment-face ((t (:foreground "Orange"))))
     ;; (font-lock-comment-delimiter-face ((t (:foreground "Orange"))))
     
     ;; Font-lock-options
     (font-lock-comment-face ((t (:foreground "#7f9f7f"))))
     (font-lock-comment-delimiter-face ((t (:foreground "#7f9f7f"))))
     ;; Modeline
      (mode-line
       ((t (:foreground "White" :background "DarkRed"
                        :box (:line-width -1 :style released-button)))))
     ;; Rainbow-delimiter
     (rainbow-delimiters-depth-1-face ((t (:foreground "#8b0000"))))
     (rainbow-delimiters-depth-2-face ((t (:foreground "#d3d3d3"))))
     (rainbow-delimiters-depth-3-face ((t (:foreground "#6a5acd"))))
     (rainbow-delimiters-depth-4-face ((t (:foreground "#94bff3"))))
     (rainbow-delimiters-depth-5-face ((t (:foreground "DarkSeaGreen"))))
     (rainbow-delimiters-depth-6-face ((t (:foreground "#add8e6"))))
     (rainbow-delimiters-depth-7-face ((t (:foreground "#ffa500"))))
     (rainbow-delimiters-depth-8-face ((t (:foreground "#6a5acd"))))
     (rainbow-delimiters-depth-9-face ((t (:foreground "#d3d3d3"))))
     (rainbow-delimiters-depth-10-face ((t (:foreground "#ffffff"))))
     (rainbow-delimiters-depth-11-face ((t (:foreground "#94bff3"))))
     (rainbow-delimiters-depth-12-face ((t (:foreground "#8c5353"))))

     ;; Tabbar
     (tabbar-default (((:inherit variable-pitch :height 0.95 :family "monaco"))))
     (tabbar-separator ((t (:inherit tabbar-default :background "black" :foreground "brown" :height 0.1))))
     (tabbar-button-highlight ((t (:inherit tabbar-default :background "black"
					    :foreground "green" :box (:color "red")))))
     (tabbar-button
      ((t (:inherit tabbar-default :background "black" :foreground "red"
                    :box (:line-width 1 :color "black" :style released-button)))))
     (tabbar-selected
      ((t (:inherit tabbar-default :background "black" :foreground "LawnGreen"
                    :box (:line-width 1 :color "#014500" :style released-button)))))
     (tabbar-selected-face
      ((t (:inherit tabbar-default-face :background "black" :foreground "grey"
                    :box (:line-width -1 :color "grey" :style released-button)))))
     (tabbar-unselected
      ((t (:inherit tabbar-default :background "black" :foreground "#10650F"
                    :box (:line-width 1 :color "Grey10" :style pressed-button)))))
     (tabbar-unselected-face
      ((t (:inherit tabbar-default-face :background "black" :foreground "white"
                    :box (:line-width -1 :color "black" :style pressed-button)))))

     ;; Auto-complete
     (ac-candidate-face ((t (:background "#454545" :foreground "MistyRose"))))
     (ac-candidate-mouse-face ((t (:background "gray" :foreground "Black"))))
     (ac-menu-face ((t (:background "Grey10" :foreground "Grey40"))))
     (ac-selection-face ((t (:background "Green4" :foreground "Green"))))
     (ac-yasnippet-menu-face ((t (:background "Grey10" :foreground "Grey40"))))
     (ac-yasnippet-selection-face ((t (:background "DarkRed" :foreground "Grey"))))

     ;; Volatile-highlight
     ;; (vhl/default-face ((t (:background "DarkSeaGreen" :foreground "Black"))))
     (vhl/default-face ((t (:background "#dca3ac" :foreground "Black"))))

     ;; highlight-line
     (highlight ((t (:background "#333333"))))

     ;; w3m color
     (w3m-anchor ((t (:foreground "SlateBlue" :underline t))))
     (w3m-arrived-anchor ((t (:foreground "Purple4" :underline t))))
     (w3m-bold ((t (:foreground "Green3" :weight bold))))
     (w3m-current-anchor
      ((t (:box (:line-width -1 :color "Grey30") :underline t))))
     (w3m-form          
      ((t (:foreground "Red" :box nil :underline "DarkRed"))))
     (w3m-form-button   
      ((t (:background "black" :foreground "LawnGreen" 
		       :box (:line-width -1 :color "#014500" style released-button)))))
     (w3m-form-button-mouse
      ((((type x w32 mac) (class color))
        (:background "Black" :foreground "Red"
                     :box (:line-width -1 :color "Grey30" :style released-button)))))
     (w3m-form-button-pressed
      ((((type x w32 mac) (class color))
        (:background "Black" :foreground "DarkRed" 
		     :box (:line-width -1 :color "Grey60" :style pressed-button)))))
     (w3m-form-face
      ((((class color) (background dark))
        (:foreground "khaki2" :underline "brown"))) t)
     (w3m-header-line-location-content
      ((((class color) (background dark))
        (:background "black" :foreground "Green"))))
     (w3m-header-line-location-title
      ((((class color) (background dark))
        (:background "black" :foreground "brown"))))
     (w3m-history-current-url
      ((t (:background "black" :foreground "DodgerBlue"))))
     (w3m-image
      ((((class color) (background dark))
        (:background "Black" :foreground "DarkRed"))))
     (w3m-image-anchor
      ((((class color) (background dark))
        (:background "Black"))))
     (w3m-session-select
      ((((class color) (background dark))
        (:foreground "grey50"))))
     (w3m-tab-background
      ((((type x w32 mac) (class color))
        (:background "black" :foreground "black"))))
     ;; (w3m-tab-background
     ;;  ((((type x w32 mac ns) (class color))
     ;;    (:background "grey" :foreground "black"))))
     (w3m-tab-selected-background
      ((((type x w32 mac) (class color))
        (:background "black" :foreground "black"))))
     (w3m-tab-mouse
      ((((type x w32 mac) (class color))
        (:background "#454545" :foreground "LawnGreen"
                     :box (:line-width -1 :color "Red" :style released-button)))))
     (w3m-tab-selected
      ((((type x w32 mac) (class color))
        (:background "black" :foreground "LawnGreen"
                     :box (:line-width -1 :color "#014500" :style released-button)))))
     (w3m-tab-selected-retrieving
      ((((type x w32 mac) (class color))
        (:background "black" :foreground "grey80"
                     :box (:line-width -1 :color "Grey40" :style released-button)))))
     (w3m-tab-unselected
      ((((type x w32 mac) (class color))
        (:background "black" :foreground "#10650F"
                     :box (:line-width 1 :color "Black" :style pressed-button)))))
     (w3m-tab-unselected-retrieving ((((type x w32 mac) (class color))
				      (:background "black" :foreground "grey30"
                     :box (:line-width 1 :color "Black" :style pressed-button)))))
     (w3m-tab-unselected-unseen ((((type x w32 mac) (class color))
        (:background "black" :foreground "SlateBlue"
                     :box (:line-width 1 :color "black" :style pressed-button)))))
     (w3m-link-numbering ((((class color) (background dark))
        (:background "Black" :foreground "Grey"))))

     )))

(provide 'color-theme-loochao)
