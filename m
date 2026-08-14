Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A6734A791
	for <linux-api@vger.kernel.org>; Fri, 14 Aug 2026 19:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786734810; cv=none; b=EeyoxodHpELd5UBgPLMXxOzgdoHwe8Vqf2NeWemzKZkSVyhyN3P/LAb9OzyfGhhhbUZQL8gvtGQflU0HY18612z61KHPMLpGP1hFmVXoKua+HIiJMRYlmYfNLpvI+Aa+/l9jJpe7VxvAGWZnYGXI9yRvRendzAxth9q45d60AZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786734810; c=relaxed/simple;
	bh=okv0Ruc1kmSe+RVBj8vaGA2dEu/LN4Vk8pTB02StHRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDt08AEo10jFt74f9P+LFK9cy/lGKCBO8tGsLmXDHm3Fzk6kS3aErACHUuF3xe3jPknRVHi4knTgG+TOWvViTLgr1eh2aeWx/iwdp6HR3OcnJGDtpXWj3d6X8VGp4PhLUORSIVGdE1HLBwBSHJ1++HaR70arP1ksLS4xIU0eMeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xr4gy1dA; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xr4gy1dA"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so18496995ad.1
        for <linux-api@vger.kernel.org>; Fri, 14 Aug 2026 12:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786734806; x=1787339606; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y/C3p5+5ukZx6/uSnq5MCFxfLdB8ZfxefsnS4zF/0Jw=;
        b=Xr4gy1dAQX2C1k5Rw9SWN6pAXqPegxY9K4x3GS8DW4IRRlu6nXhGQXwrWFjn+nXPFV
         vjd/rP6keHZ2YoBtZC04Tgw6iFi+MhxTJivPMaD/dYJQlhsImmYISOFSr0EwrKfEnc6W
         jG4zn3sYOxarLCt1J/ldgrnxidwi/ux0n5cnDTseJtlMsz7xpjBoz7euWFrk4Tlvp/7B
         GsJbwXvrK9lVL+qwxeyD7s152fyZPuZ35xQ8a9C8APsmq3nUbQNy0NRgNfVQqv0WAVKl
         r5GT9p5eL+mrg6AjMWx6QSCTRbNkFnpo+hySPvNwybQBM7OvSPLLS0vUnHrSJM9Tbusk
         9LIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786734806; x=1787339606;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y/C3p5+5ukZx6/uSnq5MCFxfLdB8ZfxefsnS4zF/0Jw=;
        b=Oc2v0LT0f7DIRclh+LiPPxm0/8EzjlzNku3pbLIvzHZAw83tBcI+Qu094+XeH0n1wl
         1UVWitKim6hCiiTB0S7WfhFJ8Ocan+AUWNjgkZl26asUHnXm8oI4FAbhZ3XA3JW5jcwa
         T4re+PE8ZCEZd3sdB2xqRx2iHWvFzhT9R088rMOgKeKr53ue6da4wsi/5y20Au6INgij
         NZCJ/paIHaEJRc594sBQPX6uVOfZWGjWhRqT47+lln0DJVhLaDY5ITRTQ3tAVPcBgi9e
         yhXpJ+kQkWqYPPdecowtNq5B6L5OalBrgKrfb2gvIuLnZVIK2F4+qtWYeiCykVM84CQp
         ATeA==
X-Forwarded-Encrypted: i=1; AHgh+Ro316hvHV/enWlf9dYNLiHtkuZvFYK2d3xjN/0re1JHks4252GixADhaVF2eJ9EGB1gURdhmRS3dt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJmXfAmbf0Kljhi1/TMoRBvuefECTTudw6A7bkoCz3LfxAMcvS
	Nj69t90XNb0HtA9sbZyXZXi5pcR3ujtDdEkFOn4zoEXdjqwht/dYeLSW
X-Gm-Gg: AR+sD11gusOLzfBwBkdjMBOFtECXKXH+wZcz/wVcZ8Z2PxMcJIVJAwrt0x4Jvzb40RY
	FdLJqi9Ijdlf7ZsOAgraYZgr8GmlOh0v1AatV1XX5Qy6FFwEfv42MAI+s7fuBo5mgv16HM3nN7f
	UC48zmipFFJb3slkJQ5HqDdTq6T1VDyfQwo3UMTM1rpSBD+gVA4ZI+Rk9lWkVWw6WQvw5veCMLx
	vZ+Kt/z8VjbPK8BgY+2zWW5AMdHdTknNH6cE7anZyDxHuDpQxbEMKq09YO3b7n4VyWkFMlirHNu
	yO5R3B2WYpjdCTdW/OZ66XkW6s8NxTOZjeBI6klI2CO+7iyURk2mHuNYIx2LI37uxenuCA34Jx8
	vKJof24ZvsyLP535pwRvZLfhT/ra2DZgpLrnoG4IZGmRizvpxItyDCijx2tmC0UfGimQQL6yPfQ
	pmqLIiV01qf/pRKLDvu8mSUriejQYbGb0GNJBdOkfm5oz6sygPh9QelroXixqj8j57FQO0qAqBX
	5gaE3lLKx+/iAWPr3n/rG1wcxeDbWq7HSFFnWho
X-Received: by 2002:a17:902:ebc5:b0:2ce:93a3:c16c with SMTP id d9443c01a7336-2d3b0c67d8fmr105739915ad.12.1786734806408;
        Fri, 14 Aug 2026 12:13:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:2ebe:8:e0b1:a24a:3d2a:2ee9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea2f787fsm6880832eec.20.2026.08.14.12.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 12:13:24 -0700 (PDT)
Date: Fri, 14 Aug 2026 12:13:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Evan Lawrence <development@laserology.net>
Cc: linux-input@vger.kernel.org, linux-api@vger.kernel.org, 
	miroslav.bendik@gmail.com
Subject: Re: [PATCH v5] Input: synaptics - add pass-through mode for
 TrackPoint
Message-ID: <an9ocXI6b7WEI8D2@google.com>
References: <20260810142440.9060-1-development@laserology.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260810142440.9060-1-development@laserology.net>

Hi Evan,

On Mon, Aug 10, 2026 at 02:25:03PM +0000, Evan Lawrence wrote:
> Synaptics touchpads with a pass-through port (PS/2 guest) default to
> encapsulating guest data in the touchpad's own packets, limiting the
> guest device (typically a TrackPoint) to the touchpad's low poll rate.
> Enabling transparent pass-through mode tells the touchpad to stop
> generating its own packets and relay the raw byte stream from the guest
> directly, letting the TrackPoint run at its full native speed while the
> touchpad is effectively disabled.
> 
> This reworks an earlier implementation by Miroslav Bendík from 2022
> that was never merged. It keeps the same hardware-mode approach but
> commits the mode flag only after a successful mode command, moves the
> reconnect handling into a generic psmouse hook instead of protocol-
> specific checks in psmouse-interrupt, and documents the interface.
> 
> The mode is exposed via a sysfs transparent_mode attribute that allows
> userspace to switch between full-rate TrackPoint and full-rate touchpad
> operation at runtime.
> 
> If the system warm-boots while transparent mode is active the touchpad
> stays in that mode and does not acknowledge command bytes, so
> ps2_command() hangs and the device fails to be detected.  Escape
> transparent mode by writing SETSCALE21 + SETSCALE11 directly to the wire
> with serio_write() before attempting a reset or probe, both during
> initial detection and on reconnect.

I have not looked at the implementation yet, just a high-level question:

What devices need this? Can they work in SMbus/RMI4 mode instead (which
should alleviate bandwidth concerns)?

Thanks.

-- 
Dmitry
