From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup and thread creation (v7)
Date: Tue, 09 Apr 2019 14:23:53 +1000
Message-ID: <877ec3yffq.fsf@concordia.ellerman.id.au>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com> <20190212194253.1951-2-mathieu.desnoyers@efficios.com> <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com> <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com> <87lg0tosfz.fsf@concordia.ellerman.id.au> <87pnq4zxyj.fsf@oldenburg2.str.redhat.com> <ce6f9db3-bf85-7aec-4bae-998e6fd629e1@redhat.com> <87y34o4xt3.fsf@oldenburg2.str.redhat.com> <43f97ddb-c8df-27ea-9517-63252ebd3183@redhat.com> <877ec4pam2.fsf@linux.ibm.com> <ce9fbc66-5eb9-0fa9-99fa-5abfe00ddfc2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ce9fbc66-5eb9-0fa9-99fa-5abfe00ddfc2@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <codonell@redhat.com>, Tulio Magno Quites Machado Filho <tuliom@ascii.art.br>, Florian Weimer <fweimer@redhat.com>, Michael Meissner <meissner@linux.ibm.com>, Alan Modra <amodra@gmail.com>, Peter Bergner <bergner@vnet.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>l
List-Id: linux-api@vger.kernel.org

Carlos O'Donell <codonell@redhat.com> writes:
> On 4/8/19 3:20 PM, Tulio Magno Quites Machado Filho wrote:
>> Carlos O'Donell <codonell@redhat.com> writes:
>> 
>>> On 4/5/19 5:16 AM, Florian Weimer wrote:
>>>> * Carlos O'Donell:
>>>>> It is valuable that it be a trap, particularly for constant pools because
>>>>> it means that a jump into the constant pool will trap.
>>>>
>>>> Sorry, I don't understand why this matters in this context.  Would you
>>>> please elaborate?
>>>
>>> Sorry, I wasn't very clear.
>>>
>>> My point is only that any accidental jumps, either with off-by-one (like you
>>> fixed in gcc/glibc's signal unwinding most recently), result in a process fault
>>> rather than executing RSEQ_SIG as a valid instruction *and then* continuing
>>> onwards to the handler.
>>>
>>> A process fault is achieved either by a trap, or an invalid instruction, or
>>> a privileged insn (like suggested for MIPS in this thread).
>> 
>> In that case, mtmsr (Move to Machine State Register) seems a good candidate.
>> 
>> mtmsr is available both on 32 and 64 bits since their first implementations.
>> 
>> It's a privileged instruction and should never appear in userspace
>> code (causes SIGILL).

I'd much rather we use a trap with a specific immediate value. Otherwise
someone's going to waste time one day puzzling over why userspace is
doing mtmsr.

It would also complicate things if we ever wanted to emulate mtmsr.

If we want something that is a trap rather than a nop then use 0x0fe50553.

That's "compare the value in r5 with 0x553 and then trap unconditionally".

It shows up in objdump as:

    10000000:	53 05 e5 0f 	twui    r5,1363


The immediate can be anything, I chose that value to mimic the x86 value
Mathieu mentioned.

There's no reason that instruction would ever be generated because the
immediate value serves no purpose. So it satisfies the "very unlikely
to appear" criteria AFAICS.

cheers
