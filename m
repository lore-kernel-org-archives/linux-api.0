From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC filtering
Date: Fri, 3 Oct 2014 13:53:24 -0700
Message-ID: <CALCETrXrcBDOq0zBkgtNDfD1qjhq4rcXR1Txta8KksREZeQg0g@mail.gmail.com>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com> <20141003204256.GO10583@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141003204256.GO10583@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 3, 2014 at 1:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Oct 03, 2014 at 01:22:22PM -0700, Andy Lutomirski wrote:
>> > So the problem with the default deny is that its:
>> >  1) pointless -- the attacker can do sys_perf_event_open() just fine;
>>
>> Not if the attacker is in a seccomp sandbox.
>
> Clearly :-)
>
>> >  2) and expensive -- the people trying to measure performance get the
>> >     penalty of the CR4 write.
>>
>> Does this matter for performance measuring?  I'm not 100% clear on how all
>> the perf_event stuff gets used in practice, but, by my very vague
>> understanding, there are two main workflows:
>>
>> a) perf record, etc: one process creates a ringbuffer and wakes up
>> rarely to record the contents.  The process being recorded doesn't
>> have a perf_event mapped, so the cr4 switch will only happen when
>> waking up the perf process.
>>
>> perf record prints stuff like "[ perf record: Woken up 1 times to
>> write data ]", which seems to confirm my understanding.
>>
>> b) self-monitoring.  A task mmaps a perf_event, does rdpmc, does
>> something, and does rdpmc again.  In that case, there's no context
>> switch.
>
> Agreed, but with the default disable, the self-monitoring task will get
> CR4 writes to its context switches and will be slower.
>
> Whereas if we default on and only disable with seccomp then only the
> seccomp tasks will suffer the burden of a CR4 write at context switch
> time.
>
> And I don't see a security implication in the default.

I don't see a security implication, but we can fight over whether
seccomp performance or perf self monitoring performance is more
important.  I spent a bunch of time making seccomp *much* faster for
3.18, and things like Chromium (the browser) could have lots of
context switched into and out of seccomp. :)

I suspect that the overhead only really matters when running as a VM guest.

Hmm.  Can we switch lazily?  I don't really like the idea, but
non-seccomp, non-perf-event tasks could, in principle, just inherit
the PCE value from whatever had the CPU last.

>
>> > So I would suggest a default on, but allow a disable for the seccomp
>> > users, which might have also disabled the syscall. Note that is is
>> > possible to disable RDPMC while still allowing the syscall.
>>
>> Disabling RDPMC per-process while still allowing the syscall will need
>> a bunch of work, right?
>
> Not much, all you need to do is make
> perf_event_mmmap_page::cap_user_rdpmc be 0 and userspace should never
> use rdpmc. Currently we set that bit based on the global sysfs rdpmc
> value, but we could easy bitwise AND it with a per process value.
>
>> What happens if the same perf_event is mapped
>> by two different users?
>
> Not entirely clear on what you mean here.

Can you open a perf_event fd, fork, and mmap it in the child?  What if
you map it in the parent and the child?  Then cap_user_rdpmc has to
match for both mappings.  Or is this impossible?

>
>> We could make the rule be that RDPMC is enabled if a perf event is
>> mmapped or TIF_SECCOMP is clear, but I'd prefer to be convinced that
>> there's an actual performance issue first.  Ideally we can get this
>> all working with no API or ABI change at all.
>
> Well I just want to not have extra CR4 writes by default (and by default
> I don't care about seccomp).
>
>> P.S. Hey, Intel, let us context switch RDPMC accessibility of the
>> individual counters, please :)
>
> Ha sure, make it more complicated why don't you ;-) But yes, that has
> come up before.

--Andy
