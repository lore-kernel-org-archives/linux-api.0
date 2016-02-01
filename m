From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 21:40:52 +0300
Message-ID: <56AFA6B4.8030808@list.ru>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com> <20160201170958.GA20735@redhat.com>
 <56AF955D.7060601@list.ru> <20160201180443.GA21064@redhat.com>
 <56AFA0E2.1030302@list.ru>
 <CALCETrWv87BS5hH20qKd7WGuf6EAEb4f78Myq+6fqXgSJWoiew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWv87BS5hH20qKd7WGuf6EAEb4f78Myq+6fqXgSJWoiew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

01.02.2016 21:28, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Mon, Feb 1, 2016 at 10:16 AM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>> 01.02.2016 21:04, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>> Yes, and SS_FORCE means "I know what I do", looks very simple.
>> But to me its not because I don't know what to do with
>> uc_stack after SS_FORCE is applied.
>>
>>> I won't argue, but to me it would be better to keep this EPERM if !=
force.
>>> Just because we should avoid the incompatible changes if possible.
>> Ok then. Lets implement SS_FORCE.
>> What semantic should it have wrt uc_stack?
>>
>> sigaltstack(SS_DISABLE | SS_FORCE);
>> swapcontext();
>> sigaltstack(set up new_sas);
>> rt_sigreturn();
>>
>> What's at the end? Do we want a surprise for the user
>> that he's new_sas got ignored?
> More detail please.  What context are you returning to with
> rt_sigreturn?  What's in uc_stack?
Whatever was saved there by save_altstack_ex() I guess.
Which is the sas params on signal entry.
And I am returning to the interrupted user context.
I am using SA_SIGINFO with sigaction().
This is actually what I was asking you already yeaterday.
I don't think SS_FORCE can play nicely with uc_stack and
you haven't clarified that part, so lets try again.

> Presumably we should continue to honor uc_stack in rt_sigreturn.
In this case, the above sigaltstack(set up new_sas) just
gets ignored. Are we allright with that? If so, I can code
up the patch. Whatever. :)

>    I'm
> less clear on whether we should have an implicit SS_FORCE when
> restoring uc_stack.
This is obscure and is likely outside of the scope of the
problem at hands.

>    I'm also not clear on why uc_stack exists in the
> first place.
>
> If I were designing this from scratch, I'd have signal delivery for a=
n
> SA_ONSTACK signal save away the altstack information and clear it so
> that nested signals work without checking sp during signal delivery.
How would you then evaluate oss->ss_flags?
