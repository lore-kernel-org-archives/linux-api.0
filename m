Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792770135;
	b=h2QTxilvPq58f4SBEGiP6DE7GZuPokM3C3IhAAA717tujyAqOm3xETdzYh1Sx5iXwoFU
	 lVPZ3OwDZvBZFBOpNLoeQtkl+c3SkRgEvTAB472HTGnNBs5zexK8ZQg9MhPym9qyt5gqn
	 X5vT+vrxHhkwpTur1QYYajagHO9sBldhLZz1xGk4CC9AezOMhnWW3tAxiflgkLFC6R0pu
	 qJ9ui30iutqxHxq5bWlpx99n/lZebUb+xuGN+5gQ63G1quM86GdOuhJ6+mdmeS4s5p/ox
	 nDLTlyWN8MopFQApNJV5FrwZ8TmUYXysj/T6+S5H64hwmmMS6jbGJmt6Neht+nVAMlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792770135;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=rug7Neq15IHiij489G0zvk8NhY0SVtgpPgzc6r/gkrk=;
	b=4gsyH2rt02DNBdk+NHIyi1GUDoESdpWj3ZwpR6dpErW00cKT7hAMoQDM4gcVxmhGd1Y3
	 w0qfs24g8vMOLxV/cPcIFsRclBp7xpE9Mu6PzTxE/qBpaZQfuBk5NjQfGGNdQnc+OT07O
	 EUSY7d+CPeA7KDJDWBd08PEaQ8uluApp8GkcYO1qjtyMFtTHxPnUq6P9fQs07gJtVrDRx
	 0t9jL2Zoqu/2/zMh+rQ36cM3VsUTMJ8BcF+XreuRPU7kqoSy+QKrtOKQeuz6F+XgMbExv
	 HD6PvobqVXv+JkiEgmKCt4y5zkCn6B265GDKnwE4dufj18PIr9W5JXsUpLcfjiOhwew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=c27WBFJ2;
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223D8606A32A
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 15:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 223D8606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=c27WBFJ2
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93cc1ab5f6cso108617585a.0
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792770134; x=1793374934; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rug7Neq15IHiij489G0zvk8NhY0SVtgpPgzc6r/gkrk=;
        b=c27WBFJ20LlEkXwtFWR0pToqFQOALwL+bcaaVuyVwXUk924Vl3bY2TE+HzwUkjjWpt
         QaaeAPi6z5Ti+PWEFO4B/P+zy2aL4YiNfo4wU22IWJR8UJl5UsOSPZsuUwdq+P5P5bI9
         72boUzrYkytCjS3Ko/P0xykJ3PbDwA2rQfd47sTgSJkaHkjkNaWVyqh7Xfj2zU9voNek
         oHWce6+kRLUM7XPX8O2BXEN48XjkeD/eVwT16b3bS4zufHv2bthZ5aNwPUaW3+/wB8mR
         3LSVs3lqw0vf+xIhH8LUjQVpYyx9cBXBWmBXwJ0sj/UDAKDRx/Nl2/3V8k+ZJ60Qkgg3
         R0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792770134; x=1793374934;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rug7Neq15IHiij489G0zvk8NhY0SVtgpPgzc6r/gkrk=;
        b=PK3t60u7vHSjaXbGlVsBYnsDPDUW66NZW5rlxhq3TNBnblFZg0/YCExpeFU3sX3iYa
         m8F045OTgd+EPQIMm3v5Vs/wQrOrmi8IaK9enO3+WMtsv5LWcvuNLeE4iTQsUgKhYEJj
         vO/ZyzgLBwnm92c8gJsR4Xyh0Gi0l2m68JrhS9wNgoH/UspmD4TH76hMhvtsgN5TW8Z/
         W/c4BzlRCEZVeQILLDpOCosopaKYFoZmqNURUE7HyZEjJAUAAuo41Dxduma4Ong9lkhx
         Jb12Z5WrItJZBDgwOZiHN5ixX4B1iCyIyamKOKKHcgrDaPf8WHZ9o4I28yuiH/nADtrv
         uLbA==
X-Forwarded-Encrypted: i=1; AKwUvBxWaCMlBFKfYbOYuYRgryMa4abIt6y4IoyYUwJ2PF4hikTGjjJXxYLXYcbcPV/kY3E3wVaGaHQtdSo=@vger.kernel.org
X-Gm-Message-State: AFq9FYJdpjWjtjCXNsmNiZj2ITqzT+qNGvK+OEAWsxF623oMf9/omqYZ
	4GBUR6kZG8dP4P3zxLUYN+76l/yZpgioh23FS8yoOcLgsvMFSS52kh11Wribru2Z9OI=
X-Gm-Gg: AYBFou2PIqhGzOS1+LQlA6haDvhExXHYTRLwxshoofAGw06k65NzpDlFewcAZD/cvQe
	UxA3Xhz70RnNsRKcZVnP5zjPu4jSye/I228oBPdvOMA+8XJRB61g8GwwJhw3XLxPvZE1m1oMIKr
	RE8XrtZmMmIngXAMDhfg9iSU/v+LzR//FHZ8AxlqHC1q/HOCRCEPmYz1fwu1yEVmqJRu2mJvbrd
	Q3rtp+OqCAGg+LSmimvc3NRhopXtX75SH9T/R7U5TSVWagdvhq48pxxjpTbVKVgHqjpgPA8QxGE
	8J7rGVr5HTGcq34/x4ewemWDi79Jz6YUv7gtXN+3vfoQilXtfs2zHmbgPpNC7pOHq+P+ypFjHc5
	1ApGLtSS2lHsRLgTZG8LPPysMj+/z2hrYWVUwFSvUUHvIZp3mnq9a7kL9VyTyI2wSbgCmTKdOOL
	ajQxaAoOpN2iRmxipkeDnxZRpWwIhvKd3cm1+c3+KA2/y+Gjwo2dqeB7ihKsJw3Ut36faAI0+TG
	bAm+zg6F+tXx3xOb7W3iDPKVVGbbo66pd4hSjH9C9nlXVtKGRbODEnLp/zA/BR51CWZGGQW8DmR
	qWUg7WsURYxH043UETE3NmhQU9GWDheNOC3KfQ==
X-Received: by 2002:a05:620a:1a11:b0:93e:5ef8:c794 with SMTP id af79cd13be357-93f6f9648bbmr497429285a.38.1792770134059;
        Fri, 23 Oct 2026 08:42:14 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94047b362a5sm45129985a.33.2026.10.23.08.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 08:42:13 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKHPI-0000000Gn79-3Zzp;
	Fri, 23 Oct 2026 12:42:12 -0300
Date: Fri, 23 Oct 2026 12:42:12 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
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
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261023154212.GJ3977851@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <yq5a7bjajaco.fsf@kernel.org>
 <atooh7uO2RauUTfY@FV6GYCPJ69>
 <yq5av76sj10a.fsf@kernel.org>
 <20261023142038.GE3977851@ziepe.ca>
 <yq5ase1wiggs.fsf@kernel.org>
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
In-Reply-To: <yq5ase1wiggs.fsf@kernel.org>

On Fri, Oct 23, 2026 at 08:58:35PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Fri, Oct 23, 2026 at 01:34:53PM +0530, Aneesh Kumar K.V wrote:
> >
> >> CCA currently takes the device identity index during pdev_create. I am
> >> investigating how to retrieve the certificate chains for all slots. For
> >> now, I have implemented the sequence below.
> >
> > Yeah, I think the consensus at LPC was this may be a gap in CCA.
> 
> I checked with Alexey, and if I understand him correctly, TIO also needs
> to establish eight separate connections to retrieve the certificate
> chains.

Lovely!

> For now, I am trying Jiri's suggestion: use Rust SPDM to fetch the
> certificate chain and return it via evidence-get. evidence-accept then
> does pdev-create with the specified slot number and compares the
> evidence data returned by the RMM with the value cached by Rust SPDM. If
> they match, it uses the cached value for set_pub_key. This seems to be
> working. (FVP only supports slot 0, hence only one blob-instance)

That's a pretty good idea, and works for every arch! Maybe that is
the best long term direction.

IDK about all this "Caching" stuff, I'm not sure I love the name
"Cache" to refer to the security important reference certificate
bundles. It should have a stronger name to reflect how critical it is
in the entire security design of SPDM. You select the certificates
once and everything following must match that or something bad has
happened. It is effectively a key part of the channel binding.

But yes, RMM is sort of backwards here, the slot number should come
with information about the certificates, but I think this is fine to
have RMM fetch them again and then we just confirm everything matches
the kernel's target. If we don't do a get prior to connecting then the
kernel would just adopt the RMM's result as the target certificate
chain for the slot?

It certainly seems like it should be all sketched out and the uAPI
confirmed. Given the state of things I don't see an issue with a slot
0 only initial configuration (ie EOPNOTSUPP the certificate gets) so
long as the long term resolution is clear.

Which is an interesting question for Jiri on CTLV, one of the things
we have in RDMA is runtime schema pruning. Based on runtime device
capabilities parts of the schema can be disabled. Can we get there
with CTLV too? Then introspection could return if the underlying
implementation supports some of this stuff..

Jason
