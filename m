Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799624A5C45
	for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144631; cv=none; b=sYdxTUArF9g0aEfuD4A1a2cdnZ9UrfNFhY1TPCQ+mrez1qKEsh1WxTJTkX2M+7C43/R4quvrk8gD3IpUq0uu6ixvYF71ngZh9wfhls2Bp5Z0+t8H0dBIpo5cjlPpqeslxHok8zZqgdaIMOjxqy8aeKiIHIkli9z2MbU7mHM6MiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144631; c=relaxed/simple;
	bh=4mfLk97WGWUYO0LzVc/bd26XHKUDdtW1nlfPHmu3EKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=op0qQKxeIAK9rrZ0/L9BCeFm0ocwgnjAB2DE2M89VjsMp0VUL1RVB9g4VTfUNh37yGPNivanZaB+uFUnoNFcjqpBgDQK5gal6lFB+0dbXUgjRG/t282NCL0G7wU9mWqYcy5mWZMhHXv5aJYiB+YrFEObvrD3L3pUPSCGSCTKNSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FsnlUFUB; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FsnlUFUB"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ee1f9bso307845ad.3
        for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 09:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789144624; x=1789749424; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5Z3nbbb1FAl9xLQpw8Rh7y5TS4mkzVFghEZ+69cMYSA=;
        b=FsnlUFUBuMlYjlrSnyqWYviUKVY0u+jcU6HD9lAFaKkbJzEKgC4qAYpwnNvjh8dMFY
         N5Kj8C0GVXBjmtYp02jgc/t96ZZGErkMGI6C5quG9FMp16gGBTOThaT9UspyR17AWjR/
         0ibAkMgRrsHv4FxrDIIdIV6yhA7Xs8MDtNqvpNTL9ZywG/4E5HLhXg8t0EkTalmLXGBU
         SwvZuu49OoqWlievrMOFp7rqkYSxDanTgep0AUEV+0XIHXTqg7cePeksolbY6JH6rFJp
         Zg9b/Z32yt5Wzq69gNgV6PsldK3PMIsQFDBCQFLHqoqBouqkE/y7NKQrf8XAzQYtBKzD
         v1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789144624; x=1789749424;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Z3nbbb1FAl9xLQpw8Rh7y5TS4mkzVFghEZ+69cMYSA=;
        b=J3EVp7O3590Gtu/7KXwmQq+TVmizYW30GXuwxUdxkDMcCHBJhq0rVEaOf89exG9f11
         032oPennEhGBwJAABuqlv5mQLQ+tbrusTMGLFji4YcmC4U5WiLrTIdsqBG+THmPLlGXX
         b2pyb+SmmlvknUMdrOzSW8XD51/sqK/GtmToLMs3jUiE4OTez6v/ihjf9IQDfsuvs280
         bp0G5chHekmmQiiImFJb6Ox9JxNnXitjSOvARABxKiSI3C0mMPTa2M0tGGzh91mI9IZS
         Kt7FMgQJzErEE+lXpbyV/rxV1Vx9aI9o5Ux7jOw/iJ20LOdgs7dUEM5A6vVn+i8fZXpD
         e8cg==
X-Forwarded-Encrypted: i=1; AKwUvBzs178OY4uf1Kl6Y9RpEFWUnq5xNF1WkfkFfhfFdJbO9jWi5EzNKl27/AfRp+kadmNioQrBCeCX5GI=@vger.kernel.org
X-Gm-Message-State: AFuF++lDU5+d8kN0yL4sY+4dhfWaB3xq/6gFfL9OiITNWHqSWk99j5wp
	XTQRGoqkPZkEwZsV/KQWUo/JGRhUf9EMg5bFPAfjMIah4915DW9k+RAR
X-Gm-Gg: AYBFou3UOMUR9ulItSl5T47CsJlZg2NURHpag0VLfttRfZMijOgatfNuVFl7Khr7KnL
	py/dLzGL/UJrrlKvjG57JiTR4HQ6lkWHzVy+88SFTjJd//Kv0oa3vxeA1xP69eLUm5FZr8Z8F44
	/QHEAnbuZqFWiXiXVGUFkvBhUcTduaYjipu6ZNXxC8phBh4yz85WGNSFsKFtEXD9qYGB8d2DBnR
	xusSJlaWuwdybMsrHVt4qtCUpbGkZ17EF3hUAZ3DKUMT/G6HN+taadSj6lUjkntNXuzreliUFI1
	Sl1LBsaIBlUyoveqSwRC1ocvFln+C7kuBBWCm/JX/0wfB8QNvcnOSwa11MQlp6dwvTsksRLBF5p
	aw5uiZgsHYyKIvuWWDKYg0twGL/ss3TgFj8l9GRblW/Gty1sdzBZStTqIqHN8Chh+LXdtVRsPbb
	yBRKTDw3RUMv2u8oK4n6bT3TldY6a5NitftJwEnC8MJNFi1QyipINsmiPszE4U9UU16BMDXd89M
	iPBPwUkVRP5FmLQNjGp4b1vxMOOzSi65C3floCo
X-Received: by 2002:a17:903:1ac5:b0:2db:539c:b7c7 with SMTP id d9443c01a7336-2dd2a46d478mr99060775ad.20.1789144623880;
        Fri, 11 Sep 2026 09:37:03 -0700 (PDT)
Received: from google.com ([2a00:79e0:2ebe:8:7e36:d696:74c7:8be3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4f55735sm8349902eec.24.2026.09.11.09.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:37:02 -0700 (PDT)
Date: Fri, 11 Sep 2026 09:36:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jikos@kernel.org>
Cc: Jonathan Jansen <jonathanjansen@ait.place>, 
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, bentiss@kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] HID: input: map System Microphone Mute LED
Message-ID: <aqQs_lxGOREamXiO@google.com>
References: <20260904022903.607880-1-ait@ait.place>
 <20260904044705.1060507-1-jonathanjansen@ait.place>
 <soq55ro6-n7o4-26n6-6o52-24n4sq513nq3@xreary.bet>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <soq55ro6-n7o4-26n6-6o52-24n4sq513nq3@xreary.bet>

On Fri, Sep 11, 2026 at 05:58:24PM +0200, Jiri Kosina wrote:
> On Fri, 4 Sep 2026, Jonathan Jansen wrote:
> 
> > HUTRR110 defines LED page usage 0x57 as System Microphone Mute.
> > 
> > The usage is currently ignored, so the indicator stays dark and
> > userspace falls back to per-vendor code in hid-lenovo,
> > hid-playstation, hid-plantronics.
> > 
> > Map it to a new LED_MICMUTE. It appears as
> > /sys/class/leds/inputN::micmute and uses the "audio-micmute"
> > trigger from snd-ctl-led, so the LED follows the system-wide
> > mic mute state the same way LED_MUTE (page 0x09) already does
> > for speaker mute.
> > 
> > LED_MICMUTE takes the next free code (0x0b).
> > 
> > Link: https://www.usb.org/sites/default/files/hutrr110-systemmicrophonemute.pdf
> > 
> > Signed-off-by: Jonathan Jansen <jonathanjansen@ait.place>
> > ---
> > 
> > Notes:
> >     Changes since v1: rewrote the commit message; no functional changes.
> > 
> >  drivers/hid/hid-debug.c                | 2 +-
> >  drivers/hid/hid-input.c                | 1 +
> 
> Acked-by: Jiri Kosina <jkosina@suse.com>
> 
> for the drivers/hid changes.
> 
> Dmitry, will you take this through your tree, please?

Hi Jiri, Jonathan,

Sorry but we should not add any new LED definitions to input since we
have proper LED subsystem now. The existing LED definitions are strictly
legacy now and input core has a bridge to LEDs (in input-leds.c).

I see we had similar submissions in '23 and '24 at the very least. I
should add a comment to that effect to input-event-codes.h.

Thanks.

-- 
Dmitry
