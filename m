From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH for 5.2 08/10] rseq/selftests: aarch64 code
 signature: handle big-endian environment
Date: Wed, 24 Apr 2019 17:45:37 +0100
Message-ID: <20190424164536.GE21101@lakrids.cambridge.arm.com>
References: <20190424152502.14246-1-mathieu.desnoyers@efficios.com>
 <20190424152502.14246-9-mathieu.desnoyers@efficios.com>
 <20190424164032.GD21101@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190424164032.GD21101@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 24, 2019 at 05:40:33PM +0100, Mark Rutland wrote:
> On Wed, Apr 24, 2019 at 11:25:00AM -0400, Mathieu Desnoyers wrote:
> > +/*
> > + * aarch64 -mbig-endian generates mixed endianness code vs data:
> > + * little-endian code and big-endian data. Ensure the RSEQ_SIG signature
> > + * matches code endianness.
> > + */
> > +#define RSEQ_SIG_CODE	0xd428bc00	/* BRK #0x45E0.  */
> > +
> > +#ifdef __AARCH64EB__
> > +#define RSEQ_SIG_DATA	0x00bc28d4	/* BRK #0x45E0.  */
> > +#else
> > +#define RSEQ_SIG_DATA	RSEQ_SIG_CODE
> > +#endif
> > +
> > +#define RSEQ_SIG	RSEQ_SIG_DATA
> >  
> >  #define rseq_smp_mb()	__asm__ __volatile__ ("dmb ish" ::: "memory")
> >  #define rseq_smp_rmb()	__asm__ __volatile__ ("dmb ishld" ::: "memory")
> > @@ -121,7 +134,7 @@ do {										\
> >  
> >  #define RSEQ_ASM_DEFINE_ABORT(label, abort_label)				\
> >  	"	b	222f\n"							\
> > -	"	.inst 	"	__rseq_str(RSEQ_SIG) "\n"			\
> > +	"	.inst 	"	__rseq_str(RSEQ_SIG_CODE) "\n"			\
> 
> I don't think this is right; the .inst directive _should_ emit the value
> in the instruction stream endianness (i.e. LE, regardless of the data
> endianness).

Now I see the RSEQ_CODE value isn't endian-swapped as teh RSEQ_DATA
value is, so the code above is fine.

Sory for the noise.

Thanks,
Mark.
