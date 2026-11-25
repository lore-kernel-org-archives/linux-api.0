Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610315;
	b=SRUzsqiXRnvf0ltUY1EwIXOUe5EdLFgQC8uMJ4FDVdToanrVs5FECwSY0pbxJhP0D45/
	 e5F6CACxfXjfai8nuW3KeZXFIrmdsrL424hHPhrgWLKKWIZ8W7Dmuiaexq0nGQyTgXIIn
	 AwODcIyqVfMA18Locyk5GaBd3L2oYVZFVI9ZsexZlTOTPLTG3fqjkJtAzBWIgtee/rrx0
	 IRjPVfiW2k5iMlzwrjl2zm93juds0OjHgpE2s5DIenSqoqWgJr4LoLbhE5KlAGhZNc+oy
	 N+lTaog/eF8+j/UVJSxbRSzwzmKf0iDds0Hazchwc0oqvsqCb9TvTSbz+GC9EF5jT7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610315;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=0+AXJAxWZ9BUMXQ24kh2T7Uu8yMvUDzaGqCtAJHJM04=;
	b=hjv+jalfkw9s+5RCONAIVqgXRasr1GY6kymjjSGqrKEHd7ereCUSu6WMDnVqI9tegkoL
	 r8t+zD7uMNJEVNIG4g6aNErt8nn9IEBnLzT3Bpcc+nZwMz50nEnx0aK2ryePdQIb+FYgO
	 3MGmiBiqeTsP6P22pbEaBbUANerB0nDgvqx9tkW+/VG+k0Y1qnL2Lkfren/msd/PbK2nD
	 j1V6ZFrcl+HxSjeXr+U/qkP57mBZ0DavvtoHrZX59j5IyFfCjmMkiTcx5f7Zdjg0E3rD1
	 De8Gq/6SvOErgBBWlWCNLGbXTEUIFflJfqLTxV31WYhDG6M3C5N57WM5p6GJ8besqDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ApzE5VP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9E9606A31E;
	Wed, 25 Nov 2026 12:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ApzE5VP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79B11F000C0;
	Wed, 25 Nov 2026 12:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795610314;
	bh=0+AXJAxWZ9BUMXQ24kh2T7Uu8yMvUDzaGqCtAJHJM04=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ApzE5VP+2dyQZ+VYa227NrDkMHpe2prWp0lrTGmovXoZWR24/hbM0VuIU+zXijTcE
	 FzZNzjjDDRQpNM/XpKgChUEnC/J3zVt3J8uv7t4+ryB/bX2ZLtWqb/BEGAJfVVNiJs
	 Esbo5Bt+ORkjHZwFrg7rhe2bFAF9kFHVynVvPu9AZJ5eGjlN3U2upfG8n8e0A+8RXL
	 wWI3a4PgSJCj52smF7KIu7x8Wc9ipB9qDm3Ta8kEl88Izg/sEJ1Puchk8+z/K582YV
	 7f0PMugFQW25FSSjU/cFIAP/Ya+Hi0aZrO+wsXUihAHb0/ZXnMM/+6bklITcQ24YBL
	 ZULloFZcWTe9g==
Message-ID: <6dba4041-fd5c-448d-9f9d-e3c1dcff8185@kernel.org>
Date: Wed, 25 Nov 2026 13:38:30 +0100
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
Subject: Re: [PATCH v2 1/9] media: v4l2-ctrls: add DV RX audio sampling rate
 and present controls
To: Hermes.wu@ite.com.tw, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Hans Verkuil
 <hverkuil+cisco@kernel.org>, Hans Verkuil <hverkuil@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org,
 linux-api@vger.kernel.org
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-1-a154685f6989@ite.com.tw>
From: Hans Verkuil <hverkuil+cisco@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-1-a154685f6989@ite.com.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/11/2026 04:04, Hermes Wu via B4 Relay wrote:
> From: Hermes Wu <Hermes.wu@ite.com.tw>
> 
> HDMI and DisplayPort receivers can report whether the source sends audio
> and at which sampling rate. Drivers expose this today through
> driver-specific controls (tc358743 and IT6625 each define their own pair),
> so userspace has to know every driver to find it.
> 
> Add two standard read-only controls to the DV control class:
> V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE, the sampling rate in Hz, 0 when no
> audio is received or the rate is not known, and
> V4L2_CID_DV_RX_AUDIO_PRESENT, whether audio is received. Drivers set
> the range of the sampling rate control.
> ---
>  Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst | 10 ++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls-defs.c              |  5 +++++
>  include/uapi/linux/v4l2-controls.h                     |  2 ++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst b/Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst
> index 5918dde83efb324cd27cc4c771245cd2c38d0b0e..a9117912e9cb255a2ce452147858d927e9e3c27a 100644
> --- a/Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst
> +++ b/Documentation/userspace-api/media/v4l/ext-ctrls-dv.rst
> @@ -158,3 +158,13 @@ enum v4l2_dv_it_content_type -
>      from a computer as opposed to content from a TV broadcast or an
>      analog source. See ``V4L2_CID_DV_TX_IT_CONTENT_TYPE`` for the
>      available content types.
> +
> +``V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE (integer)``
> +    Reads the sampling rate, in Hz, of the audio that the receiver
> +    receives from the source. It is 0 if no audio is received, or if the

received -> present

Is this indeed the case, that it is 0 if V4L2_CID_DV_RX_AUDIO_PRESENT is
false? I think both the tc358743 and this driver actually do not set the
sampling rate to 0 if audio disappears. (Might be wrong, I didn't dig deeply
into this)

I'm inclined to drop that requirement, and instead...

> +    receiver cannot determine the sampling rate. This read-only control
> +    is applicable to HDMI and DisplayPort connectors.

...add 'The value is only meaningful while ``V4L2_CID_DV_RX_AUDIO_PRESENT`` is set.'
to the description.

So '0' is specific to the case that there is audio present, but the sampling rate
cannot be determined. If there is no audio present, then, just like AUDIO_TYPE, the
value is not meaningful. I.e., it should be ignored.

Regards,

	Hans

> +
> +``V4L2_CID_DV_RX_AUDIO_PRESENT (boolean)``
> +    Detects whether the receiver receives audio from the source. This
> +    read-only control is applicable to HDMI and DisplayPort connectors.
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls-defs.c b/drivers/media/v4l2-core/v4l2-ctrls-defs.c
> index e062f2088490470c42d6c579ff7675be454a29b0..579b2d297cc8246dddb4e8d4ab74aed1e6084744 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls-defs.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls-defs.c
> @@ -1180,6 +1180,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_DV_RX_POWER_PRESENT:	return "Power Present";
>  	case V4L2_CID_DV_RX_RGB_RANGE:		return "Rx RGB Quantization Range";
>  	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:	return "Rx IT Content Type";
> +	case V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE: return "Rx Audio Sampling Rate";
> +	case V4L2_CID_DV_RX_AUDIO_PRESENT:	return "Rx Audio Present";
>  
>  	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
>  	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
> @@ -1317,6 +1319,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT:
>  	case V4L2_CID_RDS_RX_TRAFFIC_PROGRAM:
>  	case V4L2_CID_RDS_RX_MUSIC_SPEECH:
> +	case V4L2_CID_DV_RX_AUDIO_PRESENT:
>  		*type = V4L2_CTRL_TYPE_BOOLEAN;
>  		*min = 0;
>  		*max = *step = 1;
> @@ -1682,6 +1685,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_DV_TX_EDID_PRESENT:
>  	case V4L2_CID_DV_RX_POWER_PRESENT:
>  	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:
> +	case V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE:
> +	case V4L2_CID_DV_RX_AUDIO_PRESENT:
>  	case V4L2_CID_RDS_RX_PTY:
>  	case V4L2_CID_RDS_RX_PS_NAME:
>  	case V4L2_CID_RDS_RX_RADIO_TEXT:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index d17e41d51d2ec1ccb9e8ceb3ccc89ebc4381a4cd..52124b7acdeab787978029aa49ea75d0ad4cc534 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -1301,6 +1301,8 @@ enum v4l2_dv_it_content_type {
>  #define V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
>  #define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
>  #define V4L2_CID_DV_RX_IT_CONTENT_TYPE		(V4L2_CID_DV_CLASS_BASE + 102)
> +#define V4L2_CID_DV_RX_AUDIO_SAMPLING_RATE	(V4L2_CID_DV_CLASS_BASE + 103)
> +#define V4L2_CID_DV_RX_AUDIO_PRESENT		(V4L2_CID_DV_CLASS_BASE + 104)
>  
>  #define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
>  #define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
> 

