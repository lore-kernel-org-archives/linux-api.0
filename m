From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 07/36] uapi asm-generic/msgbuf.h: include asm/ipcbuf.h
Date: Sun,  6 Aug 2017 18:43:58 +0200
Message-ID: <20170806164428.2273-8-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, "H . J . Lu" <hjl.tools@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation errors like:

error: field ‘msg_perm’ has incomplete type
struct ipc64_perm msg_perm

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 include/uapi/asm-generic/msgbuf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/asm-generic/msgbuf.h b/include/uapi/asm-generic/msgbuf.h
index f55ecc43c60f..f5fbd8e8ab05 100644
--- a/include/uapi/asm-generic/msgbuf.h
+++ b/include/uapi/asm-generic/msgbuf.h
@@ -2,6 +2,8 @@
 #define __ASM_GENERIC_MSGBUF_H
 
 #include <asm/bitsperlong.h>
+#include <asm/ipcbuf.h>
+
 /*
  * generic msqid64_ds structure.
  *
-- 
2.13.3
