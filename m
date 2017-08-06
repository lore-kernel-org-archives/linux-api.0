From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 33/36] uapi linux/fsmap.h: use __kernel_size_t instead of size_t
Date: Sun,  6 Aug 2017 18:44:24 +0200
Message-ID: <20170806164428.2273-34-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, "Darrick J . Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>
List-Id: linux-api@vger.kernel.org

Fixes user space compilation error:

linux/fsmap.h:71:19: error: unknown type name ‘size_t’
 static __inline__ size_t
                   ^~~~~~

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/uapi/linux/fsmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/fsmap.h b/include/uapi/linux/fsmap.h
index 7e8e5f0bd6d2..99600bbed6b6 100644
--- a/include/uapi/linux/fsmap.h
+++ b/include/uapi/linux/fsmap.h
@@ -68,7 +68,7 @@ struct fsmap_head {
 };
 
 /* Size of an fsmap_head with room for nr records. */
-static inline size_t
+static inline __kernel_size_t
 fsmap_sizeof(
 	unsigned int	nr)
 {
-- 
2.13.3
