From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/4] signals/sigaltstack: If SS_AUTODISARM, bypass on_sig_stack
Date: Sat, 14 May 2016 09:35:41 -0700
Message-ID: <CALCETrXXL_cYiTXGAQtGDFx7Kb6psbEo53Y=M62ekn93Xzv=yA@mail.gmail.com>
References: <cover.1462296606.git.luto@kernel.org> <c46bee4654ca9e68c498462fd11746e2bd0d98c8.1462296606.git.luto@kernel.org>
 <0081b876-033b-4fb7-3daf-d38b2df1fda6@list.ru> <CALCETrX4AMCUkYMXe6-RoHTHQ=bpunM5keHSxMg=fEVtb1EmqA@mail.gmail.com>
 <97f8e27a-019c-a5d4-2d2c-c2a9627cf23d@list.ru> <CALCETrV+gmXn-kTJmKBDPM8HaRTcvp+eGmeF7mOES6bCje2AGQ@mail.gmail.com>
 <a8043a6e-764f-1fb1-d580-e21696260b94@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a8043a6e-764f-1fb1-d580-e21696260b94@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Stas Sergeev <stsp@list.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuahkh@osg.samsung.com>, Pavel Emelyanov <xemul@parallels.com>, X86 ML <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Jason Low <jason.low2@hp.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Josh Triplett <josh@joshtriplett.org>, Aleksa Sarai <cyphar@cyphar.com>, Paul Moore <pmoore@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sasha Levin <sasha.levin@oracle.com>, Denys Vlasenko <dvlasenk@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Amanieu d'Antras <amanieu@gmail.com>, Borislav Petkov <bp@alien8.de>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Tejun Heo <tj@kernel.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Palmer Dabbelt <palmer@dab>
List-Id: linux-api@vger.kernel.org

On May 14, 2016 4:18 AM, "Stas Sergeev" <stsp@list.ru> wrote:
>
> 14.05.2016 07:18, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>
>> On May 8, 2016 7:05 PM, "Stas Sergeev" <stsp@list.ru> wrote:
>>>
>>> 09.05.2016 04:32, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>
>>>> On May 7, 2016 7:38 AM, "Stas Sergeev" <stsp@list.ru> wrote:
>>>>>
>>>>> 03.05.2016 20:31, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>>>
>>>>>> If a signal stack is set up with SS_AUTODISARM, then the kernel
>>>>>> inherently avoids incorrectly resetting the signal stack if sign=
als
>>>>>> recurse: the signal stack will be reset on the first signal
>>>>>> delivery.  This means that we don't need check the stack pointer
>>>>>> when delivering signals if SS_AUTODISARM is set.
>>>>>>
>>>>>> This will make segmented x86 programs more robust: currently the=
re's
>>>>>> a hole that could be triggered if ESP/RSP appears to point to th=
e
>>>>>> signal stack but actually doesn't due to a nonzero SS base.
>>>>>>
>>>>>> Signed-off-by: Stas Sergeev <stsp@list.ru>
>>>>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>>>>>> Cc: Aleksa Sarai <cyphar@cyphar.com>
>>>>>> Cc: Amanieu d'Antras <amanieu@gmail.com>
>>>>>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>>>>> Cc: Borislav Petkov <bp@alien8.de>
>>>>>> Cc: Brian Gerst <brgerst@gmail.com>
>>>>>> Cc: Denys Vlasenko <dvlasenk@redhat.com>
>>>>>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>>>>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>>>>> Cc: H. Peter Anvin <hpa@zytor.com>
>>>>>> Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
>>>>>> Cc: Jason Low <jason.low2@hp.com>
>>>>>> Cc: Josh Triplett <josh@joshtriplett.org>
>>>>>> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>>>>>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>>>>> Cc: Oleg Nesterov <oleg@redhat.com>
>>>>>> Cc: Palmer Dabbelt <palmer@dabbelt.com>
>>>>>> Cc: Paul Moore <pmoore@redhat.com>
>>>>>> Cc: Pavel Emelyanov <xemul@parallels.com>
>>>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>>>> Cc: Richard Weinberger <richard@nod.at>
>>>>>> Cc: Sasha Levin <sasha.levin@oracle.com>
>>>>>> Cc: Shuah Khan <shuahkh@osg.samsung.com>
>>>>>> Cc: Tejun Heo <tj@kernel.org>
>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>>> Cc: Vladimir Davydov <vdavydov@parallels.com>
>>>>>> Cc: linux-api@vger.kernel.org
>>>>>> Cc: linux-kernel@vger.kernel.org
>>>>>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>>>>> ---
>>>>>>     include/linux/sched.h | 12 ++++++++++++
>>>>>>     1 file changed, 12 insertions(+)
>>>>>>
>>>>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>>>>> index 2950c5cd3005..8f03a93348b9 100644
>>>>>> --- a/include/linux/sched.h
>>>>>> +++ b/include/linux/sched.h
>>>>>> @@ -2576,6 +2576,18 @@ static inline int kill_cad_pid(int sig, i=
nt priv)
>>>>>>      */
>>>>>>     static inline int on_sig_stack(unsigned long sp)
>>>>>>     {
>>>>>> +       /*
>>>>>> +        * If the signal stack is AUTODISARM then, by constructi=
on, we
>>>>>> +        * can't be on the signal stack unless user code deliber=
ately set
>>>>>> +        * SS_AUTODISARM when we were already on the it.
>>>>>
>>>>> "on the it" -> "on it".
>>>>>
>>>>> Anyway, I am a bit puzzled with this patch.
>>>>> You say "unless user code deliberately set
>>>>>
>>>>> SS_AUTODISARM when we were already on the it"
>>>>> so what happens in case it actually does?
>>>>>
>>>> Stack corruption.  Don't do that.
>>>
>>> Only after your change, I have to admit. :)
>>>
>>>
>>>>> Without your patch: if user sets up the same sas - no stack switc=
h.
>>>>> if user sets up different sas - stack switch on nested signal.
>>>>>
>>>>> With your patch: stack switch in any case, so if user
>>>>> set up same sas - stack corruption by nested signal.
>>>>>
>>>>> Or am I missing the intention?
>>>>
>>>> The intention is to make everything completely explicit.  With
>>>> SS_AUTODISARM, the kernel knows directly whether you're on the sig=
nal
>>>> stack, and there should be no need to look at sp.  If you set
>>>> SS_AUTODISARM and get a signal, the signal stack gets disarmed.  I=
f
>>>> you take a nested signal, it's delivered normally.  When you retur=
n
>>>> all the way out, the signal stack is re-armed.
>>>>
>>>> For DOSEMU, this means that no 16-bit register state can possibly
>>>> cause a signal to be delivered wrong, because the register state w=
hen
>>>> a signal is raised won't affect delivery, which seems like a good
>>>> thing to me.
>>>
>>> Yes, but doesn't affect dosemu1 which doesn't use SS_AUTODISARM.
>>> So IMHO the SS check should still be added, even if not for dosemu2=
=2E
>>>
>>>
>>>> If this behavior would be problematic for you, can you explain why=
?
>>>
>>> Only theoretically: if someone sets SS_AUTODISARM inside a
>>> sighandler. Since this doesn't give EPERM, I wouldn't deliberately
>>> make it a broken scenario (esp if it wasn't before the particular c=
hange).
>>> Ideally it would give EPERM, but we can't, so doesn't matter much.
>>> I just wanted to warn about the possible regression.
>>
>> I suppose we could return an error if you are on the sigstack when
>> setting SS_AUTODISARM, although I was hoping to avoid yet more speci=
al
>> cases.
>
> Hmm.
> How about extending the generic check then?
> Currently it is roughly:
> if (on_sig_stack(sp)) return -EPERM;
>
> and we could do:
> if (on_sig_stack(sp) || on_new_sas(new_sas, sp)) return -EPERM;
>
> Looks like it will close the potential hole opened by your commit
> without introducing the special case for SS_AUTODISARM.
> What do you think?
>

It's still a wee bit ugly.  Also, doesn't that change existing
behavior for the existing non-AUTODISARM case?  Also, we'd have to
make sure that sigreturn doesn't trigger this check.

My inclination would be leave it alone.
