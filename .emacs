(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(require 'evil)
(evil-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (gruvbox)))
 '(custom-safe-themes
   (quote
    ("3fd0fda6c3842e59f3a307d01f105cce74e1981c6670bb17588557b4cebfe1a7" default)))
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/test.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

(visual-line-mode 1)

;; FONTS:
(set-default-font "M+ 1mn-10")

;;Stop creating backup files
(setq make-backup-files nil)

;; Org mode stuff
;; Make org-mode work with files ending in .org
(require 'org)
(transient-mark-mode 1)

;; INDENTATION in org mode

(add-hook 'org-mode-hook
                    (lambda ()
                    (org-indent-mode t))
                    t)

;; word wrap at 100 characters
(add-hook 'text-mode-hook '(lambda() (turn-on-auto-fill) (set-fill-column 100)))
;; wrap by word
(setq-default word-wrap t)
