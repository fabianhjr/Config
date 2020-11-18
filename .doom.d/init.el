;;; init.el -*- lexical-binding: t; -*-

(doom! :ui
       ; Doom
       doom
       doom-dashboard    ; a nifty splash screen for Emacs
       doom-quit         ; DOOM quit-message prompts when you quit Emacs

       ; Visual
       (emoji +unicode)  ; 🙂
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       (ligatures)         ; ligatures and symbols to make your code pretty again
       minimap           ; show a map of the code on the side
       modeline          ; snazzy, Atom-inspired modeline, plus API
       ophints           ; highlight the region an operation acts on
       unicode           ; extended unicode support for various languages
       vc-gutter         ; vcs diff in the fringe

       ; Browsing
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       treemacs          ; a project drawer, like neotree but cooler
       workspaces        ; tab emulation, persistence & separate workspaces

       ; input
       multiple-cursors  ; editing in many places at once
       window-select     ; visually switch windows

       :completion
       company           ; the ultimate code completion backend
       (helm +fuzzy)              ; the *other* search engine for love and life

       :emacs
       (dired +icons)             ; making dired pretty [functional]
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files
       fold              ; (nigh) universal code folding
       (format +onsave)  ; automated prettiness
       snippets          ; my elves. They type so I don't have to
       word-wrap         ; soft wrapping with language-aware indent

       :checkers
       syntax              ; tasing you for every semicolon you forget
       ; spell             ; tasing you for misspelling mispelling
       grammar           ; tasing grammar mistake every you make

       :tools
       (eval +overlay)     ; run code, run (also, repls)
       lookup              ; navigate your code and its documentation
       lsp
       (magit +forge)             ; a git porcelain for Emacs
       make              ; run make tasks from Emacs
       (pass +auth)              ; password manager for nerds
       pdf               ; pdf enhancements
       rgb               ; creating color strings

       :term
       vterm             ; the best terminal emulation in Emacs

       :lang
       ; Markup
       (org +journal +noter +pandoc +pretty +roam)               ; organize your plain life in plain text
       data              ; config/data formats
       json              ; At least it ain't XML
       latex             ; writing papers in Emacs has never been so fun
       markdown          ; writing docs for people to ignore
       web               ; the tubes
       yaml              ; JSON, but readable

       ; Normal
       cc                ; C/C++/Obj-C madness
       crystal           ; ruby at the speed of c
       d
       (go +lsp)         ; the hipster dialect
       ess               ; emacs speaks statistics
       java ; the poster child for carpal tunnel syndrome
       javascript        ; all(hope(abandon(ye(who(enter(here))))))
       julia             ; a better, faster MATLAB
       kotlin            ; a better, slicker Java(Script)
       lua               ; one-based indices? one-based indices
       nim               ; python + lisp at the speed of c
       python            ; beautiful is better than ugly
       (ruby +rails)     ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
       rust              ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       sh                ; she sells {ba,z,fi}sh shells on the C xor

       ; Functional
       clojure           ; java with a lisp
       common-lisp       ; if you've seen one lisp, you've seen them all
       elixir            ; erlang done right
       elm               ; care for a cup of TEA?
       emacs-lisp        ; drown in parentheses
       erlang            ; an elegant language for a more civilized age
       (haskell +dante)  ; a language that's lazier than I am
       nix               ; I hereby declare "nix geht mehr!"
       ocaml             ; an objective camel
       purescript        ; javascript, but functional
       racket            ; a DSL for DSLs
       scala             ; java, but good
       scheme            ; a fully conniving family of lisps
       sml

       ; Dependent
       agda              ; types of types of types of types...
       coq               ; proofs-as-programs
       idris             ; a language you can depend on

       :app
       (rss +org)        ; emacs as an RSS reader

       :config
       (default +bindings +smartparens))
