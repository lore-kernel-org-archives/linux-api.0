From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 19:04:43 +0100
Message-ID: <20160201180443.GA21064@redhat.com>
References: <56AE3369.2090709@list.ru>
 <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com>
 <20160201170958.GA20735@redhat.com>
 <56AF955D.7060601@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AF955D.7060601@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Stas Sergeev <stsp@list.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Amanieu d'Antras <amanieu@gmail.com>, Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jason Low <jason.low2@hp.com>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Andrea Arcangeli <aarcange@redhat.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Josh Triplett <josh@joshtriplett.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Paul Moore <pmoore@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, Vladimir Davydov <vdavydov@parallels.com>
List-Id: linux-api@vger.kernel.org

On 02/01, Stas Sergeev wrote:
>
> 01.02.2016 20:09, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >OK, I didn't notice you modified save_altstack_ex() to use ->sas_ss_=
flags instead
> >of sas_ss_flags()... still doesn't look right, in this case restore_=
altstack() will
> >not restore sas_ss_size/sas_ss_sp and they can be changed by signal =
handler.
> How?
> Trying to change them in a sighandler with sigaltstack()
> will get EPERM.

Only if on_sig_stack() and this is not true if we change the stack.

> >Anyway, whatever I missed I agree with Andy, SS_FORCE looks simpler =
and better to me.
>
> But perhaps you missed the most important thing, that
> it is not possible to change the altstack in sighandler - you'll
> get EPERM, even with my patch.

See above.

> But with SS_FORCE this is
> exactly not the case.

Yes, and SS_FORCE means "I know what I do", looks very simple.

> Also it would be interesting to know what do you think about
> just removing the EPERM check instead of this all.

I won't argue, but to me it would be better to keep this EPERM if !forc=
e.
Just because we should avoid the incompatible changes if possible.

Oleg.
