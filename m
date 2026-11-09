Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794247783;
	b=yIFZBF45nzBlLgmsvDqKnc98k2HA+vg39qU4279Si3PGSHoWZmMUDrg3T3R+Be9D8lBf
	 hFlvrYaozKLibvQw0DQ4o/8Bp9SK1zXKg6l8+KTbQdhXIdOGlpm8rOmxxtCKIzvlnwUJI
	 8yezoQdxqhvdJfhA+oZwSlmu3IPOVjZZ8uWlpNZjNXuoG0XwWzombYOOeHvM30onKXNAM
	 u5CvTZ59HJDxlndCSHcJtwLFiEu4zmd63WRV9ZerV+q8Xm7RW76+VLRCu8vwHtxR1UN4Z
	 xFmU8YbZ13kpgN9ohI8L76IsPkFJZxSAuvAnEDyDREjhwTa184vs6aCu3Cbtr5o7Kpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794247783;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=NyETrJbUD+hqxbhle7a7WmJRnJKa8FLKFhpoYnSB0Wk=;
	b=LEOL9L5rr2YFWov9ztp/ovKip17ikO4+ZjyxnEqdizyitHGAkyvoyQ/7Vdgks/sJZwqK
	 lGau19r+2dLLssPP3KLjSxjlgqB62BZ63OU/wJASYu7nRd+cR9URBizS1rgiIy3b468Y+
	 1wNV2CjIfxN+dZIIoB/2Uyxds8lE6Oevfda7ZErVAnewFxas8QPNGT/cz7zISn86pCDez
	 obiLYpS6v5B6WZ05pStuRUL/cN+0/PfGneRQrwbM1Gq37jkJc7zkhnRnu47fD+V7M2++T
	 JjLWOldTWeIm+Kbu2gCWNJnwr5lIkjO293M7wx8bjHX7otzPQsUNzi0bSm74BJbJ+0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gQy8dG47;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F05C60A2609;
	Mon,  9 Nov 2026 18:09:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F05C60A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gQy8dG47
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794247784; x=1825783784;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=xEgo4L9gzdCnmgxxQ23kg4wNOstbd44PXXFSGJn5uDA=;
  b=gQy8dG47TKhI9sl65+rMlrN7qdnsAKQeBxwxAIu34gc3ZLd9EeiRdk+F
   8rVO289IYKU+NX/FfWEYpqmuEhR8GCxUYNhQOpB5cv8jPqMMoOvXtmL7m
   i1r9xvsalPAfmk9wReMN6im0CKYqP5I9JDc9eXFjoto16V8anMApSrJj7
   mlDEFutHKZrQZF4MSCnf8VzU68tXsCQQdDS787dc/DvKw9By8acxt21xn
   m5SYz9ewN7cnmSMyUgtuNo3780F+uEt4YIA+LOSWNZmPjFSnLvk0KcJ3o
   N+Sadc1K17PHkPJfR+or60rbPfyElV6VVTrjQ+tz89eg9j2NpxfiikT2B
   w==;
X-CSE-ConnectionGUID: 8q/ZszU1Qc22Htv6HBwg4Q==
X-CSE-MsgGUID: 4e1DCbm8RfKEgLU/OeQHqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2859416"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2859416"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:09:43 -0800
X-CSE-ConnectionGUID: kMp0NImLRsWnH5m/HbNZzA==
X-CSE-MsgGUID: K/Zw5+R3Szmi9KZroVBOyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8270746"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.139])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 10:09:39 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 9 Nov 2026 20:09:36 +0200 (EET)
To: Bartu Alev <bartualev@gmail.com>
cc: Corentin Chary <corentin.chary@gmail.com>, 
    "Luke D. Jones" <luke@ljones.dev>, Denis Benato <denis.benato@linux.dev>, 
    Hans de Goede <hansg@kernel.org>, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-hwmon@vger.kernel.org, 
    Guenter Roeck <linux@roeck-us.net>, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/7] platform/x86: asus-wmi: dump buffer replies in the
 debugfs dsts file
In-Reply-To: <20261101-asus-fan-floors-v4-v1-1-b8d1c31a99a9@gmail.com>
Message-ID: <09c087ac-d0a4-8665-552d-63d289104e3a@linux.intel.com>
References: <20261101-asus-fan-floors-v4-v1-0-b8d1c31a99a9@gmail.com> <20261101-asus-fan-floors-v4-v1-1-b8d1c31a99a9@gmail.com>
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

> Reading dsts calls asus_wmi_get_devstate(), which uses
> asus_wmi_evaluate_method().  Because that helper handles only
> ACPI_TYPE_INTEGER and leaves other return types zeroed, methods
> returning an ACPI buffer read as 0x0.  This affects fan floor tables
> (0x00110026, 0x00110027, 0x00110033), fan curve getters (0x00110024,
> 0x00110025), and TUF RGB readback (0x0010005B).
> 
> Evaluate the method through asus_wmi_evaluate_method_locked() directly,
> matching the call node, which keeps execution serialized against other
> WMI operations.  Format integer replies as before, dump buffer
> contents with their byte length, and print any other type as t:<type>:
> 
>   DSTS(0x110026) = 16 bytes:
>     00000000: 00 00 00 00 19 30 3a 4a 00 00 00 00 00 00 00 00
> 
> The sentinels 0xfffffffe and 0xffffffff continue to return -ENODEV.
> 
> Signed-off-by: Bartu Alev <bartualev@gmail.com>
> ---
>  drivers/platform/x86/asus-wmi.c | 46 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index b33ebdb21aa21..c55f469cb03dc 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -5038,16 +5038,48 @@ struct asus_wmi_debugfs_node {
>  static int show_dsts(struct seq_file *m, void *data)
>  {
>  	struct asus_wmi *asus = m->private;
> -	int err;
> -	u32 retval = -1;
> +	struct bios_args args = {
> +		.arg0 = asus->debug.dev_id,
> +	};
> +	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
> +	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object *obj;
> +	acpi_status status;
> +	u32 retval;
> +	int err = 0;
>  
> -	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
> -	if (err < 0)
> -		return err;
> +	status = asus_wmi_evaluate_method_locked(asus->dsts_id, &input, &output);
> +	if (ACPI_FAILURE(status))
> +		return -EIO;
>  
> -	seq_printf(m, "DSTS(%#x) = %#x\n", asus->debug.dev_id, retval);
> +	obj = (union acpi_object *)output.pointer;

Using __free() is preferred. Please also declare the variable here in 
that case.

> +	if (!obj)
> +		return -ENODATA;
>  
> -	return 0;
> +	switch (obj->type) {
> +	case ACPI_TYPE_BUFFER:
> +		seq_printf(m, "DSTS(%#x) = %u bytes:\n", asus->debug.dev_id,
> +			   obj->buffer.length);
> +		seq_hex_dump(m, "  ", DUMP_PREFIX_OFFSET, 16, 1,
> +			     obj->buffer.pointer, obj->buffer.length, false);
> +		break;
> +	case ACPI_TYPE_INTEGER:
> +		retval = (u32)obj->integer.value;
> +		if (retval == ASUS_WMI_UNSUPPORTED_METHOD || retval == (u32)~0)
> +			err = -ENODEV;
> +		else
> +			seq_printf(m, "DSTS(%#x) = %#x\n", asus->debug.dev_id,
> +				   retval);
> +		break;
> +	default:
> +		seq_printf(m, "DSTS(%#x) = t:%d\n", asus->debug.dev_id,
> +			   obj->type);
> +		break;
> +	}
> +
> +	kfree(obj);
> +
> +	return err;
>  }
>  
>  static int show_devs(struct seq_file *m, void *data)
> 
> 

-- 
 i.

