From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 21:41:14 +0100
Message-ID: <20160201204114.GA21638@redhat.com>
References: <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com>
 <20160201170958.GA20735@redhat.com>
 <56AF955D.7060601@list.ru>
 <20160201180443.GA21064@redhat.com>
 <56AFA0E2.1030302@list.ru>
 <20160201185223.GA21136@redhat.com>
 <56AFAB9D.4070007@list.ru>
 <20160201192936.GA21214@redhat.com>
 <56AFB604.4010008@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AFB604.4010008@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Stas Sergeev <stsp@list.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Amanieu d'Antras <amanieu@gmail.com>, Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jason Low <jason.low2@hp.com>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Andrea Arcangeli <aarcange@redhat.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Josh Triplett <josh@joshtriplett.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Paul Moore <pmoore@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, Vladimir Davydov <vdavydov@parallels.com>
List-Id: linux-api@vger.kernel.org

On 02/01, Stas Sergeev wrote:
>
> 01.02.2016 22:29, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>
> >>>	sigaltstack({ DISABLE | FORCE}, &old_ss);
> >>>	swapcontext();
> >>>	sigaltstack(&old_ss, NULL);
> >>>	rt_sigreturn();
> >>>
> >>>and if you are going to return from sighandler you do not even nee=
d the 2nd
> >>>sigaltstack(), you can rely on sigreturn.
> >>Yes, that's what I do in my app already.
> >>But its only there when SA_SIGINFO is used.
> >Hmm. how this connects to SA_SIGINFO ?
> AFAIK without SA_SIGINFO you get sigreturn instead of
> rt_sigreturn, which doesn't seem to do restore_altstack().
> Or am I wrong?
>
> Hmm:
>
>         /* Set up the stack frame */
>         if (is_ia32_frame()) {
>                 if (ksig->ka.sa.sa_flags & SA_SIGINFO)
>                         return ia32_setup_rt_frame(usig, ksig, cset, =
regs);
>                 else
>                         return ia32_setup_frame(usig, ksig, cset, reg=
s);

Ah, ia32... So this is even more confusing.

> >>>>What's at the end? Do we want a surprise for the user
> >>>>that he's new_sas got ignored?
> >>>Can't understand.... do you mean "set up new_sas" will be ignored =
because
> >>>rt_sigreturn() does restore_sigaltstack() ? I see no problem here.=
=2E.
> >>Allowing the modifications that were previously EPERMed
> >>but will now be silently ignored, may be seen as a problem.
> >>But if it isn't - fine, lets code that.
> >Still can't understand. The 2nd sigaltstack() is no longer EPERMed b=
ecause
> >application used SS_FORCED before that and disabled altstack.
> >
> >And it is not ignored, it actually changes alt stack. Until we retur=
n from
> >handler.
> Before we return, the signals are usually blocked.
> So whatever is after return is most important.

Yes, but I still can't understand your "silently ignored". At least how=
 does
this differ from the case when a non-SA_ONSTACK signal handler does
sigaltstack() and then rt_sigreturn() restores the old stack.

Oleg.
