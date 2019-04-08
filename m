From: Carlos O'Donell <codonell@redhat.com>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup and
 thread creation (v7)
Date: Mon, 8 Apr 2019 17:45:41 -0400
Message-ID: <ce9fbc66-5eb9-0fa9-99fa-5abfe00ddfc2@redhat.com>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com>
 <20190212194253.1951-2-mathieu.desnoyers@efficios.com>
 <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com>
 <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
 <87lg0tosfz.fsf@concordia.ellerman.id.au>
 <87pnq4zxyj.fsf@oldenburg2.str.redhat.com>
 <ce6f9db3-bf85-7aec-4bae-998e6fd629e1@redhat.com>
 <87y34o4xt3.fsf@oldenburg2.str.redhat.com>
 <43f97ddb-c8df-27ea-9517-63252ebd3183@redhat.com>
 <877ec4pam2.fsf@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877ec4pam2.fsf@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tulio Magno Quites Machado Filho <tuliom@ascii.art.br>, Florian Weimer <fweimer@redhat.com>, Michael Meissner <meissner@linux.ibm.com>, Alan Modra <amodra@gmail.com>, Peter Bergner <bergner@vnet.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>l
List-Id: linux-api@vger.kernel.org

On 4/8/19 3:20 PM, Tulio Magno Quites Machado Filho wrote:
> Carlos O'Donell <codonell@redhat.com> writes:
> 
>> On 4/5/19 5:16 AM, Florian Weimer wrote:
>>> * Carlos O'Donell:
>>>> It is valuable that it be a trap, particularly for constant pools because
>>>> it means that a jump into the constant pool will trap.
>>>
>>> Sorry, I don't understand why this matters in this context.  Would you
>>> please elaborate?
>>
>> Sorry, I wasn't very clear.
>>
>> My point is only that any accidental jumps, either with off-by-one (like you
>> fixed in gcc/glibc's signal unwinding most recently), result in a process fault
>> rather than executing RSEQ_SIG as a valid instruction *and then* continuing
>> onwards to the handler.
>>
>> A process fault is achieved either by a trap, or an invalid instruction, or
>> a privileged insn (like suggested for MIPS in this thread).
> 
> In that case, mtmsr (Move to Machine State Register) seems a good candidate.
> 
> mtmsr is available both on 32 and 64 bits since their first implementations.
> 
> It's a privileged instruction and should never appear in userspace
> code (causes SIGILL).
> 
> Any comments?
  
That seems good to me.

Mathieu,

What's required to move this forward for POWER?

-- 
Cheers,
Carlos.
