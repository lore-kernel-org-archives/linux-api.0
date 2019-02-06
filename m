From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 20/32] x86/vdso: Initialize timens 64-bit vdso
Date: Wed,  6 Feb 2019 00:10:54 +0000
Message-ID: <20190206001107.16488-21-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Initialize both 64-bit VDSO(s): host .so and timens one that has code
for adding timens offsets.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vma.c   | 4 ++++
 arch/x86/include/asm/vdso.h | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index d1031db94093..56a62076a320 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -343,6 +343,10 @@ static int __init init_vdso(void)
 {
 	init_vdso_image(&vdso_image_64);
 
+#ifdef CONFIG_TIME_NS
+	init_vdso_image(&vdso_image_64_timens);
+#endif
+
 #ifdef CONFIG_X86_X32_ABI
 	init_vdso_image(&vdso_image_x32);
 #endif
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 619322065b8e..b6a1a028ac62 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -32,6 +32,9 @@ struct vdso_image {
 
 #ifdef CONFIG_X86_64
 extern const struct vdso_image vdso_image_64;
+#ifdef CONFIG_TIME_NS
+extern const struct vdso_image vdso_image_64_timens;
+#endif
 #endif
 
 #ifdef CONFIG_X86_X32
@@ -40,6 +43,9 @@ extern const struct vdso_image vdso_image_x32;
 
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
 extern const struct vdso_image vdso_image_32;
+#ifdef CONFIG_TIME_NS
+extern const struct vdso_image vdso_image_32_timens;
+#endif
 #endif
 
 extern void __init init_vdso_image(const struct vdso_image *image);
-- 
2.20.1
