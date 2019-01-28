From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] Fix: membarrier: racy access to p->mm in membarrier_global_expedited()
Date: Mon, 28 Jan 2019 12:27:03 -0800
Message-ID: <CAHk-=wjmpfXak0pQVu8dZrk2Oma3OxtEoBHfwCAruu0xpSMN4A@mail.gmail.com>
References: <20190128182636.18420-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190128182636.18420-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>, Andrea Parri <parri.andrea@gmail.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@kernel.org>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, David Sehr <sehr@google.com>, Greg Hackmann <ghackmann@google.com>, "H . Peter Anvin" <hpa@zytor.com>, Maged Michael <maged.michael@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Mackerras <paulus@sam>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 10:27 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Jann Horn identified a racy access to p->mm in the global expedited
> command of the membarrier system call.
>
> The suggested fix is to hold the task_lock() around the accesses to
> p->mm and to the mm_struct membarrier_state field to guarantee the
> existence of the mm_struct.

Hmm. I think this is right. You shouldn't access another threads mm
pointer without proper locking.

That said, we *could* make the mm_cachep be SLAB_TYPESAFE_BY_RCU,
which would allow speculatively reading data off the mm pointer under
RCU. It might not be the *right* mm if somebody just did an exit, but
for things like this it shouldn't matter.

But if this is the only case that might care, it sounds like just
doing the proper locking is the right approach.

           Linus
