From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and
 EPOLLROUNDROBIN
Date: Wed, 18 Feb 2015 09:07:40 +0100
Message-ID: <20150218080740.GA10199@gmail.com>
References: <cover.1424200151.git.jbaron@akamai.com>
 <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> Epoll file descriptors that are added to a shared wakeup 
> source are always added in a non-exclusive manner. That 
> means that when we have multiple epoll fds attached to a 
> shared wakeup source they are all woken up. This can lead 
> to excessive cpu usage and uneven load distribution.
> 
> This patch introduces two new 'events' flags that are 
> intended to be used with EPOLL_CTL_ADD operations. 
> EPOLLEXCLUSIVE, adds the epoll fd to the event source in 
> an exclusive manner such that the minimum number of 
> threads are woken. EPOLLROUNDROBIN, which depends on 
> EPOLLEXCLUSIVE also being set, can also be added to the 
> 'events' flag, such that we round robin through the set 
> of waiting threads.
> 
> An implementation note is that in the epoll wakeup 
> routine, 'ep_poll_callback()', if EPOLLROUNDROBIN is set, 
> we return 1, for a successful wakeup, only when there are 
> current waiters. The idea is to use this additional 
> heuristic in order minimize wakeup latencies.
> 
> Signed-off-by: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/eventpoll.c                 | 25 ++++++++++++++++++++-----
>  include/uapi/linux/eventpoll.h |  6 ++++++
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index d77f944..382c832 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -92,7 +92,8 @@
>   */
>  
>  /* Epoll private bits inside the event mask */
> -#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET)
> +#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET | \
> +			 EPOLLEXCLUSIVE | EPOLLROUNDROBIN)
>  
>  /* Maximum number of nesting allowed inside epoll sets */
>  #define EP_MAX_NESTS 4
> @@ -1002,6 +1003,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>  	unsigned long flags;
>  	struct epitem *epi = ep_item_from_wait(wait);
>  	struct eventpoll *ep = epi->ep;
> +	int ewake = 0;
>  
>  	if ((unsigned long)key & POLLFREE) {
>  		ep_pwq_from_wait(wait)->whead = NULL;
> @@ -1066,8 +1068,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>  	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
>  	 * wait list.
>  	 */
> -	if (waitqueue_active(&ep->wq))
> +	if (waitqueue_active(&ep->wq)) {
> +		ewake = 1;
>  		wake_up_locked(&ep->wq);
> +	}
>  	if (waitqueue_active(&ep->poll_wait))
>  		pwake++;
>  
> @@ -1078,6 +1082,8 @@ out_unlock:
>  	if (pwake)
>  		ep_poll_safewake(&ep->poll_wait);
>  
> +	if (epi->event.events & EPOLLROUNDROBIN)
> +		return ewake;
>  	return 1;
>  }
>  
> @@ -1095,7 +1101,12 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
>  		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
>  		pwq->whead = whead;
>  		pwq->base = epi;
> -		add_wait_queue(whead, &pwq->wait);
> +		if (epi->event.events & EPOLLROUNDROBIN)
> +			add_wait_queue_rr(whead, &pwq->wait);
> +		else if (epi->event.events & EPOLLEXCLUSIVE)
> +			add_wait_queue_exclusive(whead, &pwq->wait);
> +		else
> +			add_wait_queue(whead, &pwq->wait);
>  		list_add_tail(&pwq->llink, &epi->pwqlist);
>  		epi->nwait++;
>  	} else {
> @@ -1820,8 +1831,7 @@ SYSCALL_DEFINE1(epoll_create, int, size)
>  SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  		struct epoll_event __user *, event)
>  {
> -	int error;
> -	int full_check = 0;
> +	int error, full_check = 0, wait_flags = 0;
>  	struct fd f, tf;
>  	struct eventpoll *ep;
>  	struct epitem *epi;
> @@ -1861,6 +1871,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  	if (f.file == tf.file || !is_file_epoll(f.file))
>  		goto error_tgt_fput;
>  
> +	wait_flags = epds.events & (EPOLLEXCLUSIVE | EPOLLROUNDROBIN);
> +	if (wait_flags && ((op == EPOLL_CTL_MOD) || ((op == EPOLL_CTL_ADD) &&
> +	    ((wait_flags == EPOLLROUNDROBIN) || (is_file_epoll(tf.file))))))
> +		goto error_tgt_fput;
> +
>  	/*
>  	 * At this point it is safe to assume that the "private_data" contains
>  	 * our own data structure.
> diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
> index bc81fb2..10260a1 100644
> --- a/include/uapi/linux/eventpoll.h
> +++ b/include/uapi/linux/eventpoll.h
> @@ -26,6 +26,12 @@
>  #define EPOLL_CTL_DEL 2
>  #define EPOLL_CTL_MOD 3
>  
> +/* Balance wakeups for a shared event source */
> +#define EPOLLROUNDROBIN (1 << 27)
> +
> +/* Add exclusively */
> +#define EPOLLEXCLUSIVE (1 << 28)
> +
>  /*
>   * Request the handling of system wakeup events so as to prevent system suspends
>   * from happening while those events are being processed.

So let me rephrase the justification of your two patches:

Unlike regular waitqueue usage (where threads remove 
themselves from the waitqueue once they receive a wakeup), 
epoll waitqueues are static and 'persistent': epoll target 
threads are on the poll waitqueue indefinitely, only 
register/unregister removes threads from them.

So they are not really 'wait queues', but static 'task 
lists', and are thus exposed to classic thundering herd 
scheduling problems and scheduling assymetries: a single 
event on a shared event source will wake all epoll 
'task-lists', and not only will it wake them, but due to 
the static nature of the lists, even an exclusive wakeup 
will iterate along the list with O(N) overhead, until it 
finds a wakeable thread.

As the number of lists and the number of threads in the 
lists increases this scales suboptimally, and it also looks 
slightly odd that a random set of epoll worker threads is 
'more equal' than the others, in receiving a comparably 
higher proportion of events.

The solution is to add this new ABI to allow epoll events 
to be actively load-balanced both between the persistent 
'task lists', and to also allow the individual task lists 
to act as dynamic runqueues: the head of the list is likely 
to be sleeping, newly woken tasks get moved to the tail of 
the list.

This has two main advantages: firstly it solves the O(N) 
(micro-)problem, but it also more evenly distributes events 
both between task-lists and within epoll groups as tasks as 
well.

The disadvantages: slightly higher management micro-costs, 
plus a global waitqueue list, which used to be read-mostly, 
is now actively dirtied by every event, adding more global 
serialization. The latter is somewhat muted by the fact 
that the waitqueue lock itself is already a global 
serialization point today and got dirtied by every event, 
and the list head is next to it, usually in the same 
cacheline.

Did I get it right?

Thanks,

	Ingo
