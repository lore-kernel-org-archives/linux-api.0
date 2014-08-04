From: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 2/7] locking/rwsem: more aggressive use of optimistic
 spinning
Date: Sun, 03 Aug 2014 21:10:50 -0700
Message-ID: <1407125450.4710.38.camel@j-VirtualBox>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
	 <1407119782-41119-3-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407119782-41119-3-git-send-email-Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
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
> Signed-off-by: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
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

Hi,

So "on_cpu = true" was recently converted to "on_cpu = false" in order
to address issues such as a 5x performance regression in the xfs_repair
workload that was caused by the original rwsem optimistic spinning code.

However, patch 4 in this patchset does address some of the problems with
spinning when there are readers. CC'ing Dave Chinner, who did the
testing with the xfs_repair workload.
