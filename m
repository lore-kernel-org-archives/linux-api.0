From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Wed, 2 Mar 2016 11:34:01 +0100
Message-ID: <20160302103401.GC6357@twins.programming.kicks-ass.net>
References: <CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com>
 <1401667361.10273.1456617236327.JavaMail.zimbra@efficios.com>
 <CA+55aFwcgwRxvVBz5kk_3O8dESXAGJ4KHBkf=pSXjiS7Xh4NwA@mail.gmail.com>
 <1082926946.10326.1456619994590.JavaMail.zimbra@efficios.com>
 <CA+55aFwZY1BR5NdjAP-rytd29hE2EZEXgcaBKjepWFFj+oR1SA@mail.gmail.com>
 <1538518747.10504.1456669948568.JavaMail.zimbra@efficios.com>
 <20160229103506.GJ6356@twins.programming.kicks-ass.net>
 <676569856.13488.1456863792603.JavaMail.zimbra@efficios.com>
 <20160301213202.GY6357@twins.programming.kicks-ass.net>
 <56D60DFA.4040809@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56D60DFA.4040809@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ben Maurer <bmaurer@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>, linux-api <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Dave Watson <davejwatson@fb.com>, rostedt <rostedt@goodmis.org>, Andy Lutomirski <luto@amacapital.net>, Will Deacon <will.deacon@arm.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Chris Lameter <cl@linux.com>, Andi Kleen <andi@firstfloor.org>, Josh Triplett <josh@joshtriplett.org>, Paul Turner <pjt@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Andrew Hunter <ahh@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 01, 2016 at 01:47:38PM -0800, H. Peter Anvin wrote:
> On 03/01/16 13:32, Peter Zijlstra wrote:
> > On Tue, Mar 01, 2016 at 08:23:12PM +0000, Mathieu Desnoyers wrote:
> >> I think it's important that user-space fast-paths can quickly
> >> detect whether the feature is enabled without having to rely on
> >> always reading a separate cache-line. I've put together an ABI
> >> proposal that take into account the feedback received so far.
> > 
> > Nah, adding detectoring code to fast paths is silly, makes them less
> > fast. Doesn't userspace have self modifying code? I know that at least
> > glibc does linker trickery to call different functions depending on
> > runtime context.
> > 
> 
> No, userspace does not have self-modifying code.  The glibc indirect
> function is done at dynamic link time; it is also worth noting that
> resolving global symbols through dynamic linking often requires an
> indirect call.

Boy that blows. And here I was thinking you could edit the code at
dynamic link time because nobody was running it yet :/

And I suppose JITs need an (effective) munmap()+mmap() cycle to ensure
the 'old' code is flushed from all caches etc..?
