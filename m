From: Geoffrey McRae <geoff-vBxYYoWeDNDby3iVrkZq2A@public.gmane.org>
Subject: New security functions?
Date: Tue, 02 Dec 2008 13:30:59 +1100
Message-ID: <1228185059.11192.35.camel@lappy.spacevs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi All,

Let me first apologise if I am posting this to the wrong mailing list, I
have never done any official kernel hacking before, so I am a little
lost as to where I should send things.

I am a self taught programmer working in many languages for over 15
years now. I have been writing a server management system much like
cPanel, but far superiour in many ways.

I am trying to solve the problem of the overhead of forking a new
process for each HTTP request, and the problem of running the HTTP
server as the user's uid/gid.

After many weeks of experimenting, I have decided the only way to solve
this problem, while keeping high performance would be to use the FastCGI
approach of pre-forking and re-using processes for requests, but, with
the added feature of being able to change the uid/gid of the process
before re-using it.

I have added a new function to the kernel that allows the changing of
another processes uid/gid, now before you think, woah, thats
dangerous... there is a level of protection. The new function will only
allow changing of a child processes uid (ie, a forked process).

With this new function it is possible to change a forked processes uid
after the forked process has dropped its permissions.

This works, and quite well, but I am unsure of the security implications
of it. Ofcourse, you would not allow the child that is executing un-safe
code from asking the parent to set its uid, and the parent would have
some checking to ensure that the child is never set to root, or
something silly.

This would ensure the child NEVER has root level permissions, only the
parent does, so it would be very secure for the child to run un-safe
code as it would be running in the user's context, and the child would
not communicate with the parent, so no risk of buffer overflows or code
injection AFAIK.

The only drawback I can forsee is that the application would have to run
as root so it can change its child's permissions. It would be nice if we
could make the application call another new function that enables the
new function for only a certain range of uids after the application has
dropped root permissions. eg...

=========================================================
// set the range the uid is allowed to be in (1000, 9999)
enable_setpresuid(1000, 9999);

// become the www-data user
setresuid(www-data, www-data, www-data);

// fork a child and change its uid
child = fork();
if (child == 0) {
	//wait for our uid to be set
	//do stuff
	return 0;
} else {
	//change the child's uid
	setpresuid(child, 1000, 1000, 1000);

	//make the child do stuff
}
=========================================================

Anyway, this is my idea, there is a bit more info and a patch for a
debian kernel at: http://www.spacevs.com/rambles/setuid.php

I have realised since my folly of not using the latest kernel from git
and I am now implementing this to see how well it can work.

-Geoffrey McRae

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
