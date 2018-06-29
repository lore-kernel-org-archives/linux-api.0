From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Thu, 28 Jun 2018 17:18:22 -0700
Message-ID: <CA+55aFzxCjkSbfRUeX3W_oXSJ6LMUdRVYB=DR2b3rUNkiixM1A@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
 <CALCETrULo_VP4XHbXcZTevWY5d-6PdHUtrDS8DEF_OaozQOaNg@mail.gmail.com>
 <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com> <CALCETrUrXk3wRg8SKhWf98v8jK=HwX9XLvP+Ypi+TktZoNx_Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUrXk3wRg8SKhWf98v8jK=HwX9XLvP+Ypi+TktZoNx_Jg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Lutomirski <luto@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@ar>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 28, 2018 at 4:30 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> The idea is that, if someone screws up and sticks a number like
> 0xbaadf00d00045678 into their rseq abort_ip in a 32-bit x86 program
> (when they actually mean 0x00045678), we want to something consistent.

I think the "something consistent" is perfectly fine with just "it won't work".

Make it do

        if (rseq_cs->abort_ip != (unsigned long)rseq_cs->abort_ip)
                return -EINVAL;

at abort time.

Done.

If it's a 32-bit kernel, the above will reject the thing, and if it's
a 64-bit kernel, it will be a no-op, but the abort won't work in a
32-bit caller.

Problem solved.

             Linus
