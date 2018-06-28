From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Thu, 28 Jun 2018 13:22:38 -0700
Message-ID: <CALCETrULo_VP4XHbXcZTevWY5d-6PdHUtrDS8DEF_OaozQOaNg@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Micha
List-Id: linux-api@vger.kernel.org

On Thu, Jun 28, 2018 at 9:23 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> Validating the abort_ip field of rseq_cs ensures that the kernel don't
> return to an invalid address when returning to userspace after an abort.
> I don't fully trust each architecture code to cleanly deal with invalid
> return addresses.
>
> Validating the range [ start_ip, start_ip + post_commit_offset ] is an
> extra validation step ensuring that userspace provides valid values to
> describe the critical section.
>
> If validation fails, the process is killed with a segmentation fault.
>
> Change the rseq ABI so rseq_cs start_ip, post_commit_offset and abort_ip
> fields are seen as 64-bit fields by both 32-bit and 64-bit kernels rather
> that ignoring the 32 upper bits on 32-bit kernels. This ensures we have
> a consistent behavior for a 32-bit binary executed on 32-bit kernels and
> in compat mode on 64-bit kernels.

This is okay with me for a fix outside the merge window.  Can you do a
followup for the next merge window that fixes it better, though?  In
particular, TASK_SIZE is generally garbage.  I think a better fix
would be something like adding a new arch-overridable helper like:

static inline unsigned long current_max_user_addr(void) { return TASK_SIZE; }

and overriding it on x86 as something like:

static inline unsigned long current_max_user_addr(void) {
#ifdef CONFIG_IA32_EMULATION
  return user_64bit_mode(current_pt_regs()) ? TASK_SIZE_MAX : (1UL << 32) - 1;
#else
  return TASK_SIZE_MAX;
}

TASK_SIZE really needs to die.
