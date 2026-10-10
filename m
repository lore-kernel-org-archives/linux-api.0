Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC0237C0EB;
	Sat, 10 Oct 2026 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643862; cv=none; b=iyyv7I5y+x61R1YXUQjy0MRmh+vOMrhl1In2FGFJd20wnv6wGEpQPFzAN1yQ63AwxVKIywWpoNQIq8iPU0xdWsUM3i6xEfTMWKs0bHloBlhVJxVvy/L91ED70XPaImqiLNCFwb7KVBLkRE1TpohuETXzzzFoBhxUDLmRaKQdjVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643862; c=relaxed/simple;
	bh=j/oH5ATLbObupLH2XkSJosKQrJrrkyzykZ7wCEKR1ZI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=tvMfE4SkEJ0GajnjTEHL60VAhxp945CYewc9lj0AL18n1iywJZS24lT7X91gehIhKpKWS7wzURCZAfcsTqaN+CSy9FI/kDli9nN5VqOqEpZAILo/Tyd2+/7p8MjPlGDcLFlS7ozeTAzJ4F7Et9fgEaTBJrRMdzqCwg9wL/q2nK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=PGO+qOHs; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="PGO+qOHs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1791643833; x=1792248633; i=markus.elfring@web.de;
	bh=oTfUhhafjezSPneDU3UoSdRYujnZnCEweY05ZJZWYNs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=PGO+qOHsSag6floqx+1dJqpP9O8NNc9sZJZnMOG8CFAX5//Ip0lCKc4nxMAUBbVF
	 Oc1QqgFbMm1BNWvdeYolmQx6yREwZyfH44C6/K8nukgybkMU47EuNdnE4s1JJ0RiY
	 edgiaq3MJFyx2QcVkgJVhl3ozVWrcWe2c5VD1Vd9zKNdJAIOTPXj3t2T1Z47mYRuR
	 2YV8tF/VieLu3ZomnxeIw805SuoiXj41adhRlj7ppjG7M6/GyOrrNwJOLgTXvh+ZV
	 dQ9wDeiDk4u5u4k2j9EEO84IKKWYer2hwvZes7zDQjU/c42hXgd45NZELf9RoPF5K
	 48mSN/VQF8D4Xcd95Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MgANA-1wjEzH1cfW-00h3Ry; Sat, 10
 Oct 2026 16:50:33 +0200
Message-ID: <d08d3437-c4ef-4b88-938d-71962c2f1e88@web.de>
Date: Sat, 10 Oct 2026 16:50:29 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jihong Min <hurryman2212@gmail.com>, linux-hwmon@vger.kernel.org,
 linux-api@vger.kernel.org, =?UTF-8?B?R8O8bnRlciBSw7Zjaw==?=
 <linux@roeck-us.net>
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <27071a389536dfbc35b628a50e90636ce012c21f.1791559095.git.hurryman2212@gmail.com>
Subject: Re: [PATCH 3/5] hwmon: Add a generic interface for userspace
 implementations
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <27071a389536dfbc35b628a50e90636ce012c21f.1791559095.git.hurryman2212@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H86UT/2XdX8J5fmFIgDf4Z1Ej/Mg+CLH6U4GMuVAqDBqtpXJ2Hj
 j06lHT1DXGXuTtK6mobVHv9Ps7mmr1pfeogjJJVmZQI5bspHVvDyXKoUiN68aVvYOg/xX7D
 aHV0GLjS97e96iXPS8EaFOd0XwB0c2pol+gTTJjU6TApM0qjpGjfLuE9thWmcf+uUg1xDE/
 wQCTpHWcEPd8RY53F9dGA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tN9BGFI92iE=;12VBivF9vy+koQUqXzSJ663z9qt
 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

=E2=80=A6
> +++ b/drivers/hwmon/uhwmon.c
> @@ -0,0 +1,641 @@
=E2=80=A6
> +static void uhwmon_disconnect(struct uhwmon_device *data)
> +{
> +	mutex_lock(&data->lock);
> +	data->online =3D false;
=E2=80=A6
> +	mutex_unlock(&data->lock);
> +	wake_up_all(&data->wait);
> +}
=E2=80=A6

Under which circumstances would you become interested to apply a statement
like =E2=80=9Cguard(mutex)(&data->lock);=E2=80=9D?
https://elixir.bootlin.com/linux/v7.3-rc6/source/include/linux/mutex.h#L25=
3

Regards,
Markus
