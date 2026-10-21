Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792577219;
	b=ojM7ebErQ35dQjyoQjKpk0sWOEmcynvKBv4bW34F1DWzaNmwAGjwmv83XoJous4AMqzK
	 ivrkDQPqreX2jhAjERxLoL6o/DCbkhNIFpG5j/1FriwMnOOSMf3jOydhrXSQCeBRkX6p5
	 7nduYzkc+XwKTYMyax/XIaJ60Ya3l71G3nlcn0JZFU+IAy57yjfZ0u72O7GKXnD9GzvQR
	 zSrqzNebgQHpcjTEL3VuuBIh7ePu3P1EeJQxaQwi3b5d9bur+0ScHiGQSeSyJZWmqUkT7
	 RXxTvtY2ropr/ltai7HQio1gV6scUycsEnlFHQVz9vIheNjweind7wjh4jKgPh+FSsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792577219;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=AwR/mWAjfllw9cCm4QRkuwIqpiC8gCFh6BB36vMgvbM=;
	b=2Trh+dVry3XClZFOI2dbYQLLPG0AWQVjRbcb/Bz2C+GfyGksYtkTvJkj1LI38dlnRWq6
	 Tt/xqR0/IPnHsJ2w/NCl6+iGLtXjH4qO0BxPmf6IjYFO6g9kKWyXyA3BvvXdYTKXQtOIu
	 2djIpIhY9K7nxIpRdrREzH9WyZL2UHf8Tc7nkcx6jKqBSV7o41iX4+XYeN+IOvENs5Vx/
	 p704GsNQw6DS4uMDrByLRo9X3RVDeHUty/VRLVSkiTC3dzthfy2eGHebT3zl2uAkjvksc
	 xnM5vHAoHwpsAeTqc9iJmL1NtJGgkmLwWnOUAb/sB9W0jmD+hJfeZJabUggRGsq+0ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iJ5OCrmk;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B62606A31E;
	Wed, 21 Oct 2026 10:06:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46B62606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iJ5OCrmk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792577219; x=1824113219;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=ddfeBxUm3ZEEfef8gk5qFC+/ow3vU2YA9UAWO5ssV2Y=;
  b=iJ5OCrmkwp7IUc96u7c1PN9ktuOrzpORf+loEUFHaDdd69MjVT33h6/J
   cqXt0T5yDONSbiwHkwTPiCJ6a8ROOOXcymz7XQ6ginarDOZyDNk6yUWpj
   QzudobuHF43anzMJZF4La7eQIdZL6oNw149Ex20Sv/L8L1oJ202NV2oQ+
   Olp1SC+mJjQSI/iRZvpRRP0PdvWLx1z/XcixKY9yqcrOFsA4zJFXKqzjr
   YifM+/p7tt3wqxiGIFB39QntsbKcYjnBLPgI2wUWHO07lU46sLGWj7EJ2
   Qip9smsp1CUaZYcNP+OuRFCPeMmo2YKHf866/3oui9OPE2MZecIlnPJL1
   A==;
X-CSE-ConnectionGUID: JFsMsnCvRK2ab9FZaxQ1/w==
X-CSE-MsgGUID: MDJb+Yz2R/+xWaWMTxOD7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1313756"
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="1313756"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 03:06:58 -0700
X-CSE-ConnectionGUID: eqe3AZTfTpaD1ytC/EQvvg==
X-CSE-MsgGUID: /iJAJg9RRnappbuCo+BvRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="4888835"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.75])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 03:06:55 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 21 Oct 2026 13:06:49 +0300 (EEST)
To: Bartu Alev <bartualev@gmail.com>
cc: platform-driver-x86@vger.kernel.org, Hans de Goede <hansg@kernel.org>, 
    luke@ljones.dev, denis.benato@linux.dev, benato.denis96@gmail.com, 
    corentin.chary@gmail.com, linux-api@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] platform/x86: asus-wmi: TUF keyboard shutdown
 naming and RGB readback
In-Reply-To: <20261010101601.888709-1-bartualev@gmail.com>
Message-ID: <f090ad2d-55b7-237b-864f-cee7917568fc@linux.intel.com>
References: <20261010101601.888709-1-bartualev@gmail.com>
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

On Sat, 10 Oct 2026, Bartu Alev wrote:

> This series fixes the name of the fourth TUF keyboard power state and
> makes the TUF keyboard RGB attributes readable.
> 
> The fourth flag of kbd_rgb_state was labelled "keyboard" and treated as
> a no-op since it was introduced.  In hardware it gates the backlight
> during the ACPI S5 power-off sequence: with the bit set the keyboard
> lights up white while the machine powers off, with the bit clear the
> machine powers off dark.  Patch 2 renames the field and carries a Fixes
> tag for stable.
> 
> The remaining patches prepare and add readback.  DSTS device 0x0010005B
> evaluates the DSDT method EC0.KBLS(), which returns a 16-byte snapshot
> of the EC's keyboard state: lighting mode, red, green and blue levels,
> animation speed, and the four power flags.  Both kbd_rgb_mode and
> kbd_rgb_state become readable and report the write format with the
> command word fixed at 1.
> 
> Responses to the v2 review:
> 
> Ilpo:
> - Documentation: patch 5 adds the missing ABI entries.
> - Errno: the helper already separates the cases.
>   asus_wmi_evaluate_method_buf() returns -EIO for a failed evaluation
>   and -ENODEV for an unsupported DEVID.  The readback keeps the
>   err < 0 ? err : -ENODEV normalization for the positive ACPI integers
>   that leak through, and the AML signature check returns -ENODEV as
>   well.
> - Named defines: patch 3 names the three speed codes and the four state
>   bits, and the decoding comments are gone.
> - Struct: patch 4 parses the status buffer through a packed struct.
>
> Denis:
> - DEVID naming: the write DEVID is now ASUS_WMI_DEVID_TUF_RGB_CMD
>   (patch 1) and the read DEVID is ASUS_WMI_DEVID_TUF_RGB_READ_STATUS,
>   as you suggested.
> - -ENODATA: asus_wmi_evaluate_method_buf() already returns -ENODATA for
>   empty buffers, so no extra handling was added.
> 
> Provenance: the KBLS buffer layout and the speed-code semantics were
> recovered by static analysis of the EC firmware (ITE IT5570VG),
> assisted by an LLM-driven toolchain; the readback patch carries an
> Assisted-by tag.  Tested on a TUF Gaming A15 (FA507NV): the v2
> readback on kernel 7.2.6, and the S5 behaviour of the shutdown flag by
> A/B testing both values.
> 
> Changes in v3, relative to v2:
> - split into five patches, one logical change each
> - renamed the write DEVID to ASUS_WMI_DEVID_TUF_RGB_CMD and the new one
>   to ASUS_WMI_DEVID_TUF_RGB_READ_STATUS, per Denis Benato
> - named the speed codes and the power state bits and dropped the
>   decoding comments
> - parse the status buffer through a packed struct
> - added the ABI documentation, with the attributes documented at their
>   real location under /sys/class/leds/asus::kbd_backlight/ and worded
>   for all laptops that expose the zonal RGB devices, not only TUF
>   models
> - added linux-api to Cc, which the earlier versions missed
> 
> v2: https://lore.kernel.org/all/20260926005625.171560-1-bartualev@gmail.com/
> v1: https://lore.kernel.org/all/20260925200744.129714-1-bartualev@gmail.com/
> 
> Bartu Alev (5):
>   platform/x86: asus-wmi: rename TUF RGB state DEVID to _CMD
>   platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming
>   platform/x86: asus-wmi: name the TUF keyboard RGB state and speed
>     codes

Thanks.

I took the first 3 patches into the review-ilpo-next branch now as there 
is another series that conflicts/overlaps with them.

>   platform/x86: asus-wmi: add TUF keyboard RGB readback support

v2 thread has my thoughts about this one.

>   Documentation/ABI: asus-wmi: document TUF keyboard RGB attributes
> 
>  .../ABI/testing/sysfs-platform-asus-wmi       |  42 ++++++
>  drivers/platform/x86/asus-wmi.c               | 123 +++++++++++++++---
>  include/linux/platform_data/x86/asus-wmi.h    |   5 +-
>  3 files changed, 153 insertions(+), 17 deletions(-)

-- 
 i.

