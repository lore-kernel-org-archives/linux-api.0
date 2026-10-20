Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792500923;
	b=kdItIgVO/mxJ884/VGLU5MhJxo92nlkM+v5Lark20icAdAapduTTIziiUf8sgsgDzo9t
	 lLsJS/dpcafXJ/MliuodhOhpKJS299ue7kGsPvxAgGXGci4C4fC1ENouPkIOjIPia90BW
	 9PtptGRWwOQtAkU9JVc2fKspBfYsUH7ezvE57G1RLipueCyIBKJktR6aCIF2JYTeRBqKX
	 y3xrfg8bE/yk+HnHAeVZcuxSJ7fgEsd0Nzfd0miFln+XGfU9lDFBL7Li7tlcCLIqAsNfK
	 IkLqomayEwoJ4So3JBAdrzitJvqLoU0ha2m5ZmYoLfViBT1q0oxnZDL/ToBrIBWMidA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=XQOUTOVFh8JzZI9kzVmkfR5g5tplHfGAGARfyUUcUvk=;
	b=g1/U/xVmB+O83Npw1OStwclTKyuHLGI3Q2wD15lJu3GqT12kYEQNAbCRPjX5+ie+XB7B
	 K4PKITPCpfKz7flA/1N0t6FfVZ1YwwNge1I75/FOm9doG3aq8W7t1Z42wwpcN3on7fHgj
	 xa1paQJm8VcnIBhBe92M98iv41188GHBpOO9zHM01AFb7gkwpBTKzj/xGwfg3amP+u+lZ
	 Sb/g9ryVh4G6e40hA3Ahe6Yq3PSh5xteGCKoTcsvxasyqm+IZTa84L5GTVQHdXy6wOI//
	 WjKe5IgtRy+3sISwRVXUHMEG4gg1maUYL8Q/p+jU2zOl27pZ8oFzfC6uime6yNURUag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=AwG15E1Z;
	arc=none smtp.remote-ip=209.85.219.48
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040BB606A31F
	for <linux-api@vger.kernel.org>; Tue, 20 Oct 2026 12:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 040BB606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=AwG15E1Z
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91b54d1e9cdso28582316d6.1
        for <linux-api@vger.kernel.org>; Tue, 20 Oct 2026 05:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792500922; x=1793105722; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XQOUTOVFh8JzZI9kzVmkfR5g5tplHfGAGARfyUUcUvk=;
        b=AwG15E1ZRPKZS56zseZDToB2Qd9YJbTawLLcr9h1GLur1yCKOphB9CZeYoOaDMSbVa
         RrPlrw5eMLSbJOuslxyszTx4NmEnv744KuWIwG3DizDX0uWRbErpkLwFCuAWB+o9DRFg
         UDL4ypgxiss5CkG9v/9yYGF/Wsp/f2dCLf4e6CR3fB+jtf8r2d9o3+KYLDv1ozPWgId0
         qwRZmFOw7C/Ek9a3K6UDlQQsnDrTtjosSM7fZhX5JREOkWrFCKLppw8Pmb/qLty56lpP
         ZYj8Ee583y70a0njyljl7Z1GKpSK+nqzpOa7hK8N2VSD0I3LKpuHkedfhTxNE2H7j0za
         9QeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792500922; x=1793105722;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XQOUTOVFh8JzZI9kzVmkfR5g5tplHfGAGARfyUUcUvk=;
        b=CFPJ9Z5aT6XPoLxYytRFX/BPzQEV3fIgJsOeIob2Aib6oZVAZx3KKxg6I8NdS8k+yl
         Ml+3hrokuhwMtKvT/Q82Vdzk56dqAbPBTYalXUSPWXMpqgftKR472PV3WlKKKAA/ocZo
         BkywARxcx+xS24df++75cSzk9HqBLe/VnSLsiwTWXPOWvJ5qtJPszejXtDwHii4yY0Xa
         e66on/K4U/sbnD8j1BH0dlcJZWZlWc/Hc9YJSGno/4XDuaofW3a2ZF9tmY7OyLwjrvOv
         FhNGHyZZSoZcQEu2UyO54pQh0ZX7DTrm5fA7iWPblTeSEvpB9E/UfU6QXf6utGaIYMIU
         tZfw==
X-Forwarded-Encrypted: i=1; AKwUvBwlLwAdDvWoBeqDgy42Vap1JYqPdGtZGZRfcz7S+OuWDqc0YiuqVYN6VXxikoJiywhUI8IMDQ/ZoDA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLJIBX7Azf1izG7wCWHXLhxS1IAdIrlDK3jYTQTgeJ2gq8RCN18
	FwMsPX6ziNG71BxTvl8Gm8oizmBEyxR+GQknjBlbxbMgRfWMAP3S36HDey2dkg2PDBQ=
X-Gm-Gg: AYBFou3CpdqVJdPWAxpNcRiNk+WRW5NGuz3PN/1mj3dlrYhPabdBxRgTFgR0CZrkGx2
	l9RJqfi60ZZ+e5oZ17hVCCdMT3g2s21oT9g2Ux1dC88hZ67xMd8yoVqsNEwU4Ln1YEnwWwe2RUW
	ervft2EcYRmFp+x7KhXuct2qid3DfMfiUZ/36hWBPCI2uN31d6R+zDS50+Qv4lZIA7dq948GPql
	huh6HWSpOC91xAZJrJPvYpjFpIPNWY3YtMCJGxOA5PfGgGLLWiiBsV9CMKauy2a/Nt/rNF3gezE
	lQq+MbmvTsjsqoG/Rw5OlB/C5NlgsZPJcSwgEtGYb/xoOLlOn9QBtluFMOp3cGmhMS6lMlA+d5v
	p3H3QAS7rDFLaWzp7sGDNZ/A97EWtNEg6EuhH9Lszw4KVdxUSnFDJ1UUS0GMy/EmFqsRGs8S39e
	04uqNMkm4p3dVEbiRs5PdKOGYQTF2ZKlSnhLib0/sRYRTZ0vCoRf5YJigIild+7v1jy/UBeumE1
	dRWTku2TzasxwtU1RDYKNIL+4so7iWGEmO0a8IywyullGS8i0up1frC
X-Received: by 2002:a05:6214:626:b0:917:8752:8214 with SMTP id 6a1803df08f44-91bdec2e198mr180120836d6.1.1792500921889;
        Tue, 20 Oct 2026 05:55:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c03da5b4asm26796476d6.0.2026.10.20.05.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 05:55:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xJ9NA-0000000CTFP-3VJ7;
	Tue, 20 Oct 2026 09:55:20 -0300
Date: Tue, 20 Oct 2026 09:55:20 -0300
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
Subject: Re: [PATCH RFC 03/20] ctlv: Add the root family specification and
 generated files
Message-ID: <20261020125520.GN14213@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-4-jiri@resnulli.us>
 <179245258505.58760.6060356114682279013.b4-review@b4>
 <atdeH3nA_gkLwPLM@FV6GYCPJ69>
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
In-Reply-To: <atdeH3nA_gkLwPLM@FV6GYCPJ69>

On Tue, Oct 20, 2026 at 02:28:55PM +0200, Jiri Pirko wrote:
> Tue, Oct 20, 2026 at 01:29:45AM +0200, jgg@nvidia.com wrote:
> >> [ ... 238 lines skipped ... ]
> >> --- /dev/null
> >> +++ b/Documentation/ctlv/families.yaml
> >> @@ -0,0 +1,13 @@
> >> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> >> +%YAML 1.2
> >> +---
> >> +# Append-only registry of CTLV family names, indexed by family ID: the entry at
> >> +# index N has family ID N, up to 65535. The root family owns ID 0 and heads the
> >> +# list, and every other entry comes after the entry of the family it inherits.
> >> +# An entry may be marked deprecated, but never reordered, removed, renamed or
> >> +# reused, its position being its wire identity. Every entry must have a
> >> +# specification in specs/<name>.yaml, and is added by the change that adds the
> >> +# implementation. Fixtures under tools/ctlv/tests/ are not registered.
> >> +
> >> +families:
> >> +  - ctlv
> >
> >I see where you are coming from with this, but it is going to be
> >problematic from a global kernel perspective. Given CTLV is imagined
> >as a general tool for any subsystem we cannot control the tree that
> >things merge through. It will not be like netdev where there is one
> >authoritative tree with a linear history.
> >
> >So if Bob and Jane maintainers both add their own subsystems by the
> >time it gets to Linus the IDs will get scrambled, and bisection will
> >be lost. 
> >
> >Either changes to this file must be strictly done in a single tree
> >with shared branches (which is going to be a bit hard process wise)
> >
> >Or we need to put the ID #s here and have some simple process to
> >coordinate them during the development process. Since new families are
> >probably rare it shouldn't be a big deal
> 
> Exactly. Collision is not very likely. Explicit ID or implicit, scramble
> would still happen. And in that case it is resolvable.

I think because of process if it is kept like this we will have to
merge 'dead code' to reserve spots for people doing new work..

But at a minimum this comment above needs a big fat warning not to
change this file without consulting with XYZ to coordinate merging.

Jason
