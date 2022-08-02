;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Fabián Heredia Montiel"
      user-mail-address "fabianhjr@protonmail.com")

(setq doom-theme 'badwolf)
(setq doom-font (font-spec :family "FiraCode" :size 18))

(setq display-line-numbers-type t)
(setq-default indent-tabs-mode t)

(setq exec-path (append exec-path '("/home/fabian/.local/bin")))

(setq org-directory "~/Documents/KnowledgeBase/")

(setq org-agenda-files "~/Documents/KnowledgeBase/Agenda.org")

(setq org-roam-complete-everywhere t)
(setq org-roam-directory org-directory)
(setq org-roam-dailies-directory "Journal/")

(use-package! idris-mode
  :mode ("\\.l?idr\\'" . idris-mode)
  :config

  (after! lsp-mode
    (add-to-list 'lsp-language-id-configuration '(idris-mode . "idris2"))

    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "idris2-lsp")
      :major-modes '(idris-mode)
      :server-id 'idris2-lsp))
    )
  (setq lsp-semantic-tokens-enable t)

  (add-hook 'idris-mode-hook #'lsp!)
  )

(add-to-list 'auto-mode-alist '("\\.coconut\\'" . python-mode))
