From: Arnd Bergmann <arndbergmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Date: Wed, 21 Oct 2009 10:37:38 +0200
Message-ID: <200910211037.38413.arnd@arndb.de>
References: <20091013044925.GA28181@us.ibm.com> <20091013045556.GJ28435@us.ibm.com> <20091019213636.GB1482@ucw.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091019213636.GB1482-+ZI9xUNit7I@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> 
> > +struct clone_struct {
> > +	u64 flags;
> > +	u64 child_stack;
> 
> u64 seems wrong  on 32 bit platforms. ulong?

That would make it incompatible between 64 bit kernels and
32 bit user space, requiring a wrapper. Better leave it at u64.

> > +	If a pid in the @pids list is 0, the kernel will assign the next
> > +	available pid in the pid namespace, for the process.
> > +
> > +	If a pid in the @pids list is non-zero, the kernel tries to assign
> > +	the specified pid in that namespace.  If that pid is already in use
> > +	by another process, the system call fails with -EBUSY.
> ...
> > +	On failure, clone3() returns -1 and sets 'errno' to one of following
> > +	values (the child process is not created).
> 
> Inconsistent with above. Syscalls really return -ERRCODE, errno is
> glibc magic.

Quite the opposite is true.

The man page describes what the user space sees, which is errno. Returning
-ERRCODE to libc from the kernel is part of the architecture specific
kernel ABI and should not be documented in this place but in the architecture
documentation.

> > +	pid_t pids[] = { 77, 99 };
> > +	struct clone_struct cs;
> > +
> > +	cs.flags = (u64) SIGCHLD;
> > +	cs.child_stack = (u64) setup_child_stack();
> > +	cs.nr_pids = 2;
> > +	cs.parent_tid = 0LL;
> > +	cs.child_tid = 0LL;
> > +
> > +	rc = syscall(__NR_clone3, &cs, pids);
> 
> Hmm, is there reason why pids are not at the end of struct
> clone_struct? Passing most parameters in special structure, then pids
> separately is strange...

I suggested doing that, it's a lot easier to handle fixed length data
structures than an array at the end.

	Arnd <><
