From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/11] UAPI: nilfs2: Fix use of undefined byteswapping
 functions [ver #2]
Date: Thu, 06 Sep 2018 10:19:17 +0100
Message-ID: <153622555770.14298.17748806314555967351.stgit@warthog.procyon.org.uk>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
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

 include/uapi/linux/nilfs2_ondisk.h |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index a7e66ab11d1d..47f8f596ff1c 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -29,6 +29,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <asm/byteorder.h>
 
 
 #define NILFS_INODE_BMAP_SIZE	7
@@ -533,20 +534,17 @@ enum {
 static inline void							\
 nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)		\
 {									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |		\
-				   (1UL << NILFS_CHECKPOINT_##flag));	\
+	cp->cp_flags |= __cpu_to_le32(1UL << NILFS_CHECKPOINT_##flag);	\
 }									\
 static inline void							\
 nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)		\
 {									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) &		\
-				   ~(1UL << NILFS_CHECKPOINT_##flag));	\
+	cp->cp_flags &= __cpu_to_le32(~(1UL << NILFS_CHECKPOINT_##flag)); \
 }									\
 static inline int							\
 nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
 {									\
-	return !!(le32_to_cpu(cp->cp_flags) &				\
-		  (1UL << NILFS_CHECKPOINT_##flag));			\
+	return !!(cp->cp_flags & __cpu_to_le32(1UL << NILFS_CHECKPOINT_##flag)); \
 }
 
 NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
@@ -595,21 +593,17 @@ enum {
 static inline void							\
 nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)		\
 {									\
-	su->su_flags = cpu_to_le32(le32_to_cpu(su->su_flags) |		\
-				   (1UL << NILFS_SEGMENT_USAGE_##flag));\
+	su->su_flags |= __cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_##flag); \
 }									\
 static inline void							\
 nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)	\
 {									\
-	su->su_flags =							\
-		cpu_to_le32(le32_to_cpu(su->su_flags) &			\
-			    ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
+	su->su_flags &= __cpu_to_le32(~(1UL << NILFS_SEGMENT_USAGE_##flag)); \
 }									\
 static inline int							\
 nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
 {									\
-	return !!(le32_to_cpu(su->su_flags) &				\
-		  (1UL << NILFS_SEGMENT_USAGE_##flag));			\
+	return !!(su->su_flags & __cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_##flag)); \
 }
 
 NILFS_SEGMENT_USAGE_FNS(ACTIVE, active)
@@ -619,15 +613,15 @@ NILFS_SEGMENT_USAGE_FNS(ERROR, error)
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
+	return !su->su_flags;
 }
 
 /**
