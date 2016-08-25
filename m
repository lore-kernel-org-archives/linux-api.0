From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] iomap: add a flag to report shared extents
Date: Thu, 25 Aug 2016 16:31:20 -0700
Message-ID: <147216788009.525.789325200721590680.stgit@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147216784041.525.7722906502172299465.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/iomap.c            |    2 ++
 include/linux/iomap.h |    1 +
 2 files changed, 3 insertions(+)


diff --git a/fs/iomap.c b/fs/iomap.c
index e9b3f99..ec411a6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -512,6 +512,8 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 
 	if (iomap->flags & IOMAP_F_MERGED)
 		flags |= FIEMAP_EXTENT_MERGED;
+	if (iomap->flags & IOMAP_F_SHARED)
+		flags |= FIEMAP_EXTENT_SHARED;
 
 	return fiemap_fill_next_extent(fi, iomap->offset,
 			iomap->blkno != IOMAP_NULL_BLOCK ? iomap->blkno << 9: 0,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3a56212..c74226a 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -22,6 +22,7 @@ struct vm_fault;
  * Flags for iomap mappings:
  */
 #define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
+#define IOMAP_F_SHARED	0x02	/* block shared with another file */
 
 /*
  * Magic value for blkno:
