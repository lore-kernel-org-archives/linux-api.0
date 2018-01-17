From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for 4.16 07/11] x86: Implement sync_core_before_usermode (v3)
Date: Wed, 17 Jan 2018 09:53:12 -0800
Message-ID: <CALCETrWqRPsmLY=sTo5YHbWRh3HWjrVQ4FOn-=YfP=4_n98F6w@mail.gmail.com>
References: <20180117165458.13330-1-mathieu.desnoyers@efficios.com> <20180117165458.13330-8-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180117165458.13330-8-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 17, 2018 at 8:54 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> Ensure that a core serializing instruction is issued before returning to
> user-mode. x86 implements return to user-space through sysexit, sysrel,
> and sysretq, which are not core serializing.
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
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
> Changes since v1:
> - Fix prototype of sync_core_before_usermode in generic code (missing
>   return type).
> - Add linux/processor.h include to sched/core.c.
> - Add ARCH_HAS_SYNC_CORE_BEFORE_USERMODE to init/Kconfig.
> - Fix linux/processor.h ifdef to target
>   CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE rather than
>   ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.
> - Move empty static inline in processor.h to generic patch.
> ---
>  arch/x86/Kconfig                 |  1 +
>  arch/x86/include/asm/processor.h | 10 ++++++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 20da391b5f32..0b44c8dd0e95 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -61,6 +61,7 @@ config X86
>         select ARCH_HAS_SG_CHAIN
>         select ARCH_HAS_STRICT_KERNEL_RWX
>         select ARCH_HAS_STRICT_MODULE_RWX
> +       select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
>         select ARCH_HAS_UBSAN_SANITIZE_ALL
>         select ARCH_HAS_ZONE_DEVICE             if X86_64
>         select ARCH_HAVE_NMI_SAFE_CMPXCHG
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index d3a67fba200a..3257d34dbb40 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -722,6 +722,16 @@ static inline void sync_core(void)
>  #endif
>  }
>
> +/*
> + * Ensure that a core serializing instruction is issued before returning
> + * to user-mode. x86 implements return to user-space through sysexit,
> + * sysrel, and sysretq, which are not core serializing.
> + */
> +static inline void sync_core_before_usermode(void)
> +{

/* With PTI, we unconditionally serialize before running user code. */
if (static_cpu_has(X86_FEATURE_PTI))
  return;

> +       sync_core();
> +}

--Andy
