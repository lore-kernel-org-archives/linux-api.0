From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Tue, 20 Oct 2015 20:29:29 -0400
Message-ID: <20151020202929.485a1ef0@grimm.local.home>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
	<1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
	<CALCETrWzhrYreizoKG0w6Jtz3RLFjNx9Qk_JLykcLLUQcCXBEA@mail.gmail.com>
	<5626B00E.3010309@ezchip.com>
	<CALCETrX6e+mqfy-rNV3sA8xGVDNHviQ9vHBBhAPULeLecno7XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrX6e+mqfy-rNV3sA8xGVDNHviQ9vHBBhAPULeLecno7XQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 20 Oct 2015 14:26:34 -0700
Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:

> I'm not a scheduler person, so I don't know.  But "don't run me unless
> I'm isolated" seems like a design that will, at best, only ever work
> by dumb luck.  You have to disable migration, avoid other runnable
> tasks, hope that the kernel keeps working the way it did when you
> wrote the patch, hope you continue to get lucky enough that you ever
> get to user mode in the first place, etc.


Since it only makes sense to run one isolated task per cpu (not more
than one on the same CPU), I wonder if we should add a new interface
for this, that would force everything else off the CPU that it
requests. That is, you bind a task to a CPU, and then change it to
SCHED_ISOLATED (or what not), and the kernel will force all other tasks
off that CPU. Well, we would still have kernel threads, but that's a
different matter.

Also, doesn't RCU need to have a few ticks go by before it can safely
disable itself from userspace? I recall something like that. Paul?

-- Steve
