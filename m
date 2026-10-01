Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3309D46A5EE;
	Thu,  1 Oct 2026 18:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790879569; cv=none; b=OGc/ku/tBqcwrOWe3ybknv+WC/wcEkUmPKUdkXbe6wDoeA5XGwlA+ui24bg+2Z/X1RE7YpqIHUqLvoLX1AZz9c+zR5XFm5bn0wiKz2MsJy3z0Z/WtT5krDWIJhhGGAkRb5Q9xRe8RQ/r5WHfSVJcXvdPQSExkW6ixG8WNgGCxY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790879569; c=relaxed/simple;
	bh=v7HO9sVs1M61klOQEBu9J2z3I8TacHaHmMywiDQe7pA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mP+Shxq95DV9rz+z8aUABry4tXG/8w8CAQ0ACQTmHBJHdy9NneqbJGnd9HG8EPP2nYa5PHfMahML5d3IahJWjWTP/n4zOXD69X0BfyT5sl3GpJ4eQbsQ3OkG4sIT2oJ3Opvgdl3oCreZzOpVk/AzWIe83BdbpNJcf4AHtPY7RDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hO/Gio9C; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hO/Gio9C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790879567; x=1822415567;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v7HO9sVs1M61klOQEBu9J2z3I8TacHaHmMywiDQe7pA=;
  b=hO/Gio9CvxznwHSk7PwB6z2Z4TiMRZrrxJupd31Vtp3GMDzEF/S+D/7h
   cG2U4UjfXYva1iS06T9guh8KieJG9eg8mfVe03Bshc7j7AWpdSrm8cOLT
   p7cbSRkaaQqHkYPBsZbiP9W3u4heOPp8PYp8TfhDvl5on1ZvqSuNuRR+Y
   y/KZMioPGi9eRbzJa4DP2822IG9DTXKxgFT5uTauf820GEWVTMO1wgbG8
   vw2Mv8/00wIaSEAbDnMFWdHLEHjyD4vX/o6eLNmxKRceWRj2sjfdmjpbv
   JbIu1sh3ebZpSe1uHszF2Rv8+ki8pye7dbLvKargfYuXwL9quyKC0gAie
   w==;
X-CSE-ConnectionGUID: NWh8RgApTgi6RfdwnNbxpA==
X-CSE-MsgGUID: 1AbBX8EsRBSb5HOt8US0hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="94135281"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="94135281"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 11:32:46 -0700
X-CSE-ConnectionGUID: d6fCbgTXTvi2mzMNbApUcQ==
X-CSE-MsgGUID: VneUtzyLTACjiqj0SehDMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="274693908"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.27])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 11:32:43 -0700
Date: Thu, 1 Oct 2026 21:32:41 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Miguel Vadillo <miguel.vadillo@intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	sakari.ailus@linux.intel.com, hansg@kernel.org,
	laurent.pinchart@ideasonboard.com, mehdi.djait@bootlin.com,
	mika.westerberg@linux.intel.com, srini@kernel.org, arun.t@intel.com
Subject: Re: [PATCH] media: i2c: cvs: Add NVMem-based firmware update support
Message-ID: <ar6nSbS-FpaI6jYp@ashevche-desk.local>
References: <20260930182142.108744-1-miguel.vadillo@intel.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930182142.108744-1-miguel.vadillo@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Sep 30, 2026 at 11:21:42AM -0700, Miguel Vadillo wrote:
> Add firmware update support for the Intel CVS device using the kernel
> NVMem provider framework.
> 
> Two NVMem devices are registered per CVS device:
>  - nvm_active: read-only, exposes the active firmware version by
>    querying the device over I2C.
>  - nvm_non_active: write-only, root-only, accepts an incoming firmware
>    image staged by userspace (e.g. fwupd).
> 
> Firmware update is triggered via the nvm_authenticate sysfs attribute,
> which supports the following write values:
>  1 - Validate staged image, stream to device, and request reset
>  2 - Validate and stream image only (no reset request)
>  3 - Request reset for a previously streamed image
>  0 - Clear update state and reset_pending flag
> 
> On a successful write of 1 or 3, a KOBJ_CHANGE uevent is emitted and
> nvm_reset_pending is set to signal that a device reset is required to
> activate the new firmware.
> 
> The nvm_version attribute exposes the running firmware version in
> major.minor decimal format. The device_id attribute exposes the device
> VID:PID for identification by userspace tools.
> 
> Firmware images are streamed to the device in 256-byte or 1KB chunks
> over I2C depending on device quirks. The staging buffer is vmalloc'd
> on first write and released once the image has been streamed to the
> device, or on driver remove if no update was performed.
> 
> ABI documentation for all new sysfs attributes is added under
> Documentation/ABI/testing/sysfs-bus-i2c-devices-cvs.
> 
> The kernel does not inspect the firmware image contents. Signature
> verification and anti-rollback enforcement are performed by the CVS
> device firmware, which rejects images that fail either check.

...

> +Date:		January 2027
> +KernelVersion:	7.4

Tough deadline, but if there are nothing to address, you have a chance to land
it as expected.

...

> +static int cvs_do_fw_download(struct icvs *ctx, const u8 *buf, size_t size)
> +{
> +	struct icvs_cmd cmd = { };
> +	size_t chunk_max, chunk, pos;
> +	int ret, end_ret;
> +
> +	if (ctx->quirks & ICVS_FW_BUF_SIZE_256)
> +		chunk_max = SZ_256;
> +	else
> +		chunk_max = SZ_1K;
> +
> +	void *fw_buf __free(kfree) = kmalloc(chunk_max + sizeof(__be16),
> +					     GFP_KERNEL);

Slightly better to read in a form of

	void *fw_buf __free(kfree) =
		kmalloc(chunk_max + sizeof(__be16), GFP_KERNEL);

> +	if (!fw_buf)
> +		return -ENOMEM;
> +
> +	cmd.cmd_id = cpu_to_be16(ICVS_FW_LOADER_START);
> +	ret = cvs_send(ctx, &cmd, sizeof(cmd.cmd_id), ICVS_CMD_TIMEOUT);
> +	if (ret < 0)
> +		return ret;

What is the meaning of the positive returned value?

> +	for (pos = 0; pos < size; pos += chunk) {
> +		chunk = min(chunk_max, size - pos);
> +		put_unaligned_be16(ICVS_FW_LOADER_DATA, fw_buf);
> +		memcpy(fw_buf + sizeof(__be16), buf + pos, chunk);
> +
> +		ret = cvs_send(ctx, fw_buf, sizeof(__be16) + chunk,
> +			       ICVS_CMD_TIMEOUT);
> +		if (ret < 0) {
> +			dev_err(cvs_dev(ctx),
> +				"FW data chunk send failed: %d\n", ret);
> +			break;
> +		}
> +	}
> +
> +	/* Always send FW_LOADER_END, but keep any earlier DATA error. */
> +	cmd.cmd_id = cpu_to_be16(ICVS_FW_LOADER_END);
> +	end_ret = cvs_send(ctx, &cmd, sizeof(cmd.cmd_id), FW_END_TIMEOUT);
> +
> +	return ret < 0 ? ret : end_ret;
> +}

...

> +	mutex_lock(&ctx->lock);

Why not guard()()? Also how ACQUIRE() macros are co-habit with goto:s?

> +	ctx->nvm.auth_status = 0;
> +
> +	switch (val) {
> +	case ICVS_NVM_AUTH_CLEAR:
> +		ctx->nvm.flushed = false;
> +		break;
> +
> +	case ICVS_NVM_AUTH_WRITE_ONLY:
> +	case ICVS_NVM_AUTH_WRITE_AND_AUTH:
> +		ret = cvs_nvm_validate(ctx);
> +		if (ret)
> +			goto err_status;
> +
> +		ret = cvs_do_fw_download(ctx, ctx->nvm.buf_data_start,
> +					 ctx->nvm.buf_data_size);
> +		if (ret)
> +			goto err_status;
> +
> +		ctx->nvm.flushed = true;
> +		cvs_nvm_release_buf(&ctx->nvm);
> +
> +		if (val == ICVS_NVM_AUTH_WRITE_ONLY)
> +			break;
> +
> +		fallthrough;
> +
> +	case ICVS_NVM_AUTH_AUTH_ONLY:
> +		if (!ctx->nvm.flushed) {
> +			ret = -ENODATA;
> +			goto err_status;
> +		}
> +
> +		do_uevent = true;
> +		break;
> +	}
> +
> +	mutex_unlock(&ctx->lock);
> +
> +	if (do_uevent)
> +		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
> +
> +	return count;
> +
> +err_status:
> +	ctx->nvm.auth_status = -ret;
> +	mutex_unlock(&ctx->lock);
> +
> +	return ret;

...

> +static const struct attribute_group *cvs_fw_groups[] = {
> +	&cvs_fw_group,
> +	NULL
> +};

__ATTRIBUTE_GROUPS() ?

...

>  struct icvs {
>  	struct i2c_client *i2c_client;

>  	int irq;
>  	wait_queue_head_t hostwake_event;
>  	bool hostwake_event_arg;
> +	struct icvs_nvm nvm;
>  };

Is `pahole` happy with the layout?

-- 
With Best Regards,
Andy Shevchenko


