From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 3/3] statx: add STATX_ATTRIBUTES flag
Date: Thu, 18 Oct 2018 15:11:25 +0200
Message-ID: <20181018131125.6303-3-mszeredi@redhat.com>
References: <20181018131125.6303-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018131125.6303-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

FUSE will want to know if stx_attributes is interesting or not, because
there's a non-zero cost of retreiving it.

This is more of a "want" flag, since stx_attributes_mask already indicates
whether we "got" stx_attributes or not.  So for now we can just deal with
this flag in the generic code.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 fs/stat.c                       | 3 +++
 include/uapi/linux/stat.h       | 1 +
 samples/statx/test-statx.c      | 2 +-
 tools/include/uapi/linux/stat.h | 1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index 8d297a279991..6bf86d57e2e3 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -535,6 +535,9 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_size = stat->size;
 	tmp.stx_blocks = stat->blocks;
 	tmp.stx_attributes_mask = stat->attributes_mask;
+	/* Having anything in attributes_mask means attributes are valid. */
+	if (tmp.stx_attributes_mask)
+		tmp.stx_mask |= STATX_ATTRIBUTES;
 	tmp.stx_atime.tv_sec = stat->atime.tv_sec;
 	tmp.stx_atime.tv_nsec = stat->atime.tv_nsec;
 	tmp.stx_btime.tv_sec = stat->btime.tv_sec;
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 370f09d92fa6..aef0aba5dfe7 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -148,6 +148,7 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
+#define STATX_ATTRIBUTES	0x00001000U	/* Want/got stx_attributes */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
diff --git a/samples/statx/test-statx.c b/samples/statx/test-statx.c
index e354048dea3c..deef9a68ff68 100644
--- a/samples/statx/test-statx.c
+++ b/samples/statx/test-statx.c
@@ -211,7 +211,7 @@ int main(int argc, char **argv)
 	struct statx stx;
 	int ret, raw = 0, atflag = AT_SYMLINK_NOFOLLOW;
 
-	unsigned int mask = STATX_BASIC_STATS | STATX_BTIME;
+	unsigned int mask = STATX_BASIC_STATS | STATX_BTIME | STATX_ATTRIBUTES;
 
 	for (argv++; *argv; argv++) {
 		if (strcmp(*argv, "-F") == 0) {
diff --git a/tools/include/uapi/linux/stat.h b/tools/include/uapi/linux/stat.h
index 370f09d92fa6..aef0aba5dfe7 100644
--- a/tools/include/uapi/linux/stat.h
+++ b/tools/include/uapi/linux/stat.h
@@ -148,6 +148,7 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
+#define STATX_ATTRIBUTES	0x00001000U	/* Want/got stx_attributes */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
-- 
2.14.3
