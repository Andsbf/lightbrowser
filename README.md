Lighthouse Browser
============

We're going to build a command-line browser. It will allow us to fetch a web page and display some general information about that page. Since it is a light version of a browser (or perhaps built at Lighthouse), we're going to call this app "Lightbrow" ... clever eh?

It will be a REPL interface and [look something like this](http://d.pr/i/eyzh/3Dt5eu0n) while running.

The user will run it by simply running:

    ruby run.rb

We'll be using Ruby's built-in Net::HTTP library to fetch the page and then using Nokogiri to parse the HTML the page returns.

A lot of the mundane REPL code is pre-written for you.

## Learning Goals

### Primary Goal

Our primary objective is to start getting familiar with how the web works. Everything your program does a browser has to do, too.

### Secondary Goals

* Making HTTP requests from Ruby using Net::HTTP
* More practice with ActiveRecord
* Exposure to good [Separation of Concerns](http://en.wikipedia.org/wiki/Separation_of_concerns)

## Reference Material

* [Net::HTTP Class - Docs](http://devdocs.io/ruby/net/http)
* [Net::HTTP Class - Cheat Sheet](http://www.rubyinside.com/nethttp-cheat-sheet-2940.html)

## Objectives

### 1. Read the code

1. What is the responsibility of the Browser class?

2. What is the responsibility of the HTMLPage class?

3. Why are the 2 classes inside a module?

4. Is the Browser class code readable? What would you change/improve?

5. What is Nokogiri and why is the HTMLPage class using it?

6. Why does the `content` method in HTMLPage do this? `@content ||=`

7. How come the Browser doesn't have to fully qualify the HTMLPage class name (`LightBrow::HTMLPage`) when referring to it?

### 2. Implement

In the Browser class, the `fetch` method needs to be implemented. Currently it always returns nil which causes the program to assume that the user entered URL was invalid: <http://d.pr/i/wsKv/2OAvo6Yz>.

Once you implement it to fetch the URL and return the HTTP response, the browser should work as advertised.

### 3. Error Handling

What if the URL entered by the user is malformed or not a valid HTTP url? `fetch` should return nil instead of the response object.

### 4. Enhancement - History

Add the ability to store browser history (the urls that were visited). Commands: `\h`, `\f` and `\b`. We'd like it to work similar to how a real browser handles history:
* Show history in reverse chronological order
* Back command fetches the last visited page again
* Going back again means you can go forward twice
* Attempting to go forward when you're at the most current/recent URL is not possible (tell the user to stuff it)

We might as well store the URLs visited by the user in the database.

**Think about the following:**

1. What model(s) / table(s) should you create?
2. What should the fields/attributes be?

**You'll probably want to:**

* Add ActiveRecord support
* Use SQLite3 (add the gem, establish a connection to the db)
* Put your models in `app/models` folder
* Add rake commands to be able to create, drop, migrate the db

Hint: Refer to and perhaps even bring in files/code from your previous project to save on time.

### 5. Enhancement - Visit links _(Bonus)_

Allow the user to navigate to the links that are listed after visiting a page.

Given the following scenario, the user would be able to enter the command `\v 1` to visit link #1, taking them to `https://github.com/`. If they entered `\v 2` that would take them to `https://github.com/join`.

Think about the different types of URLs you have to deal with here:
1. Absolute URLs (eg: `https://github.com/`)
2. Relative URLs from the root of the domain (eg: `/join`)
3. Relative URLs from the current page (eg `news`)
