(define alias-header "echo \"#SCMBAG aliases\n")

(define aliases
"alias gs='scmbag -s'
alias ga='scmbag -a'
alias gd='scmbag -d'
alias gps='git push'
alias gdc='git diff --cached'
alias gc='git commit'
alias gcm='scmbag -c'
alias gcma='scmbag -m'
alias gl='git log --graph'
alias gg='git log --graph --decorate --oneline'
alias grs='scmbag -r'
alias gb='scmbag -b'
alias gco='scmbag -o'
alias rm='scmbag -x'")

(define alias-file "\"> ~/.scmbag")

(define append-aliases
  "if grep -Fxq '#SCMBAG' ~/.bash_profile
then
echo \"Aliases already sourced into ~/.bash_profile\n\"
else
printf \"\nAppended scmbag aliases,\033[31m source ~/.scmbag\033[0m to .bash_profile\n\n\"
echo \"
#SCMBAG
source ~/.scmbag\" >> ~/.bash_profile
fi")


(define (init-aliases) 
  (system (string-append "" alias-header aliases alias-file))
  ;; Append aliases to bash profile.
  (system append-aliases)
  ;;Prints required action.
  (print "Reload Bash (execute the following):\n$ source ~/.bash_profile"))


