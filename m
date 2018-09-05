From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/11] UAPI: nilfs2: Fix use of undefined byteswapping
 functions
Date: Wed, 05 Sep 2018 16:55:23 +0100
Message-ID: <153616292366.23468.14988166998690800938.stgit@warthog.procyon.org.uk>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-api@vger.kernel.org

nilfs2 exports a load of inline functions to userspace that call kernel
byteswapping functions that don't exist in UAPI.  Fix this by making it
#include asm/byteorder.h and use the functions declared there.

A better way is probably to remove these inline functions from the nilfs2
header since they are technically broken.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
cc: linux-nilfs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---

 include/uapi/linux/nilfs2_ondisk.h |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index a7e66ab11d1d..d3bd2fe08791 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -29,6 +29,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <asm/byteorder.h>
 
 
 #define NILFS_INODE_BMAP_SIZE	7
@@ -533,19 +534,19 @@ enum {
 static inline void							\
 nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)		\
 {									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |		\
+	cp->cp_flags = __cpu_to_le32(__le32_to_cpu(cp->cp_flags) |	\
 				   (1UL << NILFS_CHECKPOINT_##flag));	\
 }									\
 static inline void							\
 nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)		\
 {									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) &		\
+	cp->cp_flags = __cpu_to_le32(__le32_to_cpu(cp->cp_flags) &	\
 				   ~(1UL << NILFS_CHECKPOINT_##flag));	\
 }									\
 static inline int							\
 nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
 {									\
-	return !!(le32_to_cpu(cp->cp_flags) &				\
+	return !!(__le32_to_cpu(cp->cp_flags) &				\
 		  (1UL << NILFS_CHECKPOINT_##flag));			\
 }
 
@@ -595,20 +596,20 @@ enum {
 static inline void							\
 nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)		\
 {									\
-	su->su_flags = cpu_to_le32(le32_to_cpu(su->su_flags) |		\
+	su->su_flags = __cpu_to_le32(__le32_to_cpu(su->su_flags) |	\
 				   (1UL << NILFS_SEGMENT_USAGE_##flag));\
 }									\
 static inline void							\
 nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)	\
 {									\
 	su->su_flags =							\
-		cpu_to_le32(le32_to_cpu(su->su_flags) &			\
+		__cpu_to_le32(__le32_to_cpu(su->su_flags) &		\
 			    ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
 }									\
 static inline int							\
 nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
 {									\
-	return !!(le32_to_cpu(su->su_flags) &				\
+	return !!(__le32_to_cpu(su->su_flags) &				\
 		  (1UL << NILFS_SEGMENT_USAGE_##flag));			\
 }
 
@@ -619,15 +620,15 @@ NILFS_SEGMENT_USAGE_FNS(ERROR, error)
 static inline void
 nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
 {
-	su->su_lastmod = cpu_to_le64(0);
-	su->su_nblocks = cpu_to_le32(0);
-	su->su_flags = cpu_to_le32(0);
+	su->su_lastmod = __cpu_to_le64(0);
+	su->su_nblocks = __cpu_to_le32(0);
+	su->su_flags = __cpu_to_le32(0);
 }
 
 static inline int
 nilfs_segment_usage_clean(const struct nilfs_segment_usage *su)
 {
-	return !le32_to_cpu(su->su_flags);
+	return !__le32_to_cpu(su->su_flags);
 }
 
 /**
