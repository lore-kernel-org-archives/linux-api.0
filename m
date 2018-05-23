From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/33] uapi: turn __poll_t sparse checkin on by default
Date: Wed, 23 May 2018 21:19:51 +0200
Message-ID: <20180523192022.1703-3-hch@lst.de>
References: <20180523192022.1703-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180523192022.1703-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/uapi/linux/types.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/uapi/linux/types.h b/include/uapi/linux/types.h
index cd4f0b897a48..2fce8b6876e9 100644
--- a/include/uapi/linux/types.h
+++ b/include/uapi/linux/types.h
@@ -49,11 +49,7 @@ typedef __u32 __bitwise __wsum;
 #define __aligned_be64 __be64 __attribute__((aligned(8)))
 #define __aligned_le64 __le64 __attribute__((aligned(8)))
 
-#ifdef __CHECK_POLL
 typedef unsigned __bitwise __poll_t;
-#else
-typedef unsigned __poll_t;
-#endif
 
 #endif /*  __ASSEMBLY__ */
 #endif /* _UAPI_LINUX_TYPES_H */
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
