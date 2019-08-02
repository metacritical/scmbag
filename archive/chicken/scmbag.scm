(require-library extras data-structures srfi-13 srfi-69)
(require-extension scsh-process args)
(include "include/util.scm")
(include "include/init.scm")
(include "include/options.scm")
(include "include/git.scm")

(receive (options operands)
    (args:parse (command-line-arguments) cli-opts) "")
