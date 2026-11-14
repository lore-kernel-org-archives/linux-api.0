Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794682053;
	b=pHQdKvS1M/selJFg2PDBdx1dVdzELc7fugfPhTJa0ny5P+AuypFtEebSSpW6wUyWlayJ
	 ihRi8j3uJqBLO6Cb0yECMZ/KzPHnKe/ep34wVwQMbOe/K6xQNUE2sh3TEM0MIpogNX20s
	 rRl6tyO7G1TSW6x0xUWYmsGaRC6BeoObF//0XKrYUHQdA8NjRvMOExEqVaawqvg2vOI12
	 QA6RvxMHRWiHh31EZumpJ2AmQvLz6MSVhDSrQNVJKvsxI4IMaEj+huf4XFJtUhmwZnFA9
	 aoMrL3etkBMgfMZS3+9CNn+jLRetJuNgvQvtV3o48xj2BT1SkccbyJwTcbeE3zCErfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794682053;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eXrt6zjXDYGtbkAl2DYVnczzLf0GaCjURpDTDmTj8GU=;
	b=lAvDaxcxMRH5x41cSd0SlJkdZbe+uEfOohO3ohPfd51+s3UI5Cu8yfndqV595fXWMfjh
	 EZ2rmaqzXQx8C1JwRLuF7qDx4VNFgp8lc/23i7kizyQ/bCH9W+N/NBl1AJOewT+RjZWO7
	 J+lRW3S/lhNsXZFY/lkTPsu53g1kHYTUDYNXirRD3Qo02rllwaE+cxcRtx7x/HEwMABRJ
	 DUn/guSZJWTP8vMg3uOLtTi+dYcRj6KuQgLpeCIWytNFykwLoALUbUIodAYYJUA4MLeEG
	 ZOmTa4sxP1l8sv0ljKi4tQWLpv0HTGN832qb641X+RFkaQXtwIQcmGUDA7sw3PBmmlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=sr0v5n3s;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BDD606A337;
	Sat, 14 Nov 2026 18:47:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77BDD606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=sr0v5n3s
Received: from eipi10.cs.unibo.it (host0.studiodavoli.it [109.234.61.1])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id F0BC91C025B;
	Sat, 14 Nov 2026 19:47:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794682051;
	bh=rb+3MKxX5aVEtvNPL35DviAvmrKKFIkGgi9tYTrkJVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sr0v5n3sFV1hSxJsnNyaJjh9ORnCa2EuxQxIo6EYpQNdWQ9Qdp8NehDSsaYHUChFI
	 avvhnS/DXptVVDuBIjIj62/RTds4VX8/oZy/mFF8YzIUKeKafi2KnqVbePJqo7OvdS
	 3w6F4suIu5/B1ADHz2yBJmYpIv7VdqBsBMlcJmDE=
From: Renzo Davoli <renzo@cs.unibo.it>
To: linux-kernel@vger.kernel.org
Cc: Renzo Davoli <renzo@cs.unibo.it>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Davide Berardi <berardi.dav@gmail.com>,
	"Dmitry V . Levin" <ldv@strace.io>,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	strace-devel@lists.strace.io,
	linux-api@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Brian Cain <bcain@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Michal Simek <monstr@monstr.eu>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	linux-alpha@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-um@lists.infradead.org
Subject: [PATCH v4 1/3] asm/ptrace.h: add instruction_pointer_set
Date: Sat, 14 Nov 2026 19:47:16 +0100
Message-ID: <20261114184720.373178-2-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261114184720.373178-1-renzo@cs.unibo.it>
References: <20261114184720.373178-1-renzo@cs.unibo.it>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an instruction_pointer_set function for architectures that do
not currently provide one.

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
 arch/alpha/include/asm/ptrace.h      | 6 ++++++
 arch/hexagon/include/asm/ptrace.h    | 6 ++++++
 arch/m68k/include/asm/ptrace.h       | 6 ++++++
 arch/microblaze/include/asm/ptrace.h | 6 ++++++
 arch/nios2/include/asm/ptrace.h      | 6 ++++++
 arch/um/include/asm/ptrace-generic.h | 6 ++++++
 arch/xtensa/include/asm/ptrace.h     | 6 ++++++
 7 files changed, 42 insertions(+)

diff --git a/arch/alpha/include/asm/ptrace.h b/arch/alpha/include/asm/ptrace.h
index 45d1229344b6..1a6f073e892e 100644
--- a/arch/alpha/include/asm/ptrace.h
+++ b/arch/alpha/include/asm/ptrace.h
@@ -33,6 +33,12 @@ static __always_inline bool regs_irqs_disabled(struct pt_regs *regs)
 	return arch_irqs_disabled_flags(regs->ps);
 }
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 /* Syscall emulation defines */
 #define PTRACE_SYSEMU			0x1d
 #define PTRACE_SYSEMU_SINGLESTEP	0x1e
diff --git a/arch/hexagon/include/asm/ptrace.h b/arch/hexagon/include/asm/ptrace.h
index ed35da1ee685..0a121f6e3bfc 100644
--- a/arch/hexagon/include/asm/ptrace.h
+++ b/arch/hexagon/include/asm/ptrace.h
@@ -18,6 +18,12 @@ extern const char *regs_query_register_name(unsigned int offset);
 	((struct pt_regs *) \
 	 ((unsigned long)current_thread_info() + THREAD_SIZE) - 1)
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 #if CONFIG_HEXAGON_ARCH_VERSION >= 4
 #define arch_has_single_step()	(1)
 #endif
diff --git a/arch/m68k/include/asm/ptrace.h b/arch/m68k/include/asm/ptrace.h
index bc86ce012025..6e8a8f0daee8 100644
--- a/arch/m68k/include/asm/ptrace.h
+++ b/arch/m68k/include/asm/ptrace.h
@@ -18,6 +18,12 @@
 	(struct pt_regs *)((char *)current_thread_info() + THREAD_SIZE) - 1
 #define current_user_stack_pointer() rdusp()
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 #define arch_has_single_step()	(1)
 
 #ifdef CONFIG_MMU
diff --git a/arch/microblaze/include/asm/ptrace.h b/arch/microblaze/include/asm/ptrace.h
index 17982292a64f..69e10658d7a9 100644
--- a/arch/microblaze/include/asm/ptrace.h
+++ b/arch/microblaze/include/asm/ptrace.h
@@ -20,5 +20,11 @@ static inline long regs_return_value(struct pt_regs *regs)
 	return regs->r3;
 }
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 #endif /* __ASSEMBLER__ */
 #endif /* _ASM_MICROBLAZE_PTRACE_H */
diff --git a/arch/nios2/include/asm/ptrace.h b/arch/nios2/include/asm/ptrace.h
index 96cbcd40c7ce..d120d8ecb187 100644
--- a/arch/nios2/include/asm/ptrace.h
+++ b/arch/nios2/include/asm/ptrace.h
@@ -70,6 +70,12 @@ struct switch_stack {
 #define user_stack_pointer(regs)	((regs)->sp)
 extern void show_regs(struct pt_regs *);
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 #define current_pt_regs() \
 	((struct pt_regs *)((unsigned long)current_thread_info() + THREAD_SIZE)\
 		- 1)
diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index 62e9916078ec..632d4ce3334d 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -29,6 +29,12 @@ struct pt_regs {
 
 #define PTRACE_OLDSETOPTIONS 21
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 #ifdef CONFIG_BINFMT_ELF_FDPIC
 #define PTRACE_GETFDPIC		31
 #define PTRACE_GETFDPIC_EXEC	0
diff --git a/arch/xtensa/include/asm/ptrace.h b/arch/xtensa/include/asm/ptrace.h
index d0568ff6d349..97b14418955e 100644
--- a/arch/xtensa/include/asm/ptrace.h
+++ b/arch/xtensa/include/asm/ptrace.h
@@ -103,6 +103,12 @@ static inline unsigned long regs_return_value(struct pt_regs *regs)
 	return regs->areg[2];
 }
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 int do_syscall_trace_enter(struct pt_regs *regs);
 void do_syscall_trace_leave(struct pt_regs *regs);
 
-- 
2.47.3

