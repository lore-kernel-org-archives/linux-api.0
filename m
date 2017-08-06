From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 10/36] uapi asm-generic/signal.h: use __kernel_size_t instead of size_t
Date: Sun,  6 Aug 2017 18:44:01 +0200
Message-ID: <20170806164428.2273-11-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Al Viro <viro@zeniv.linux.org.uk>, "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compiler error:

error: unknown type name ‘size_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 include/uapi/asm-generic/signal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-generic/signal.h
index 3094618d382f..6bbcdfa5db89 100644
--- a/include/uapi/asm-generic/signal.h
+++ b/include/uapi/asm-generic/signal.h
@@ -113,7 +113,7 @@ struct sigaction {
 typedef struct sigaltstack {
 	void __user *ss_sp;
 	int ss_flags;
-	size_t ss_size;
+	__kernel_size_t ss_size;
 } stack_t;
 
 #endif /* __ASSEMBLY__ */
-- 
2.13.3
