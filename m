From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Mon, 9 Feb 2015 21:27:00 +0100
Message-ID: <CAHO5Pa04PbU5MMzUYxbd=OWF9G6bynCBA0bVka1+U5tPex_yDw@mail.gmail.com>
References: <cover.1423509605.git.jbaron@akamai.com> <68a0ad4a99551ea3bfff89da461bb490d63b0ca8.1423509605.git.jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <68a0ad4a99551ea3bfff89da461bb490d63b0ca8.1423509605.git.jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, normalperson <normalperson-rMlxZR9MS24@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]


On Mon, Feb 9, 2015 at 9:06 PM, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
> Epoll file descriptors that are added to a shared wakeup source are always
> added in a non-exclusive manner. That means that when we have multiple epoll
> fds attached to a shared wakeup source they are all woken up. This can
> lead to excessive cpu usage and uneven load distribution.
>
> This patch introduces two new 'events' flags that are intended to be used
> with EPOLL_CTL_ADD operations. EPOLLEXCLUSIVE, adds the epoll fd to the event
> source in an exclusive manner such that the minimum number of threads are
> woken. EPOLLROUNDROBIN, which depends on EPOLLEXCLUSIVE also being set, can
> also be added to the 'events' flag, such that we round robin around the set
> of waiting threads.
>
> An implementation note is that in the epoll wakeup routine,
> 'ep_poll_callback()', if EPOLLROUNDROBIN is set, we return 1, for a successful
> wakeup, only when there are current waiters. The idea is to use this additional
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
> +                        EPOLLEXCLUSIVE | EPOLLROUNDROBIN)
>
>  /* Maximum number of nesting allowed inside epoll sets */
>  #define EP_MAX_NESTS 4
> @@ -1002,6 +1003,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>         unsigned long flags;
>         struct epitem *epi = ep_item_from_wait(wait);
>         struct eventpoll *ep = epi->ep;
> +       int ewake = 0;
>
>         if ((unsigned long)key & POLLFREE) {
>                 ep_pwq_from_wait(wait)->whead = NULL;
> @@ -1066,8 +1068,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>          * Wake up ( if active ) both the eventpoll wait list and the ->poll()
>          * wait list.
>          */
> -       if (waitqueue_active(&ep->wq))
> +       if (waitqueue_active(&ep->wq)) {
> +               ewake = 1;
>                 wake_up_locked(&ep->wq);
> +       }
>         if (waitqueue_active(&ep->poll_wait))
>                 pwake++;
>
> @@ -1078,6 +1082,8 @@ out_unlock:
>         if (pwake)
>                 ep_poll_safewake(&ep->poll_wait);
>
> +       if (epi->event.events & EPOLLROUNDROBIN)
> +               return ewake;
>         return 1;
>  }
>
> @@ -1095,7 +1101,12 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
>                 init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
>                 pwq->whead = whead;
>                 pwq->base = epi;
> -               add_wait_queue(whead, &pwq->wait);
> +               if (epi->event.events & EPOLLROUNDROBIN)
> +                       add_wait_queue_rr(whead, &pwq->wait);
> +               else if (epi->event.events & EPOLLEXCLUSIVE)
> +                       add_wait_queue_exclusive(whead, &pwq->wait);
> +               else
> +                       add_wait_queue(whead, &pwq->wait);
>                 list_add_tail(&pwq->llink, &epi->pwqlist);
>                 epi->nwait++;
>         } else {
> @@ -1820,8 +1831,7 @@ SYSCALL_DEFINE1(epoll_create, int, size)
>  SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>                 struct epoll_event __user *, event)
>  {
> -       int error;
> -       int full_check = 0;
> +       int error, full_check = 0, wait_flags = 0;
>         struct fd f, tf;
>         struct eventpoll *ep;
>         struct epitem *epi;
> @@ -1861,6 +1871,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>         if (f.file == tf.file || !is_file_epoll(f.file))
>                 goto error_tgt_fput;
>
> +       wait_flags = epds.events & (EPOLLEXCLUSIVE | EPOLLROUNDROBIN);
> +       if (wait_flags && ((op == EPOLL_CTL_MOD) || ((op == EPOLL_CTL_ADD) &&
> +           ((wait_flags == EPOLLROUNDROBIN) || (is_file_epoll(tf.file))))))
> +               goto error_tgt_fput;
> +
>         /*
>          * At this point it is safe to assume that the "private_data" contains
>          * our own data structure.
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
> --
> 1.8.2.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
