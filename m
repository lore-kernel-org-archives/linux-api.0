Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E3C3C5832;
	Tue, 30 Jun 2026 07:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782805122; cv=none; b=rvAJ9h7txS8peTgR6WGX9Xo3lHcUVhjKYJ5pFW2q/LlgMv0Hi/ZZSNf6vuHIYmWpQWto074EuW25k0XIHc/gTNoXzfUTyPaAgWQE35lKXBmOpICWbod3tLBXTswFip4pnuHS1a6hRFu2z8Vj4aGgBDh59zA2+CzLc7hLqV801kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782805122; c=relaxed/simple;
	bh=plrPFKoJU/JbBsz98bmTgEfEDcWHMRUx9UlzYiAXfhk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qRyVDaqLi6i+VCCpvtDhoqvOQzuqHo9HyWEbBs1XRmmO6beeNRZr2YmEpgOhwNoB0/fiiCFR/7g0eCMockXEjBAAkflRFXPpvDztZjcswbgiHCSbBhguNsH5lqmMs7akMjse/iUtTfptkQ6jAN6b/YHb/TlLVw3mZj/zQJQetJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=TczhSN8Q; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jzgRViMZ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TczhSN8Q";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jzgRViMZ"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782805119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0rP5abhmKr6KLEx3iZEdDeVAcPKxX+uoMyOYGVFHCg=;
	b=TczhSN8QMskf5TjORlWONf/XomuIBCqAPlEuPxXJKY8rTuQWE/zorwPnbatqBK9LoFH4Fl
	odlBfohKOCPLp9io7ZxYulSYdULULLiy6oz3XyKKx+VJe6Vr/1APewPFsWoBir9tN0U8sd
	PZkLNkoQRCJq9QTgOfy+dUxFAj1TqkOnvYoRqqf3joYMAo4F6g0JCLm1XN7WTmydPI4DkA
	s91UJ9U+QDHI+ImbWxlUTLmijuljShdZ08aEPI3wnzR2hz2BDZRdF6XH0JEKB5Xpwpa1NA
	NJyqqb7NwXALfPXxYxaUHF8Ep4qtiZHbtrumdNpfBQTxFb67vWrd/YPVIMgpqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782805119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0rP5abhmKr6KLEx3iZEdDeVAcPKxX+uoMyOYGVFHCg=;
	b=jzgRViMZz774qFMKHXHPeMS4Mdkv4+p0V2Qcs9WaT2T4zF6wrBOB7bmiJcgGjaN8Q6cVtd
	GztXYgnQ4ZdXOgDg==
Date: Tue, 30 Jun 2026 09:38:33 +0200
Subject: [PATCH v2 4/9] arm64: vdso32: Respect COMPAT_32BIT_TIME
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-compat_32bit_time-v2-4-520d194640dd@linutronix.de>
References: <20260630-vdso-compat_32bit_time-v2-0-520d194640dd@linutronix.de>
In-Reply-To: <20260630-vdso-compat_32bit_time-v2-0-520d194640dd@linutronix.de>
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
 sparclinux@vger.kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782805116; l=2429;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=plrPFKoJU/JbBsz98bmTgEfEDcWHMRUx9UlzYiAXfhk=;
 b=MoI8OxBRQTXPL7JpTkPnu0q30h7XY+R8Rz3zOV8gOov8Sk45uvf1yINZeUgEwpoVHvWHmnObB
 7nCG3+7MN++CX2BCN1FaE5fKzjbNOp4AEI3o48IRlkxBfehKJSVKQvZ
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

If CONFIG_COMPAT_32BIT_TIME is disabled then the vDSO should not
provide any 32-bit time related functionality. This is the intended
effect of the kconfig option and also the fallback system calls would
also not be implemented.

Currently the kconfig option does not affect the gettimeofday() syscall,
so also keep that in the vDSO.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm64/kernel/vdso32/vdso.lds.S      |  2 ++
 arch/arm64/kernel/vdso32/vgettimeofday.c | 14 ++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/vdso32/vdso.lds.S b/arch/arm64/kernel/vdso32/vdso.lds.S
index c374fb0146f3..12bfc39e8aab 100644
--- a/arch/arm64/kernel/vdso32/vdso.lds.S
+++ b/arch/arm64/kernel/vdso32/vdso.lds.S
@@ -82,9 +82,11 @@ VERSION
 {
 	LINUX_2.6 {
 	global:
+#ifdef CONFIG_COMPAT_32BIT_TIME
 		__vdso_clock_gettime;
 		__vdso_gettimeofday;
 		__vdso_clock_getres;
+#endif /* CONFIG_COMPAT_32BIT_TIME */
 		__vdso_clock_gettime64;
 		__vdso_clock_getres_time64;
 	local: *;
diff --git a/arch/arm64/kernel/vdso32/vgettimeofday.c b/arch/arm64/kernel/vdso32/vgettimeofday.c
index 0c6998ebe491..12d0255cc2cf 100644
--- a/arch/arm64/kernel/vdso32/vgettimeofday.c
+++ b/arch/arm64/kernel/vdso32/vgettimeofday.c
@@ -8,16 +8,17 @@
 #define BUILD_VDSO32_64
 #include <vdso/gettime.h>
 
+#ifdef CONFIG_COMPAT_32BIT_TIME
 int __vdso_clock_gettime(clockid_t clock,
 			 struct old_timespec32 *ts)
 {
 	return __cvdso_clock_gettime32(clock, ts);
 }
 
-int __vdso_clock_gettime64(clockid_t clock,
-			   struct __kernel_timespec *ts)
+int __vdso_clock_getres(clockid_t clock_id,
+			struct old_timespec32 *res)
 {
-	return __cvdso_clock_gettime(clock, ts);
+	return __cvdso_clock_getres_time32(clock_id, res);
 }
 
 int __vdso_gettimeofday(struct __kernel_old_timeval *tv,
@@ -25,11 +26,12 @@ int __vdso_gettimeofday(struct __kernel_old_timeval *tv,
 {
 	return __cvdso_gettimeofday(tv, tz);
 }
+#endif /* CONFIG_COMPAT_32BIT_TIME */
 
-int __vdso_clock_getres(clockid_t clock_id,
-			struct old_timespec32 *res)
+int __vdso_clock_gettime64(clockid_t clock,
+			   struct __kernel_timespec *ts)
 {
-	return __cvdso_clock_getres_time32(clock_id, res);
+	return __cvdso_clock_gettime(clock, ts);
 }
 
 int __vdso_clock_getres_time64(clockid_t clock_id, struct __kernel_timespec *res)

-- 
2.55.0

