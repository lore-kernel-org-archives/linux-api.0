Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C7A3DF008
	for <linux-api@vger.kernel.org>; Sat, 17 Oct 2026 19:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792263722; cv=none; b=DCafDUvdKWVvS6aZWyo9sm0Nd6l7KjrGJeXjb+hUlfmagHBfzVSttfKX7s6xxNguO+WSCoB8kyAJ0fvadHOnFjOgphL1gxubnXQ1Bdjqgd96J1SPJnELJa6tW7CekcCANZspWC52uVBmWHwSsWyrYG1RPZKvVRjIqIPGctmM8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792263722; c=relaxed/simple;
	bh=OLRW7s+yNC5tjl37gTdFreL7HOCnw4vNpy7AfT7FaTw=;
	h=From:Content-Type:Mime-Version:Subject:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cCduhrP9GbrX71kV3bcAB0lqguWc02hTIc+AMR805J2XruIZebFfyjtmMj/cOwyO0gakXLFQvBVxcTuzHYZ4no9YOfgaznJ+79InQnvGCbN4qFhmhDxIVXX7qWlsnAMqQ9rEQ3F/2VAXvtAyql/X2nyjIebBZauvvtHNPlxfAT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFgc+8+z; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFgc+8+z"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1d484b4a9so12530775e9.0
        for <linux-api@vger.kernel.org>; Sat, 17 Oct 2026 12:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792263718; x=1792868518; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vJ3S+zrJ53PJeoB13lI44vseeQL6ZkTaT4zeMMelbtg=;
        b=FFgc+8+z64PqZZkaSVGU367jYwpOweJeg4qYh+D/KYJIk9fq+4utO6uW5+zHJJ4Wnp
         1884cDf3lzG7fzIAVymVQwmTj5ENqEa22itVXL+rNjDGnpcArWsXeiUDwxsmVgBbQp9z
         aVzjTdoGQnNwh3UHsubIzWIf5zdxIXETVckw7YIKCrj7wSHOYz1FCv3xHgyj0DhGIXdF
         0nsGhSQe6NxpjH0aHBHxozQNyz/KJSFR4vjKSpu9II9CkkjwuvtGtiFdJiAc5Q4RGipX
         MRJInq7jbsrqxzfyhL+exp2Qqezh1YO7PBQgoupkgLG/AWl3rrqZ1m00Mk29uzflLjlW
         dZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792263718; x=1792868518;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vJ3S+zrJ53PJeoB13lI44vseeQL6ZkTaT4zeMMelbtg=;
        b=py6r+GHlKJwqxESv+PFTivfVJS1ltjxGuuSywbm4LvsJr2rsxyyfprH95305uHnYbF
         pmgSIvUJQduW4PuyPty4uL+C24zWu7G0Aj2CCvlL+pEqjihefURdptAe7+mh2RYMHLN5
         dPLOmLJNprqJqfFQrTrZOsMxVfmDEEIp+vQ241NLyY6R6NplSp79FCW3PZ+dk+SQom6e
         7kZGjHMzNqZok51twieBLgr68Jb8KsSl9BfY3jrHt+sDSP7NLtpJx0ENPD41yIVRvejK
         11rHm4viXDuhG7yk9fC7RYyzU9MOOEyWb0gG5RBPO718yjnUPAJD6HPpmf/Q1McfA6dL
         m8eQ==
X-Forwarded-Encrypted: i=1; AKwUvBztuS1hkoRvP07cgRcdpMFEfsOPHIEDVSqZUu1FqyZpO1CalFc0e94t8UuruV+EvuaD7CiypzP12DI=@vger.kernel.org
X-Gm-Message-State: AFq9FYIpctP6Kb9aq9Ot9VSeEtYwuFwSlZw39S0II9LYDXl2EWF3Gzxq
	wyGqBOh/+gon55aJBL3FFMaGsGTbQ5hohA4As3NOuRmW06U1BSTMcdHy
X-Gm-Gg: AYBFou0TpcdZ2hWgo7Pl0dcxKn/BwjADPIAZv6umUwC/SPVh+ZDGXYmCXnP0XuFZRe6
	gtc+Ksid0kd3jm8X+OKNgc9CTdBMxqICi4Qb5tCO+p/hUczVni4hWyBCj/beLg/CbBMMkeogJ3+
	TcAHf3UvuKc1MZ1yEQuBfO2g0G0ihfOM+I9h8YPPAhfcVS+Ywb8LSG+raezZNWd+VZ8C7dzrLsz
	uD9i90554Fk8sVy+Nmc7/XP/b99CN2oL9D6Q94Z0ZfviEPhmmQs1Rwq/P5Yl0v61vO81L52tkyW
	MFLhLKTTHMy7nhhzNqc9dGAbSUsGFhA8rV65BHcOuhHgKYFCnkbWCO7fcRkEMPL8yx/Fal3DDc8
	lQqgM++an9d2YMAyQpraVdn6v07EhW4RrDyTMlfiRdOfLD/ozFyR+NNwTJstxPR36t+UTBC/MY0
	OGQkcQn6MXLQTdakJxiSvY5EZ5EsOdHjWX9jqnhdn27J0ghX/njV875PH8o8ShYxMjIrjZGYeHf
	qwIX2ie9ucHJ6MLetI28x6/aj7B+8/rvqpx6EviH1i5blaQaOknDP3McZ/p7e/kUQE0tZ9JX/Sm
	WOwKH3IGfHVWqaPN0xBDFLNvobzR3MUN9oX6XnApuTeGIhOQUCtjUI76H8AMnBnNvrzfDwAYBHW
	f1llIEjSqUvsTR/Fk
X-Received: by 2002:a05:6000:24c7:b0:48e:e98:8b6a with SMTP id ffacd0b85a97d-48e0e988e86mr1971222f8f.4.1792263717875;
        Sat, 17 Oct 2026 12:01:57 -0700 (PDT)
Received: from smtpclient.apple (dynamic-2a00-1028-8388-a84e-4dec-301f-bf3e-93cd.ipv6.o2.cz. [2a00:1028:8388:a84e:4dec:301f:bf3e:93cd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8bd9sm13074929f8f.35.2026.10.17.12.01.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Oct 2026 12:01:57 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
X-Google-Original-From: Josef Schlehofer <Pepe.Schlehofer@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 2/2] leds: Add support for Turris 1.x LEDs
In-Reply-To: <arvNDgAVO4V_drW7@solitude>
Date: Sat, 17 Oct 2026 21:01:44 +0200
Cc: Lee Jones <lee@kernel.org>,
 Pavel Machek <pavel@kernel.org>,
 Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Andy Shevchenko <andy@kernel.org>,
 Rong Zhang <i@rong.moe>,
 linux-leds@vger.kernel.org,
 devicetree@vger.kernel.org,
 linux-api@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D7371D8B-06B6-4F52-8B08-CC573E699EE5@gmail.com>
References: <20260928111907.72592-1-pepe.schlehofer@gmail.com>
 <20260928111907.72592-3-pepe.schlehofer@gmail.com>
 <arvNDgAVO4V_drW7@solitude>
To: =?utf-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)


Hi Marek,

> On 29. 9. 2026, at 16:45, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>=20
> My proposal is to register the first LAN LED as a true multicolor LED,
> and the rest of LAN LEDs as simple LEDs, and then create sysfs
> symlinks for the multi_intensity and multi_index attribute files:
>=20
>  rgb:lan-1
>    multi_intensity   (true attribute file)
>    multi_index       (true attribute file)
>  rgb:lan-2
>    multi_intensity   (symlink to ../rgb:lan-1/multi_intensity)
>    multi_index       (symlink to ../rgb:lan-1/multi_index)
>  ...
>=20
> This way the sysfs will somehow reflect this topology.
>=20
> Also, the max_brigthness will need to be set to 1 instead of 255,
> since we can set each LAN LED on/off state individually, but color
> globally.

I tried to reach you privately about this. I am ready to do it, but
before I do, I would like to clarify one thing.

v4 will have rgb:lan-1 as the multicolor LED, the other four LAN LEDs
as plain LEDs, and max_brightness 1 on all five.

I am not sure about the symlinks, though. sysfs_create_link() can only
link a whole kobject. A single attribute can be linked with
compat_only_sysfs_link_entry_to_kobj(), but its callers in the tree
(tpm, fadump, img-ascii-lcd) use it to keep old sysfs paths working.
Would you and Lee be fine with it here, or do you prefer a link to the
whole rgb:lan-1 directory, or only the ABI documentation saying that
rgb:lan-1 sets the colour of all five?

Josef=
