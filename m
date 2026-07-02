Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2C242B303;
	Thu,  2 Jul 2026 08:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782980505; cv=none; b=KR+t02IFj+JMc8Xo2PjL8ugKk3M4PP+YXJnRUhg+NwDDosxEZeQE35Z/BhFhOhDOgmQvBxczghybBqNqsxf351HJBSVHOXElNmxzqvDwcGSBBOki8f5MF0mhtc/cX00DQFMzJVEJPTIp+S8L96AIpoMzN3uWXLndelctDkkrVTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782980505; c=relaxed/simple;
	bh=aqgZkxvAY2TFHB/+t3zOeQYlHPgQbAzCa7BbZvo7XEI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dMybqsRXwHd8+sxk4GA1vUXKpZg58pzsN3bVfMVsQTNhzApjUCURLkLIRijs62IN5jcrxQiiS8LJoBysJH2/UtUhM28tKOcYzWIPpGzkR2uXoKtNWzm+pjCHYMIrfUwW0/SLyQyNJhAR0zfuG/0k3fJ/u9uJoMlB8XIcBh7UryA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=BpewmvR2; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=IN5w+ClU; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="BpewmvR2";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="IN5w+ClU"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782980502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FDx/mf68loGtY4/pzu5yq07jQQexXyZTLZdmZFsiZXE=;
	b=BpewmvR2+cxq52PsGAE2vwBwLa+/ZzzeGA+lg/qEYCN4YRzTaIpcwXpxV5JcvbYJtnkz0I
	8NwqdhSpBbq1Q0o8uhgFF2jEzrI3fjEMk1lbNSWuMt2/FV+yFlWTf9rWdHWojTJT3uSDpS
	1dr8mEoMZ8fziX8zfDlkO+47RtFf8C6HiRXD2iwQszCoS/2C5PbVT9Vsk69KE2ArYZXyJy
	3aDo934xMmfb6h2Imp/hw5dlgyj7n2rgYZ6mn5eLZWakWoxeD/UGG/JddOZBVIo++83RyU
	KQ0unSywA8FFxRJM8ZYSFcI7woId5DAYu7LKBLdckluB6lkjb1FGt/Z1hijhEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782980502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FDx/mf68loGtY4/pzu5yq07jQQexXyZTLZdmZFsiZXE=;
	b=IN5w+ClUYXeEuRwMnIIp4Wh50yy51Mfzok9sXoiqTYTqLC5s777ZMh3kQ4pZVhxJ7YBa+z
	cWi6nPksNiK2OPAQ==
Date: Thu, 02 Jul 2026 10:21:32 +0200
Subject: [PATCH v3 8/9] sparc: vdso: Respect COMPAT_32BIT_TIME
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260702-vdso-compat_32bit_time-v3-8-db9f36d8d432@linutronix.de>
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
 bh=aqgZkxvAY2TFHB/+t3zOeQYlHPgQbAzCa7BbZvo7XEI=;
 b=MJHCyL6E9qzPfqGXmPqJaDhUYxYyfcT/TZ/DuMzn9UmQF0rR8IjTjqUuY6qLJygXnfZg+67wQ
 aXbHQ4k8hejAgijef9PPHV+17AjAB6mo8QSpFk3D0eKXIsM83o++5FC
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
 arch/sparc/vdso/vclock_gettime.c    | 4 ++++
 arch/sparc/vdso/vdso32/vdso32.lds.S | 6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/vdso/vclock_gettime.c b/arch/sparc/vdso/vclock_gettime.c
index 1d9859392e4c..221bd4ed19f5 100644
--- a/arch/sparc/vdso/vclock_gettime.c
+++ b/arch/sparc/vdso/vclock_gettime.c
@@ -21,6 +21,7 @@
 
 #include "../../../../lib/vdso/gettimeofday.c"
 
+#if defined(CONFIG_SPARC64) || defined(CONFIG_COMPAT_32BIT_TIME)
 int __vdso_gettimeofday(struct __kernel_old_timeval *tv, struct timezone *tz)
 {
 	return __cvdso_gettimeofday(tv, tz);
@@ -28,6 +29,7 @@ int __vdso_gettimeofday(struct __kernel_old_timeval *tv, struct timezone *tz)
 
 int gettimeofday(struct __kernel_old_timeval *, struct timezone *)
 	__weak __alias(__vdso_gettimeofday);
+#endif
 
 #if defined(CONFIG_SPARC64)
 int __vdso_clock_gettime(clockid_t clock, struct __kernel_timespec *ts)
@@ -40,6 +42,7 @@ int clock_gettime(clockid_t, struct __kernel_timespec *)
 
 #else
 
+#if defined(CONFIG_COMPAT_32BIT_TIME)
 int __vdso_clock_gettime(clockid_t clock, struct old_timespec32 *ts)
 {
 	return __cvdso_clock_gettime32(clock, ts);
@@ -47,6 +50,7 @@ int __vdso_clock_gettime(clockid_t clock, struct old_timespec32 *ts)
 
 int clock_gettime(clockid_t, struct old_timespec32 *)
 	__weak __alias(__vdso_clock_gettime);
+#endif
 
 int __vdso_clock_gettime64(clockid_t clock, struct __kernel_timespec *ts)
 {
diff --git a/arch/sparc/vdso/vdso32/vdso32.lds.S b/arch/sparc/vdso/vdso32/vdso32.lds.S
index a14e4f77e6f2..28052168b875 100644
--- a/arch/sparc/vdso/vdso32/vdso32.lds.S
+++ b/arch/sparc/vdso/vdso32/vdso32.lds.S
@@ -15,12 +15,14 @@
 VERSION {
 	LINUX_2.6 {
 	global:
+#ifdef CONFIG_COMPAT_32BIT_TIME
 		clock_gettime;
 		__vdso_clock_gettime;
-		clock_gettime64;
-		__vdso_clock_gettime64;
 		gettimeofday;
 		__vdso_gettimeofday;
+#endif
+		clock_gettime64;
+		__vdso_clock_gettime64;
 	local: *;
 	};
 }

-- 
2.55.0

