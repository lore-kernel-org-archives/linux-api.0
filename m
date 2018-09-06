From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 2/2] prctl: add PR_[GS]ET_KILLABLE
Date: Thu, 6 Sep 2018 15:42:08 -0700
Message-ID: <20180906154208.24f397896957116d1a644a3b@linux-foundation.org>
References: <20180730075241.24002-1-j@bitron.ch>
        <20180803144021.56920-1-j@bitron.ch>
        <20180803144021.56920-2-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180803144021.56920-2-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri,  3 Aug 2018 16:40:21 +0200 Jürg Billeter <j@bitron.ch> wrote:

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
> 
>  * As SIGSTOP is ignored when raised from the SIGNAL_UNKILLABLE process
>    itself, it's not possible to implement the stop action in a custom
>    SIGTSTP handler.
>  * Many applications do not install handlers for these signals and
>    thus, job control won't work properly with unmodified applications.
> 
> There are other scenarios besides job control in a shell where
> applications rely on the default actions as described in signal(7) and
> PID isolation may be useful. This new prctl makes the signal protection
> for "init" processes optional, without breaking backward compatibility.

This one is above my pay grade.  Eric & Oleg: could you please provide
input?
