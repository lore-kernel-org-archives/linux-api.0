Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793194436;
	b=rkLxl0g5ywa7n8aUPJVmWqiTSMEGOxMhf8JwuxkOvLRErShv3TjOy456t2oyBxhLFhoU
	 xcxikNDbcd7Vei04CdGO3uohE73XYEhY/Cps+jSgNxlBZWl2fHlW0bKl6Wd06UJhuLLxd
	 B3+8HSouUoGKabqgK2bMLfWfJS7/7h/F+b1CA7zj0QGTZ9xRaZg9JK6oVdd0CorMQXZEg
	 ob+NRCPNeUby8wyzPho8/k5vBCxLb6HI1u5oDVNpe2Mttx8hpQ7Vd4mF8gHoatUSBQBFY
	 GWyKYrGSwJLOEaQzhG2rB4v66YNSRM2i0oKjJPTGzRFhmq6EEpnVhTimvGSUyiMURmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194436;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mHBWVyhcqxaC5vumFhxxpKEuhD3213M1GsePKvUPh1Q=;
	b=kDrYegG28VEiMnWLIXtvlaQM+tOfl+oeQnML2gsXOKiAoQN30cBWeyB6exw5NkVc67+c
	 a0L/3XxnarIFuoRlpp/vR7uW6/x6OlPJyczcgmMYbhDzBxAXetY6y7gEfxfgFbVpoK5Wp
	 bAFhKcbHOPRb8GL+g35V2Cl6ybovTRaq7S/Z45svDGCA6X12mgBuGDg0x/ToXRH91hTHE
	 9vSXOXNys6tDV5yinJUFLsbD3ZPRy9YGNdC7GqfhF8stgZaxUyWRnCbcpzCHD2qhnn/M/
	 7wf819oyP6gBLmoR0fuEwbZt3w47P3h1fWwWKuNviq/yXKVlVqBklnStqfbvtHZNz1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=armoriq.io;
	spf=pass smtp.mailfrom=armoriq.io;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=a0tLEIZV;
	arc=none smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1085660A261F
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 13:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1085660A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=armoriq.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=armoriq.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=a0tLEIZV
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8aea7b7ca0cso7538407b3.2
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 06:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1793194435; x=1793799235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mHBWVyhcqxaC5vumFhxxpKEuhD3213M1GsePKvUPh1Q=;
        b=a0tLEIZVYyhkTlIJHtgGbFZONiiDQraHICSs8nIr1Mw8HVsHHaim+W21SJOURks2cx
         61LO/g8DvIxgQhaGuocD17ZH/DA4iaOHyjQrLqvDuajbQoadCuwEJCYzv6ytYZ488PyY
         6RP5RF0HmPdnKboB6PcfpwOn894vMmmRnBEgJgJHkKN20mHnSrwCmpTy9nNQaa76UAWN
         NpNmbx2oRjFr0n7ImcBB7NpIjIxHAYO1AHWj0PGm8ai11QqqZC4jA1qSo7eoPgwI0ndQ
         cBlclyvHvowc6wQkBzpllidO02OCyWxupMHOBYWp76zlmeTbU415dVFYLCJd5WjoD/Bk
         ik0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793194435; x=1793799235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mHBWVyhcqxaC5vumFhxxpKEuhD3213M1GsePKvUPh1Q=;
        b=FiaClh6O0BLPvWxUL/4HHYgiRE+vwssKuqr1OtHWJTresuH1MFsdJeyYvL6eP/dx1M
         Teg4+5K9EjGpD2UR8rTE80xXnA+jJy0CmyV6vwayR2papCqtY32Ncjwj6IP+/88i3odk
         plgzerw6nVvpGEllsug5E8yUCrBEBD+CCQfuR44rIUhacXpGvDGFiBK9JKf9GHy4tLAO
         mOkCf2TbzhEo3j10JbDtQJf32AKcwuDjmhVR3C+jEXhir3q2JlOr0M/FT3JYam4hdHLJ
         yjJHvDXjT/I+mOCXFbWsFxwT8FLGWIsrvYFXDJr7FRbMoQcLZMZGxtkDZpMKn4Y903hT
         QaHQ==
X-Forwarded-Encrypted: i=1; AKwUvBzbyyXy0rFO5xY1tUXRhMi3P3p2SjD82lHRxogQIkVALJehFHcqyygxlOHb1ISIjF3MfdkGpLWwhzA=@vger.kernel.org
X-Gm-Message-State: AFq9FYK4surEArF+OMoj5nX7bCpCQpGTanooSzE3YHXjEYL1fM+wXDc9
	oIGu7x3kOJozLmi893ZA0kYxOL7NtnAXzVyrqpe5EJwSJzNpWBuuD3JVXvbD6X+vR59X
X-Gm-Gg: AYBFou3ExfcBcVPvVQgd+S0KLiUJZRdl6+jVDsMmc0i1+Jkzb1mN1qC30k/uNDTPttM
	qARSbyJF2TqPWVhD983OY2eXQym7j5ciq0QbqjKUUML1MoGjxt4jIDPzAsPJrjrobYZMw2+ER3X
	p0RuCBGxwprXWAKmInw+PyyzBX1SEpfxlLoIT8bcUzE2MJVQt9sLMYPEMQYzeiN9fkcfabOf/kW
	//Jf1jJaQFEkoXRUPyyKiMWK4xKHDezwxHYB/UvlHIb/dci9LSFTofXxqV4e5UqfTGuV5BlLAvF
	S19BVp3LxosI/ctOAgSojtSt0Ftjt6rve1Q2Xcba+m0MjNjfNY841z3LImr+9um6TOZQgUtmxsh
	RPzSCn8onCTShoB20KeOlJLWHM+dnyyp5LeF7JucbSODCgcgt7GIwVAGeaXkuZGYcje+iu4Vcdt
	bXxDqTZsyhq0R+VDQPRWgmJQvqBaApRg7XX1TmY2YM4UeXl/0Ur6xTPspqDdo5yMiu0O+FTTqJY
	u0HqjDxoXtW6mDLcwWH/lxgKpWHf/xhxmaojuRnNDmvXZ+9WS6CGyQM/e1gjXCruQlfunLxiEjk
	cvaFzYLob308S0XCieas8aXABAZBNFXClMKkhDbJ0hVOg1Spo8g4i3Q7Uu7ETl63FHL+Ej/X6kq
	ui+AO7Ws2sNYZSIMMkVRq/PoG8Fz37XHWCCz5OJILZpdIFwQ=
X-Received: by 2002:a53:d60f:0:b0:679:992e:3ad8 with SMTP id 956f58d0204a3-67a7bd3cbf0mr1120504d50.132.1793194434760;
        Wed, 28 Oct 2026 06:33:54 -0700 (PDT)
Received: from CC-KJQTV599DQ.attlocal.net ([2600:1702:7b5a:ab90:103d:30e1:1f09:a9ae])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a79f38dfesm1694911d50.1.2026.10.28.06.33.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 06:33:54 -0700 (PDT)
From: Ketan Bhardwaj <ketan@armoriq.io>
To: Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	linux-kernel@vger.kernel.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>,
	Ketan Bhardwaj <ketan@armoriq.io>
Subject: [RFC PATCH v2 6/6] MAINTAINERS: add an entry for the Kernel Assurance Plane
Date: Wed, 28 Oct 2026 09:33:35 -0400
Message-ID: <20261028133335.75899-7-ketan@armoriq.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261028133335.75899-1-ketan@armoriq.io>
References: <20261028133335.75899-1-ketan@armoriq.io>
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

Add the KAP maintainers and the files they look after.

Assisted-by: Claude
Co-developed-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
Assisted-by: Codex
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f53047a..0946d15 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14118,6 +14118,16 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media.git
 F:	drivers/media/radio/radio-keene*
 
+KERNEL ASSURANCE PLANE (KAP)
+M:	Ketan Bhardwaj <ketan@armoriq.io>
+M:	HARIHARA SUDHAN. R <harisudhan@armoriq.io>
+L:	linux-security-module@vger.kernel.org
+S:	Supported
+F:	Documentation/ABI/testing/securityfs-kap
+F:	Documentation/security/kap.rst
+F:	include/linux/kap.h
+F:	security/kap/
+
 KERNEL AUTOMOUNTER
 M:	Ian Kent <raven@themaw.net>
 L:	autofs@vger.kernel.org
-- 
2.51.0

