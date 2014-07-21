From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 09:42:48 -0700
Message-ID: <8761iq3bp3.fsf@tassilo.jf.intel.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> (Waiman
	Long's message of "Mon, 21 Jul 2014 11:24:26 -0400")
Sender: linux-doc-owner@vger.kernel.org
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

Waiman Long <Waiman.Long@hp.com> writes:

> This patch series introduces two new futex command codes to support
> a new optimistic spinning futex for implementing an exclusive lock
> primitive that should perform better than the same primitive using
> the wait-wake futex in cases where the lock owner is actively working
> instead of waiting for I/O completion.

How would you distinguish those two cases automatically?
>
> This patch series improves futex performance on two different fronts:
>  1) Reducing the amount of the futex spinlock contention by using 2
>     different spinlocks instead of just one for the wait-wake futex.
>  2) Eliminating the context switching overhead and latency due to the
>     sleeping and the waking of the waiting tasks.

FWIW the main problem is currently that switch-through-idle is so 
slow. I think improving that would give a boost to far more
situations.

> Patch 4 changes sleeping queue from a simple FIFO list to an rbtree
> sorted by process priority as well as the sequeunce the tasks enter
> the kernel.

This seems to mix new functionality with performance improvements?

Generally adding new ordering in an user interface is risky because
often user programs have been tuned for specific old ordering.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
