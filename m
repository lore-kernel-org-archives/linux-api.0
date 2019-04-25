From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup
 and thread creation (v7)
Date: Thu, 25 Apr 2019 01:41:30 +0100 (BST)
Message-ID: <alpine.LFD.2.21.1904250022240.18194@eddie.linux-mips.org>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com> <20190212194253.1951-2-mathieu.desnoyers@efficios.com> <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com> <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
 <602718e0-7375-deb7-b6e6-2d17022173c5@redhat.com> <20190404214151.6ogrm34dok52az4h@pburton-laptop> <1031613720.1496.1555613900993.JavaMail.zimbra@efficios.com> <1103046939.521.1556118342613.JavaMail.zimbra@efficios.com>
 <20190424231303.zu2irxd5g3v7yqey@pburton-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Received: (from localhost user: 'macro', uid#1010) by eddie.linux-mips.org
        with ESMTP id S23993062AbfDYAladQ7Kx (ORCPT
        <rfc822;linux-api@vger.kernel.org> + 1 other);
        Thu, 25 Apr 2019 02:41:30 +0200
In-Reply-To: <20190424231303.zu2irxd5g3v7yqey@pburton-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Burton <paul.burton@mips.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Carlos O'Donell <codonell@redhat.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, heiko carstens <heiko.carstens@de.ibm.com>, gor <gor@linux.ibm.com>, schwidefsky <schwidefsky@de.ibm.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmc>
List-Id: linux-api@vger.kernel.org

On Wed, 24 Apr 2019, Paul Burton wrote:

> > > Any idea why 0x7273 is not accepted by my assembler ?
> 
> I don't know why the assembler wants a smaller immediate than the
> instruction encoding allows... There's a comment in the binutils file
> include/opcode/mips.h that reads:
> 
> > A breakpoint instruction uses OP, CODE and SPEC (10 bits of the
> > breakpoint instruction are not defined; Kane says the breakpoint code
> > field in BREAK is 20 bits; yet MIPS assemblers and debuggers only use
> > ten bits).  An optional two-operand form of break/sdbbp allows the
> > lower ten bits to be set too, and MIPS32 and later architectures allow
> > 20 bits to be set with a signal operand (using CODE20).
> 
> I suspect there's some history here that predates my involvement (or
> possibly just predates me).

 A useful explanation is in the Linux kernel (always good to look there), 
in arch/mips/kernel/traps.c:

	/*
	 * There is the ancient bug in the MIPS assemblers that the break
	 * code starts left to bit 16 instead to bit 6 in the opcode.
	 * Gas is bug-compatible, but not always, grrr...
	 * We handle both cases with a simple heuristics.  --macro
	 */

Unfortunately the bug has been carried over to the microMIPS instruction 
encoding in libopcodes for no reason (i.e. likely by copying the table 
mechanically without analysing it) and I didn't catch it when upstreaming.  
We should have permitted setting all bits in the 20-bit code field in the 
microMIPS encoding with a single operand, but you need two, like with the 
regular MIPS instruction set.

 The note on the MIPS32 assembly ISA permitting to set all the 20 bits 
with a single operand is a stale comment referring to the situation before 
binutils commit 1586d91e32ea ("/ 0 should send SIGFPE not SIGTRAP..."), 
<https://sourceware.org/ml/binutils/2004-07/msg00260.html>, which 
addressed a user ABI compatibility issue as discussed upthread here: 
<https://sourceware.org/ml/binutils/2004-06/msg00188.html> and previously: 
<https://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=40C9F5A4.2050606%40avtrex.com>.

 As this is my mistake with the stale note, I have applied a fix to 
binutils now, commit cd0923370be1 ("MIPS/include: opcode/mips.h: Update 
stale comment for CODE20 operand"), so that it is clear that it is only 
SDBBP that accepts a single 20-bit operand for the code field (for the 
MIPS32 and later ISAs).

 FWIW,

  Maciej
