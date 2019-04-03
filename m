From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v3 2/7] arm64: HWCAP: add support for AT_HWCAP2
Date: Wed, 3 Apr 2019 10:29:52 +0100
Message-ID: <20190403092951.GJ53702@e119886-lin.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-3-andrew.murray@arm.com>
 <20190402145831.GI3567@e103592.cambridge.arm.com>
 <20190403083255.GG53702@e119886-lin.cambridge.arm.com>
 <20190403091118.GL3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-101146-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20190403091118.GL3567@e103592.cambridge.arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Phil Blundell <pb@pbcl.net>, libc-alpha@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 03, 2019 at 10:11:20AM +0100, Dave Martin wrote:
> On Wed, Apr 03, 2019 at 09:32:55AM +0100, Andrew Murray wrote:
> > On Tue, Apr 02, 2019 at 03:58:31PM +0100, Dave Martin wrote:
> > > On Mon, Apr 01, 2019 at 11:45:10AM +0100, Andrew Murray wrote:
> 
> [...]
> 
> > > > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> > > > index aa4ec53281ce..6cc8aff83805 100644
> > > > --- a/drivers/clocksource/arm_arch_timer.c
> > > > +++ b/drivers/clocksource/arm_arch_timer.c
> > > > @@ -833,7 +833,11 @@ static void arch_timer_evtstrm_enable(int divider)
> > > >  	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
> > > >  			| ARCH_TIMER_VIRT_EVT_EN;
> > > >  	arch_timer_set_cntkctl(cntkctl);
> > > > +#ifdef CONFIG_ARM64
> > > > +	cpu_set_named_feature(EVTSTRM);
> > > > +#else
> > > >  	elf_hwcap |= HWCAP_EVTSTRM;
> > > > +#endif
> > > 
> > > I wonder whether we can have a generic definition for this:
> > > 
> > > #define cpu_set_named_feature(x) (elf_hwcap |= HWCAP_ ## x)
> > 
> > You mean specific to arm32?
> > 
> > I will do this, along with a cpu_get_named_feature - but I think I'd prefer
> > to do this in a separate series.
> 
> Yes, we could do that.  We could also do it more widely, but it's
> probably not worth the overhead of doing it.

I had considered this as well but also determined that it wouldn't give
much gain.

Thanks,

Andrew Murray

> 
> [...]
> 
> Cheers
> ---Dave
