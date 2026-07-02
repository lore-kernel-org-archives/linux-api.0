Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001FC429827;
	Thu,  2 Jul 2026 08:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782980501; cv=none; b=Hb4K+AYgtYMat//z9kSPsEldv7brSE4sJ6UulfmZmGrGlzIoeTmjnEgMFZaakQBYnEaM/zWfruhEYsx3+paQbjwI9vTBEA3LFwzuDWJtSub/5/EDuHREG0LBsbAGFBtUISy7hkhEv2e5pkju02033V69ONFJ44V/EZSNyrBxydE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782980501; c=relaxed/simple;
	bh=s479PRbMVDXdIvbdPYAU8IZbXFBmioP81XZuIIwdP44=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=inn8rHDaBvn1bmSdeoAYqmA9R11ijamLqHw8DOFa+q/8h6ncyEIlB6f4CcY8uj05cNZxNieD/FNS2lt6li7b2VJhZwdZfrxlgDrqavza5CmhhSj/F256omUG6CrIvnOqQZ8RTVuqLL2yqI4NelvSjdnMiFCfrCk7OfgblQbxyLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CrqNSPHy; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=bH2TeRMa; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CrqNSPHy";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="bH2TeRMa"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782980498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVHOIJRddqovqhLIkcVxRsjGq4Z6rx7B7PnZY9VPT4I=;
	b=CrqNSPHyhom5WgeS9I7ky45yoXIHJoKQgYMjL0NZOctLFla3kj1N1jzVeb4rWahsXS+m4i
	QwMCY3L8pCKRqHeleuqxYHcSC1XHXRVIUKNzs3e2A0ZLBDeoXKrNiEibRwNc8utICysDN4
	x3iceWDda0BXgcnL/3WxsQU7MvyJjZn4LDN5YIsKPSLUhblS4rgnCPC11OQniRdWGE5Fqf
	jGvvzwJhdNVZ2uelRpaOoPkUPVbkgKsY2Z/5cYGKL5ECPC4wdHaB7iizrX5X7FoU9247mA
	HmbeveG53Vfy2HK50Lk8FYHPenSrMUhJVf/LOu2Lm2Gwb9q+dRjQF7PUyQmasA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782980498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVHOIJRddqovqhLIkcVxRsjGq4Z6rx7B7PnZY9VPT4I=;
	b=bH2TeRMa04lMzbfJdlIYZdVgAopNHrNmilJxFn/x99PPJWA/USXFkSUJ3EhH652Vh++h6X
	qE3itSWwWztZJMDQ==
Date: Thu, 02 Jul 2026 10:21:28 +0200
Subject: [PATCH v3 4/9] arm64: vdso32: Respect COMPAT_32BIT_TIME
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260702-vdso-compat_32bit_time-v3-4-db9f36d8d432@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782980489; l=2429;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=s479PRbMVDXdIvbdPYAU8IZbXFBmioP81XZuIIwdP44=;
 b=jw72k2yu/phtrz+ZvTR0e9wnDBwUTGnyGSS31EPml2CC3DbTHtM5JXq9trW3betwaWO2xq3s/
 APMfjUxDOpGAZXgiGfV9W09+JSA5KhkO1JWxkRWhns7uS5Aya1/9/1B
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

If CONFIG_COMPAT_32BIT_TIME is disabled then the vDSO should not
provide any 32-bit time related functionality. This is the intended
effect of the kconfig option and also the fallback system calls would
also not be implemented.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Philippe Mathieu-Daudé <philmd@oss.qualcomm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
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

