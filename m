Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FAB28C86C;
	Tue, 30 Jun 2026 07:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782805120; cv=none; b=mkcEo2TYjoPJk7+8r4EFEIkU5G31JpeY64W5w/jix3gBlkh+B2WJw/ei/kra83+bTJZbabwDvqZoLUjjWIPv0PDZxyNh9Cr17jJXmbVrPSI7/rUo8zDOjf+ZOEuoouqh5nd6tjGzuD2f8tUJeOFdXFyrGbiIDZnaVAcDvVOptSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782805120; c=relaxed/simple;
	bh=m2BcXDvYAEp5y0PpYqR0UFKrjTCsaqAcLwRl/QjXAqE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=dxoc8QoLzamt+gLUPqlaghy8XeVhWne34rptMftU3d7ZNLX4j80Uq2h7OewA8HIfmKv2xcqH7+0d1IzVoXZr0p9n2Q5kgk94cHHn/2JfE7RV0DNdagPFG68MSCNCi+uH/MlfumY0KJ/u5madMDKoqrUn/12xBz5na1elN0xX7mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=eOCI/CT9; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Btvx2I53; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="eOCI/CT9";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Btvx2I53"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782805117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NdrwOPwwg5sl/G/VlKLy2BfD96hcOiYwx38KP81p2To=;
	b=eOCI/CT9Al8F9+zzbCaSRdLDNuKZdO0uWTKoB2tZnMKpW1yRESHHgZD76EC03YhgbvMlmi
	C/n2LhQNqFCMC/bxvchp20eA9IqpSqZDnBvD0VhQ3jrlrliiSBJK8TN9LGDK3c7+oUCUyH
	JQHBtevBRk+3re8OHUO/TRxNx/+CQrdChPFl1jCUdTrl7YimwZ87ITGoC7febatJzajsny
	jxXixUhadxsuYrlw+AoXiXfzMWLHxR+n4MXrkfjQy6UmrrFpIkIR6VulXnsXF5xEKJTkZV
	JkefOTZCE6s85sFs5lbc8HYEZ/jFZqxqDfzv1zm2+ctf23qBxLCLRwxs8w4bbg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782805117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NdrwOPwwg5sl/G/VlKLy2BfD96hcOiYwx38KP81p2To=;
	b=Btvx2I53nZX8nXAICG9CUa/B6i7cJ363iMeh2cME3M8TJhPuIOpoqqppMxRTzXXToY8W+x
	ya7jeQWHyt9zVQBQ==
Subject: [PATCH v2 0/9] vDSO: Respect COMPAT_32BIT_TIME
Date: Tue, 30 Jun 2026 09:38:29 +0200
Message-Id: <20260630-vdso-compat_32bit_time-v2-0-520d194640dd@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNwQqDMBAFf0VybkqygcT21P8oIlHXulATSdJgE
 f+9qT33OANv3sYiBsLIrtXGAmaK5F0BOFWsn6x7IKehMAMBWkipeB6i572fF5taBR2lNtGMHGt
 RG63wYrRlZbwEHGk9wvem8EQx+fA+frL82l8SwPxLZskFV6OAWlvT2V7dnuReKXhH63lA1uz7/
 gHqMwZqwAAAAA==
X-Change-ID: 20260113-vdso-compat_32bit_time-e808763e976a
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782805116; l=3999;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=m2BcXDvYAEp5y0PpYqR0UFKrjTCsaqAcLwRl/QjXAqE=;
 b=MmLqPk6DUhP7wmz102JYzJAuqPgG4TQxTMFC0bnmH6DgjsgVPzlCAJG/20f/m5qxrZq2ldo9i
 GdipLSy/PXsD0YkIipY0BiFwCqtAP78WuzVzlQnXVwNuMroRwsWymi+
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

If CONFIG_COMPAT_32BIT_TIME is disabled then the vDSO should not
provide any 32-bit time related functionality. This is the intended
effect of the kconfig option and also the fallback system calls would
also not be implemented.

Currently the kconfig option does not affect the gettimeofday() syscall,
so also keep that in the vDSO.

I also tried to introduce some helpers to avoid much of the ifdeffery,
but due to the high variance in the architecture-specific glue code
these would need to handle they ended up being worse than the current
proposal.

As a side-effect this will make the self-tests more reliable,
as there is now always a matching syscall available for each vDSO function.

clock_gettime_time64() was only introduced in v6.19, so libc implementations
are likely not using it yet.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Changes in v2:
- Also handle SPARC.
- Drop MIPS cleanup patches.
- Also handle gettimeofday().
- Add more static validations.
- Rebase on v7.2-rc1.
- Link to v1: https://lore.kernel.org/r/20260227-vdso-compat_32bit_time-v1-0-3f0286a7bac3@linutronix.de

To: Andy Lutomirski <luto@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
To: H. Peter Anvin <hpa@zytor.com>
To: Russell King <linux@armlinux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
To: Nicholas Piggin <npiggin@gmail.com>
To: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Vincenzo Frascino <vincenzo.frascino@arm.com>
To: John Stultz <jstultz@google.com>
To: Stephen Boyd <sboyd@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
To: Andreas Larsson <andreas@gaisler.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-mips@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-api@vger.kernel.org
Cc: sparclinux@vger.kernel.org

---
Thomas Weißschuh (9):
      time: Respect COMPAT_32BIT_TIME for old time type functions
      vdso/gettimeofday: Validate system call existence for time() and gettimeofday()
      x86/vdso: Respect COMPAT_32BIT_TIME
      arm64: vdso32: Respect COMPAT_32BIT_TIME
      ARM: VDSO: Respect COMPAT_32BIT_TIME
      powerpc/vdso: Respect COMPAT_32BIT_TIME
      MIPS: VDSO: Respect COMPAT_32BIT_TIME
      sparc: vdso: Respect COMPAT_32BIT_TIME
      vdso/gettimeofday: Verify COMPAT_32BIT_TIME interactions

 arch/arm/vdso/vdso.lds.S                    |  2 ++
 arch/arm/vdso/vgettimeofday.c               | 14 ++++++++------
 arch/arm64/kernel/vdso32/vdso.lds.S         |  2 ++
 arch/arm64/kernel/vdso32/vgettimeofday.c    | 14 ++++++++------
 arch/mips/vdso/vdso.lds.S                   |  2 ++
 arch/mips/vdso/vgettimeofday.c              |  3 +++
 arch/powerpc/kernel/vdso/gettimeofday.S     |  8 ++++++++
 arch/powerpc/kernel/vdso/vdso32.lds.S       | 10 ++++++----
 arch/powerpc/kernel/vdso/vgettimeofday.c    | 16 ++++++++++------
 arch/sparc/vdso/vclock_gettime.c            |  4 ++++
 arch/sparc/vdso/vdso32/vdso32.lds.S         |  6 ++++--
 arch/x86/entry/vdso/common/vclock_gettime.c | 20 ++++++++++++--------
 arch/x86/entry/vdso/vdso32/vdso32.lds.S     |  2 ++
 kernel/sys_ni.c                             |  4 ++++
 kernel/time/time.c                          | 24 ++++++++++++++++++++----
 lib/vdso/gettimeofday.c                     | 20 ++++++++++++++++++++
 16 files changed, 115 insertions(+), 36 deletions(-)
---
base-commit: e6da2429169af9b33f3629b69905d89bb5ee9e64
change-id: 20260113-vdso-compat_32bit_time-e808763e976a

Best regards,
--  
Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>

