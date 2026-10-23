Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792765596;
	b=VbK6CJ3qsAduS0FfBh2hDgt2Ehr6qmrSCU77+5ptT/MlX5Rqv0I84qvqyPH+EdO/T8iH
	 eNZjs5a8upQKQuBwocJH7yMx31wYNsYJcT+puZpI8EN/BWjRwZZ2BcgJsL1NGj9TfKmZM
	 KTEIqIhjfjGekzeZfkntubiQRHUjzO4dTLShPZLrtJAG4BESRXY3ldZxze/RlnDrNZ5Hq
	 mSLd2u44C/usnJoQ6I+cPKCIk5lkvWfi/wkvVCyru8dl9d4JipIoWIyK9riW9Q4Ih7pU4
	 ToUIMjmTKAbaUllnMt8RBdruzLgOGbdjooppBuZAW8EpJjD3Vwql/lTpvpt/NifNTBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792765596;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=0RgIg1l+3ifUtXqxbecqEIvcyWwa/dmFWxjX5pMBv2k=;
	b=uk+EoKffCIv012FNzjX7HhTIi832bBN4HpwjkXbimXmXJCwYixTMc2l3C1UwCwIPm2c+
	 ubv/rKXZDqYSB2RO+ZHmRUckdyJhpG3F/Fa4OzBqFQJdX5dlh70SemYrdvhRdkQnj/NVP
	 Z/d8ceP/WKgBUnuWQxP0aYuvZi3hmT9gsByGpGA3uZlsraSJ5XBpndI4kgvCjEHXg5LeV
	 GfGw7IbhSXxJ+OZd9IWjIyn5oWw3xwLnTDLhk/AOimHvIcRj8iLU+aR98UoRPGl3pAhyI
	 asCF4QmsBG5IYLOLPTeOYjsp4wwzqqezkTVHkkqIqx5UJ9Z4xPBCOwU83Z/TdKEjclw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=DuYf6d6E;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDBA606A31B
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 14:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FDBA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=DuYf6d6E
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-536c8f958d7so3413311cf.1
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 07:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792765595; x=1793370395; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0RgIg1l+3ifUtXqxbecqEIvcyWwa/dmFWxjX5pMBv2k=;
        b=DuYf6d6Eamd3Mim9JzP6lyLqHMZQ7cyKJdqyD3vzB6Sr2u0uVSkWpIdZeTI1JCnN61
         NIFACP66viSHxdE7SDl5Z0vkYsbly/8y1CfaZRItrer83OcRPXUOgkf7EFlW4VGlKxdh
         Ibu8s0eq8atFnKpxTif1E8wcf/K+m39TnPCWSxdLLek+ly/BYkiswbugga0oEPTHxpsq
         0aLlYBRgbYl8s/ZSMNb9ZITEEZ494ZrhiPsfXxG6KKufF1DcVU0B+j0htKw9QXGscyHG
         1HHHpGtDXP5Ie9+0fnY1zPNtuSAYT2zAG1Js2cHKYqmmzY+Pz52DZZlyK/Tuivj1tXdV
         b3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792765595; x=1793370395;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0RgIg1l+3ifUtXqxbecqEIvcyWwa/dmFWxjX5pMBv2k=;
        b=sCwQwqGa2CSw/8A5q9y2EuuzvFa5GEyqhDWEWRQyWIJr3lmzb8CMCZW+PNeyB+F9bt
         FvCZmD1LR2B0xHvDVL4aX4njbn5fhI4tFSxZiO7OKFvwl9K0pszgiqwNfI1HOihTEIdC
         UjMlmT2M1l6Ld3P8OYXqiMnW/7g1M2qAnlO0by7zyFJgdzm90aLeI5dtVfQPP2PHllkq
         4ZpKykJBOtU9P6b9G0g82SyHpvrKekZtt6V+3cjDAYO/3PIbEbiX++xeS9g7FXBslU2x
         XAqMC86cq1DKSKOl45/ZFbFAAbfZNKsTow0CTegvR9XqVa8jf5JVtPZhl7tknwsAcbWn
         PM1w==
X-Forwarded-Encrypted: i=1; AKwUvByodfCBYg9F02af4y8yjcY8SUBVM9lKqkxMSkr55P2eNAq/2vQODAcUsKCuzn+QYnWb3NAmwrer7ZA=@vger.kernel.org
X-Gm-Message-State: AFq9FYIWWemND2g7CcaA/jEGDSN2+ApnbJ/FYp1QE6XwmaLrlpsHcEWL
	bdvNvbau9qId91WoovfkojFHmR45YXnuueIWDv/as9hCT/XAentfiF4DzSuigQY5NBw=
X-Gm-Gg: AYBFou3n/iOlYlNPyxMa5ejyV8ph2zOHTzRAzGhrEq4/wlbkmJcyaRLn6l1gKSjQEfq
	zpWcAD3sgj5fWmfB64tBJcnS0QxPQl0vUgfm76Q9FYGU4UDInxEOzILxDrLFxPvj29t52CDO4Tg
	LbZlE4Xqzu3xQZmXbySgTApbtHvHFLz1aXUqSy3Itv+YRaP2AcSe7r5sBB3idAAIKPdBkr0Rr8P
	r91Zz1FWZ5Fhdu38mMXIERB8rgf/+4TPOFACXGuxyWiLFqyZMmhOQXoxXxrTXD2/qiFyk8dQfGu
	2OkOkq+DswDGES7gtHEqe5FDaKr54+k8+5b7l7RVViJqFGI8n8WpFReVWhrNTJXbxedYTYN9FcP
	xKDBdudich1w8/F/xwNQLGPA/Kv90fQhqdpIVwEhaqj0/YTy99XNW4t5FukWx9t7KLfH7InhHFP
	ueWGynmisNLO4P3NYIRQ3qyM5fvLn6pPAQeJx7eR/kHNeI0qw/cu8Xx1AP2EabJhzPWMjjWYAyL
	OSxklNjS4gRdjDZ/KvJGUDnWvxq7z+zYUaPVTRAApR+eedckAyRhR+IE56kOV+nNzfl3KCwVMYc
	EBBV8rG/5dEsD6OC0rxUP3XYw+AyJBSSFJwQeA==
X-Received: by 2002:a05:622a:5b93:b0:535:a5fa:ee02 with SMTP id d75a77b69052e-536c2700643mr30249831cf.66.1792765594917;
        Fri, 23 Oct 2026 07:26:34 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536c18afef6sm17177241cf.27.2026.10.23.07.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 07:26:34 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKGE5-0000000GjLW-1mzI;
	Fri, 23 Oct 2026 11:26:33 -0300
Date: Fri, 23 Oct 2026 11:26:33 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-coco@lists.linux.dev,
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
Subject: Re: [PATCH RFC 12/20] ctlv: Add device and operation dispatch
Message-ID: <20261023142633.GF3977851@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-13-jiri@resnulli.us>
 <20261021022505.6fe1b1bb@jic23-hlaptop>
 <20261022184313.GD3381610@ziepe.ca>
 <attZl_0TNMDLgi4U@FV6GYCPJ69>
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
In-Reply-To: <attZl_0TNMDLgi4U@FV6GYCPJ69>

On Fri, Oct 23, 2026 at 02:58:33PM +0200, Jiri Pirko wrote:
> >> Jason did some nice handling in the fwctl stuff for
> >> device alloc and hand over after device_initialize()
> >> (I've copied it into a few places recently :)
> >> 
> >> I'd like to see something similar here as it made
> >> it easier to follow lifetimes etc.
> >
> >This is really at the wrong layer.. Attestation subsystem is the lead
> >subsystem, it should be allocating the struct device memory and the
> >driver should see the typical
> >
> >  struct attestation_dev *adev;
> >
> >  adev = attestation_alloc()
> >  [..]
> >  attestation_register(adev)
> 
> Er, the driver would call attestation_create() which will be a wrapper
> of ctvl_create. The reason is inheritance chain and each parent being
> passed info to and doing its own init()

We really want it to look like the above so we get proper container_of
stuff.

struct driver_attestion_dev {
   struct attestaion_dev adev;
}

driver_adev = attestaion_alloc(..)

Don't want "create" to allocate the memory, it is upside down. The
fixed memory ctvl needs should be buried in the attestaion_Dev

struct attestation_dev {
   struct device dev;    // sysfs dev inside class attestation
   struct ctlv_XX ctlv;  // ctlv instance
   struct cdev cdev;

   const struct attestation_ops *ops;
}

That's the essential skeleton of what a subsystem should look like in
linux, ctvl shouldn't co-opt it, it should embed like cdev does.

Look at fwctl for reference

Jason
