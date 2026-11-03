Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793667941;
	b=MFGyUzGBwahDo9lGU0S0xEpOncK3GFiZyxfZ4v+nrx0fxrxesdvNlCGQdv77FAsxesJ9
	 DTEdeXwUdfvvmPxr0m7GgonJKGMNxWWdJb97e3TRCYJeXvatYEo1NL9Yo+Y3yVFJzohCn
	 qqeR2I4WsjtPEjO88niaoQDB928xSk+wi1TUwxE2ooqvB1/TQP4a0/NIBaH5b5w1hSvSg
	 okeAiW2IjPt8oYeIFc05ujdE1CoZMj8DxqdVVCTRrflT2CY8du/4v5x+3kfgyNYYdCMun
	 VyHkNrXjQ/wjjx9+akwawnW46EdOkZb8hENQI7G0wlBBtfFVas87nRQQ5Am0RStDsLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793667941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Qv+EdtqMB+XL1xqO+2Rl4b1uStrdgvx9BftdNrlvlQs=;
	b=gDp91o9ywtt75NJmNCQH5JAI6FJVbGj0OFm27IbZ7CgLXv/HPO/QY1zEay6mg7twPjFm
	 0c3Sw1ovVnpJ5dUhY+1IFWetYSbD8R+sngMa6anbFiXND+hxHrsmu5N0/U1BAO4LzQx9d
	 z51LcDvA1og+w4epCLtPo01zY+FKjBvnKFTtjYR7Kc7xSigvqaC0ZywAm83v2CX7H4UAZ
	 C+J/bC9Rp5B+O0RlN/ald1cG30INGXscWQd6vb8wI1yMT0qj2gpvAb5l2WAQg3Akg1nH5
	 a/ViNlps7STwsMCxR4XwbV6mxCmUNUt2MDBRq3ELm5ltsuvkYyXBF/pnyTXIcQdTKGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=pUb0rNHx;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83900606A326
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 01:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83900606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=pUb0rNHx
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-533778ab0bdso52371881cf.3
        for <linux-api@vger.kernel.org>; Mon, 02 Nov 2026 17:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793667939; x=1794272739; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qv+EdtqMB+XL1xqO+2Rl4b1uStrdgvx9BftdNrlvlQs=;
        b=pUb0rNHxiAU+LF8DVe0ZniHMW9XjI2QNJZUDuVtuZyauhWJ9JcYl8XRJUwP1m23NN5
         YhOjwo0TjD9eLE6c+GNdgdirH4NqQys6UuF4s1ak2aBWg+qYGy0UdkpqSeNSUH+pazVY
         djyuyvx4EOAdRDVN8Xijkdq2CFi+TXuMFmjrHrjS/MOHZgGCyI+rcXQ0JE0PS/Vit8ih
         SIRs5HGehq5NrqF2hE9UIkltDBQeI+OydffKxerZZONTbpFg4+FAFMsEp59NIGXCq3aI
         XaSYJO67edsrOWUfFASBvHIFuWYkMwgs7x8IENEGhSDJcl0V26I7CvXK7rKdPcK8adU8
         26Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667939; x=1794272739;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qv+EdtqMB+XL1xqO+2Rl4b1uStrdgvx9BftdNrlvlQs=;
        b=XSjA6KzGPKljm9w40KgcSnLPkAvMyFv5kxWKO6XqwnZ0/CPPreaWAIQUIvPJFfG9fs
         ErEbGE1psyvwSbavRpI1f/KVvntIcqYNF2tUsFBiZJUA/oI5IocslNXbPAvAAouRi00O
         Q8atOmCmI0Sxrmr3Oczw66CqxzwI4n10XwCJOtkqtCumIz20cofTkmJUPiualayN7mTU
         R6gCwbSZHAzY56eAzYJSYPZE6zJiJcQ9FuwXOM59i4fEUJtNUGYb0NJuFoCznJ+JZze0
         RLyTDZdxiBt2qHoVn6J/gz3hnrnk2eYdwvXDAy85VU8JosyuQF6DuS6HBvwgFh8KfjyW
         ywRw==
X-Forwarded-Encrypted: i=1; AKwUvBzLzEo2L2pqvMxg43qOh3iMG/I4QD3xWUMgGPPafVQYdF8c56UPZjwHFf3//4aH/FgEVRjxugjtpDs=@vger.kernel.org
X-Gm-Message-State: APuU4Z/TWXYDB/IXGcNI1Q5VcZPZIh+8mu7C5JcvCdREDWBi7mqQHF1m
	riRLMPofn3HL9mXHR2+DOAfnFZgcIXYVl61PJed+jhwJjsGUhipD2/0EeFg/pp4RXb4=
X-Gm-Gg: AYBFou1whhcvFpzojfV25I0Or8VXWqpQdWml6Njk24GawtIAsLHDJCI12huRs7gVETK
	Wl7JrQMHiM14ifXhAe1ZMSy05juQVnuh5cKTFEiuMfnzXaP5ETroiov86m3r8D5CtZuscWy7rSK
	vrUaPvZ2d0PFQRe9ChnDhymVByJCMxImBGmm3QlRy8RnU6E5G99NGqiR+puGdnqQGbfA8hWQgI9
	AVXX+jDVfOWpdLTs2DoO/sMksXnxTVZ6ju5LxQDfQv5HsgmCExJ2+4sml9PSi0ICwjKj6vqmd0S
	nyHeS0KIwjf/NKAGbQeWR0addEOmeqLb1DJS72iy9geOSxBNzYVwcgupiyib94pCEHxg5IU8BaO
	2KZLS7Pa/SYMQ0d7hMLEOm/P0sb1yE8arPk2jTwsSvlmjA+QxQQUuzaM15ONnGFZQXc3INejQcP
	I12HBkOfzwVOsqY54EbWdWIQ4V5nXVGHE4sB4OVT3pg5s1bNYNCFsf5I3lSTbURrchwCcHgfm2a
	zGnopwQcEfmDYMfp3wQLqDrFjmqahUgr2w8QDauNrI3qpwJREISlgPY14ITeP1nEwA3Xyd2tUat
	TfdnV5s44F+YFRqRzRgieBt3SuCi9Ud3FziPnDmw0UsCwD/Gmsn6lAsq5xOsEAbQTmy6n4yvgbN
	mSkX8sjpy2A==
X-Received: by 2002:a05:622a:4017:b0:536:64f4:45e with SMTP id d75a77b69052e-542b7525e13mr187886741cf.50.1793667939125;
        Mon, 02 Nov 2026 17:05:39 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5498cb57669sm12221861cf.24.2026.11.02.17.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 17:05:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xO2y1-0000000BIml-2jCU;
	Mon, 02 Nov 2026 21:05:37 -0400
Date: Mon, 2 Nov 2026 21:05:37 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH RFC 11/20] ctlv: Prepare runtime introspection
Message-ID: <20261103010537.GI3889730@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-12-jiri@resnulli.us>
 <179302367452.58760.11808905856343064399.b4-review@b4>
 <auRmMPfaFINUIchi@FV6GYCPJ69>
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
In-Reply-To: <auRmMPfaFINUIchi@FV6GYCPJ69>

On Fri, Oct 30, 2026 at 10:53:11AM +0100, Jiri Pirko wrote:
> >So.. how about could we drop the sets, use a direct description of the
> >layout and do something else for the ID numbering? Maybe the numbering
> >can be solved directly by only listing the names in:
> >
> >numbering:
> >  - device-get.reply
> >  - device-get.reply.caps
> >  - device-get.caps.evidence
> >  -[..]
> >
> >?
> 
> I'm still committed to implicit numbering. For "inline records" I
> resolved it by having it encoded as a tree with 4 levels:
> 
>  63         48 47 46 45        32 31  28 27  24 23  20 19  16 15               0
> +-------------+-----+------------+------+------+------+------+------------------+
> |   family    |kind |   index    |  L1  |  L2  |  L3  |  L4  |      field       |
> +-------------+-----+------------+------+------+------+------+------------------+
>               |<------------------ record ------------------>|

Fascinating idea. Sort of like an oid

I guarentee we will run out of bits someday :) I saw recently we ran
out of bits in RDMA :\ 3 bits seems like quite a small number..

Maybe increasing op to 128 bits?

Maybe family/kind/index/field spread over the first 64 and then the
Lx's over the second?

At the very least there should be an escape hatch so that if this
becomes too small there is a way to opt into some new layout and fix
it without breaking everything.

Jason
