sabredav.io source
==================

Welcome to the sourcecode for [sabre.io][1].

sabre.io is a static website. We use [sculpin][2] to generate this website.

To start contributing, you can simply fork this project and add your new pages
to the `source` directory.

Running the website locally
---------------------------

Although this is not needed when creating or updating content, it may be
useful to be able to run the website on a local machine.

To do so, first [follow the installation instructions for sculpin][3].
I used the phar install, because it was the easiest.

Next, from the project directory, run the following:

    sculpin install
    sculpin generate --watch --server

The first step will install required dependencies, the second starts a server
locally where you can go have a look. To test, simply head to
<http://localhost:8000/>.

Style guide
-----------

1. Try to keep all the lines in your markdown files under 80 characters.
2. External links are done using references.
3. Internal links to other pages on the site, are made using in-line links.
4. Code blocks are done using indentation style (4 spaces). This is not the
   most ideal for typing, but it does appear to be the most portable style.
5. Break the rules when appropriate.

Sample page with links
----------------------

    Welcome to sabre.io!
    ====================

    To find out more, check out [getting started](/dav/getting-started)!

    Credits
    -------

    This website was built using [sculpin][1].

    [1]: https://sculpin.io/


[1]: http://sabre.io/
[2]: http://sculpin.io/
[3]: https://sculpin.io/download/
