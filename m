Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A821EFFA1;
	Thu,  2 Jul 2026 08:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782980498; cv=none; b=f6E++DdMQaOXHZMpMtuumuW6LbhiO+JBHeTk5wn+wAncfVTBao0E+KPV3wFqEE2f6rtPQLQGGQOmPtQK1nQjQjjKdBM+oSb6MxM4HYShn4tKeYNJgKSqN8IGFxi84awOryfYfTSvGvcFfEXih98hQ+XsyOi6em10vhZHKzcMXS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782980498; c=relaxed/simple;
	bh=cec3xwnXWZBQQGbv42GU6QmpPz+8AvRAz3K8EdeOBsQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FADbCBpn8R+zzxZG5FAuGSDNKlizSt5SZFweKzZd6D60EGYWq8ULMHSJxzdBTxIfldHU+GBqTVPx1LU56XZpFT3a27hQKmWsUzraTggciVmmQhrDRbido60SCsfHUSrA7IdRy6jb/e3zKfKlnTXrU2Cez+L8e/EZ8MOKqKDDoUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0GCsaEzz; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2M0y1mYM; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0GCsaEzz";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2M0y1mYM"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782980491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bp5U5FjsUuqmG9kVHnnc4OFrEREB6gXomJ8tROC/Nas=;
	b=0GCsaEzzXtV7+3pSgVu9W2HrlZjfXko73xUrILYZX8Hk65mqDlFZEcg3Z2VAMx6ukZ+DDy
	Wat324S+35nUX42kcvzdaAwDQy8WBw6ZJEdnBfXqoohiReiMrfSbXXmVUgNNOWRezi1EkR
	8LT/Znewzn3A1jiQhQzLJcbaEmw019bz06/Ukrkr5jcag4AmPMB0FUCjvHSNv8IdtZO+sD
	Ua+kEQBFi980B91go75YCUM1V4tdBOZDY5jyPhqhnnwZrm+R6MFRdTPTBO9OORMFDGeoKz
	xhOAujq7pNQ2b0xxFi1cFkcElqF8sltuKFCUaQQyqR/1UuobVLJ4Z+mxFo/yxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782980491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bp5U5FjsUuqmG9kVHnnc4OFrEREB6gXomJ8tROC/Nas=;
	b=2M0y1mYMX8Z+I87ZrS2dXnaMyc8xPFYBq11TIrfERYXTp+SGGC2fbgWqvHNdfBghCnzSFj
	GdgbjETZOUoqjoBg==
Date: Thu, 02 Jul 2026 10:21:26 +0200
Subject: [PATCH v3 2/9] vdso/gettimeofday: Validate system call existence
 for time() and gettimeofday()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260702-vdso-compat_32bit_time-v3-2-db9f36d8d432@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782980489; l=1392;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=cec3xwnXWZBQQGbv42GU6QmpPz+8AvRAz3K8EdeOBsQ=;
 b=fzIbY2wUHyepDnlJz2y76h3VjJzYpEMenwXZ0eQfbLg9z5MtsLMJicYf/IxYkFJWtTT8ssPeF
 JUjxzIyuUxbA0DywLtasjndTd8qdcR4KZDPqER7EA6QrYk5LgyY3miX
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Not all architectures have the system calls for time() and
gettimeofday(). When the system call is missing, the vDSO function
should also not be present.

Validate that.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Philippe Mathieu-Daudé <philmd@oss.qualcomm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
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

