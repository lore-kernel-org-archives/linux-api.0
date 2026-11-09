Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794249282;
	b=fb57JDywUWN6SRXPqyGC54iVRNBXeN4v1VIwPBeO5q9JNXC0B1eyAYk9E2Z8MPozc+1T
	 yOjVADpXftRreDOpicXaKGnjUjMw4KPbSeS9fraqTaU6vxRvYri+cCkEg1Y+bHnw9J8YP
	 Psnyh7MDeQ7GBKHYRLV4HB9TdYUcelgSkioJjex5iwLU146y+7UOw0jFN+5vI4PFEtice
	 aKUJyZEEIE31F72B5jck+EoJr0Im3DZ4TdQ9/10IuEHdevbSCUS07n62DSl7rnI7qarbu
	 4kPGeNHrEhhsn+wnITe/7BTxGCfnj3fqK7gbIwSv15QqKwPSXB9ACKwiuykZEvdSDQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794249282;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=EAYzsoHGShDNLxcEC4nzCs8egN1aw2JDSXlKgPC5Mfo=;
	b=F5vWrYhDK0sPSBIO8mcRrnjHtEmy+cZ29YDyln9yWj6vjFjxh13NI5Bjh62wwIyyMQEZ
	 kZUGEh15RjM8NWp71tKQPIKoBoozA6REZeqmH09yoiqK0Wo5om3QHHbPRMh69at7QPVSA
	 nvEXZPdU55BoY0VjCwi1DUg3jXs6sSLETmpOEnXRVkTMa+ETesCb3oOfb1vXJs8iOdbnz
	 KY0ylXUuXun00UoEglzF5rjiKwFhzUdrWwTzFcWeH5UtOh7v1e6YpaJOUS7s8krVm7UTq
	 N5S/JIOKvThMrBqMH8Jh2h9TxQNjExUJVXpwdSHnB1RXM/sTFfcl7vQhbC4Y4+stzgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="g2Gqat/c";
	arc=none smtp.remote-ip=198.175.65.14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923FB606A5C1;
	Mon,  9 Nov 2026 18:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 923FB606A5C1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=g2Gqat/c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794249281; x=1825785281;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=uIdTCvf5Xd+7AgxI7O+gBFdCHrkZGxWNz4Lt1PpdbjI=;
  b=g2Gqat/cMDFCdH+J376PF09/czvg9oB90PoV7QtnWWuI7HN62mFfsicn
   Ljazm7C8NSSaNP+zWUMzauQZwDRtLPjuE2l4x4TBH32/rDSDsPeZJGo+L
   nvQJz7VFoeaJK76lqjLUTGMsZa8jIx7r/IBP47LBPqP/QWnq6SJB6WR06
   /XcXBe4SBswQ73t7EtUyoWpyojnxxBV2cFKV9JvWMl0iB7peqk39cg04Z
   Wg3/WpKHYnHD+rF0IXSbVlyN7EAF8ozrTDYs8Jd3A8lGXBzIQptt6+GBs
   9KJYsiuXHkAcE/dczzaX2AhfTXDM9nrfBYUSYaASV6nP6wFy3+EN4nd9w
   w==;
X-CSE-ConnectionGUID: iigwvCdoSqmIlOvBTVmtKA==
X-CSE-MsgGUID: aQGqYYe/Q02vcldm9mAAxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2874825"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2874825"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:34:40 -0800
X-CSE-ConnectionGUID: SQvI6sYVQomtBNtNVoHgOQ==
X-CSE-MsgGUID: I3SZNZs6QbymxG8nMpfxJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8068631"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.139])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:34:38 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 9 Nov 2026 20:34:34 +0200 (EET)
To: Bartu Alev <bartualev@gmail.com>
cc: Corentin Chary <corentin.chary@gmail.com>, 
    "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
    Hans de Goede <hansg@kernel.org>, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-hwmon@vger.kernel.org, 
    Guenter Roeck <linux@roeck-us.net>, linux-api@vger.kernel.org
Subject: Re: [PATCH 6/7] platform/x86: asus-wmi: expose the fan floor tables
 via hwmon
In-Reply-To: <20261101-asus-fan-floors-v4-v1-6-b8d1c31a99a9@gmail.com>
Message-ID: <fd2f3c5d-9ff8-3c72-e9f0-d5704b539f9b@linux.intel.com>
References: <20261101-asus-fan-floors-v4-v1-0-b8d1c31a99a9@gmail.com> <20261101-asus-fan-floors-v4-v1-6-b8d1c31a99a9@gmail.com>
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

> Firmware enforces minimum duties on fan curves without updating the
> reported curve buffers, leaving userspace unable to determine which
> duty ranges are unreachable.
> 
> Export read-only pwm[1-3]_auto_point[1-8]_floor_pwm attributes on the
> hwmon device.  Each file returns the minimum duty (0-255 PWM) enforced
> for that curve point.  The attributes are registered for every
> supported fan curve and return -ENODATA when firmware provides no
> floor table.
> 
> Standard hwmon curve attributes (pwmY_auto_pointZ_pwm) assume
> writable points and cannot represent a separate, hardware enforced
> floor.  Dedicated read-only floor attributes provide these values
> while adhering to the one value per file rule.
> 
> Document these attributes in
> Documentation/ABI/testing/sysfs-platform-asus-wmi.
> 
> Signed-off-by: Bartu Alev <bartualev@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-platform-asus-wmi |  23 ++++
>  drivers/platform/x86/asus-wmi.c                   | 141 +++++++++++++++++++++-
>  2 files changed, 163 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
> index 775ea88625c0d..24931cc97ca86 100644
> --- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
> +++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
> @@ -297,3 +297,26 @@ Contact:	Luke D. Jones <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>,
>  Description:
>  		Same as the pwm1 and pwm2 curve points, for the mid fan
>  		(pwm3) of laptops whose firmware exposes a third fan curve.
> +
> +What:		/sys/class/hwmon/hwmonX/pwm[1-3]_auto_point[1-8]_floor_pwm
> +Date:		Nov 2026
> +KernelVersion:	7.5
> +Contact:	Bartu Alev <bartualev@gmail.com>
> +Description:
> +		Read-only minimum duty, in pwm units (0-255), that the
> +		embedded controller enforces for curve point Z of fan Y.
> +		The firmware reports the floor as a percentage; the driver
> +		converts it with DIV_ROUND_UP(255 * percent, 100), which maps

No code quotes here please.

> +		every 0-100 percentage back to itself.

This mapping sounds like implementation detail not much of user interest.

> +		Point Z (Z = 1..8) is bound to the temperature decade
> +		[30 + 10 * (Z - 1), 39 + 10 * (Z - 1)] degrees Celsius and
> +		the value is the floor of that decade.  The controller applies
> +		max(curve, floor) for every point on each thermal tick, so
> +		the floor is a hardware limit on top of the curve written

If I understand things right, there's ambiguity with "the curve" so it 
would be better to differentiate the minumum curve from the custom curve.
If you want, the the latter you could say inside parenthesis how the 
custom curve is inputted.

> +		through pwmY_auto_pointZ_pwm.
> +
> +		The attribute exists for every fan with a custom fan curve.

Is that same as "the curve written through pwmY_auto_pointZ_pwm"? Please 
try to use consistent terminology. I'd say the custom

> +		Reading it returns -ENODATA when the firmware of that fan
> +		does not provide a floor table.  A zero value is a real
> +		floor: the controller then enforces no minimum duty for that
> +		point.
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index dc1e69b964c99..74476904cb99c 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -3868,6 +3868,23 @@ static ssize_t fan_curve_show(struct device *dev,
>  	return sysfs_emit(buf, "%d\n", value);
>  }
>  
> +static ssize_t fan_curve_floor_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct sensor_device_attribute_2 *dev_attr = to_sensor_dev_attr_2(attr);
> +	struct asus_wmi *asus = dev_get_drvdata(dev);
> +	struct fan_curve_data *data = &asus->custom_fan_curves[dev_attr->nr];
> +	u8 floor;
> +
> +	guard(mutex)(&asus->fan_curve_lock);
> +	if (!data->floors_valid)
> +		return -ENODATA;
> +
> +	floor = data->floors[dev_attr->index];
> +
> +	return sysfs_emit(buf, "%u\n", floor);
> +}
> +
>  /*
>   * "fan_dev" is the related WMI method such as ASUS_WMI_DEVID_CPU_FAN_CURVE.
>   */
> @@ -4153,6 +4170,58 @@ static SENSOR_DEVICE_ATTR_2_RW(pwm3_auto_point7_pwm, fan_curve,
>  static SENSOR_DEVICE_ATTR_2_RW(pwm3_auto_point8_pwm, fan_curve,
>  			       FAN_CURVE_DEV_MID | FAN_CURVE_PWM_MASK, 7);
>  
> +/* Firmware enforced minimum duty of each point, read-only */
> +static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point1_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_CPU, 0);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point2_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_CPU, 1);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point3_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_CPU, 2);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point4_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_CPU, 3);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point5_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_CPU, 4);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point6_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_CPU, 5);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point7_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_CPU, 6);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm1_auto_point8_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_CPU, 7);
> +
> +static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point1_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_GPU, 0);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point2_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_GPU, 1);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point3_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_GPU, 2);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point4_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_GPU, 3);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point5_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_GPU, 4);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point6_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_GPU, 5);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point7_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_GPU, 6);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm2_auto_point8_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_GPU, 7);
> +
> +static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point1_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_MID, 0);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point2_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_MID, 1);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point3_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_MID, 2);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point4_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_MID, 3);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point5_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_MID, 4);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point6_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_MID, 5);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point7_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_MID, 6);
> +static SENSOR_DEVICE_ATTR_2_RO(pwm3_auto_point8_floor_pwm, fan_curve_floor,
> +			       FAN_CURVE_DEV_MID, 7);
> +
>  static struct attribute *asus_fan_curve_attr[] = {
>  	/* CPU */
>  	&sensor_dev_attr_pwm1_enable.dev_attr.attr,
> @@ -4211,6 +4280,37 @@ static struct attribute *asus_fan_curve_attr[] = {
>  	NULL
>  };
>  
> +static struct attribute *asus_fan_curve_floor_attr[] = {
> +	/* CPU */
> +	&sensor_dev_attr_pwm1_auto_point1_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm1_auto_point2_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm1_auto_point3_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm1_auto_point4_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm1_auto_point5_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm1_auto_point6_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm1_auto_point7_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm1_auto_point8_floor_pwm.dev_attr.attr,
> +	/* GPU */
> +	&sensor_dev_attr_pwm2_auto_point1_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm2_auto_point2_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm2_auto_point3_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm2_auto_point4_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm2_auto_point5_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm2_auto_point6_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm2_auto_point7_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm2_auto_point8_floor_pwm.dev_attr.attr,
> +	/* MID */
> +	&sensor_dev_attr_pwm3_auto_point1_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm3_auto_point2_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm3_auto_point3_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm3_auto_point4_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm3_auto_point5_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm3_auto_point6_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm3_auto_point7_floor_pwm.dev_attr.attr,
> +	&sensor_dev_attr_pwm3_auto_point8_floor_pwm.dev_attr.attr,
> +	NULL
> +};
> +
>  static umode_t asus_fan_curve_is_visible(struct kobject *kobj,
>  					 struct attribute *attr, int idx)
>  {
> @@ -4233,11 +4333,50 @@ static umode_t asus_fan_curve_is_visible(struct kobject *kobj,
>  	return 0;
>  }
>  
> +static bool fan_curve_available(struct asus_wmi *asus, int fan_idx)
> +{
> +	switch (fan_idx) {
> +	case FAN_CURVE_DEV_CPU:
> +		return asus->cpu_fan_curve_available;
> +	case FAN_CURVE_DEV_GPU:
> +		return asus->gpu_fan_curve_available;
> +	case FAN_CURVE_DEV_MID:
> +		return asus->mid_fan_curve_available;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static umode_t asus_fan_curve_floor_is_visible(struct kobject *kobj,
> +					       struct attribute *attr, int idx)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct asus_wmi *asus = dev_get_drvdata(dev->parent);
> +	struct device_attribute *dattr =
> +		container_of(attr, struct device_attribute, attr);

Add include.

> +	int fan = to_sensor_dev_attr_2(dattr)->nr;
> +
> +	if (!fan_curve_available(asus, fan))
> +		return 0;
> +
> +	return 0444;
> +}
> +
>  static const struct attribute_group asus_fan_curve_attr_group = {
>  	.is_visible = asus_fan_curve_is_visible,
>  	.attrs = asus_fan_curve_attr,
>  };
> -__ATTRIBUTE_GROUPS(asus_fan_curve_attr);
> +
> +static const struct attribute_group asus_fan_curve_floor_attr_group = {
> +	.is_visible = asus_fan_curve_floor_is_visible,
> +	.attrs = asus_fan_curve_floor_attr,
> +};
> +
> +static const struct attribute_group *asus_fan_curve_attr_groups[] = {
> +	&asus_fan_curve_attr_group,
> +	&asus_fan_curve_floor_attr_group,
> +	NULL,
> +};
>  
>  /*
>   * Must be initialised after throttle_thermal_policy_dev is set as
> 
> 

-- 
 i.

