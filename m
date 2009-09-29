From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Date: Tue, 29 Sep 2009 15:11:03 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0909291501530.6996@localhost.localdomain>
References: <20090924165548.GA16586@us.ibm.com>
	<20090924170308.GH16989@us.ibm.com>
	<200909242343.59903.arnd@arndb.de>
	<20090925082346.GB4436@localdomain>
	<20090925105632.GG12824@hawkmoon.kerlabs.com>
	<20090929180537.GD4625@us.ibm.com>
	<20090929184023.532DF34@magilla.sf.frob.com>
	<4AC255A4.4030002@zytor.com>
	<20090929210207.247b94df@infradead.org>
	<alpine.LFD.2.01.0909291207410.6996@localhost.localdomain>
	<4AC267C7.4070300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <4AC267C7.4070300-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On Tue, 29 Sep 2009, H. Peter Anvin wrote:
> 
> That's not the main issue here, though.  The main issue is that the
> prototype of the function now depends on one of its arguments

Ok, I agree with that. The kernel side is easy (we have magic calling 
conventions there and need to turn registers into arguments anyway before 
you get to the shared code), but your point about the user side prototype 
is valid.

However, that could easily be handled by just having a extended_clone() 
prototype that then sets the CLONE_EXTINFO (or whatever) bit in the flags. 
I think most of the time the clone() stuff needs special user-level 
wrappers anyway to handle the stack setup etc, no?

In other words, what I'd suggest we could do is

 - the kernel "do_fork()" interface would be made to have the "extended" 
   format by default - so the _kernel_ never has two formats in its 
   generic logic.

 - the "sys_clone()" system call, that already needs to munge the user 
   mode registers into the "do_fork()" format, would be the one that 
   recognizes the new flag and copies the extended data from user mode 
   memory to the extended info mode.

Then each architecture would need to update it's "sys_clone()" function to 
take advantage of the new extended format, but that's something that the 
new system call would have had to do anyway, so that's not an added burden 
in any way.

Hmm?

I don't feel horribly strongly about this, and as far as I'm concerned 
it's fine to also do it as a new system call too (we already have 'fork()' 
and 'vfork()' as special case interfaces to do_fork() - the new 'extended 
clone' would be no different).

I just think that Roland is correct that if the new extended fork handles 
the "no new info" case itself _anyway_, then there is no upside to making 
it a new system call, since the complexity is the same as just extending 
the old one.

			Linus
