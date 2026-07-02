Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA97D42B325;
	Thu,  2 Jul 2026 08:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782980506; cv=none; b=TnMxy8BvuoJ05GwL/Eb4FIMi+/xp/42rdQFzQtolUXtWAqgL4EfL6AlsUSupBBzwUBX09E98vkvty2i9enztjQlhleTYXme3toj8uJP635hJhifJG6u+WqZgJZSK+j8vSFmtruDEpXuIIwy3RQAzNdddhTZf9tDuIJLY8sLu3kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782980506; c=relaxed/simple;
	bh=5g615MqgFMp6M0A+ZVnIgEz2yKH7vz8ZMuh99cb7cpM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lVbw1RWq2yAyTndfOBeWoZ7z3MruBR1Ji63oSYCUoKScbcVwEHT7qv0ef9wOiQooEbuDyy88v5kgge6u3pWQRW1tgDKgYJJxCFUT7Jg5NCmQrGTgWZSrAE/KJYpo8aLlF9XgTyf2itwJk5W3qCFBxFWuwwstLSqRwVbIIBNp1Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Ju+BX4Wp; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=O3+0llp0; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Ju+BX4Wp";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="O3+0llp0"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782980502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n92rz6XZyDHduuUMRGj8v17yy2y+GqzJvWaUESl6CjM=;
	b=Ju+BX4WptZhtkZ0xka0eDircy71rg7a8jgfQHPrUYwoa91IaXbfGYVbB0xSiZh/9kbjvnP
	hxBUuZ8aa8qyhBB14ZKEKphtKSGY5jJgEUSwxyIfHkM/AD8nAtW1nTFG8r5dybliIzhaLS
	SZeDbvA2p6xXsq2DYF14Rp1TYxHprobSGEJBa3HWucsAB3XKUGs/6AZPp3yXPQ2fZT7SSk
	zLMrXhSq067Ixmyikxf3MVzT+lKjHmA4ew08eLqzmDo2hDNt6afCSIKbJuwKjS4KfC3yhD
	eBWE1mQfsudAQV9Qc0aazYpQ85pRsKr9NALiTvOXJrUWLXK6cfVUQRuLZSGVNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782980502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n92rz6XZyDHduuUMRGj8v17yy2y+GqzJvWaUESl6CjM=;
	b=O3+0llp0uPND16gfyqFlxpbwIHuoeUoQD4Q/Clu8sHHEI0ud3n8czVTTmvF1g1Y/xyIzS8
	gxrdq95n7wNC1tAA==
Date: Thu, 02 Jul 2026 10:21:33 +0200
Subject: [PATCH v3 9/9] vdso/gettimeofday: Verify COMPAT_32BIT_TIME
 interactions
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260702-vdso-compat_32bit_time-v3-9-db9f36d8d432@linutronix.de>
References: <20260702-vdso-compat_32bit_time-v3-0-db9f36d8d432@linutronix.de>
In-Reply-To: <20260702-vdso-compat_32bit_time-v3-0-db9f36d8d432@linutronix.de>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>
Cc: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, 
 Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, 
 sparclinux@vger.kernel.org, 
 =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782980489; l=1961;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=5g615MqgFMp6M0A+ZVnIgEz2yKH7vz8ZMuh99cb7cpM=;
 b=9r69kfG/WPHhMK/v3k1Ei9r0o54djhlcPyY3jYCnYKkxUndy33fhLwmO1brSL65A552jj8YEl
 ETzvBSqQBqlCLXH05NxwrkT2gG8Wi4rBSYoB0y8j7rTpSYquFTmPzMC
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

If CONFIG_COMPAT_32BIT_TIME is disabled then the vDSO should not
provide any 32-bit time related functionality.

Add some build-time validations to make sure the architecture-specific
glue satisfies this requirement.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Philippe Mathieu-Daudé <philmd@oss.qualcomm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/vdso/gettimeofday.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index b8c1fc85eb74..f7a591aba59f 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -25,6 +25,8 @@
  */
 #include <asm/vdso/gettimeofday.h>
 
+#include <linux/build_bug.h>
+
 /* Bring in default accessors */
 #include <vdso/vsyscall.h>
 
@@ -325,6 +327,8 @@ __cvdso_clock_gettime32_data(const struct vdso_time_data *vd, clockid_t clock,
 	struct __kernel_timespec ts;
 	bool ok;
 
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_COMPAT_32BIT_TIME));
+
 	ok = __cvdso_clock_gettime_common(vd, clock, &ts);
 
 	if (unlikely(!ok))
@@ -354,6 +358,8 @@ __cvdso_gettimeofday_data(const struct vdso_time_data *vd,
 	BUILD_BUG();
 #endif
 
+	BUILD_BUG_ON(sizeof(tv->tv_sec) != 8 && !IS_ENABLED(CONFIG_COMPAT_32BIT_TIME));
+
 	if (likely(tv != NULL)) {
 		struct __kernel_timespec ts;
 
@@ -392,6 +398,8 @@ __cvdso_time_data(const struct vdso_time_data *vd, __kernel_old_time_t *time)
 	BUILD_BUG();
 #endif
 
+	BUILD_BUG_ON(sizeof(*time) != 8 && !IS_ENABLED(CONFIG_COMPAT_32BIT_TIME));
+
 	if (vdso_is_timens_clock(vc)) {
 		vd = vdso_timens_data(vd);
 		vc = vd->clock_data;
@@ -481,6 +489,8 @@ __cvdso_clock_getres_time32_data(const struct vdso_time_data *vd, clockid_t cloc
 	struct __kernel_timespec ts;
 	bool ok;
 
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_COMPAT_32BIT_TIME));
+
 	ok = __cvdso_clock_getres_common(vd, clock, &ts);
 
 	if (unlikely(!ok))

-- 
2.55.0

