From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Thu, 12 Oct 2017 17:36:02 -0700
Message-ID: <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

I do not hate this series, and I'd be happy to apply it, but I will
repeat what I've asked for EVERY SINGLE TIME this series has come up:

On Thu, Oct 12, 2017 at 4:03 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Here are benchmarks of counter increment in various scenarios compared
> to restartable sequences. Those benchmarks were taken on v8 of the
> patchset.

I want to see real numbers from real issues.

A "increment percpu value" simply isn't relevant.

When I asked last time, people pointed me to potential uses, including
malloc libraries that could get per-thread performance with just
per-cpu (not per thread) data structure overhead. I see that you once
more point to the slides from 2013 that again talks about it.

But people didn't post code, people didn't post numbers, and people
didn't point to actual real uses, just "this could happen".

I really really want more than hand-waving. I want more than pointless
"this is how quickly you can increment a per-thread counter". I want
to hear about _real_ uses, and real numbers.

This has been going on for long enough, that if there *still* are no
actual real users, then I'm *still* not interested in having this
merged.

Because without real-world uses, it's not obvious that there won't be
somebody who goes "oh, this isn't quite enough for us, the semantics
are subtly incompatible with our real-world use case".

So I want real numbers from a real implementation of malloc/free. And
if it's not malloc/free, then what is it? I want something *real*, not
some micro-benchmark that benchmarks a totally pointless load.

Because until there are that kind of "yes, this is more than theory",
I'm not really willing to have this merged.

                   Linus
