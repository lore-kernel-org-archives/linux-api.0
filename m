From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 22/36] uapi linux/reiserfs_xattr.h: use __kernel_size_t instead of size_t
Date: Sun,  6 Aug 2017 18:44:13 +0200
Message-ID: <20170806164428.2273-23-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, reiserfs-devel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: unknown type name ‘size_t’
  size_t length;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: reiserfs-devel@vger.kernel.org
---
 include/uapi/linux/reiserfs_xattr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/reiserfs_xattr.h b/include/uapi/linux/reiserfs_xattr.h
index 38fdd648be21..af52b38ef783 100644
--- a/include/uapi/linux/reiserfs_xattr.h
+++ b/include/uapi/linux/reiserfs_xattr.h
@@ -18,7 +18,7 @@ struct reiserfs_xattr_header {
 struct reiserfs_security_handle {
 	const char *name;
 	void *value;
-	size_t length;
+	__kernel_size_t length;
 };
 
 #endif  /*  _LINUX_REISERFS_XATTR_H  */
-- 
2.13.3
