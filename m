From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v16 00/13] support "task_isolation" mode
Date: Mon, 6 Nov 2017 09:38:44 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1711060932520.9015@nuc-kabylake>
References: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509728692-10460-1-git-send-email-cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Francis Giraldeau <francis.giraldeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 3 Nov 2017, Chris Metcalf wrote:

> However, it doesn't seem possible to do the synchronous cancellation of
> the vmstat deferred work with irqs disabled, though if there's a way,
> it would be a little cleaner to do that; Christoph?  We can certainly
> update the statistics with interrupts disabled via
> refresh_cpu_vm_stats(false), but that's not sufficient.  For now, I

Callig quiet_vmstat() gives you the folding of the statistics without
the numa page allocator page cleanup. Leaving some pages in the queues
should not be that much of an issue.

> What about that d*mn 1 Hz clock?
>
> It's still there, so this code still requires some further work before
> it can actually get a process into long-term task isolation (without
> the obvious one-line kernel hack).  Frederic suggested a while ago
> forcing updates on cpustats was required as the last gating factor; do
> we think that is still true?  Christoph was working on this at one
> point - any progress from your point of view?

Well if you still have the 1 HZ clock then you can simply defer the numa
remote page cleanup of the page allocator to that the time you execute
that tick.
