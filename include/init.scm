(define aliases #<<EOF
echo "#SCMBAG aliases

alias scm='scmbag'
alias gs='scm -s'
alias ga='scm -a'
alias gd='scm -d'
alias gps='git push'
alias gdc='git diff --cached'
alias gc='git commit'
alias gcm='scm -c'
alias gcma='scm -m'
alias gl='git log --graph'
alias gg='git log --graph --decorate --oneline'
alias grs='scm -r'
alias gb='scm -b'
alias gco='scm -o'
alias grm='scm -x'" > ~/.scmbag
EOF
)

(define append-aliases #<<EOF
  if grep -Fxq '#SCMBAG' ~/.bash_profile
  then
  echo  "Aliases already sourced into ~/.bash_profile\n"
  else
  printf "\nAppended scmbag aliases,\033[31m source ~/.scmbag\033[0m to ~/.bash_profile\n\n" 
  echo "\n#SCMBAG\nsource ~/.scmbag" >> ~/.bash_profile
  fi
EOF
)

(define src-msg #<<EOF
Reload Bash (execute the following):
$ source ~/.bash_profile
EOF
)


(define (init-aliases) 
  (system aliases)
  ;; Append aliases to bash profile.
  (system append-aliases)
  ;;Prints required action.
  (print src-msg))

(define (show-alias)
  (print aliases))
