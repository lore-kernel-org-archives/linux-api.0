From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Fri, 19 Aug 2016 14:24:23 -0700
Message-ID: <20160819212423.623v5leqknfrxhpd@x>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1471637274-13583-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g@mail.gmail.com>
 <20160819205611.GF5871@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160819205611.GF5871@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catal>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 19, 2016 at 01:56:11PM -0700, Andi Kleen wrote:
> > Nobody gets a cpu number just to get a cpu number - it's not a useful
> > thing to benchmark. What does getcpu() so much that we care?
> 
> malloc is the primary target I believe. Saves lots of memory to keep
> caches per CPU rather than per thread.

Also improves locality; that does seem like a good idea.  Has anyone
written and tested the corresponding changes to a malloc implementation?

- Josh Triplett
