From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU number
 of running thread
Date: Thu, 7 Apr 2016 14:37:39 +0200
Message-ID: <57065493.9060200@redhat.com>
References: <5702A037.60200@zytor.com>
 <492303698.44994.1459799188052.JavaMail.zimbra@efficios.com>
 <856357054.45028.1459802903401.JavaMail.zimbra@efficios.com>
 <5703E191.2040707@redhat.com>
 <20160405164722.GB3430@twins.programming.kicks-ass.net>
 <570621E5.7060306@redhat.com>
 <20160407103158.GP3430@twins.programming.kicks-ass.net>
 <570638D9.7010108@redhat.com>
 <20160407111938.GR3430@twins.programming.kicks-ass.net>
 <57064CA9.101@redhat.com>
 <20160407122528.GS3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160407122528.GS3430@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On 04/07/2016 02:25 PM, Peter Zijlstra wrote:

> Do you have a pointer to something I can read? Because I'm clearly not
> understanding the full issue here.

I believe the canonical reference still is this document:

  <https://www.akkadia.org/drepper/tls.pdf>

For newer architectures (ppc64le, aarch64), you'll have to check the
psABI supplements.

Florian
