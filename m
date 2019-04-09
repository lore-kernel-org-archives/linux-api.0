From: Alan Modra <amodra@gmail.com>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup and
 thread creation (v7)
Date: Tue, 9 Apr 2019 18:59:48 +0930
Message-ID: <20190409092948.GA14424@bubble.grove.modra.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877ec3yffq.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Carlos O'Donell <codonell@redhat.com>, Tulio Magno Quites Machado Filho <tuliom@ascii.art.br>, Florian Weimer <fweimer@redhat.com>, Michael Meissner <meissner@linux.ibm.com>, Peter Bergner <bergner@vnet.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 09, 2019 at 02:23:53PM +1000, Michael Ellerman wrote:
> I'd much rather we use a trap with a specific immediate value. Otherwise
> someone's going to waste time one day puzzling over why userspace is
> doing mtmsr.

It's data.  We have other data in executable sections.  Anyone who
wonders about odd disassembly just hasn't realized they are
disassembling data.

> It would also complicate things if we ever wanted to emulate mtmsr.

No, because it won't be executed.  If I understand correctly, the only
reason to choose an illegal, trap or privileged insn is to halt
execution earlier rather than later when a program goes off in the
weeds.

> If we want something that is a trap rather than a nop then use 0x0fe50553.
> 
> That's "compare the value in r5 with 0x553 and then trap unconditionally".
> 
> It shows up in objdump as:
> 
>     10000000:	53 05 e5 0f 	twui    r5,1363
> 
> 
> The immediate can be anything, I chose that value to mimic the x86 value
> Mathieu mentioned.
> 
> There's no reason that instruction would ever be generated because the
> immediate value serves no purpose. So it satisfies the "very unlikely
> to appear" criteria AFAICS.

Yes, looks fine to me, except that in VLE mode (do we care?)
".long 0x0fe50553" disassembles as
   0:	0f e5       	se_cmphl r5,r30
   2:	05 53       	se_mullw r3,r5
No illegal/trap/privileged insn there.

".long 0x0fe5000b" might be better to cover VLE.

-- 
Alan Modra
Australia Development Lab, IBM
