From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call (v7)
Date: Fri, 13 Apr 2018 09:37:28 -0700
Message-ID: <CA+55aFwXCnnfrOjPj5SB=G34xgveo1jqNyf23YNt6jOKX_VdGw@mail.gmail.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
 <20180412192800.15708-13-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com>
 <1580648199.9463.1523563167045.JavaMail.zimbra@efficios.com>
 <CA+55aFwFUeNA6_0a1MOU-7VGzCw5T99cfVCPiyTpZQJdd6z=bw@mail.gmail.com> <625160026.9658.1523621809662.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <625160026.9658.1523621809662.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 13, 2018 at 5:16 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> The vmalloc space needed by cpu_opv is bound by the number of pages
> a cpu_opv call can touch.

No it's not.

You can have a thousand different processes doing cpu_opv at the same time.

A *single* cpu_opv may me limited toi "only" a megabyte, but I'm not
seeing any global limit anywhere.

In short, this looks like a guaranteed DoS approach to me.

                   Linus
