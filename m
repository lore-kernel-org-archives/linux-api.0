From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 19/36] uapi linux/omapfb.h: use __kernel_size_t instead of size_t
Date: Sun,  6 Aug 2017 18:44:10 +0200
Message-ID: <20170806164428.2273-20-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: unknown type name ‘size_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-omap@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 include/uapi/linux/omapfb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/omapfb.h b/include/uapi/linux/omapfb.h
index 7c97bc00ac6d..b637a924618f 100644
--- a/include/uapi/linux/omapfb.h
+++ b/include/uapi/linux/omapfb.h
@@ -181,7 +181,7 @@ struct omapfb_memory_read {
 	__u16 y;
 	__u16 w;
 	__u16 h;
-	size_t buffer_size;
+	__kernel_size_t buffer_size;
 	void __user *buffer;
 };
 
-- 
2.13.3
