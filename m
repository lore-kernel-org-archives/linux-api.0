From: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: [PATCH v3 26/28] arm64/sve: Add documentation
Date: Wed, 11 Oct 2017 10:50:16 +0100
Message-ID: <59DDE958.4080605@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com> <1507660725-7986-27-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-27-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: nd@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Alan Hayward <alan.hayward@arm.com>
List-Id: linux-api@vger.kernel.org

On 10/10/17 19:38, Dave Martin wrote:
> This patch adds basic documentation of the user/kernel interface
> provided by the for SVE.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Alex Bennée <alex.bennee@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alan Hayward <alan.hayward@arm.com>
> 
> ---
> 
> Changes since v2
> ----------------
> 
> Changes requested by Alan Hayward:
> 
>  * Added a note that the caller of PTRACE_SETREGSET will need to do a
>    GETREGSET if complete certainty about the resulting VL is desired.
> 
> ABI changes:
> 
>  * Documented the changed return value value semantics for PR_SET_SET_VL
>    when the PR_SVE_SET_VL_ONEXEC flag is passed.
> ---
...
> +prctl(PR_SVE_SET_VL, unsigned long arg)
> +
> +    Sets the vector length of the calling thread and related flags, where
> +    arg == vl | flags.
> +
> +    vl is the desired vector length, where sve_vl_valid(vl) must be true.
> +
> +    flags:
> +
> +	PR_SVE_SET_VL_INHERIT
> +
> +	    Inherit the current vector length across execve().  Otherwise, the
> +	    vector length is reset to the system default at execve().  (See
> +	    Section 9.)
> +
> +	PR_SVE_SET_VL_ONEXEC
> +
> +	    Defer the requested vector length change until the next execve().
> +	    This allows launching of a new program with a different vector
> +	    length, while avoiding runtime side effects in the caller.
> +
> +	    This also overrides the effect of PR_SVE_SET_VL_INHERIT for the
> +	    first execve().
> +
> +	    Without PR_SVE_SET_VL_ONEXEC, any outstanding deferred vector
> +	    length change is cancelled.
> +

"next execve" is still ambiguous. (execve has process
global effect so it may plausibly mean next in the
process or next in the calling thread)

"any outstanding deferred vector length change" is
ambiguous. (it may be for all threads in a process or
in the calling thread only)

> +    Return value: a nonnegative on success, or a negative value on error:
> +	EINVAL: SVE not supported, invalid vector length requested, or
> +	    invalid flags.
> +
> +    On success, the calling thread's vector length is changed to the largest
> +    value supported by the system that is less than or equal to vl.
> +    If vl == SVE_VL_MAX, the calling thread's vector length is changed to the
> +    largest value supported by the system.
> +
> +    The returned value describes the resulting configuration, encoded as for
> +    PR_SVE_GET_VL.  The vector length reported in this value is the new current
> +    vector length for this thread if PR_SVE_SET_VL_ONEXEC was not passed in the
> +    input arg; otherwise, the reported vector length is the deferred vector
> +    length that will be applied at the next exec.
> +
...
> +9.  System runtime configuration
> +--------------------------------
> +
> +* To mitigate the ABI impact of expansion of the signal frame, a policy
> +  mechanism is provided for administrators, distro maintainers and developers
> +  to set the default vector length for userspace processes:
> +
> +/proc/cpu/sve_default_vector_length
> +

still wrong.
