From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 6/7] arm64: Advertise ARM64_HAS_DCPODP cpu feature
Date: Wed, 3 Apr 2019 10:32:43 +0100
Message-ID: <20190403093242.GN3567@e103592.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-7-andrew.murray@arm.com>
 <20190402145958.GJ3567@e103592.cambridge.arm.com>
 <20190403092342.GI53702@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-101147-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20190403092342.GI53702@e119886-lin.cambridge.arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Phil Blundell <pb@pbcl.net>, libc-alpha@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 03, 2019 at 10:23:42AM +0100, Andrew Murray wrote:
> On Tue, Apr 02, 2019 at 03:59:58PM +0100, Dave Martin wrote:
> > On Mon, Apr 01, 2019 at 11:45:14AM +0100, Andrew Murray wrote:
> > > Advertise ARM64_HAS_DCPOP when both DC CVAP and DC CVADP are supported.
> > 
> > Do you mean ARM64_HAS_DCPODP?
> 
> Yes I did - good catch.
> 
> > 
> > And do we need this?  This capability flag doesn't currently appear to
> > be used for anything (which makes me wonder whether it _should_ be wired
> > up to something in the kernel).
> > 
> > Do we expect the kernel to do something special with this in the future?
> > 
> > OTOH, we get a nice printk when the feature is detected, and the code
> > size cost is insignificant.  So, if there's a reasonable expectation that
> > we will use it someday, I don't see a big problem with having it.
> 
> Yes it's not currently used, so I'm happy to drop this patch if people prefer
> that - however it does complement the existing DCPOP cap which is present.

OK, sounds fine.

Maybe add a note in the commit message that this is here for consistency
with DCPOP, and we anticipate it being used in the future.

Cheers
---Dave
