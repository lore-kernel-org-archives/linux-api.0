From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Thu, 28 Jun 2018 14:22:27 -0700
Message-ID: <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com> <CALCETrULo_VP4XHbXcZTevWY5d-6PdHUtrDS8DEF_OaozQOaNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrULo_VP4XHbXcZTevWY5d-6PdHUtrDS8DEF_OaozQOaNg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Lutomirski <luto@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@ar>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 28, 2018 at 1:23 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> This is okay with me for a fix outside the merge window.  Can you do a
> followup for the next merge window that fixes it better, though?  In
> particular, TASK_SIZE is generally garbage.  I think a better fix
> would be something like adding a new arch-overridable helper like:
>
> static inline unsigned long current_max_user_addr(void) { return TASK_SIZE; }

We already have that. It's called "user_addr_max()".

It's the limit we use for user accesses.

That said, I don't see why we should even check the IP. It's not like
that's done by signal handling either.

                     Linus
