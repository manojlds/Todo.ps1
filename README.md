Todo.ps1
========

A [todo.txt](http://todotxt.com/) implementation in Powershell

Based on the [todo.txt-cli implementation](https://github.com/ginatrapani/todo.txt-cli) and tries to use use the API except in places where it made sense to use a more POSH way of doing things.


Installation
============

Get the Todo.psm1 file, import the module, and done!. The `t` command should be available for you.


Commands
========

add
---

Add a todo.  

`t add "Get Milk +grocery"`

addm
----

Add multiple todos

`t addm "Get Milk +grocery","Call Mom +Family"`

append
------

Append text to a todo. todo is identified by its number as seen in `t ls`

`t append 2 "And Dad too"`

archive
-------

Move done todos to done.txt

`t archive`

rm
--

Remove the specified todo

`t rm 2`


do
--

Mark a todo as done

`t do 1`


dp
--

Deprioritize the specified todo

`t dp 1`

ls
--

List all pending todos

`t ls`


lsa
---

List all todos, including the completed ones

`t lsa`

p
-

Add / replace priority of a todo.

`t p 1 A`

