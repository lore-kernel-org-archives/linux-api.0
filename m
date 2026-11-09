Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794244359;
	b=3XqVkee76zIx319Vt8Oxr0S+mMnZynymsJr+tkWcY+Tnm1aPVaRsGafp+AfbIQ7dCncU
	 AMmf7ZGsqatdKiA91/Un1QGn2/s/G0dGTKLWjqKkLBQ9ALg4q9O/+uB9UT9xox+ZUctQA
	 bFIXs/PqEvNLTKn6YkZkD73B0vGjHeshT895oYeNiPPYXWKihZ0dZr0CJYeaBc9m6NrUN
	 3MOgcuaK9AUGlCfT+kmNNmGbjsmMBVM/9ItsGQ5eHDz+AxkR1GaYhH7WaGyGin7vq8iAq
	 g/Cdz8JBY+LRBjVuQo4QZ/sl/9/WOVrJSvUaB7RjWhOAu6OThRfwHDTsucr2e9g7/Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=mldVdWBWz+slWUX+6pvLrLM/2pda4Td9vv1hcuYueHI=;
	b=Im+hGoukYMqspY398q5+WiW9/hkw6RRuvY8HTvgo7dKlTOs5ClfAzafdzZ6EMJRMpu36
	 4GbRe8BZ/UquY6+sHVwAeJlWmNRJrqWCrsfNjhcLz2uC5r6ZJBj+nnOgys3virQMBOkQr
	 vMQjJATggNE8tg7szoNtEgzOCaPcIpzQNADvaw3VazlJPR1RCOXHcv9WACLErSp9j9pPA
	 KIGmiKVlnrt4W+JCIpFXBln0GvxhnkmM1BaBVsi3+eW8FPZZphBSZ01ilCcmMexheq+nd
	 FQupQSIfy87fZmjCT8//QJLVdHPNxx1I1mOjjPI41KrhmtKAOmlwyhmvivx12lAyiiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Yl4Em7oV;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE59606A325
	for <linux-api@vger.kernel.org>; Mon,  9 Nov 2026 17:12:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BE59606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Yl4Em7oV
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f20c3aaa5so99171885a.2
        for <linux-api@vger.kernel.org>; Mon, 09 Nov 2026 09:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794244358; x=1794849158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mldVdWBWz+slWUX+6pvLrLM/2pda4Td9vv1hcuYueHI=;
        b=Yl4Em7oVwrZZg0i63RkmLtgR+ZRN9euPgyMkxxN1Ob152+zGGnL2fm2jvTYJo4LVnF
         vMEovACZqMWqSZBQO8MwjFgjN/VfTU1Hb0gUOSD50ReMsbb4x2PsB8Vqznx9hxIVJ9P/
         ktueRojchyU0OBQAvs4hpd+FT+5Nl5MGAaSYHa1Vg/86pPRlmOn28BDAbJB366nQmarU
         C7enZgKp8KEKbUHK1eQuucK6wGkqEYMXhjguAz7je3g8iMjLQyATGWC6+GeMkRPjj6b5
         YcfHQWnHrd67gsof5g39Wok+gfkBlOMw1fVpw6g/CmgVLoFrpX+x7ke/8IMcGiq6ZU6J
         xcKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794244358; x=1794849158;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mldVdWBWz+slWUX+6pvLrLM/2pda4Td9vv1hcuYueHI=;
        b=N4YybClS4c06Fr9OON8k8dDy3SVZlTh3KyVgP/e56gBQ5bELVOTFLUo3wUI264qAuS
         2fT0n0yk8RnDsHKVOJfzRocfTylX8LZ6lK1UUo7q4LHyDIFhqNg8+XtaEXImafYAf/uQ
         rhY5iRCrgbaHdqdl735FBS/otzB27jyhd3X9om+sMVOu2c0gObSjf1Om2EsHn5/MEP4k
         z5RUOe3rR4NF9tyobYAB+cV56A5723nzeDsw/rhOEy3NGZ2HUaKVr/69RDvmDn2WeEbk
         N9kUKdmWaJWJFupn1NGA3p3WgMpko7nVHhGCUQ8mbbHF3yw3VtAxYtfQmOTy7Ff1swok
         ZhgQ==
X-Forwarded-Encrypted: i=1; AL+hErGfLbX58qk3DnArYxa9i72d6cL11AcA+6+w3qyI0weKn+QmLqy38nI4ZPXOUispTIRk+GFyUoR4SQw=@vger.kernel.org
X-Gm-Message-State: APuU4Z/uGK1l9ftdRQe8wo4YtB9AtnKeX2Z9lK7+UFC4ugA9eyoC6x4H
	xWwuyMKELyordIUKdhUGpYUdHCa0GGMg8h/IMcyfoBbpStYFsk3M+SjhOKAlhPfACnQ=
X-Gm-Gg: AYBFou3N8A2Fj0ABO4s1oOFSiwBiyRh8H6KlWd2bXC4qnU4UofOb8GijXzdrFyjbeQm
	zPPlRoIkGAUZscm9DEHboNFZ/gvgYhaMoPs4jtHTrm0+tP7N4TM5YKZAN+f5dY7Ws7pwM8SfN77
	TwhjlLOV8gZqd8VV+aBTJxeZHI38XxwpjbeeKkRaRZcAxU/D3wIiVfXcL2VWQubk3evJhaXotwZ
	MifZqb3ovvBIjezX1A7cEgrdM7y5npyQPuDWktPXPPeDUVwzS3u07YPW6pT7KPakn35iEJis/F9
	pheOp1CPug/XUk84JWcVwjnBDFKc6BIeMdJVLx6/DQdXCCi16IbAkNOsd5luzqsThNAbr4r8RWR
	dSrInnausmiEXDW6Q2AYFjKnDZ677tOrH4gavevXu152HhTuYeVcLG234sKxGcfvV/VJHlUFbJB
	PPv8bGcqHeWGItUIozTtaH0d1Fp58pQ6607gixUQTYEZDe4SU2gdYVMWihnemeKLPXU7SIgOMsR
	nsp9R5k+epbj5yFzjYE5Af/0RPmzV3fWFqNxNu0rN4BopKFKOiwB6YFXtMz1HadgHkXUByWpAN+
	eAlqL1f8gofchNfn+K2DeXAUj9oNIuV2JhAPGQn+D6zSZahldxrLZFq3dF9giQvDY4y1oO7JYnW
	BbcJ5ivUNog==
X-Received: by 2002:a05:620a:4625:b0:946:26a:22c4 with SMTP id af79cd13be357-9479f415545mr8700585a.73.1794244358097;
        Mon, 09 Nov 2026 09:12:38 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef0540a8dsm277806d6.41.2026.11.09.09.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:12:37 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xQSv6-00000001ryf-1fz6;
	Mon, 09 Nov 2026 13:12:36 -0400
Date: Mon, 9 Nov 2026 13:12:36 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Peter Fang <peter.fang@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"Xing, Cedric" <cedric.xing@intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"ankita@nvidia.com" <ankita@nvidia.com>,
	"jiri@resnulli.us" <jiri@resnulli.us>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Quigley, David" <david.quigley@intel.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"pgonda@google.com" <pgonda@google.com>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	"lukas@wunner.de" <lukas@wunner.de>,
	"jic23@kernel.org" <jic23@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"sameo@meta.com" <sameo@meta.com>, "aik@amd.com" <aik@amd.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"ksinyuk@kernel.org" <ksinyuk@kernel.org>,
	"qinkun@google.com" <qinkun@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <20261109171236.GP663069@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-21-jiri@resnulli.us>
 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
 <20261023141218.GD3977851@ziepe.ca>
 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
 <20261023220030.GM3977851@ziepe.ca>
 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
 <20261103005851.GH3889730@ziepe.ca>
 <au5LCE1jau0yDo5S@intel.com>
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
In-Reply-To: <au5LCE1jau0yDo5S@intel.com>

On Fri, Nov 06, 2026 at 01:47:52PM -0800, Peter Fang wrote:

> For TDX, the direction so far has been to keep the guest as simple as
> possible in the attestation process. So the "quote type" knowledge is
> pushed into the TDX module and the remote verifier. The host kernel is
> mostly tasked with transporting the quote blob from the TDX module back
> to the guest. In other words, TDX doesn't have any quote type knowledge
> outside of the module itself. And as far as I know, parsing these blobs
> is sort of a pain.
> 
> The TDX DICE blobs are actually self-describing, meaning the verifier
> can follow a schema, parse the blob straight away, and know what's
> inside, including how to verify the signature. They're also
> distinguishable from the legacy quotes. A launched guest is guaranteed
> to have a stable format for its quotes. So this makes me wonder how the
> labeling should be done. Do you think it makes sense to just have a
> "primary raw TDX quote" label and let the TDX quote blob describe
> itself? Also, I think currently there are no plans to add
> secondary/supplementary blobs alongside the quote itself.

I would be very happy if Intel came with some plan, documented in the
ABI comments around their labels down the road.

What I would like is that given a specific label any userspace can do
a verification and full dump of that data, including signature
validation, without need of any further external information.

Ie it is entirely self describing under that label.

So if someone has to say externally 'oh this was a legacy VM' to make
parsing work then that needs to go in the label.

Think of it this way, you should be able to run a command, lets imagine:

$ attestctl dump report0
   intel TDX A:
     - Field 1
     - Field 2
   Signature VALID
   Certificate chain
      A
      B
      C

It must not be something like:

$ attestctl dump report0 --kind tdx_legacy
$ attestctl dump report0 --kind tdx_dice

Does it make sense?

Whatever labeling you choose has to follow these goals, and there is
some trade off between making thing self describing forever into the
future and exposing protocol details into the guest kernel driver.

The future scares me so I would always design to include a description
of the blob from TDX module to the guest driver :)

Jason
