From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: futex(2) man page update help request
Date: Wed, 14 May 2014 17:35:46 -0700
Message-ID: <CALCETrXzMiS9DwvmZn++wg0x6v-ZR0YP9fAdco4PRST=nTY4nQ@mail.gmail.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <1400100977.3865.30.camel@buesod1.americas.hpqcorp.net> <53740A30.20807@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53740A30.20807@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 14, 2014 at 5:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/14/2014 01:56 PM, Davidlohr Bueso wrote:
>>>
>>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>>> removed the futex() call entirely, so these man pages don't describe
>>>
>>> I don't think futex() ever was in glibc--that's by design, and
>>> completely understandable: no user-space application would want to
>>> directly use futex().
>>
>> That's actually not quite true. There are plenty of software efforts out
>> there that use futex calls directly to implement userspace serialization
>> mechanisms as an alternative to the bulky sysv semaphores. I worked
>> closely with an in-memory DB project that makes heavy use of them. Not
>> everyone can simply rely on pthreads.
>>
>
> More fundamentally, futex(2), like clone(2), are things that can be
> legitimately by user space without automatically breaking all of glibc.

I'm lost -- I think the missing verb is important :)

>  There are some other things where that is *not* true, because glibc
> relies on being able to mediate all accesses to a kernel facility, but
> not here.

--Andy
