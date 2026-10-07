Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21824657E0
	for <linux-api@vger.kernel.org>; Wed,  7 Oct 2026 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791395713; cv=none; b=tD1giekcRgYpwh2TmguwEvZ9RMHDagU6oxhY7/JJky/mnwdGQ0o5UVJGeNjjHWu3KXvI2IutMGCeQRkagJltDeANWW7d3Lmsp2bGdiQn9ZcTpr42FF3Wb4ej9IeZc1sxgEqGOH0XAhWjO4s8xozA1KwEmLOTVLMigaSPzO25XUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791395713; c=relaxed/simple;
	bh=ke688EiZv7Hz5A3yoyZYE6WoFX7dc/lqhTa8W6a13dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C29NFB7CQiOMzcj83yIvqIBQD+J2/WwzV8ykZpfKY4r84RopYLenmWOLSlhz4GoCFXQLetiRmewSpq+mdBjo6lenVQN6DUx7vEyZL221npwKrYF8Fo3YJqC7agK8fHQhWuasUrKuXCG2W366LYeLWTvj24dXMJML1fHhOs7UthI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=en7MgX5J; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="en7MgX5J"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93e441e14a1so347076685a.2
        for <linux-api@vger.kernel.org>; Wed, 07 Oct 2026 10:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1791395711; x=1792000511; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UngZ8k3YNt3VJyCBdJrwK5aCUhaIZau8MCEL0x/UbHY=;
        b=en7MgX5JdzfWnY4lbrbnRDKoNvkk5EScS8Zlw89NuHjP4ePEayP9LogDgY4VrsGUVp
         q5LLdyePhpgKRo62Qwgz9iDEdrDsjJnIU9NGOkBevsamWzf3r31r7fRaa866ta+eMGX2
         QUJLhTYGpzEqUkW535/KGBjclJJf698ZCRCmUKRf+ZiSriRRtP+EuPzePhvbTf+8+oaK
         RZkHCdH6qoRI3lM8wUezHP6wIQHK0VolROAKgTEqmNvDDEaPSdLmpYiK40ec13rXECJh
         lFRbkk/ILKsYxsCKOa4JIiMVRggUc7C7LJyZV7DXf+N3ebqkhh1d1UGmLHqliG3hTahM
         4+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791395711; x=1792000511;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UngZ8k3YNt3VJyCBdJrwK5aCUhaIZau8MCEL0x/UbHY=;
        b=Vky0UMRLBn1YBY6kJUoG9HbOHvB3tRAgIK0hgz7BTL2DpqKqyenEong1nO7d0SZu8k
         GP0jRgLFnvqhvydf1fnJW4rJb3aJGuVcF95BGnLMrrLftrgnbv0Cz4x5FoIE/rQOf11g
         BI1BLGt5oocFt3J6bcoZ/VcsrXj9ankBfAgtGGnoqKCq7znDlT2fiAWUDkHjZbgOmkyR
         FzsEZedfGkfQjzfw9zL9F4kpBiNX1N4/si+QZlIQoRj02l5wuySMYVJRPLG9UHvN/n3/
         mKWqSQ15YTLllfLP9o76bLwKQMYEVGxs4yfvLw+GbB60+N7qTNr/Lt9ii3hRpsVLRUAs
         /J7g==
X-Forwarded-Encrypted: i=1; AKwUvBy8KJblsW5TUIrDqIQmm9W9rb0QuwZD8/rOMWP7Esj+hj8/d1Y3ujy7MAbcHrhz6VDK6FTk77rNCEw=@vger.kernel.org
X-Gm-Message-State: AFuF++kzKvoKHBlIhUmUzDDf5nGYyYpV5oCQRx9K9O53FPLMb1oyQbeF
	KeCj5eyV8x2X5UXSLHEGyuIgi6A46zMRmiPM99eu1KPTNNXaSPkegCwQYrAn2bDIamnPbFeP0RF
	Mldnslw==
X-Gm-Gg: AYBFou1C+2Va5NdLyfQfUHsot2pNfxfJQlGj0Hoj3e2YZymKMssW/ILacLoWiDMT2wL
	y7F83sr8PLvSSMsXEo77hS09/I6omr4b4KGiQWxJsNXCrFnqXTUzDin6ZC9qZlQZeYVhhNMAGC4
	RMBO6P4t+KcpA/wvWJJdPh/mFIB0HvnfXX8JSkceXfMt2dJweEzNqDcqacZZt0d+v+/OIdj/+r8
	lKlbzCWs6AFPGMONNZZRqR2X2wJ3wXgc3atAU7oA0cQnoaQAAwSljjA2S5TkJzeWOgVWemNq7f7
	VXsGzpLUrM8mt2rnWwu4BgK5HvOZw45nYdWy0mjzM6pA74qhmpeqXSvy9QGuZOpXrrjtpaNUMXf
	6JTO/J4xR3NKhxaSu9O0nrsXf1JOw458+bkXrLf1yCLI2jx+Sw4Og84dFFpGNaZPUCJngjpE+3f
	chTd+wbuD8aZvEg8EgZZGBbIQEbd6xwnEAkw/PcKQ+raaZ8pfgE9gPxQg6Hf7ez9rwWU7f60Kjp
	evORtF3OYYisK5e4vLuc1Id2uef5/RqmRgc8ZpcVw==
X-Received: by 2002:a05:620a:4081:b0:93c:66da:ee08 with SMTP id af79cd13be357-93e9b76c7bamr579983785a.14.1791395710620;
        Wed, 07 Oct 2026 10:55:10 -0700 (PDT)
Received: from rowland.harvard.edu ([2607:fb60:1011:2006:2008:aeb7:73d7:d8ff])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93e99160036sm274186885a.25.2026.10.07.10.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 10:55:09 -0700 (PDT)
Date: Wed, 7 Oct 2026 13:55:07 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Giuseppe Piscitelli <ooonea@gmail.com>
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [RFC PATCH] USB: core: emit a device-level modalias
Message-ID: <afcecb34-0024-460f-bc21-a7f2b1754d23@rowland.harvard.edu>
References: <20261007161721.60593-1-ooonea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007161721.60593-1-ooonea@gmail.com>

On Wed, Oct 07, 2026 at 06:17:21PM +0200, Giuseppe Piscitelli wrote:
> USB device drivers can load from interface modaliases after a userspace
> client has already configured the device. Loading apple-mfi-fastcharge
> then reprobes the generic binding and interrupts usbmuxd transfers.

This description is very confusing for anyone who doesn't already know 
what you're talking about.  Are you referring to some particular type of 
device?  If not, why mention apple-mfi-fastcharge and usbmuxd?  If yes, 
you should say what type of device and why apple-mfi-fastcharge and 
usbmuxd would get loaded in the first place.

> Emit a modalias on the device event, with unknown interface fields left
> as wildcards.

Why?  What does this accomplish?  How does it prevent 
apple-mfi-fastcharge from interrupting usbmuxd transfers?

>  The existing udev module loader can load matching modules
> before consumers receive the processed device event.

Why do you say "_existing_ udev module loader"?  Are you trying to 
reassure people who might think there was a _nonexistent_ udev module 
loader?

What processed device event?  Is this the uevent added by the patch or 
is it something else?  In what way does it get "processed"?

Sure, the udev module loader _can_ load matching modules before 
consumers receive the processed device event.  But udev might run slowly 
and not get around to loading matching modules until later.  What will 
happen then?

Alan Stern

>  Keep interface
> modaliases and the driver teardown paths unchanged.
> 
> Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
> Assisted-by: OpenAI Codex
> ---
> Tested on x86_64 with Linux 7.2.9 and an iPhone (05ac:12a8). With no
> Apple module preload, the first insertion after boot loads the module,
> keeps configuration 4 and works with iLoader without restarting usbmuxd.
> The current usb_uevent function also passes 18 source-extracted cases.
> 
>  drivers/usb/core/driver.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
> index 3c3bbaf89..29d1acba9 100644
> --- a/drivers/usb/core/driver.c
> +++ b/drivers/usb/core/driver.c
> @@ -954,6 +954,17 @@ static int usb_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  			   usb_dev->descriptor.bDeviceProtocol))
>  		return -ENOMEM;
>  
> +	if (is_usb_device(dev) &&
> +	    add_uevent_var(env,
> +			   "MODALIAS=usb:v%04Xp%04Xd%04Xdc%02Xdsc%02Xdp%02Xic*isc*ip*in*",
> +			   le16_to_cpu(usb_dev->descriptor.idVendor),
> +			   le16_to_cpu(usb_dev->descriptor.idProduct),
> +			   le16_to_cpu(usb_dev->descriptor.bcdDevice),
> +			   usb_dev->descriptor.bDeviceClass,
> +			   usb_dev->descriptor.bDeviceSubClass,
> +			   usb_dev->descriptor.bDeviceProtocol))
> +		return -ENOMEM;
> +
>  	return 0;
>  }
>  
> 
> base-commit: 42bcac323cc3b16566fed8c5b250318ad02a0de0
> 
