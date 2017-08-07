From: "Maciej W. Rozycki" <macro@imgtec.com>
Subject: Re: [PATCH 4/7] signal/mips: Document a conflict with SI_USER with
 SIGFPE
Date: Mon, 7 Aug 2017 17:18:11 +0100
Message-ID: <alpine.DEB.2.00.1708071706290.17596@tp.orcam.me.uk>
References: <87o9shg7t7.fsf_-_@xmission.com> <20170718140651.15973-4-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170718140651.15973-4-ebiederm@xmission.com>
Sender: linux-arch-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Ralf Baechle <ralf@linux-mips.org>
List-Id: linux-api@vger.kernel.org

On Tue, 18 Jul 2017, Eric W. Biederman wrote:

> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index b68b4d0726d3..6c9cca9c5341 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -735,7 +735,7 @@ void force_fcr31_sig(unsigned long fcr31, void __user *fault_addr,
>  	else if (fcr31 & FPU_CSR_INE_X)
>  		si.si_code = FPE_FLTRES;
>  	else
> -		si.si_code = __SI_FAULT;
> +		si.si_code = FPE_FIXME;

 This is an "impossible" state to reach unless your hardware is on fire.  
One or more of the FCSR Cause bits will have been set (in `fcr31') or the 
FPE exception would not have happened.

 Of course there could be a simulator bug, or we could have breakage 
somewhere causing `process_fpemu_return' to be called with SIGFPE and 
inconsistent `fcr31'.  So we need to handle it somehow.

 So what would be the right value of `si_code' to use here for such an 
unexpected exception condition?  I think `BUG()' would be too big a 
hammer here.  Or wouldn't it?

  Maciej
