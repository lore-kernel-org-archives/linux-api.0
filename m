From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/2] sched/wait: add round robin wakeup mode
Date: Mon, 9 Feb 2015 21:26:01 +0100
Message-ID: <CAHO5Pa2ZKeSk9cqjL4ZvKNTxB9mwkG9rFEKH=oXGwCWaUouErw@mail.gmail.com>
References: <cover.1423509605.git.jbaron@akamai.com> <f382714bd4ba5df3589e2e2e8bac114cdd4d7bb3.1423509605.git.jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f382714bd4ba5df3589e2e2e8bac114cdd4d7bb3.1423509605.git.jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, normalperson@yhbt.net, Davide Libenzi <davidel@xmailserver.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@vger.kernel.org]


On Mon, Feb 9, 2015 at 9:05 PM, Jason Baron <jbaron@akamai.com> wrote:
> The motivation for this flag is to allow the distribution of wakeups from
> a shared source in a balanced manner. Currently, we can add threads exclusively
> but that often results in the same thread woken up again and again. In the case
> where we are trying to balance work across threads this is not desirable.
>
> The WQ_FLAG_ROUND_ROBIN is restricted to being exclusive as well, otherwise we
> do not know who is being woken up.
>
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---
>  include/linux/wait.h | 11 +++++++++++
>  kernel/sched/wait.c  |  5 ++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 2232ed1..bbdef98 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -16,6 +16,7 @@ int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *ke
>  /* __wait_queue::flags */
>  #define WQ_FLAG_EXCLUSIVE      0x01
>  #define WQ_FLAG_WOKEN          0x02
> +#define WQ_FLAG_ROUND_ROBIN    0x04
>
>  struct __wait_queue {
>         unsigned int            flags;
> @@ -109,6 +110,16 @@ static inline int waitqueue_active(wait_queue_head_t *q)
>
>  extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
>  extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
> +
> +/*
> + * rr relies on exclusive, otherwise we don't know which entry was woken
> + */
> +static inline void add_wait_queue_rr(wait_queue_head_t *q, wait_queue_t *wait)
> +{
> +       wait->flags |= WQ_FLAG_ROUND_ROBIN;
> +       add_wait_queue_exclusive(q, wait);
> +}
> +
>  extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
>
>  static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> index 852143a..17d1039 100644
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -71,8 +71,11 @@ static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
>                 unsigned flags = curr->flags;
>
>                 if (curr->func(curr, mode, wake_flags, key) &&
> -                               (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
> +                              (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive) {
> +                       if (flags & WQ_FLAG_ROUND_ROBIN)
> +                               list_move_tail(&curr->task_list, &q->task_list);
>                         break;
> +               }
>         }
>  }
>
> --
> 1.8.2.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
