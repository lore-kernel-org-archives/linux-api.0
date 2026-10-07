Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E045B3909B8;
	Wed,  7 Oct 2026 21:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407220; cv=none; b=CmO6og5tjBhroMaklmp0kmh1qZDhyyFh53VB0/BE7rcxFXhAUk4Do2EGMkUdRbmKSoJ8nz6F2MXNN9Voj02ozw04bzhXNWd3g2jU5GH2wUc5xogCh4dtb4DZL9Avw/UBLx0JZB+tlYqoXFTfH3urtRSaacU0ZwvMe7eHemZdQr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407220; c=relaxed/simple;
	bh=orJyM4gAkLXth7P1jWfqZCODM31Ti/75+/fEFd5k4y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5gJs0OZWevyKl2rvXt1LJm5VbngObj9+xOcWt217/3weMPPbIlWCUsJbrfqqKaebHHzt1gD/X2Q9FDvpyG8NmqEnWpvLIzDRMaEHWpmODDxuD8gO917VYCEeYlfsE5J563fDjHZTA9s+COME0rX5wr2214psmsQUjYLPrTETTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OE58uRMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OE58uRMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C4F1F00893;
	Wed,  7 Oct 2026 21:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791407217;
	bh=yfEIqFetP+zMSGX0qAkYwfAKB8aIkopgdtGQykOUrq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OE58uRMdt9mOERnYY0kV5VzyNC4WhQvp45Oka40jOlLGV5s3WC1gzPOkQtXVB2c43
	 zWJ7zwb9qPiRO/ZSnjrP+Yx2hcG037tf8hYYZmoEXjqu59O1zi9ROTLxTkHCCy+Qmp
	 uQ4/WJpnTDEwMlEoHAO+SB8xxpcEBMReXB/NPDlcyZMqXAg6fCpc9nb+SCKj+af28B
	 hsdwP86kqMUrpconX/sFQi6DlVU5G9SVhyO/VrlhldVYHZfir7LQDxWLp1fpNA6Qnt
	 7Wb08ULvbY769IY9ZVlgvGpyFT2pmPf3hQto7obJm8jYkEo/TluSzKeKV30XNXcsxo
	 HLkAW3ZRQ5v/g==
Date: Wed, 7 Oct 2026 16:06:56 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: linux-kernel@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Lee Jones <lee@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	Pavel Machek <pavel@kernel.org>, linux-leds@vger.kernel.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	devicetree@vger.kernel.org,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	linux-api@vger.kernel.org, Rong Zhang <i@rong.moe>,
	Andy Shevchenko <andy@kernel.org>
Subject: Re: [PATCH v3 1/2] dt-bindings: leds: Add CZ.NIC Turris 1.x LED
 controller
Message-ID: <179140721655.298625.8529136449283931541.robh@kernel.org>
References: <20260928111907.72592-1-pepe.schlehofer@gmail.com>
 <20260928111907.72592-2-pepe.schlehofer@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260928111907.72592-2-pepe.schlehofer@gmail.com>


On Mon, 28 Sep 2026 13:19:06 +0200, Josef Schlehofer wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> Add a binding for the LED controller on the front panel of the CZ.NIC
> Turris 1.x routers. The LEDs are controlled by the firmware of the
> CZ.NIC CPLD, which is memory mapped on the local bus.
> 
> The turris1x.dts device tree, which is part of the mainline kernel since
> v6.0, already references this compatible string.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Cc: Marek Behún <kabel@kernel.org>
> Co-developed-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> ---
> 
> Notes:
>     Changes in v3, by Josef Schlehofer:
>     - drop the file name and "binding" from the subject
>     - describe the hardware rather than the driver
>     - fix example indentation and use the merged turris1x.dts node
>     - set Josef Schlehofer as the binding maintainer
>     - constrain color to LED_COLOR_ID_RGB
>     - list the required controller and LED properties
>     - describe the register range and the LED order in the reg properties,
>       and put the SPDX expression in parentheses
>     - pass dt_binding_check with dtschema 2026.9
> 
>     checkpatch asks whether MAINTAINERS needs updating for the new file.
>     The MAINTAINERS entry that covers it is added in 2/2, together with
>     the driver.
> 
>  .../bindings/leds/cznic,turris1x-leds.yaml    | 132 ++++++++++++++++++
>  1 file changed, 132 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/cznic,turris1x-leds.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

