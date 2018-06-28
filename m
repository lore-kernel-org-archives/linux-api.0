From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Thu, 28 Jun 2018 16:29:55 -0700
Message-ID: <CALCETrUrXk3wRg8SKhWf98v8jK=HwX9XLvP+Ypi+TktZoNx_Jg@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
 <CALCETrULo_VP4XHbXcZTevWY5d-6PdHUtrDS8DEF_OaozQOaNg@mail.gmail.com> <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 28, 2018 at 2:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jun 28, 2018 at 1:23 PM Andy Lutomirski <luto@kernel.org> wrote:
>>
>> This is okay with me for a fix outside the merge window.  Can you do a
>> followup for the next merge window that fixes it better, though?  In
>> particular, TASK_SIZE is generally garbage.  I think a better fix
>> would be something like adding a new arch-overridable helper like:
>>
>> static inline unsigned long current_max_user_addr(void) { return TASK_SIZE; }
>
> We already have that. It's called "user_addr_max()".

Nah, that one is more or less equivalent to TASK_SIZE_MAX, except that
it's different if set_fs() is used.

>
> It's the limit we use for user accesses.
>
> That said, I don't see why we should even check the IP. It's not like
> that's done by signal handling either.

The idea is that, if someone screws up and sticks a number like
0xbaadf00d00045678 into their rseq abort_ip in a 32-bit x86 program
(when they actually mean 0x00045678), we want to something consistent.
On a 32-bit kernel, presumably it gets cast to u32 somewhere and it
works.  On a 64-bit kernel, we end up shoving 0xbaadf00d00045678 into
regs->ip, and then the entry code will do, um, something.  If I had to
guess, I would guess that at least IRET is likely to truncate if we're
returning to a 32-bit CS.  But I really don't want to start promising
that we won't segfault if a different path gets invoked on some future
kernel on some future CPU of if we're on an AMD CPU using their
utterly braindead SYSRETL microcode, etc.

So I think we're much better off if we either promise that rseq
truncates the address for 32-bit users or that it segfaults if high
bits are set for 32-bit users.

TASK_SIZE is a super shitty way to do this.  The correct thing is to
either add some check to the exit-to-usermode slowpath that rseq can
trigger or if we add some reasonable way for rseq to say "is this
address a legitimate addressable virtual address for the current
task's user space operating mode."  We don't have such a thing right
now.
