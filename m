From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 3/5] statx: add STATX_ATTRIBUTES flag
Date: Fri, 19 Oct 2018 14:20:47 +0200
Message-ID: <20181019122049.27121-3-mszeredi@redhat.com>
References: <20181019122049.27121-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019122049.27121-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

FUSE will want to know if stx_attributes is interesting or not, because
there's a non-zero cost of retreiving it.

This just a "want" flag, since stx_attributes_mask already indicates
whether we "got" stx_attributes or not.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 include/uapi/linux/stat.h       | 1 +
 samples/statx/test-statx.c      | 2 +-
 tools/include/uapi/linux/stat.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index ed456ac0f90d..7d3cce078652 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -148,6 +148,7 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
+#define STATX_ATTRIBUTES	0x00001000U	/* Want stx_attributes */
 
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
index ed456ac0f90d..60cd0a3f52e7 100644
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
