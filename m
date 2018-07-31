From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH v2] prctl: add PR_[GS]ET_KILLABLE
Date: Tue, 31 Jul 2018 18:12:48 +0200
Message-ID: <f21a22c9730ab455504f58a5fbda72cba0eb1227.camel@bitron.ch>
References: <20180730075241.24002-1-j@bitron.ch>
         <20180731070337.61004-1-j@bitron.ch> <20180731143949.GA1890@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731143949.GA1890@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2018-07-31 at 16:39 +0200, Oleg Nesterov wrote:
> On 07/31, Jürg Billeter wrote:
> > SIGINT, SIGQUIT and SIGTSTP are used in job control for ^C, ^\, ^Z.
> > While a task with the SIGNAL_UNKILLABLE flag could install handlers for
> > these signals, this is not sufficient to implement a shell that uses
> > CLONE_NEWPID for child processes:
> 
> Ah. My question wasn't clear, sorry.
> 
> Could you explain your use-case? Why a shell wants to use
> CLONE_NEWPID?

To guarantee that there won't be any runaway processes, i.e., ensure
that no descendants (background helper daemons or misbehaving
processes) survive when the child process is terminated. And to prevent
children from killing their ancestors. This is not something that can
be always-on in all shells, but it could be an option for users that
want this control/isolation.

> And what do we actually want in, say, ^Z case? Just stop the child reaper
> or may be it would be better to stop the whole pid namespace?

Stopping the whole PID namespace would be interesting, however, I think
this should be discussed separately if and when there is a proposal to
support this. For now the process group is stopped, same as without PID
namespaces.

> >  * As SIGSTOP is ignored when raised from the SIGNAL_UNKILLABLE process
> >    itself, it's not possible to implement the stop action in a custom
> >    SIGTSTP handler.
> 
> Yes. So may be we actually want to change __isig() paths to use
> SEND_SIG_FORCED (this is not that simple), or perhaps we can change
> __send_signal() to not drop SIGSTOP sent to itself, or may be we can even
> introduce SIG_DFL_EVEN_IF_INIT, I dunno.

In my opinion, my patch is much simpler and also more general as it
covers all scenarios where regular signal handling is required or
desired for "init" processes, with minimal code changes (after
PR_SET_KILLABLE, binaries that expect SIG_DFL to work can be executed
without changes).

> >  * Many applications do not install handlers for these signals and
> >    thus, job control won't work properly with unmodified applications.
> 
> I can't understand this. An application should be changed anyway to do
> PR_SET_KILLABLE?

PR_SET_KILLABLE can be called (e.g., by the shell) between clone() and
execve(). (Some applications may have issues running as subreaper but
that's a separate matter, signal handling will work as expected).

> > +	case PR_SET_KILLABLE:
> > +		if (arg2 != 1 || arg3 || arg4 || arg5)
> > +			return -EINVAL;
> > +		spin_lock_irq(&me->sighand->siglock);
> > +		me->signal->flags &= ~SIGNAL_UNKILLABLE;
> > +		spin_unlock_irq(&me->sighand->siglock);
> 
> OK, but then you need to change the CLONE_PARENT/SIGNAL_UNKILLABLE check
> in copy_process().

Good point, need a different check for the PID namespace root process
in copy_process().

Thanks,
Jürg
