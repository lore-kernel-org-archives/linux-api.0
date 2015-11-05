From: mudongliang <mudongliangabcd@gmail.com>
Subject: [PATCH] uapi elf: delete unused macros
Date: Thu, 05 Nov 2015 23:41:33 +0800
Message-ID: <563B78AD.2060906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, takahiro.akashi@linaro.org, will.deacon@arm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

delete unused macros and unify the comment format

>From e21328f3450e841abf8a312865910806d0858373 Mon Sep 17 00:00:00 2001
From: mudongliang <mudongliangabcd@gmail.com>
Date: Thu, 5 Nov 2015 22:46:19 +0800
Subject: [PATCH] unify the comment form and delete unused macros

Signed-off-by: mudongliang <mudongliangabcd@gmail.com>
---
 arch/powerpc/boot/elf.h  | 6 ++----
 include/uapi/linux/elf.h | 7 ++-----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/boot/elf.h b/arch/powerpc/boot/elf.h
index 1941bc5..e6e00ed 100644
--- a/arch/powerpc/boot/elf.h
+++ b/arch/powerpc/boot/elf.h
@@ -133,15 +133,13 @@ typedef struct elf64_phdr {
 #define	ELFCLASSNONE	0	/* EI_CLASS */
 #define	ELFCLASS32	1
 #define	ELFCLASS64	2
-#define	ELFCLASSNUM	3
 
-#define ELFDATANONE	0	/* e_ident[EI_DATA] */
+#define ELFDATANONE	0	/* EI_DATA */
 #define ELFDATA2LSB	1
 #define ELFDATA2MSB	2
 
-#define EV_NONE		0	/* e_version, EI_VERSION */
+#define EV_NONE		0	/* EI_VERSION */
 #define EV_CURRENT	1
-#define EV_NUM		2
 
 #define ELFOSABI_NONE	0
 #define ELFOSABI_LINUX	3
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 71e1d0e..bd049b2 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -342,15 +342,12 @@ typedef struct elf64_shdr {
 #define	ELFCLASSNONE	0		/* EI_CLASS */
 #define	ELFCLASS32	1
 #define	ELFCLASS64	2
-#define	ELFCLASSNUM	3
 
-#define ELFDATANONE	0		/* e_ident[EI_DATA] */
+#define ELFDATANONE	0		/* EI_DATA */
 #define ELFDATA2LSB	1
-#define ELFDATA2MSB	2
 
-#define EV_NONE		0		/* e_version, EI_VERSION */
+#define EV_NONE		0		/* EI_VERSION */
 #define EV_CURRENT	1
-#define EV_NUM		2
 
 #define ELFOSABI_NONE	0
 #define ELFOSABI_LINUX	3
-- 
2.1.4

-- 
My best regards to you.

     No System Is Safe!
     mudongliang
