From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 22:46:12 +0300
Message-ID: <56AFB604.4010008@list.ru>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com> <20160201170958.GA20735@redhat.com>
 <56AF955D.7060601@list.ru> <20160201180443.GA21064@redhat.com>
 <56AFA0E2.1030302@list.ru> <20160201185223.GA21136@redhat.com>
 <56AFAB9D.4070007@list.ru> <20160201192936.GA21214@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160201192936.GA21214-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

01.02.2016 22:29, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 02/01, Stas Sergeev wrote:
>> 01.02.2016 21:52, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>> Stas, I probably missed something, but I don't understand your conc=
erns,
>>>
>>> On 02/01, Stas Sergeev wrote:
>>>> 01.02.2016 21:04, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>>> Yes, and SS_FORCE means "I know what I do", looks very simple.
>>>> But to me its not because I don't know what to do with
>>>> uc_stack after SS_FORCE is applied.
>>> Nothing? restore_sigaltstack() should work as expected?
>> That's likely the reason for EPERM: restore_sigaltstack()
>> does the job, so manual modifications are disallowed.
>> Allowing them will bring in the surprises where the changes
>> done by the user are ignored.
> Unlikely. Suppose you do sigalstack() and then a non SA_ONSTACK signa=
l handler
> runs and calls sigaltstack() again. This won't fail, but restore_siga=
ltstack()
> will restore the old alt stack after return.
OK.

> I too do not know why uc_stack exists, in fact I do not know about it=
 until
> today when I read your patch ;) But it is here, and I do not think SS=
_FORCE
> can add more confusion than we already have.
OK.

>>> Yes, or
>>>
>>> 	sigaltstack({ DISABLE | FORCE}, &old_ss);
>>> 	swapcontext();
>>> 	sigaltstack(&old_ss, NULL);
>>> 	rt_sigreturn();
>>>
>>> and if you are going to return from sighandler you do not even need=
 the 2nd
>>> sigaltstack(), you can rely on sigreturn.
>> Yes, that's what I do in my app already.
>> But its only there when SA_SIGINFO is used.
> Hmm. how this connects to SA_SIGINFO ?
AFAIK without SA_SIGINFO you get sigreturn instead of
rt_sigreturn, which doesn't seem to do restore_altstack().
Or am I wrong?

Hmm:

         /* Set up the stack frame */
         if (is_ia32_frame()) {
                 if (ksig->ka.sa.sa_flags & SA_SIGINFO)
                         return ia32_setup_rt_frame(usig, ksig, cset, r=
egs);
                 else
                         return ia32_setup_frame(usig, ksig, cset, regs=
);
         } else if (is_x32_frame()) {
                 return x32_setup_rt_frame(ksig, cset, regs);
         } else {
                 return __setup_rt_frame(ksig->sig, ksig, set, regs);
         }



>>>> What's at the end? Do we want a surprise for the user
>>>> that he's new_sas got ignored?
>>> Can't understand.... do you mean "set up new_sas" will be ignored b=
ecause
>>> rt_sigreturn() does restore_sigaltstack() ? I see no problem here..=
=2E
>> Allowing the modifications that were previously EPERMed
>> but will now be silently ignored, may be seen as a problem.
>> But if it isn't - fine, lets code that.
> Still can't understand. The 2nd sigaltstack() is no longer EPERMed be=
cause
> application used SS_FORCED before that and disabled altstack.
>
> And it is not ignored, it actually changes alt stack. Until we return=
 from
> handler.
Before we return, the signals are usually blocked.
So whatever is after return is most important.
