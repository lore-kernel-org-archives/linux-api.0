From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH for 4.18 2/2] rseq: compat: clear high bits of rseq_cs fields
Date: Tue, 26 Jun 2018 14:58:08 -0700
Message-ID: <D9B93DE9-F61C-4488-B109-432C2DFDCEC2@amacapital.net>
References: <20180626211617.8933-1-mathieu.desnoyers@efficios.com> <20180626211617.8933-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180626211617.8933-2-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Joel Fernandes <joelaf@google.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Will Deacon <will.deacon@arm.com>, Andi Kleen <andi@firstfloor.org>, "H . Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Andrew Hunter <ahh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org



> On Jun 26, 2018, at 2:16 PM, Mathieu Desnoyers <mathieu.desnoyers@efficios=
.com> wrote:
>=20
> Make the behavior rseq on compat tasks more robust by ensuring that
> kernel/rseq.c:rseq_get_rseq_cs() clears the high bits of
> rseq_cs->abort_ip, rseq_cs->start_ip and rseq_cs->post_commit_offset
> when a 32-bit binary is run on a 64-bit kernel.
>=20
> The intent here is that if user-space has garbage rather than zeroes
> in its struct rseq_cs fields padding, the behavior will be the same
> whether the binary is run on 32-bit or 64-bit kernels.
>=20
> Use in_compat_syscall() when rseq_get_rseq_cs() is invoked from
> system call context, and use is_compat_frame() when invoked from
> signal delivery.
>=20

And when it=E2=80=99s invoked due to preemption unrelated to a syscall or si=
gnal, you malfunction?

I think the only sane solution is to make these fields be u64, delete the LI=
NUX_FIELD_ macros, and possibly teach the x86 slowpath return to inject a si=
gnal if it=E2=80=99s trying to return to a 32-bit context with garbage in th=
e high bits of regs->ip so that we determistically fail if the user screws u=
p.

Rseq is brand new. It should not need compat code at all.=
