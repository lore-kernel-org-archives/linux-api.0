From: Ramana Radhakrishnan <ramana.gcc@googlemail.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and
 thread creation (v8)
Date: Tue, 23 Apr 2019 12:59:38 +0100
Message-ID: <CAJA7tRZDKHxLDzuggSmNngfxSTD31EX3mv6YQpcnNXrOtF=9qQ@mail.gmail.com>
References: <20190416173216.9028-1-mathieu.desnoyers@efficios.com>
 <1770787324.668.1555530989646.JavaMail.zimbra@efficios.com>
 <1066731871.915.1555593471194.JavaMail.zimbra@efficios.com>
 <6cbfea7b-9d83-74a5-9cd2-af56a5d68818@arm.com> <1055153722.1072.1555602067220.JavaMail.zimbra@efficios.com>
 <79996d13-2ba2-ed7d-b202-e7d38f1fd870@arm.com> <604915684.1299.1555607449814.JavaMail.zimbra@efficios.com>
 <846db7ef-f75e-53b8-3c4c-461ec730a17e@arm.com> <1531569198.1389.1555611422188.JavaMail.zimbra@efficios.com>
 <a1bd2595-b7ae-b06b-9c71-802901ed8587@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a1bd2595-b7ae-b06b-9c71-802901ed8587@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, nd <nd@arm.com>, Joseph Myers <joseph@codesourcery.com>, Will Deacon <Will.Deacon@arm.com>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 23, 2019 at 12:16 PM Szabolcs Nagy <Szabolcs.Nagy@arm.com> wrote:
>
> On 18/04/2019 19:17, Mathieu Desnoyers wrote:
> > ----- On Apr 18, 2019, at 1:37 PM, Szabolcs Nagy Szabolcs.Nagy@arm.com wrote:
> >> you have to add a documentation comment somewhere
> >> explaining if RSEQ_SIG is the value that's passed to
> >> the kernel and then aarch64 asm code has to use
> >>
> >> .inst endianfixup(RSEQ_SIG) // or
> >> .word RSEQ_SIG
> >
> > Using ".word" won't allow objdump to show the instruction it
> > maps to. It will consider it as data. So .inst is preferred here.
>
> is there some specific reason you prefer .inst?

I believe the reasoning here is that in the disassembly you want to
see an instruction pattern for an architecture rather than a magic bit
pattern that appears to be an "inline" literal pool entry.  I would
support the .inst variant so that the disassembler shows the
instruction for what it is when debugging. If control reaches the
marker instruction, something's gone wrong and thus from a user
friendliness perspective I would prefer to see an instruction that
clearly indicates that it's undefined .inst directive so that someone
disassembling this in an assembly view in GDB sees the right thing
(TM) instead of having to reach for the manual and disassembling this
by hand.

>
> disassembling a canary value as data (that is
> never executed, but loaded and compared by the
> kernel as data) sounds more semantically correct
> to me than showing it as an instruction.
>



Ramana


> i guess having it as an instruction can avoid
> issues if some tools dislike .word in .text,
> but otherwise .word seems better.
