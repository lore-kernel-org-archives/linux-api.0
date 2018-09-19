From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Wed, 19 Sep 2018 16:37:31 +0000
Message-ID: <alpine.DEB.2.21.1809191630260.26757@digraph.polyomino.org.uk>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919144438.1066-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha@sourceware.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 19 Sep 2018, Mathieu Desnoyers wrote:

> Here is a rough prototype registering rseq(2) TLS for each thread
> (including main), and unregistering for each thread (excluding
> main). "rseq" stands for Restartable Sequences.

A final patch would need to add documentation and tests and a NEWS entry 
and fix various coding style issues.

> diff --git a/nptl/Versions b/nptl/Versions
> index e7f691da7a..7316c2815d 100644
> --- a/nptl/Versions
> +++ b/nptl/Versions
> @@ -275,6 +275,7 @@ libpthread {
>      mtx_init; mtx_lock; mtx_timedlock; mtx_trylock; mtx_unlock; mtx_destroy;
>      call_once; cnd_broadcast; cnd_destroy; cnd_init; cnd_signal;
>      cnd_timedwait; cnd_wait; tss_create; tss_delete; tss_get; tss_set;
> +    __rseq_abi; __rseq_refcount;

That's the GLIBC_2.28 section, but 2.28 is already out.  New symbols would 
need to go in GLIBC_2.29 or later (and the ABI test baselines would all 
need updating).

> diff --git a/sysdeps/unix/sysv/linux/rseq.h b/sysdeps/unix/sysv/linux/rseq.h

This looks like it's coming from the Linux kernel.  Can't the relevant 
uapi header just be used directly without copying into glibc (with due 
care to ensure that glibc still builds if the kernel headers used for the 
build are too old - you need such conditionals anyway if they don't define 
the relevant syscall number)?

-- 
Joseph S. Myers
joseph@codesourcery.com
