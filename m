From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH for 4.15 05/10] x86: Introduce sync_core_before_usermode
Date: Fri, 10 Nov 2017 14:02:41 -0800
Message-ID: <CALCETrWV+bgUPoS7NqVYhoi7hOyvsfoWw5CnyMrkYz=HYznmXQ@mail.gmail.com>
References: <20171110213717.12457-1-mathieu.desnoyers@efficios.com> <20171110213717.12457-6-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110213717.12457-6-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 10, 2017 at 1:37 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> Introduce an architecture function that ensures the current CPU
> issues a core serializing instruction before returning to usermode.
>
> This is needed to fix an existing core serialization bug on
> thread migration, and also needed by the membarrier "sync_core" command.
>
> Architectures defining the sync_core_before_usermode() static inline
> need to define ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Andy Lutomirski <luto@kernel.org>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CC: Boqun Feng <boqun.feng@gmail.com>
> CC: Andrew Hunter <ahh@google.com>
> CC: Maged Michael <maged.michael@gmail.com>
> CC: Avi Kivity <avi@scylladb.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Michael Ellerman <mpe@ellerman.id.au>
> CC: Dave Watson <davejwatson@fb.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Andrea Parri <parri.andrea@gmail.com>
> CC: Russell King <linux@armlinux.org.uk>
> CC: Greg Hackmann <ghackmann@google.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: David Sehr <sehr@google.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: x86@kernel.org
> CC: linux-arch@vger.kernel.org
> ---
>  arch/x86/Kconfig                 |  1 +
>  arch/x86/include/asm/processor.h | 10 ++++++++++
>  include/linux/processor.h        |  6 ++++++
>  3 files changed, 17 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 01f78c1d40b5..54fbb8960d94 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -62,6 +62,7 @@ config X86
>         select ARCH_HAS_SG_CHAIN
>         select ARCH_HAS_STRICT_KERNEL_RWX
>         select ARCH_HAS_STRICT_MODULE_RWX
> +       select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
>         select ARCH_HAS_UBSAN_SANITIZE_ALL
>         select ARCH_HAS_ZONE_DEVICE             if X86_64
>         select ARCH_HAVE_NMI_SAFE_CMPXCHG
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index bdac19ab2488..6ce996a7c730 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -706,6 +706,16 @@ static inline void sync_core(void)
>  #endif
>  }
>
> +/*
> + * Ensure that a core serializing instruction is issued before returning
> + * to user-mode. x86 implements return to user-space through sysexit and
> + * sysretq, which are not core serializing.
> + */
> +static inline void sync_core_before_usermode(void)
> +{
> +       sync_core();
> +}

Make this if (!in_interrupt()) sync_core(); please.  We can optimize
it better later on.
