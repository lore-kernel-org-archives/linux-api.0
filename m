Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793110528;
	b=5nFTcN5rssN+vcCArjf21SWXsdPmKmfD8HecC4JpnANUzXrC3aDw6O6mzI76lAB/CFGu
	 j1dBKna9lA0914mDyd8pEMeZSA1VbIPd+G56AU2lRsE0ntfYPJ6CrojOBsI+fb0TiQaa5
	 ihFFMis8PntwMWuWLTPuoQsdehiZYCXIn361hnK+TjYDqda43yp7uMmjoX6KhcHU5p8C2
	 qSsr13xwU75cyW7jFsAYAR532iYSdr0WFiNLXFvPs7IQD1vAmle9DAEgXzRQfUacSl5HP
	 6uiwD0udrjqRABMDpHvCyaHyeMi5INZYsyJ818mVXNUPSTpFwU/bog1CPsS58Sc+5iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793110528;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=zUsMbjO3gCQtUvLruyRuDb07/mulBS+KPR/B4sl8JQg=;
	b=mzuuDvtUHBzh4JXqc32tnYyZF9qO7EaSmpdAmDootsYap9OoyewNpOWXrYv4qwQQE7r4
	 JOP20zfNxpHwlUhvHsbQSY8/4zOjAt6qs/yWoz5snBSS51DwfH4r3SXtbRe/C6pSWpi4w
	 2yjIQKH+SfIUAAeF5fcnXxfU0EZkfJbHgrt2Ikjc3FWDNlCCgbBh+b5vWSRFJFsIVRN0r
	 kw4AOys98q8U+6DWnoFaVoi2F3+c801KAOfT6cnrufdnkSM6CTqSC9EC3lqV9/4j7Ud96
	 buO1LmYTt2C4sZqm8polY2FusChoE4QeCiHO8sVNITyEy4bZ05DcFJAnk6UpbPPadGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Be4xWtvF;
	arc=none smtp.remote-ip=209.85.222.174
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDE0606A31F
	for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 14:15:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABDE0606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Be4xWtvF
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f20b304c0so398737485a.3
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 07:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793110526; x=1793715326; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zUsMbjO3gCQtUvLruyRuDb07/mulBS+KPR/B4sl8JQg=;
        b=Be4xWtvF6zD3vHFfarAJm9xvRSujoQ4ZcjWYGMVUL72IZdQIrglRXya7nu1BUbTDL4
         JU5H5uRGbpfBgIl70sNPb7M5LjoH0JVWDiWYrd5p4dA1OYCaMa+eIU/FSQPzPq322pXW
         3BIOxxgck38BNY71yNhw4SSAeSgx6JinXx3Zn9yaso3wr//ChfahhDpgNLVyEjzAUE4O
         dAZ29PJibsBSyXgYh9LfzzRTLPKUcXDHhi6ZnUGansAH2HGrRy8Pnu4yfMUh815lcwdA
         ly/eGdf5n5xPlK639WdhZJDZBQmI4py6CAaKCrpKXNlKtynHB1yPt8pqrUeP1VSUuNAQ
         Z3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793110526; x=1793715326;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zUsMbjO3gCQtUvLruyRuDb07/mulBS+KPR/B4sl8JQg=;
        b=ForAFl+ghaqeMUVy6/w2NQ/5JUwCiNWUTtwv6i1VtaIUww//rxe1ChuS4aFtSLeiLi
         bt02cO+XkJxf5AKCLqnWdR4IcBYKwDEN9dP3Lf6lbcNyfCKlH+Fuip0KK7t7BGRHOLwo
         1eBDh+6HqiGY1SeKMB/7R3DihQyLcqXgnajGyA6CqE2CFpTntUtO9HpjdmIVyKpUQas/
         3FgJmi7b1irLfzLvSpjmoieiAcxgFBQ9RdBnc61Qyp5CXENiYzPekCaGWp2VfJ5ej8Dc
         wA6ftSJo2uGB4dlu9fRW4BFDDmC+AB2+wIBxBcEp4Rtsa5zodhcRgmtgXbfPcOhrHCqU
         9z+g==
X-Forwarded-Encrypted: i=1; AKwUvByTSfIAMWMiR7TpRTlWwMN0Mcsjv0f8r+MpjgA7bT/iLOjcnsuttej2QZLymcP+kt4yP0K82TWwL6o=@vger.kernel.org
X-Gm-Message-State: AFq9FYJdvVA/wrLKI1JDSGdDIbdpONZnW28ylYzg3NPJvidrHLn+DfyM
	YybgzaJkFAotL5aaH16M687gsVAEbye3TzydCwDwC/mz+aIl1nqxLNfPKZ2xFf8VnQI=
X-Gm-Gg: AYBFou1Q7Fmhy1XZ5mMErnChWpEzBLN8u7MQq0R5K4xIH8ilDl13d1synpheKCjTMKZ
	id3XwKOH6IRaznoKxaNhs+4DgrwKFCgmMUxapcVApsO/L5RPfbzuYX34KareVhXq4YJ2sh8xOeh
	0gNfWYz65CVeEu67TlV3OgPyavMsv1fwruIcQDN556r3y57nj/2L0TPDV9rKNw5WrF0pqbv9jSb
	CT3TfnvmKNmUnNm6eFWwdBnIVxc0/0bo0R6iTk9QPSAOYd0tTh0zITPY0Eg9eHRVKLPscrCTx9H
	gaQrn5lqvjCOnXG6+8MdIJ2sYs1YMGoCV+epzdjcrfN74biHGBeflmmF7neSM1y82FvY4wWNUyH
	FgcBl0PbOGYubZKqvdFO2NsM3KUu6mgieknO2LtkpOcBqzZeH/bnKfqEmk+3m+pH4z1LRx0DPMa
	iviq319y42fmVBgHsTS7dzZRUEnwseMr8Na0ARqmq6V2pzSE61BGfZ1Yjz8yWvj0fRzVgAKkYWx
	qBNFCaV7B+Syd0izOxh43Lwv5F2GgRxpAdtO3EhuqfjQ4bK923EYmdcnF/Z4oIguh05GJRrQ4uK
	h9ysgUNQcZrb9DevFixCfLpw90gJp2aHJojisg==
X-Received: by 2002:a05:620a:261e:b0:93f:d27:c89e with SMTP id af79cd13be357-940ef9d6997mr1602321285a.75.1793110526435;
        Tue, 27 Oct 2026 07:15:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0787d96sm982932985a.28.2026.10.27.07.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:15:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xLhxU-00000009zYJ-422J;
	Tue, 27 Oct 2026 11:15:24 -0300
Date: Tue, 27 Oct 2026 11:15:24 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	drdeeglaze@gmail.com, James.Bottomley@hansenpartnership.com,
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
	ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 02/20] ctlv: Add the UAPI wire format and family API
Message-ID: <20261027141524.GF1685504@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-3-jiri@resnulli.us>
 <at-iEMxN98nie1Qr@e129823.arm.com>
 <auBaROC0XdWpILEI@FV6GYCPJ69>
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
In-Reply-To: <auBaROC0XdWpILEI@FV6GYCPJ69>

On Tue, Oct 27, 2026 at 09:02:14AM +0100, Jiri Pirko wrote:
> Mon, Oct 26, 2026 at 07:55:12PM +0100, yeoreum.yun@arm.com wrote:
> >[    3.856919]  ctlv_schema_check_attr+0x3dc/0x538
> >[    3.857105]  ctlv_schema_check_indexed_nest+0x788/0x958
> >[    3.857301]  ctlv_schema_validate+0x88/0x180
> >[    3.857482]  ctlv_msg_test_as_deep_as_the_core_allows+0x11c/0x1e8
> >[    3.857698]  kunit_try_run_case+0x64/0x188
> >[    3.857878]  kunit_generic_run_threadfn_adapter+0x30/0x68
> >[    3.858086]  kthread+0x10c/0x140
> >[    3.858245]  ret_from_fork+0x10/0x20
> >[    3.858398] SMP: stopping secondary CPUs
> >[    3.858630] Kernel Offset: disabled
> >[    3.858720] CPU features: 0x0,00000000,00b0802e,9f190bc3,2affe72f
> >[    3.858872] Memory Limit: none
> >[    3.858976] ---[ end Kernel panic - not syncing: kernel stack overflow ]---
> >
> >[...]
> >
> >I think it might be good to configurable according to architecture
> >unless it's not good to reduce the CTLV_MAX_NEST_DEPTH number
> >otherwise, increasing stack size when CTLV is enabled seems unresonable...
> 
> Agreed, will lower it down. I think we should be okay with 8 for start.

I'm surprised this ran out of stack though with even as few as
32 levels.. Is there accidently something large on the stack?

Jason
