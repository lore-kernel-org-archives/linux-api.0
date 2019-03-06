From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH for 5.1 0/3] Restartable Sequences updates for 5.1
Date: Wed, 6 Mar 2019 09:21:30 +0100
Message-ID: <20190306082130.GR32477@hirez.programming.kicks-ass.net>
References: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
 <1689743723.311.1551817115045.JavaMail.zimbra@efficios.com>
 <20190305215848.GQ32477@hirez.programming.kicks-ass.net>
 <486623963.509.1551825130539.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <486623963.509.1551825130539.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>Catalin Marinas <c>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 05, 2019 at 05:32:10PM -0500, Mathieu Desnoyers wrote:
> ----- On Mar 5, 2019, at 4:58 PM, Peter Zijlstra peterz@infradead.org wrote:
> 
> > On Tue, Mar 05, 2019 at 03:18:35PM -0500, Mathieu Desnoyers wrote:
> >> * NUMA node ID in TLS
> >> 
> >> Having the NUMA node ID available in a TLS variable would allow glibc to
> >> perform interesting NUMA performance improvements within its locking
> >> implementation, so I have a patch adding NUMA node ID support to rseq
> >> as a new rseq system call flag.
> > 
> > Details? There's just not much room in the futex word, and futexes
> > themselves are not numa aware.
> 
> It was discussed in this libc-alpha mailing list thread:
> 
> https://public-inbox.org/libc-alpha/CAMe9rOo7i_-keOooa0D+P_wzatVCdKkTRiFiJ-cxpnvi+eApuQ@mail.gmail.com/
> 
> (adding the relevant people in CC)
> 
> I'd like to hear in more details on how they intend to design
> NUMA-aware spinlocks within glibc. All I know is that quick
> access to the node ID would help for this.

Userspace spinlocks are a trainwreck anyway. The only case where they
can possibly work is when there's only a single thread on every cpu.
Pretty much any other scenario is fail; see why we have paravirt
spinlocks.
