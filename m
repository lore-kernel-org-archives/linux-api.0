Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991576;
	b=weAeH2YrkL47Cr7soLQ0BoSPbwl6+WB6Fzz1llqBfv/IB//XcZOKYMAUYoHB+ri+fST1
	 Dwbx5/E5/EB1qUh7fo8KKOt3/uC8C59/oImvCGmhCvpcNIK0JdWcqpMsqaj/HaVCdJ+fc
	 j1OfkU6VOGNyByIfRZFgG+NCerP2maFJZqIJdrOTMO1xA8sCRLcUX1IcL2BZTskmv3oHy
	 YdUqzYm4MOyicswDQCbM6w3gSFY0Advl3hua77UpU/LlwqhKsULljF88cr+TSpawVsoMk
	 RQHxj54mpP1Ht1U5k2gI3XzTFMenwG2Zt3YDx+oUgvud+YKeZLpLM9JMjI5WNWrbYKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991576;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pxkuXdERaykwMOPQlF5CucoOr0fRF5ezQY9VTtl8AFo=;
	b=eUPeZhHLev4zZ3UNcGjhXL3GtI9oYGTIVWwT1XsIzzzuaMaui0vk+4k8fPQhQ0AUi2pg
	 FqdycZLAMH+CQ4Wf4EB6cPWe4cduSP+b2QCeH05nvQtXymuRG/8S5tj03UrkAifusqX5s
	 bkf2G29vVO1Y0kAQVcPj3XO/nJi7saXAKB3oNzlWH39rMLw6bMoOXuR4JDyQEGqyDyXDi
	 qhDAQ3mlbRGDRK6bmGsW+vdKMs6MfDBcROjvOuNgOmkTtREOzpGnukqzcJ76BH4k36MmM
	 vhd6Po7qayOnjwBWV3CpGUjJ9JNSpxFo3Hi4maj0Z3JO+ttjGBMINczQcJ5P/5E4izw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZpVGaUt0;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E359606A32C
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 08:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E359606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZpVGaUt0
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15ea896ddc8so1339090c88.0
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 00:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794991576; x=1795596376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pxkuXdERaykwMOPQlF5CucoOr0fRF5ezQY9VTtl8AFo=;
        b=ZpVGaUt0qFX+fY8g64e6lfSZ6qDUG93vsf8J1YDKaJ//YYszq+CA7ztgrzDEG9cOt1
         WvUtFbMadc7JV+Vfz7dMqS3VNrppTwPCAfMUqjXCRMf+Xmzn/cA3k1VV6wDRtIFUoHHe
         5C8eDEEk4jKPUr5tDtaRFkBWw320hZjP2fePVtOA3YI1cmnu+KUOcpvS33oV+ermFd+W
         ZopHhKSa8ddS5XUHTfsLuTMs5bAhUqttDM1zqstvA9RmVI5BHbvs/O8JWrwxbOIcN7CD
         JiBGRmgNg7lblyYyO4QFX6Ozuq4O8JFPXGKHT6HM+hy0rII/NvC0J0NskiVWESPU9VgR
         BQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794991576; x=1795596376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pxkuXdERaykwMOPQlF5CucoOr0fRF5ezQY9VTtl8AFo=;
        b=hBOgpfuBYl0FgXz9pSnItGpBrLJaaPKs+t8Qi9BSVSG8c4GcfEiGChVMvetmkgbZTG
         3UeJ3+R8GufK9DMjgXdOAJRVtdB62FvhFK5s1E9i4BHKgkCpJc72m5ufLZRoGNM3HGx8
         869SXpAJvF1Bb3uknG5LMw4vocQShwBJEfZqyXQe+6thHLDJmRoYR1DU9J0HoAbVjkQm
         PJ2GOzgWYffy1YNHpg7dB99kZ3ci+cqOzrfyJwYb6CQ3q6Mf+zxbYhvG/LVg4+ksTVrm
         qLauefsAvoXb5AjFYWtpMUWgo45ctKSMXXpRxI9Aolw3SsijKvsH6o+LEYUQz1z/1SQ+
         K+lQ==
X-Forwarded-Encrypted: i=1; AL+hErFdvvqvUec/EGjIWL9+GJ8eS2v2ZO53+8f+FPIRw9f/8pOZJbwl2skGsHP847nlz4F7fmvYn6YjHzc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9oHq2PYZRmh5IZh7dd4EjiwttZGJXDaGG4Y+EdNbAEhvKxGaN3
	DZMVtiG69eoi7mhRaRl+QAKuOq34/8OfjYe/iyLDwrQQT0/uGI71XH4u
X-Gm-Gg: AYBFou3VjUPkAzZ6c0wNtJPPHNbRzcaHIzmQBeJVu9+ygae+bvTEqomH00/SWIuNkYj
	v7bTRYIU8u5aBtg6EWuPiDPTO603XcgWkfPLkEmRvu/tzzsJZp1Hz5pvY+8SQ3CiPBT8IbgosIC
	ts0VdAqrw0vBj9/iUSpJPXTOF1R4faaCGCOnZD8DPU1iJw8I4VwG2g4MloRfjgYPHlvRyrVBadt
	F83LWGBEOkd0ysM6SomTncWFkRobhBhHl1lDoGExG4lVLmTPvisQ9WAAgq9TF4/69gxpB/HONuL
	w+Z1kFGn1BdYs/4LF+XaXblm3Gex9bhNsuw16pa4r2cxx7iGsuENn3lOvWBIzR+p1hv1zig6qVx
	ZP36nJ2zQoXYdvqvT9w/JtpCXaV953WQdykAVw1TSW7pGdX+JfIkmGZPR2yEno2XydF3Fm4TqXa
	MJNRxWeeF8VFA0dbaIYX12wc5Nordy1aENkuV3OpNnsTB6c3ne7kVa3yxNCm+VkbV0N7i6Drgxd
	yiy1Lswt7ewgHNPQj3FtwNhuRrvORVESX71SRKdZoISglbnTU8bTF3npYbTyJb+XFquIBq5KXgJ
	8QMKPWY+gL5fcNchV847O9VzsRZfighobPWqh4Jp9UMLduoVTw7BTQe2
X-Received: by 2002:a05:701b:4649:b0:144:fa57:c617 with SMTP id a92af1059eb24-1b543d32afemr1728596c88.34.1794991575630;
        Wed, 18 Nov 2026 00:46:15 -0800 (PST)
Received: from zypulse-in-radeon-MS-7E24.lan ([2406:da18:1601:7200:e02b:e41c:8db0:668d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447dc5e9sm7220671c88.11.2026.11.18.00.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 00:46:15 -0800 (PST)
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
Subject: [PATCH net 2/2] selftests: net: test flushing IPv4 nexthop routes in compat mode
Date: Wed, 18 Nov 2026 16:45:10 +0800
Message-ID: <20261118084510.332821-3-zypulsecore@gmail.com>
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

Exercise ip route flush on a route with a nexthop group while the dump
includes both the group's ID and the expanded paths. Check that the
flush succeeds and that the route is gone.

Both checks fail before the IPv4 delete fix and pass after it in a
QEMU/KVM guest with unmodified iproute2. Codex assisted with adding
the case to the existing compatibility selftest and running it.

Signed-off-by: Yuen Su <zypulsecore@gmail.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index adbec51..d3c8cf8 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -2183,6 +2183,13 @@ ipv4_compat_mode()
 	stop_ip_monitor $ipmout 3
 	log_test $? 0 "IPv4 compat mode on - nexthop change"
 
+	run_cmd "$IP route add 192.0.2.1/32 nhid 122"
+	log_test $? 0 "IPv4 compat mode on - add route for flush"
+	run_cmd "$IP route flush to exact 192.0.2.1/32"
+	log_test $? 0 "IPv4 compat mode on - route flush"
+	check_route "192.0.2.1" ""
+	log_test $? 0 "IPv4 compat mode on - route removed by flush"
+
 	sysctl_nexthop_compat_mode_set 0 "IPv4"
 
 	# cleanup
