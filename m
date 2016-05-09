From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/4] signals/sigaltstack: If SS_AUTODISARM, bypass on_sig_stack
Date: Sun, 8 May 2016 18:32:46 -0700
Message-ID: <CALCETrX4AMCUkYMXe6-RoHTHQ=bpunM5keHSxMg=fEVtb1EmqA@mail.gmail.com>
References: <cover.1462296606.git.luto@kernel.org> <c46bee4654ca9e68c498462fd11746e2bd0d98c8.1462296606.git.luto@kernel.org>
 <0081b876-033b-4fb7-3daf-d38b2df1fda6@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0081b876-033b-4fb7-3daf-d38b2df1fda6@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Stas Sergeev <stsp@list.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuahkh@osg.samsung.com>, Pavel Emelyanov <xemul@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, Jason Low <jason.low2@hp.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Josh Triplett <josh@joshtriplett.org>, Aleksa Sarai <cyphar@cyphar.com>, Paul Moore <pmoore@redhat.com>, X86 ML <x86@kernel.org>, Sasha Levin <sasha.levin@oracle.com>, Denys Vlasenko <dvlasenk@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Amanieu d'Antras <amanieu@gmail.com>, Borislav Petkov <bp@alien8.de>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Tejun Heo <tj@kernel.org>, Brian Gerst <brgerst@gmail.com>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Palmer Dabbelt <palmer@dabbelt.com>, Frederic Weisbecker <fweisbec@gmail.com>, Andrea
List-Id: linux-api@vger.kernel.org

On May 7, 2016 7:38 AM, "Stas Sergeev" <stsp@list.ru> wrote:
>
> 03.05.2016 20:31, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>
>> If a signal stack is set up with SS_AUTODISARM, then the kernel
>> inherently avoids incorrectly resetting the signal stack if signals
>> recurse: the signal stack will be reset on the first signal
>> delivery.  This means that we don't need check the stack pointer
>> when delivering signals if SS_AUTODISARM is set.
>>
>> This will make segmented x86 programs more robust: currently there's
>> a hole that could be triggered if ESP/RSP appears to point to the
>> signal stack but actually doesn't due to a nonzero SS base.
>>
>> Signed-off-by: Stas Sergeev <stsp@list.ru>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Aleksa Sarai <cyphar@cyphar.com>
>> Cc: Amanieu d'Antras <amanieu@gmail.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Brian Gerst <brgerst@gmail.com>
>> Cc: Denys Vlasenko <dvlasenk@redhat.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
>> Cc: Jason Low <jason.low2@hp.com>
>> Cc: Josh Triplett <josh@joshtriplett.org>
>> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: Palmer Dabbelt <palmer@dabbelt.com>
>> Cc: Paul Moore <pmoore@redhat.com>
>> Cc: Pavel Emelyanov <xemul@parallels.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Richard Weinberger <richard@nod.at>
>> Cc: Sasha Levin <sasha.levin@oracle.com>
>> Cc: Shuah Khan <shuahkh@osg.samsung.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Vladimir Davydov <vdavydov@parallels.com>
>> Cc: linux-api@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>>   include/linux/sched.h | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 2950c5cd3005..8f03a93348b9 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -2576,6 +2576,18 @@ static inline int kill_cad_pid(int sig, int p=
riv)
>>    */
>>   static inline int on_sig_stack(unsigned long sp)
>>   {
>> +       /*
>> +        * If the signal stack is AUTODISARM then, by construction, =
we
>> +        * can't be on the signal stack unless user code deliberatel=
y set
>> +        * SS_AUTODISARM when we were already on the it.
>
> "on the it" -> "on it".
>
> Anyway, I am a bit puzzled with this patch.
> You say "unless user code deliberately set
>
> SS_AUTODISARM when we were already on the it"
> so what happens in case it actually does?
>

Stack corruption.  Don't do that.

> Without your patch: if user sets up the same sas - no stack switch.
> if user sets up different sas - stack switch on nested signal.
>
> With your patch: stack switch in any case, so if user
> set up same sas - stack corruption by nested signal.
>
> Or am I missing the intention?

The intention is to make everything completely explicit.  With
SS_AUTODISARM, the kernel knows directly whether you're on the signal
stack, and there should be no need to look at sp.  If you set
SS_AUTODISARM and get a signal, the signal stack gets disarmed.  If
you take a nested signal, it's delivered normally.  When you return
all the way out, the signal stack is re-armed.

=46or DOSEMU, this means that no 16-bit register state can possibly
cause a signal to be delivered wrong, because the register state when
a signal is raised won't affect delivery, which seems like a good
thing to me.

If this behavior would be problematic for you, can you explain why?
