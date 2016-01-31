From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Sun, 31 Jan 2016 12:11:10 -0800
Message-ID: <CALCETrXPYLqunBNxjS8bpmpg+jG_MXbSyZtUVK3X3m+pGSQ1Og@mail.gmail.com>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
 <CALCETrU1sB4FDkyrGcxY0CrCRr7qyGW0tzmpyaQDwM0UTjCRMw@mail.gmail.com>
 <56AE4567.9000403@list.ru> <CALCETrUVODhNRwvbAfC0q3RVJAFw-ZFGhsww2uQsk3UZjLynnQ@mail.gmail.com>
 <56AE69AD.6090005@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56AE69AD.6090005-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jan 31, 2016 at 12:08 PM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
> 31.01.2016 22:03, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Also, consider a use case like yours but with *two* contexts that us=
e
>> their own altstack.  If you go to context A, enable sigaltstack, get=
 a
>> signal, temporarily disable, then swapcontext to B, which tries to
>> re-enable its own sigaltstack, then everything gets confusing with
>> your patch, because, with your patch, the kernel is only tracking on=
e
>> temporarily disabled sigaltstack.
>
> Of course the good practice is to set the sigaltstack
> before creating the contexts. Then the above scenario
> should involve switching between 2 signal handlers to get
> into troubles. I think the scenario with switching between
> 2 signal handlers is very-very unrealistic.

Why is it so unrealistic?  You're already using swapcontext, which
means you're doing something like userspace threads (although I
imagine that one of your thread-like things is DOS, but still), and,
to me, that suggests that the kernel interface should be agnostic as
to how many thread-like thinks are alive.

With your patch, where the kernel remembers that you have a
temporarily disabled altstack, you can't swap out your context on one
kernel thread and swap it in on another, and you can't have two
different contexts that get used on the same thread.

ISTM it would be simpler if you did:

sigaltstack(disable, force)
swapcontext() to context using sigaltstack
sigaltstack(set new altstack)

and then later

sigaltstack(disable, force)  /* just in case.  save old state, too. */
swapcontext() to context not using sigaltstack
sigaltstack(set new altstack)

If it would be POSIX compliant to allow SS_DISABLE to work even if on
the altstack even without a new flag (which is what you're
suggesting), then getting rid of the temporary in-kernel state would
considerably simplify this patch series.  Just skip the -EPERM check
in the disable path.

--Andy
