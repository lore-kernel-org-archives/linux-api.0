From: Carlos O'Donell <codonell@redhat.com>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup and
 thread creation (v7)
Date: Tue, 9 Apr 2019 10:13:03 -0400
Message-ID: <86030de9-862d-3ef5-d372-1695af3c8204@redhat.com>
References: <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com>
 <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
 <87lg0tosfz.fsf@concordia.ellerman.id.au>
 <87pnq4zxyj.fsf@oldenburg2.str.redhat.com>
 <ce6f9db3-bf85-7aec-4bae-998e6fd629e1@redhat.com>
 <87y34o4xt3.fsf@oldenburg2.str.redhat.com>
 <43f97ddb-c8df-27ea-9517-63252ebd3183@redhat.com>
 <877ec4pam2.fsf@linux.ibm.com>
 <ce9fbc66-5eb9-0fa9-99fa-5abfe00ddfc2@redhat.com>
 <877ec3yffq.fsf@concordia.ellerman.id.au>
 <20190409092948.GA14424@bubble.grove.modra.org>
 <871s2bp9f9.fsf@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <871s2bp9f9.fsf@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tulio Magno Quites Machado Filho <tuliom@ascii.art.br>, Alan Modra <amodra@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Florian Weimer <fweimer@redhat.com>, Michael Meissner <meissner@linux.ibm.com>, Peter Bergner <bergner@vnet.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>Peter
List-Id: linux-api@vger.kernel.org

On 4/9/19 9:58 AM, Tulio Magno Quites Machado Filho wrote:
> Alan Modra <amodra@gmail.com> writes:
>> Yes, looks fine to me, except that in VLE mode (do we care?)
>> ".long 0x0fe50553" disassembles as
>>     0:	0f e5       	se_cmphl r5,r30
>>     2:	05 53       	se_mullw r3,r5
>> No illegal/trap/privileged insn there.
>>
>> ".long 0x0fe5000b" might be better to cover VLE.
> 
> Looks good for me too.

The requirement that it be a valid instruction is simply to aid in the
disassembly of rseq regions which may be hand written assembly with a
thin veneer of CFI/DWARF information.

It has already been pointed out that POWER uses data in the instruction
stream for jump tables to implement switch statements, but that specific
use has compiler support and one presumes good debug information. So as
Alan says, there is already data in the insn stream, though such things
can't be good for performance (pollutes D-cache, problematic for
speculative execution).

> Actually, it better fits what Carlos O'Donnell had requested:
> 
>>>> I think the order of preference is:
>>>>
>>>> 1.  An uncommon insn (with random immediate values), in a literal pool, that is
>>>>       not a useful ROP/JOP sequence (very uncommon)
>>>> 2a. A uncommon TRAP hopefully with some immediate data encoded (maybe uncommon)
>>>> 2b. A NOP to avoid affecting speculative execution (maybe uncommon)
>>>>
>>>> With 2a/2b being roughly equivalent depending on speculative execution policy.

Yes, though "in a literal pool" is something that is not required, since
users might not want literal pools and so we shouldn't require that
feature (it also pollutes D-cache).

Keep in mind the insn will never execute.

If a trap insn calls out the nature of the signature more clearly then
use that instead.

-- 
Cheers,
Carlos.
