Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248623;
	b=mDmZa5F90DXBlYsvCD4CFGhMSnYhXgcx5mXvQ7ykmCnkLlC1xF3yKJQrPEfkjBqAkPpr
	 xm5pCr7TIM1l01a3O7cBSHs9aRuE7UPwWMuT3AyqsmOD6kJg68saW6UtaM9AGZqRW76DU
	 tp1qkIPZAg0vtzPiglvUITHyPgs7blW77RghtJvIlCH+8N20zfWuqVlfRv9n6kwbvketu
	 8AA53Pl/wWGfdjbb0/D6Mu7oLRIhDzuocr5ThGdl4kAyqlzAll/dzSjoMM3B/UJdCKD5U
	 MMpkF0FDpSEnuwXgMzzHhfaXGNtv5EwAtq+0iFHSj+lTgFUo73djzso5crOE//pGngA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248623;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=nVHVF+Kc92+BRI/aLmdGMRNmm3kBUyhiEVjuIYHrvVQ=;
	b=z9UlQ82kTkcUC8tSgR+Dor9d8Tb3hVSX3wX61I35gH2Yri+/0uN/Dh8vs11579k3VuWq
	 XnEcouT0EN9UVtaDfodPg+2WxhBUATMw125TK4EcwL3LYPAewLNX+jbvQJlNL7iSvQjdi
	 TYrBwSKDy/H2pZn5CZipbMIWjFBr0nnFRo3DXjpMlWrkqKSbVIIywdDx7p86ZS/1g1oPv
	 /8E+3o2jEbx2AADO4QufwVTNM5lvzW4Dhu1cVf751HqqSlVJKUZu/LQ1r2eAg2UBqwOHP
	 dyS0YSUGO9BOKadn2vwuyeq51RZOnnHcuDSA4h+kkHlZ7yViqOEban4EIZEVEj1NTqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Nyw4HMPX;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B87606A325;
	Mon,  9 Nov 2026 18:23:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4B87606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Nyw4HMPX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794248622; x=1825784622;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=86KVkOJZ+b8WfEPmHNnWW2R1LFl+RH1uq4vmQ1SjCfI=;
  b=Nyw4HMPX9dqxwylGUbnmHN64w1bV2UH2BWuWuG2NKR8I4Kn/SES95t8p
   JT65qtxNkuoV75zEfJJWqMKIvAl5kfGOQeoE7sCRQ2w9Um94oPocvjrcn
   wLSUwUlESVJysZHmHUsN6UbDIeLw3w8v/ygN8aIeffPlUTRkwZug6kSCd
   UgkxmzkBIs+Yb7mwsTx/yIqnEsXJqzCxDhdvaCLTni8AHAcN1/V+G8wgh
   +FtqHsxbw7w/JImhbrwDn8b37ZvhOhzHnVOagFBk7Q/fpc63W/sY1mG3b
   F3GzkrsvTO0qIKJY9L/sYce1Grv4ImO3ARYThn/+3pN0UxglM4wTeto2/
   A==;
X-CSE-ConnectionGUID: JbObTrGdTzm44GkWN2fAQw==
X-CSE-MsgGUID: PfjtixPOTv+WdgBlz5Cysg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2861379"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2861379"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:23:41 -0800
X-CSE-ConnectionGUID: K9QaV3jgR3mClpkPr7nl8A==
X-CSE-MsgGUID: zJS3SNKUQnmc77RIMK62Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="7957427"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.139])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:23:38 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 9 Nov 2026 20:23:34 +0200 (EET)
To: Bartu Alev <bartualev@gmail.com>
cc: Corentin Chary <corentin.chary@gmail.com>, 
    "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
    Hans de Goede <hansg@kernel.org>, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-hwmon@vger.kernel.org, 
    Guenter Roeck <linux@roeck-us.net>, linux-api@vger.kernel.org
Subject: Re: [PATCH 4/7] platform/x86: asus-wmi: read the firmware fan floor
 tables
In-Reply-To: <20261101-asus-fan-floors-v4-v1-4-b8d1c31a99a9@gmail.com>
Message-ID: <9097a71a-a7f5-54ec-dd2b-7f55376b2a14@linux.intel.com>
References: <20261101-asus-fan-floors-v4-v1-0-b8d1c31a99a9@gmail.com> <20261101-asus-fan-floors-v4-v1-4-b8d1c31a99a9@gmail.com>
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

On Sun, 1 Nov 2026, Bartu Alev wrote:

> On some ASUS laptops, the embedded controller enforces minimum fan
> duties on top of custom fan curves written via CPU_FAN_CURVE
> (0x00110024), GPU_FAN_CURVE (0x00110025), and the mid fan curve
> methods. The floors are exposed via read-only DSTS methods 0x00110026,
> 0x00110027, and 0x00110033.
> 
> The floor table is indexed by curve point: entry i (0-based, sysfs
> point i + 1) provides the minimum duty for that point. The EC maps
> each point to a temperature decade [30 + 10 * i, 39 + 10 * i] degrees
> Celsius, stepping between points with 5 degrees Celsius of hysteresis
> without interpolation on TUF series.
> 
> EC firmware dumps from an FA507 show floor tables of {0, 0, 0, 0, 25,
> 48, 58, 74}% for the CPU fan and {0, 0, 0, 0, 26, 57, 68, 91}% for the
> GPU fan, verified via live DSTS reads on an FA507NV.
> 
> Read the tables at probe and refresh them after power profile changes
> or curve resets, as the EC can reload defaults when operating modes
> change.  Profile switches did not alter table bytes on the FA507, so
> this refresh is precautionary.
> 
> Export the floors without altering user curves, rejecting replies
> shorter than eight bytes or containing values exceeding 100%.  If a
> table contains decreasing values along its points, warn once but still
> export it so userspace can inspect what firmware enforces.  When
> firmware returns 0xFFFFFFFE, mark the table unsupported for that fan
> to avoid repeating failed WMI calls on future refreshes; unreadable
> tables remain zeroed.
> 
> Protect the cached floor tables with a mutex against concurrent sysfs
> reads.
> 
> Also fix the stale comment claiming that firmware interpolates between
> curve points.
> 
> Signed-off-by: Bartu Alev <bartualev@gmail.com>
> ---
>  drivers/platform/x86/asus-wmi.c | 170 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 165 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index c55f469cb03dc..b6541183d4568 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -239,6 +239,10 @@ struct fan_curve_data {
>  	u32 device_id;
>  	u8 temps[FAN_CURVE_POINTS];
>  	u8 percents[FAN_CURVE_POINTS];
> +	/* EC minimum duty per point, pwm 0-255, not percent */
> +	u8 floors[FAN_CURVE_POINTS];
> +	bool floors_valid;
> +	bool floors_unsupported;
>  };
>  
>  struct asus_wmi {
> @@ -320,6 +324,9 @@ struct asus_wmi {
>  	bool gpu_fan_curve_available;
>  	bool mid_fan_curve_available;
>  	struct fan_curve_data custom_fan_curves[3];
> +	/* protects custom_fan_curves[].floors */
> +	struct mutex fan_curve_lock;
> +	struct device *fan_curve_hwmon;
>  
>  	struct device *ppdev;
>  
> @@ -466,7 +473,8 @@ static int asus_wmi_evaluate_method5(u32 method_id,
>   * means that the method called is unsupported.
>   */
>  static int asus_wmi_evaluate_method_buf(u32 method_id,
> -		u32 arg0, u32 arg1, u8 *ret_buffer, size_t size)
> +		u32 arg0, u32 arg1, u8 *ret_buffer, size_t size,
> +		size_t *ret_len)
>  {
>  	struct bios_args args = {
>  		.arg0 = arg0,
> @@ -479,6 +487,9 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
>  	union acpi_object *obj;
>  	int err = 0;
>  
> +	if (ret_len)
> +		*ret_len = 0;
> +
>  	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
>  
>  	pr_debug("%s called (0x%08x) with args: 0x%08x, 0x%08x\n",
> @@ -503,6 +514,8 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
>  		}
>  
>  		memcpy(ret_buffer, obj->buffer.pointer, obj->buffer.length);
> +		if (ret_len)
> +			*ret_len = obj->buffer.length;
>  		break;
>  	case ACPI_TYPE_INTEGER:
>  		err = (u32)obj->integer.value;
> @@ -3631,7 +3644,7 @@ static int fan_curve_get_factory_default(struct asus_wmi *asus, u32 fan_dev)
>  		mode = 2;
>  
>  	err = asus_wmi_evaluate_method_buf(asus->dsts_id, fan_dev, mode, buf,
> -					   FAN_CURVE_BUF_LEN);
> +					   FAN_CURVE_BUF_LEN, NULL);
>  	if (err) {
>  		pr_warn("%s (0x%08x) failed: %d\n", __func__, fan_dev, err);
>  		return err;
> @@ -3651,7 +3664,136 @@ static int fan_curve_get_factory_default(struct asus_wmi *asus, u32 fan_dev)
>  	return 0;
>  }
>  
> -/* Check if capability exists, and populate defaults */
> +/*
> + * Read the firmware fan floor table. The EC enforces a minimum duty per
> + * curve point on top of the custom curve. Reading is best effort: at
> + * probe time a failed read leaves the table zeroed and invalid, and a
> + * failed refresh keeps the last table that was read.
> + */
> +static int fan_curve_load_floors(struct asus_wmi *asus, u32 fan_dev)
> +{
> +	struct fan_curve_data *curves;
> +	u8 buf[FAN_CURVE_BUF_LEN] = {};
> +	size_t len;
> +	int err, fan_idx, i;

Reverse xmas-tree order.

I seems to only use positive values(?) => unsigned int 

> +	switch (fan_dev) {
> +	case ASUS_WMI_DEVID_CPU_FAN_CURVE:
> +		fan_idx = FAN_CURVE_DEV_CPU;
> +		fan_dev = ASUS_WMI_DEVID_CPU_FAN_FLOOR;
> +		break;
> +	case ASUS_WMI_DEVID_GPU_FAN_CURVE:
> +		fan_idx = FAN_CURVE_DEV_GPU;
> +		fan_dev = ASUS_WMI_DEVID_GPU_FAN_FLOOR;
> +		break;
> +	case ASUS_WMI_DEVID_MID_FAN_CURVE:
> +		fan_idx = FAN_CURVE_DEV_MID;
> +		fan_dev = ASUS_WMI_DEVID_MID_FAN_FLOOR;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	curves = &asus->custom_fan_curves[fan_idx];
> +	if (curves->floors_unsupported)
> +		return -ENODEV;
> +
> +	err = asus_wmi_evaluate_method_buf(asus->dsts_id, fan_dev, 0, buf,
> +					   FAN_CURVE_BUF_LEN, &len);
> +	if (err) {
> +		pr_debug("%s (0x%08x) failed: %d\n", __func__, fan_dev, err);

Below you use dev_*() printing, so why pr_*() here??

This also seems to lack include for dev_*() so lets finally add that one.

> +		/* 0xFFFFFFFE means the firmware has no such method */

Drop comment.

> +		if (err == -ENODEV)
> +			curves->floors_unsupported = true;
> +		return err;
> +	}
> +
> +	if (len < FAN_CURVE_POINTS) {
> +		pr_debug("%s (0x%08x): short reply of %zu bytes\n",
> +			 __func__, fan_dev, len);

dev_...()

> +		return -ENODATA;
> +	}
> +
> +	/* A percentage above 100 would overflow the pwm scale below */

Drop.

> +	for (i = 0; i < FAN_CURVE_POINTS; i++) {
> +		if (buf[i] > 100) {
> +			pr_debug("%s (0x%08x): implausible floor table\n",
> +				 __func__, fan_dev);

dev_xx().

Why is this only debug level? It would seem like something that has 
relevance beyond that.

When making it err/warn level, improve/simplify the message too to 
simply state that floor table entry > 100 instead of something cryptic 
like the above :-). And never print __func__ for messages intended for 
normal user.

> +			return -EINVAL;
> +		}
> +	}
> +
> +	/*
> +	 * The floors observed so far do not decrease along the points, but
> +	 * that is only proven on the FA507.  Do not reject a table that
> +	 * does: the values are still usable as per-point minimums, and
> +	 * hiding them would leave userspace no way to see what the
> +	 * firmware enforces.
> +	 */
> +	for (i = 1; i < FAN_CURVE_POINTS; i++) {
> +		if (buf[i] < buf[i - 1]) {

Reverse the compare sides to make it more logical.

> +			dev_warn_once(&asus->platform_device->dev,
> +				      "fan curve (0x%08x): floor table decreases at point %d\n",
> +				      fan_dev, i + 1);
> +			break;
> +		}
> +	}
> +
> +	guard(mutex)(&asus->fan_curve_lock);
> +	for (i = 0; i < FAN_CURVE_POINTS; i++)
> +		curves->floors[i] = DIV_ROUND_UP(255 * buf[i], 100);

Add include.

> +	curves->floors_valid = true;
> +
> +	return 0;
> +}
> +
> +static void fan_curve_notify_floors(struct asus_wmi *asus)
> +{
> +	struct device *hwmon = asus->fan_curve_hwmon;
> +	bool valid[ARRAY_SIZE(asus->custom_fan_curves)];
> +	char name[32];
> +	int fan, point;
> +
> +	if (!hwmon)
> +		return;
> +
> +	scoped_guard(mutex, &asus->fan_curve_lock) {
> +		for (fan = 0; fan < ARRAY_SIZE(valid); fan++)

Add include.

> +			valid[fan] = asus->custom_fan_curves[fan].floors_valid;
> +	}
> +
> +	for (fan = 0; fan < ARRAY_SIZE(valid); fan++) {
> +		if (!valid[fan])
> +			continue;
> +
> +		for (point = 0; point < FAN_CURVE_POINTS; point++) {
> +			snprintf(name, sizeof(name),

scnprintf()

> +				 "pwm%d_auto_point%d_floor_pwm",
> +				 fan + 1, point + 1);
> +			sysfs_notify(&hwmon->kobj, NULL, name);

Add include.

> +		}
> +	}
> +}
> +
> +/*
> + * The EC re-runs its defaults reload when the mode byte it keys on
> + * changes, which a thermal profile switch can do.  Re-read the tables
> + * so that the exported values follow the firmware; on the FA507 the
> + * tables are profile independent, so this is defensive.
> + */
> +static void fan_curve_refresh_floors(struct asus_wmi *asus)
> +{
> +	if (asus->cpu_fan_curve_available)
> +		fan_curve_load_floors(asus, ASUS_WMI_DEVID_CPU_FAN_CURVE);
> +	if (asus->gpu_fan_curve_available)
> +		fan_curve_load_floors(asus, ASUS_WMI_DEVID_GPU_FAN_CURVE);
> +	if (asus->mid_fan_curve_available)
> +		fan_curve_load_floors(asus, ASUS_WMI_DEVID_MID_FAN_CURVE);
> +
> +	fan_curve_notify_floors(asus);
> +}
> +
> +/* Check if the capability exists, populate its defaults and read its floor table */
>  static int fan_curve_check_present(struct asus_wmi *asus, bool *available,
>  				   u32 fan_dev)
>  {
> @@ -3668,6 +3810,16 @@ static int fan_curve_check_present(struct asus_wmi *asus, bool *available,
>  	}
>  
>  	*available = true;
> +
> +	err = fan_curve_load_floors(asus, fan_dev);
> +	if (err == -ENODEV)
> +		dev_dbg(&asus->platform_device->dev,
> +			"fan curve (0x%08x): no floor table\n", fan_dev);
> +	else if (err)
> +		dev_warn(&asus->platform_device->dev,
> +			 "fan curve (0x%08x): unusable floor table (%d)\n",
> +			 fan_dev, err);
> +
>  	return 0;
>  }
>  
> @@ -3738,8 +3890,9 @@ static int fan_curve_write(struct asus_wmi *asus,
>  }
>  
>  /*
> - * A fan curve is a set of points the firmware interpolates between, so it
> - * only makes sense if neither temperature nor PWM ever decreases along it.
> + * A fan curve is a set of points the firmware steps through, without
> + * interpolating between them, so it only makes sense if neither temperature
> + * nor PWM ever decreases along it.
>   */
>  static int fan_curve_validate(struct device *dev, struct fan_curve_data *data)
>  {
> @@ -3870,6 +4023,7 @@ static ssize_t fan_curve_enable_store(struct device *dev,
>  			err = asus_fan_set_auto(asus);
>  			if (err)
>  				return err;
> +			fan_curve_refresh_floors(asus);
>  		} else {
>  			/* Safeguard against fautly ACPI tables */
>  			err = fan_curve_get_factory_default(asus, data->device_id);
> @@ -3878,6 +4032,7 @@ static ssize_t fan_curve_enable_store(struct device *dev,
>  			err = fan_curve_write(asus, data);
>  			if (err)
>  				return err;
> +			fan_curve_refresh_floors(asus);
>  		}
>  	}
>  	return count;
> @@ -4125,6 +4280,8 @@ static int asus_wmi_custom_fan_curve_init(struct asus_wmi *asus)
>  		return PTR_ERR(hwmon);
>  	}
>  
> +	asus->fan_curve_hwmon = hwmon;
> +
>  	return 0;
>  }
>  
> @@ -4195,6 +4352,8 @@ static int throttle_thermal_policy_write(struct asus_wmi *asus)
>  	if (asus->mid_fan_curve_available)
>  		asus->custom_fan_curves[FAN_CURVE_DEV_MID].enabled = false;
>  
> +	fan_curve_refresh_floors(asus);
> +
>  	return 0;
>  }
>  
> @@ -5202,6 +5361,7 @@ static int asus_wmi_add(struct platform_device *pdev)
>  	asus->platform_device = pdev;
>  	wdrv->platform_device = pdev;
>  	platform_set_drvdata(asus->platform_device, asus);
> +	mutex_init(&asus->fan_curve_lock);
>  
>  	if (wdrv->detect_quirks)
>  		wdrv->detect_quirks(asus->driver);
> 
> 

-- 
 i.

