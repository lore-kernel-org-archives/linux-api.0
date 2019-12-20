From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH for 5.5 0/3] Restartable Sequences Fixes
Date: Fri, 20 Dec 2019 15:48:27 +0100
Message-ID: <20191220144827.GJ2844@hirez.programming.kicks-ass.net>
References: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 11, 2019 at 11:17:10AM -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> Here is a repost of a small set of rseq fixes which was initially posted
> in September 2019. It now targets kernel 5.5. Those should be backported
> to stable kernels >= 4.18.
> 
> Thanks,
> 
> Mathieu
> 
> Mathieu Desnoyers (3):
>   rseq: Fix: Reject unknown flags on rseq unregister
>   rseq: Fix: Unregister rseq for clone CLONE_VM
>   rseq/selftests: Fix: Namespace gettid() for compatibility with glibc
>     2.30

I've picked up the first two patches, thanks!
