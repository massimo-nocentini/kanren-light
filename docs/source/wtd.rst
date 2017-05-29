
*****
Intro
*****

After the experience of porting the relational framework *μkanren* [HF13]_ into
the Python world [MN17]_, me and Marco Maggesi would like to make effort toward
a *certified* version of the logical computation using the *HOL Light* [JRH13]_
theorem prover.


To be honest, this documentations has many targets:
    
    * write them here...

We like to structure my exposition following advices from `an interesting
group of people <write_the_doc_>`_, and `one of them in particular
<holscher_>`_, much more experienced that me on writing this kind of stuff;
consequently, in what follows you will find the same sections as you find in
the referenced page, hoping to provide answers and to taylor paragraphs to this
particular project. Quoting their `Sidebar on open source
<http://www.writethedocs.org/guide/writing/beginners-guide-to-docs/#you-want-people-to-use-your-code>`_:

    There is a magical feeling that happens when you release your code. It comes in
    a variety of ways, but it always hits you the same. Someone is using my code?!
    A mix of terror and excitement.

        I made something of value!
        What if it breaks?!
        I am a real open source developer!
        Oh god, someone else is using my code...

    Writing good documentation will help alleviate some of these fears. A lot of
    this fear comes from putting something into the world. My favorite quote about
    this is something along these lines:

        Fear is what happens when you're doing something important.
        If you are doing work that isn't scary,
        it isn't improving you or the world.

    Congrats on being afraid! It means you're doing something important.

from my little and humble point of view, I'm proud to have been afraid as I was
doing all this stuff...

Why write docs
==============

You will be using your code in 6 months (aka, *the future of this project*)
---------------------------------------------------------------------------

The reality:

    I find it best to start off with a selfish appeal. The best reason to write
    docs is because you will be using your code in 6 months. Code that you
    wrote 6 months ago is often indistinguishable from code that someone else
    has written. You will look upon a file with a fond sense of remembrance.
    Then a sneaking feeling of foreboding, knowing that someone less
    experienced, less wise, had written it.


You want people to use your code
--------------------------------

*If people don't know why your project exists, they won't use it.*


*If people can't figure out how to install your code, they won't use it.*
    All that is required is to have a `Git client <https://git-scm.com/>`_
    available, so type the following in a console:
    
    .. code-block:: shell
        
        git clone https://github.com/massimo-nocentini/microkanrenpy.git # get stuff
        cd microkanrenpy/src # go into there
        python3 # start the Python interpreter
    
    Now in the python interpreter it is possible to load our core module:

    .. code-block:: python
         
        >>> from muk.core import *

    that's it!

*If people can't figure out how to use your code, they won't use it.*

You want people to help out
---------------------------

*You only get contributions after you have put in a lot of work.*


*You only get contributions after you have users (aka, to whet your appetite).*

*You only get contributions after you have documentation.*





It makes your code better
-------------------------

You want to be a better writer (aka, *looking at the past*)
-----------------------------------------------------------
What technology
===============

Information for people who want to contribute back
--------------------------------------------------
I think that `GitHub <https://github.com/>`_ is a very strong platform where we
can keep alive this project.  Moreover, I think also that the decentralized
model and the `workflow <https://guides.github.com/introduction/flow/>`_
proposed by GitHub itself, which is based on `pull requests
<https://help.github.com/articles/about-pull-requests/>`_, is a clean and
healthy methodology to do development. Therefore, I would like to accept
contributions according to this settings, using facilities provided by the
platform to do discussions and to track issues.  Finally, here is the address
of the repository:

    https://github.com/massimo-nocentini/microkanrenpy

.. note::

    The actual repository has its roots from:
        
         https://github.com/massimo-nocentini/on-python/tree/master/microkanren

    the transition to its new independent location has been possible by the following guide:
    https://help.github.com/articles/splitting-a-subfolder-out-into-a-new-repository/

Together with simplicity and elegance, we believe that *automated testing* is a
vital principle to keep the code base healthy. Therefore, we link the git repo with:


*Read The Docs*
    which allows us to have an up-to-date documentation, namely the one you are reading, 
    with the code base; although this service doesn't allow us to run doctests, this flaw 
    is covered by Travis just described above. The corresponding page is the following:

        https://readthedocs.org/projects/microkanrenpy/


README.rd first
---------------
As raccomanded by `this article <http://tom.preston-werner.com/2010/08/23/readme-driven-development.html>`_,
have a look to our `README.md <https://github.com/massimo-nocentini/microkanrenpy/blob/master/README.md>`_ first.

How to get support
------------------
If you are having issues, please let us know and feel free to drop me an
email at massimo.nocentini@unifi.it for any info you would like to known. 


Your project's license
----------------------

Copyright 2017 Marco Maggesi, Massimo Nocentini

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--------------------------------------------------

.. [HF13]
    Jason Hemann and Daniel P. Friedman,
    *microKanren: A Minimal Functional Core for Relational Programming*, 
    In Proceedings of the 2013 Workshop on Scheme and Functional Programming (Scheme '13), Alexandria, VA, 2013.

.. [HF15]
    Jason Hemann and Daniel P. Friedman,
    *A Framework for Extending microKanren with Constraints*,
    In Proceedings of the 2015 Workshop on Scheme and Functional Programming (Scheme '15), Vancouver, British Columbia, 2015.
   
.. [CF15]
    Cameron Swords and Daniel P. Friedman,
    *rKanren: Guided Search in miniKanren*,
    In Proceedings of the 2013 Workshop on Scheme and Functional Programming (Scheme '13), Alexandria, VA, 2013.

.. [GS17]
    N. D. Goodman and A. Stuhlmüller (electronic),
    *The Design and Implementation of Probabilistic Programming Languages*,
    Retrieved 2017-4-27 from http://dippl.org

.. [RS05]
    Daniel P. Friedman, William E. Byrd and Oleg Kiselyov,
    *The Reasoned Schemer*,
    The MIT Press, Cambridge, MA, 2005

.. [RS82]
    Raymond Eric Smullyan,
    *The Lady or the Tiger*,
    Knopf; 1st edition, 1982

.. [WB09]
     William E. Byrd,
     *Relational Programming in miniKanren: Techniques, Applications, and Implementations*,
     Ph.D. thesis, Indiana University, Bloomington, IN, 2009.

.. [MN17]
    Massimo Nocentini,
    *microkanrenpy*, 
    https://github.com/massimo-nocentini/microkanrenpy

.. [JRH13]
    John Harrison,
    *HOL Light*, 
    http://www.cl.cam.ac.uk/~jrh13/hol-light/

.. _write_the_doc: http://www.writethedocs.org/guide/writing/beginners-guide-to-docs/
.. _reasoned_schemer_unitests: https://github.com/massimo-nocentini/microkanrenpy/blob/master/src/reasonedschemer_test.py
.. _mclock_unitests: https://github.com/massimo-nocentini/microkanrenpy/blob/master/src/mclock_test.py
.. _holscher: http://ericholscher.com/blog/2016/jul/1/sphinx-and-rtd-for-writers/
