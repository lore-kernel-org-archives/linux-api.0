From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC PATCH 1/2] arm64: fpsimd: Fix bad si_code for undiagnosed SIGFPE
Date: Mon, 22 Jan 2018 15:13:08 -0600
Message-ID: <878tcp8umz.fsf@xmission.com>
References: <1516623798-25001-1-git-send-email-Dave.Martin@arm.com>
        <1516623798-25001-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1516623798-25001-2-git-send-email-Dave.Martin@arm.com> (Dave
        Martin's message of "Mon, 22 Jan 2018 12:23:17 +0000")
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Russell King <linux@armlinux.org.uk>
List-Id: linux-api@vger.kernel.org


> diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
> index e447283..77edb00 100644
> --- a/include/uapi/asm-generic/siginfo.h
> +++ b/include/uapi/asm-generic/siginfo.h
> @@ -193,7 +193,8 @@ typedef struct siginfo {
>  #define FPE_FLTRES	6	/* floating point inexact result */
>  #define FPE_FLTINV	7	/* floating point invalid operation */
>  #define FPE_FLTSUB	8	/* subscript out of range */
> -#define NSIGFPE		8
> +#define FPE_UNKNOWN	9	/* undiagnosed floating-point exception */
> +#define NSIGFPE		9

Minor nit here.

At least before this is final I would really appreciate if you could
rebase this on top of my unificiation of siginfo.h that I posted on
linux-arch and is in my siginfo-next branch.

As that already pushes NSIGFPE up to 13.

Which would make this patch change NSIGFPE to 14 and allocate the number
14 for FPE_UNKNOWN

Eric
