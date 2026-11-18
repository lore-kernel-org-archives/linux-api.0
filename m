Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991572;
	b=purar/EcXnteoHOPFP0OpmhMwWqd/qQttC3b4UpKIh5Ggd3woSLTXhBWIGNlk4NsoGnd
	 u/JFwPid6JQSYUQrAxEEI67AEVVwv92tVPcmwomQNx2BUlqexyE0bnj8VMt9MC55tPQF4
	 QdkjXctJ4ejanQD6QxBzgNEaDCSIvbN17MwAKjYYChl7VtaOb/t9PcSkE44rT8Cer5CuC
	 UscRiXB6CIXQ2CbR+MlvpENJRYMhuwV6kfW/um7ZuFh0rB1mabea/4BT7zCPRkPGbQpI2
	 i31Ac45znkph/NDrUMdJ6f7NsBjv1d76QsJE4m5Orv7gVw6q4KoplKMbdmFRN7fI6Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991572;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3QIwNNjbPCMY9vDnX5iy4rnVih4SICdsbjgMj/Fl6DI=;
	b=Z/XASzliTGRenvL7zVVJLwekbjFRWNP5xWXYaY5FlEZNkDHl8wexQ5C5IuZgO33F9605
	 nN7bMTT1kCF09oRfklKz0a/Fdifd/de/GG98dQjvLqHkX/yYGlj21Oo5mozDG8gNrDUNT
	 Ef5ME+v7bUaH3YaI8nPcyk/jzdzkhn+TD7YorY/xq0aiYBuBrJsbXwlQja75yXj5WKmWG
	 gRIOJx7+IwL0thb/BD2tJTvm1tTfqArqASx0oAmP83Unyi4WaaoUOudDUf5msZPj8M/Ig
	 JPr5rPaGaFEavinH6z0k9c2umVMLE/uLkZ7q/W9cLYiaapbq8Q3TxKZ0Lal5lSC0Prg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ylwfilqf;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDBF606A32A
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 08:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDDBF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ylwfilqf
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-14394530ec6so1146449c88.1
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 00:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794991571; x=1795596371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3QIwNNjbPCMY9vDnX5iy4rnVih4SICdsbjgMj/Fl6DI=;
        b=YlwfilqfImrmeUkjlmi31h8/Gtwx5R+YTc3jkhYD55hYY4e+ISCZjjjbTdIiTzhcV7
         cbSD6Mhy0IK4wtt/gqPLb3WBm/5UwX5ZaiG7GxzQQ21Y16HGi71C6/Q32aJHlyQFBTo9
         o43bdcYA4TeNLD/jN8dVcvW6x4KD5Y9xsgFAE/mXaBPcVfAQSxmdd0ZmeS+88bPuJ6/y
         GuEXauXS/+B4MK+eeDHAnsozZwqhXA3K+9RnlLJPuWqj3W0vecclR2WMx3PKOYSu4nm2
         0JE54dk5TPK5j/uixo96McpIYb+68Q936zCzgqvjbOwp/oco8cQjFQZImAqdnXwEA/h7
         eJUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794991571; x=1795596371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3QIwNNjbPCMY9vDnX5iy4rnVih4SICdsbjgMj/Fl6DI=;
        b=I3yPN7YKDS7lG2djyAfAyXywetxhx5sRm/LGIvoYjDKfOgARrKd22j+MTTykHYp+wm
         yvv8tsYBRCrvg/SFkQTzcAxElLXeUHXo6Qj5rOHbVj6PZLHb/wtYnqdBZt/YRKfJcquq
         fi/DoLaGhcxSuuNEkmOug4xYFdbmYer5i1JiywmefsJX2WCo7JvEYkFMlo+wWUsObn1T
         st3tVebwIIfxRx0jWiW8qWYnlyrpPjwLd+vrsxSLcfA0aXVfcwqBX8tOtLDJC5n52bnD
         q7DX13iQwe+q7n3KivPd8K7auj0svvzQpHf6vzZElI/m/0T+7Ya4WNcl8fPL6w7YwLSb
         yCJg==
X-Forwarded-Encrypted: i=1; AL+hErHAhO530MPH51eTpATFEKrfFTqb0jGRLsC3NoqTFIieGXwCmHdp6hF197Tf/a7Aheg8ix2CFfPQSS4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Qz/+JdH4kUM027h+u+OVhbu2IvePuU7nyXcBDCoqNQtMYJPXb
	SWJFhKGCYWzYqatoZhHn5gNDpWJK0s+eRO+qZ95/8SQX47McF9Z3L4eA
X-Gm-Gg: AYBFou17U/D2RNgKHIyoWVW3VK1lGvdM4NXqpnVi1Z4CHOUJKi3xF44dvVSfgm0iYVq
	NZD5kaQ6mFPZc2jMACdOM5dZDXk/hsIRTKBJylwNTEYvUJIR2U/gxlHpoE/VoM9gxRfUeYRJXtR
	/ciLVTdGx4T3L2oWah+Sda8YKgjne5g9oarNU1L2w5/0f3/JxKDrisNtA23Fdo3jgkC0y0ztgrr
	hf2oadELE5TmWHQULvb131e3Klujh8kKo8ylq/GE4khTQZBQpRdknWj2PnoB7ptaPS2Y1WepXjA
	SKrgZcX1DqcXLEaMF97EiNnXJoyCiqquE/WS1ee0qsJUdieASIX/NYreA5U4gZ91RNF03jKM/bZ
	jTgrabVbm7Rtvgw7pD9cUZTI7Xgy6Vjb5At+i5iMSq+uhVTsv4t6vUwHomMFZJjihiBe7aiSbil
	4cWDDIXIFI7RM7gQli9md8ogOxuFWUpDnqU4eYp4Rxy6gF3aUjT6EL7NarxczR6TcTc4rKbVrX/
	6K0R7yWNkW8FwY3kSCaAO4ngJyGPukJRNOMqTKhZhDLZyKXDrI5g9U2d/GtBnv1Wzz4+sOGSUap
	9FTH4gzUo+ZDnadRV3wfMcwwaR1sYajmBSww1VFk1UVzGcfXiUCsQmtCDL8puwzxfIBX5tP+ByF
	hkA==
X-Received: by 2002:a05:701b:4584:b0:138:30b1:4c00 with SMTP id a92af1059eb24-1b543af0334mr2051555c88.3.1794991570825;
        Wed, 18 Nov 2026 00:46:10 -0800 (PST)
Received: from zypulse-in-radeon-MS-7E24.lan ([2406:da18:1601:7200:e02b:e41c:8db0:668d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447dc5e9sm7220671c88.11.2026.11.18.00.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 00:46:10 -0800 (PST)
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
Subject: [PATCH net 1/2] ipv4: accept nexthop dump attributes in route deletes
Date: Wed, 18 Nov 2026 16:45:09 +0800
Message-ID: <20261118084510.332821-2-zypulsecore@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261118084510.332821-1-zypulsecore@gmail.com>
References: <20261118084510.332821-1-zypulsecore@gmail.com>
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

ip route flush reuses route dump messages as RTM_DELROUTE requests.
With nexthop compatibility mode enabled, the dump includes RTA_NH_ID
alongside expanded nexthop attributes. rtm_to_fib_config() rejects the
combination with -EINVAL, leaving the routes installed.

Skip the mutual exclusion check for RTM_DELROUTE. fib_nh_match()
already uses the ID to match the nexthop when an ID is supplied, so
the expanded fields do not constrain that match. Keep the validation
for RTM_NEWROUTE and leave the other delete selectors intact.

The failure was reproduced while investigating the iproute2 flush
report below. An unmodified kernel and iproute2 reproduced it without
fault injection in a fresh network namespace with compatibility mode
enabled.

    ip link add d0 type dummy
    ip link set d0 up
    ip -4 nexthop add id 101 via 192.0.2.1 dev d0 onlink
    ip -4 route add 198.51.100.0/24 table 1111 nhid 101 metric 10
    ip -4 route flush table 1111 metric 10

Verified the flush and the existing new-route validation in QEMU/KVM.
The IPv4 compatibility selftest reproduced the failure on the base
kernel and passed with the fix. The IPv4 group and IPv6 compatibility
selftests also passed with the fix.

Codex assisted with isolating the IPv4 delete change, writing the
regression test and running the QEMU comparisons.

Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Link: https://lists.openwall.net/netdev/2026/10/26/186
Signed-off-by: Yuen Su <zypulsecore@gmail.com>
---
 net/ipv4/fib_frontend.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 8c123b1..6b012c8 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -868,7 +868,10 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		goto errout;
 	}
 
-	if (cfg->fc_nh_id) {
+	/* Dumps can include both a nexthop ID and compatibility attributes.
+	 * On deletion, fib_nh_match() uses the ID to match the nexthop.
+	 */
+	if (cfg->fc_nh_id && nlh->nlmsg_type != RTM_DELROUTE) {
 		if (cfg->fc_oif || cfg->fc_gw_family ||
 		    cfg->fc_encap || cfg->fc_mp) {
 			NL_SET_ERR_MSG(extack,
