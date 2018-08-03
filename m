From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH v2] prctl: add PR_[GS]ET_KILLABLE
Date: Fri, 03 Aug 2018 16:39:14 +0200
Message-ID: <548ab0d300c6b9839ad645655182d0ba26607d47.camel@bitron.ch>
References: <20180730075241.24002-1-j@bitron.ch>
         <20180731070337.61004-1-j@bitron.ch> <20180731143949.GA1890@redhat.com>
         <f21a22c9730ab455504f58a5fbda72cba0eb1227.camel@bitron.ch>
         <20180801141914.GA21248@redhat.com>
         <7f7c57230e0279f4599bf13ae1d1d449d76ac232.camel@bitron.ch>
         <87sh3vd14s.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87sh3vd14s.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 2018-08-03 at 08:34 -0500, Eric W. Biederman wrote:
> From the other direction I think we can just go ahead and fix handling
> of the job control stop signals as well.  As far as I understand it
> there is a legitimate complaint that SIGTSTP SIGTTIN SIGTTOU do not work
> on a pid namespace leader.
> 
> The current implementation actual overshoots.  We only need to ignore
> signals from the descendants in the pid namespace.  Ideally signals from
> other processes are treated like normal.  We have only been able to
> apply that ideal to SIGSTOP and SIGKILL as we can handle them in
> prepare_signal.  Other signals can be blocked which means the logic to
> handle them needs to live in get_signal where we may have no sender
> information.

SIGINT and SIGQUIT are also relevant for job control. Would the same
approach be possible for them?

And I would like to allow regular POSIX signal behavior also for
signals used outside job control, e.g., SIGTERM, for maximum
compatibility with existing applications. Furthermore, it would also be
good to allow a PID namespace leader to send a signal to itself.

Do you think we can and should cover all of the above without a prctl
by loosening the restrictions imposed by SIGNAL_UNKILLABLE (with
reasonable effort)?

In my opinion, my patch still makes sense as it simply allows regular
POSIX signal behavior for PID namespace leaders and it doesn't risk any
compatibility issues as the behavior doesn't change at all for
processes that don't invoke the new prctl. I.e., simple patch, low
risk, and covers all signals.

In the meantime I've tested the missing patch for copy_process() and
will send out v3 of the patch in case the new prctl makes sense after
all.

Jürg
