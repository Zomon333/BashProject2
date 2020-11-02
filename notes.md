##Notes!
So; we're supposed to keep a notesheet showing a chronology of our progress. This is a bit tricky;
Chronology infers that our progress would happen over time. When we actually had the assignment, we were intended to do it over about a week.
I did this in a cumulative 16 hours over 2 days. That's not really a very long period of time, so my timescale here is going to be brief.

When I originally started the project, I read through the specifications and copied them down as a comment into the header of the script. They're still there, even.
After a closer read, I realized the program could basically be broken down into three main chunks: Reading the file, making the accounts, and sending the emails.

---

###Reading a file:
This is something that I hadn't had all too much experience with. I seem to recall, Project 1 involved *outputting a file* but it didn't involve *reading* a file. For me, this made things a little bit more complicated.
I did a little bit of research and found, from http://www.linuxhint.com/read_file_line_by_line_bash/ , how to read a file. After I read their example, I heavily modified it to suit my own needs.
The process of turning their while statement into my function wasn't too difficult, but it's still drastically different. I changed the readFile function about 4 times before I came to the most recent, final version, which calls other functions to achieve the same tasks.

The readFile function also stores the information read into arrays. I learned about arrays from some research I did, which led me to http://www.gnu.org/software/bash/manual/html_node/Arrays.html
This example showed me how to declare and use arrays in Bash-- something I hadn't done before. Well, now I know how to do that. It's not that bad!
In terms of chronology here: All of this is still taking place within the first 3 hours of my work. I spent more time on emails than anything else, so these early days are comparatively short on the time scale.

After learning how to use arrays, I did some basic research just to touch up on other variables; I had forgotten some stuff since project 1, so I needed to reevaluate how, precisely, I'd accomplish my task.
I used http://www.linuxize.com/post/bash-increment-decrement-variable/ to refresh my memory on incrementing integers in bash so I could make a counter to loop through an array while the file was read. Wasn't too hard.

###Making the accounts:
After setting the file input portion up, I spent a small amount of time with the sed command stripping off the ends of emails with 's/@.*//', something I had written myself.
Turns out, I've known how to use the sed command for a very long time; I've just never associated s/// with sed. Eventually, though, I switched to cut.
I include this under making the accounts becase by stripping away the @ symbol, I'm now left with the username I use to create the account.

About 30 minutes of googling later, I have a number of sources instructing me on the command to use to create an account. I look at `man account`, and then disregard the sources.
I forgot to write down which sites they were but, really, I only used them to find the command.
From here, I analyzed that I'd need a way to generate passwords aswell. Of course, the professor recommended openssl. I ran man openssl to see what it included; it didn't dissapoint.
Apparently openssl has a wide range of functions and, to be honest, it was getting late and I couldn't be bothered to go through and see what they all did. I found one named rand which
generates random characters and I used the --hex option to force them out as hex values. String six of those together and you have a 12 character password of the numbers/letters 0 through f.
I understand this isn't the best way to create a password but, hey, it's good enough for me.

Now that I had the command to create accounts, a function to generate passwords, and a function to parse out account names, the only hurdle was to throw them all together.
It only took me about an hour to get this working and I put it into it's own function, if I recall.

From here, I did a bit of research into chage and passwd. I found out two things: One, chage can be used to set the expiration date to today; and two, passwd can be used alongside echo to set someone's password and then make it instantly expire. I used this with the account creation in order to ensure you don't keep my awful passwords.

###Sending the Emails:
Finally; sending emails. The project description advises that we look up some tutorials on this. So I did! I found quite a few, and settled on a blend of a couple which seems to work well enough.
The sources I found recommended I install ssmpt in order to send emails; so I did exactly that. Turns out, sending emails isn't hard either. What ***is*** hard, however, is getting them formatted right.
All of the guides I found told you how to *send* an email but not how to *format* an email. This can create some problems.
The next 12 hours were me trying to figure out how emails were formatted. I could send them fine, but they wouldn't show any content. I went though at least 100 blank emails.
I know that seems like a very long time but most of it was trial and error. The only reason that I eventually made a breakthrough was because I asked a friend of mine from New Zealand named Anna what she thought. She then gave me some example code of a different version of the same command being run in a different environment. Anna had used sendmail instead of ssmpt, which likely made a difference, but I opted to keep going with what I had.
Turns out the formatting she shared was universal though; I used it to set all the information. Finally, there was only one hurdle to cross which comprised about the other 8 hours of work;

***Variables.***

I know this sounds inconspicuous; like, what could variables possibly do that would cause you that much irritation? Well you see, that's the problem. They did nothing. Literally!
I spent like 8 hours trying to find out how to get the email formatting to accept having variables thrown into it; It had developed a nasty habit of ignoring all variables.
Eventually I figured out two crucial problems with my script which I had to solve: One, ssmpt doesn't always like spaces if you don't have ENDOFFILE in it and, two, ssmpt refuses to show any variables in the string UNLESS they are positional arguments.
So, I spent like 8 hours before realizing that I just had to replace them with positional arguments and feed the information in from the outside. Irritating, but whatever.

And with that; a loose chronological scale of 16 hours of work, noting the issues I faced and the procedure I went through to get to where I am now.
Hope this suffices as project notes in markdown format.
