From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v7 03/10] kthread: Add create_kthread_worker*()
Date: Wed, 1 Jun 2016 12:36:19 -0700
Message-ID: <20160601123619.6cadd1d09287c71b0639e226@linux-foundation.org>
References: <1464620371-31346-1-git-send-email-pmladek@suse.com>
	<1464620371-31346-4-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464620371-31346-4-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 30 May 2016 16:59:24 +0200 Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org> wrote:

> Kthread workers are currently created using the classic kthread API,
> namely kthread_run(). kthread_worker_fn() is passed as the @threadfn
> parameter.
> 
> This patch defines create_kthread_worker() and
> create_kthread_worker_on_cpu() functions that hide implementation details.

I hate to nick pits, but the naming isn't good.

A good, disciplined and pretty common naming scheme is to lead the
overall identifier with the name of the relevant subsystem.  kthread
has done that *fairly* well:


Things we got right:

kthread_create_on_node
kthread_create
kthread_create_on_cpu
kthread_run
kthread_bind
kthread_bind_mask
kthread_stop
kthread_should_stop
kthread_should_park
kthread_freezable_should_stop
kthread_data
kthread_park
kthread_unpark
kthread_parkme
kthreadd
kthread_work_func_t
KTHREAD_WORKER_INIT
KTHREAD_WORK_INIT
KTHREAD_WORKER_INIT_ONSTACK
kthread_worker_fn

Things we didn't:

probe_kthread_data
DEFINE_KTHREAD_WORKER
DEFINE_KTHREAD_WORK
DEFINE_KTHREAD_WORKER_ONSTACK
DEFINE_KTHREAD_WORKER_ONSTACK
__init_kthread_worker
init_kthread_worker
init_kthread_work
queue_kthread_work
flush_kthread_work
flush_kthread_worker


So I suggest kthread_create_worker() and
kthread_create_worker_on_cpu(), please.

And this might be a suitable time to regularize some of the "things we
didn't" identifiers, if you're feeling keen.
