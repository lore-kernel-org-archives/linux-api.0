From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 26/28] arm64/sve: Add documentation
Date: Fri, 13 Oct 2017 15:24:21 +0100
Message-ID: <20171013142421.j32jzisukewxtosx@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-27-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-27-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Richard Sandiford <richard.sandiford@arm.com>, linux-api@vger.kernel.org, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: linux-api@vger.kernel.org

On Tue, Oct 10, 2017 at 07:38:43PM +0100, Dave P Martin wrote:
> +4.  Signal handling
> +-------------------
> +
> +* A new signal frame record sve_context encodes the SVE registers on signal
> +  delivery. [1]
> +
> +* This record is supplementary to fpsimd_context.  The FPSR and FPCR registers
> +  are only present in fpsimd_context.  For convenience, the content of V0..V31
> +  is duplicated between sve_context and fpsimd_context.
> +
> +* The signal frame record for SVE always contains basic metadata, in particular
> +  the thread's vector length (in sve_context.vl).
> +
> +* The SVE registers may or may not be included in the record, depending on
> +  whether the registers are live for the thread.  The registers are present if
> +  and only if:
> +  sve_context.head.size >= SVE_SIG_CONTEXT_SIZE(sve_vq_from_vl(sve_context.vl)).
> +
> +* If the registers are present, the remainder of the record has a vl-dependent
> +  size and layout.  Macros SIG_SVE_* are defined [1] to facilitate access to
> +  the members.

s/SIG_SVE_/SVE_SIG_/

> +
> +* If the SVE context is too big to fit in sigcontext.__reserved[], then extra
> +  space is allocated on the stack, an extra_context record is written in
> +  __reserved[] referencing this space.  sve_context is then written in the
> +  extra space.  Refer to [1] for further details about this mechanism.

Does this document require that the user stack is sufficiently large or
should we cap the vector length (prior to the last two RFC patches)?

> +
> +
> +5.  Signal return
> +-----------------
> +
> +When returning from a signal handler:
> +
> +* If there is no sve_context record in the signal frame, or if the record is
> +  present but contains no register data as desribed in the previous section,
> +  then the SVE registers/bits become non-live and take unspecified values.
> +
> +* If sve_context is present in the signal frame and contains full register
> +  data, the SVE registers become live and are populated with the specified
> +  data.  However, for backward compatibility reasons, bits [127:0] of Z0..Z31
> +  are always restored from the corresponding members of fpsimd_context.vregs[]
> +  and not from sve_context.  The remaining bits are restored from sve_context.
> +
> +* Inclusion of fpsimd_context in the signal frame remains mandatory,
> +  irrespective of whether sve_context is present or not.

Could we relax this? I'm not sure it's worth it.

-- 
Catalin
