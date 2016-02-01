From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 20:29:36 +0100
Message-ID: <20160201192936.GA21214@redhat.com>
References: <56AE3369.2090709@list.ru>
 <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com>
 <20160201170958.GA20735@redhat.com>
 <56AF955D.7060601@list.ru>
 <20160201180443.GA21064@redhat.com>
 <56AFA0E2.1030302@list.ru>
 <20160201185223.GA21136@redhat.com>
 <56AFAB9D.4070007@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AFAB9D.4070007@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Stas Sergeev <stsp@list.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Amanieu d'Antras <amanieu@gmail.com>, Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jason Low <jason.low2@hp.com>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Andrea Arcangeli <aarcange@redhat.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Josh Triplett <josh@joshtriplett.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Paul Moore <pmoore@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, Vladimir Davydov <vdavydov@parallels.com>
List-Id: linux-api@vger.kernel.org

On 02/01, Stas Sergeev wrote:
>
> 01.02.2016 21:52, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >Stas, I probably missed something, but I don't understand your conce=
rns,
> >
> >On 02/01, Stas Sergeev wrote:
> >>01.02.2016 21:04, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>Yes, and SS_FORCE means "I know what I do", looks very simple.
> >>But to me its not because I don't know what to do with
> >>uc_stack after SS_FORCE is applied.
> >Nothing? restore_sigaltstack() should work as expected?
> That's likely the reason for EPERM: restore_sigaltstack()
> does the job, so manual modifications are disallowed.
> Allowing them will bring in the surprises where the changes
> done by the user are ignored.

Unlikely. Suppose you do sigalstack() and then a non SA_ONSTACK signal =
handler
runs and calls sigaltstack() again. This won't fail, but restore_sigalt=
stack()
will restore the old alt stack after return.

I too do not know why uc_stack exists, in fact I do not know about it u=
ntil
today when I read your patch ;) But it is here, and I do not think SS_F=
ORCE
can add more confusion than we already have.

> >Yes, or
> >
> >	sigaltstack({ DISABLE | FORCE}, &old_ss);
> >	swapcontext();
> >	sigaltstack(&old_ss, NULL);
> >	rt_sigreturn();
> >
> >and if you are going to return from sighandler you do not even need =
the 2nd
> >sigaltstack(), you can rely on sigreturn.
> Yes, that's what I do in my app already.
> But its only there when SA_SIGINFO is used.

Hmm. how this connects to SA_SIGINFO ?

> >>What's at the end? Do we want a surprise for the user
> >>that he's new_sas got ignored?
> >Can't understand.... do you mean "set up new_sas" will be ignored be=
cause
> >rt_sigreturn() does restore_sigaltstack() ? I see no problem here...
> Allowing the modifications that were previously EPERMed
> but will now be silently ignored, may be seen as a problem.
> But if it isn't - fine, lets code that.

Still can't understand. The 2nd sigaltstack() is no longer EPERMed beca=
use
application used SS_FORCED before that and disabled altstack.

And it is not ignored, it actually changes alt stack. Until we return f=
rom
handler.

Oleg.
