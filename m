From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] fsmap: fix documentation of FMR_OF_LAST
Date: Thu, 31 Aug 2017 13:49:18 -0700
Message-ID: <20170831204918.GA7404@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
To: xfs <linux-xfs@vger.kernel.org>
Cc: linux-api@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

The FMR_OF_LAST flag is set on the last fsmap record being returned for
the dataset requested, contrary to what the header file says.  Fix the
docs to reflect the behavior of all fsmap implementations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/uapi/linux/fsmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/fsmap.h b/include/uapi/linux/fsmap.h
index 7e8e5f0b..e5213c3 100644
--- a/include/uapi/linux/fsmap.h
+++ b/include/uapi/linux/fsmap.h
@@ -96,7 +96,7 @@ fsmap_advance(
 #define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
 #define FMR_OF_SHARED		0x8	/* segment = shared with another file */
 #define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
-#define FMR_OF_LAST		0x20	/* segment is the last in the FS */
+#define FMR_OF_LAST		0x20	/* segment is the last in the dataset */
 
 /* Each FS gets to define its own special owner codes. */
 #define FMR_OWNER(type, code)	(((__u64)type << 32) | \
