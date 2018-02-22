From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 1/3] signal: Add FPE_FLTUNK si_code for undiagnosable
 fp exceptions
Date: Thu, 22 Feb 2018 12:14:17 +0000
Message-ID: <5A8EB419.1020508@arm.com>
References: <1519228960-10883-1-git-send-email-Dave.Martin@arm.com>
 <1519228960-10883-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1519228960-10883-2-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Will Deacon <will.deacon@arm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Hi Dave,

On 21/02/18 16:02, Dave Martin wrote:
> Some architectures cannot always report accurately what kind of
> floating-point exception triggered a floating-point exception trap.
> 
> This can occur with fp exceptions occuring on lanes in a vector

(Nit: occurring)

> instruction on arm64 for example.
> 
> Rather than have every architecture come up with its own way of
> descrbing such a condition, this patch adds a common FPE_FLTUNK do

(Nits: describing; 'to report')

> report that an fp exception caused a trap but we cannot be certain
> which kind of fp exception it was.


> diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
> index 85dc965..10304de 100644
> --- a/include/uapi/asm-generic/siginfo.h
> +++ b/include/uapi/asm-generic/siginfo.h
> @@ -229,7 +229,8 @@ typedef struct siginfo {
>  # define __FPE_INVASC	12	/* invalid ASCII digit */
>  # define __FPE_INVDEC	13	/* invalid decimal digit */
>  #endif
> -#define NSIGFPE		13
> +#define FPE_FLTUNK	14	/* undiagnosed floating-point exception */
> +#define NSIGFPE		14

It looks like x86's compat relies on this value not changing:
| arch/x86/kernel/signal_compat.c:        BUILD_BUG_ON(NSIGFPE  != 13);
| include/uapi/asm-generic/siginfo.h:#define NSIGFPE              13

(from v4.16-rc2)


Thanks,

James
