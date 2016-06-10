From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v8 02/12] kthread: Kthread worker API cleanup
Date: Fri, 10 Jun 2016 15:29:05 -0700
Message-ID: <20160610152905.e99933d99108fa6d9f8d4dca@linux-foundation.org>
References: <1465480326-31606-1-git-send-email-pmladek@suse.com>
	<1465480326-31606-3-git-send-email-pmladek@suse.com>
	<20160609110710.510c7c67@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609110710.510c7c67-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 9 Jun 2016 11:07:10 -0400 Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:

> On Thu,  9 Jun 2016 15:51:56 +0200
> Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > A good practice is to prefix the names of functions and macros
> > by the name of the subsystem.
> > 
> > The kthread worker API is a mix of classic kthreads and workqueues.
> > Each worker has a dedicated kthread. It runs a generic function
> > that process queued works. It is implemented as part of
> > the kthread subsystem.
> > 
> > This patch renames the existing kthread worker API to use
> > the corresponding name from the workqueues API prefixed by
> > kthread_/KTHREAD_:
> > 
> > DEFINE_KTHREAD_WORKER()		-> KTHREAD_DECLARE_WORKER()
> > DEFINE_KTHREAD_WORK()		-> KTHREAD_DECLARE_WORK()
> > DEFINE_KTHREAD_WORKER_ONSTACK()	-> KTHREAD_DECLARE_WORKER_ONSTACK()
> > DEFINE_KTHREAD_WORKER_ONSTACK()	-> KTHREAD_DECLARE_WORKER_ONSTACK()
> > __init_kthread_worker()		-> __kthread_init_worker()
> > init_kthread_worker()		-> kthread_init_worker()
> > init_kthread_work()		-> kthread_init_work()
> > insert_kthread_work()		-> kthread_insert_work()
> > queue_kthread_work()		-> kthread_queue_work()
> > flush_kthread_work()		-> kthread_flush_work()
> > flush_kthread_worker()		-> kthread_flush_worker()
> > 
> 
> I know that Andrew suggested this, but I didn't get a chance to respond
> to his email due to traveling.
> 
> Does this mean we are going to change all APIs like this? Because we
> pretty much use this type of naming everywhere. That is, we start with
> "DEFINE_*" and "DECLARE_*" commonly. As well as "init_*".
> 
> For example DEFINE_PER_CPU(), DEFINE_SPINLOCK(), DEFINE_LGLOCK(),
> DEFINE_MUTEX(), DEFINE_RES_MEME(), DEFINE_TIMER(), DEFINE_IDA(),
> DEFINE_NFS4_*(), and the list goes on. Just do a grep in
> include/linux/*.h for DEFINE_ and DECLARE_.

Yes, there's so much precedence that DEFINE_KTHREAD_WORKER() and
friends can/should be left as-is.

But I do think that init_kthread_worker() is a sore thumb and should
become kthread_worker_init() (not kthread_worker_init())

> Also, are you sure that we should change the DEFINE to a DECLARE,
> because DEFINE is used to create the object in question, DECLARE is for
> header files:

Yes2, these macros expand to definitions, not to declarations.
