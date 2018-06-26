From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 2/2] rseq: compat: clear high bits of
 rseq_cs fields
Date: Tue, 26 Jun 2018 18:17:22 -0400 (EDT)
Message-ID: <107389573.6464.1530051442686.JavaMail.zimbra@efficios.com>
References: <20180626211617.8933-1-mathieu.desnoyers@efficios.com> <20180626211617.8933-2-mathieu.desnoyers@efficios.com> <D9B93DE9-F61C-4488-B109-432C2DFDCEC2@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D9B93DE9-F61C-4488-B109-432C2DFDCEC2@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Will Deacon <will.deacon@arm.com>, Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Andrew Hunter <ahh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, linux-api <linux-api@vger.kernel.org>linux-arch <linux-a>
List-Id: linux-api@vger.kernel.org

----- On Jun 26, 2018, at 5:58 PM, Andy Lutomirski luto@amacapital.net wrot=
e:

>> On Jun 26, 2018, at 2:16 PM, Mathieu Desnoyers <mathieu.desnoyers@effici=
os.com>
>> wrote:
>>=20
>> Make the behavior rseq on compat tasks more robust by ensuring that
>> kernel/rseq.c:rseq_get_rseq_cs() clears the high bits of
>> rseq_cs->abort_ip, rseq_cs->start_ip and rseq_cs->post_commit_offset
>> when a 32-bit binary is run on a 64-bit kernel.
>>=20
>> The intent here is that if user-space has garbage rather than zeroes
>> in its struct rseq_cs fields padding, the behavior will be the same
>> whether the binary is run on 32-bit or 64-bit kernels.
>>=20
>> Use in_compat_syscall() when rseq_get_rseq_cs() is invoked from
>> system call context, and use is_compat_frame() when invoked from
>> signal delivery.
>>=20
>=20
> And when it=E2=80=99s invoked due to preemption unrelated to a syscall or=
 signal, you
> malfunction?

Fair point! Hence the "RFC". ;)

So I understand better your intent to use the pt_regs to figure out whether=
 it
is compat or not. My is_compat_frame()+in_compat_syscall() approach does no=
t
handle this correctly.

>=20
> I think the only sane solution is to make these fields be u64,

I'm OK with turning the rseq_cs start_ip, post_commit_offset, and abort_ip
fields into normal u64.

> delete the
> LINUX_FIELD_ macros,

The LINUX_FIELD_ macros are still needed to ensure single-copy updates of
the (struct rseq *__tls_abi)->rseq_cs pointer by 32-bit user-space.

> and possibly teach the x86 slowpath return to inject a
> signal if it=E2=80=99s trying to return to a 32-bit context with garbage =
in the high
> bits of regs->ip so that we determistically fail if the user screws up.

I like the approach of dealing with the rseq_cs fields as u64 even on 32-bi=
t
architectures. As a downside, it will require 32-bit architectures to do
arithmetic on 64-bit values, but it's not a fast-path. As you point out, th=
e
tricky bit is to decide what happens when architecture code returns to
userspace with regs->ip containing garbage in the high bits.

An alternative approach is to ensure the high bits are cleared when returni=
ng
to an IP with garbage in the high bits.

> Rseq is brand new. It should not need compat code at all.

Dealing with u64 for start_ip, post_commit_offset, and abort_ip at the kern=
el
level would indeed provide this characteristic. However, I'm uneasy adding
64-bit arithmetic on operations really caring about 32 bits on 32-bit archs=
,
even though those are not fast paths.

Thanks,

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
