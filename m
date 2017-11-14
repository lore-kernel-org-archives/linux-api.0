From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 00/24] Restartable sequences and CPU op
 vector v11
Date: Tue, 14 Nov 2017 21:32:55 +0000 (UTC)
Message-ID: <2115146800.15215.1510695175687.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <CA+55aFzZcQKEvu5S3TwD9MscqDhqq3pKa0Kam79NncjP8RnvoQ@mail.gmail.com> <CALCETrVMvk0dsBMF8F-gPZCGnfJt=RQOvTnVzJhVaAFhEFbq2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVMvk0dsBMF8F-gPZCGnfJt=RQOvTnVzJhVaAFhEFbq2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 14, 2017, at 4:15 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:

> On Tue, Nov 14, 2017 at 1:08 PM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>> On Tue, Nov 14, 2017 at 12:03 PM, Mathieu Desnoyers
>> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>>> Here is the last RFC round of the updated rseq patchset containing:
>>
>> Andy? You were the one with concerns here and said you'd have
>> something else ready for comparison.
>>
> 
> I had a long discussion with Mathieu and KS and I think that this is a
> good compromise.  I haven't reviewed the series all that carefully,
> but I think the idea is sound.
> 
> Basically, event_counter is gone (to be re-added in a later kernel if
> it really ends up being necessary, but it looks like it may primarily
> be a temptation to write subtly incorrect user code and to see
> scheduling details that shouldn't be readily exposed rather than a
> genuinely useful feature) and the versioning mechanism for the asm
> critical section bit is improved.  My crazy proposal should be doable
> on top of this if there's demand and if anyone wants to write the
> gnarly code involved.
> 
> IOW no objection from me as long as those changes were made, which I
> *think* they were.  Mathieu?

Yes, I applied all your suggestions.

The major change was removal of the event_counter. I did improve the
user-space side of things significantly, both in terms of speed, and
reduced complexity, as the rseq and cpu_opv C code is now very much
alike. We could even have a library header macro that would ensure both
fast and slow paths are the same.

I added the version field to struct rseq_cs. Along with the "rseq_len"
parameter to sys_rseq for the struct rseq, we should be good to handle
future extensions.

One thing I kept however that diverge from your recommendation is the
"sign" parameter to the rseq syscall. I prefer this flexible
approach to a hardcoded signature value. We never know when we may
need to randomize or change this in the future.

Regarding abort target signature the vs x86 disassemblers, I used a
5-byte no-op on x86 32/64:

  x86-32: nopl <sig>
  x86-64: nopl <sig>(%rip)

Other architectures (e.g. arm32, powerpc 32/64) with fixed-size instruction
set don't need this kind of trick to make disassemblers happy. Actually,
it is common practice on e.g. arm 32 to put literal values after branch
instructions so they are close to the load instruction.

Those were all the action items I had gathered following our discussion
at KS. Let me know if I'm missing anything.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
