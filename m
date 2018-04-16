From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call (v7)
Date: Mon, 16 Apr 2018 12:26:35 -0700
Message-ID: <CA+55aFxtZXi05UNLmtbKcZ=2N_ROE5pLnu9+v6FaXiuK=VbErA@mail.gmail.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
 <20180412192800.15708-13-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com>
 <CALCETrVvaMWUJKx+bxXdEm3oVBzn2r5RuJ4JcXNzOPSgJAC5PA@mail.gmail.com>
 <542721578.11358.1523903708510.JavaMail.zimbra@efficios.com>
 <CA+55aFzZtY5ELKc+TGf9BA6px300BNzedadm_yNXzODTKN=HgQ@mail.gmail.com> <435471300.11403.1523906479091.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <435471300.11403.1523906479091.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 16, 2018 at 12:21 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> And I try very hard to avoid being told I'm the one breaking
> user-space. ;-)

You *can't* be breaking user space. User space doesn't use this yet.

That's actually why I'd like to start with the minimal set - to make
sure we don't introduce features that will come back to bite us later.

The one compelling use case I saw was a memory allocator that used
this for getting per-CPU (vs per-thread) memory scaling.

That code didn't need the cpu_opv system call at all.

And if somebody does a ldload of a malloc library, and then wants to
analyze the behavior of a program, maybe they should ldload their own
malloc routines first? That's pretty much par for the course for those
kinds of projects.

So I'd much rather we first merge the non-contentious parts that
actually have some numbers for "this improves performance and makes a
nice fancy malloc possible".

As it is, the cpu_opv seems to be all about theory, not about actual need.

              Linus
