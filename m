From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Thu, 7 Apr 2016 12:31:58 +0200
Message-ID: <20160407103158.GP3430@twins.programming.kicks-ass.net>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1459789313-4917-2-git-send-email-mathieu.desnoyers@efficios.com>
 <5702A037.60200@zytor.com>
 <492303698.44994.1459799188052.JavaMail.zimbra@efficios.com>
 <856357054.45028.1459802903401.JavaMail.zimbra@efficios.com>
 <5703E191.2040707@redhat.com>
 <20160405164722.GB3430@twins.programming.kicks-ass.net>
 <570621E5.7060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570621E5.7060306@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 11:01:25AM +0200, Florian Weimer wrote:
> > Because ideally this structure would be part of the initial (glibc) TCB
> > with fixed offset etc.
> 
> This is not possible because we have layering violations and code
> assumes it knows the precise of the glibc TCB.  I think Address
> Sanitizer is in this category.  This means we cannot adjust the TCB size
> based on the kernel headers used to compile glibc, and there will have
> to be some indirection.

So with the proposed fixed sized object it would work, right?

Which is part of the reason its being proposed as a fixed sized object.
