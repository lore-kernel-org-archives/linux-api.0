From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH for 5.2 00/12] Restartable Sequences selftests updates
Date: Fri, 03 May 2019 14:46:17 -0700
Message-ID: <5a671727418034dd1de54ad67f3f028f3cde9516.camel@perches.com>
References: <20190429152803.7719-1-mathieu.desnoyers@efficios.com>
         <678952111.699.1556908562445.JavaMail.zimbra@efficios.com>
         <68a135d7-7b30-71c7-c570-c7608d6f75d5@kernel.org>
         <1137649333.995.1556911352713.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1137649333.995.1556911352713.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, shuah <shuah@kernel.org>, Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

On Fri, 2019-05-03 at 15:22 -0400, Mathieu Desnoyers wrote:
> ----- On May 3, 2019, at 2:53 PM, shuah shuah@kernel.org wrote:
> > ERROR: need consistent spacing around '%' (ctx:WxV)
> > #227: FILE: tools/testing/selftests/rseq/rseq-x86.h:104:
> > +		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
> > 
> > Will you be able to fix them and resend?
[]
> (CCing the che checkpatch maintainers)
> 
> checkpatch appears to be wrong for these errors. I suspect it thinks those are
> '%' modulo operators (for which the style requires space before/after),
> but those are actually part of the asm input and goto target operands.

checkpatch doesn't really understand asm.
Ignore checkpatch when it's silly.
