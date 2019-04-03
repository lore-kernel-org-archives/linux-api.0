From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 3/7] arm64: HWCAP: encapsulate elf_hwcap
Date: Wed, 3 Apr 2019 10:13:21 +0100
Message-ID: <20190403091320.GM3567@e103592.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-4-andrew.murray@arm.com>
 <20190402145821.GH3567@e103592.cambridge.arm.com>
 <20190402150654.GD53702@e119886-lin.cambridge.arm.com>
 <8f47d948-e5cd-68ab-b340-d40d3b11a3f5@arm.com>
 <20190402155558.GK3567@e103592.cambridge.arm.com>
 <20190403085326.GH53702@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-101144-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20190403085326.GH53702@e119886-lin.cambridge.arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, mark.rutland@arm.com, libc-alpha@sourceware.org, Szabolcs.Nagy@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, pb@pbcl.net, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 03, 2019 at 09:53:26AM +0100, Andrew Murray wrote:
> On Tue, Apr 02, 2019 at 04:55:58PM +0100, Dave Martin wrote:
> > On Tue, Apr 02, 2019 at 04:32:57PM +0100, Suzuki K Poulose wrote:

[...]

> > > nit:
> > > 
> > > As mentioned above we have "cpu_hwcaps" for the features only internally
> > > by the kernel. Naming it "kernel_hwcap" kind of looses the hint that the
> > > major purpose is for userspace consumption and could easily confuse with
> > > the poorly named "cpu_hwcaps" which should have been called kernel_hwcaps.
> > > 
> > > How about "user_hwcaps" ? Or preferrably something closer to that.
> > 
> > Yes, that may be better.
> > 
> > Of course, we also have this naming in all the KERNEL_HWCAP #defined now.
> > 
> > Since kernel_hwcap is just a static variable now, maybe it's sufficient
> > to stick a comment next to it explaining what it is (and what it isn't).
> > "user_hwcaps" still implies that this might be the userspace view of the
> > flags, which it isn't.
> > 
> > But I don't feel strongly about this.  If someone wants to make a
> > decision, I'm happy to defer to it.
> 
> I think changing the name will cause more confusion - there isn't an obvious
> name for it and needing a comment to explain it hints that this may not be
> the best approach. As it's a static variable with only 4 uses in the same
> file it should be pretty clear to anyone interested. Also keeping the same
> name will help users find it and understand how it has changed if they
> incorrectly attempt to use it by setting/testing bits on it.
> 
> Afterall the elf_hwcap variable does still hold the elf_hwcap bits and it's
> obtained by cpu_get_elf_hwcap. The naming of KERNEL_HWCAP also makes sense
> in this context.
> 
> Perhaps a better name would be something like elf_hwcaps implying that there
> is some mapping required (though this would only last until we run out of
> space in it and need another one).
> 
> Shall we stick with what we have?

I'm happy enough with what you propose: I agree, there's not an
obviously a better name, and now that this is local, the scope for
confusion is lessened.  So, add a comment, but keep whetever name you're
happy with.

Cheers
---Dave
