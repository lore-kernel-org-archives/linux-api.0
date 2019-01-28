From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [RFC PATCH] Fix: membarrier: racy access to p->mm in
 membarrier_global_expedited()
Date: Mon, 28 Jan 2019 12:46:11 -0800
Message-ID: <20190128204611.GB4240@linux.ibm.com>
References: <20190128182636.18420-1-mathieu.desnoyers@efficios.com>
 <CAHk-=wjmpfXak0pQVu8dZrk2Oma3OxtEoBHfwCAruu0xpSMN4A@mail.gmail.com>
Reply-To: paulmck@linux.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wjmpfXak0pQVu8dZrk2Oma3OxtEoBHfwCAruu0xpSMN4A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>, Andrea Parri <parri.andrea@gmail.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@kernel.org>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, David Sehr <sehr@google.com>, Greg Hackmann <ghackmann@google.com>, "H . Peter Anvin" <hpa@zytor.com>, Maged Michael <maged.michael@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@s>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 12:27:03PM -0800, Linus Torvalds wrote:
> On Mon, Jan 28, 2019 at 10:27 AM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > Jann Horn identified a racy access to p->mm in the global expedited
> > command of the membarrier system call.
> >
> > The suggested fix is to hold the task_lock() around the accesses to
> > p->mm and to the mm_struct membarrier_state field to guarantee the
> > existence of the mm_struct.
> 
> Hmm. I think this is right. You shouldn't access another threads mm
> pointer without proper locking.
> 
> That said, we *could* make the mm_cachep be SLAB_TYPESAFE_BY_RCU,
> which would allow speculatively reading data off the mm pointer under
> RCU. It might not be the *right* mm if somebody just did an exit, but
> for things like this it shouldn't matter.

That sounds much simpler and more effective than the contention-reduction
approach that I suggested.  ;-)

							Thanx, Paul

> But if this is the only case that might care, it sounds like just
> doing the proper locking is the right approach.
> 
>            Linus
> 
