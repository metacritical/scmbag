(define alias-header "echo \"#SCMBAG aliases\n")

(define aliases
"
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
alias rm='scm -x'")

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


