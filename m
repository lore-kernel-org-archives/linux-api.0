From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v3 6/7] arm64: Advertise ARM64_HAS_DCPODP cpu feature
Date: Wed, 3 Apr 2019 10:57:12 +0100
Message-ID: <20190403095711.GK53702@e119886-lin.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-7-andrew.murray@arm.com>
 <20190402145958.GJ3567@e103592.cambridge.arm.com>
 <20190403092342.GI53702@e119886-lin.cambridge.arm.com>
 <20190403093242.GN3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190403093242.GN3567@e103592.cambridge.arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Phil Blundell <pb@pbcl.net>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 03, 2019 at 10:32:43AM +0100, Dave Martin wrote:
> On Wed, Apr 03, 2019 at 10:23:42AM +0100, Andrew Murray wrote:
> > On Tue, Apr 02, 2019 at 03:59:58PM +0100, Dave Martin wrote:
> > > On Mon, Apr 01, 2019 at 11:45:14AM +0100, Andrew Murray wrote:
> > > > Advertise ARM64_HAS_DCPOP when both DC CVAP and DC CVADP are supported.
> > > 
> > > Do you mean ARM64_HAS_DCPODP?
> > 
> > Yes I did - good catch.
> > 
> > > 
> > > And do we need this?  This capability flag doesn't currently appear to
> > > be used for anything (which makes me wonder whether it _should_ be wired
> > > up to something in the kernel).
> > > 
> > > Do we expect the kernel to do something special with this in the future?
> > > 
> > > OTOH, we get a nice printk when the feature is detected, and the code
> > > size cost is insignificant.  So, if there's a reasonable expectation that
> > > we will use it someday, I don't see a big problem with having it.
> > 
> > Yes it's not currently used, so I'm happy to drop this patch if people prefer
> > that - however it does complement the existing DCPOP cap which is present.
> 
> OK, sounds fine.
> 
> Maybe add a note in the commit message that this is here for consistency
> with DCPOP, and we anticipate it being used in the future.

OK thanks,

Andrew Murray

> 
> Cheers
> ---Dave
