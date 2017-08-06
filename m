From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 12/36] x86 uapi asm/signal.h: use __kernel_size_t instead of size_t
Date: Sun,  6 Aug 2017 18:44:03 +0200
Message-ID: <20170806164428.2273-13-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: unknown type name ‘size_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/uapi/asm/signal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/signal.h b/arch/x86/include/uapi/asm/signal.h
index 8264f47cf53e..74346db30758 100644
--- a/arch/x86/include/uapi/asm/signal.h
+++ b/arch/x86/include/uapi/asm/signal.h
@@ -127,7 +127,7 @@ struct sigaction {
 typedef struct sigaltstack {
 	void __user *ss_sp;
 	int ss_flags;
-	size_t ss_size;
+	__kernel_size_t ss_size;
 } stack_t;
 
 #endif /* __ASSEMBLY__ */
-- 
2.13.3
