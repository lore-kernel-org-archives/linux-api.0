From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical sections
Date: Tue, 26 May 2015 14:18:32 -0700
Message-ID: <CALCETrXXtu1BNqQopd5eCfa6wE9O+001ofhjjsXUe2f9K_hj8g@mail.gmail.com>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com>
 <757752240.6470.1432330487312.JavaMail.zimbra@efficios.com>
 <CALCETrUxp-dP-kaTy4prEdciM-=sTXjpqnMbkvk38g5BTEvX0g@mail.gmail.com>
 <1839774559.6579.1432400944032.JavaMail.zimbra@efficios.com>
 <CALCETrWzoFX7hXqvQqDEq=r=7PNaGKVjZeHEBWxPvC28Zi1AKA@mail.gmail.com>
 <1184354091.7499.1432578613872.JavaMail.zimbra@efficios.com>
 <CALCETrW3_Hv0jc3cpiwsHTinBqJzvab_EiPS8BVJhX-xe5D8qw@mail.gmail.com>
 <CALCETrXzmO=fQC=UdCh5b0zWiGWAJScEtdT4QDJkoqLgtgEVig@mail.gmail.com> <821493560.8531.1432674243321.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <821493560.8531.1432674243321.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 26, 2015 at 2:04 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> ----- Original Message -----
>> On May 25, 2015 11:54 AM, "Andy Lutomirski" <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> [...]
>> I might be guilty of being too x86-centric here.  On x86, as long as
>> the lock and unlock primitives are sufficiently atomic, everything
>> should be okay.  On other architectures, though, a primitive that
>> gives lock, unlock, and abort of a per-cpu lock without checking that
>> you're still on the right cpu at unlock time may not be sufficient.
>> If the primitive is implemented purely with loads and stores, then
>> even if you take the lock, migrate, finish your work, and unlock
>> without anyone else contending from the lock (and hence don't abort),
>> the next thread to take the same lock will end up unsynchronized
>> unless there's appropriate memory ordering.  For example, if taking
>> the lock were an acquire and unlocking were a release, we'd be fine.
>
> If we look at x86-TSO, where stores reordered after loads is pretty
> much the only thing we need to care about, we have:
>
>   CPU 0                               CPU 1
>
>                                       load, test lock[1]
>                                       store lock[1]
>                                       loads/stores to data[1]
>                                       [preempted, migrate to cpu 0]
>                                       [run other thread]
>                                       load, test lock[1] (loop)
>   loads/stores to data[1] (A)
>   store 0 to lock[1]      (B)
>                                       load, test lock[1]      (C)
>                                       store lock[1]
>                                       loads/stores to data[1] (D)
>
> What we want to ensure is that load/stores to data[1] from CPU 0 and
> 1 don't get interleaved.
>
> On CPU 0 doing unlock, loads and stores to data[1] (A) cannot be reordered
> against the store to lock[1] (B) due to TSO (all we care about is stores
> reordered after loads).
>
> On CPU 1 grabbing the 2nd lock, we care about loads/store from/to
> data[1] (C) being reordered before load, test of lock[1] (C). Again,
> thanks to TSO, loads/stores from/to data[1] (D) cannot be reordered
> wrt (C).
>
> So on x86-TSO we should be OK, but as you say, we need to be careful
> to have the right barriers in place on other architectures.
>
>>
>> Your RFC design certainly works (in principle -- I haven't looked at
>> the code in detail), but I can't shake the feeling that it's overkill
>
> If we can find a simpler way to achieve the same result, I'm all ears :)
>
>> and that it could be improved to avoid unnecessary aborts every time
>> the lock holder is scheduled out.
>
> The restart is only performed if preemption occurs when the thread is
> trying to grab the lock. Once the thread has the lock (it's now the
> lock holder), it will not be aborted even if it is migrated.

Then maybe this does have the same acquire/release issue after all.

>
>>
>> This isn't a problem in your RFC design, but if we wanted to come up
>> with tighter primitives, we'd have to be quite careful to document
>> exactly what memory ordering guarantees they come with.
>
> Indeed.
>
>>
>> It may be that all architectures for which you care about the
>> performance boost already have efficient acquire and release
>> operations.  Certainly x86 does, and I don't know how fast the new ARM
>> instructions are, but I imagine they're pretty good.
>
> We may even need memory barriers around lock and unlock on ARM. :/ ARM
> smp_store_release() and smp_load_acquire() currently implements those with
> smp_mb().

I would have expected it to use LDA/STL on new enough cpus:

http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0802a/CIHDEACA.html


>
>>
>> It's too bad that not all architectures have a single-instruction
>> unlocked compare-and-exchange.
>
> Based on my benchmarks, it's not clear that single-instruction
> unlocked CAS is actually faster than doing the same with many
> instructions.

True, but with a single instruction the user can't get preempted in the middle.

Looking at your code, it looks like percpu_user_sched_in has some
potentially nasty issues with page faults.  Avoiding touching user
memory from the scheduler would be quite nice from an implementation
POV, and the x86-specific gs hack wins in that regard.

--Andy
