From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] prctl: add PR_[GS]ET_KILLABLE
Date: Mon, 30 Jul 2018 21:39:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1807302138580.1725@nanos.tec.linutronix.de>
References: <20180730075241.24002-1-j@bitron.ch>         <20180730101659.GA24781@redhat.com> <922baeb3d6d6387c480026fc3a6ca01d915f60a5.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-788013628-1532979573=:1725"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <922baeb3d6d6387c480026fc3a6ca01d915f60a5.camel@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-15?Q?J=FCrg_Billeter?= <j@bitron.ch>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-788013628-1532979573=:1725
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 30 Jul 2018, Jürg Billeter wrote:

> On Mon, 2018-07-30 at 12:17 +0200, Oleg Nesterov wrote:
> > On 07/30, Jürg Billeter wrote:
> > > 
> > > This is required for job control in a shell that uses CLONE_NEWPID for
> > > child processes.
> > 
> > Could you explain in more details?
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
>    itself, I don't think it's possible to implement the stop action in
>    a custom SIGTSTP handler.
>  * Many applications do not install handlers for these signals and
>    thus, job control won't work properly with unmodified applications.
> 
> Job control in a shell is just an example. There are other scenarios,
> of course, where applications rely on the default actions as described
> in signal(7), and PID isolation may be useful. In my opinion, the
> kernel support for preventing accidental killing of the "init" process
> should really be optional and this new prctl provides this without
> breaking backward compatibility.

This makes sense and exactly that information needs to be in the changelog.

Thanks,

	tglx
--8323329-788013628-1532979573=:1725--
