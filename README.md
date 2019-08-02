<img src="https://i.imgur.com/ro2uIXv.png" width="200" />

# SCMBAG
> SCMBag. (Git command shortcuts written in racket)

### A scm-breeze inspired git command shortcut program written in chicken scheme.

#### Why Racket ? 
Because bash is relatively slower. and racket seems not to have breaking changes, the program was earlier written in chicken scheme
which you can still find in archive but it was breaking with latest chicken, which is when it was rewritten in racket.

#### What does SCMBAG stand for ?
Pronounced 'Scumbag', is a bag of shortcuts for source control management program 'git'.

#### How about SCMPUFF which is written in 'golang' and not an obscure language like scheme?
Scheme is Fast (Specifically chicken scheme takes half as much time as scmpuff).
<img src="https://i.imgur.com/jFP9sub.png" title="source: imgur.com" />
But unfortunately chicken compiler introduces breakign stuff so we have to resort to mediocre path to portability.

#### Any other reason i should use SCMBAG instead of SCMBREEZE or SCMPUFF ?
It works great on 'Monorepos', speed is its main advantage hands down beats the other two.


## Installation/Compile

In Development instructions soon ....



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
