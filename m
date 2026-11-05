Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793904687;
	b=emWOHmtjwU32xyk83RJQFvubxEwBG+sQnyGB+0ituULkly2ynfmjEz3dzbBxbuL6r2Bi
	 E810FHc9Q27HgBc81QCMvJ3hkzVQ0xCKLPz+WSR21W5u9+mwHj9RxO3GZk7sYtNy2jMJV
	 wkyO2ZoOI019hsvQq10iGNHtCvdrWKwI3uhkhIeF6tfp8j+Wk2qdfRi4WldAQzLEXpaqg
	 YkXGcq04zq1XBcOHXKE3kqC36UWHXvqUKFPzZPMqNMpL8DeFrxsqyvazOWeoSGa/Lgsro
	 9zRfRwO5oP3tcrql+K6TMpgjcZcY+/q6BIQf6CExJsHkOmqzNr7qgF1Vyz0TmWVudhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793904687;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jnWVUTUnlmsJEpFB8nhtjDbr8Y+ZTWe/nqHnts4RQXs=;
	b=4YBJ9vQHKWSSH4mqa5Rp0pVA1x/GUXNfgQEwYTwfklIe5J28upp5BQrwJQJhGjL1bxji
	 p3/SgUZTqYsAwxu264b2TDogvRfdZh6Tck/xCSnh68M3fAVheyDDzDpFvNPwzvnhCd8jS
	 PD1znpjfTM7pVfi5xqEEom1sOaQCdLRDwJBg9F5tD8qHMeiOaVuHPaDHlyUTldTWnEU0P
	 O+aAK6GqAe8cgAlPPn+5JUHmh8v1nuDhVbbl/moMDcMHu0bxVaP2jrA5CUin22LmgkxXG
	 oYOdibEg9gIvMgCGEi4Dayi42wUY3t9D1HrZ0l2ls/j/YCi1UNYh6huW7/bvyfSFcOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="X8eqe9u/";
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE1A606A32C
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 18:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DE1A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X8eqe9u/
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so16665115e9.2
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 10:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793904680; x=1794509480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jnWVUTUnlmsJEpFB8nhtjDbr8Y+ZTWe/nqHnts4RQXs=;
        b=X8eqe9u/Aq1FrN4sMxD/pefIzG+YXzeOqvrZ8COqfqapO8Q/M1H0Sj1aD0TqhpMLI2
         AmrBQacAjif6fdKpEU+BLEmLC+oewe604mdifwCPdOv8erlIeU5oNwnF3Iy9LL7J8sxq
         PlQgueiT1Olwo5efl/bu6lKuYT85HXTali5gc9szgbGNdqyUrkeDjRdP7E95sVtqCTQI
         VhOsWyufCye5KbdgYYFgpgWSlNKXELlW5y+xgS+Jikcq8fro9a4x/lZSZch5LBeP9NQn
         Jg1xlrjJKhFDmxd+OR1rys5baX34Jvcf5xBAagOLSWMOBBAGXDlgEIq9UvZKeNhb4woY
         BURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793904680; x=1794509480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jnWVUTUnlmsJEpFB8nhtjDbr8Y+ZTWe/nqHnts4RQXs=;
        b=uXKb+xn4b2u+l0aV+YMPluXW68dEvxSMSyDw5RVjWpkgiIUxF5uZIwy5P+qKVnhln7
         wZm92WtL0Km34+zvu7LWtyiL1aoCpJuFmLRZW7P0qyJLTT8vBmSb1l7PGxJ3DuvoRNB4
         sQ9UR6m14fgsX6D470hq5arMdUr3MscX5hyUXn8+CkQkg2DZyFGeWFOVPJRkrZEtQpbd
         S6lwEGgaG0E69r9n8Iz1vJiK0q4+EDu3/i19XNw3JKlbDy4WxiUcO9xNKtPARr+WBA4n
         TDHJfOM29aiYK6pw1uu8v4MnAEmIU500xGdpYSITpMf5587C/C7VNn0dK9pECanUGKog
         JaEw==
X-Forwarded-Encrypted: i=1; AKwUvBzD/WTkYbC8Jba0XyLBXDHmbzvAJ+elHp0VjpR33JKzROdkOudmFd0Uiy9l9ZIBUtgnR9Z48c3Nox0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4dXpXxf0ICzxZIpFSjzwW/0zqt73ETkBbKRG8u7ciJ864MKq7
	Y8zB4itDM3ZVljKpHz1UMAZDBPPWHvqJswAds3OkX4i2uqWCxHvCZwhG
X-Gm-Gg: AYBFou0euMmQ7cvZHmlj0bLZPqUsXbSTlWsgPY7mX7Z66XWYys9yqxPW158PE2I0Ag4
	3XOAdqJgNG0pos5BhAK3QTISr5RwEfoDql0Kwwh2EOMijI7JJvKw7MQCIuK+Q19WXKtNAL0PGEX
	odU7EdJ6UFzA1dJVkPX6+1WsX4KRKDG8YQ2v3rf3vdt8FaDUTFDMRAYMxpPa/p4K3WqoRdPKjN1
	8RBe55/zlou/OPA+haHvsw8p/jsW6GSlx6IOVl+4MMaQguFWmuJvUdaroEBiFbhzS0vIDxnOmKm
	u3lOA2EMelLZV3tH4zEwhoYexwejGvpatSJaSnVbKPSLsM4fIRnmYVfp7VqlmaCyK8RXPmOABCH
	8Un28C17CP7NWUQE/omEJUqXVePSjhg/BE4EXUSDD8k0J7CfFJFmcUi5hxw9WCzveB9UVbfQQrH
	yuG5P35Vro4duS9zFr4xZnAaCIYasnSr6LlUURuzILbx1DVJabRvLGI/GR1xF4LQrWKOG6ZOZPv
	EIb5inuLTytxx74X9pWHM92O1Sll2FyvkI4d7WVwBQVzAq2nI4QaZPskuBPl/DuQ3BSdMgWwFZS
	8P7AnLUnpsxvul0Ah/SOfsIPCo5dL5NDkLSz5qve9dksKKSNzA1OIirHW/k9KvxQYJ7ClwgERm0
	rwGJauTTGkB809AopHRBSAxMgixYhbn7n1eNv974KSyhB+7+JvNtsxofkasjcT+Ha0E4Iqm4pRy
	XxGXGSprxxNQpo9n+89/m+5z9HAZWMKon6YK7d0uRQ16KxynfQebMWXRnb4PNPtz9j51JpAWImW
	8w=
X-Received: by 2002:a05:600c:46c8:b0:4a3:59c9:a744 with SMTP id 5b1f17b1804b1-4b6dd82aa22mr395975e9.7.1793904680202;
        Thu, 05 Nov 2026 10:51:20 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-88bf-3a8a-f542-868c.ipv6.o2.cz. [2a00:1028:8388:a84e:88bf:3a8a:f542:868c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56e2ae72dsm137150875e9.3.2026.11.05.10.51.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 05 Nov 2026 10:51:19 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	=?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
	=?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Rong Zhang <i@rong.moe>,
	=?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] leds: turris-1x: Add support for CZ.NIC Turris 1.x LEDs
Date: Thu,  5 Nov 2026 19:51:17 +0100
Message-ID: <20261105185117.83189-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104150229.GA1650678@google.com>
References: <20261104150229.GA1650678@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Lee,

Thanks. v5 incorporates your style and driver name changes,
dev_ext_attribute, and the layout of brightness_set(). It also drops
led->on and the fixup. All includes are used, and string.h is new.

The global brightness files stay. Generic brightness is per LED, while
this is a single CPLD dimmer for the whole panel, similar to
device/brightness on Omnia. The level files expose the eight steps of
its button.

The reset flag also stays. The LED core reads LED_RETAIN_AT_SHUTDOWN
only during unregister and calls led_classdev_suspend() only on PM
suspend. At reboot, software triggers therefore keep writing after
.shutdown. Unregistering the LEDs in .shutdown, as leds-sun50i-a100
does, would also work. Let me know if you prefer that approach.

The devm ordering stays as well. A failed probe unwinds like an unbind,
with the LEDs released before the reset.

v5 also preserves a dim level set before activating the hardware
trigger, including across a colour change underneath it. This follows
the behaviour of leds-turris-omnia, which I used as the implementation
pattern.

Finally, scripts/checkpatch.pl reports only the 75-character warning
from your list on the mails I sent. It is on a URL line in the cover
letter.

Josef
