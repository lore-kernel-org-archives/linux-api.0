From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.16 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Fri, 15 Dec 2017 16:52:22 +0000 (UTC)
Message-ID: <729438855.35910.1513356742518.JavaMail.zimbra@efficios.com>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1712141033100.6249@nuc-kabylake> <12046460.34426.1513275177081.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1712141238180.8340@nuc-kabylake> <1537392285.34532.1513279478488.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1712141512360.8945@nuc-kabylake> <20171214212023.GJ3326@worktop> <alpine.DEB.2.20.1712150903490.14235@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1712150903490.14235@nuc-kabylake>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Dec 15, 2017, at 10:05 AM, Chris Lameter cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org wrote:

> On Thu, 14 Dec 2017, Peter Zijlstra wrote:
> 
>> > But my company has extensive user space code that maintains a lot of
>> > counters and does other tricks to get full performance out of the
>> > hardware. Such a mechanism would also be good from user space. Why keep
>> > the good stuff only inside the kernel?
>>
>> Mathieu's proposal is for userspace, _only_ userspace.
> 
> But what we were talking about are instructions that work effectively in
> kernel space whose efficiency restartable sequences could bring to user
> space.

It can be worthwhile to recap my understanding of this thread so far:

AFAIU, Chris' proposal is to use the "gs" segment selector as instruction
prefix on x86 rather than explicitly loading CPU number and calculating
offsets.

This can turn sequences of rseq operations like this cmpxchg:

Registers:

  R1: return value
  R2: expected value
  R3: new value
  R4: cpu_id

rseq cmpxchg:

  load TLS::cpu_id_start into R4
  calculate offset of v
  fs:mov (store rseq descriptor address into TLS::rseq_cs)
  compare R4 against TLS::cpu_id
  jne abort
  mov (load v into R1)
  compare R1 against R2
  jne cmpfail
  mov (store R3 into *v)

into:

  fs:mov (store rseq descriptor address into TLS::rseq_cs)
  gs:mov (load *v+off into R1)
  compare R1 against R2
  jne cmpfail
  gs:mov (store R3 into *v+off)

My first concern with this approach is the lack of flexibility of the segment
selector method wrt variety of schemes user-space has to deal with for memory
allocation. In the kernel, this is achieved by ensuring that all per-cpu data
layout is segment-selector-prefix friendly.

Another aspect that worries me is applications using the gs segment selector
for other purposes. Suddenly reserving the gs segment selector for use by a
library like glibc may lead to incompatibilities with applications already
using it.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
