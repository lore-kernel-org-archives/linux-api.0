Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794399168;
	b=vRIQ8NLXatNrduJK7sHKG/VksciBbLdKOXb12hfwP04w04LTeXD+kXWYRu1eoJtFAfHC
	 73caBROMUvOkl0HJ26/S5gaXp9voSqDE0bnweP2iTyYYKwX/EB63g7PqnN0sBqwuNgXVW
	 ImSJR1QQrHHMwc0OiqmKVh6uU6iJ0KuRY917g2A3RIYia5ZCyx3Uehq9YDyxTTRtbM4Z6
	 K2kSTw269zolnB0Nu5/hjD5JOQ0ULxNdJ3+eZkSxfDKoxpcMBHda7faxvuHt1H2BmuR5A
	 VWPWiz53zaK9M65o6AS3iLHxD6VBOsTRmfBVlBN9f4E9mS8G3Zp1XDJKwnCEKKYZAyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399168;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:From:
	 Subject:To:Cc:References:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=DndahKbHHVFbP+dR7mo1vACUgPmW4clx8WQ8XgvyXe4=;
	b=PmaJQFNYaTCiDZ13l2bEffNwV/OG1TQcN+ILjSFBfvOpP4tNeGejWTGCOxUdKVtrhHsF
	 uSHz371zbV4chKV0lwVIZvSMliqoVQPJE1Bbwv4qI4rBFFd6sSzx5H1aubYjhwrs1tq4H
	 XKIcrtUb63fZamhjJEh2/Rnf7UNQ+C/ltSG9RSREKZkMR3ZTD3JHBOmDeyWQ8pOHZVrL1
	 dP1hoXf4U6A+2XXPeNg1NN8xhL4Ldz4wXbm8Kv6L6C8DW++yS512AguEqWroaqcb505fA
	 a+y5OSMrADmhn3Mr89BkqxYMsXoTZ8Ak9K1mDVbXV4JHB0gUNQ4K80k9CkfRStSo7UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CFRhYsNO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D227D606A31C;
	Wed, 11 Nov 2026 12:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CFRhYsNO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BFA1F00A06;
	Wed, 11 Nov 2026 12:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794399168;
	bh=DndahKbHHVFbP+dR7mo1vACUgPmW4clx8WQ8XgvyXe4=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=CFRhYsNOzUMwH4d7PXd+CmRWLW36G8MGdZpsDQBVkpdp3HNoJunwy1m+wDKiGyCOC
	 vFV7ltzJOjC+t4Uo5vgZs8qPNbxToq7F3eAuKSnBcS4mfLyZCvY/wsI+d0dlwoKvPt
	 6DsT4OqRjNiVAQGITysmwK0gn94ghxMWYLYd/2qWgwmWWEqHJZl/GLgbiqP4QSL/ep
	 ZnFOCRKnXZKyOm/MPE2DCv8zwqJI/BLRJ2s5oTPerzRiP9aEAkM6KL77+bzc9Byp+/
	 o6Cnv9Dtx6rQG6KzUL4mqRtJfa+kWM3X8VRhmCCL4i7mU0nUaa/AmmPtLKHDo2GWB7
	 mgKOzG3HqL2eA==
Message-ID: <a554e557-3d10-465e-ad3b-90d8357b60f2@kernel.org>
Date: Wed, 11 Nov 2026 13:12:44 +0100
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: Re: [PATCH 2/5] media: Documentation: it6625: document the audio
 controls
To: Hermes.wu@ite.com.tw, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org,
 linux-api@vger.kernel.org
References: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
 <20261103-upstream-it6625-alsa-i2s-v1-2-bb91e2879b01@ite.com.tw>
Content-Language: en-US, nl
In-Reply-To: <20261103-upstream-it6625-alsa-i2s-v1-2-bb91e2879b01@ite.com.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Hermes,

On 03/11/2026 07:50, Hermes Wu via B4 Relay wrote:
> From: Hermes Wu <Hermes.wu@ite.com.tw>
> 
> The IT6625 driver exposes two read-only driver-specific controls,
> V4L2_CID_IT6625_AUDIO_SAMPLING_RATE and V4L2_CID_IT6625_AUDIO_PRESENT,
> which so far are described only in the uAPI header.
> 
> Add a page for the driver to the V4L2 driver-specific documentation that
> describes both controls, and list it in MAINTAINERS.
> 
> Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
> ---
>  Documentation/userspace-api/media/drivers/index.rst  |  1 +
>  Documentation/userspace-api/media/drivers/it6625.rst | 18 ++++++++++++++++++
>  MAINTAINERS                                          |  1 +
>  3 files changed, 20 insertions(+)
> 
> diff --git a/Documentation/userspace-api/media/drivers/index.rst b/Documentation/userspace-api/media/drivers/index.rst
> index 8d2c489b8453e11b8e15ef9d9c1c0312f3da06af..57be8dd5749d7f5aa6e0e21c7e3d89d377a209d0 100644
> --- a/Documentation/userspace-api/media/drivers/index.rst
> +++ b/Documentation/userspace-api/media/drivers/index.rst
> @@ -33,6 +33,7 @@ For more details see the file COPYING in the source distribution of Linux.
>  	dcmipp
>  	dw100
>  	imx-uapi
> +	it6625
>  	mali-c55
>  	max2175
>  	npcm-video
> diff --git a/Documentation/userspace-api/media/drivers/it6625.rst b/Documentation/userspace-api/media/drivers/it6625.rst
> new file mode 100644
> index 0000000000000000000000000000000000000000..efd970e8124979abffb6f9ba3ea1e1bc193820b3
> --- /dev/null
> +++ b/Documentation/userspace-api/media/drivers/it6625.rst
> @@ -0,0 +1,18 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +ITE IT6625/IT6626 HDMI to MIPI bridge driver
> +============================================
> +
> +The IT6625 driver implements the following driver-specific controls. All of
> +them are read-only and describe the audio of the HDMI input.
> +
> +``V4L2_CID_IT6625_AUDIO_SAMPLING_RATE (integer)``
> +-------------------------------------------------
> +    The sampling rate of the HDMI audio stream, in Hz. 0 means that the rate
> +    is not available: there is no stable input signal or no audio, the bridge
> +    reported a rate code that the driver does not recognize, or reading the
> +    audio status failed.
> +
> +``V4L2_CID_IT6625_AUDIO_PRESENT (boolean)``
> +-------------------------------------------
> +    Whether the bridge currently receives HDMI audio.

Mention in the documentation that these controls are read-only.

We need to make standard controls for the audio sampling rate and presence.
They are also used by the tc358743 driver, and are in fact common for all
HDMI receiver drivers (I know of a bunch of out-of-tree drivers that use the
same controls).

So rather than creating driver-specific controls, can you add standard
controls for this? They belong to the V4L2_CID_DV_CLASS control class.

So the defines become:

V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE and V4L2_CID_DV_RX_AUDIO_PRESENT.

This also means that there is no need for a separate it6625.rst.

The tc358743 driver should be extended to also support the new standard
controls. So tc358743_s_ctrl_audio_sampling_rate/_present set both the
custom and the standard control.

Sorry for this, it is a bit more work but it makes userspace easier since
there is a standard control for this instead of having driver-specific
controls.

Make sure that the patches adding support to the v4l2 core for these
two new standard controls are not mixed with the it656 changes. So
first add it to the core, then use it in this driver.

Regards,

	Hans

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 760791e3635f3c306e7fed7240b948d29b45ae66..1d6de374d86d3046d993bf220195b1a75049fa8a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13972,6 +13972,7 @@ M:	Hermes Wu <Hermes.Wu@ite.com.tw>
>  S:	Maintained
>  T:	git git://linuxtv.org/media.git
>  F:	Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml
> +F:	Documentation/userspace-api/media/drivers/it6625.rst
>  F:	drivers/media/i2c/it6625.c
>  F:	include/uapi/linux/it6625.h
>  
> 

