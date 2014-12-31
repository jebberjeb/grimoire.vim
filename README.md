grimoire.vim
============

Vim support for [Clojure Grimoire](http://conj.io)

:Grim - echo doc for symbol under cursor  
:GrimBuffer - Similar to :Grim but creates new buffer  
:GrimBrowse - open doc in browser (using gx) 

Dependencies
============

* [vim-fireplace](https://github.com/tpope/vim-fireplace)

Installation
============

First, install the Vim plugin. Using Vundle, you'd add the following to your
config:

    Plugin 'jebberjeb/grimoire.vim'

Next, add the Leiningen dependency (preferably to your ~/.lein/profiles.clj):

    [grimvim "0.1.0"]

TODO
====

* cache api calls
* check for names, namespaces (using api)
* help doc

License
=======

Distributed under the same terms as Vim itself. See :help license
