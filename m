Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610618;
	b=a/1x7ODSPdGyaJM7SmZqYcf38NZWRwkAUuiNSSm9vX5to6DBr7KxdnrIPJwOW2L4j+RA
	 M65VM7Bfg+fVh4HY9z0ijUUkca2+kwzSU5zkEI4ITZqa5ocfmhQUS4zbXQMGrWgW42cLu
	 K+uzfY3bmXuC8RGquSlqFbNOxqbGdqu2pQV1fyWxu/LSf9mVER7aQb1S8S2p09KGhMUDM
	 C6mMcPftXfwkpgYrz3xZ+1egWwQ6MG1Aa97hxgl2IDy3SnzNy17yi8Ec7/upaCRcO2fQE
	 bc1uadb0l18AWMmsUPPNnaLXyPBFQLhMEwRl2QdYYY6ZTHjNU2IZ/2sAsaE+LerkRcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610618;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=xgMce4ZLn7WugbByXBoQX9uK8N/L98LxV5lBSsjjcpc=;
	b=h3+jad8E8WtDvsYcMTbaoRrx/uIhtPYObGYgJjGzeTYdDNbn3Iz2EvEbGijyXbxUeGTj
	 WTdQM6Q1WMYYW/DSgKv4apn1JpV/yNYPR1n/U+zsOlVbGc6qbC3iKabQMi4KFROklX4pl
	 RYiqfFwq7g9IEU/bJYQ6/r7TtAPYWLrHTo9Vqt6MgWZedcsv8OWJOa2yjYVQ56WKO11YC
	 EsQRk7bB0/xzXrPL1S5cWEPJZWcsuiuRVWtpvEPxCxpLwjyLkwxdHERzYWeOeBfoYedsL
	 FDI1Xt8tpI8yVnxccUxV/tcPotrVx+MDOgPJc3ICByMeIrsi4ZIHYCdRtMUWlcjE4rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BT+hTcP9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8406F606A321;
	Wed, 25 Nov 2026 12:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BT+hTcP9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756F51F000C0;
	Wed, 25 Nov 2026 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795610618;
	bh=xgMce4ZLn7WugbByXBoQX9uK8N/L98LxV5lBSsjjcpc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BT+hTcP9vymG7plIWwg5zVbrsIoEEyfkv9Ln58G0WyvQ/w/RuOhRlcZzcuW8O6Ago
	 H8lPkqpVEf8LdwufW/HUAIhKhlDORtJT8fkSBKjqheJhIGD+nFnuq0jNbDfPJ9/iBK
	 H5U1lgNUrC2MX96rKjFSKaRAXt7mWYQ7T4NynJc+Ujyicbhs/E8oRbnZlexic4zXdE
	 39vG/i9OnvNEoduuA9ys3A5+YZQPJxyW4rxdG5/lWimm6gP/m2uomF0Nt4VeBf5S41
	 yBrei4qtAkoSmp1G67sjI/avTxQNe9Pk6g62G6UO8k9itVUd+e/6nZj2r9ag0Bq8/p
	 YPpTlVbhtKKGw==
Message-ID: <c356089d-775d-4998-813f-644b15eddfc3@kernel.org>
Date: Wed, 25 Nov 2026 13:43:34 +0100
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
Subject: Re: [PATCH v2 9/9] media: uapi: it6625: remove the driver-specific
 audio controls
To: Hermes.wu@ite.com.tw, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Hans Verkuil
 <hverkuil+cisco@kernel.org>, Hans Verkuil <hverkuil@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org,
 linux-api@vger.kernel.org
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-9-a154685f6989@ite.com.tw>
From: Hans Verkuil <hverkuil+cisco@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-9-a154685f6989@ite.com.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/11/2026 04:04, Hermes Wu via B4 Relay wrote:
> From: Hermes Wu <Hermes.wu@ite.com.tw>
> 
> V4L2_CID_IT6625_AUDIO_SAMPLING_RATE and V4L2_CID_IT6625_AUDIO_PRESENT
> have been replaced by the standard V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE
> and V4L2_CID_DV_RX_AUDIO_PRESENT controls, and the driver no longer uses
> them. They were added together with the driver and are not part of any
> released kernel yet.

Well, that's not really true. By the time this patch would go in, the driver
will be part of a released kernel.

That said, this is one case where I am in favor of dropping the old controls
even though it strictly speaking breaks the uAPI.

I'm not aware of any hardware boards that use this chip, so the impact is very
small if not zero.

It's actually an interesting question: are there boards/SBCs commercially available
that use this chip? It's an interesting one, it might be nice if there would be
a board for e.g. the Raspberry Pi.

Regards,

	Hans

> 
> Remove the uAPI header and the V4L2_CID_USER_IT6625_BASE reservation.
> ---
>  MAINTAINERS                        |  1 -
>  drivers/media/i2c/it6625.c         |  1 -
>  include/uapi/linux/it6625.h        | 25 -------------------------
>  include/uapi/linux/v4l2-controls.h |  6 ------
>  4 files changed, 33 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f4456f4589a1b86b140ab578d149884d46a3320a..a7a315f0e80585be26fe2b52a62c19e469cb5703 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14271,7 +14271,6 @@ S:	Maintained
>  T:	git git://linuxtv.org/media.git
>  F:	Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml
>  F:	drivers/media/i2c/it6625.c
> -F:	include/uapi/linux/it6625.h
>  
>  IVTV VIDEO4LINUX DRIVER
>  M:	Andy Walls <awalls@md.metrocast.net>
> diff --git a/drivers/media/i2c/it6625.c b/drivers/media/i2c/it6625.c
> index e4487e8111b94b2fa9f599e37ecd2b8a11425862..64c1cec26edfcb0e0105e00e1b7ba5960252aae7 100644
> --- a/drivers/media/i2c/it6625.c
> +++ b/drivers/media/i2c/it6625.c
> @@ -33,7 +33,6 @@
>  #include <sound/pcm.h>
>  #include <sound/pcm_params.h>
>  #include <sound/soc.h>
> -#include <uapi/linux/it6625.h>
>  
>  static int debug;
>  module_param(debug, int, 0644);
> diff --git a/include/uapi/linux/it6625.h b/include/uapi/linux/it6625.h
> deleted file mode 100644
> index a895658aaf6a80d3fb624cdece33c5135161c72d..0000000000000000000000000000000000000000
> --- a/include/uapi/linux/it6625.h
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> -/*
> - * Controls header for IT6625/IT6626 driver
> - */
> -
> -#ifndef _UAPI_LINUX_IT6625_H
> -#define _UAPI_LINUX_IT6625_H
> -
> -#include <linux/v4l2-controls.h>
> -
> -/*
> - * Currently detected HDMI audio sampling rate, in Hz. Read-only.
> - * 0 means the rate is unavailable/unknown: no audio is currently
> - * present on the input, the hardware reported a sample-rate id this
> - * driver doesn't recognize, or the status read itself failed. Never a
> - * literal 0 Hz sample rate.
> - */
> -#define V4L2_CID_IT6625_AUDIO_SAMPLING_RATE	(V4L2_CID_USER_IT6625_BASE + 0)
> -
> -/*
> - * Whether HDMI audio is currently present on the input. Read-only.
> - */
> -#define V4L2_CID_IT6625_AUDIO_PRESENT		(V4L2_CID_USER_IT6625_BASE + 1)
> -
> -#endif /* _UAPI_LINUX_IT6625_H */
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 942a1df3057e3e49c9111f6a27ec1883d964bf64..a2d4ea909e01f9b705d30b680ef382f5fcd39714 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -249,12 +249,6 @@ enum v4l2_colorfx {
>   */
>  #define V4L2_CID_USER_DCMIPP_BASE		(V4L2_CID_USER_BASE + 0x1240)
>  
> -/*
> - * The base for IT6625/IT6626 driver controls.
> - * We reserve 16 controls for this driver.
> - */
> -#define V4L2_CID_USER_IT6625_BASE		(V4L2_CID_USER_BASE + 0x1250)
> -
>  /* MPEG-class control IDs */
>  /* The MPEG controls are applicable to all codec controls
>   * and the 'MPEG' part of the define is historical */
> 

