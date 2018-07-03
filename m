From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 21:08:31 +0200
Message-ID: <20180703190831.GJ2458@hirez.programming.kicks-ass.net>
References: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <20180703173451.GX2494@hirez.programming.kicks-ass.net>
 <399697782.11820.1530639539750.JavaMail.zimbra@efficios.com>
 <20180703174833.GZ2494@hirez.programming.kicks-ass.net>
 <1048940999.11846.1530640717837.JavaMail.zimbra@efficios.com>
 <20180703181143.GB2494@hirez.programming.kicks-ass.net>
 <1708848118.11868.1530641734202.JavaMail.zimbra@efficios.com>
 <20180703182837.GC2494@hirez.programming.kicks-ass.net>
 <1368400582.11897.1530643261772.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368400582.11897.1530643261772.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, heiko carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

On Tue, Jul 03, 2018 at 02:41:01PM -0400, Mathieu Desnoyers wrote:

> User-space won't ever want to read cpu_id_start and cpu_id from a single
> u64 load, it serves no purpose to do so. So I'm OK with keeping those as
> is and defining a local union for the __put_user() update.

So I think previously we had the sequence number and cpuid in there
together, and in that case it did want to load them both. But since you
made that sequence number dissapear....
