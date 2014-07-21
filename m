From: Jason Low <jason.low2@hp.com>
Subject: Re: [RFC PATCH 2/5] futex: add optimistic spinning to
 FUTEX_SPIN_LOCK
Date: Mon, 21 Jul 2014 13:17:18 -0700
Message-ID: <1405973838.4677.11.camel@j-VirtualBox>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <1405956271-34339-3-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1405956271-34339-3-git-send-email-Waiman.Long@hp.com>
Sender: linux-doc-owner@vger.kernel.org
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-07-21 at 11:24 -0400, Waiman Long wrote:
> This patch adds code to do optimistic spinning for the FUTEX_SPIN_LOCK
> primitive on the futex value when the lock owner is running. It is
> the same optimistic spinning technique that is done in the mutex and
> rw semaphore code to improve their performance especially on large
> systems with large number of CPUs. When the lock owner is not running,
> the spinning tasks will go to sleep.

Perhaps we could introduce a "CONFIG_FUTEX_SPIN_ON_OWNER" that depends
on SMP and ARCH_SUPPORTS_ATOMIC_RMW?

> There is 2 major advantages of doing optimistic spinning here:
>  1) It eliminates the context switching latency and overhead (at
>     least a few us) associated with sleeping and wakeup.
>  2) It eliminates most of the need to call futex(2) with
>     FUTEX_SPIN_UNLOCK as spinning is done without the need to set
>     the FUTEX_WAITERS bit.

>  struct futex_q_head {
>  	struct list_head	      hnode;
>  	struct list_head	      waitq;
>  	union futex_key		      key;
> +	struct optimistic_spin_queue *osq;

And this would have to be updated to

+	struct optimistic_spin_queue osq;

given the recent changes to the osq lock.


