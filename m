Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763896;
	b=jtlWwmX6F608EBRSfOrwVn6j27SiLPvTwt4CYbxyEmQWSOCYIKO92k5fVLXffazQOo4A
	 lHC1X/oq+cgFvSN0OJwDGjAWeEH6T8syh+4HCE3KtqtmJ+UtWGNzRH6rvxqnHoSIwbYag
	 2nqLQS3QVOQHXq+g6hwbPJ2aWtRxFHYEX7FPkqS9twjq+z/oHl+xzOpKXjEGK2YJ5lSI9
	 7M+wJsygFVgc9Yw315j9FcBVg0CRUbMMP+Ibjj35k39qI+zDc3sdb3iqAXwcy//u1Okd4
	 F4YonAbxR6ZjA0agsWE5i1VyQFQNdFl6L4f/8SUmsEgBn0dNBh8uA7VaC618rQ4C4+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763896;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=C3bbnymH/AHGYpcpFk8/j247A/7fyrb+hVFtH4yEx/A=;
	b=UEoArF0sjfUnnQt9oiy5c3CV0hKKU8e9/5ehErpJ6PkCePHQaUz+sVHJanwjc4NegJq/
	 6p4Z1Ro8FZ35B2ha1fydsZOmnqDv0CGYVsvCYook8NI4Mm1gqY/g44Yzv2wGaECwmzeKE
	 LadrdCsj9QaHuVGT8nIe7SHuqtReE+VJ23ziWxGWEefKJNpjj++QAp6OXfi+V9bQqE20i
	 JWok8w1AxX5KRZBC2Quq2YwU1Nq0H6Sc+M9OrMzM54eRcblx5ecyoe0gQ4Mol17HdQeBy
	 x7L8k+959qrl5ifg3XHdkphyVDrB/7GfG/H4k520xPx/qwvhMXAEECg/YX6Y6Nw2L3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=Ik1pJb2Z;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32063606A31E;
	Sun, 15 Nov 2026 17:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32063606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=Ik1pJb2Z
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=C3bbnymH/AHGYpcpFk8/j247A/7fyrb+hVFtH4yEx/A=; t=1794763894; x=2110123894; 
	b=Ik1pJb2ZpTJXEQP5eyihMUnDflRc+OsmYCdTZsrd7V42iVix5XveYf+RFeul7LCQksHBzbmpXXl
	dhc9m/Qt1EHRSoX7ytrDc5rskvKXAqLuev9ZkGVyYA5t4TOUdEbr+aPCCAvHkwPHi21dG9fm9RtqN
	vc6cn6MpKns7mliuhNCS5d7a/cx3OlNY8GvsCmeOvwFLc+nBKJlTP+H2ggseEvKEFmOo3dmXoT0E8
	zW0dp5+4LzCe3sGXWzLScP75UeCYFfT2zRuLXYyvyjy0dhriN7l1BkCuCDmttRkXZYxpyQMR8e3MO
	x0RuPKizhEFBHsUPtLEcACgUvgDG1rF7xDXg==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4U-00B0BK-0I; Sun, 15 Nov 2026 18:31:18 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 15 Nov 2026 14:31:10 -0300
Subject: [PATCH v8 01/10] futex: Skip test_futex_robust_unlock() if not
 supported
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261115-tonyk-robust_futex-v8-1-a4fe47333a28@igalia.com>
References: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
In-Reply-To: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Waiman Long <longman@redhat.com>, Ryan Houdek <Sonicadvance1@gmail.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-api@vger.kernel.org, kernel-dev@igalia.com, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Skip test_futex_robust_unlock() if FUTEX_ROBUST_UNLOCK operation is not
supported.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 tools/testing/selftests/futex/functional/robust_list.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/futex/functional/robust_list.c b/tools/testing/selftests/futex/functional/robust_list.c
index 87217c549361..ddb610149857 100644
--- a/tools/testing/selftests/futex/functional/robust_list.c
+++ b/tools/testing/selftests/futex/functional/robust_list.c
@@ -792,6 +792,9 @@ TEST_F(futex_op, test_futex_robust_unlock)
 	ret = sys_futex_robust_unlock(futex, FUTEX_ROBUST_UNLOCK | variant->op, tid,
 				      &head.list_op_pending, variant->val3);
 
+	if (ret == -1 && errno == ENOSYS)
+		SKIP(return, "No support for FUTEX_ROBUST_UNLOCK");
+
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(*futex, 0);
 

-- 
2.56.1

