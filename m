Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0E83E4514;
	Tue, 30 Jun 2026 07:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782805124; cv=none; b=MVWDLAmI8rEFR7EPRQPM5iguAhc09q/zwhp7olx/YNzLeUfVR0p7L+rHONaB1kPfkvAHPOLomnZNXs2rvhR0C70jY5PRFWw4sIoh9swnWMStg5SO/V9wwj60VTTSAAfCkLBG79upPDqvrslArdBjb4lX6tY7U8j+Bhsan9nX6qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782805124; c=relaxed/simple;
	bh=Y3HmBsDyRXYMBklzibJJx8Xw8D+NzjIxpzvmQa5/92I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Pea6SzWydzfyXxQFimwJqpcA5WwkcyyoL2OsURs8x0Y+8yBC7i4z1XSNciKJRBGMBFjdW2FyINOytUxjiteOFgfZva5SMNQxDi4bSCOYG4pzEvcgA47EdVS0xgPlYCorhxvDVggz3C8JP4601fIvrd3ay9DwvTsLkG59E3K/W2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0r1pz1IR; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=dKF5P0SH; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0r1pz1IR";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="dKF5P0SH"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782805121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJlJzdmoKaPgYs3XkyTM2uOkRwW778HSxBnDi52Vm7M=;
	b=0r1pz1IRmEhdi1svwnFqxKbPu7TzeFCZMZpxFJJtm4Jp369U/2CcU9knvHDp5DNRtK59Vl
	f0O5a5AudG+1wHY6G2DO/HgF+Zwgj2MdpHfs3kqaSlKLvdI3LXqT/KYhjhkJ3elJUHz/zY
	UxTfh2NHPeWR8MdqxAtAn8W/b8+JVdQnKHQqcwY5dSdx1NT03FF0MRas7ucBqCcFp+VsiA
	hJnfJ7XcnUH4QCWHhZAPKgwBx5wsr+8VMqXBiByLydBjTyMEvDJnP4ANdCpAeHpyuOIur/
	LyvxxLBvn3OPf5g1yHh0ChqIntL6X4nxNSqfja7pnMPZ2mDv9JgwUFIuRX/F6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782805121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJlJzdmoKaPgYs3XkyTM2uOkRwW778HSxBnDi52Vm7M=;
	b=dKF5P0SH7UeBCiEd4D0aAsr0LulQkFMW+XNL13e04TGw0dDaT9TShwqRXWOUV8Z5QFOTHZ
	CMq+r1b8UtedgFCw==
Date: Tue, 30 Jun 2026 09:38:36 +0200
Subject: [PATCH v2 7/9] MIPS: VDSO: Respect COMPAT_32BIT_TIME
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-compat_32bit_time-v2-7-520d194640dd@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782805116; l=1716;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Y3HmBsDyRXYMBklzibJJx8Xw8D+NzjIxpzvmQa5/92I=;
 b=pvdSGJwi0a8pc2utGGLPCI1gG+1BwWkeRAfn5FRxIp4bwh/fT2JRVhxqz22oPde4hijoOrZD3
 nigKZNlG9AJATsm5boBYD8nY2NsJK+JPbqfBa4ZvhYg+mi3+dC54V5I
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
 arch/mips/vdso/vdso.lds.S      | 2 ++
 arch/mips/vdso/vgettimeofday.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/arch/mips/vdso/vdso.lds.S b/arch/mips/vdso/vdso.lds.S
index 278ab6444e98..b11ee493c67f 100644
--- a/arch/mips/vdso/vdso.lds.S
+++ b/arch/mips/vdso/vdso.lds.S
@@ -97,9 +97,11 @@ VERSION
 	LINUX_2.6 {
 #ifdef CONFIG_GENERIC_GETTIMEOFDAY
 	global:
+#if _MIPS_SIM == _MIPS_SIM_ABI64 || defined(CONFIG_COMPAT_32BIT_TIME)
 		__vdso_clock_gettime;
 		__vdso_gettimeofday;
 		__vdso_clock_getres;
+#endif
 #if _MIPS_SIM != _MIPS_SIM_ABI64
 		__vdso_clock_gettime64;
 		__vdso_clock_getres_time64;
diff --git a/arch/mips/vdso/vgettimeofday.c b/arch/mips/vdso/vgettimeofday.c
index 00f9fcfc327e..a1fb06b8973e 100644
--- a/arch/mips/vdso/vgettimeofday.c
+++ b/arch/mips/vdso/vgettimeofday.c
@@ -12,6 +12,8 @@
 #include <vdso/gettime.h>
 
 #if _MIPS_SIM != _MIPS_SIM_ABI64
+
+#ifdef CONFIG_COMPAT_32BIT_TIME
 int __vdso_clock_gettime(clockid_t clock,
 			 struct old_timespec32 *ts)
 {
@@ -29,6 +31,7 @@ int __vdso_clock_getres(clockid_t clock_id,
 {
 	return __cvdso_clock_getres_time32(clock_id, res);
 }
+#endif /* CONFIG_COMPAT_32BIT_TIME */
 
 int __vdso_clock_gettime64(clockid_t clock,
 			   struct __kernel_timespec *ts)

-- 
2.55.0

