Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802259;
	b=aj2wKLQNXrdtPUuXLwq11QSGWQ5eoBtyZC97XSqdi2ODprFD4y3yDewXm900phFFPKFH
	 rbFGgKrW5XRwa+i86kQTnEUB6dE1c92zTsqxPxl/dRayPyfYAW1iySPGHGme6clyekFK+
	 FNeQUmuwfrYBIBKp7SUC+vDJi0llBmQlCuoCpr+y7gR2Pa/P+w0dBd9trjrLvzT93NkLa
	 U+BTD2dzdt6dJEBM/6/Q+qaB2Uk759EuZsoEfMwRQIpe12tusUVrI2tjIvMXOY5f9vfnp
	 yUmlYgkiPJS+Rpj1ngpRXW/If2eGBjcitgCH6lfXxBR/iTW0XdA2bas3vHmFgIH5Htw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802259;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Lw5xfTMZEAmyN2Nc8Nkz8zVlejgCPerABrhvOHqBdhQ=;
	b=qDxEbp5xptnpOR4ysH/ZNr2NUGifkaAaWyB+UvFE5yMSAvPRIiGC3qpb37jBiqlXicQE
	 iBEt0KeFm4YbAoq00YvxLJ4ZqCDh/qnERlIGbO1J9EHMyHIxJicd5wB1vZo3RGwUpDKrP
	 f+iq0opI+P3/JmzqcfSvTged3h+GkIIKf1PUb/w/UTyCBIaIJYbFcYttkjQ01fQgXdNog
	 yB9Mv43p5G8PRxtepESVIOuFQMQN7GTd5EtuHu0tmxJQNaJXaytF3olE0cqg/dPPRzO/b
	 lA1DStbu67+NNxsa23L2bh4OVInUMY/YIe3Un8nqQWJe8alcmHc5LqqhTOkBfGws9kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aekkikD7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1237606A336;
	Wed,  4 Nov 2026 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aekkikD7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE201F00919;
	Wed,  4 Nov 2026 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802258;
	bh=Lw5xfTMZEAmyN2Nc8Nkz8zVlejgCPerABrhvOHqBdhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aekkikD7qYr3oBGooaq2M+Ias4dgd++lhUpdZ88HpA46jXNqe6n0n1Wuc+tZZ6jGL
	 Hji3W7RwoAiOkG0WIXLR8oNpK8qvy92UKTN1eQl+C74gpjKhYAWqtnpMXs3+RhpmKb
	 nZL/3u2+FrbmcvnJIPKOSaIaDkHnzVYSXKnAvl6A0DlwztSn9p/+Yyj79RKvKdy0dr
	 sqjJgnVYhV2oh2+JISnIFDtGFW7K23MHVB/jRQDr3Bzud51Zk/3Pv0lP/232Gd1c87
	 jm6b6YeAul+IoGDlKhW2OKHvNrBnqxkhC/7QBOsQ7piRM7gpN57vffgnhJ6zN5XUVw
	 O+uogSw/NjlFA==
Date: Wed, 4 Nov 2026 15:24:14 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hermes Wu <Hermes.wu@ite.com.tw>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Hans Verkuil <hverkuil+cisco@kernel.org>, 
	linux-media@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH 1/5] dt-bindings: media: ite,it6625: add audio DAI
 properties
Message-ID: <20261104-sparkling-icy-hound-fd0dac@quoll>
References: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
 <20261103-upstream-it6625-alsa-i2s-v1-1-bb91e2879b01@ite.com.tw>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103-upstream-it6625-alsa-i2s-v1-1-bb91e2879b01@ite.com.tw>

On Tue, Nov 03, 2026 at 02:50:19PM +0800, Hermes Wu wrote:
> IT6625 and IT6626 decode the HDMI audio stream and output it on an I2S
> interface, driving the bit and frame clocks themselves. The bridge has up
> to eight I2S data pins.
> 
> Add '#sound-dai-cells' so the bridge can be referenced as an audio codec
> DAI, and 'ite,i2s-data-lanes' to describe which data pins are connected
> to the audio receiver, in HDMI channel-pair order. Without the property
> only SD0 is connected.
> 
> Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
> ---
>  .../devicetree/bindings/media/i2c/ite,it6625.yaml  | 23 +++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

