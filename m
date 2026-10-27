Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793116550;
	b=fuTbc4HWzHMY8nuujOywaGSqqHXk9AAoUlT9lyZTYxvjOVvVtBD502s3cSo8xOcut1cL
	 LqIU+hvNa0WhpOnNRZQ1RAobHMwPYbo3J+18/yKi1Kli+6NYTGgNG8b58+qWv3SpuNwsu
	 w30qNqslL4sumQTS5pUcIipN+UM4JjB4Kt50H5rPNH9YOfYsy3heIS0L/NvLW4zgqT8ki
	 EH6aO2g986blQEdIz+O5CrwC0yNNQFJLjKwbA5mNANiGimlA1mtUea0OF6lFZRJTpRctU
	 MGGij9c/tJKGpOHFCMYM+vZKFNpjL/zFM7hvr0NUvhCt/Ftk2RYLqcVftje0UIk3/iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793116550;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=X3nN5mvj2xSO5zsqyy9p2CSMqdWuPUqnZqJuz9RqDrs=;
	b=RRoo4zz6tNnvuqGXHJZ0sZHVVE9RtoFn6kf3lyqYc+UBU4eqOqKyXWZyHDsiNqpgi7/v
	 VhS2pjy6LNAHX0YFByiwUytyZrQBT6mHCTPs0XUbbnPneHddOs8aRWL7DP5SyLbcoXGRv
	 yryanfa5NwqGBJde5mtj9qzT9uZoe4VgYZah4Ak7deidSxYxPj84jpH7+q5N+bLtNbjjM
	 r9rFiHYJdd9zaxiNlBe1Dqkzt4fuSp/OG5VlVlncHuOkLVIc4LUrna91QhVavsCFaJOop
	 W/0++UTUS5+UwmZtoQkgRSJY/ISY0yGs2XUSx7+j00TzPinFXwcG6WMjeTcXmMZr/Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nUBsgUOc;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C95F606A31A;
	Tue, 27 Oct 2026 15:55:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C95F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nUBsgUOc
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFAA915A1;
	Tue, 27 Oct 2026 08:55:44 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99D3E3F59E;
	Tue, 27 Oct 2026 08:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793116548; bh=aFf9GgQhV3g+Yk+fBjBM9rXGTN5SLkr3sBqw5a3PzYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nUBsgUOcX9RBvoTqLb/e9N8C/nshHTMWHLcgb2RCIBaQ6+L1UA7ImCOoPnrvZ2uVX
	 YGfOvtGfcoPWnanfMPuSHX3TVjVeXvVEC+HOOS992L9SYpwvOnie9G3LEgT8Idi5B1
	 qMLFUQPRVx2zPKgX6I+K5/7t7JlqaYjRo2TnCD20=
Date: Tue, 27 Oct 2026 15:55:41 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jiri Pirko <jiri@resnulli.us>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 02/20] ctlv: Add the UAPI wire format and family API
Message-ID: <auDJfQz19ineLgvP@e129823.arm.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-3-jiri@resnulli.us>
 <at-iEMxN98nie1Qr@e129823.arm.com>
 <auBaROC0XdWpILEI@FV6GYCPJ69>
 <20261027141524.GF1685504@ziepe.ca>
 <auC5sw9YMC9NO4wl@e129823.arm.com>
 <20261027151729.GG1685504@ziepe.ca>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027151729.GG1685504@ziepe.ca>

On Tue, Oct 27, 2026 at 12:17:29PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 27, 2026 at 02:48:19PM +0000, Yeoreum Yun wrote:
> > > On Tue, Oct 27, 2026 at 09:02:14AM +0100, Jiri Pirko wrote:
> > > > Mon, Oct 26, 2026 at 07:55:12PM +0100, yeoreum.yun@arm.com wrote:
> > > > >[    3.856919]  ctlv_schema_check_attr+0x3dc/0x538
> > > > >[    3.857105]  ctlv_schema_check_indexed_nest+0x788/0x958
> > > > >[    3.857301]  ctlv_schema_validate+0x88/0x180
> > > > >[    3.857482]  ctlv_msg_test_as_deep_as_the_core_allows+0x11c/0x1e8
> > > > >[    3.857698]  kunit_try_run_case+0x64/0x188
> > > > >[    3.857878]  kunit_generic_run_threadfn_adapter+0x30/0x68
> > > > >[    3.858086]  kthread+0x10c/0x140
> > > > >[    3.858245]  ret_from_fork+0x10/0x20
> > > > >[    3.858398] SMP: stopping secondary CPUs
> > > > >[    3.858630] Kernel Offset: disabled
> > > > >[    3.858720] CPU features: 0x0,00000000,00b0802e,9f190bc3,2affe72f
> > > > >[    3.858872] Memory Limit: none
> > > > >[    3.858976] ---[ end Kernel panic - not syncing: kernel stack overflow ]---
> > > > >
> > > > >[...]
> > > > >
> > > > >I think it might be good to configurable according to architecture
> > > > >unless it's not good to reduce the CTLV_MAX_NEST_DEPTH number
> > > > >otherwise, increasing stack size when CTLV is enabled seems unresonable...
> > > > 
> > > > Agreed, will lower it down. I think we should be okay with 8 for start.
> > > 
> > > I'm surprised this ran out of stack though with even as few as
> > > 32 levels.. Is there accidently something large on the stack?
> > >
> > 
> > Nope.
> > 
> > When I see the each functions stack allocation:
> > - ctlv_schema_check_indexed_nest():
> > 	sub	sp, sp, #0xf0 // 240 bytes
> > 
> > - ctlv_schema_check_attr():
> > 	sub	sp, sp, #0xb0 // 176 bytes
> > 
> > Roughly (240 + 176) * CTLV_MAX_NEST_DEPTH = 13,952 (around 14KB)
> > consumed.
> 
> 400 bytes per nest seems pretty big to me...
> 
> Do you have debug options enabled or something that increases stack usage?

Actually not, I've used the distribution's Kconfig e.g) ubuntu
+ KSASN.

So, It doesn't seems from side-effect from debug options.

-- 
Sincerely,
Yeoreum Yun
