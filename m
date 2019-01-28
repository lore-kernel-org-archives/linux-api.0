From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH] Fix: membarrier: racy access to p->mm in membarrier_global_expedited()
Date: Mon, 28 Jan 2019 22:33:47 +0100
Message-ID: <CAG48ez3wLmZiA8cqakoa+98xdqcoK79pMUEpa3XM-Re0CGWXxA@mail.gmail.com>
References: <20190128182636.18420-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190128182636.18420-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andrea Parri <parri.andrea@gmail.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@kernel.org>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, David Sehr <sehr@google.com>, Greg Hackmann <ghackmann@google.com>, "H . Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Maged Michael <maged.michael@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Mackerras <paulus>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 7:27 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> Jann Horn identified a racy access to p->mm in the global expedited
> command of the membarrier system call.
>
> The suggested fix is to hold the task_lock() around the accesses to
> p->mm and to the mm_struct membarrier_state field to guarantee the
> existence of the mm_struct.
>
> Link: https://lore.kernel.org/lkml/CAG48ez2G8ctF8dHS42TF37pThfr3y0RNOOYTmxvACm4u8Yu3cw@mail.gmail.com
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

The patch looks good to me, and to be sure, I've also given it a spin
- I can't trigger a splat anymore. You can add:

Tested-by: Jann Horn <jannh@google.com>
