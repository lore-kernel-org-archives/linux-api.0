From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Fri, 19 Aug 2016 13:59:28 -0700
Message-ID: <CA+55aFw95UtYhpaiX5LgzmmjL==+vbFQcYtFvkxYcEBOtyXzMQ@mail.gmail.com>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1471637274-13583-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g@mail.gmail.com> <20160819204450.GB27677@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160819204450.GB27677@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 19, 2016 at 1:44 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>
> The combination of CPU number and restartable sequence allows userspace
> to write "per-CPU" rather than "per-thread" algorithms, just as the
> kernel can.  The kernel can do that with preempt_disable().  Userspace
> can do it with "tell me my CPU and restart me if preempted".

Yes, I understand what the patch series wants to do. But there hasn't
been a lot of discussion about why per-cpu would be better than
per-thread, or who would actually use this.

The kernel cares about per-cpu, because as far as the kernel is
concerned, that largely _is_ threading inside the kernel.

I'd feel a lot more warm and fuzzy about this all if I'd also see what
the usage scenario is, and then the numbers on top of that.

We really _have_ had too many clever interfaces that basically never
saw any real use, because the application writers don't want to limit
themselves to just Linux, and even if they are happy to do that, they
don't want to then limit themselves to a fairly modern kernel, and
they don't want to have two different code bases.

For example, there's been a talk about number of instructions and
cycles on ARMv7, but it's not clear whether the use case is going to
care about tens of cycles of overhead much less individual instruction
counts. Those instruction counts may matter when you benchmark an
individual "cpu-atomic add", but may not matter when you actually
benchmark something much bigger.

And if people end up waiting for kernel support to be universally
available, then ARMv7 isn't even all that relevant any more. It takes
years for things like this to percolate out. In the android space, you
get new hardware quicker than you get new software..

           Linus
