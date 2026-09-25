Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0793BA22C;
	Fri, 25 Sep 2026 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358826; cv=none; b=i6+vovFyOSdBcOVLDPwfHF+IRirnzfoWQlt5w08dajEvZQOj0C7+n49/W0gPvrh5JfU6n8RU9FSfL5fvNE3DHxuCgZnXYDczRNQxbNxLEoj1Dr4qHevnkQIP7Z8ZIWnR3tBsG2CGEjnVUZUyGv7O9L50YOQyTWAqwf3AAW8PqNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358826; c=relaxed/simple;
	bh=JII5ww0zyMXtFUHlYiH45ZYZP1ybkjciByz2YEted/E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VB3R3+y+jp45LTN76RjK5X8kEcgloL5R9H1ZbrAgqC2Ijgx38H/3nwtSY7L/4zodDL7UbPZUbi8e53DomjsV/R+TEqIXdjdmAeAr6daYfI887hxw0UEPGQ4J5KVTCWQCIOLjKTjX7eqW2IifL3XHMUFKyRpMMfrBDKfe+QaLdME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=VbKhnQLJ; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="VbKhnQLJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=d719y6n0vZmTUGtro2ttRMd9wPuk2PwhmZ1VS9tuoac=; b=VbKhnQLJ9wEaLHEsB5eI0QeUw1
	umqI87m0F4xMbQMu6lCL+LD+n5w6Nwy97kMSw2nXsOHhFggKPTQCcmKvQkEnalW+iLzgjR8Q7n6T8
	3V8LGy4i+OQCZ1lyXJLx7J1Q7H8e7Pp583HI4AN+L+zvBPfOqazxL6W+eUtigkAVOcdbpXSY8DLWq
	afxs6o6OWEzjZW9xC6oaoaa9pq9l2LhBUEkZok0ouqGIgyNdoyEKBPdJ5pYtagvrN+W5UnUaTd56A
	YpVm2bIVdkI0PnW3f/JzwranugFKSF6NCm7lpb+ccbccfIQID5qc0EXsqTuDV2HbjfL1VY4/0s90A
	F8HyhiHw==;
Received: from [177.172.123.214] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAA77-007GQg-Aw; Fri, 25 Sep 2026 19:53:37 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 25 Sep 2026 14:53:24 -0300
Subject: [PATCH v7 01/10] futex: Skip test_futex_robust_unlock() if not
 supported
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260925-tonyk-robust_futex-v7-1-d1095991152c@igalia.com>
References: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
In-Reply-To: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
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
2.55.0

