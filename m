From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Fri, 17 Jul 2015 11:48:14 -0700
Message-ID: <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
	<5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
	<587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
	<5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
	<549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
	<CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 16, 2015 at 12:27 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
> If we actually bit the bullet and implemented per-cpu mappings

That's not ever going to happen.

Per-cpu page tables are a complete disaster. It's a recipe for crazy
race conditions, when you have CPUs that update things like
dirty/accessed bits atomically etc, and you have fundamental races
when multiple CPU's allocating page tables at the same time (remember:
we have concurrent page faults, and the locking is not per-vm, it's at
a finer granularity).

It's also a big memory management problem when you have lots and lots of CPU's.

So don't go there. The only way to do per-cpu virtual mappings is
hardware-specific, it if you have hardware that explicitly allows
inserting percpu TLB entries (while still sharing the page tables),
then that would be ok. And we don't have that on x86. MIPS has
explicit support for these kinds of TLB backs, and obviously on other
architectures you might be able to play games with the SW-fill TLB,
but on x86 there's no hardware support for per-CPU TLB filling.

And this is not just theory. We've seen what happens when people try
to do per-thread page tables. It's happened several times, and it's a
fundamental mistake. Plan-9 had "private mappings" because that's how
they did stacks (ie the stack mappings were thread-local), and it
means that thread switching is fundamentally broken. I think Mach did
too. And per-cpu page tables are less broken from a scheduling
standpoint than per-thread page tables, but still do share a lot of
the synchronization problems, and have some allocation issues all
their own.

The Linux VM model of "one page table per VM" is the right one.
Anything else sucks, and makes threading a disaster.

So you can try to prove me wrong, but seriously, I doubt you'll succeed.

On x86, if you want per-cpu memory areas, you should basically plan on
using segment registers instead (although other odd state has been
used - there's been the people who use segment limits etc rather than
the *pointer* itself, preferring to use "lsl" to get percpu data. You
could also imaging hiding things in the vector state somewhere if you
control your environment well enough).

                Linus
