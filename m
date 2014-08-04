From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH 2/7] locking/rwsem: more aggressive use of optimistic
 spinning
Date: Sun, 03 Aug 2014 21:09:44 -0700
Message-ID: <1407125384.3216.4.camel@buesod1.americas.hpqcorp.net>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
	 <1407119782-41119-3-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407119782-41119-3-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
> The rwsem_can_spin_on_owner() function currently allows optimistic
> spinning only if the owner field is defined and is running. That is
> too conservative as it will cause some tasks to miss the opportunity
> of doing spinning in case the owner hasn't been able to set the owner
> field in time or the lock has just become available.
> 
> This patch enables more aggressive use of optimistic spinning by
> assuming that the lock is spinnable unless proved otherwise.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  kernel/locking/rwsem-xadd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index d058946..dce22b8 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -285,7 +285,7 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
>  static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
>  {
>  	struct task_struct *owner;
> -	bool on_cpu = false;
> +	bool on_cpu = true;	/* Assume spinnable unless proved not to be */

Nope, unfortunately we need as it fixes some pretty bad regressions when
dealing with multiple readers -- as readers do not deal with lock
ownership, so another thread can spin for too long in !owner. See commit
37e95624.
