From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Fri, 19 Aug 2016 16:35:46 -0700
Message-ID: <20160819233546.GK3482@linux.vnet.ibm.com>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1471637274-13583-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g@mail.gmail.com>
 <20160819205611.GF5871@two.firstfloor.org>
 <20160819211946.GJ3482@linux.vnet.ibm.com>
 <CA+55aFwo7LJ95fKBAhzcu6kCLd5=73n9M6QOq-mMaYO-d5dCVw@mail.gmail.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwo7LJ95fKBAhzcu6kCLd5=73n9M6QOq-mMaYO-d5dCVw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 19, 2016 at 02:32:13PM -0700, Linus Torvalds wrote:
> On Fri, Aug 19, 2016 at 2:19 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Fri, Aug 19, 2016 at 01:56:11PM -0700, Andi Kleen wrote:
> >>
> >> malloc is the primary target I believe. Saves lots of memory to keep
> >> caches per CPU rather than per thread.
> >
> > Agreed, a competent default malloc() in glibc would be a very nice change
> > from the current state.
> 
> I agree that malloc can be a very good target for something like this,
> but it is also something that is quite complicated. A general-purpose
> allocator that could be used by glibc and has not just the performance
> but the debug stuff etc that people inevitably want is a big project.
> And then the people who have special needs end up writing their own
> allocators anyway, just because they care about certain layout and
> access patterns...
> 
> Put another way: I'd really like to see some real numbers and use,
> rather than "this can be used for.."

No argument here!

							Thanx, Paul
