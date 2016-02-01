From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 18:27:33 +0100
Message-ID: <20160201172733.GA20831@redhat.com>
References: <56AE3369.2090709@list.ru>
 <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com>
 <56AF8E89.5090400@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56AF8E89.5090400-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/01, Stas Sergeev wrote:
>
> >So the sequence is
> >
> >	// running on alt stack
> >
> >	sigaltstack(SS_DISABLE);
> >
> >	temporary_run_on_another_stack();
> >
> >	sigaltstack(SS_ONSTACK);
> >
> >and SS_DISABLE saves us from another SA_ONSTACK signal, right?
> Yes.
> Note: there is a test-case in that patch serie from which
> you can see or copy/paste the sample code.

OK, I wasn't cc'ed

> >But afaics it can only help after we change the stack. Suppose that SA_ONSTACK signal
> >comess before temporary_run_on_another_stack(). get_sigframe() should be fine after
> >your changes (afaics), it won't pick the alt stack after SS_DISABLE.
> >
> >However, unless I missed something save_altstack_ex() will record SS_ONSTACK in
> >uc_stack->ss_flags, and after return from signal handler restore_altstack() will
> >enable alt stack again?
> I don't think so. Please see the following hunk:

Yes, see another email, I already noticed this change.

> So I understand this is very confusing, but I think the patch
> is correct.

Not sure, but I can hardly read this patch and I can't apply it.

> Do you think adding the SS_FORCE flag would be a better solution?

Yes, certainly. I see no point to remember that a thread actually has the alt stack
but it was disabled.

Oleg.
