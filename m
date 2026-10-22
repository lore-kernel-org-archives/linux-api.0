Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792694602;
	b=jeMAn2eLjVYBnyvV6e2EEu4rxgTDjwxih5MhxbFfF4RFJ4AKwktr0DqqZ5PtTuVVYwwT
	 0L4YtXfLpQwlbp/Ou+T4dVbtyHk7clKrAn4+kyErSjcqu50GJp1SAdi+uegU+5eqaES+Y
	 REDuzISyxuGbB6mZmSJtQeQgtVlu0kSgF9sAlUZgod8rRwB6AfSqQtSvWUnXIqTCVQvvn
	 IWB4eTJwwKxF4gkaylrzCXB8ZNzOMSumZvaLvUooB5SyUnWuPf5mH/c8ZDUGCsTseVeEt
	 8MokMieTRbCNtzBe0eZk/z4udpRaIHchMeKtQYfhqrNyuTnpZcVaaX9GT9L78ftR7hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792694602;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=My1VAgj8tQx3tGuGu6tSDqUUuD+FQDqeoDBJloW0vMo=;
	b=428fRNJpcsW7742chzJbedsIoZ5pw0p6ktmZiEyfhOOO5nBRbRoqgpjpCeJydLC6vr7x
	 WAAmL8ctRVc5i5qc5nfvwisTYk0OcM9XrPWezs7ceywPCdL1+qviVw2CuiE6D5xf08MDY
	 NqH20kwjTXYqMt2mauE+y2MoytIrOvBD0AJ2uxpnL//7jBXplWHVuNAd6qlb4xlGBJ2LD
	 QROmF0FqCn72EwU/ZKS6xMx/d5wOZDNJPdl/8cHOz8YgpFM9peE2w5+QN8VPYmpaF5h6X
	 RHsXcKi6Q5IQN/yDgdkZ3zQeGnAZb7JDg+Zu9hOihkS0516llkmwzxI92WuSRXmraKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=nKJi93LP;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4B9606A31D
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 18:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D4B9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=nKJi93LP
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-917997ab0d9so2081316d6.3
        for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 11:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792694596; x=1793299396; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=My1VAgj8tQx3tGuGu6tSDqUUuD+FQDqeoDBJloW0vMo=;
        b=nKJi93LPc48Esxvohip1vSyHieBUQORNbKUhASwH832yq8/YpN7cupzfybrDxNZpwb
         9Tux6bXq8BPZTnJ0xrIE2ypof5Mq+DgTPuRBxYrlMvJ7pvPttb4ErfUwG25/5mEAyvsX
         3i5SsTcaAThuto3P5oLgORukoVh/lCAgW8PXZT/kpbMhDVHYC+YqWMZDs5Zjv3eKswZN
         T9PVuV+Y/yAla5vrjn+/dQ4k8GDIinY/XCI/+tg5+RonRfWg2hghEjHgY8otLDvEhcBs
         2eFakYN6BWX9BHluQ2GWKp7JHXTFhcYL1XE2jxLpRChT+kYtkIuSe2t5mEbD2G1YBghp
         1nKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792694596; x=1793299396;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=My1VAgj8tQx3tGuGu6tSDqUUuD+FQDqeoDBJloW0vMo=;
        b=pa7eg/M9KtjQq1OTLgPKbiEmWTPzNR3wIRr49rrfU84VQfuE6bKKyYg1DGtEcgoX/q
         YFyJM0IQpsVtyHMog5mOPG3fdTdKcmXvcndIwKyZrGpRNGzXj/b6niAztBNWRz/JKlNT
         vNgtl29kMKOYinQKRWD0+oDBjwpDr1duyC1KkLJldIincrEA6u70v9TnMup31q1rxrBg
         6QsVTheylCRlvVASPR0l9ULOlfPStbTXtbpMoQFCh5OFSAXTpNKH3lAN1lDCNJKtHgXV
         xUByGk1yfHAFHpz7ig0TUcK6deJ5jxHJx6vulIdMtuzbK7P1EM1rwXQD3jlAk9EWNC4e
         gNXA==
X-Forwarded-Encrypted: i=1; AKwUvBy3VpiLZ1wprus6Von27768kPVUgxFUSydUTQHs1xXOWrUzNGhb+8X81SNu6RG9muUd/GUXfqDwM5s=@vger.kernel.org
X-Gm-Message-State: AFq9FYL3c1EQpl3YF+/EfBqMQ0ZCK8/JUw7VH63saF4bwaW/6yeiqwm6
	gZtVh+hMy7HYzEj1dD5nwK+Eiv2IYSCj4qHqWZNDNUcSj98Ky1gQmXgpjfb5pGAZtlo=
X-Gm-Gg: AYBFou3A00i7zkHlbTSMD+HZjurMJ4tI2OGsLKtcJFkuEzlhK0EwyyJxuv175NB2DPF
	ualS4i3Sv/5Z51c26WtDrFqwc09MMA3cwkkIZ578zyb5KvjonxA4hlO5wKDQWNu0GxC1A3v7yga
	7oijUNmttmLnVhTfydXMqJdq6X2GBQbh6NmtB+WC/NMzHk0zPB6Rysku4BW3Ne0nYJNPXSyLua4
	1ArSX5bYnLBYEnTekd7VX3ReFLs720p9J+GFYreTtjjRiIJuDpxA+c2WZwRVO1NFJjVkG1mXq5l
	wBoC1lriwOIsG77nQCAsKFhLq13Hea9G0Zrf4Sd8CHIuppfu9nzKUibTye2lO5aUvAdRzWN82KF
	I129mN3YJDLKIk8yWBJcpLjxiqVVwnKbp4o0nJ7S6W/cq6srmXnx84IylcqRd3Yb0tphdqbOOXg
	CuU7i2NH0fbjLcjTy4/z4FVk2MIjeuxCH9ly7LjSLQSn3U7vgh80Jgasi6nHwfyuJ/rgwlloueR
	NxJX4GrW19PX53gbdf891JsP/QJ/C6NqbligYK/Y7dZB60ybr2s4gqz+JfyOu75oavRLZM4tfvv
	AW5gq4UpB2lTVZFvtByxoLKzCzFMYXwDfT+PPg==
X-Received: by 2002:ad4:4ee5:0:b0:91b:8b44:d4c7 with SMTP id 6a1803df08f44-91c12ee2dc3mr106716916d6.26.1792694596058;
        Thu, 22 Oct 2026 11:43:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c37060bb5sm4070256d6.24.2026.10.22.11.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:43:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xJxkv-0000000FjQ8-3dAv;
	Thu, 22 Oct 2026 15:43:13 -0300
Date: Thu, 22 Oct 2026 15:43:13 -0300
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
Subject: Re: [PATCH RFC 12/20] ctlv: Add device and operation dispatch
Message-ID: <20261022184313.GD3381610@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-13-jiri@resnulli.us>
 <20261021022505.6fe1b1bb@jic23-hlaptop>
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
In-Reply-To: <20261021022505.6fe1b1bb@jic23-hlaptop>

On Wed, Oct 21, 2026 at 02:25:05AM +0100, Jonathan Cameron wrote:
> > +struct ctlv_device *ctlv_create(struct device *parent_dev, const struct ctlv_family *family,
> > +				const void *init_info)
> > +{
> > +	struct ctlv_device *ctlvdev;
> > +	int devnum, ret;
> > +
> > +	if (!parent_dev || !family)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	ctlvdev = kzalloc_obj(*ctlvdev, GFP_KERNEL);
> > +	if (!ctlvdev)
> > +		return ERR_PTR(-ENOMEM);
> > +	ctlvdev->family = family;
> > +	init_rwsem(&ctlvdev->registration_lock);
> > +	spin_lock_init(&ctlvdev->transition_lock);
> > +	ctlv_event_device_init(ctlvdev);
> > +
> > +	/* Before anything reads the schema through this device. */
> > +	ret = ctlv_op_resolution_init(ctlvdev, family);
> > +	if (ret)
> > +		goto err_free;
> > +	/* What this family's events need of every queue opened on it. */
> > +	ret = ctlv_event_sizes(ctlvdev);
> > +	if (ret)
> > +		goto err_free;
> > +	/* Before a minor is spent on a device that could not be announced. */
> > +	ret = ctlv_device_uevent_check(family);
> > +	if (ret)
> > +		goto err_free;
> > +	if (ctlvdev->dynamic_ops_count) {
> > +		ctlvdev->disabled = bitmap_zalloc(ctlvdev->dynamic_ops_count, GFP_KERNEL);
> > +		if (!ctlvdev->disabled) {
> > +			ret = -ENOMEM;
> > +			goto err_free;
> > +		}
> > +	}
> > +	devnum = ida_alloc_max(&ctlv_device_ids, CTLV_MAX_DEVICES - 1, GFP_KERNEL);
> > +	if (devnum < 0) {
> > +		ret = devnum;
> > +		goto err_free;
> > +	}
> > +
> > +	ctlvdev->dev.devt = ctlv_device_number + devnum;
> > +	ctlvdev->dev.class = &ctlv_device_class;
> > +	ctlvdev->dev.parent = parent_dev;
> > +	device_initialize(&ctlvdev->dev);
> > +	/*
> > +	 * The core owns the file operations, so an open holds the core module
> > +	 * and not the family's, which may unload while readers remain.
> > +	 */
> > +	cdev_init(&ctlvdev->cdev, &ctlv_file_operations);
> > +	ctlvdev->cdev.owner = THIS_MODULE;
> > +
> > +	ret = dev_set_name(&ctlvdev->dev, "ctlv%d", devnum);
> > +	if (ret)
> > +		goto err_put;
> > +	ret = ctlv_family_claim_add(family->schema);
> > +	if (ret)
> > +		goto err_put;
> > +	ret = ctlv_family_privs_pre_init(ctlvdev, init_info);
> > +	if (ret)
> > +		goto err_put;
> > +	ret = ctlv_family_privs_init(ctlvdev);
> > +	if (ret)
> > +		goto err_put;
> > +	ctlv_op_publish_all(ctlvdev);
> > +	ctlv_event_contexts_start(ctlvdev);
> > +	ret = ctlv_family_privs_post_init(ctlvdev);
> > +	if (ret)
> > +		goto err_fini;
> > +	scoped_guard(rwsem_write, &ctlvdev->registration_lock) {
> > +		ret = ctlv_device_add(ctlvdev);
> > +		if (!ret)
> > +			ctlvdev->registered = true;
> > +	}
> > +	if (ret)
> > +		goto err_fini;
> > +	return ctlvdev;
> > +
> > +err_fini:
> > +	ctlv_device_fini(ctlvdev);
> > +err_put:
> > +	put_device(&ctlvdev->dev);
> > +	return ERR_PTR(ret);
> 
> Jason did some nice handling in the fwctl stuff for
> device alloc and hand over after device_initialize()
> (I've copied it into a few places recently :)
> 
> I'd like to see something similar here as it made
> it easier to follow lifetimes etc.

This is really at the wrong layer.. Attestation subsystem is the lead
subsystem, it should be allocating the struct device memory and the
driver should see the typical

  struct attestation_dev *adev;

  adev = attestation_alloc()
  [..]
  attestation_register(adev)

Sequence in its probe function

We need the subsystem refcounted memory to exist if we are ever going
to create a kapi and common functions

Jason
