Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897622;
	b=AhoPdG2W8mr0LRByrPtGxuS3nDVNDe6FhBSmN4J4470Y4nk0rs9rHyZI2Ue+1992mWG/
	 ng8mE6m7dxFhiurj2xkYcRrPv4SCpEon02aURJBAlJ+k11eokDFRoYTuwuUaBw2F+8+Wn
	 Qea5dR1cPMtroI0Wo4FsSaOjyo2vUG+LwbIvaimtx7lqZHb0tLYVk+tMY/ex6AdXMiJB6
	 cexPJ9vO8QYgorAYNDcYKblEZWWCDJD8rVSmctGk0gohXW8gWjPeFfZhYXMoIa/mlOUAZ
	 8sG5usvv2Wo5RVfO7oycx66mixRlgjK7XJHTKt+T1RuvOQtzzY+RDcPb9m5ECpZg5KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897622;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=FnB6ScYt0UJ+tH3MyOUVNV1BCySchRfbtW7QyFys1DY=;
	b=4p5LPKVjKx0y8Jfr6kylrsL5v3Srv39JPDLo8jxsUUt52aFVxBrQSrgTTcjpzEJvAHVX
	 W/l6iwoVoRTy5pbMzm9UCjLqM0K9swmgjmpKLMcIjF+xRoIUeP8jYOKqomMioMG5gJQ9j
	 6JsUpIOX1UtKHtZFKSROybOtsdui6ZaVcaFdBWR9CL2R7ZnBvo3PKOkz6a/PxUwZkQKuK
	 6NwCrPxbHkaa3c/rbiQCsbmcmEIYyCLKqLJA2U0N77rFoBcClRQacaPYC6vBV+oyuSRPr
	 W3sig8PJe+pD2nRUKWL4cVRMUKFL/yNpCWdClKYvHPj91ybL8w2wi2WgUfm77RNkQYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98884606A32E;
	Thu,  5 Nov 2026 16:53:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98884606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8DE51684;
	Thu,  5 Nov 2026 08:53:32 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 282963F632;
	Thu,  5 Nov 2026 08:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793897615; bh=gens9hPKGA5ELjldl6EH1n02/4cZLP/+KLPJ6OG+Fkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BNBjlWWZxPk/3OjZlelVp0O3zZXCm69B3ls9RYBpwR7Ml6GZW3+6kNE55iqdThxI1
	 19eVBTIJJP9nuQSpyr/ZvhHC4YD1IFyXPLmmhs0yYOiRokyEos3nbx9i9FaL2L0pQ4
	 vCEg18tG2S3UK1ZSEiiYqU9kdbxOV8dQM7pM4gX8=
Date: Thu, 5 Nov 2026 16:53:29 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yeoreum Yun <yeoreum.yun@arm.com>,
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
Message-ID: <auy0iXpFEcVoHBOC@e129823.arm.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-3-jiri@resnulli.us>
 <at-iEMxN98nie1Qr@e129823.arm.com>
 <auBaROC0XdWpILEI@FV6GYCPJ69>
 <20261027141524.GF1685504@ziepe.ca>
 <auC5sw9YMC9NO4wl@e129823.arm.com>
 <20261027151729.GG1685504@ziepe.ca>
 <auyAJ8OMWHUTCFKs@FV6GYCPJ69>
 <auyJ8Nuvn0t2qj5w@e129823.arm.com>
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
In-Reply-To: <auyJ8Nuvn0t2qj5w@e129823.arm.com>

On Thu, Nov 05, 2026 at 01:51:44PM +0000, Yeoreum Yun wrote:
> > Tue, Oct 27, 2026 at 04:17:29PM +0100, jgg@ziepe.ca wrote:
> > >On Tue, Oct 27, 2026 at 02:48:19PM +0000, Yeoreum Yun wrote:
> > >> > On Tue, Oct 27, 2026 at 09:02:14AM +0100, Jiri Pirko wrote:
> > >> > > Mon, Oct 26, 2026 at 07:55:12PM +0100, yeoreum.yun@arm.com wrote:
> > >> > > >[    3.856919]  ctlv_schema_check_attr+0x3dc/0x538
> > >> > > >[    3.857105]  ctlv_schema_check_indexed_nest+0x788/0x958
> > >> > > >[    3.857301]  ctlv_schema_validate+0x88/0x180
> > >> > > >[    3.857482]  ctlv_msg_test_as_deep_as_the_core_allows+0x11c/0x1e8
> > >> > > >[    3.857698]  kunit_try_run_case+0x64/0x188
> > >> > > >[    3.857878]  kunit_generic_run_threadfn_adapter+0x30/0x68
> > >> > > >[    3.858086]  kthread+0x10c/0x140
> > >> > > >[    3.858245]  ret_from_fork+0x10/0x20
> > >> > > >[    3.858398] SMP: stopping secondary CPUs
> > >> > > >[    3.858630] Kernel Offset: disabled
> > >> > > >[    3.858720] CPU features: 0x0,00000000,00b0802e,9f190bc3,2affe72f
> > >> > > >[    3.858872] Memory Limit: none
> > >> > > >[    3.858976] ---[ end Kernel panic - not syncing: kernel stack overflow ]---
> > >> > > >
> > >> > > >[...]
> > >> > > >
> > >> > > >I think it might be good to configurable according to architecture
> > >> > > >unless it's not good to reduce the CTLV_MAX_NEST_DEPTH number
> > >> > > >otherwise, increasing stack size when CTLV is enabled seems unresonable...
> > >> > > 
> > >> > > Agreed, will lower it down. I think we should be okay with 8 for start.
> > >> > 
> > >> > I'm surprised this ran out of stack though with even as few as
> > >> > 32 levels.. Is there accidently something large on the stack?
> > >> >
> > >> 
> > >> Nope.
> > >> 
> > >> When I see the each functions stack allocation:
> > >> - ctlv_schema_check_indexed_nest():
> > >> 	sub	sp, sp, #0xf0 // 240 bytes
> > >> 
> > >> - ctlv_schema_check_attr():
> > >> 	sub	sp, sp, #0xb0 // 176 bytes
> > >> 
> > >> Roughly (240 + 176) * CTLV_MAX_NEST_DEPTH = 13,952 (around 14KB)
> > >> consumed.
> > >
> > >400 bytes per nest seems pretty big to me...
> > >
> > >Do you have debug options enabled or something that increases stack usage?
> > 
> > KASAN is such an option. On arm64 with GCC 15, the stack protector and
> > zero-initialized stack variables, ctlv_schema_check_indexed_nest() takes
> > 208 bytes and ctlv_schema_check_attr() 144 without KASAN. With generic
> > KASAN, which instruments the stack with GCC, they take 432 and 304: the
> > redzones around every local whose address is taken more than double both
> > frames. Your numbers are in between, I guess a different compiler or
> > KASAN mode.
> > 
> > Otherwise there is nothing large on the stack. 96 of the 208 bytes hold
> > the callee-saved registers, the rest are small locals and spills. It is
> > just two frames per nesting level.
> > With the limit lowered to 8, validation at the maximum depth takes about
> > 3KB, about 6KB with generic KASAN.
> 
> TBH, I'm bit of surprised since I'm not using GENERIC option but with HW
> (MTE). Do you mean this with KASAN HW_TAG?
> might the GENERIC and SW_TAG would be, but I don't expected with HW_TAG.

JFYI, When I check again without KASAN HW_TAG and clang-23:

  ctlv_schema_check_indexed_nest() -> 240 bytes
  ctlv_schema_check_attr() -> 176 bytes

This is no difference with KASAN HW_TAG.

Anyway, limit depth to 8 seems valid for me.

Thanks!

-- 
Sincerely,
Yeoreum Yun
