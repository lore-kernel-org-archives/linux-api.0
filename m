From: Paul Burton <paul.burton@mips.com>
Subject: Re: [RFC PATCH for 5.2 10/10] rseq/selftests: mips: use break
 instruction for RSEQ_SIG
Date: Mon, 29 Apr 2019 22:31:36 +0000
Message-ID: <20190429223134.unab336v73qdhoz6@pburton-laptop>
References: <20190424152502.14246-1-mathieu.desnoyers@efficios.com>
 <20190424152502.14246-11-mathieu.desnoyers@efficios.com>
 <20190424220609.4kryfcgsv46iu3ds@pburton-laptop>
 <1183307732.352.1556202092390.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1183307732.352.1556202092390.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Content-ID: <D91FD40890C17F459F7E560D4BCC26A6@namprd22.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

On Thu, Apr 25, 2019 at 10:21:32AM -0400, Mathieu Desnoyers wrote:
> I've tried to figure out if we could find a way to have RSEQ_SIG left und=
efined
> if it's not on the plain mips environment, but could not find anything th=
at
> would be #defined on plain mips, but #undefined on both micromips and nan=
omips.
>=20
> What I'd like to do is e.g.:
>=20
> #if defined(__nanomips__)
> # ifdef __MIPSEL__
> #  define RSEQ_SIG	0x03500010
> # else
> #  define RSEQ_SIG	0x00100350
> # endif
> #elif defined(__mips_micromips)
> # ifdef __MIPSEL__
> #  define RSEQ_SIG	0xd4070000
> # else
> #  define RSEQ_SIG	0x0000d407
> # endif
> #elif defined(__mips__)
> # define RSEQ_SIG	0x0350000d
> #else
> /* Leave RSEQ_SIG as is. */
> #endif
>=20
> The idea here is to not allow code targeting future MIPS ISA to compile
> with the wrong signature.
>=20
> The delta between compiling without/with -mmicromips on a gcc-8 compiler
> is only:
>=20
> > #define __mips_micromips 1
>=20
> Some interesting delta when compiling for plain little-endian mips with
> gcc-8 compared to the nanomips compiler is:
>=20
> < #define __mips__ 1
> < #define _mips 1
> < #define MIPSEL 1
>=20
> > #define __nanomips__ 1
>=20
> < #define __mips_isa_rev 2
> > #define __mips_isa_rev 6
>=20
> So let's say we have a picomips introduced in the future, can we rely
> on it not defining __mips__ like the nanomips compiler does ? If so,
> my "#elif defined(__mips__)" approach would indeed leave RSEQ_SIG undefin=
ed
> as expected.
>=20
> Thoughts ?

That seems like a reasonable approach to me. I don't think it'll be
guaranteed, but it'll give the best odds of the behavior you want.

If I recall correctly the reason for not defining __mips__ in the
nanoMIPS compiler was to force people to audit MIPS-specific code given
the scale of the changes in nanoMIPS - there are some incompatibilities
at the assembly level but more than that the ABI changes in multiple
ways from register assignment & calling convention to kernel-user struct
layouts & other things. If we were to build existing MIPS-specific code
as-is then some of this could lead to brokenness that the tools wouldn't
have a good way to detect & reject automatically, so making people audit
the code & add in the __nanomips__ check is a sort of safety measure.

So the likelihood of your code above picking up on any future ISA
changes will probably depend upon how incompatible they are, which seems
pretty sensible.

Thanks,
    Paul
