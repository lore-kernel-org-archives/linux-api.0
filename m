From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC PATCH] UAPI: Document auxvec AT_* namespace policy and note
 reservations
Date: Wed, 16 May 2018 19:21:16 -0400
Message-ID: <20180516232116.GB1392@brightrain.aerifal.cx>
References: <1526480447-18185-1-git-send-email-Dave.Martin@arm.com>
 <20180516152913.GY1392@brightrain.aerifal.cx>
 <20180516154957.GT7753@e103592.cambridge.arm.com>
 <3e291fda-b27b-7002-9374-23196f18a38f@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3e291fda-b27b-7002-9374-23196f18a38f@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Palmer Dabbelt <pal>
List-Id: linux-api@vger.kernel.org

On Wed, May 16, 2018 at 04:09:29PM -0700, H. Peter Anvin wrote:
> On 05/16/18 08:49, Dave Martin wrote:
> > 
> > Since <linux/auxvec.h> only contains #defines, it may be enough for arch
> > <asm/auxvec.h> headers to include <linux/auxvec.h>.
> > 
> 
> <asm/auxvec.h> doesn't seem to have any reason to exist at all. If
> anyone includes it now, they are Doing It Wrong[TM] since
> <linux/auxvec.h> includes <asm/auxvec.h>.

Sounds good. BTW there probably does need to be a check for
kernel-internal use of #ifdef AT_* etc. I saw some instances in
arch/um and a few other weird places. They might not matter but there
might be code that's indirectly enabled only for certain archs via the
AT_* macros.

Rich
