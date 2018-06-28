From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH for 4.18 2/2] rseq: compat: clear high bits of rseq_cs
 fields
Date: Thu, 28 Jun 2018 10:04:51 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1806281002280.1778@nanos.tec.linutronix.de>
References: <20180626211617.8933-1-mathieu.desnoyers@efficios.com> <20180626211617.8933-2-mathieu.desnoyers@efficios.com> <D9B93DE9-F61C-4488-B109-432C2DFDCEC2@amacapital.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-627297609-1530173097=:1778"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D9B93DE9-F61C-4488-B109-432C2DFDCEC2@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, Joel Fernandes <joelaf@google.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Will Deacon <will.deacon@arm.com>, Andi Kleen <andi@firstfloor.org>, "H . Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Andrew Hunter <ahh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, x86
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-627297609-1530173097=:1778
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 26 Jun 2018, Andy Lutomirski wrote:
> > On Jun 26, 2018, at 2:16 PM, Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > Make the behavior rseq on compat tasks more robust by ensuring that
> > kernel/rseq.c:rseq_get_rseq_cs() clears the high bits of
> > rseq_cs->abort_ip, rseq_cs->start_ip and rseq_cs->post_commit_offset
> > when a 32-bit binary is run on a 64-bit kernel.
> > 
> > The intent here is that if user-space has garbage rather than zeroes
> > in its struct rseq_cs fields padding, the behavior will be the same
> > whether the binary is run on 32-bit or 64-bit kernels.
> > 
> > Use in_compat_syscall() when rseq_get_rseq_cs() is invoked from
> > system call context, and use is_compat_frame() when invoked from
> > signal delivery.
> > 
> 
> And when it’s invoked due to preemption unrelated to a syscall or signal,
> you malfunction?
>
> I think the only sane solution is to make these fields be u64, delete the
> LINUX_FIELD_ macros, and possibly teach the x86 slowpath return to inject
> a signal if it’s trying to return to a 32-bit context with garbage in the
> high bits of regs->ip so that we determistically fail if the user screws
> up.

Right. That's the only sane solution. Trying to play games with 32/64bit
for a dubious value is going to bite us within no time and just create ugly
workarounds left and right. Forcing a clear handling upfront avoids all of
that.

Thanks,

	tglx
--8323329-627297609-1530173097=:1778--
