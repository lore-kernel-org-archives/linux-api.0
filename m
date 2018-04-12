From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call (v7)
Date: Thu, 12 Apr 2018 12:43:27 -0700
Message-ID: <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com> <20180412192800.15708-13-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412192800.15708-13-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 12, 2018 at 12:27 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> The cpu_opv system call executes a vector of operations on behalf of
> user-space on a specific CPU with preemption disabled. It is inspired
> by readv() and writev() system calls which take a "struct iovec"
> array as argument.

Do we really want the page pinning?

This whole cpu_opv thing is the most questionable part of the series,
and the page pinning is the most questionable part of cpu_opv for me.

Can we plan on merging just the plain rseq parts *without* this all
first, and then see the cpu_opv thing as a "maybe future expansion"
part.

I think that would make Andy happier too.

             Linus
