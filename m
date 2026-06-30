Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB34368D7C;
	Tue, 30 Jun 2026 07:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782805121; cv=none; b=Z6RIRK68SB9DBAk3lzoJwuhfLO4T5PwTZUBxZbZ4mUDuazN8enfRw+M4teWvyFW8aFio1xRSHWZKd0JadUe6qHovs6KdMGqLjwGZ6xj0deNMoXlcP5IKM/KU+r9WD8i15dappe72G5SNjDXmRvmh+IYCRCsdXvS70/w8KNHkuw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782805121; c=relaxed/simple;
	bh=6IjQwZ36LCC2tu6Rbkgy6M8Qe+F80ooiDk/V0b5/cPg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j8phr4NadeXNp96Ex8G+UM1NMscGey/uOikHW4aZClM7VyIbW0ggrvIJBPI9BlHLBDT3Xg4Hpr6L7EXB38H/M+q0W8yRwYkPiwD3dEXvcPK+/m3RGYG3qowhhTOw/MLh4xNIpAaM3N/cVKfQ9jPn6f+aBZ977nQNfIPmgFzJErQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=RbOA0Fab; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=M/J6OBdN; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="RbOA0Fab";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="M/J6OBdN"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782805118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVID/t0qaW7VypBPiJtjpPrhFqRi5Mo116w2nu1OqvI=;
	b=RbOA0FabMmwkH0ETPAqTm8Bkw+WY1YFlatQVCCczvntdUcP234tEMqb+9zMZT7CFk9/8gW
	UuRXrafcY1XD6hMcJBWy2VOEraSpm7/OreDOBrkRKgEr7TfJfji6QLUuhjXuCO/aANZUmL
	9hJlG6dj3PbWk623bqWdKsqX99138cZp1utC2bMBA6zbnyxkFqlkgNTpUqGDm/HBGBWpj2
	vXauaKNypXTtGKEtuwDfjnu0S2Xm/fV7HHheM7qrzc6OSBs21IdeRattIObztMsOtaNpeJ
	sweB4YV6GMk6LUoXkW3lGrl+esFVDdKw37/5sw+Vd5ld6Lv8Z6g65o/nTv1a6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782805118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVID/t0qaW7VypBPiJtjpPrhFqRi5Mo116w2nu1OqvI=;
	b=M/J6OBdNY+/auBdTuVPbjXT7fKuYYOmlFPuYgS/s/BNuPXvfW62YNCL1QgeLo6+SGpE65T
	1Bo0NxBSKbe/VKCw==
Date: Tue, 30 Jun 2026 09:38:31 +0200
Subject: [PATCH v2 2/9] vdso/gettimeofday: Validate system call existence
 for time() and gettimeofday()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-compat_32bit_time-v2-2-520d194640dd@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782805116; l=1284;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=6IjQwZ36LCC2tu6Rbkgy6M8Qe+F80ooiDk/V0b5/cPg=;
 b=MvautCTPrf+MHg7V1Qyx6eZ2mFaotGr1QoK7VQAj1+oc+8OwJcD4eLwKPNP2/NGjXDj3pLlon
 XRdROlWK9goDBywLWyspXabx3LLpZsa9yMN0f8yBMirgFFiywsPaDWU
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Not all architectures have the system calls for time() and
gettimeofday(). When the system call is missing, the vDSO function
should also not be present.

Validate that.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 lib/vdso/gettimeofday.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index e0f289d3d110..b8c1fc85eb74 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -12,6 +12,8 @@
 #include <vdso/time32.h>
 #include <vdso/time64.h>
 
+#include <uapi/linux/unistd.h>
+
 /*
  * The generic vDSO implementation requires that gettimeofday.h
  * provides:
@@ -348,6 +350,10 @@ __cvdso_gettimeofday_data(const struct vdso_time_data *vd,
 {
 	const struct vdso_clock *vc = vd->clock_data;
 
+#ifndef __NR_gettimeofday
+	BUILD_BUG();
+#endif
+
 	if (likely(tv != NULL)) {
 		struct __kernel_timespec ts;
 
@@ -382,6 +388,10 @@ __cvdso_time_data(const struct vdso_time_data *vd, __kernel_old_time_t *time)
 	const struct vdso_clock *vc = vd->clock_data;
 	__kernel_old_time_t t;
 
+#ifndef __NR_time
+	BUILD_BUG();
+#endif
+
 	if (vdso_is_timens_clock(vc)) {
 		vd = vdso_timens_data(vd);
 		vc = vd->clock_data;

-- 
2.55.0

