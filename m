From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v5 12/16] fs-verity: add SHA-512 support
Date: Thu, 20 Jun 2019 13:50:39 -0700
Message-ID: <20190620205043.64350-13-ebiggers@kernel.org>
References: <20190620205043.64350-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190620205043.64350-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add SHA-512 support to fs-verity.  This is primarily a demonstration of
the trivial changes needed to support a new hash algorithm in fs-verity;
most users will still use SHA-256, due to the smaller space required to
store the hashes.  But some users may prefer SHA-512.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/fsverity_private.h  | 2 +-
 fs/verity/hash_algs.c         | 5 +++++
 include/uapi/linux/fsverity.h | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index eaa2b3b93bbf6b..02a547f0667c13 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -29,7 +29,7 @@ struct ahash_request;
  * Largest digest size among all hash algorithms supported by fs-verity.
  * Currently assumed to be <= size of fsverity_descriptor::root_hash.
  */
-#define FS_VERITY_MAX_DIGEST_SIZE	SHA256_DIGEST_SIZE
+#define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
 
 /* A hash algorithm supported by fs-verity */
 struct fsverity_hash_alg {
diff --git a/fs/verity/hash_algs.c b/fs/verity/hash_algs.c
index 46df17094fc252..e0462a010cabfb 100644
--- a/fs/verity/hash_algs.c
+++ b/fs/verity/hash_algs.c
@@ -17,6 +17,11 @@ struct fsverity_hash_alg fsverity_hash_algs[] = {
 		.digest_size = SHA256_DIGEST_SIZE,
 		.block_size = SHA256_BLOCK_SIZE,
 	},
+	[FS_VERITY_HASH_ALG_SHA512] = {
+		.name = "sha512",
+		.digest_size = SHA512_DIGEST_SIZE,
+		.block_size = SHA512_BLOCK_SIZE,
+	},
 };
 
 /**
diff --git a/include/uapi/linux/fsverity.h b/include/uapi/linux/fsverity.h
index 57d1d7fc0c345a..da0daf6c193b4b 100644
--- a/include/uapi/linux/fsverity.h
+++ b/include/uapi/linux/fsverity.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 
 #define FS_VERITY_HASH_ALG_SHA256	1
+#define FS_VERITY_HASH_ALG_SHA512	2
 
 struct fsverity_enable_arg {
 	__u32 version;
-- 
2.22.0.410.gd8fdbe21b5-goog
