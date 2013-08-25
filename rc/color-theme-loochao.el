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

     (ffap ((t (:background "DarkRed" :foreground "White"))))
     (minibuffer-prompt ((t (:foreground "Cyan"))))
     ;; Font-lock-options
     (font-lock-comment-face ((t (:foreground "#7f9f7f"))))
     (font-lock-comment-delimiter-face ((t (:foreground "#7f9f7f"))))
     ;; (font-lock-comment-face ((t (:foreground "Orange"))))
     ;; (font-lock-comment-delimiter-face ((t (:foreground "Orange"))))
     ;; (font-lock-comment-face ((t (:foreground "#869497" :slant italic))))
     ;; (font-lock-comment-delimiter-face ((t (:foreground "#869497" :slant italic))))


     (font-lock-builtin-face ((t (:foreground "LightSteelBlue"))))
     (font-lock-constant-face ((t (:foreground "LightGoldenrod"))))
     (font-lock-doc-face ((t (:foreground "LightSalmon" :slant italic))))
     (font-lock-function-name-face ((t (:foreground "LightSkyBlue"))))
     (font-lock-keyword-face ((t (:foreground "Cyan"))))
     (font-lock-string-face ((t (:foreground "LightSalmon"))))
     (font-lock-type-face ((t (:foreground "PaleGreen"))))
     (font-lock-variable-name-face ((t (:foreground "LightGoldenrod"))))
     (font-lock-warning-face ((t (:foreground "#ff0000"))))

     ;; Modeline
     (mode-line ((t (:background "DarkRed" :foreground "white" :height 0.92 :box (:line-width -1 :style released-button)))))
     (mode-line-buffer-id ((t (:bold t :weight bold))))
     (mode-line-emphasis ((t (:bold t :weight bold))))
     (mode-line-highlight ((t (:box (:line-width -1 :color "DarkRed" :style released-button)))))
     (mode-line-inactive ((t (:background "grey30" :foreground "white" :height 0.91 :box (:line-width -1 :color "grey30" :style released-button)))))

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

     ;; EMMS
     (emms-playlist-selected-face ((t (:foreground "LightSteelBlue"))))
     (emms-playlist-mark-face ((t (:foreground "Pink"))))
     (emms-playlist-track-face ((t (:foreground "DarkSeaGreen"))))

     ;; Org
     (org-document-title ((t (:foreground "Pale Turquoise" :weight normal :height 1.2))))

     (org-level-1 ((t (:foreground "PaleGreen"))))
     (org-level-2 ((t (:foreground "DarkSeaGreen"))))
     (org-level-3 ((t (:foreground "LightSteelBlue"))))
     (org-level-4 ((t (:foreground "LightGoldenrod"))))
     (org-level-5 ((t (:foreground "DeepSkyBlue"))))
     (org-level-6 ((t (:foreground "Cyan"))))
     (org-level-7 ((t (:foreground "Yellow"))))
     (org-level-8 ((t (:foreground "DarkRed"))))

     (org-meta-line ((t (:foreground "LightPink4"))))
     (org-todo ((t (:bold t :foreground "Orange" :weight bold
                              :box (:line-width 1 :style none)))))
     ;; iSearch
     (isearch ((t (:background "Pink" :foreground "black"))))
     (isearch-fail ((t (:background "grey90" :foreground "red2"))))

     ;; Tabbar
     (tabbar-default ((t (:height 0.97 :background "black"))))
     (tabbar-highlight ((t (nil))))
     (tabbar-button ((t (:background "black" :foreground "green" :box (:line-width -1 :color "green" :style released-button)))))
     (tabbar-button-highlight ((t (:background "black" :foreground "green" :box (:line-width -1 :color "green" :style released-button)))))
     (tabbar-selected ((t (:background "grey30" :foreground "LawnGreen" :height 0.97))))
     (tabbar-separator ((t (:background "black" :height 0.97))))
     (tabbar-unselected ((t (:background "grey20" :foreground "grey60" :height 0.97))))

     ;; (tabbar-default (((:inherit variable-pitch :height 0.95 :family "monaco"))))
     ;; (tabbar-separator ((t (:inherit tabbar-default :background "black" :foreground "brown" :height 0.1))))
     ;; (tabbar-button-highlight ((t (:inherit tabbar-default :background "black"
     ;;    				    :foreground "green" :box (:color "red")))))
     ;; (tabbar-button
     ;;  ((t (:inherit tabbar-default :background "black" :foreground "red"
     ;;                :box (:line-width 1 :color "black" :style released-button)))))
     ;; (tabbar-selected
     ;;  ((t (:inherit tabbar-default :background "black" :foreground "LawnGreen"
     ;;                :box (:line-width 1 :color "#014500" :style released-button)))))
     ;; (tabbar-selected-face
     ;;  ((t (:inherit tabbar-default-face :background "black" :foreground "grey"
     ;;                :box (:line-width -1 :color "grey" :style released-button)))))
     ;; (tabbar-unselected
     ;;  ((t (:inherit tabbar-default :background "black" :foreground "#10650F"
     ;;                :box (:line-width 1 :color "Grey10" :style pressed-button)))))
     ;; (tabbar-unselected-face
     ;;  ((t (:inherit tabbar-default-face :background "black" :foreground "white"
     ;;                :box (:line-width -1 :color "black" :style pressed-button)))))

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

     ;; w3m
     (w3m-anchor ((t (:foreground "DarkSeaGreen" :underline t :height 1.05))))
     (w3m-arrived-anchor ((t (:foreground "red4" :underline t))))
     (w3m-bold ((t (:foreground "red3" :weight normal :height 1.05))))
     (w3m-current-anchor ((t (:box (:line-width -1 :color "Grey30") :underline t))))
     (w3m-form ((t (:foreground "khaki2" :underline "brown"))))
     (w3m-form-button ((t (:background "white" :foreground "black" :box (:line-width 1 :color "grey80" :style released-button) :height 1.05))))
     (w3m-form-button-mouse ((t (:background "Black" :foreground "LightSalmon" :box (:line-width -1 :color "Grey30" :style released-button)))))
     (w3m-form-button-pressed ((t (:background "Black" :foreground "Orange" :box (:line-width -1 :color "Grey60" :style pressed-button)))))
     (w3m-header-line-location-content ((t (:background "black" :foreground "DarkSeaGreen" :weight normal :height 1.05))))
     (w3m-header-line-location-title ((t (:background "black" :foreground "LightSalmon" :weight normal :height 1.05))))
     (w3m-history-current-url ((t (:background "black" :foreground "LightSalmon" :height 1.05))))
     (w3m-image ((t (:background "Black" :foreground "DarkRed"))))
     (w3m-image-anchor ((t (:background "Black"))))
     (w3m-insert ((t (:foreground "orchid"))))
     (w3m-italic ((t (:italic t :slant italic))))
     (w3m-link-numbering ((t (:foreground "LightSalmon2"))))
     (w3m-linknum-match ((t (:inverse-video t))))
     (w3m-linknum-minibuffer-prompt ((t (:foreground "LightSalmon"))))
     (w3m-session-select ((t (:foreground "white"))))
     (w3m-session-selected ((t (:bold t :foreground "white" :underline t :weight bold))))
     (w3m-strike-through ((t (:strike-through t))))
     (w3m-tab-background ((t (:background "black" :foreground "black" :height 0.97))))
     (w3m-tab-mouse ((t (:background "grey30" :foreground "PaleGreen" :height 0.97))))
     (w3m-tab-selected ((t (:background "grey30" :foreground "PaleGreen" :height 0.97))))
     (w3m-tab-selected-background ((t (:background "black" :foreground "black" :height 0.97))))
     (w3m-tab-selected-retrieving ((t (:background "grey30" :foreground "DarkSeaGreen" :height 0.97))))
     (w3m-tab-unselected ((t (:background "grey20" :foreground "grey80" :height 0.97))))
     (w3m-tab-unselected-retrieving ((t (:background "grey20" :foreground "grey80" :height 0.97))))
     (w3m-tab-unselected-unseen ((t (:background "grey20" :foreground "grey80" :height 0.97))))
     (w3m-underline ((t (:underline t))))
     
     ;; Dired
     (dired-directory ((t (:foreground "LightSkyBlue" :height 1.05))))
     ;; (dired-flagged ((t (:foreground "red" :height 1.05))))
     (dired-header ((t (:foreground "PaleGreen" :height 1.05))))
     ;; (dired-ignored ((t (:foreground "white" :height 1.05))))
     ;; (dired-mark ((t (:foreground "Pink"))))
     (dired-marked ((t (:foreground "Pink" :height 1.05))))
     (dired-perm-write ((t (:foreground "DarkRed" :height 1.05))))
     (dired-symlink ((t (:foreground "grey60" :height 1.05))))
     (dired-warning ((t (:foreground "gold" :height 1.05))))
     (dired-filetype-common ((t (:foreground "Peru" :height 1.05))))
     (dired-filetype-compress ((t (:foreground "Pink" :height 1.05))))
     (dired-filetype-document ((t (:foreground "LightGoldenrod" :height 1.05))))
     (dired-filetype-execute ((t (:foreground "DarkRed" :height 1.05))))
     (dired-filetype-image ((t (:foreground "SlateBlue" :height 1.05))))
     (dired-filetype-lnk ((t (:foreground "Cyan" :height 1.05))))
     (dired-filetype-music ((t (:foreground "Orange" :height 1.05))))
     (dired-filetype-omit ((t (:foreground "grey50" :height 1.05))))
     (dired-filetype-plain ((t (:foreground "PaleGreen" :height 1.05))))
     (dired-filetype-source ((t (:foreground "PaleGreen" :height 1.05))))
     (dired-filetype-video ((t (:foreground "Pink" :height 1.05))))
     (dired-filetype-xml ((t (:foreground "Chocolate" :height 1.05))))
     )))

(provide 'color-theme-loochao)
(color-theme-loochao)
