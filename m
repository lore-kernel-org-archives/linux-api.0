From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup and thread creation (v7)
Date: Tue, 02 Apr 2019 17:02:40 +1100
Message-ID: <87lg0tosfz.fsf@concordia.ellerman.id.au>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com> <20190212194253.1951-2-mathieu.desnoyers@efficios.com> <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com> <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-101107-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Carlos O'Donell <codonell@redhat.com>, Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> Hi Carlos,
>
> ----- On Mar 22, 2019, at 4:09 PM, Carlos O'Donell codonell@redhat.com wrote:
...
>
> [...]
>>> +++ b/sysdeps/unix/sysv/linux/powerpc/bits/rseq.h
> [...]
>>> +/* Signature required before each abort handler code.  */
>>> +#define RSEQ_SIG 0x53053053
>> 
>> Why isn't this an opcode specific to power?
>
> On powerpc 32/64, the abort is placed in a __rseq_failure executable section:
>
> #define RSEQ_ASM_DEFINE_ABORT(label, abort_label)                               \
>                 ".pushsection __rseq_failure, \"ax\"\n\t"                       \
>                 ".long " __rseq_str(RSEQ_SIG) "\n\t"                            \
>                 __rseq_str(label) ":\n\t"                                       \
>                 "b %l[" __rseq_str(abort_label) "]\n\t"                         \
>                 ".popsection\n\t"
>
> That section only contains snippets of those trampolines. Arguably, it would be
> good if disassemblers could find valid instructions there. Boqun Feng could perhaps
> shed some light on this signature choice ? Now would be a good time to decide
> once and for all whether a valid instruction would be a better choice.

I'm a bit vague on what we're trying to do here.

But it seems like you want some sort of "eye catcher" prior to the branch?

That value is a valid instruction on current CPUs (rlwimi.
r5,r24,6,1,9), and even if it wasn't it could become one in future.

If you change it to 0x8053530 that is both a valid instruction and is a
nop (conditional trap immediate but with no conditions set).

cheers
