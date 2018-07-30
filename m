From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH] prctl: add PR_[GS]ET_KILLABLE
Date: Mon, 30 Jul 2018 21:32:54 +0200
Message-ID: <922baeb3d6d6387c480026fc3a6ca01d915f60a5.camel@bitron.ch>
References: <20180730075241.24002-1-j@bitron.ch>
         <20180730101659.GA24781@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180730101659.GA24781@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2018-07-30 at 12:17 +0200, Oleg Nesterov wrote:
> On 07/30, Jürg Billeter wrote:
> > 
> > This is required for job control in a shell that uses CLONE_NEWPID for
> > child processes.
> 
> Could you explain in more details?

The SIGNAL_UNKILLABLE flag, which is implicitly set for tasks cloned
with CLONE_NEWPID, has the effect of ignoring all signals (from
userspace) if the corresponding handler is set to SIG_DFL. The only
exceptions are SIGKILL and SIGSTOP and they are only accepted if raised
from an ancestor namespace.

SIGINT, SIGQUIT and SIGTSTP are used in job control for ^C, ^\, ^Z.
While a task with the SIGNAL_UNKILLABLE flag could install handlers for
these signals, this is not sufficient to implement a shell that uses
CLONE_NEWPID for child processes:

 * As SIGSTOP is ignored when raised from the SIGNAL_UNKILLABLE process
   itself, I don't think it's possible to implement the stop action in
   a custom SIGTSTP handler.
 * Many applications do not install handlers for these signals and
   thus, job control won't work properly with unmodified applications.

Job control in a shell is just an example. There are other scenarios,
of course, where applications rely on the default actions as described
in signal(7), and PID isolation may be useful. In my opinion, the
kernel support for preventing accidental killing of the "init" process
should really be optional and this new prctl provides this without
breaking backward compatibility.

> > +	case PR_SET_KILLABLE:
> > +		if (arg2 != 1 || arg3 || arg4 || arg5)
> > +			return -EINVAL;
> > +		me->signal->flags &= ~SIGNAL_UNKILLABLE;
> 
> this needs spin_lock_irq(me->sighand->siglock).

Thanks for the review, will fix this for v2.

Jürg
