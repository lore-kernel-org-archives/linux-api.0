Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794731153;
	b=r+3zEKnDSo2TbElnm2JCiGwz7oC9R65ZbgJtSrEg8aphH/4UPsKsnrctsmgiVHehhcSX
	 ERTz7O//7vcwRzQlKibn5JeGdUYis7fq/Y555CwzX5Hnkv2v0tS6hMZO5aBuFfwUYJgrF
	 aBVYOr67XriqtdAWh8qub+FYfUCOJ6/5Hx+0GYcBw8cwZrvckWVeIYlllxy+8vJpfn1ce
	 6PvIvZuM8ZtRyk3X3uYUYOo1kpP1Nag5gAFBunAVS2PuKcuRLtnjDlr4pzImgaPXbpBKd
	 kVkfpr6Q6j+eWgNsEj3XyFbOuLRb6gP27yQgbH0OIN6lclfjJbQkM4WZCqxFHhL0SFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794731153;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=am2oq3K7voWtidL8P/wiusHrC9cFOyMvuO2qYCBRnSI=;
	b=hknjt0xGs6uE6qdcaK2CQraozPWuh/KC5PRaX7htuhd8oGC/ymBThM9mSXV6hrwYweWL
	 RCn9Hlq5zYoAP1T2B0MU2wifDRDMZHAGJj+AP9ZEAZOCNojdYI4fp3Q9qy3Ca/jZ9i2r5
	 7OJCbF9uxoRqob4WkwZ7KcafDy538lb4cuiy5Ajs8JYDiGz87atn7Kw1k5xw2O2p2cTn9
	 jE9DmgmAUoQiGXCZhgOAU5qH3N9Xs913kRPhHtN8erniuQHgIT64Ej/F28wbRCQhgRswJ
	 tLqepI2Fgo0QO8IDe6kxXYePgLKgaGEMEtEMKys0bTFwH/If/2t9zeMDLyMUMmAOVfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=wzZ2owGe;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF122606A31A;
	Sun, 15 Nov 2026 08:25:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF122606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=wzZ2owGe
Received: from eipi10.cs.unibo.it (host0.studiodavoli.it [109.234.61.1])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id 88BC91C024A;
	Sun, 15 Nov 2026 09:25:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794731149;
	bh=hrHmOxbTSAB7Y9Jg4qV0thUknR1ape12zJwbVMAYLNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzZ2owGeAGzrsmcDGxaGesBza5yjzR3NGtOr6zZkcCtwXYyQEi2OxS+lfKM64Df8+
	 UvsklVCdnvEtLdqJLXiHag1rH66bXYeMGuvr8KVqiTh8lWfqs1xsNwB5AoY8Hy/YJQ
	 Ay4ndTp5k8NDP3RcKNKuBEZzw6PK4XcdhDUPXY5g=
From: Renzo Davoli <renzo@cs.unibo.it>
To: linux-kernel@vger.kernel.org
Cc: Renzo Davoli <renzo@cs.unibo.it>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Dmitry V . Levin" <ldv@strace.io>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	strace-devel@lists.strace.io,
	linux-api@vger.kernel.org,
	Bradley Morgan <bradley.morgan@linux.dev>
Subject: [PATCH v2] ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
Date: Sun, 15 Nov 2026 09:25:39 +0100
Message-ID: <20261115082540.385386-1-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <2D2A202C-35F8-4200-9110-B0E636216FCF@linux.dev>
References: <2D2A202C-35F8-4200-9110-B0E636216FCF@linux.dev>
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

With is_error set, PTRACE_SET_SYSCALL_INFO passes info.exit.rval to
syscall_set_return_value() as an "int" error without checking it: a
positive value, or on 64-bit one outside the "int" range, turns the
error into a success or is truncated.

Reject with -ERANGE any error value outside [-MAX_ERRNO, -1].

Fixes: 26bb32768fe6 ("ptrace: introduce PTRACE_SET_SYSCALL_INFO request")
Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
v2: shorter commit message and comment, dropped Assisted-by (Bradley Morgan)
v1: https://lore.kernel.org/lkml/20261114184842.373304-1-renzo@cs.unibo.it/

Tested on x86_64: rval 0, 1, 3, -4096, INT_MIN and 0x100000000 with
is_error set are now rejected with -ERANGE; -ESRCH and -4095 still work.

 kernel/ptrace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 3f2fe68ccb14..1ffacfcef8d4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1111,6 +1111,10 @@ ptrace_set_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
 	if (rval != info->exit.rval)
 		return -ERANGE;
 
+	/* An error must be a negative errno value. */
+	if (info->exit.is_error && (rval < -MAX_ERRNO || rval >= 0))
+		return -ERANGE;
+
 	if (info->exit.is_error)
 		syscall_set_return_value(child, regs, rval, 0);
 	else

base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
-- 
2.47.3

