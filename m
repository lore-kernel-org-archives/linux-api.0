From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH for 4.16] membarrier-sync-core: Document architecture
 support
Date: Sat, 10 Feb 2018 12:47:00 +0100
Message-ID: <20180210114700.mq2rg4lbjtzyx5pn@gmail.com>
References: <1518208256-22034-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1518208256-22034-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Andrea Parri <parri.andrea@gmail.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@kernel.org>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, David Sehr <sehr@google.com>, Greg Hackmann <ghackmann@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Maged Michael <maged.michael@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Ensure we gather architecture requirements about each architecture
> supporting the "sync_core" membarrier command in a single file under
> Documentation/features.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Andrea Parri <parri.andrea@gmail.com>
> Cc: Andrew Hunter <ahh@google.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Avi Kivity <avi@scylladb.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Dave Watson <davejwatson@fb.com>
> Cc: David Sehr <sehr@google.com>
> Cc: Greg Hackmann <ghackmann@google.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Maged Michael <maged.michael@gmail.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-api@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> ---
>  .../sched/membarrier-sync-core/arch-support.txt    | 62 ++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/features/sched/membarrier-sync-core/arch-support.txt
> 
> diff --git a/Documentation/features/sched/membarrier-sync-core/arch-support.txt b/Documentation/features/sched/membarrier-sync-core/arch-support.txt
> new file mode 100644
> index 0000000..2c815a7
> --- /dev/null
> +++ b/Documentation/features/sched/membarrier-sync-core/arch-support.txt
> @@ -0,0 +1,62 @@
> +#
> +# Feature name:          membarrier-sync-core
> +#         Kconfig:       ARCH_HAS_MEMBARRIER_SYNC_CORE
> +#         description:   arch supports core serializing membarrier

This breaks the output of the Documentation/features/list-arch.sh script.

Thanks,

	Ingo
