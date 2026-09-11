Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A037231839;
	Fri, 11 Sep 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142309; cv=none; b=TgbPlvsl5LmpuBCUgrFlMFybi5kKzsGhlMTVB8PMdWI61qOyFJdaq++fkWCRl/IqyKx6cKSevWiC9qpJShlGcr6Lu40+zqswSJJXVHrVVUA/J03C/XyoqJ8Lm4ZjaxnoFDkQKQzpHPnZlNv2YwE7xxIKwX2VP1P3u9VNK5AxK2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142309; c=relaxed/simple;
	bh=c76gjyfUWnfOXlc+IvY3nQy4ba8y/OYdpnsrOGISM34=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hTbkelvhgoQfoBIhZ0hxfDj0yTos1tYEzXu4SVcsyGuXx4z/BAFlHn1Ip4rK7kTmT3cXiLGNOxfs9/WIDRx3oul0OT6H07j3jkzySD/bNzv+U8o+7RV82GJSZ/zNfGkdx55YJfEAH5oqvwWTJVlUehrdYKAeXeWv6FCYD+kORD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DphkzoAx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DphkzoAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595D21F000FF;
	Fri, 11 Sep 2026 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789142307;
	bh=pF1mD7koAktSQci5aFCC8LPDfzJk1zpfq+mWVKmKrEg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=DphkzoAxcEx/VHnvhK/jZNOJlguvI2BEAvo4zno4uOXbGr9dakK7iX7z9oOA2ub2/
	 ZV3P5iPp+NgzTHCmkT1SJq9zB3aP75kS3636LQqxKxsg1exWjGTdcbGTHsYdR3ycne
	 YqSmC7ID1jACOEZWYS/mMy0DV3RTtlmFnWpuVH8V3A2xRE9LERbKGdGqc9jmZxDskJ
	 9Bef+Nyz1RCFMFu3qtVyu9b2w8oeIbbMXCVKPeCluIk7g+kv8Ii71GvXnQrkcNbp/U
	 qYgWOAGtQaFXV4s1jxJwjxon7/CW0TTCzMyuuD4hw82vh0ZWuQutek7ByJAXaq5I9U
	 iLVr5UHPERv+g==
Date: Fri, 11 Sep 2026 17:58:24 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: Jonathan Jansen <jonathanjansen@ait.place>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
    bentiss@kernel.org, dmitry.torokhov@gmail.com, linux-api@vger.kernel.org
Subject: Re: [PATCH v2] HID: input: map System Microphone Mute LED
In-Reply-To: <20260904044705.1060507-1-jonathanjansen@ait.place>
Message-ID: <soq55ro6-n7o4-26n6-6o52-24n4sq513nq3@xreary.bet>
References: <20260904022903.607880-1-ait@ait.place> <20260904044705.1060507-1-jonathanjansen@ait.place>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 4 Sep 2026, Jonathan Jansen wrote:

> HUTRR110 defines LED page usage 0x57 as System Microphone Mute.
> 
> The usage is currently ignored, so the indicator stays dark and
> userspace falls back to per-vendor code in hid-lenovo,
> hid-playstation, hid-plantronics.
> 
> Map it to a new LED_MICMUTE. It appears as
> /sys/class/leds/inputN::micmute and uses the "audio-micmute"
> trigger from snd-ctl-led, so the LED follows the system-wide
> mic mute state the same way LED_MUTE (page 0x09) already does
> for speaker mute.
> 
> LED_MICMUTE takes the next free code (0x0b).
> 
> Link: https://www.usb.org/sites/default/files/hutrr110-systemmicrophonemute.pdf
> 
> Signed-off-by: Jonathan Jansen <jonathanjansen@ait.place>
> ---
> 
> Notes:
>     Changes since v1: rewrote the commit message; no functional changes.
> 
>  drivers/hid/hid-debug.c                | 2 +-
>  drivers/hid/hid-input.c                | 1 +

Acked-by: Jiri Kosina <jkosina@suse.com>

for the drivers/hid changes.

Dmitry, will you take this through your tree, please?

Thanks,

-- 
Jiri Kosina
SUSE Labs

