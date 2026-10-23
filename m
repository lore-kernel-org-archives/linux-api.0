Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792779332;
	b=aVPkrUMNCC+CdXqqxDCdycsL7rNPv6sVH1tSnxrvpKMFt6LRlJQD+cfSWo+ICpOrMxw6
	 CRq+kmtUEv6MSZ1UjDR6QrCVI3vdrQPUBe+IAYeAUzffwdHhUsOFjZM7+biwJL7ZjdLSG
	 Cf6QhHpWHViLfTLvN9k7Aq4YBfLUXT6mmA1kscI+jRnQHfmHOOPXxyKIqaaWi8vtExuZk
	 4mudjB+dCO6uiba/hEah3jjYzwvjhwzQdx+9b/Pi7+cEZfhNz4kC6Gf0CmONCgDl1S9De
	 ONgqYwgBBPWUptgtrm4LM74YhMPx1J1WyZrTlPgosHXX5pM0sKcTfGpxwbEDKOHiWEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792779332;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Qt+ZKJaVNRWLSfsLrt7/fp04EXHG7/fEzwXs7hhdXAs=;
	b=apbqA7NzyGfmbnRqwufrQWpSatFXV3NzTu9f2POTYI0S0TIctBL+3tGcHmxqdMehVMNa
	 A2+v4eDxa4H59IYF+19W0WrK98cX/oO4VRJdEWdvxtsfQjWY27NNvsor7g/N7e0VI46Dd
	 iSEy8I+GwkCrf+o7QZPuAaQ6Pv/gG6qxs+y+LH6xtnG7H+6eXSZRo+KuKFdaz7qA1BfXo
	 M/9U7b8UOmcxgW4PVYLad2EdcJn+AKgWJsE4SjG/ZZ+UCFHRCTgD8fR5q6U4XT4yqdvi9
	 y/wq+sy7VH7O0+yBWVUcwgx3UJ6S9eQTUp0BO4F71XBDeTp0daUHP9cDoFN3g0zutoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=O7qkyEr9;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA39606A31B
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 18:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEA39606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=O7qkyEr9
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c3fd91337baso162378766b.3
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 11:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792779324; x=1793384124; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qt+ZKJaVNRWLSfsLrt7/fp04EXHG7/fEzwXs7hhdXAs=;
        b=O7qkyEr96a2bINpE6/r6kEb0535R1oyjk5PKdiHdWuRqzyQHVAIHlQayFrNwVqaizf
         OZjoFhvrNBBem744hV7PcpwW+uNDtb3Liqy886CyHCC0HM9q+hVxyT5gJpqo6TbWrz2q
         a95iHMVJ6s6hSkLo/uQJLWBpWlQoTZRv51uNA8sKcev0oI13JRo3QqHN9FED4MiFnc2H
         rF7HNHP3bz9cO+eP3RUTAMe+Isc/LhMQXjHhCxfmDpay9QAcYRLsLuHLwdszmyj/HFG3
         K/CQrimbe1zkJJqSM9Lhz/E2y4Bs2mMDqGiJN+StKl+H0kD7/jAOUDp5G+6V4bMpJgoE
         tV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792779324; x=1793384124;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qt+ZKJaVNRWLSfsLrt7/fp04EXHG7/fEzwXs7hhdXAs=;
        b=Istc9Club4nUc1jJkWcf9YawSA5K7sTIhBfXeXV1mggI1h11pGR/hsEdFQF11xxDZM
         XBLMjqtohf3CUYu9Y0xrzR7Dm+c6ie8G/Azgt3u+o1fZ+3QTmekqICV7pv/0ZdcEb5Dc
         ejstMgEatAnEHEDfSM0DsfHUxxtUzkLranT8OTj5KEcvzi3kYCU7s2iWXnhVTUh2RQof
         prMEiXwY48jMqteDTOJY9IxZtWB7WjZKewRWm1WjqwxqlD44o73EwpLBJK0edudSlPmV
         2KWD1hYRHgSNIarMnQNcs9qMED6NOAub6cSlcfdKkYmTO4PObH5KmKcowOaBoo7Vvrw8
         HxUA==
X-Forwarded-Encrypted: i=1; AKwUvByMTaQLvWIawdyYl0pSCfteAzDaASdFUYMqtrpm/XFuJMxjscQaj5MGuoLipDK9ZKgae96PFWLzaH0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJuwUc4vd/y+7XoW6KU1hrqtZy4/ppp/fpmzCbNQKnzqpRWJjuV
	kOHYr0+WMmJNJ6zgBlcq0WE/dPV61+/NURd+Y42GuqhyJ2JMGK6Kciiwj6HUMQQh1DU=
X-Gm-Gg: AYBFou0yVsBENzNzPX4Ec6XG225k/djx0J49IBSL7zgzGn+35KiPioQvhFew9NLKgEk
	IUs+JbGBWOD9Zy1gtg0lm4KJPvVKnN9YTVg+kZzNHz6QkE7caTzOQ9H5MFiLuUK5bHgStNUyss2
	/h8keNSSE3JiqHRDte2FOyGPxaE0OduaQIbpNJDGnZJNNQX68sRaetgI2IOuGyaOghJH7is5Nd+
	YvpLUcAjkPz2hVhpsqRGaLKfqES4hj+HERfBnjDahF6rrkk/S5kSHDt/uBHJI1Qikr9ET+Hukcf
	zylgweppFxPISwvsE7XbwB4Fm39y3iCe7zK/MPe/zUhsp+lJCEqi0nkGmZvH7mS9c25SZCgCdlA
	pu4vvX29fAb9Lq4bHIDG7fbI3llnh6XBw18ehPfIgGPByqBr1hK/UkdSFFV34HwpzXqj6JuYnS8
	xlMFmLLuWtwtfz+RZLdseo6XvVkVIPaDbfxahcRW222sZZLGDj2IVOF/v9JhGMvwo677GzOFrwz
	aGAXPezeHUocO1asa4rl9sEH8fCfybsiGpjXUSeLVLW5Z3RDiQhQIawcu5SeEFE4BA=
X-Received: by 2002:a17:907:7256:b0:c2e:3f49:df04 with SMTP id a640c23a62f3a-c46a8eefbdamr488289866b.1.1792779324041;
        Fri, 23 Oct 2026 11:15:24 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46b8bc2851sm27128666b.31.2026.10.23.11.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 11:15:23 -0700 (PDT)
Date: Fri, 23 Oct 2026 20:15:19 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pgonda@google.com" <pgonda@google.com>, "jic23@kernel.org" <jic23@kernel.org>, 
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>, 
	"James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"Xing, Cedric" <cedric.xing@intel.com>, "alistair.francis@wdc.com" <alistair.francis@wdc.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ankita@nvidia.com" <ankita@nvidia.com>, 
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>, "kas@kernel.org" <kas@kernel.org>, 
	"Quigley, David" <david.quigley@intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>, "Vivi, Rodrigo" <rodrigo.vivi@intel.com>, 
	"lukas@wunner.de" <lukas@wunner.de>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"ksinyuk@kernel.org" <ksinyuk@kernel.org>, "Fang, Peter" <peter.fang@intel.com>, 
	"sameo@meta.com" <sameo@meta.com>, "aik@amd.com" <aik@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"x86@kernel.org" <x86@kernel.org>, "qinkun@google.com" <qinkun@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <atui5si5xs5px_Or@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-21-jiri@resnulli.us>
 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
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
In-Reply-To: <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>

Fri, Oct 23, 2026 at 12:07:28AM +0200, rick.p.edgecombe@intel.com wrote:
>On Thu, 2026-10-15 at 16:50 +0200, Jiri Pirko wrote:
>> Connect the attestation family to the native TDX service. Expose
>> TDREPORT, Quote, MRTD and RTMR operations while preserving the existing
>> native interfaces.
>
>Along the lines of some of the other commenters I'm not clear on the benefits of
>the unified TD/VM attestation part of this.
>
>Especially when you talk about a TD report, it is pretty specific to TDX. So
>calling user code is going to need to know about TDX anyway. In fact the report

True. For this case, attestation subsystem creates just unified
transport: EVIDENCE_GET. Nice thing is that the same op can be used for
other evidence providing instances as well, like SPDM, armcca, tpm, etc.


>won't have all the details of the TD either. Going forward it's main function is
>to serve as a nonce transport blob and it only has TD details because of legacy
>constraints about SGX based attestation. So just a quirky TDX specific part of
>the flow on the way to get a quote.
>
>Can you help me connect the dots of why the unification for the TD/VM
>attestation helps us get to a wider attestation vision?
>
>
>One idea... Not sure on it. We are currently working on support for DICE based
>attestation for TDX. This is an industry standard and AFAIU other vendors will
>(want to?) support it too. Perhaps if we could have a single way to ask for for
>DICE based quote, it could make a cross vendor interface more useful? Callers
>could just call and get some standard format they can understand. It might take
>some work on the TDX side to ensure the DICE format quote.

Yes, that sounds useful and fits the proposed interface.

DEVICE_GET advertises the supported evidence formats, and callers select
one through EVIDENCE_GET. Providers implementing the same standardized
DICE evidence profile could advertise the same format identifier,
regardless of whether the underlying platform is TDX or something else:

EVIDENCE_GET(challenge=nonce,
             object[]={PRIMARY(<agreed-DICE-profile>)})

We would not need a separate DICE operation or provider family. TDX could
advertise this alongside its existing evidence formats.

Makes sense?

>
>Regarding the device attestation part of this, DaveJ (CCed) is exploring this
>currently and can share some findings in a bit.
