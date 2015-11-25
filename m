From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 02/22] kthread/smpboot: Do not park in
 kthread_create_on_cpu()
Date: Wed, 25 Nov 2015 22:16:16 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1511252216040.12555@nanos>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com> <1447853127-3461-3-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447853127-3461-3-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 18 Nov 2015, Petr Mladek wrote:
> kthread_create_on_cpu() was added by the commit 2a1d446019f9a5983e
> ("kthread: Implement park/unpark facility"). It is currently used
> only when enabling new CPU. For this purpose, the newly created
> kthread has to be parked.
> 
> The CPU binding is a bit tricky. The kthread is parked when the CPU
> has not been allowed yet. And the CPU is bound when the kthread
> is unparked.
> 
> The function would be useful for more per-CPU kthreads, e.g.
> bnx2fc_thread, fcoethread. For this purpose, the newly created
> kthread should stay in the uninterruptible state.
> 
> This patch moves the parking into smpboot. It binds the thread
> already when created. Then the function might be used universally.
> Also the behavior is consistent with kthread_create() and
> kthread_create_on_node().
> 
> Signed-off-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>

Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
