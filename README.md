<img src="https://i.imgur.com/ro2uIXv.png" width="200" />

# SCMBAG
> SCMBag. (Git command shortcuts written in chicken scheme)

### A scm-breeze inspired git command shortcut program written in chicken scheme.

#### Why chicken scheme ? 
Because bash is relatively slower. and chicken scheme outputs compiled binaries which are super fast.

#### What does SCMBAG stand for ?
Pronounced 'Scumbag', is a bag of shortcuts for source control management program 'git'.

#### How about SCMPUFF which is written in 'golang' and not an obscure language like scheme?
Scheme is Fast (Specifically chicken scheme takes half as much time as scmpuff).
<img src="https://i.imgur.com/jFP9sub.png" title="source: imgur.com" />

#### Any other reason i should use SCMBAG instead of SCMBREEZE or SCMPUFF ?
It works great on 'Monorepos', speed is its main advantage hands down beats the other two.


## Installation/Compile

Compile using chickem scheme. 
```bash
$ make
Compiling scmbag
csc scmbag.scm 
Aliases already sourced into ~/.bash_profile

Reload Bash (execute the following):
$ source ~/.bash_profile
Installing scmbag
cp scmbag /usr/local/bin/

```

## Usage

##### git status
```bash
gs
```
<img src="https://i.imgur.com/DuhFUEw.png" title="source: imgur.com"/>

```bash
ga  1
```
<img src="https://i.imgur.com/yBAI1gd.png" title="source: imgur.com" />

```bash
rm 1
```
<img src="https://i.imgur.com/JMYfRDF.png" title="source: imgur.com" />
