From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 19:52:23 +0100
Message-ID: <20160201185223.GA21136@redhat.com>
References: <56AE3369.2090709@list.ru>
 <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com>
 <20160201170958.GA20735@redhat.com>
 <56AF955D.7060601@list.ru>
 <20160201180443.GA21064@redhat.com>
 <56AFA0E2.1030302@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56AFA0E2.1030302-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Stas, I probably missed something, but I don't understand your concerns=
,

On 02/01, Stas Sergeev wrote:
>
> 01.02.2016 21:04, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Yes, and SS_FORCE means "I know what I do", looks very simple.
> But to me its not because I don't know what to do with
> uc_stack after SS_FORCE is applied.

Nothing? restore_sigaltstack() should work as expected?

> >I won't argue, but to me it would be better to keep this EPERM if !f=
orce.
> >Just because we should avoid the incompatible changes if possible.
> Ok then. Lets implement SS_FORCE.
> What semantic should it have wrt uc_stack?
>
> sigaltstack(SS_DISABLE | SS_FORCE);
> swapcontext();
> sigaltstack(set up new_sas);
> rt_sigreturn();

Yes, or

	sigaltstack({ DISABLE | FORCE}, &old_ss);
	swapcontext();
	sigaltstack(&old_ss, NULL);
	rt_sigreturn();

and if you are going to return from sighandler you do not even need the=
 2nd
sigaltstack(), you can rely on sigreturn.

> What's at the end? Do we want a surprise for the user
> that he's new_sas got ignored?

Can't understand.... do you mean "set up new_sas" will be ignored becau=
se
rt_sigreturn() does restore_sigaltstack() ? I see no problem here...

Oleg.
