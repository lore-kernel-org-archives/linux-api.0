From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 2/7] arm64: HWCAP: add support for AT_HWCAP2
Date: Wed, 3 Apr 2019 10:35:35 +0100
Message-ID: <20190403093535.GO3567@e103592.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-3-andrew.murray@arm.com>
 <20190402145831.GI3567@e103592.cambridge.arm.com>
 <20190403083255.GG53702@e119886-lin.cambridge.arm.com>
 <20190403091118.GL3567@e103592.cambridge.arm.com>
 <20190403092951.GJ53702@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-101148-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20190403092951.GJ53702@e119886-lin.cambridge.arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Phil Blundell <pb@pbcl.net>, libc-alpha@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 03, 2019 at 10:29:52AM +0100, Andrew Murray wrote:
> On Wed, Apr 03, 2019 at 10:11:20AM +0100, Dave Martin wrote:
> > On Wed, Apr 03, 2019 at 09:32:55AM +0100, Andrew Murray wrote:
> > > On Tue, Apr 02, 2019 at 03:58:31PM +0100, Dave Martin wrote:

[...]

> > > > I wonder whether we can have a generic definition for this:
> > > > 
> > > > #define cpu_set_named_feature(x) (elf_hwcap |= HWCAP_ ## x)
> > > 
> > > You mean specific to arm32?
> > > 
> > > I will do this, along with a cpu_get_named_feature - but I think
> > > I'd prefer to do this in a separate series.
> > 
> > Yes, we could do that.  We could also do it more widely, but it's
> > probably not worth the overhead of doing it.
> 
> I had considered this as well but also determined that it wouldn't give
> much gain.

Yep, agreed.  It can always be done later if it turns out to be useful
for someone.

Cheers
---Dave
