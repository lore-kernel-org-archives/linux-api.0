From: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system call
Date: Tue, 14 Nov 2017 20:49:54 +0000
Message-ID: <CY4PR15MB1688CE0F2139CEB72B467242CF280@CY4PR15MB1688.namprd15.prod.outlook.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>,<20171114200414.2188-2-mathieu.desnoyers@efficios.com>,<CY4PR15MB168884529B3C0F8E6CC06257CF280@CY4PR15MB1688.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR15MB168884529B3C0F8E6CC06257CF280-ZVJ2su15u+xeX4ZvlgGe+Yd3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

(apologies for the duplicate email, the previous one bounced as it was acci=
dentally using HTML formatting)

If I understand correctly this is run on every context switch so we probabl=
y want to make it really fast

> +static int rseq_need_restart(struct task_struct *t, uint32_t cs_flags)
> +{
> +       bool need_restart =3D false;
> +       uint32_t flags;
> +
> +       /* Get thread flags. */
> +       if (__get_user(flags, &t->rseq->flags))
> +               return -EFAULT;
> +
> +       /* Take into account critical section flags. */
> +       flags |=3D cs_flags;
> +
> +       /*
> +        * Restart on signal can only be inhibited when restart on
> +        * preempt and restart on migrate are inhibited too. Otherwise,
> +        * a preempted signal handler could fail to restart the prior
> +        * execution context on sigreturn.
> +        */
> +       if (flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) {
> +               if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
> +                       return -EINVAL;
> +               if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
> +                       return -EINVAL;
> +       }

How does this error even get to userspace? Is it worth doing this switch on=
 every execution?


> +       if (t->rseq_migrate
> +                       && !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
> +               need_restart =3D true;
> +       else if (t->rseq_preempt
> +                       && !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
> +               need_restart =3D true;
> +       else if (t->rseq_signal
> +                       && !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL))
> +               need_restart =3D true;

This could potentially be sped up by having the rseq_* fields in t use a si=
ngle bitmask with the same bit offsets as RSEQ_CS_FLAG_NO_* then using bit =
operations to check the appropriate overlap.=
