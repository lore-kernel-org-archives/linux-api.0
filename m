Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886713;
	b=maxHZFrfDhG1MBOOXB148VP2K/7zpxy+zr8L1iyKOo50ln1KDLlSUTnJEDYponpROSIz
	 GlgYi8JhElCXWLmGTVeYJbM+7Rgw/HEyGppaKpjBOCPlURyLxBcnfMX6VUUTzXwvGoeI2
	 rAHwKqUcOm7tLA9mYzB09v/xZ/C4k0uW0DuT6kUJoVJxb2d5wgcW2pFlcWnBQwZhqo717
	 fEtXFpbva7OWQbcAwDx8Sjpt3E4PZ3Seq57CDP6iv+ixO/zpysMXewB/LkpNPLQthDJH5
	 pJd2ikWT5gsUH2rp3VIvPCopYd8MLgCjAzO11gaPTfvHpqty9YENq3a3+W9NZdPfSAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886713;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=jeG3y12HtFa7m8IvIKhqM9ur3tVT1kjPhMNf8HVLxi8=;
	b=dgmGv/OATO9RIva/1jEtgpyhR6OkLDbNrV+gnpFWKeXI4vAgT4fzr62Nv7uNli6wjjrc
	 C3hHFUPEQuLQtTrtnzS8OYmCK1jQtt8MiQlQhhbfdhhFpfzdcgR5qT82kqahHsI3aTES8
	 DvTVwR2WAnXJpfel2b4K6Klhc21d3qNp3WFtAVQIW8s0eKxPvo34Y5CAfAmKOCBt8D3GQ
	 0FmIqr0ryvlzNncRjmH1ZqA/4NyBloaeR5DKQUjlb/gwncEXKa3/p3PrS1J5G5B35ItnP
	 UMEYHDe1ULQozX2Ouy3vZUOcdPMt15BXx2okzxV0O27hG+xctRPcOQ50PfKbnXOcM7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=m+09lacs;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0E6606A328;
	Thu,  5 Nov 2026 13:51:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C0E6606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=m+09lacs
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 975371650;
	Thu,  5 Nov 2026 05:51:48 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 532CF3F628;
	Thu,  5 Nov 2026 05:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793886711; bh=h84UlwUJYAiqDq33RX39Hh2D1oEYdS7iW7dNb129dXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m+09lacsvQH6RHUHtbjlvSu27zPjooCxuMs6qDiflGnjn4Td/TYYUafIL8k4EYAXF
	 6ediJxrSXelxhGk1YIPGggBvbGC0ixvbbQaewIy+pOtbmJ19guvhIRcQFuracVXXk/
	 OZeo6y15VTgJCsrdOWjJ0R7OhFPrIqPJRjYl1Eq8=
Date: Thu, 5 Nov 2026 13:51:44 +0000
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
Message-ID: <auyJ8Nuvn0t2qj5w@e129823.arm.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-3-jiri@resnulli.us>
 <at-iEMxN98nie1Qr@e129823.arm.com>
 <auBaROC0XdWpILEI@FV6GYCPJ69>
 <20261027141524.GF1685504@ziepe.ca>
 <auC5sw9YMC9NO4wl@e129823.arm.com>
 <20261027151729.GG1685504@ziepe.ca>
 <auyAJ8OMWHUTCFKs@FV6GYCPJ69>
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
In-Reply-To: <auyAJ8OMWHUTCFKs@FV6GYCPJ69>

> Tue, Oct 27, 2026 at 04:17:29PM +0100, jgg@ziepe.ca wrote:
> >On Tue, Oct 27, 2026 at 02:48:19PM +0000, Yeoreum Yun wrote:
> >> > On Tue, Oct 27, 2026 at 09:02:14AM +0100, Jiri Pirko wrote:
> >> > > Mon, Oct 26, 2026 at 07:55:12PM +0100, yeoreum.yun@arm.com wrote:
> >> > > >[    3.856919]  ctlv_schema_check_attr+0x3dc/0x538
> >> > > >[    3.857105]  ctlv_schema_check_indexed_nest+0x788/0x958
> >> > > >[    3.857301]  ctlv_schema_validate+0x88/0x180
> >> > > >[    3.857482]  ctlv_msg_test_as_deep_as_the_core_allows+0x11c/0x1e8
> >> > > >[    3.857698]  kunit_try_run_case+0x64/0x188
> >> > > >[    3.857878]  kunit_generic_run_threadfn_adapter+0x30/0x68
> >> > > >[    3.858086]  kthread+0x10c/0x140
> >> > > >[    3.858245]  ret_from_fork+0x10/0x20
> >> > > >[    3.858398] SMP: stopping secondary CPUs
> >> > > >[    3.858630] Kernel Offset: disabled
> >> > > >[    3.858720] CPU features: 0x0,00000000,00b0802e,9f190bc3,2affe72f
> >> > > >[    3.858872] Memory Limit: none
> >> > > >[    3.858976] ---[ end Kernel panic - not syncing: kernel stack overflow ]---
> >> > > >
> >> > > >[...]
> >> > > >
> >> > > >I think it might be good to configurable according to architecture
> >> > > >unless it's not good to reduce the CTLV_MAX_NEST_DEPTH number
> >> > > >otherwise, increasing stack size when CTLV is enabled seems unresonable...
> >> > > 
> >> > > Agreed, will lower it down. I think we should be okay with 8 for start.
> >> > 
> >> > I'm surprised this ran out of stack though with even as few as
> >> > 32 levels.. Is there accidently something large on the stack?
> >> >
> >> 
> >> Nope.
> >> 
> >> When I see the each functions stack allocation:
> >> - ctlv_schema_check_indexed_nest():
> >> 	sub	sp, sp, #0xf0 // 240 bytes
> >> 
> >> - ctlv_schema_check_attr():
> >> 	sub	sp, sp, #0xb0 // 176 bytes
> >> 
> >> Roughly (240 + 176) * CTLV_MAX_NEST_DEPTH = 13,952 (around 14KB)
> >> consumed.
> >
> >400 bytes per nest seems pretty big to me...
> >
> >Do you have debug options enabled or something that increases stack usage?
> 
> KASAN is such an option. On arm64 with GCC 15, the stack protector and
> zero-initialized stack variables, ctlv_schema_check_indexed_nest() takes
> 208 bytes and ctlv_schema_check_attr() 144 without KASAN. With generic
> KASAN, which instruments the stack with GCC, they take 432 and 304: the
> redzones around every local whose address is taken more than double both
> frames. Your numbers are in between, I guess a different compiler or
> KASAN mode.
> 
> Otherwise there is nothing large on the stack. 96 of the 208 bytes hold
> the callee-saved registers, the rest are small locals and spills. It is
> just two frames per nesting level.
> With the limit lowered to 8, validation at the maximum depth takes about
> 3KB, about 6KB with generic KASAN.

TBH, I'm bit of surprised since I'm not using GENERIC option but with HW
(MTE). Do you mean this with KASAN HW_TAG?
might the GENERIC and SW_TAG would be, but I don't expected with HW_TAG.


-- 
Sincerely,
Yeoreum Yun
