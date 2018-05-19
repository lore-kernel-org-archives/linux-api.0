From: Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH 3/6] workqueue: Make worker_attach/detach_pool() update worker->pool
Date: Sat, 19 May 2018 14:44:39 +0800
Message-ID: <CAJhGHyC8pZvy3cmT-n6aFy0KQVJ0je6LwUKZf2Z1Rdvq--vFVw@mail.gmail.com>
References: <20180517043448.3152269-1-tj@kernel.org> <20180517043448.3152269-4-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517043448.3152269-4-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Craig Small <csmall@enc.com.au>
List-Id: linux-api@vger.kernel.org

On Thu, May 17, 2018 at 12:34 PM, Tejun Heo <tj@kernel.org> wrote:
> For historical reasons, the worker attach/detach functions don't
> currently manage worker->pool and the callers are manually and
> inconsistently updating it.
>
> This patch moves worker->pool updates into the worker attach/detach
> functions.  This makes worker->pool consistent and clearly defines how
> worker->pool updates are synchronized.
>
> This will help later workqueue visibility improvements by allowing
> safe access to workqueue information from worker->task.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c          | 16 ++++++++--------
>  kernel/workqueue_internal.h |  2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 91fe0a6..2fde50f 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1741,6 +1741,7 @@ static void worker_attach_to_pool(struct worker *worker,
>                 worker->flags |= WORKER_UNBOUND;
>
>         list_add_tail(&worker->node, &pool->workers);
> +       worker->pool = pool;
>
>         mutex_unlock(&wq_pool_attach_mutex);
>  }
> @@ -1748,19 +1749,21 @@ static void worker_attach_to_pool(struct worker *worker,
>  /**
>   * worker_detach_from_pool() - detach a worker from its pool
>   * @worker: worker which is attached to its pool
> - * @pool: the pool @worker is attached to
>   *
>   * Undo the attaching which had been done in worker_attach_to_pool().  The
>   * caller worker shouldn't access to the pool after detached except it has
>   * other reference to the pool.
>   */
> -static void worker_detach_from_pool(struct worker *worker,
> -                                   struct worker_pool *pool)
> +static void worker_detach_from_pool(struct worker *worker)
>  {
> +       struct worker_pool *pool = worker->pool;
>         struct completion *detach_completion = NULL;
>
>         mutex_lock(&wq_pool_attach_mutex);
> +
>         list_del(&worker->node);
> +       worker->pool = NULL;
> +
>         if (list_empty(&pool->workers))
>                 detach_completion = pool->detach_completion;
>         mutex_unlock(&wq_pool_attach_mutex);
> @@ -1799,7 +1802,6 @@ static struct worker *create_worker(struct worker_pool *pool)
>         if (!worker)
>                 goto fail;
>
> -       worker->pool = pool;
>         worker->id = id;
>
>         if (pool->cpu >= 0)
> @@ -2236,7 +2238,7 @@ static int worker_thread(void *__worker)
>
>                 set_task_comm(worker->task, "kworker/dying");
>                 ida_simple_remove(&pool->worker_ida, worker->id);
> -               worker_detach_from_pool(worker, pool);
> +               worker_detach_from_pool(worker);
>                 kfree(worker);
>                 return 0;
>         }
> @@ -2367,7 +2369,6 @@ static int rescuer_thread(void *__rescuer)
>                 worker_attach_to_pool(rescuer, pool);
>
>                 spin_lock_irq(&pool->lock);
> -               rescuer->pool = pool;
>
>                 /*
>                  * Slurp in all works issued via this workqueue and
> @@ -2417,10 +2418,9 @@ static int rescuer_thread(void *__rescuer)
>                 if (need_more_worker(pool))
>                         wake_up_worker(pool);
>
> -               rescuer->pool = NULL;
>                 spin_unlock_irq(&pool->lock);
>
> -               worker_detach_from_pool(rescuer, pool);
> +               worker_detach_from_pool(rescuer);
>
>                 spin_lock_irq(&wq_mayday_lock);
>         }
> diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
> index d390d1b..4a182e0 100644
> --- a/kernel/workqueue_internal.h
> +++ b/kernel/workqueue_internal.h
> @@ -37,7 +37,7 @@ struct worker {
>         /* 64 bytes boundary on 64bit, 32 on 32bit */
>
>         struct task_struct      *task;          /* I: worker task */
> -       struct worker_pool      *pool;          /* I: the associated pool */
> +       struct worker_pool      *pool;          /* A: the associated pool */
>                                                 /* L: for rescuers */

I guess ` /* L: for rescuers */ ` needed to be removed.

And there are many usages of worker->pool without attached_mutex
heled. The only locking annotation "A:" is not enough. Additional
comment is needed too.

1) called from the worker(including rescuer) task: it is safe because only
    the worker task itself can call the attach()/detach().

2) called from the destroy_worker() (only normal worker): it is safe
    because it is immutable before the worker detaches itself.

>         struct list_head        node;           /* A: anchored at pool->workers */
>                                                 /* A: runs through worker->node */
> --
> 2.9.5
>
