From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Thu, 22 Nov 2018 14:36:25 -0500 (EST)
Message-ID: <1705791029.10494.1542915385130.JavaMail.zimbra@efficios.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com> <87a7m1ywni.fsf@oldenburg.str.redhat.com> <20181122151710.GF23599@brightrain.aerifal.cx> <875zwpyw81.fsf@oldenburg.str.redhat.com> <1306224240.10055.1542900799576.JavaMail.zimbra@efficios.com> <7032ab45-8314-b85d-5b4d-f83b41dab5b6@arm.com> <1602745030.10426.1542911744479.JavaMail.zimbra@efficios.com> <20181122190143.GI23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181122190143.GI23599@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Florian Weimer <fweimer@redhat.com>, nd <nd@arm.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <Will.Deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2018, at 2:01 PM, Rich Felker dalias@libc.org wrote:

> On Thu, Nov 22, 2018 at 01:35:44PM -0500, Mathieu Desnoyers wrote:
>> ----- On Nov 22, 2018, at 11:24 AM, Szabolcs Nagy Szabolcs.Nagy@arm.com wrote:
>> 
>> > On 22/11/18 15:33, Mathieu Desnoyers wrote:
>> >> ----- On Nov 22, 2018, at 10:21 AM, Florian Weimer fweimer@redhat.com wrote:
>> >>> Right, but in case of user-supplied stacks, we actually free TLS memory
>> >>> at this point, so signals need to be blocked because the TCB is
>> >>> (partially) gone after that.
>> >> 
>> >> Unfortuntately, disabling signals is not enough.
>> >> 
>> >> With rseq registered, the kernel accesses the rseq TLS area when returning to
>> >> user-space after _preemption_ of user-space, which can be triggered at any
>> >> point by an interrupt or a fault, even if signals are blocked.
>> >> 
>> >> So if there are cases where the TLS memory is freed while the thread is still
>> >> running, we _need_ to explicitly unregister rseq beforehand.
>> > 
>> > i think the man page should point this out.
>> 
>> Yes, I should add this to the proposed rseq(2) man page.
>> 
>> > 
>> > the memory of a registered rseq object must not be freed
>> > before thread exit. (either unregister it or free later)
>> > 
>> > and ideally also point out that c language thread storage
>> > duration does not provide this guarantee: it may be freed
>> > by the implementation before thread exit (which is currently
>> > not observable, but with the rseq syscall it is).
>> 
>> How about the following wording ?
>> 
>>   Memory of a registered rseq object must not be freed before the
>>   thread exits. Reclaim of rseq object's memory must only be
>>   done after either an explicit rseq unregistration is performed
>>   or after the thread exit. Keep in mind that the implementation
>>   of the Thread-Local Storage (C language __thread) lifetime does
>>   not guarantee existence of the TLS area up until the thread exits.
> 
> This is all really ugly for application/library code to have to deal
> with. Maybe if the man page is considered as documenting the syscall
> only, and not something you can use, it's okay,

This is indeed for the rseq(2) manpage targeting the man-pages project,
which documents system calls.

> but "until the thread
> exits" is not well-defined in the sense you want it here. It's more
> like "until the kernel task for the thread exits", and the whole point
> is that there is some interval in time between the abstract thread
> exit and the kernel task exit that is not observable without rseq but
> is observable if the rseq is wrongly left installed.

It's important to clear a possible misunderstanding here: from the
point where the thread issues the "exit" system call, the kernel won't
touch the registered rseq TLS area anymore.

So the point where the thread exits is actually well defined, even from
a user-space perspective.

The problematic scenario arises when glibc frees the TLS memory
before invoking exit() when the thread terminates. In this kind of
scenario, we need to explicitly invoke rseq unregister before TLS
memory reclaim.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
