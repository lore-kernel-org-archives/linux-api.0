From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at nptl init and thread creation (v4)
Date: Tue, 04 Dec 2018 20:44:00 +0100
Message-ID: <8736rd13i7.fsf@oldenburg2.str.redhat.com>
References: <20181204192141.4684-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181204192141.4684-1-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Tue, 4 Dec 2018 14:21:38 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Carlos O'Donell <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> diff --git a/sysdeps/unix/sysv/linux/riscv/rv64/libpthread.abilist b/sysdeps/unix/sysv/linux/riscv/rv64/libpthread.abilist
> index c370fda73d..9da78d59d2 100644
> --- a/sysdeps/unix/sysv/linux/riscv/rv64/libpthread.abilist
> +++ b/sysdeps/unix/sysv/linux/riscv/rv64/libpthread.abilist
> @@ -235,3 +235,4 @@ GLIBC_2.28 tss_create F
>  GLIBC_2.28 tss_delete F
>  GLIBC_2.28 tss_get F
>  GLIBC_2.28 tss_set F
> +GLIBC_2.29 __rseq_refcount T 0x4

This part looks buggy.

It's unclear based on this patch whether you actually want to get rid of
the __rseq_refcount symbol.

Thanks,
Florian
