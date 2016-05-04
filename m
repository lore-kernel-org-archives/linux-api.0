From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/4] signals/sigaltstack: If SS_AUTODISARM, bypass on_sig_stack
Date: Wed, 4 May 2016 16:02:55 -0700
Message-ID: <CALCETrVzhzF_xJeYVNhg4XtQucbvYzbwaNFEpitLzpBPeAtdVA@mail.gmail.com>
References: <cover.1462296606.git.luto@kernel.org> <c46bee4654ca9e68c498462fd11746e2bd0d98c8.1462296606.git.luto@kernel.org>
 <20160504063233.GB9499@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504063233.GB9499-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>Frederic Weisbecker <f>
List-Id: linux-api@vger.kernel.org

On May 3, 2016 11:32 PM, "Ingo Molnar" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>
> * Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> > If a signal stack is set up with SS_AUTODISARM, then the kernel
> > inherently avoids incorrectly resetting the signal stack if signals
> > recurse: the signal stack will be reset on the first signal
> > delivery.  This means that we don't need check the stack pointer
> > when delivering signals if SS_AUTODISARM is set.
> >
> > This will make segmented x86 programs more robust: currently there's
> > a hole that could be triggered if ESP/RSP appears to point to the
> > signal stack but actually doesn't due to a nonzero SS base.
> >
> > Signed-off-by: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
>
> Presuably that SOB from Stas is stray, as there's no matching From: line?
> I've removed it.

Yes.  It was a cut-and-paste-o -- I meant to change it to cc.

>
> Thanks,
>
>         Ingo
