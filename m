From: Alex Dubov <alex.dubov@gmail.com>
Subject: Re: Minimal effort/low overhead file descriptor duplication over
 Posix.1b s
Date: Wed, 3 Dec 2014 03:15:16 +1100
Message-ID: <CAPs88r_+yOYTNeKZEq+kPS83-+T4_ehR0Y_5kpTP1LmO2508MQ@mail.gmail.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<20141202102632.6ae37b88@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141202102632.6ae37b88@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 3, 2014 at 2:26 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue,  2 Dec 2014 15:35:17 +1100
> Alex Dubov <alex.dubov@gmail.com> wrote:
>
>
>  - Messing with another process's file descriptor table without its
>    knowledge looks like a possible source of all kinds problems.  Might
>    there be race conditions with close()/dup() code, for example?  And
>    remember that users can be root in a user namespace; maybe there's no
>    potential for mischief there, but it needs to be considered.

If process A has sufficient permissions to signal process B, it can
already do arbitrary mischief, no news there (SIGKILL and SIGSTOP will
definitely cause more havoc :-).

I don't believe there can be any race conditions as this is not
different to what happens when dup() is invoked from one of the
threads in multi-threaded application, whereupon other threads go on
with their usual file operations. Descriptor duplication happens prior
to any signal handling activities.

>  - Forcing the use of realtime signals seems strange; this isn't a
>    realtime operation by any stretch.

"Real time signals" are merely a misleading name for Posix.1b
micro-messaging facility. To the best of my knowledge they do not
affect scheduling any more then SIGIO or SIGALRM would.

As Posix.1b signals are best handled by signalfd() facility anyway, no
impact on scheduling compared to any other approach (including the
existing domain socket approach) is expected at all.

>
>  - How might the sending process communicate to the recipient what the fd
>    is for?  Even if a process only expects one type of file descriptor,
>    the ability to communicate information other than its number seems
>    like it would often be useful.

There are 32 "real time" signals defined by default in kernel; this
range can be increased at will with kernel recompilation and glibc
will pick up the correct range automatically (this is Posix mandated
behavior and it actually works like that).

I have not seen an app yet that relied on more than half a dozen of
distinct signal numbers. Thus any application can conveniently define
more than 2 dozens of different fd varieties out of the box, delivered
to it with dedicated signal ids, whereupon in most practical
applications only 1 or 2 varieties of file descriptors are ever passed
around.

>
> Some of these concerns might be addressable by requiring the recipient to
> call acceptfd() (or some such) with the ability to use poll().  As an
> alternative, I believe kdbus has fd-passing abilities; if kdbus goes in,
> would you still need this feature?

Any process willing to handle Posix.1b signals must explicitly
manipulate the signal masks - otherwise it will be killed the moment
signal is received. Thus, no special "acceptfd()" call is necessary on
the receiver side - applications usually don't  modify their signal
masks unless they expect some particular signal to arrive.

kdbus has something like it and binder on android has it as well. The
problem with both of them are the same as with unix domain sockets
(which implement a whole, rather convoluted, cmsg facility to be ever
used for that single purpose): they try to solve big problems with
fancy functionality, whereupon fd passing is a nice side feature
(which then gets used the most).

To my understanding, commonly used functionality deserves to have its
own quick, low overhead path:

1. We've got eventfd() which is neat and all, but to use it we need an
easy way to pass its fd around.

2. We've got memfd() which is also neat, but to use it..

3. We've got fairly complex (and consequently buggy) functionality
like SO_REUSEPORT, but I can't avoid a feeling that if there was a low
overhead transport available to path fds around (like the one
proposed), the old school approach of having one process running
tightly around accept() and sending sockets to workers may still rival
it (pity I don't have google's setup around to test it).

4. Most importantly, when network appliances are concerned (and those
represent a huge percentage of linux install base), it is desirable to
have the leanest possible code paths both in kernel and in the user
space (no functionality - no vulnerabilities to fish for) and still be
able to rely on multi-process applications (as multi-process
applications are considerably more reliable then multi-threaded ones,
for all the obvious reasons). A compact, easily traceable facility
comprising few hundred LOCs in the kernel, end to end, and very simple
application code (sigqueue() -> signalfd()) pose a distinct advantage
in this regard over largish subsystems which may provide similar
feature (invariable at the expense of unnecessary costs, like
persistent file system objects, specialized user-space libraries, etc)
.
