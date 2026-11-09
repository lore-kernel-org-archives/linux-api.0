Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794249568;
	b=RSTUiyRNgkH0HG8pSVEGFJMGNKOLoLFctRwzHuEuQjZPnqUsyNXk53Sc9jbrYQSy4T4U
	 c4NSUxtkyPXtYtg0pLi37jrpjCVFFCuCvC7pnINCcttRdSJQz56gkmM3hAlVcVlE8wlJ6
	 hbYn1RZ1xr1tq0TSj8tiExC45m/Tszi+NUxh50i3uLegppZmlYGf4Z3QBpiekx8hVWOl2
	 8Qkb/VUXPdFfs/2uihTmuQeiv+af34b42KmLp6WEVV7ufeEKbRnYryjbZcuwvXoJsxTZ6
	 U0nkkYEW+rjJEclUQJnHOmyk0fK6e2mvEWRXLYqXtD5hl+sGISJvPhjACUW1TZN94Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794249568;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=stI3jtpvM2YYP1yEZSkEZ7SghKm/GllTBEaHKU/eszE=;
	b=zduGwRbqL5vdEpmgBIkgNvuDHWrgZfl0V1ENb2Fawp/0YqmZWxeCtgcvgFerpKTW29Is
	 blDySVfDm8689bFm9s8PB0oY7yHGKPYOzXfX5OKpjnuG6lLuzorb8XOO9F1szSkTWTxnu
	 YnkSOZxPa5wrxHX1LOhRL6Z8+irwYfR+1j35pQOpJuzle72cJ47qa99TWbCc9mauCxReN
	 H8/eNqnWG0/OIgqhlEJmJ6j/p8364cu0XW6KzpdkifL8Iv9fYTY4dOhG0IzvWbMfzscP/
	 L7G3PBpZfmxcsp7XLBdlgElEtl4B5YJ8dC/WMOPWMcZgfvkOLmnawJxyihlcTm8yv1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=naOCQY0F;
	arc=none smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113CA606A325;
	Mon,  9 Nov 2026 18:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 113CA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=naOCQY0F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794249567; x=1825785567;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=AR9HO37+WZET1xfDFkT+PkhphAIRkn3TOYR+YW4pQew=;
  b=naOCQY0FLDyR2HgxH3D+0gRvYeXq+gjVINu3DE29990nBzdv5UuNUB5E
   I5ZAD34AW6lkS9kSKeE69O7ZazVGRGOS8Nags0U9oDKAORJfdozUGYC8f
   7GxKgWbYnQv576dQwsZ2DRcvpo30b31octRogY6wPtesXJfAINmuZPQmD
   SdhE6ycWZey+IpiqMYu94ZIYsv1CxJ7Axgh1m6zvhJLPc32+mwhFuYCGZ
   HUI4cs7N5qIoSR4xQd8OpRT16M7zK5j41kIjmVby4253QCmWA1EaZHJc4
   jKZwIv+X5VRw1fvwXDv1ku1XJngth4TUVCxwivqsY7rdH8Skn49qw7iln
   Q==;
X-CSE-ConnectionGUID: SKqdPuGORWeB1izrRNzBlQ==
X-CSE-MsgGUID: FXal0sYyQ0eoel6rppqVRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2850176"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2850176"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:39:26 -0800
X-CSE-ConnectionGUID: rSX/ccPoRViXWqNHd/04kw==
X-CSE-MsgGUID: ScpW41F/QL+SNMjgaexk8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="7795277"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.139])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:39:23 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 9 Nov 2026 20:39:19 +0200 (EET)
To: Bartu Alev <bartualev@gmail.com>
cc: Corentin Chary <corentin.chary@gmail.com>, 
    "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
    Hans de Goede <hansg@kernel.org>, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-hwmon@vger.kernel.org, 
    Guenter Roeck <linux@roeck-us.net>, linux-api@vger.kernel.org
Subject: Re: [PATCH 7/7] platform/x86: asus-wmi: show the effective duty for
 enabled curves
In-Reply-To: <20261101-asus-fan-floors-v4-v1-7-b8d1c31a99a9@gmail.com>
Message-ID: <9e4832e9-9bd1-85c0-8b4d-e1de98373690@linux.intel.com>
References: <20261101-asus-fan-floors-v4-v1-0-b8d1c31a99a9@gmail.com> <20261101-asus-fan-floors-v4-v1-7-b8d1c31a99a9@gmail.com>
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

> When a custom fan curve is enabled, the embedded controller executes
> each point at max(written_duty, floor_duty).  However,
> pwmY_auto_pointZ_pwm reports only the stored value, diverging from
> the duty applied by hardware.
> 
> Return max(stored, floor) from pwmY_auto_pointZ_pwm when the curve is
> enabled and floor data is valid.  When disabled, continue returning
> the stored value.
> 
> Because the controller operates in integer percentages while sysfs
> uses PWM units (0-255), the reported value is an upper bound of the
> applied duty.  Consequently, reading an enabled curve is not
> read/modify/write safe: writing back a read value commits the
> firmware floor into the stored curve.
> 
> Trigger sysfs notifications on pwmY_auto_pointZ_pwm on enable and
> disable transitions, as well as floor refreshes, so pollers detect
> changes in effective duty.
> 
> Signed-off-by: Bartu Alev <bartualev@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-platform-asus-wmi | 14 +++++++++++
>  drivers/platform/x86/asus-wmi.c                   | 30 +++++++++++++++++++----
>  2 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
> index 24931cc97ca86..36b633a5dfc49 100644
> --- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
> +++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
> @@ -281,6 +281,20 @@ Description:
>  		(0-255); the driver scales the duty to the percentage the
>  		firmware expects when the curve is enabled.
>  
> +		While the curve is enabled, _pwm reports the effective duty,
> +		which is the higher of the stored duty and the firmware floor
> +		of the point (pwmY_auto_pointZ_floor_pwm).  A disabled curve
> +		reports the stored duty.  The controller works in whole
> +		percent, so the reported value is an upper bound: the applied
> +		duty can be up to 2.5 pwm units lower.
> +
> +		Reading while the curve is enabled is therefore not
> +		read-modify-write safe: a curve editor that reads the points
> +		and writes them back stores the effective duty as the new
> +		curve, and the duty the user originally wrote is lost.  Read
> +		the curve while it is disabled, or write back the values that
> +		were written rather than the ones that were read.
> +
>  		The embedded controller binds point Z (Z = 1..8) to the
>  		temperature decade [30 + 10 * (Z - 1), 39 + 10 * (Z - 1)]
>  		degrees Celsius and silently clamps the threshold into that
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index 74476904cb99c..bae5a528ac5d8 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -324,7 +324,7 @@ struct asus_wmi {
>  	bool gpu_fan_curve_available;
>  	bool mid_fan_curve_available;
>  	struct fan_curve_data custom_fan_curves[3];
> -	/* protects custom_fan_curves[].floors */
> +	/* protects custom_fan_curves[].floors and .floors_valid */
>  	struct mutex fan_curve_lock;
>  	struct device *fan_curve_hwmon;
>  
> @@ -3754,7 +3754,7 @@ static int fan_curve_load_floors(struct asus_wmi *asus, u32 fan_dev)
>  	return 0;
>  }
>  
> -static void fan_curve_notify_floors(struct asus_wmi *asus)
> +static void fan_curve_notify(struct asus_wmi *asus)
>  {
>  	struct device *hwmon = asus->fan_curve_hwmon;
>  	bool valid[ARRAY_SIZE(asus->custom_fan_curves)];
> @@ -3778,6 +3778,10 @@ static void fan_curve_notify_floors(struct asus_wmi *asus)
>  				 "pwm%d_auto_point%d_floor_pwm",
>  				 fan + 1, point + 1);
>  			sysfs_notify(&hwmon->kobj, NULL, name);
> +			snprintf(name, sizeof(name),

scnprintf()

> +				 "pwm%d_auto_point%d_pwm",
> +				 fan + 1, point + 1);
> +			sysfs_notify(&hwmon->kobj, NULL, name);
>  		}
>  	}
>  }
> @@ -3797,7 +3801,7 @@ static void fan_curve_refresh_floors(struct asus_wmi *asus)
>  	if (asus->mid_fan_curve_available)
>  		fan_curve_load_floors(asus, ASUS_WMI_DEVID_MID_FAN_CURVE);
>  
> -	fan_curve_notify_floors(asus);
> +	fan_curve_notify(asus);
>  }
>  
>  /* Check if the capability exists, populate its defaults and read its floor table */
> @@ -3855,15 +3859,28 @@ static ssize_t fan_curve_show(struct device *dev,
>  	struct asus_wmi *asus = dev_get_drvdata(dev);
>  	struct fan_curve_data *data;
>  	int value, pwm, index;
> +	bool enabled;
>  
>  	data = fan_curve_attr_2_select(asus, attr);
>  	pwm = dev_attr->nr & FAN_CURVE_PWM_MASK;
>  	index = dev_attr->index;
>  
> -	if (pwm)
> +	if (pwm) {
> +		enabled = data->enabled;
>  		value = data->percents[index];
> -	else
> +
> +		/*
> +		 * The EC runs the point at the higher of the curve and the
> +		 * firmware floor, so report the duty it applies.  Only the
> +		 * floor table is protected by fan_curve_lock; enabled and
> +		 * percents are written without it, so this is a snapshot.
> +		 */
> +		guard(mutex)(&asus->fan_curve_lock);
> +		if (enabled && data->floors_valid)
> +			value = max(value, (int)data->floors[index]);
> +	} else {
>  		value = data->temps[index];
> +	}
>  
>  	return sysfs_emit(buf, "%d\n", value);
>  }
> @@ -4059,6 +4076,9 @@ static ssize_t fan_curve_enable_store(struct device *dev,
>  			fan_curve_refresh_floors(asus);
>  		}
>  	}
> +
> +	fan_curve_notify(asus);
> +
>  	return count;
>  }
>  
> 
> 

-- 
 i.

