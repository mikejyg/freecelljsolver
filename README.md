# freecelljsolver
Freecell Java Solver

## DESCRIPTION

freecelljsolver is a java package that solves freecell games.

While the original goal was to design a smart solver, it has not materialized. As of today, it is a brute force solver, albeit with optimizations and heuristics.

**NOTE: When moving to an empty column, this solver always moves the longest column possible.  No case of this rule causing a solvable deal unsolvable has been discovered. Please keep this in mind when it comes to the standard move notation.**

## STATUS

(with command: java -Xmx1024M -jar freecelljsolver.jar --dual game_number)

It can solve approx. 99.99% of games in less then a second.

In the worst cases, it only takes about a minute.

It has not encountered a game that it can not solve or determine that it is unsolvable.


## BUILDING

An easy way to build the executable jar file is to use ant - just type ant under the freecelljsolver directory. 


## USAGE and RUNNING

Since this is a Java program, you need to have a Java Virtual Machine (aka JVM, Java runtime) installed on your system.

A stand alone application is provided (test\FCSolve.java) as a usage example. The basic command to execute the program is

	java -jar freecelljsolver.jar

A few example tests are provided under the directory *tests/*, showing how to use the stand alone application in various ways.

**Note, when using the Berkeley DB backed option, a directory named "dbEnv" must be present in the directory where the program is run.**

Options of running the solver are provided by command line options and a properties file. Please use the -h option to see the help, and the file *freecell-default.properties* for info on properties.

## TECHNICAL

The solver uses a few techniques to speed up the search and uses less memory, they are summarized below,

* Use heuristic algorithm to evaluate each candidate within a common ancestor, and pick the most likely winner among them.

Since it is difficult, if possible at all, to find a single algorithm to best suit all situations, the solver provides two formulas, termed cautious and aggressive, to maximize chance of good guessing.

In dual-threaded mode, this solver actually tries both algorithms at the same time, and gets the earliest the answer.

* Use equivalent board for comparison, by reducing some suit to color only for some cards, to minimize possible boards, and thus reduce search space.

While it is not proven correct, this has worked for the first 1 million deals correctly. On the cautious side, the solver will disable this optimization, if it encounters an unsolvable board, and try again.
   
* When a safe auto play is encountered, let it be the only successor for its ancestor.

This technique reduces search space.

* Use revision marking for free cells, home cells and each column, to prevent some unnecessary moves;

The idea is to prevent a particular movement of a card, that has been moved, and nothing meaningful has occurred with regard to the movement, since its previous movement.  

This technique restricts the possible moves from each board (hopefully the unnecessary ones), so has the potential for the solver to make better guesses. However, it does also has the potential to increase the difficult for the solver, e.g., if it made a bad guess early on.

This technique may provide a better answer, by reducing the number of moves.

This technique may improve performance by reducing the the number of boards being tried.

On the down side, this technique uses more memory for each board stored and takes more time to process each board.


* What about brute force?

Sure, the solver can be configured to use Berkeley DB as back end, let us find out how big the search space it can get, and how big a database can Berkeley DB handle, right?


* The JVM garbage collector

When the solver uses as much memory as the size of the JVM heap space, the JVM will stagnate, wasting almost all the time doing garbage collection. As a result, it is beneficial to stop the search (call it off), before the JVM tells you so.

The solver provides limitation of number of boards. It need to be set accordingly to the heap space settings of the JVM.

By default, the program provides settings, assuming 512MB of heap space for single thread mode, and 1024M for dual thread mode. 
