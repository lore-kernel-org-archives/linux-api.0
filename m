Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FFE3D0903
	for <linux-api@vger.kernel.org>; Tue, 29 Sep 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790695831; cv=none; b=ZWkW+Dy3/vnlwBFl0MULQwSAR61xYfjyrLPpWG4O8knIQDeDBon/dEA4uKxiZ8NJ4xnhu887jJWYqodc/gBM8Fayd9QlRrsRufjTcXCIQVtd3WnWA/EEvuoQIQOkfFaPvHENKEdRFQsIBRc7z5x2OLUbLG1+KByMTh7eZcOGc5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790695831; c=relaxed/simple;
	bh=F4vwzsAv5drBYD3qzwjgWR2J9+Uw6/OSFUG7o1trW1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHvwzYay8CJs+dFb9PZ+S0Ojarx01OX0XJ7C31hdSKAVxca/1r1T6YbgVkwGsTac82KQmOLPEKM6TxorFOlezLZDveObOP3296oEHX93oVPAosbNq6/slQauKbK15pcCpn5LGzxlZOCVEpGKeDs6HrEmnWLjfB1DH43PeqpHPqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=Ia0fNy+g; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="Ia0fNy+g"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48afd5b1678so11469f8f.2
        for <linux-api@vger.kernel.org>; Tue, 29 Sep 2026 08:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1790695827; x=1791300627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WyDJvPwiURiXggZLxrM4rW7PJScAxLcWq9jkvSmb68E=;
        b=Ia0fNy+g9yzZ+Pw523i8UgyZHcJ+BoCzNGcM8SKXNyz8VqVp8cL8U2nn90MKMi3sX3
         mvXM4A5oQq4vj0u4bQMRLkeYL26lxE+//KhGXm4BeFGAjTiFNh4lG9397nCMzyhV795M
         Rdp3/xQ7Q26XD6DtpALRkj1p+ekol8Lmqnbr6poyz6roLgb+JojPWIrhRglcc/EmYAA+
         QdiSFX13YJ+o4mIEj05nZa10a3JGltxd7nk+Sxt6xJeVaikZJlTA0+YY5eDEOQlRLGrQ
         Jvwtm6BzMKEZu9VyBtZaMGQDv/4H3Zxqlo0z3G32qkYZ333vTQ6Y8ZqMaDa5xXpCAslD
         wWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790695827; x=1791300627;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WyDJvPwiURiXggZLxrM4rW7PJScAxLcWq9jkvSmb68E=;
        b=aPCwxv6oYUzB0juGJMfCE51xthod1lBK6O/C8pah7gIaralnzHFZh5FFbQN2seXVlL
         6V/cE6mL5/uIKPXIbVHH3hisLRkbtkCN6NGKyDFbNAmaSZFKgGgVKeWD8Yl3aSre0aNO
         sIXbCrMScFATwbY+2413LikDsH/De5fZmZrPhgQPkursKkaWO2Lt0gD0diHt2kTQbiIc
         h1A81fy9LC/5TJ/VkVRGXhF6CuklNxcJC+d2IlEtammyOkqVDDaXuHCjKSuv9cbSSQqN
         z5bgUDBZGXrsHULiTkL0vIfYURkQOTyvO8H0lbN7evoZfYg0+bL83oVDEjVWlIlgV1Qp
         6Dbw==
X-Forwarded-Encrypted: i=1; AKwUvByAez1E6qiQzatk1y5/I5QbzZZvhFtAvUuDU7s3mgFcrakhKAn4HwBW1VK3uLVBsJIqikJUmUMx6/8=@vger.kernel.org
X-Gm-Message-State: AFq9FYLUTmfDLq2CzOZH3LEz3YETX6eFlLoQUCiQXJOwSKOZe3iLfvxI
	uJJBg4lEBzdLal5WivIj7MhPwI3UezuzFbfxhiGSwuX6SYVdhlKbtzgF8h8YQD8GmWI=
X-Gm-Gg: AYBFou3hkIvXFmZnwOXRHnlFVymz0gAN3q2NYSLllCnIoHROPaerJDO2hErv1eKq19Y
	UUgNEYmoKE9OWx13TvajfL99jsw+j2Hv2zDxuybeLOyP3+aF/2j0kpJXXMXdpU+z5UDtwaBC1ba
	CJF11AF6OTdjQEAtN4e46g+lhLUN7uhniuLvi9Tky7ohgFIrNnEH2p4n8Sn/RB6ztwIqOd0+5Ow
	xwPzsanxNlfUQTOb3E/z4BIgtLbrDgLFp/bGYie2eYQfJByk9ZFfez2KJrgxnsllkaAa/dUw2oq
	5G0z2HR2lR+phsYwnKd08CQyZtCXOwhjoAElFBfY86z0Pmu8Db7TiVEtQWoKMyg0EbhtZ0BxSXx
	bKcW5uTJdn7aHmGDEDCirpjOabEkMg0g6ekbONotbO8IJUB9ZkAiL7uoE1d7PtkEyGZxSxiqLB/
	zRtHohUlE+Pe06y0ACib2doSgahtOtkAGC94OWb97D53szA4KYQAeeMmiQuAs7FrkynV8Lzqsp+
	RFUt7YhfnADsJk7+DWztyKzkE+tHwLXfajnTWGa5ZObxnUZGVXJp08IxGxFGuasz//6p4/N
X-Received: by 2002:a5d:6f0d:0:b0:488:8131:c684 with SMTP id ffacd0b85a97d-48af171b851mr6071142f8f.13.1790695827301;
        Tue, 29 Sep 2026 08:30:27 -0700 (PDT)
Received: from localhost (p200300f65f19a904123cb16e9a8bb736.dip0.t-ipconnect.de. [2003:f6:5f19:a904:123c:b16e:9a8b:b736])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-48af4f88352sm5171032f8f.4.2026.09.29.08.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 08:30:26 -0700 (PDT)
Date: Tue, 29 Sep 2026 17:30:24 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, 
	Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>, Andy Shevchenko <andy@kernel.org>, Rong Zhang <i@rong.moe>, 
	linux-leds@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] leds: Add support for Turris 1.x LEDs
Message-ID: <arvYcW1jFeLtcQD_@monoceros>
References: <20260928111907.72592-1-pepe.schlehofer@gmail.com>
 <20260928111907.72592-3-pepe.schlehofer@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gf6rtofzqt35lkym"
Content-Disposition: inline
In-Reply-To: <20260928111907.72592-3-pepe.schlehofer@gmail.com>


--gf6rtofzqt35lkym
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v3 2/2] leds: Add support for Turris 1.x LEDs
MIME-Version: 1.0

Hello,

On Mon, Sep 28, 2026 at 01:19:07PM +0200, Josef Schlehofer wrote:
> [...]
> +#include <linux/mod_devicetable.h>

Please don't include <linux/mod_devicetable.h>. This is a header that
pulls in a plethora of dependencies on subsystems you don't need in your
driver. So either rely on <linux/platform_device.h> to pull in the
definition of of_device_id (my preferred option) or include
<linux/device-id/of.h> if you want full iwyu.

> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/property.h>
> [...]
> +static void turris1x_leds_shutdown(struct platform_device *pdev)
> +{
> +	turris1x_leds_reset(platform_get_drvdata(pdev));

Is this needed to ensure a proper shutdown? If not I'd expect this
shouldn't be done.

> +}
> +
> +static const struct of_device_id of_turris1x_leds_match[] = {
> +	{ .compatible = "cznic,turris1x-leds" },
> +	{}

{ } please to match the most common style.

> +};
> +MODULE_DEVICE_TABLE(of, of_turris1x_leds_match);

Best regards
Uwe

--gf6rtofzqt35lkym
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmq72Y4ACgkQj4D7WH0S
/k5KnAgAhZtJJoXqunj2x2oJQnmSxm/PEMoRlwQyPhfFAx2hve16++ANVtEO/Ezs
69fImgBN+zPW4Ueuwzlh+LhhIAlzzkOfP+nfg5lY4m74PrhR2N4QxRCUI9H92e2J
igSY1goMilkzXCBvoCmGtqDK0WlGutBJINqBhj7B0EA+2VSzyLzyKvsF+ODcFlx9
lEisDl45mzbd+KX/WAnRQb8UghxxeIR1N1D/anut+YCU+wEX7Bk8quHAb+xx8QnB
eLG/jzOSdS2MqvwA3W4A7Y+rYmiY09xJcqtGGC7lMGz7lAwZilYy1kFl8FMlCsfs
KJL63mPnhbokMwEmeTCXtnL3QObeMA==
=YuO2
-----END PGP SIGNATURE-----

--gf6rtofzqt35lkym--
