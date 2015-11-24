From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 09/22] kthread: Allow to cancel kthread work
Date: Tue, 24 Nov 2015 12:23:53 -0800
Message-ID: <CA+55aFyW=hp-myZGcL+5r2x+fUbpBJLmxDY66QB5VQj-nNsCxQ@mail.gmail.com>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
	<1447853127-3461-10-git-send-email-pmladek@suse.com>
	<20151123225823.GI19072@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151123225823.GI19072-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 23, 2015 at 2:58 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> And the timer can do (ignoring the multiple worker support, do we even
> need that?)
>
>         while (!trylock(worker)) {
>                 if (work->canceling)
>                         return;
>                 cpu_relax();
>         }

No no no!

People, you need to learn that code like the above is *not*
acceptable. It's busy-looping on a spinlock, and constantly trying to
*write* to the spinlock.

It will literally crater performance on a multi-socket SMP system if
it ever triggers. We're talking 10x slowdowns, and absolutely
unacceptable cache coherency traffic.

These kinds of loops absolutely *have* to have the read-only part. The
"cpu_relax()" above needs to be a loop that just tests the lock state
by *reading* it, so the cpu_relax() needs to be replaced with
something like

        while (spin_is_locked(lock)) cpu_relax();

instead (possibly just "spin_unlock_wait()" - but the explicit loop
might be worth it if you then want to check the "canceling" flag
independently of the lock state too).

In general, it's very dangerous to try to cook up your own locking
rules. People *always* get it wrong.

                      Linus
