From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 06/36] uapi asm-generic/ipcbuf.h: include linux/posix_types.h
Date: Sun,  6 Aug 2017 18:43:57 +0200
Message-ID: <20170806164428.2273-7-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, "H. Peter Anvin" <hpa@zytor.com>, "H . J . Lu" <hjl.tools@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: unknown type name ‘__kernel_key_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/asm-generic/ipcbuf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/asm-generic/ipcbuf.h b/include/uapi/asm-generic/ipcbuf.h
index 3dbcc1e771c0..909f825096f4 100644
--- a/include/uapi/asm-generic/ipcbuf.h
+++ b/include/uapi/asm-generic/ipcbuf.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_GENERIC_IPCBUF_H
 #define __ASM_GENERIC_IPCBUF_H
 
+#include <linux/posix_types.h>
+
 /*
  * The generic ipc64_perm structure:
  * Note extra padding because this structure is passed back and forth
-- 
2.13.3
