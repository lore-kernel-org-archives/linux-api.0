Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792659948;
	b=LcCSY15ferLjB7rpVxCl+0OrkJKGSO0f36hdakxCl9gny267qhzxkQvTnu+EygLOWJiZ
	 5U1OdDTYwPn/bZ8ICTv8r/UD1M7s+9EK36Kz61P0mpRhvv3/vmzX69sq0Fmt7pzyymeHr
	 i+1cR+BYkQrkpYAtexrtJF3TSa0Zc2+kaxjoVJssRG1c+dmqMF9rB24zcwR+5saGVPdYA
	 gPCwbIRsTm8xnakZu+bvSoiRmDOX8FwOqLEbDKpKa4ATk2Z+/8kKIXuwb6XITkVm2ooHD
	 5O8r9+KNVJwOdLpNIjVhbB2sa7GUL0FBxWoEPGeJpHdSSAhQaSFyyW4OrH6QZ9Z0CZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659948;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=VCtPLF1g5YCJnqvDxXjL/9SGDpcHIvBwNuJeTWJPyWo=;
	b=fKumToE/l11eOZmrRBbdjNyWvUzfRdT02X4vgg9M6/Pd+YTwG3UjX2q2Uze90l+xhFsf
	 4tCe4ixvTBfGWVUCA4PSaZtPL4vt3VDKQeOdvgi9zpUIzGT6yRdqATg3aa5GS7g0CNb5j
	 JfsQcBmj8x5Ld+Bk1sqSDROJgqjsE9Kd30Sy8kK4oyggInrq5vv0FzClekPfKSHlw5UGy
	 zhADa++5FWIJzyvjG0rEidAAlg6nxwsa34L5iiGMB3KK9KTTUCZ8tvv+yWg5c1mrObRML
	 DTKZuftiCCzXQwoI2+I1xp/DLAEkUkuUusc/4uuw3rlm/qw1c024bxHNFCSuUZOK0xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=CG4pwxKj;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6465F606A320
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 09:05:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6465F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=CG4pwxKj
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1347198f8f.1
        for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 02:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792659947; x=1793264747; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VCtPLF1g5YCJnqvDxXjL/9SGDpcHIvBwNuJeTWJPyWo=;
        b=CG4pwxKjkPq41V9lUY1xPtyLM7VGkWfj0wIo2355s6BuBYcgsuRPWfhiVq6CnU5EUK
         U6ISRUDw6LP3pxCtWf53VXIfVLLFARjt5/A5RTFt+Wj5BQOl97jTWy5uCVl0uJZWZjdx
         5QJOnQ67tU8DZeBGkIBPmyGxUBNX8t40T1FxTQcWlxN/XSMqIzeI5/KwqhLXE/nZYg/2
         l652BLCNN5Kg7dZMEBleKvf3x4lpyF2+1ohF3/UOY/Bo5ex0KS/FI4UCDM6fFbSf2m7g
         Jwj6H3TFMAkXXh6cmYl2j5nTS3Z5Ixi/a1aX0e55EA1spziMAnLVlnozBP/BV3o2LlvG
         bjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659947; x=1793264747;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VCtPLF1g5YCJnqvDxXjL/9SGDpcHIvBwNuJeTWJPyWo=;
        b=KMWl5TaVxeWJ4uAUDWL2rdZrwScPB3hPwTUrZ+v99fRjxpFdTOYOZG8wmfhV9ZvUZR
         REhBVTFirAw1QMnQSZZJnXHPkbKsZrykYrADgZsMFWLKt6rDgvjMINShFeteQBgDp2L4
         QKPZquGJFa+Yic0ML0W33qeDtcFLtkiGSslfipoYmmtBDhMsCgplKlAWBLXEEzgRrsAM
         h8cJ5vHvD+rUqCmE+C0utbDfwzrKuZLYYu3MHeEVrUuh2WDgyn9VaufFMw0Mdts+lXEU
         YYABhsibcjB7f/tCmGJEkVxIbqIXyjIRIbSuUIeGEw4ul1yRwUeCXvcL04hP7pRHgNJR
         HO9A==
X-Forwarded-Encrypted: i=1; AKwUvBzntVUNRXgzkv7S5Yt78JEPeMMZlePmPKuFgXbmdsc3yUqvTZlmud4PzAR3KSQu3hiFyxoBq9hHC10=@vger.kernel.org
X-Gm-Message-State: AFq9FYJNuER4fNsNZ51JKfSM9VLeN+UrcUfJJQ41AmOzk6DuNO11x8M2
	aqeT1l5M22K5atCoQPO5oPg25A3PlSqZnJJ+RFoK/xB4BQdtn0JYIPRPhii7ToCgWek=
X-Gm-Gg: AYBFou21bH6O2gTDi4y7BnrPuG+wasEYgQtwfp9Q7MWiBNNfq1TPOMs5kg+d4Zq2dAx
	O9vGWPlirXOpEqAJGA6grahM5QYjaoYELVGd7p5brJ8KI6eZ3yfgr5lKNewKgVd07zvNCR5BV7/
	TL4805UWLUtAvT8fVM8Jfy9GrnNY3Yi9U9dRrO/qCg+Oq+b+zc9NPiFqftw8PU4OjqAqhW/VTWt
	rCm7unZP52xI9/THDIbm7P6VUqVSe8nShsKLRdBXoZA/l3WeLv4bwjTbzO/r1fKENBG3NiWKsUN
	3gOs1JeYszfaqaK77hLmvVeCx35iSHDscSOfmOAfclFq9zXRQhKYUldykt89t/NchzJyZ1uW7cz
	ZS/cWE/nBRzUEt98oCqvjAjkSfExSbgIj9d7QtNpC144vARktACIojB/+FuORyEPqU9r6uwVSM4
	DE8ao4YDZXcX7vBng50xhnEh5QewNb9Ixx8kS/Njx9RVMQI0IQ3vKW+Ia06wWJmEt0Q/5fBA8vn
	z6hkFkU2ougk5STMpEueU5f4iApoXAYrIK+h4Sc92g4BPxgTWS5hG7Y9v1ozXJY
X-Received: by 2002:a05:600c:3b1d:b0:4a1:d41b:5060 with SMTP id 5b1f17b1804b1-4a1fdb1358bmr98096365e9.22.1792659946257;
        Thu, 22 Oct 2026 02:05:46 -0700 (PDT)
Received: from localhost ([128.77.52.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203b28f70sm62056445e9.4.2026.10.22.02.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:05:45 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:05:41 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 12/20] ctlv: Add device and operation dispatch
Message-ID: <atnRsQHieSNzE51D@FV6GYCPJ69>
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

Wed, Oct 21, 2026 at 03:25:05AM +0200, jic23@kernel.org wrote:
>On Thu, 15 Oct 2026 16:50:45 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Register CTLV devices, resolve family chains and dispatch operations
>> through validated messages. Wire CONFIG_CTLV and the generated root family
>> after all module objects are present.
>> 
>> Assisted-by: Cursor: GPT-5.6 Sol
>> Assisted-by: Cursor: Claude Opus 5.5
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  drivers/Kconfig             |    2 +
>>  drivers/Makefile            |    1 +
>>  drivers/ctlv/Makefile       |    4 +-
>>  drivers/ctlv/core.c         | 1517 +++++++++++++++++++++++++++++++++++
>Normally I'd push back hard on too big to read, but it is an rfc
>and other patches in the series are much large.
>
>I'm out of time for today and not sure when I'll get back to this,
>so just a few quick comments inline on the bit I did look at.
>
>>  drivers/ctlv/device.h       |   17 +
>>  include/linux/ctlv.h        |   55 ++
>>  include/linux/ctlv_family.h |   22 +
>>  7 files changed, 1616 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/ctlv/core.c
>
>> diff --git a/drivers/ctlv/core.c b/drivers/ctlv/core.c
>> new file mode 100644
>> index 000000000000..aeab29fe2fdd
>> --- /dev/null
>> +++ b/drivers/ctlv/core.c
>
>...
>
>> +static int ctlv_file_open(struct inode *inode, struct file *filp)
>> +{
>> +	struct ctlv_device *ctlvdev = container_of(inode->i_cdev, struct ctlv_device, cdev);
>> +	struct ctlv_file *cfile;
>> +	int ret;
>> +
>> +	/*
>> +	 * A failed create can withdraw the cdev while an open is waiting for
>> +	 * the lifecycle lock, so admission itself first pins core storage.
>> +	 */
>> +	get_device(&ctlvdev->dev);
>> +	ctlv_file_open_pinned(ctlvdev);
>> +	scoped_guard(rwsem_read, &ctlvdev->registration_lock) {
>> +		if (!ctlv_file_open_allowed(ctlvdev)) {
>> +			ret = -ENODEV;
>> +			break;
>Personally I still dislike the hidden for loop in scoped_guard()
>and using break with that enough I'd do a 
>	do {
>		guard(rwsem_read)(&ctlvdev->registration_lock);
>
>	
>	} while (0);
>
>Just so it is obvious what those breaks are from.

Agreed, easier to read. Will fix.


>
>Maybe I just need to get this one into my code review head...
>> +		}
>> +		if (!(filp->f_mode & FMODE_READ)) {
>> +			ret = -EACCES;
>> +			break;
>> +		}
>> +
>> +		cfile = kzalloc_obj(*cfile, GFP_KERNEL_ACCOUNT);
>> +		if (!cfile) {
>> +			ret = -ENOMEM;
>> +			break;
>> +		}
>> +		cfile->ctlvdev = ctlvdev;
>> +		/*
>> +		 * Commits this description to the device. An open that failed
>> +		 * after this would have to take it back.
>> +		 */
>> +		ret = ctlv_event_file_init(cfile);
>> +		if (ret) {
>> +			kfree(cfile);
>> +			break;
>> +		}
>> +		/* This description keeps the reference taken on entry. */
>> +		filp->private_data = cfile;
>> +		return 0;
>> +	}
>> +
>> +	put_device(&ctlvdev->dev);
>> +	return ret;
>> +}
>
>> +struct ctlv_device *ctlv_create(struct device *parent_dev, const struct ctlv_family *family,
>> +				const void *init_info)
>> +{
>> +	struct ctlv_device *ctlvdev;
>> +	int devnum, ret;
>> +
>> +	if (!parent_dev || !family)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	ctlvdev = kzalloc_obj(*ctlvdev, GFP_KERNEL);
>> +	if (!ctlvdev)
>> +		return ERR_PTR(-ENOMEM);
>> +	ctlvdev->family = family;
>> +	init_rwsem(&ctlvdev->registration_lock);
>> +	spin_lock_init(&ctlvdev->transition_lock);
>> +	ctlv_event_device_init(ctlvdev);
>> +
>> +	/* Before anything reads the schema through this device. */
>> +	ret = ctlv_op_resolution_init(ctlvdev, family);
>> +	if (ret)
>> +		goto err_free;
>> +	/* What this family's events need of every queue opened on it. */
>> +	ret = ctlv_event_sizes(ctlvdev);
>> +	if (ret)
>> +		goto err_free;
>> +	/* Before a minor is spent on a device that could not be announced. */
>> +	ret = ctlv_device_uevent_check(family);
>> +	if (ret)
>> +		goto err_free;
>> +	if (ctlvdev->dynamic_ops_count) {
>> +		ctlvdev->disabled = bitmap_zalloc(ctlvdev->dynamic_ops_count, GFP_KERNEL);
>> +		if (!ctlvdev->disabled) {
>> +			ret = -ENOMEM;
>> +			goto err_free;
>> +		}
>> +	}
>> +	devnum = ida_alloc_max(&ctlv_device_ids, CTLV_MAX_DEVICES - 1, GFP_KERNEL);
>> +	if (devnum < 0) {
>> +		ret = devnum;
>> +		goto err_free;
>> +	}
>> +
>> +	ctlvdev->dev.devt = ctlv_device_number + devnum;
>> +	ctlvdev->dev.class = &ctlv_device_class;
>> +	ctlvdev->dev.parent = parent_dev;
>> +	device_initialize(&ctlvdev->dev);
>> +	/*
>> +	 * The core owns the file operations, so an open holds the core module
>> +	 * and not the family's, which may unload while readers remain.
>> +	 */
>> +	cdev_init(&ctlvdev->cdev, &ctlv_file_operations);
>> +	ctlvdev->cdev.owner = THIS_MODULE;
>> +
>> +	ret = dev_set_name(&ctlvdev->dev, "ctlv%d", devnum);
>> +	if (ret)
>> +		goto err_put;
>> +	ret = ctlv_family_claim_add(family->schema);
>> +	if (ret)
>> +		goto err_put;
>> +	ret = ctlv_family_privs_pre_init(ctlvdev, init_info);
>> +	if (ret)
>> +		goto err_put;
>> +	ret = ctlv_family_privs_init(ctlvdev);
>> +	if (ret)
>> +		goto err_put;
>> +	ctlv_op_publish_all(ctlvdev);
>> +	ctlv_event_contexts_start(ctlvdev);
>> +	ret = ctlv_family_privs_post_init(ctlvdev);
>> +	if (ret)
>> +		goto err_fini;
>> +	scoped_guard(rwsem_write, &ctlvdev->registration_lock) {
>> +		ret = ctlv_device_add(ctlvdev);
>> +		if (!ret)
>> +			ctlvdev->registered = true;
>> +	}
>> +	if (ret)
>> +		goto err_fini;
>> +	return ctlvdev;
>> +
>> +err_fini:
>> +	ctlv_device_fini(ctlvdev);
>> +err_put:
>> +	put_device(&ctlvdev->dev);
>> +	return ERR_PTR(ret);
>
>Jason did some nice handling in the fwctl stuff for
>device alloc and hand over after device_initialize()
>(I've copied it into a few places recently :)
>
>I'd like to see something similar here as it made
>it easier to follow lifetimes etc.

Will do.


>
>> +err_free:
>> +	bitmap_free(ctlvdev->disabled);
>> +	ctlv_family_privs_free(ctlvdev);
>> +	kfree(ctlvdev->ops);
>> +	kfree(ctlvdev);
>> +	return ERR_PTR(ret);
>> +}
>> +EXPORT_SYMBOL_NS_GPL(ctlv_create, "CTLV");
>

Thanks!

