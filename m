From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/4] ext4: support STATX_ATTR_VERITY
Date: Tue, 29 Oct 2019 13:41:39 -0700
Message-ID: <20191029204141.145309-3-ebiggers@kernel.org>
References: <20191029204141.145309-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191029204141.145309-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Set the STATX_ATTR_VERITY bit when the statx() system call is used on a
verity file on ext4.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 516faa280ceda8..a7ca6517798008 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5717,12 +5717,15 @@ int ext4_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & EXT4_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (flags & EXT4_VERITY_FL)
+		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP);
+				  STATX_ATTR_NODUMP |
+				  STATX_ATTR_VERITY);
 
 	generic_fillattr(inode, stat);
 	return 0;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog
