Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886756;
	b=Zbl5nQ4xGBErTPftnhUqVmgOQonVD9T7TC5bGvNFq8G9YeTTfhKlaNaejban9D2bwdIA
	 rTvX6/PNVG6sSYPKLP675catg9dL2TOymJKhijRTPBtW0CxzBHrqnJodkZAKAphNudbTz
	 rS5LVrBFK6I2u43KpGoI3IsJhee34QRcuehLnL/LbNGbGg5r4pABTdCJNRASHjSvXkyJW
	 yuuO3SOQKOdRGTAgKxaz6unsLHnvfCy6ZkkMxQmlIMVwpldlXE3Zllw/KEYNiyIntwW73
	 xGnjkMm7zSABLUCimmOCHq+xsousF6APmp/fmbXRv0U7yt7zgMv6v280Bqg2UljB0AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886756;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=QwmQA1a2QhYSOPcBSTBe/t1Xyv+zC9XEOaQnTg/X7XI=;
	b=XdI+2RcG4hKRe6b2rm/ws9sYbc8vJQNODpAmnuwFCkVYwF2TcspJy0/shXdyJxo5XbO3
	 9QtVO1H9hg69f4zTy9H5ifK8Coc63bmjscLEzdWoGj9J72iqT98t6F5IoA01qaIHH27g6
	 O/knENDhz9RAhWvpHGYBR4CQGKRm99BW8owYZ73R9ruYLFbuQYpiTI2v48J/0np9+EUOo
	 ZVKcbYGy98xzFLuh2shEqjW6b2StQcRV64zIJlgfZFML8/x4JWp8EamS/n91GroFFOMMJ
	 4mQ6NX3lYnzAYBm8tcUj5l0yl6Ch3B31Q525NJ88rrEttek+h1IE6RPJxOr2z1sJQxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="c34gCj/8";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22558606D80D
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 13:52:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22558606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=c34gCj/8
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a214af2076so13763865e9.0
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 05:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793886753; x=1794491553; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QwmQA1a2QhYSOPcBSTBe/t1Xyv+zC9XEOaQnTg/X7XI=;
        b=c34gCj/8CF0gjZPD4S6DE7fp5Zl7gSX0P0hMJk9lFt1y+nBZYrLUQMyOe9yskOljO0
         mWq7a3nzqXz8tp3I6ubwhzBAOsJYhD2zSynoQZHrZRopkQjPUFsi2whqLUzl+ldansUM
         MIoZ/uxtCEAMb9QDpVquB9CLXS7hpypOQBKzqBwygEabCHs8+Q8vFHnySRybX3XMNR5x
         /bmNPcFbYLThOu3b+Gb9jeXLHMvKt3ZgoiXr0DY8zyFrDCAKVO/1n77AROFDNyHGSlRT
         4sQdtVSWMSH4Fk6Bh6Fa2qjPcR18tiYc8STHLzktuM/SW/ODCEM5gMYc36N9pRaZ8t/X
         7c+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793886753; x=1794491553;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QwmQA1a2QhYSOPcBSTBe/t1Xyv+zC9XEOaQnTg/X7XI=;
        b=O1WylTHhszGAwKGOvqg6c+3JFvGGrHmCo/r6H9H8qUiDMjrjYHSeNZsTOquJY+Cpx5
         /TgDG+qHJy3hiItlpd0V/enSDr7jr7E6wPbnNe8XCiTvhJOns3lvv6wuFmEb0Lt0U1II
         +wTGtq/94tP19u/BmLhUDTh1mQycUVpNNSP4Yefn9rqeyujgBGIBOVJ4UA/O1elx+DB1
         Q0AhZAEnCvqQNRiFM0X4+/gdBQ9C4FWk6SzZLF0Oia1HVvv8hpHj9aJJgPoseXSk16aP
         a+6Srp2K46IJT+I8snb4dgECen0HmpNexuflXj0OHT6mxTJduMCq1CK2ZpuRRBEJfol7
         vbdQ==
X-Forwarded-Encrypted: i=1; AKwUvBw0RdBF8i0fEr3Zegx5rc54DlkcZ3vLP5x10nY5DTMtY/rYSew7eizf2aqffaSZKBaHYMm5V+ERtzQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8fMAULutBnIjymT2n+BQqk4r3H3tevdh5/kWHKql8O9perfqHm
	vG90nKqWsjThAK/0M+U2nAZbC9JJJYxcr+aBo7ds17MAgKyUjfDQFg9FA+Ou1M29cKg=
X-Gm-Gg: AYBFou1KS/041OGS4Q3s3xPC3p7WfwQ9LrBep8MOKsjLnsllNvHNwQuQ/7aargJWycD
	NLV2x+rpPROWSIryv/uN3aDCeRZjGAO2IFDSKwZr/FbG0DyRtfwRsFj89bg0kLsqehMxqu0j4sk
	FNEr+6xuhdi8G+tuWFm6PU0vXuIUlqbmG9Hp4O5K+tuqrBVKRDfHO9gAhQoArQnLypcjsJBqHvL
	6b4qi8AvtBlzdW6kOSgPlVnPUpzMTv2xKy9IMuTiQg9VTv5grbbXlTaE7WVt/6mJ5RYeEVIcyY8
	64Zobwcd1s25Cci8oT98xhm/9cm50YT03JtYmW984Zkf/3atCcNYAHJOW/3bnRK+buiK2goHLAJ
	F/m/5FaGDFD0rEtyaKsvIbrZCbqRKzU2TeTVkgZmwzQAcsowiAab3SfU2GF491ML1ZWlyFoUj/5
	bDuitk8Vnr8xoBntAYzm/Axlc52Q4aTNBjVY/aLJwhSu9IpjVw0UBTKU1AViIqADkuIB8/dGhvz
	QG8M8VOjGYxnpX530FxiL24+XdjkHlKyhM7aUMSqPRMmKlrahOIVLW1FJGTMdZ9iTuyKhz+fmxi
	pYTV9fyHUeRKR/hghOqlnfPEkeAA/FWm9/SidqE=
X-Received: by 2002:a05:600c:83c5:b0:4a1:88de:9e8b with SMTP id 5b1f17b1804b1-4ac17191074mr383781755e9.5.1793886753121;
        Thu, 05 Nov 2026 05:52:33 -0800 (PST)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4104d600fsm127121635e9.0.2026.11.05.05.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 05:52:32 -0800 (PST)
Date: Thu, 5 Nov 2026 14:52:28 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 14/20] attestation: Add the base family specification
 and generated files
Message-ID: <auyG1AnzpjLdOtpR@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
 <179302367452.58760.3782556786585774917.b4-review@b4>
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
In-Reply-To: <179302367452.58760.3782556786585774917.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:

[..]

>mr-get:
>  request:
>    id: uint
>  reply:
>    name: string
>    supported-hash-algorithms[]: uint
>
>No definition what these numbers are. They should be TCG2 defined hash
>algorithm constants I guess. Why not have an enum here for them?
>
>    caps: mr-caps
>    register-index?: uint
>
>So we get a string and a small integer for every MR? Like PCR10 and 10
>for TPM?
>
>=======
>
>mr-dump:
>  request: {}
>  reply:
>    items[]:
>      id: uint
>      name: string
>      supported-hash-algorithms[]: uint
>      caps: mr-caps
>      register-index?: uint
>
>
>This returns all of the MRs at once?
>
>=======
>
>mr-read:
>  request:
>    id: uint
>  reply:
>    generation: uint
>    values[]:
>      hash-algo: uint
>      data: binary
>
>Get, dump and read? I don't get it

This is another netlink-influenced terminology. "get" fetches one object
info, "dump" fetches all objects info. "read" reads a single MR.

I'll remove get and just have dump accepting id as a "filter".

