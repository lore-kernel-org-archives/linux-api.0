From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 1/4] signals/sigaltstack: If SS_AUTODISARM, bypass
 on_sig_stack
Date: Sat, 14 May 2016 14:18:14 +0300
Message-ID: <a8043a6e-764f-1fb1-d580-e21696260b94@list.ru>
References: <cover.1462296606.git.luto@kernel.org>
 <c46bee4654ca9e68c498462fd11746e2bd0d98c8.1462296606.git.luto@kernel.org>
 <0081b876-033b-4fb7-3daf-d38b2df1fda6@list.ru>
 <CALCETrX4AMCUkYMXe6-RoHTHQ=bpunM5keHSxMg=fEVtb1EmqA@mail.gmail.com>
 <97f8e27a-019c-a5d4-2d2c-c2a9627cf23d@list.ru>
 <CALCETrV+gmXn-kTJmKBDPM8HaRTcvp+eGmeF7mOES6bCje2AGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrV+gmXn-kTJmKBDPM8HaRTcvp+eGmeF7mOES6bCje2AGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrea Arcangeli <aarcange@r>
List-Id: linux-api@vger.kernel.org

14.05.2016 07:18, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On May 8, 2016 7:05 PM, "Stas Sergeev" <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>> 09.05.2016 04:32, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>
>>> On May 7, 2016 7:38 AM, "Stas Sergeev" <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>>>> 03.05.2016 20:31, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>>
>>>>> If a signal stack is set up with SS_AUTODISARM, then the kernel
>>>>> inherently avoids incorrectly resetting the signal stack if signa=
ls
>>>>> recurse: the signal stack will be reset on the first signal
>>>>> delivery.  This means that we don't need check the stack pointer
>>>>> when delivering signals if SS_AUTODISARM is set.
>>>>>
>>>>> This will make segmented x86 programs more robust: currently ther=
e's
>>>>> a hole that could be triggered if ESP/RSP appears to point to the
>>>>> signal stack but actually doesn't due to a nonzero SS base.
>>>>>
>>>>> Signed-off-by: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
>>>>> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
>>>>> Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
>>>>> Cc: Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>>>> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>>>>> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
>>>>> Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>> Cc: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>>>>> Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
>>>>> Cc: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
>>>>> Cc: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
>>>>> Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
>>>>> Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
>>>>> Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>>>> Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>> Cc: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
>>>>> Cc: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>> Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>>>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>>>>> Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
>>>>> Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>>>> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>>> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>>>>> Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>>>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>>> ---
>>>>>     include/linux/sched.h | 12 ++++++++++++
>>>>>     1 file changed, 12 insertions(+)
>>>>>
>>>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>>>> index 2950c5cd3005..8f03a93348b9 100644
>>>>> --- a/include/linux/sched.h
>>>>> +++ b/include/linux/sched.h
>>>>> @@ -2576,6 +2576,18 @@ static inline int kill_cad_pid(int sig, in=
t priv)
>>>>>      */
>>>>>     static inline int on_sig_stack(unsigned long sp)
>>>>>     {
>>>>> +       /*
>>>>> +        * If the signal stack is AUTODISARM then, by constructio=
n, we
>>>>> +        * can't be on the signal stack unless user code delibera=
tely set
>>>>> +        * SS_AUTODISARM when we were already on the it.
>>>> "on the it" -> "on it".
>>>>
>>>> Anyway, I am a bit puzzled with this patch.
>>>> You say "unless user code deliberately set
>>>>
>>>> SS_AUTODISARM when we were already on the it"
>>>> so what happens in case it actually does?
>>>>
>>> Stack corruption.  Don't do that.
>> Only after your change, I have to admit. :)
>>
>>
>>>> Without your patch: if user sets up the same sas - no stack switch=
=2E
>>>> if user sets up different sas - stack switch on nested signal.
>>>>
>>>> With your patch: stack switch in any case, so if user
>>>> set up same sas - stack corruption by nested signal.
>>>>
>>>> Or am I missing the intention?
>>> The intention is to make everything completely explicit.  With
>>> SS_AUTODISARM, the kernel knows directly whether you're on the sign=
al
>>> stack, and there should be no need to look at sp.  If you set
>>> SS_AUTODISARM and get a signal, the signal stack gets disarmed.  If
>>> you take a nested signal, it's delivered normally.  When you return
>>> all the way out, the signal stack is re-armed.
>>>
>>> For DOSEMU, this means that no 16-bit register state can possibly
>>> cause a signal to be delivered wrong, because the register state wh=
en
>>> a signal is raised won't affect delivery, which seems like a good
>>> thing to me.
>> Yes, but doesn't affect dosemu1 which doesn't use SS_AUTODISARM.
>> So IMHO the SS check should still be added, even if not for dosemu2.
>>
>>
>>> If this behavior would be problematic for you, can you explain why?
>> Only theoretically: if someone sets SS_AUTODISARM inside a
>> sighandler. Since this doesn't give EPERM, I wouldn't deliberately
>> make it a broken scenario (esp if it wasn't before the particular ch=
ange).
>> Ideally it would give EPERM, but we can't, so doesn't matter much.
>> I just wanted to warn about the possible regression.
> I suppose we could return an error if you are on the sigstack when
> setting SS_AUTODISARM, although I was hoping to avoid yet more specia=
l
> cases.
Hmm.
How about extending the generic check then?
Currently it is roughly:
if (on_sig_stack(sp)) return -EPERM;

and we could do:
if (on_sig_stack(sp) || on_new_sas(new_sas, sp)) return -EPERM;

Looks like it will close the potential hole opened by your commit
without introducing the special case for SS_AUTODISARM.
What do you think?
