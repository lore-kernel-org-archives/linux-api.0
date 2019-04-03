From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v4 5/6] arm64: add CVADP support to the cache maintenance
 helper
Date: Wed, 3 Apr 2019 14:21:47 +0100
Message-ID: <20190403132147.GT3567@e103592.cambridge.arm.com>
References: <20190403105628.39798-1-andrew.murray@arm.com>
 <20190403105628.39798-6-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-101161-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20190403105628.39798-6-andrew.murray@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Phil Blundell <pb@pbcl.net>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 03, 2019 at 11:56:27AM +0100, Andrew Murray wrote:
> Allow users of dcache_by_line_op to specify cvadp as an op.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/include/asm/assembler.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index c5308d01e228..d50caf0e6b64 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -407,10 +407,14 @@ alternative_endif
>  	.ifc	\op, cvap
>  	sys	3, c7, c12, 1, \kaddr	// dc cvap
>  	.else
> +	.ifc	\op, cvadp
> +	sys	3, c7, c13, 1, \kaddr	// dc cvadp
> +	.else
>  	dc	\op, \kaddr
>  	.endif
>  	.endif
>  	.endif
> +	.endif

This is a bit annoying, but short of moving this .if chain into a
separate macro and doing something like:

	.ifc	\op, cvap
	sys	3, c7, c12, 1, \kaddr	// dc cvap
	.exitm
	.endif

	.ifc	\op, cvadp
	sys	3, c7, c12, 1, \kaddr	// dc cvap
	.exitm
	.endif

	// ...

I don't see an obvious fix.  For now, this seems like overkill...


Anyway, with the patch as-is:

Reviewed-by: Dave Martin <Dave.Martin@arm.com>


It's logical to have dcache_by_line_op understanding cvadp, even if we
don't use it yet.

Cheers
---Dave
