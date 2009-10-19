From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Date: Mon, 19 Oct 2009 23:36:36 +0200
Message-ID: <20091019213636.GB1482@ucw.cz>
References: <20091013044925.GA28181@us.ibm.com> <20091013045556.GJ28435@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091013045556.GJ28435-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi!

> This gives a brief overview of the clone3() system call.  We should

Thanks!

> eventually describe more details in existing clone(2) man page or in
> a new man page.

M. Kerrisk (see MAINTAINERS) maintains man pages...

> Changelog[v8]:
> 	- clone2() is already in use in IA64. Rename syscall to clone3()
...
> Index: linux-2.6/Documentation/clone2
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/Documentation/clone2	2009-10-12 19:54:38.000000000 -0700

clone3?

> +struct clone_struct {
> +	u64 flags;
> +	u64 child_stack;

u64 seems wrong  on 32 bit platforms. ulong?

> +	u32 nr_pids;

So nr_pids is either 1 or 2?

> +	u32 reserved1;
> +	u64 parent_tid;
> +	u64 child_tid;
> +	u64 reserved2;
> +};
> +


> +	See CLONE_NEWPID section of clone(2) man page for details about pid
> +	namespaces.
> +
> +	The order pids in @pids corresponds to the nesting order of pid-
> +	namespaces, with @pids[0] corresponding to the init_pid_ns.

Ok, so I'm confused.

> +	If a pid in the @pids list is 0, the kernel will assign the next
> +	available pid in the pid namespace, for the process.
> +
> +	If a pid in the @pids list is non-zero, the kernel tries to assign
> +	the specified pid in that namespace.  If that pid is already in use
> +	by another process, the system call fails with -EBUSY.
...
> +	On failure, clone3() returns -1 and sets 'errno' to one of following
> +	values (the child process is not created).

Inconsistent with above. Syscalls really return -ERRCODE, errno is
glibc magic.

> +Example:
> +
> +	pid_t pids[] = { 77, 99 };
> +	struct clone_struct cs;
> +
> +	cs.flags = (u64) SIGCHLD;
> +	cs.child_stack = (u64) setup_child_stack();
> +	cs.nr_pids = 2;
> +	cs.parent_tid = 0LL;
> +	cs.child_tid = 0LL;
> +
> +	rc = syscall(__NR_clone3, &cs, pids);

Hmm, is there reason why pids are not at the end of struct
clone_struct? Passing most parameters in special structure, then pids
separately is strange...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
