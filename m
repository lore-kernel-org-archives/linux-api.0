Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795814405;
	b=ZlqR8srZU9CQIIIkC65WJNv2zRhWv5XpYZDl3ksWyooc2FCiezLvSKNjIOjVcjlR+eOF
	 X1gFVNABmDWOoT1SPfu5uYL9YXwvH5KMO3SQi2Sbh7TFOgBTOAPPErl9WDlkocfl4Us07
	 pAeLjjSDsMwqtIBs2su/Ccd0DSeXo6m71Lvg9qSy8UGR0yEvucu+Z87hb2YA5w6BK6QB/
	 0CHWN5937IQEt1YRM6i/tm1YGjILGpZMwSVfoundBQRv75kFqgUs2pTtFKBYSAbrns2+W
	 es3MnhQ3/hVuH1gee2CGcBDSO7WDGPJBY+JFDOzxY/rpng42F9aBrAXeTG3AeOuZX3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795814405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=1L+JG2vdUpgp0JPqj2FHTVN4G8BfYs3SYaKUQy5dZWM=;
	b=S0zWDe9G1WOmXM2RY7ho01XY3T+K29nUGhx6tL8TjvCNGPPQN5+qj8CUSnGk5HEPAa+C
	 Gw07K8/HY9/tm4HZhs6NNgQGFZyxILyNY1qTM2Cw2IZtbC8NvykmI+Hk6Pkvaqe75ELP6
	 NGrdTPx//lzgszkqEUUtaY+0rHCVAIncZsg+frZy8uvH76wphFBVB+tPX4DyGGFBbPfcX
	 DnmbfhxPi6ftOG0IXm9E4KlntNSPkZelpEzQ4qUE3zBvlMFMIYb8ae9kqz+XDTQzkjsIf
	 DsOfmsuEM7iKtjTDxrOspIXZ+hzGZus9DdA6ia75o3UsgmYwsnorspUWJ98vA1AHzHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0hY7ceyl;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7B4606A31E
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 21:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD7B4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0hY7ceyl
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-385c497bf94so8917002eec.1
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 13:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795814404; x=1796419204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1L+JG2vdUpgp0JPqj2FHTVN4G8BfYs3SYaKUQy5dZWM=;
        b=0hY7ceyl1k+6gG5NoRMuyJa5XY8JIWyC5XzIlibVt/9sSjFx1iaDnif1zvh+LEp2cl
         XqYhrW6hs3xMl9UG4ezqJAqkJnsGDjvrBKBKG9KGKDbwlnha8AN4UVCOS5bM2essWJGV
         YLFV3QG1oDq7qU/gOILaWeywAg+Q3oODeK6xatjJVpHGvmr2XBo/cZJZbBEPB98dcmov
         UXicMtWrhFeRfURwU2+zaAp5dRw3PwK/8aGA4a81E9SgtpbvOglFFgH8cik55w+K6ULw
         kEdYakIK2mIcbbN16BRqFFyczoC65wAjRh7gd9orDPp8fFoULPj3xEr66juGaUd594gb
         tQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795814404; x=1796419204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1L+JG2vdUpgp0JPqj2FHTVN4G8BfYs3SYaKUQy5dZWM=;
        b=mPEPlp5/CCNtg7zz0FClSXETg7RoaHWeip94v/PQa+7oMkoGNTEQ5pxEyW/9urA/Uy
         5SToFM9YPMNGD5zW4i/kdNaEfeNaMyt5KnLvoDchpXPSKQPlgqROyMRYQ/1mNYDMfzVz
         UMGbZeFJKAtn4XwRIl8vMjSl5IenOG3OpbSebP8vPS0Ol5KI8wQjjmJLlhlOeWYs/0gF
         m8l9S/wdPwzxob6J3QgEKFPiM87ShxxqGdfs5dC8TNvDAq26N+4XJJRJrcKMSCeAkSMn
         BsIMMwNZedeZqlLTgwHVSQIZEta/c3oCs7u2pfdxkYtk4IKKEwMP3NjvQsxLv6Oiogyt
         M4XQ==
X-Forwarded-Encrypted: i=1; AL+hErHqrb9MxhhwxvdV8PGugINZMsb2wKjP2deu+0bYFJTaWDnDnWzAdFUbJO4vNkra2cQptOXkCtfMT3I=@vger.kernel.org
X-Gm-Message-State: APuU4Z/y05NY1sOXNgDJzq97s/kxX4X0kKlB+VxbA1Ersea7M19JeEln
	+5EDJnQbK0b0rPeOb7trtWcS3SFzad3cHiz/HUxpdYSA2Zl0cChRxfk2
X-Gm-Gg: AZFdTZfQqEy9lFf9gtm7AfVzM0VC6+t/omjwh2mmldXfh2x4++kKNEG1rYxT7OpDEfM
	ZYvp/7R6Z5+upSRWGceuJ+YNnLzu6wQ22KUHM65B7tw8iSiYNJvUGNgZUfqY7FbozNbV3TsvB7j
	qaV2HCkwhrurUrGT6EiFOMO2rE24suV5KfEBSLgj8X2anxdzMAIQQUm9usrWAZ+OH70sDuu74nY
	GOvM0qJ6rg0VF7afGjMKAt2sKDDVEHiVw6xWdet7sgaBTpCNiNr957Zkw1ALo1AC/OyfJPegWqA
	3bnlaSZBKXhgEQtHqHXHh+G+59aIkNkdiBlYU91+nFuCVzekSG8ChToWMnMjRDkUhkB29n9pyi2
	c9HlpXWP/L40cbTHKNSNh2t9MPL2cKwqCiPjtjkgXLrsQVhRoEGZnNFRlTRchnk0uFu3zw5rBi3
	Vx7Q/xYSmlHh9i0I3bHcEzK1YJ1SDOtkY+dZh1i8HqWtS3CKe2JOJR8p5FpXxBcWqJSApqFQLxP
	0GiXhOpgR/eL0MYkmb2goSSNXXEzeQ0UHB/K2KQt2z622ooVdYVRPfh04bHLoGd8CkkShAABOom
	v7Xz933mwom6Ww/7cqan89+RHo8eVg92vCHj/38W+D7+nUVxqxY3k7B4t8mYek8qQ5l7UNpcvrK
	vslLmJjCo3h9QV9rPNHHH96WsDfHoU8SqZbHkr/KggwceuFHcY3H12i6mMaEGRkAdJm7FNJyoah
	0+b/Wdxncyq3kfUcDXSNwue4kfb9mmH/gsd4A9TTT7uT71Fhu4CBBKl2koogS3grXtC4cBlCs5I
	c4me77YQHI75zKlhV3b/i/YSx4V5MNToV1XiYUtakUkoNt6Xb9kmXODs4QgZrhRtsj+rz6oeyUw
	UVWGxLUM23Vc3O+u/A==
X-Received: by 2002:a05:7300:1899:b0:386:b6e2:9fa1 with SMTP id 5a478bee46e88-386b6e2a02fmr22240514eec.34.1795814403841;
        Fri, 27 Nov 2026 13:20:03 -0800 (PST)
Received: from localhost.localdomain ([2600:1700:5390:dae0:7063:f08:2b4a:6d9a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385672c6f31sm73804236eec.15.2026.11.27.13.20.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 27 Nov 2026 13:20:03 -0800 (PST)
From: Artem Andreenko <miolini@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,
	Artem Andreenko <miolini@gmail.com>,
	linux-api@vger.kernel.org
Subject: [RFC PATCH 0/2] io_uring: add CLOCK_TAI support for waits and timeouts
Date: Fri, 27 Nov 2026 13:20:02 -0800
Message-ID: <20261127212001.18516-4-miolini@gmail.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2163; i=miolini@gmail.com; h=from:subject; bh=XKWCeqAmuD+zCiWGJnq/gtjNw3U99tOn+x2J75zIfjE=; b=owJ4nJvAy8zAJebzwOiZnvnNTMbTakkM2ZxfGNXVi4wfvVZxqv/GkLte9MbxT18WyjwX7p5d+ e/BhfPHPG53TGBhEONisBRTZGlsnb9W//5n75gSN1uYOaxMIEOkRRoYgICFgS83Ma/USMdIz1Tb UM/QSMdAx5iBi1MAprpWmOHHcv28Vt2527eezrAtuq144dSfnl3st80/s3+tu7pnb95FRoYzzGf 8C/QiTT7YRyp+nnH0VmWknmPQQ5nb7l/NdaqeHuMCAAY1UgM=
X-Developer-Key: i=miolini@gmail.com; a=openpgp; fpr=81859FAD2FDFF34B5C74463D4CE032E62E37D969
Content-Transfer-Encoding: 8bit

This series adds CLOCK_TAI support to io_uring for both
IORING_REGISTER_CLOCK (ring wait timers) and IORING_OP_TIMEOUT /
IORING_OP_LINK_TIMEOUT (via IORING_TIMEOUT_TAI).

5G NR gNodeB DU/CU radio-slot loops, O-RAN 7.2x fronthaul, and TSN
workloads anchor periodic activations and TX deadlines to PTP-steered
CLOCK_TAI (matching SO_TXTIME, sch_etf, and bpf_ktime_get_tai_ns()).
Adding CLOCK_TAI directly to io_uring avoids per-slot userspace clock
conversion or separate timerfd(CLOCK_TAI) syscalls.

Patch 1/2 removes the redundant ctx->clock_offset field (deriving the
timekeeper offset from ctx->clockid) and snapshots iowq.clockid once per
io_cqring_wait() cycle, fixing a pre-existing data race between
IORING_REGISTER_CLOCK and lockless waiters (which becomes severe once
CLOCK_TAI and CLOCK_MONOTONIC differ by ~56 years).

Patch 2/2 enables CLOCK_TAI in IORING_REGISTER_CLOCK and adds
IORING_TIMEOUT_TAI (bit 8) to IORING_TIMEOUT_CLOCK_MASK.

Tool-assisted content note (per Documentation/process/generated-content.rst):
An AI coding assistant (Google Antigravity / Gemini) assisted with source
analysis, drafting the patches/changelogs, and writing the standalone
arm64 QEMU test harness. Both patches were built with W=1 and runtime-tested
on arm64 QEMU with PROVE_LOCKING, DEBUG_ATOMIC_SLEEP, and a 37-second
ADJ_TAI offset.

Open question for RFC feedback:
Should IORING_REGISTER_CLOCK(CLOCK_TAI) and IORING_TIMEOUT_TAI be split
into separate patches or kept together as in Patch 2/2?

Artem Andreenko (2):
  io_uring: snapshot clockid per wait and drop clock_offset
  io_uring: add CLOCK_TAI support for waits and timeouts

 include/linux/io_uring_types.h |  1 -
 include/uapi/linux/io_uring.h  |  5 ++++-
 io_uring/io_uring.c            |  1 -
 io_uring/io_uring.h            | 13 +++++++++----
 io_uring/napi.c                |  3 ++-
 io_uring/register.c            |  6 ++----
 io_uring/timeout.c             |  2 ++
 io_uring/wait.c                |  9 +++++----
 8 files changed, 24 insertions(+), 16 deletions(-)


base-commit: 822ba3a89c7896b26e4beb70e2ebffb881924dfe
-- 
2.54.0 (Apple Git-157)

