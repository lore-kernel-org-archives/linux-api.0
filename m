Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795814407;
	b=hECAo1TdlDa61KTKi+wIP2Qzn8HOEd+APQpMjbtm8h3PVm28I96fkSXYOn8R8cP59u4U
	 U/uwu3wJZCz6LrTpowmKraXOhXjEdYWAPzmquJRED15ZKuqnllyQv8FYQXJuYCNgp52Sg
	 vCts+IIPiAsYXUhlJH/jauGvhcca7YHAfgwy7fIGCX/YHVpz1YhH0/pzRwWKI8X7veNf3
	 wXpvVqpnxwskMGhMxFBfYgwUJOWLSD41ahQMJ2NV2mduwJwQFV4zEFybgVmxOX5qXzRwl
	 wwTIfujzEd76vS9f0O18YPAzsqSw+G6ZGhYyDpBIrlb4+cF0dxeTLOL/cmqfenGMgyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795814407;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=KHHColduWGkmMFxFIDLQlFNb6NHf5yIkvDHac155u38=;
	b=u/NcQcK+/KhhXRvqUQ4hcmpbfcIIb0rlOgkcOkyt53YRN4Sj807zmPK03dCMDRM99x4p
	 NIEdAQlkAJDczGlL8lkOL8JmdnMBhtr5o8zFj9t1XIGzw9nkt5Rpw38HTDf3E4H2LWWs6
	 9Jd44119+4eDT6A9CmMXP4gD1MWkkZDInIArl6yTCGG93iKj6UkEkK+5uE/hBgITcF18V
	 LDF+wHzFQRtqVLDZVPSUxOgpCocgdCooiXwG7kIMRP200aTf3n+yBQj/j2v4cXjxoLy0y
	 a0s3msn4ENnyFWtBxaJwBoTvG4R5hRfTDTInyZnYWehdd3JFIWmlpA1DAf4oT4C7IoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0SeRFOYg;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5AF606A32D
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 21:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B5AF606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0SeRFOYg
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-38644aedba1so13216651eec.0
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 13:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795814406; x=1796419206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KHHColduWGkmMFxFIDLQlFNb6NHf5yIkvDHac155u38=;
        b=0SeRFOYgIHf0xKk845tY7Ew61fEgVRrey05t5afn/eNfocTuP4qrVuiOmmc2ZJGAzZ
         mXTtk35clO94Jdl8LcjIjc8Set0IgMoOSOQ71g/Guu/ST33xtd9QZSjHaecR/ykryOB4
         Sg0Sl0R6B0y2Uy/Jhq1zuTYDcluJXYizvqG6oLU3Bk7B+fmcQkDTioqhT40Y/TpzS01q
         VF8JKhpd7F9kbolfYzRwFE7kawAgrWcIqoXiBYHhKYStnqwgh7d8zF93WVfPk2qk0OmS
         VlYGYlxAWACfq4oGItMLrflh+mvmbsG7jcZiHL8OuDiAp7I/x3PrjnD5gtqWMdUUmawb
         s23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795814406; x=1796419206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KHHColduWGkmMFxFIDLQlFNb6NHf5yIkvDHac155u38=;
        b=svUuiYqgxRX7MIQ31G/znGynmGD4KU0L0Z4UWGi8/sUe21JA9Pw4zFIksGHNaHJj56
         Ci3zXOUCeIyxsaPVo8FqvkI5N9Gr8N13EJLaw8OfnxD3qKGw+COB8ZITM55f+Yyi/Toj
         s5p5XPk8qeegmD2cnleyLkvlEFB0295pKAW9nBT/cKg6ojJmAJMM468JV5sbOdaj+i8c
         ruj2wf3oBGZKYSbf4q3/+MuooEW6q9jiwY/cqnuJQSvEVAmZvlJBM/aUbAOiOW88hf+F
         5UpJ1zLnKing030mAsFihQGjWJum3WdzQwlLFTWjkqtjfZbqJpDZyfJhBgxrTUKwMXwZ
         HdUA==
X-Forwarded-Encrypted: i=1; AL+hErGA7RJe8TSNs/JRizjKvTezKBeIL+B7FnMUn0bmYuOyVDr9LDed/trAJ4DQJUL/tt3s1QZ01ujj84c=@vger.kernel.org
X-Gm-Message-State: APuU4Z9UL5cBvxS6zGt5pdeJEXJOkB3TlXzUCuyZASeH+l+h0qXIR6iZ
	TPhMn0MADnkkTTxvv+WJa7sLP5NRormeOWxjT06LYZ86JS8OLiK32LWq
X-Gm-Gg: AZFdTZetAEJ1jp77IpApIs/cRF5fUDRgdoBR2Z/Eqd/wAQUOtqBYMiQU6Vpe48oXU7M
	/CkXtXfRFAtcuc838eKVd8arZFSntgFqUH/5GYAoQCJNWP0ggty0f1hz1U10349PB0xAMcf6exA
	J2bx62b0tuHCyvJpVUtsC89YrY4f06oKZ9EB6J1dB+1QeMR8S8ww5MsKIXjvDG2fiQCN/lecjXW
	uXG8s66H47w7UtL/uPAIJ+ogvCyDdZzO6A8oVFISAj4YU6pLO+F0Sg8/ERX9vCnG9QXIK7AhZTr
	mJrPl3q+QJBDlqN4O3yqsZOvcb7w+P/lZ5TbdslhWU+t0vRaGfbRqpIpKQ/J2EPsFByws5VUpUN
	u6ugu3Zm122slunG17KqDLbLzBxopoFQSicuYYHpqfmQvgi4Ur1fl5SnUo6eZCYXCJeE3VLUeZj
	fxTJG9H6gLgj4fjNERVNte5LQSEoEkgC1bAI/9FJPWbggObzm/70xgn86vsj44JKPIZ9+sO1WsM
	/P12KET4xqsZZrngy1Am4PKyudHBvMsnOPldi5bzlolsxrI9vm0hNlEUUhMaxz6LNx+C09UGEBE
	m96Pf2hlTMN334/E72ZV2IwNay3qMEez2SC29PUvD+VHtb0Llc8/BQQIuLMtXWbbasf1ZkmAoEh
	NCBHJBNGTA/p5M4UYxfZhNkeKOgcs+QVZs3G+a87ziaVqIoUDiFWGyL4Maq3n941TsPH01MRF7l
	C2UtL79Waa5Bwvi5eoPbUDMJD6Ab5wtqVCejpaFI4rlMaAGcis/B8uWcxLgSAy1xf7sDro3QU4q
	M/CPJV1ngHd6Hlpz/ADL68DIV+q0netDeFbitJl10eOUT6ZSXEMaZgkbybhqUjTeuXJEl8cmATQ
	lIwQGhVflQf1X3s2QQ==
X-Received: by 2002:a05:693c:88d4:20b0:386:a8de:2bfc with SMTP id 5a478bee46e88-386a8de2f67mr17929616eec.6.1795814406495;
        Fri, 27 Nov 2026 13:20:06 -0800 (PST)
Received: from localhost.localdomain ([2600:1700:5390:dae0:7063:f08:2b4a:6d9a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385672c6f31sm73804236eec.15.2026.11.27.13.20.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 27 Nov 2026 13:20:05 -0800 (PST)
From: Artem Andreenko <miolini@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,
	Artem Andreenko <miolini@gmail.com>,
	linux-api@vger.kernel.org
Subject: [RFC PATCH 2/2] io_uring: add CLOCK_TAI support for waits and timeouts
Date: Fri, 27 Nov 2026 13:20:04 -0800
Message-ID: <20261127212001.18516-6-miolini@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261127212001.18516-4-miolini@gmail.com>
References: <20261127212001.18516-4-miolini@gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3022; i=miolini@gmail.com; h=from:subject; bh=yvTfJypiHdmknicGUP3Np55BO5/vKeWwpJXIdb7AeSg=; b=owJ4nJvAy8zAJebzwOiZnvnNTMbTakkM2ZxfmN56ORi3bbI+d5U/eGm7dcLJhpcZl6ZmpLDv3 bfw753NmQkdE1kYxLgYLMUUWRpb56/Vv//ZO6bEzRZmDisTyBBpkQYGIGBh4MtNzCs10jHSM9U2 1DM00jHQMWbg4hSAqd68gpHh34aXrUmP9mwXWTVhi/nNj66M/495rPNo6194U/WS7243K0aG3vP se07P85cMMrlx4Brfk888Spt+aRW+f227aI7b7O93WAAa4VOG
X-Developer-Key: i=miolini@gmail.com; a=openpgp; fpr=81859FAD2FDFF34B5C74463D4CE032E62E37D969
Content-Transfer-Encoding: 8bit

Time-sensitive workloads such as 5G NR gNodeB DU/CU radio-slot loops,
O-RAN 7.2x fronthaul, and TSN applications schedule periodic activations
and packet launchtimes on PTP-synchronized CLOCK_TAI rather than
CLOCK_MONOTONIC (which drifts relative to GNSS/PTP grandmasters).

Allow CLOCK_TAI in IORING_REGISTER_CLOCK (via ktime_get_clocktai() and
HRTIMER_BASE_TAI) and add IORING_TIMEOUT_TAI (bit 8) to
IORING_TIMEOUT_CLOCK_MASK so IORING_OP_TIMEOUT and
IORING_OP_LINK_TIMEOUT can arm CLOCK_TAI deadlines directly.

Tested on arm64 QEMU with PROVE_LOCKING and DEBUG_ATOMIC_SLEEP after
setting a 37-second ADJ_TAI offset, verifying IORING_REGISTER_CLOCK,
future and already-expired absolute io_uring_enter waits,
IORING_OP_TIMEOUT with IORING_TIMEOUT_TAI, and conflicting clock-flag
rejection.

Signed-off-by: Artem Andreenko <miolini@gmail.com>
---
 include/uapi/linux/io_uring.h | 5 ++++-
 io_uring/io_uring.h           | 2 ++
 io_uring/register.c           | 1 +
 io_uring/timeout.c            | 2 ++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cf1afd11b..af86553b3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -357,7 +357,10 @@ enum io_uring_op {
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_MULTISHOT	(1U << 6)
 #define IORING_TIMEOUT_IMMEDIATE_ARG	(1U << 7)
-#define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
+#define IORING_TIMEOUT_TAI		(1U << 8)
+#define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | \
+					 IORING_TIMEOUT_REALTIME | \
+					 IORING_TIMEOUT_TAI)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
  * sqe->splice_flags
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b2808222e..b8c2bee11 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -584,6 +584,8 @@ static inline ktime_t io_get_time(clockid_t clockid)
 	switch (clockid) {
 	case CLOCK_BOOTTIME:
 		return ktime_get_boottime();
+	case CLOCK_TAI:
+		return ktime_get_clocktai();
 	default:
 		return ktime_get();
 	}
diff --git a/io_uring/register.c b/io_uring/register.c
index 802cfd6a9..38495369f 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -453,6 +453,7 @@ static int io_register_clock(struct io_ring_ctx *ctx,
 	switch (reg.clockid) {
 	case CLOCK_MONOTONIC:
 	case CLOCK_BOOTTIME:
+	case CLOCK_TAI:
 		break;
 	default:
 		return -EINVAL;
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index db78059cf..43a6afd6d 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -43,6 +43,8 @@ static clockid_t io_flags_to_clock(unsigned flags)
 		return CLOCK_BOOTTIME;
 	case IORING_TIMEOUT_REALTIME:
 		return CLOCK_REALTIME;
+	case IORING_TIMEOUT_TAI:
+		return CLOCK_TAI;
 	default:
 		/* can't happen, vetted at prep time */
 		WARN_ON_ONCE(1);
-- 
2.54.0 (Apple Git-157)

