From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 4.16 08/10] membarrier: x86: Provide core
 serializing command (v3)
Date: Tue, 16 Jan 2018 19:22:13 +0000 (UTC)
Message-ID: <1443621141.3981.1516130533202.JavaMail.zimbra@efficios.com>
References: <20180115191104.12437-1-mathieu.desnoyers@efficios.com> <20180115191104.12437-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1801161928110.2366@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1801161928110.2366@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, maged michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David
List-Id: linux-api@vger.kernel.org

----- On Jan 16, 2018, at 1:29 PM, Thomas Gleixner tglx@linutronix.de wrote:

> On Mon, 15 Jan 2018, Mathieu Desnoyers wrote:
> 
>> There are two places where core serialization is needed by membarrier:
>> 
>> 1) When returning from the membarrier IPI,
>> 2) After scheduler updates curr to a thread with a different mm, before
>>    going back to user-space, since the curr->mm is used by membarrier to
>>    check whether it needs to send an IPI to that CPU.
> 
> This wants to be split into x86 and core changes. Ideally you make the core
> changes before the previous patch and add the empty inline into
> linux/processor.h....

Good point, done. The first commit introducing the new command now also
introduces the generic stuff moved from the x86 patches.

Thanks,

Mathieu

> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
