Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792694385;
	b=i48R6JdhlA7e++2qfEUtJNoHRQ9YrxbqHi1U0UKLNfu7UDVcXhsoBUtFbMr0javKv3Xh
	 xjeJRFVJW/0DRTZ+XXGgEckzGf0lLxuLDKUdrJbOMBlqHiiwSN8tGOxr5b0B1CR+1jQr+
	 x9bbMJvhlp2ZrE520afSR85HOBbZxmB6r19xDyBqn72ievPJLbH0rG4qZTCdYJkS5tdSn
	 4W91CroKG7hagFUh5WQOZNc7qDQy5EJQJjAVBo1C7R8apOAeZ4LaUBpzJWoMN/vS/9mHr
	 oVRp2xqXTjZzh+LHzDJrK3K7FlciuueA60hQtEcVMi7m5hjgwt+6eMMnD2vO5imsPnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792694385;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=6OyEIFFGQJwoM3H+g7NU0Vj1plI2Oe4JZLflWIJCYwE=;
	b=f0WG0mNCCAdtrKxEXt/4sDe31veoTCwnPi8B0sLpdvJkZqPEHAGV9xNSKFfTn06XnM/Y
	 h0qahl0eLMa/Hk9izcKCH+cebFSNKVBu/VHqLuLRZBrr+L0eOBaj79k4+5e+FFXHTT8XY
	 OwT58re6H8qLEIrEkFhB0ODRxaeZEMoYe0/lBcTqt9fg3ukl3XApZWvhiaP3/A7KMyauW
	 raJRXFsdtXxvhbJUCIDOmgiJpB/vE8uL18t49rmm/fCa4AGifzvOagY4oEpljV/28kUeA
	 SpJggPjiK9KXBF617wmE159ib0Tnw/zyUhnLwcv3XBkNyBXepElAwcBB5VAu2mthIRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=KHuMy0sZ;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677A9606A322
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 18:39:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 677A9606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=KHuMy0sZ
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-9179bfa9e9cso2625346d6.1
        for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 11:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792694383; x=1793299183; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6OyEIFFGQJwoM3H+g7NU0Vj1plI2Oe4JZLflWIJCYwE=;
        b=KHuMy0sZD7ZOI2sSxUEZc78TXFyK8CaY79wWRvg5gbf1f2MF53i7eKzHp54VCzTIp5
         xWKZP1zwsNiEWUau24i8KBu2EhZnrlozJiXL7jschM5mD9V6HP6UzOwpwUigeemLbuqG
         2uX5eesUhTVTe3yiJMtEUH2rAwxHhZQPM2Q65xGSSUhjSBNHoWcUiwXd3gQ4qt1G+nml
         zvDmKIjngDDacFbxpApugajGRtJn1poOEZl/c6h3/yA9ZyjYaLLxk7Kl8ePmLtWp7h+K
         PSV/i1A+yg2UH9c0P1A+em+71uwWcsUkBNx+QuE4xflfqek14/yZRT4/z7srKnMPim9G
         MzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792694383; x=1793299183;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6OyEIFFGQJwoM3H+g7NU0Vj1plI2Oe4JZLflWIJCYwE=;
        b=bDxcQgN/NufKkLUSexWSi1R0pcr0sXEM2w1Skj2fpmcj2Hp9UrSQC3eSI6Xg6mCBP8
         /j5jss5gDhLyHd68O8fuveleou2E+i837O8uqRAA0HyjB9w3jjzrUKjXBT0rGE9wzlJM
         aHpf5ev0p9HrrksTD9NQp0z+QoIiR1ADgScmKRJEP5s7+cRpxMZIFFoxLuHM3Tbo3/QP
         LJESwYJ3XyuM1XEx/1T2lia91XIoEgSqXfn5QV2BXO0d/Pr/MpabV9QzjSgfZ81Ir9Ey
         fYm/VOPcN982J2tU4cSNekXzMEu9ZvvN4/eSiU4ifxGE6TEPJTRrEi1Uq3ZBep+UMrIy
         gEgw==
X-Forwarded-Encrypted: i=1; AKwUvBz0BeTsyDAUEEfXRuMAiKDoGH8FpO5OyvWFtjxkSNUkIktL7Ejwp47wS7jfqHQeJT3Rlp5axo7xQcI=@vger.kernel.org
X-Gm-Message-State: AFq9FYK6yioFYE8272ceYHKads56pJdv0x08iiuiNcpPxlkxZfZys6OZ
	Od6I54p9WMEyqfKUOqWLmtFIUm7mu+dm67MW9z8x+OajJFkppatJ5HQYKQaI7+CxCFI=
X-Gm-Gg: AYBFou3giTkJUcBFeAjdJy9oKhmEVQgt9bWEqsq5Makn9goQyyd3aLVgysAUbSfdNGK
	s4+CWsd2yvWY3EyU1Fz7MxFe0oDBqzJH4sGVON3FxpnwVmDhlVq3oesWT8r+JCGvaMfPgG9zF8D
	D1viomMAb3ibAEHbNRM+WtwFVMFl1KOsm1XqlwEpkb4lAej58MUsnfvNYb1AHANxCqE2nsQ536t
	IORKzw1+CpwFV9G64T8Wvd4lPh1Oq9G04jG4qOx3aLlPFlm47gElAcm+56bJ9TIVuVbPBsAXSRM
	QuqEn5dtTHLQ451Fah8MAxAZhoWnveSdZ7PMIn33Befelsk8yIrPmkazCri2BVLqLEqbZvUkWsG
	vyqc0OdyHKBSn0UCxrdJs+3rdDj2ImCcrWVzB8QvzoCb1Fj/UORiL6YwxJZmOKd3CoA8MqPYCEY
	t5deLwoxSVpD0wYi4zgEtbKsK+KE3+Rbd0PIh7rLN/Zka1WiUARvb8SXWGRCRe2s351FgfSFLFC
	bPqWU2UBapAQb1uIpy/VUhmIC2W0fZGkId901065Ia0GKTxt8fmIMgqPNd9NcZT99Mmichjw3dg
	lysJzntb9E7raBIxjLvV/0A2QyjrkSg8zGpIhA==
X-Received: by 2002:a05:620a:40c3:b0:937:d6e8:59b0 with SMTP id af79cd13be357-93f6f79bca2mr59757485a.10.1792694383306;
        Thu, 22 Oct 2026 11:39:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f6fb82a5fsm19367685a.8.2026.10.22.11.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:39:42 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xJxhW-0000000FjFr-0C75;
	Thu, 22 Oct 2026 15:39:42 -0300
Date: Thu, 22 Oct 2026 15:39:42 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	drdeeglaze@gmail.com, James.Bottomley@hansenpartnership.com,
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
	pgonda@google.com, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 05/20] ctlv: Prepare message input handling
Message-ID: <20261022183942.GC3381610@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-6-jiri@resnulli.us>
 <20261021014324.58376589@jic23-hlaptop>
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
In-Reply-To: <20261021014324.58376589@jic23-hlaptop>

On Wed, Oct 21, 2026 at 01:43:24AM +0100, Jonathan Cameron wrote:

> > +bool ctlv_message_input_rebind(struct ctlv_cursor *nest, const struct ctlv_schema_tree *tree,
> > +			       u32 node)
> > +{
> > +	const struct ctlv_message_input_scope *bound_scope;
> > +	const struct ctlv_message_input_nest *indexed;
> > +	u32 i;
> > +
> > +	if (WARN_ON_ONCE(!nest->attr || !nest->msg || !nest->msg->index))
> > +		return false;
> > +	if (!ctlv_message_nest_index_ok(nest))
> > +		return false;
> > +	bound_scope = &nest->msg->index->scopes[nest->index_nest_scope];
> > +	indexed = &nest->msg->index->nests[bound_scope->nest];
> > +	for (i = 0; i < indexed->scopes_count; i++) {
> 
> 	for (u32 i = 0; ...

Is that allowed now?

Jason
