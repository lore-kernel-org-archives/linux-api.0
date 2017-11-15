From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 00/24] Restartable sequences and CPU op
 vector v11
Date: Wed, 15 Nov 2017 06:34:20 +0000 (UTC)
Message-ID: <1752729538.15531.1510727660854.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <CA+55aFzZcQKEvu5S3TwD9MscqDhqq3pKa0Kam79NncjP8RnvoQ@mail.gmail.com> <CALCETrVMvk0dsBMF8F-gPZCGnfJt=RQOvTnVzJhVaAFhEFbq2w@mail.gmail.com> <2115146800.15215.1510695175687.JavaMail.zimbra@efficios.com> <CALCETrX4dzY_kyZmqR+srKZf7vVYzODH5i9bguFAzdm0dcU3ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrX4dzY_kyZmqR+srKZf7vVYzODH5i9bguFAzdm0dcU3ZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 14, 2017, at 11:12 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:

>> On Nov 14, 2017, at 1:32 PM, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> wrote:
>>
>> ----- On Nov 14, 2017, at 4:15 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:
>>
>>
>> One thing I kept however that diverge from your recommendation is the
>> "sign" parameter to the rseq syscall. I prefer this flexible
>> approach to a hardcoded signature value. We never know when we may
>> need to randomize or change this in the future.
>>
>> Regarding abort target signature the vs x86 disassemblers, I used a
>> 5-byte no-op on x86 32/64:
>>
>>  x86-32: nopl <sig>
>>  x86-64: nopl <sig>(%rip)
> 
> I still don't see how this can possibly work well with libraries.  If
> glibc or whatever issues the syscall and registers some signature,
> that signature *must* match the expectation of all libraries used in
> that thread or it's not going to work.

Here is how I envision this signature can eventually be randomized:

A librseq.so provided by glibc manages rseq thread registration. That
library could generate a random uint32_t value as signature for each
process within a constructor, as well as lazily upon first call to
signature query function (whichever comes first).

The constructors of every program/library using rseq would invoke
a signature getter function to query the random value, and iterate over
a section of pointers to signatures, and update those as part of the
constructors (temporarily mprotecting the pages as writeable).

Given that this would prevent page sharing across processes due to
CoW, I would not advise going for this randomized signature solution
unless necessary, but I think it's good to keep the door open to this
by keeping a uint32_t sig argument to sys_rseq.


> I can see two reasonable ways
> to handle it:
> 
> 1. The signature is just a well-known constant.  If you have an rseq
> abort landing site, you end up with something like:
> 
> nopl $11223344(%rip)
> landing_site:
> 
> or whatever the constant is.

If librseq.so passes a hardcoded constant to sys_rseq, then my solution
is very similar to this one, except that mine can allow randomized
signatures in the future for a kernel ABI perspective.


> 
> 2. The signature varies depending on the rseq_cs in use.  So you get:
> 
> static struct rseq_cs this_cs = {
>  .signature = 0x55667788;
>  ...
> };
> 
> and then the abort landing site has:
> 
> nopl $11223344(%rip)
> nopl $55667788(%rax)
> landing_site:

AFAIU, this solution defeats the purpose of having code signatures in the
in the first place. An attacker simply has to:

1) Craft a dummy struct rseq_cs on the stack, with:

struct rseq_cs {
  .signature = <whatever needs to be matched prior to the wanted program target>,
  .start_ip = 0x0,
  .len = -1UL,
  .abort_ip = <address of system() or such>,
}

2) Store the address of this dummy struct rseq_cs into __rseq_abi.rseq_cs.

3) Profit.

You should _never_ compare the signature in the code with an integer
value which can end up being controlled by the attacker.

Passing the signature to the system call upon registration leaves to the
kernel the job of keeping that signature around. An attacker would need
to first invoke sys_rseq to unregister the current __rseq_abi and re-register
with another signature in order to make this work. If an attacker has that
much access to control program execution and issue system calls at will,
then the game is already lost: they already control the execution flow,
so what's the point in trying to prevent branching to a specific address ?

> 
> The former is a bit easier to deal with.  The latter has the nice
> property that you can't subvert one rseq_cs to land somewhere else,
> but it's not clear to me how what actual attack this prevents, so I
> think I prefer #1.  I just think that your variant is asking for
> trouble down the road with incompatible userspace.

As described above, user-space can easily make the signature randomization
work by having all users patch code within constructors.

Thanks,

Mathieu


> 
> --Andy

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
