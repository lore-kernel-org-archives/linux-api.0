Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991567;
	b=w5Ru518FACEUqFrVuvjZssyc8QbANT+8XGDAA/qxQt2HziG1EM6ndBwLH3EJCFj2VVuZ
	 Sfcmo5u26sB8RMXBrXHCM9DWx34aEU9V87Z70tQ3rYor7eyEN62tBh23kF0r7X9Vj5Am6
	 Y1FZbzAjx5V2Rk6ApKLF7TmoihLZAd8kQl+/14zwnybCir29aHSxJNKZnHBiHW2z6S/1C
	 g81OCoLWwKPuBhfIGaDLntuFjsi3bTI3tzboP5HeoEpPJgs0WNOELvolVpAgbKPmHoSTI
	 1DzTnRtoIMqXa9n+lGk8s/XZTtJSjHLLGb7JcsfEUdRBcel7E46HwvPmMqst2wYh50Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991567;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rH7dHadXHQBCAb1xibb6d+8zPhNSRfeCjnCBhbphGSo=;
	b=i7WxLzhZ2QaPDcS00QtIg3Y98R0365/X2F8ReLTK7zghG/v6xuXnfQz4QqHQKFQ5G8wa
	 /yjw40MWseylaeRHZT97R1SsnFGi1t6JypXLDXsj9uL/shisy3iWsN5WJn9gcnjI+Lzq8
	 AXoSQR1ms48UKKUFZ++kHQCwfC8iyhtdktUZfEW++KIHg7Km0b8t4CDKtjz61Hr2TgDWG
	 d/A8xa+wBq0KUoBUedIG+T8fMIY6c/X63oBKI8ErWjO4AWaQJh/MPNlL9419JyXRoNe3C
	 N0zIxGmNhINhFW0KzkAkSxMqaSGT1T1iVOiaeqvPIju9l45hnC824SHiX3hFYYLY46w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EEW8WNWB;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5115606A31C
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 08:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5115606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EEW8WNWB
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1b3ada81853so806742c88.0
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 00:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794991566; x=1795596366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rH7dHadXHQBCAb1xibb6d+8zPhNSRfeCjnCBhbphGSo=;
        b=EEW8WNWByczu4ke+zSMCDWYT3ytnREhs02FtgVDVy97uFVL1M63IfMMn7i1shDNIKY
         EHSikcxcfwuXcY0KfiJy6NQEm98L/FTxMsIMMWTrnD+k1ngKNWjyIYCAaCTKsf3cvtNS
         2RzaOW6cjqRgjb42qoR+vz9uP66wtSwosjEi5ZwXSudA2RIVOUvqfEqWBgrcshrgkmrx
         ZrlL3LSBpgqvO8fYOTZxP9c8C2qbTjPSLhMJ99yDNDotRugINQDbFm6lxFzBZQ8crz3w
         OXmmDDcMlxKevtFaB50JGyJVMqF2axaLqGv03HguhlbVU/sINHXD1T/jFB8xE6MrbaCE
         2npA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794991566; x=1795596366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rH7dHadXHQBCAb1xibb6d+8zPhNSRfeCjnCBhbphGSo=;
        b=ajPu/1vwe0MBS0rweK0l5iw4kkwMTcp8DKb2McOx/Rg99Nppt7NilOK2HnDVq60SWX
         iOl/ELctwfVgreIKx9ipf8wjiM15EzQwluXqKvjJ1qtqRanXq+hOXUFNj91qhgZR7zgQ
         QdjS2hUtOzOKjgt4hBpVcAshFCyk83iPDuEQRNnlGbdWrwN0fGaMx/5HI4OitVJFWPbX
         CwBmDoslWZ+14C4GVmpJs1duWPT8Z4R4BhpoIsieXQNS5J7YJllSsdb4nepmhnLQkygE
         8X9F2s9rOayYdrKfgpvPXo0zeTrDePIOUZLkc+OgvAIXV1PGA8jernDq5TZBwehqzUhn
         TnZw==
X-Forwarded-Encrypted: i=1; AL+hErH5tP72EQJ3O0KH/wIzF9NTnb5z5Y9V0yEcMJliUTX3JcSkburtTujiZOT9r4cIn1fUTc92kgwzVAw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+B7kO/xSQ5IKOHIgPm8RxvDO3oabVNwAGkZSyfgcmxB1TOkbxa
	m88q4EroZApAzMvJhRo4RGcgE5GS+C4pWFHsbhu3ePw4kd6vRUw3Wz1dT6h/SryhTO5nciah
X-Gm-Gg: AYBFou0ni8SNKqbr1A7r5WYo+tVRSOHgKK4YpV9M/9Ldavo3a2oGmSJYTVV1yX4ntOA
	gijTgf0iyHQLHAEfOprp5VlJGnnL/T6RGpDL7+fN9q2jt/ms/Di5WV6IQL7a8hkQkT1Y9wqwiX3
	4EFcZ8MVwDGwgY/sCreGlYnnmCCA62wyuJ5Zgk7P74kc0Gk0vF3MxcLhl6Qhd9HTEStlqq3VZym
	Cz6ddMg4NX8OgqpVIibUgIZw4E3RXDPpzPm+N2rEphnhTK90cnOeO10/LlDTfw+L/6iHk1JBpkZ
	7T492c/tiOgYkkBRs6Ewscg+blynVByK7OMqQu5iCmoyXmHD7N/5AKpRpoBKauYFY5IgJSCXeyZ
	VsSMcN/q77wTL0QkurKhS90eO9IHLj6/N5RrudeqRQFmRzv1wXA0QOHybqg8fCRE3xKJeCHo9w4
	HmfmtZk2taU7VyOPXPASl4UNNYzPrZ8itT1DAzD4Tr9DLrkBzDvoAUxsR4wsSgYM5MwpwHYq1nr
	7jRqbpvfFiUkVrpqY0wiRO4TdVM8CRcx7Cu+a2NLLtRkhNINJG2lD4vt+85lTV/7Wkbi0jkfGP/
	UHgtbOlwBjcQ4Z27DbUjr884j94AZCogUt+dDtL7yLfRattu4/Ed/I9c
X-Received: by 2002:a05:7023:a4b:20b0:1b5:32d6:677f with SMTP id a92af1059eb24-1b543cfc722mr1753116c88.34.1794991565842;
        Wed, 18 Nov 2026 00:46:05 -0800 (PST)
Received: from zypulse-in-radeon-MS-7E24.lan ([2406:da18:1601:7200:e02b:e41c:8db0:668d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447dc5e9sm7220671c88.11.2026.11.18.00.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 00:46:05 -0800 (PST)
From: Yuen Su <zypulsecore@gmail.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH net 0/2] ipv4: allow route dump replay with nexthop IDs
Date: Wed, 18 Nov 2026 16:45:08 +0800
Message-ID: <20261118084510.332821-1-zypulsecore@gmail.com>
X-Mailer: git-send-email 2.55.0
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

IPv4 route flush fails when a route dump includes both a nexthop ID
and its expanded compatibility attributes. This series fixes the
IPv4 kernel delete path so that existing iproute2 can reuse the dump.
If a delete supplies RTA_NH_ID, the ID determines the nexthop match.

The first patch limits the mutual exclusion check to operations other
than deletion. The second adds a regression case to the existing IPv4
compatibility test. The route type and IPv6 changes discussed in the
earlier iproute2 thread are outside this series.

In QEMU/KVM, with the same unmodified iproute2, the new flush and
route removal checks failed on the base kernel and passed with the
fix. The three selected kselftests passed all 36 checks with the fix.

Codex helped extract the IPv4 kernel fix from the earlier iproute2
investigation, add the test and run the baseline and patched guests.

Earlier iproute2 discussion
https://lists.openwall.net/netdev/2026/10/26/186

Yuen

Yuen Su (2):
  ipv4: accept nexthop dump attributes in route deletes
  selftests: net: test flushing IPv4 nexthop routes in compat mode

 net/ipv4/fib_frontend.c                     | 5 ++++-
 tools/testing/selftests/net/fib_nexthops.sh | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)


base-commit: 2a324a58a084c5cfd7e5a2f55e0786bee170a4a5
