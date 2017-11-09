From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH for 4.15 5/6] membarrier: x86: Provide core
 serializing command
Date: Thu, 9 Nov 2017 11:07:49 -0800
Message-ID: <CALCETrX4vZHxkWhLKBebZ+R_UE8pDsmVbpJzpyPt=ZgZB8w8iQ@mail.gmail.com>
References: <20171108183514.3306-1-mathieu.desnoyers@efficios.com> <20171108183514.3306-6-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108183514.3306-6-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, gromer <gromer@google.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 8, 2017 at 10:35 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:

> +/*
> + * x86-64 implements return to user-space through sysret, which is not a
> + * core-serializing instruction. Therefore, we need an explicit core
> + * serializing instruction after going from kernel thread back to
> + * user-space thread (active_mm moved back to current mm).
> + */
> +static inline void membarrier_arch_mm_sync_core(struct mm_struct *mm)
> +{
> +       if (likely(!(atomic_read(&mm->membarrier_state) &
> +                       MEMBARRIER_STATE_SYNC_CORE)))
> +               return;
> +       sync_core();
> +}

IMO there should be an extremely clear specification somewhere for
what this function is supposed to do.

If I remember correctly, it's supposed to promise that the icache is
synced before the next time we return to usermode for the current mm
on this CPU.  If that's correct, then let's document it very
explicitly and let's also drop the "membarrier" from the name -- it's
a primitive we'll need anyway given the existing migration bug.
