From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] prctl: add PR_[GS]ET_KILLABLE
Date: Tue, 31 Jul 2018 16:39:50 +0200
Message-ID: <20180731143949.GA1890@redhat.com>
References: <20180730075241.24002-1-j@bitron.ch>
 <20180731070337.61004-1-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180731070337.61004-1-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/31, Jürg Billeter wrote:
>
> PR_SET_KILLABLE clears the SIGNAL_UNKILLABLE flag. This allows
> CLONE_NEWPID tasks to restore normal signal behavior, opting out of the
> special signal protection for init processes. This prctl does not allow
> setting the SIGNAL_UNKILLABLE flag, only clearing.
>
> The SIGNAL_UNKILLABLE flag, which is implicitly set for tasks cloned
> with CLONE_NEWPID, has the effect of ignoring all signals (from
> userspace) if the corresponding handler is set to SIG_DFL. The only
> exceptions are SIGKILL and SIGSTOP and they are only accepted if raised
> from an ancestor namespace.
>
> SIGINT, SIGQUIT and SIGTSTP are used in job control for ^C, ^\, ^Z.
> While a task with the SIGNAL_UNKILLABLE flag could install handlers for
> these signals, this is not sufficient to implement a shell that uses
> CLONE_NEWPID for child processes:

Ah. My question wasn't clear, sorry.

Could you explain your use-case? Why a shell wants to use CLONE_NEWPID?
And what do we actually want in, say, ^Z case? Just stop the child reaper
or may be it would be better to stop the whole pid namespace?

>  * As SIGSTOP is ignored when raised from the SIGNAL_UNKILLABLE process
>    itself, it's not possible to implement the stop action in a custom
>    SIGTSTP handler.

Yes. So may be we actually want to change __isig() paths to use
SEND_SIG_FORCED (this is not that simple), or perhaps we can change
__send_signal() to not drop SIGSTOP sent to itself, or may be we can even
introduce SIG_DFL_EVEN_IF_INIT, I dunno.

>  * Many applications do not install handlers for these signals and
>    thus, job control won't work properly with unmodified applications.

I can't understand this. An application should be changed anyway to do
PR_SET_KILLABLE?


Let me clarify. I am not arguing with this patch, probably it makes sense in
any case. I am just trying to understand your real motivation for this change.



> +	case PR_SET_KILLABLE:
> +		if (arg2 != 1 || arg3 || arg4 || arg5)
> +			return -EINVAL;
> +		spin_lock_irq(&me->sighand->siglock);
> +		me->signal->flags &= ~SIGNAL_UNKILLABLE;
> +		spin_unlock_irq(&me->sighand->siglock);

OK, but then you need to change the CLONE_PARENT/SIGNAL_UNKILLABLE check
in copy_process().

Oleg.
