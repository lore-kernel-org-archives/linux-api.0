Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794247329;
	b=UHc8YSu3el+rUv1QhxoivZYsFstsuYEgu/ff5FE/aa+umi0R0aOQR8uu6ZK5HCQ6Wqme
	 ZrO93Da563+ArgMRMUjMsEwRHep8NoxW1mjrKlknjVpsh+KXLO5sMxY7EIFirCwq+Bdg7
	 VpkxXjF/94ut47XQN65TH9nfwS7mrZP7lDoD79+wlNlzP8KjLmiSaaBS5sempUkcnJ0pD
	 Xm+J9+RQcA20OmyYEVltrVPbXXafDund7xSMZ8B4htgaTkSuIUIzPVj8MQ7ml2D3siTP0
	 1fyjaUfqNU6FdBjHUsBcBU9P6GUJ5+iiRxA3n9zN1gbVGnzy/Z74pivCLrGmtrXmqBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794247329;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=KxWYw93Pi5kViZyP3dyIySxBB9d/7DBTkBkUxzwtrZE=;
	b=koSIubITW+NdQ88H0isQ4V8BB41v0Umy7JBEJwbsPcdHDovCnwc3FnsfrngZSKeTDqr/
	 tVz9Q03eacc8M2UoqIrn51aQBRplUqVaJHeiEHOhVfCsJsxebnNtw32xEZrAUeF4KIPcE
	 U6LJnAds7eVtU0fKvBCjhhX5Lfm5/k8QBZbQLBCMZ84bB1iKq4TGxmSmwuhtlFUsTSc8n
	 F5spKdgN8SNb0KhhpaC37crp+6bjrcflvOgw+FMqW2rJi++P3R32osgesDp9Waks8xVA3
	 Jvde+AjNX3rT5qbE5hvuM8zcRJn4CX9Dy5RjVHdS/VfT5UwCY616LVgAsLkzwFri/PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="J4Q4/Q4v";
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FB3606A321;
	Mon,  9 Nov 2026 18:02:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40FB3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=J4Q4/Q4v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794247329; x=1825783329;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=iISDovYgQ4NqAviSm7T6rjP49if52la9bOu9h+thNkc=;
  b=J4Q4/Q4vH6jlMr61TaP0M2gVZxn0vKA530yKtW8EuhS9iddcpeH0SMrl
   cuR79d5cLnH+txwvLBleIKzjPTxt5yMbuma0Wd8E/oTAjrkdB9F4WmgPH
   R/XyOTC2o0fqDi4+O4Bv4KouRZLBH67NwuVQKyJhfc9xVaNpr08yk1rrN
   jhEgjWwrF64P/qzRIzaAkEGncwnVi83iSIhYshvOHzZ7VTfyg4mGIIqqE
   vlhJpIRdzZwghr2OftUXd1fxG1AJ2YcCCYtXfU8q2cHNr6d7g0P4/7JGE
   vuXAV1PZh/SivCT0b7MHoriHwiMADtzk7O5yLPpHGjDQogn4LeQe3+kS4
   g==;
X-CSE-ConnectionGUID: gdq7Ymd3TJWB2orgwWa6UQ==
X-CSE-MsgGUID: hC7z61xoQQyP7CJgp1SZFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2877003"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2877003"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:02:08 -0800
X-CSE-ConnectionGUID: ez1J/oyfQg+dH56aKfCRNw==
X-CSE-MsgGUID: 0v/iqMgBSEmlC2I5T/Z33A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8115454"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.139])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:02:04 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 9 Nov 2026 20:02:01 +0200 (EET)
To: Bartu Alev <bartualev@gmail.com>
cc: Corentin Chary <corentin.chary@gmail.com>, 
    "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
    Hans de Goede <hansg@kernel.org>, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, 
    Denis Benato <benato.denis96@gmail.com>
Subject: Re: [PATCH v4 1/2] platform/x86: asus-wmi: add TUF keyboard RGB
 readback support
In-Reply-To: <20261029-asus-tuf-rgb-v4-v4-1-0d3b877d2c30@gmail.com>
Message-ID: <cc9c8655-6f7c-05f9-ad09-4ea30f1dda95@linux.intel.com>
References: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com> <20261029-asus-tuf-rgb-v4-v4-1-0d3b877d2c30@gmail.com>
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

On Thu, 29 Oct 2026, Bartu Alev wrote:

> The TUF keyboard RGB attributes kbd_rgb_mode and kbd_rgb_state are
> write-only, so userspace tools keep their own copy of the lighting
> configuration and lose track of it whenever the EC changes state on its
> own: after a firmware reset or a boot into another operating system the
> tools show a stale configuration until the user rewrites every field.
> 
> DSTS device 0x0010005B evaluates the DSDT method EC0.KBLS(), which
> snapshots the EC's host-visible keyboard state into a 16-byte buffer:
> lighting mode, red, green and blue levels, animation speed, and the
> four power-state flags.  The first byte is a constant 1 written by the
> AML, which distinguishes a KBLS reply from any other object the method
> could return.
> 
> Add kbd_rgb_read_status() to evaluate and validate that buffer, parse
> it through a packed struct, and convert both attributes to
> DEVICE_ATTR_RW.  The read returns the write format with "n/a" in the
> command position: the command word belongs to the write verb (apply
> now or save to flash) and both verbs update the EC mirror the same
> way, so there is no state to report there.  The three EC speed codes
> map back to the sysfs indices 0 to 2.
> 
> Readback was verified against the EC firmware: the status bytes mirror
> EC RAM at 0x0B22 to 0x0B2E, and the speed codes 0xe1, 0xeb and 0xf5
> select animation step thresholds of 30, 20 and 10 ticks per phase,
> which matches the slow, normal and fast labels.  Tested on a TUF
> Gaming A15 (FA507NV).
> 
> Suggested-by: Denis Benato <denis.benato@linux.dev>
> Signed-off-by: Bartu Alev <bartualev@gmail.com>
> ---
>  drivers/platform/x86/asus-wmi.c            | 83 +++++++++++++++++++++++++++++-
>  include/linux/platform_data/x86/asus-wmi.h |  3 ++
>  2 files changed, 84 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index b33ebdb21aa2..054d1d684bb0 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -1062,6 +1062,65 @@ static DEVICE_ATTR_RW(gpu_mux_mode);
>  #define TUF_KBD_RGB_SPEED_SLOW		0xe1
>  #define TUF_KBD_RGB_SPEED_NORMAL	0xeb
>  #define TUF_KBD_RGB_SPEED_FAST		0xf5
> +/* TUF keyboard RGB status readback *******************************************/
> +struct asus_wmi_kbd_rgb_status {
> +	u8 signature;
> +	u8 mode;
> +	u8 red;
> +	u8 green;
> +	u8 blue;
> +	u8 speed;
> +	u8 state;
> +	u8 unused[9];
> +} __packed;
> +
> +static int kbd_rgb_read_status(struct asus_wmi_kbd_rgb_status *status)
> +{
> +	int err;
> +
> +	err = asus_wmi_evaluate_method_buf(ASUS_WMI_METHODID_DSTS,
> +					   ASUS_WMI_DEVID_TUF_RGB_READ_STATUS,
> +					   0, (u8 *)status, sizeof(*status));
> +	if (err)
> +		return err < 0 ? err : -ENODEV;

What do you (or Denis) think on sashiko's mention about 
asus_wmi_evaluate_method_buf() casting integer.value to int which might 
end up aliasing high-bit on return values with errnos?

The other caller seems to also return that value directly out of _store 
function().

-- 
 i.

> +	/* The AML writes a constant 1 here; anything else is not a KBLS reply */
> +	if (status->signature != 1)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static ssize_t kbd_rgb_mode_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
> +	struct asus_wmi_kbd_rgb_status status = {};
> +	u32 speed;
> +	int err;
> +
> +	err = kbd_rgb_read_status(&status);
> +	if (err)
> +		return err;
> +
> +	switch (status.speed) {
> +	case TUF_KBD_RGB_SPEED_SLOW:
> +		speed = 0;
> +		break;
> +	case TUF_KBD_RGB_SPEED_FAST:
> +		speed = 2;
> +		break;
> +	case TUF_KBD_RGB_SPEED_NORMAL:
> +	default:
> +		speed = 1;
> +		break;
> +	}
> +
> +	/* The command word belongs to the write verb, so report n/a. */
> +	return sysfs_emit(buf, "n/a %d %d %d %d %d\n",
> +			  status.mode, status.red, status.green, status.blue,
> +			  speed);
> +}
> +
>  static ssize_t kbd_rgb_mode_store(struct device *dev,
>  				 struct device_attribute *attr,
>  				 const char *buf, size_t count)
> @@ -1114,7 +1173,7 @@ static ssize_t kbd_rgb_mode_store(struct device *dev,
>  
>  	return count;
>  }
> -static DEVICE_ATTR_WO(kbd_rgb_mode);
> +static DEVICE_ATTR_RW(kbd_rgb_mode);
>  
>  static DEVICE_STRING_ATTR_RO(kbd_rgb_mode_index, 0444,
>  			     "cmd mode red green blue speed");
> @@ -1135,6 +1194,26 @@ static const struct attribute_group kbd_rgb_mode_group = {
>  #define TUF_KBD_RGB_STATE_AWAKE		BIT(3)
>  #define TUF_KBD_RGB_STATE_SLEEP		BIT(5)
>  #define TUF_KBD_RGB_STATE_SHUTDOWN	BIT(7)
> +static ssize_t kbd_rgb_state_show(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct asus_wmi_kbd_rgb_status status = {};
> +	u8 state;
> +	int err;
> +
> +	err = kbd_rgb_read_status(&status);
> +	if (err)
> +		return err;
> +
> +	state = status.state;
> +
> +	return sysfs_emit(buf, "n/a %d %d %d %d\n",
> +			  !!(state & TUF_KBD_RGB_STATE_BOOT),
> +			  !!(state & TUF_KBD_RGB_STATE_AWAKE),
> +			  !!(state & TUF_KBD_RGB_STATE_SLEEP),
> +			  !!(state & TUF_KBD_RGB_STATE_SHUTDOWN));
> +}
> +
>  static ssize_t kbd_rgb_state_store(struct device *dev,
>  				 struct device_attribute *attr,
>  				 const char *buf, size_t count)
> @@ -1166,7 +1245,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
>  
>  	return count;
>  }
> -static DEVICE_ATTR_WO(kbd_rgb_state);
> +static DEVICE_ATTR_RW(kbd_rgb_state);
>  
>  static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
>  			     "cmd boot awake sleep shutdown");
> diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
> index 66c7ab35d6c8..393fd3c5949a 100644
> --- a/include/linux/platform_data/x86/asus-wmi.h
> +++ b/include/linux/platform_data/x86/asus-wmi.h
> @@ -166,6 +166,9 @@
>  /* TUF laptop RGB power/state */
>  #define ASUS_WMI_DEVID_TUF_RGB_CMD	0x00100057
>  
> +/* TUF laptop RGB keyboard status readback */
> +#define ASUS_WMI_DEVID_TUF_RGB_READ_STATUS	0x0010005B
> +
>  /* Bootup sound control */
>  #define ASUS_WMI_DEVID_BOOT_SOUND	0x00130022
>  
> 
> 
