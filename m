From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields, validate
 user inputs
Date: Tue, 3 Jul 2018 10:59:45 -0700
Message-ID: <CA+55aFxcVbG2DMmmrW-HLTXZE+rcBWc5F48UYoL2heEsEpyO=g@mail.gmail.com>
References: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <20180703082955.GH3704@osiris> <20180703084312.GU2494@hirez.programming.kicks-ass.net>
 <20180703085546.GJ3704@osiris> <20180703092113.GV2494@hirez.programming.kicks-ass.net>
 <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org> <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com>
 <20180703173451.GX2494@hirez.programming.kicks-ass.net> <399697782.11820.1530639539750.JavaMail.zimbra@efficios.com>
 <20180703174833.GZ2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703174833.GZ2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andi Kleen <andi@firstfloor.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.m>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 3, 2018 at 10:49 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> > I can simply document that loads/stores from/to all struct rseq fields
> > should be thread-local then ?
>
> I'm not sure that covers things sufficiently. You really want the
> userspace load/stores to be single instructions.

Actually, I think we should try very hard to limit even that to _just_
the rseq pointer itself.

Everything else can be filled in ahead of time with non-atomic stores,
and then the last thing that happens - and the only thing that wants
that final "one last atomic write" is the rseq pointer write.

No?

So I'd suggest that the only part we aim to have any "atomic" behavior
at all is for the individual fields in "struct rseq" itself. So the
cpu id and the base pointer and the flags. And even they are
thread-local, so the atomicity is not about the kernel, but about user
space needing to read and update them in word-sized chunks.

End result: absolutely nothing is atomic for the kernel.

                 Linus
