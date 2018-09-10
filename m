From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 2/2] vfs: dedupe should return EPERM if permission is not granted
Date: Mon, 10 Sep 2018 16:21:18 -0700
Message-ID: <20180910232118.14424-3-mfasheh@suse.de>
References: <20180910232118.14424-1-mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20180910232118.14424-1-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>
List-Id: linux-api@vger.kernel.org

Right now we return EINVAL if a process does not have permission to dedupe a
file. This was an oversight on my part. EPERM gives a true description of
the nature of our error, and EINVAL is already used for the case that the
filesystem does not support dedupe.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index be0e8723a049..c734bc2880a5 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1991,7 +1991,7 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	if (ret < 0)
 		goto out_drop_write;
 
-	ret = -EINVAL;
+	ret = -EPERM;
 	if (!allow_file_dedupe(dst_file))
 		goto out_drop_write;
 
-- 
2.15.1
