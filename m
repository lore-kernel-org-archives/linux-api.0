From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 26/28] arm64/sve: Add documentation
Date: Fri, 13 Oct 2017 18:17:59 +0100
Message-ID: <20171013171758.GO19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-27-git-send-email-Dave.Martin@arm.com>
 <20171013142421.j32jzisukewxtosx@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171013142421.j32jzisukewxtosx@armageddon.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Alan Hayward <alan.hayward@arm.com>, linux-api@vger.kernel.org, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 13, 2017 at 03:24:21PM +0100, Catalin Marinas wrote:
> On Tue, Oct 10, 2017 at 07:38:43PM +0100, Dave P Martin wrote:
> > +4.  Signal handling
> > +-------------------
> > +
> > +* A new signal frame record sve_context encodes the SVE registers on signal
> > +  delivery. [1]
> > +
> > +* This record is supplementary to fpsimd_context.  The FPSR and FPCR registers
> > +  are only present in fpsimd_context.  For convenience, the content of V0..V31
> > +  is duplicated between sve_context and fpsimd_context.
> > +
> > +* The signal frame record for SVE always contains basic metadata, in particular
> > +  the thread's vector length (in sve_context.vl).
> > +
> > +* The SVE registers may or may not be included in the record, depending on
> > +  whether the registers are live for the thread.  The registers are present if
> > +  and only if:
> > +  sve_context.head.size >= SVE_SIG_CONTEXT_SIZE(sve_vq_from_vl(sve_context.vl)).
> > +
> > +* If the registers are present, the remainder of the record has a vl-dependent
> > +  size and layout.  Macros SIG_SVE_* are defined [1] to facilitate access to
> > +  the members.
> 
> s/SIG_SVE_/SVE_SIG_/

Oops, good spot.  Fixed.

> > +* If the SVE context is too big to fit in sigcontext.__reserved[], then extra
> > +  space is allocated on the stack, an extra_context record is written in
> > +  __reserved[] referencing this space.  sve_context is then written in the
> > +  extra space.  Refer to [1] for further details about this mechanism.
> 
> Does this document require that the user stack is sufficiently large or
> should we cap the vector length (prior to the last two RFC patches)?

We don't know how much free stack space there actually is until the
signal is delivered.

If the initial user stack at process startup is <8K the user process has
more serious problems than can be solved by clamping the vector length.

After process startup we are committed to some VL, and silently clamping
it at signal delivery time is a potential programmer's model / ABI break
... there would be no guaranteed way to return from the signal handler
successfully.  That may not be what you meant though ...?

In the sigaltstack() case we do know how much space there is in advance,
but at the time of a sigaltstack() call if any, we may be still be
committed to some VL.  The thread is allowed to assume the VL is
unchanged across syscalls even though the SVE register data is not
guaranteed to be preserved.

Possibly sigaltstack() should fail with ENOMEM if ss_size is too small
for the maximum VL supported by the system, but strictly speaking that
violates POSIX if ss_size >= MINSIGSTKSZ.  Also, knowing that the stack
is big enough for the kernel-generated still doesn't guarantee that
the handler's own stack needs are satisfied, so this check is of
limited use.


So, my current policy is an extension of the existing one: the stack
must have enough space for the signal frame, or attempted signal
delivery will SEGV the task -- the kernel doesn't try to work around
this in advance.

This isn't fantastic, but I haven't come up with a better answer so far.
I'm open to ideas :)

> > +
> > +
> > +5.  Signal return
> > +-----------------
> > +
> > +When returning from a signal handler:
> > +
> > +* If there is no sve_context record in the signal frame, or if the record is
> > +  present but contains no register data as desribed in the previous section,
> > +  then the SVE registers/bits become non-live and take unspecified values.
> > +
> > +* If sve_context is present in the signal frame and contains full register
> > +  data, the SVE registers become live and are populated with the specified
> > +  data.  However, for backward compatibility reasons, bits [127:0] of Z0..Z31
> > +  are always restored from the corresponding members of fpsimd_context.vregs[]
> > +  and not from sve_context.  The remaining bits are restored from sve_context.
> > +
> > +* Inclusion of fpsimd_context in the signal frame remains mandatory,
> > +  irrespective of whether sve_context is present or not.
> 
> Could we relax this? I'm not sure it's worth it.

It would be cleaner, but I think it's an ABI break.  Consider a non-SVE
program that gets linked (perhaps dynamically) against a library variant
that happens to use SVE:


void segv_handler(...)
{
	/* examine signal frame FPSIMD_MAGIC to print a crash dump */
}

void f(double d, double *p)
{
	some_library_function_that_uses_sve_internally();
	*p = d;
}


segv_handler() could previously safely assume that the FPSIMD_MAGIC block
was present in the frame and may now just crash or print garbage if this
block isn't found.  But even if it does fail safe, functionality is lost
-- the crash dump cannot now include the value of d becuase the non-SVE-
aware main program doesn't know how to fish it out of the signal frame.

I would be all in favour of getting rid of FPSIMD_MAGIC in this instance
and avoiding the duplication and awkward sigreturn semantics, but I
don't see how we would get away with it without breaking existing
software.

Cheers
---Dave
