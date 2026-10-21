Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792545917;
	b=Xt2qHP5efUNxHTwGXHxbPbJ6PWXqy5hFpftes3KWf+YjecSmWYopDdge48wFdKah9s1l
	 5ies5R+V+wBRZMwDHt0Te+tvIaAEOuz0VbW79LWsA/HBu1l627sLekRDbhbkf+zRNQvbO
	 O9vC6mKh7/98rqG6tH2smb988Q6VF8l70OySskcB3lo51teWcUuUiX49+45ORe+xXPsmX
	 /7/ZvSCO4Psx9VX8JnfO9hUFRnLhksKSXsJm41YquH4s/uteDROcZdrF6Ab5j08fKlk7V
	 6s87RAm3OK9pFcykdNrpMkhftwlxgPncCoHkByUrrGfZ+80+CLcG1OU8nV445Vg0SpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792545917;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4bdhRhvLCR2OGjIxKNlvor52ldxxtItwDVGS0GO5vlE=;
	b=xaLeNlFpoNXoYFlrh8QGiqOvWXfGGbHiwpiZYOvWRD5RR+VRQuXuzorgW2CPHwY18scZ
	 7yNlM/16CqrN6DIGJ5DfyMzPf3tD0CLKtflHMcfcMqAO8gPwQU2kDSeB2o1td52JpaMYd
	 5k7/ztQvEGEEbMTjxaFty24gdJNICIHq4GrCMN0CX4jvKGxPwXHPDFnKSoI+5mD9UUhKT
	 5zVNyxujdAOIhWQfxcmWfhA7WOMgRCcWny4LwmM/FqPiUr7ogAM9cxmBhTjKMT3xe3pSi
	 fiJsjIFe5HoZLN1sXtxmj+/o8Ykrqi3jPy0R2R4aw2//804VxvzmDcspqNqHqzMv7GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l9ZFmHKE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321E6606A319;
	Wed, 21 Oct 2026 01:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l9ZFmHKE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505451F000C9;
	Wed, 21 Oct 2026 01:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792545916;
	bh=4bdhRhvLCR2OGjIxKNlvor52ldxxtItwDVGS0GO5vlE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=l9ZFmHKEU/tlzxe+ZQ2rXXUNZIZ7NRc9MDFn6t+2EnFjQd0F/F1eOOau1b+RvVxpk
	 wmcQA7BXyhiQ+fCH4WmKbP0UH/KBcb337EZ/4QnsmExYnAu+hUqeurjT7b3fE5Fuap
	 SjiRPzngmTN89MyNez5+pb6ubCwlVc9kUxwsLecQU9Q9EnyJsK67Mcg4UqdM1HW5nE
	 /xTzxsMqO+TTbsSfx4XSV8xqdDNXhuOE+AmdLgOWtyh0v3Pi8/nyrdNZopK1NDxlan
	 jygxgW7nU2Gm42PIWonHcgv8+L7n8/TO5zZ5N0dx51wjnV13PK/AKzpE90CtPviaiv
	 x5wzvWgPedDbQ==
Date: Wed, 21 Oct 2026 02:25:05 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@HansenPartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, alistair.francis@wdc.com,
 ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
Subject: Re: [PATCH RFC 12/20] ctlv: Add device and operation dispatch
Message-ID: <20261021022505.6fe1b1bb@jic23-hlaptop>
In-Reply-To: <20261015145053.3664509-13-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-13-jiri@resnulli.us>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Oct 2026 16:50:45 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@nvidia.com>
> 
> Register CTLV devices, resolve family chains and dispatch operations
> through validated messages. Wire CONFIG_CTLV and the generated root family
> after all module objects are present.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  drivers/Kconfig             |    2 +
>  drivers/Makefile            |    1 +
>  drivers/ctlv/Makefile       |    4 +-
>  drivers/ctlv/core.c         | 1517 +++++++++++++++++++++++++++++++++++
Normally I'd push back hard on too big to read, but it is an rfc
and other patches in the series are much large.

I'm out of time for today and not sure when I'll get back to this,
so just a few quick comments inline on the bit I did look at.

>  drivers/ctlv/device.h       |   17 +
>  include/linux/ctlv.h        |   55 ++
>  include/linux/ctlv_family.h |   22 +
>  7 files changed, 1616 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/ctlv/core.c

> diff --git a/drivers/ctlv/core.c b/drivers/ctlv/core.c
> new file mode 100644
> index 000000000000..aeab29fe2fdd
> --- /dev/null
> +++ b/drivers/ctlv/core.c

...

> +static int ctlv_file_open(struct inode *inode, struct file *filp)
> +{
> +	struct ctlv_device *ctlvdev = container_of(inode->i_cdev, struct ctlv_device, cdev);
> +	struct ctlv_file *cfile;
> +	int ret;
> +
> +	/*
> +	 * A failed create can withdraw the cdev while an open is waiting for
> +	 * the lifecycle lock, so admission itself first pins core storage.
> +	 */
> +	get_device(&ctlvdev->dev);
> +	ctlv_file_open_pinned(ctlvdev);
> +	scoped_guard(rwsem_read, &ctlvdev->registration_lock) {
> +		if (!ctlv_file_open_allowed(ctlvdev)) {
> +			ret = -ENODEV;
> +			break;
Personally I still dislike the hidden for loop in scoped_guard()
and using break with that enough I'd do a 
	do {
		guard(rwsem_read)(&ctlvdev->registration_lock);

	
	} while (0);

Just so it is obvious what those breaks are from.

Maybe I just need to get this one into my code review head...
> +		}
> +		if (!(filp->f_mode & FMODE_READ)) {
> +			ret = -EACCES;
> +			break;
> +		}
> +
> +		cfile = kzalloc_obj(*cfile, GFP_KERNEL_ACCOUNT);
> +		if (!cfile) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +		cfile->ctlvdev = ctlvdev;
> +		/*
> +		 * Commits this description to the device. An open that failed
> +		 * after this would have to take it back.
> +		 */
> +		ret = ctlv_event_file_init(cfile);
> +		if (ret) {
> +			kfree(cfile);
> +			break;
> +		}
> +		/* This description keeps the reference taken on entry. */
> +		filp->private_data = cfile;
> +		return 0;
> +	}
> +
> +	put_device(&ctlvdev->dev);
> +	return ret;
> +}

> +struct ctlv_device *ctlv_create(struct device *parent_dev, const struct ctlv_family *family,
> +				const void *init_info)
> +{
> +	struct ctlv_device *ctlvdev;
> +	int devnum, ret;
> +
> +	if (!parent_dev || !family)
> +		return ERR_PTR(-EINVAL);
> +
> +	ctlvdev = kzalloc_obj(*ctlvdev, GFP_KERNEL);
> +	if (!ctlvdev)
> +		return ERR_PTR(-ENOMEM);
> +	ctlvdev->family = family;
> +	init_rwsem(&ctlvdev->registration_lock);
> +	spin_lock_init(&ctlvdev->transition_lock);
> +	ctlv_event_device_init(ctlvdev);
> +
> +	/* Before anything reads the schema through this device. */
> +	ret = ctlv_op_resolution_init(ctlvdev, family);
> +	if (ret)
> +		goto err_free;
> +	/* What this family's events need of every queue opened on it. */
> +	ret = ctlv_event_sizes(ctlvdev);
> +	if (ret)
> +		goto err_free;
> +	/* Before a minor is spent on a device that could not be announced. */
> +	ret = ctlv_device_uevent_check(family);
> +	if (ret)
> +		goto err_free;
> +	if (ctlvdev->dynamic_ops_count) {
> +		ctlvdev->disabled = bitmap_zalloc(ctlvdev->dynamic_ops_count, GFP_KERNEL);
> +		if (!ctlvdev->disabled) {
> +			ret = -ENOMEM;
> +			goto err_free;
> +		}
> +	}
> +	devnum = ida_alloc_max(&ctlv_device_ids, CTLV_MAX_DEVICES - 1, GFP_KERNEL);
> +	if (devnum < 0) {
> +		ret = devnum;
> +		goto err_free;
> +	}
> +
> +	ctlvdev->dev.devt = ctlv_device_number + devnum;
> +	ctlvdev->dev.class = &ctlv_device_class;
> +	ctlvdev->dev.parent = parent_dev;
> +	device_initialize(&ctlvdev->dev);
> +	/*
> +	 * The core owns the file operations, so an open holds the core module
> +	 * and not the family's, which may unload while readers remain.
> +	 */
> +	cdev_init(&ctlvdev->cdev, &ctlv_file_operations);
> +	ctlvdev->cdev.owner = THIS_MODULE;
> +
> +	ret = dev_set_name(&ctlvdev->dev, "ctlv%d", devnum);
> +	if (ret)
> +		goto err_put;
> +	ret = ctlv_family_claim_add(family->schema);
> +	if (ret)
> +		goto err_put;
> +	ret = ctlv_family_privs_pre_init(ctlvdev, init_info);
> +	if (ret)
> +		goto err_put;
> +	ret = ctlv_family_privs_init(ctlvdev);
> +	if (ret)
> +		goto err_put;
> +	ctlv_op_publish_all(ctlvdev);
> +	ctlv_event_contexts_start(ctlvdev);
> +	ret = ctlv_family_privs_post_init(ctlvdev);
> +	if (ret)
> +		goto err_fini;
> +	scoped_guard(rwsem_write, &ctlvdev->registration_lock) {
> +		ret = ctlv_device_add(ctlvdev);
> +		if (!ret)
> +			ctlvdev->registered = true;
> +	}
> +	if (ret)
> +		goto err_fini;
> +	return ctlvdev;
> +
> +err_fini:
> +	ctlv_device_fini(ctlvdev);
> +err_put:
> +	put_device(&ctlvdev->dev);
> +	return ERR_PTR(ret);

Jason did some nice handling in the fwctl stuff for
device alloc and hand over after device_initialize()
(I've copied it into a few places recently :)

I'd like to see something similar here as it made
it easier to follow lifetimes etc.

> +err_free:
> +	bitmap_free(ctlvdev->disabled);
> +	ctlv_family_privs_free(ctlvdev);
> +	kfree(ctlvdev->ops);
> +	kfree(ctlvdev);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_NS_GPL(ctlv_create, "CTLV");

