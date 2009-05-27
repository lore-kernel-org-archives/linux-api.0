From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: [RFC v16][PATCH 16/43] c/r: export shmem_getpage() to support shared memory
Date: Wed, 27 May 2009 13:32:42 -0400
Message-ID: <1243445589-32388-17-git-send-email-orenl@cs.columbia.edu>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1243445589-32388-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Export functionality to retrieve specific pages from shared memory
given an inode in shmem-fs; this will be used in the next two patches
to provide support for c/r of shared memory.

mm/shmem.c:
- shmem_getpage() and 'enum sgp_type' moved to linux/mm.h

Signed-off-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
---
 include/linux/mm.h |   11 +++++++++++
 mm/shmem.c         |   15 ++-------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ae70b50..53e916a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -330,6 +330,17 @@ void put_pages_list(struct list_head *pages);
 
 void split_page(struct page *page, unsigned int order);
 
+/* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
+enum sgp_type {
+	SGP_READ,	/* don't exceed i_size, don't allocate page */
+	SGP_CACHE,	/* don't exceed i_size, may allocate page */
+	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
+	SGP_WRITE,	/* may exceed i_size, may allocate page */
+};
+
+extern int shmem_getpage(struct inode *inode, unsigned long idx,
+			 struct page **pagep, enum sgp_type sgp, int *type);
+
 /*
  * Compound pages have a destructor function.  Provide a
  * prototype for that function and accessor functions.
diff --git a/mm/shmem.c b/mm/shmem.c
index b25f95c..f260336 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -99,14 +99,6 @@ static struct vfsmount *shm_mnt;
 /* Pretend that each entry is of this size in directory's i_size */
 #define BOGO_DIRENT_SIZE 20
 
-/* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
-enum sgp_type {
-	SGP_READ,	/* don't exceed i_size, don't allocate page */
-	SGP_CACHE,	/* don't exceed i_size, may allocate page */
-	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
-	SGP_WRITE,	/* may exceed i_size, may allocate page */
-};
-
 #ifdef CONFIG_TMPFS
 static unsigned long shmem_default_max_blocks(void)
 {
@@ -119,9 +111,6 @@ static unsigned long shmem_default_max_inodes(void)
 }
 #endif
 
-static int shmem_getpage(struct inode *inode, unsigned long idx,
-			 struct page **pagep, enum sgp_type sgp, int *type);
-
 static inline struct page *shmem_dir_alloc(gfp_t gfp_mask)
 {
 	/*
@@ -1202,8 +1191,8 @@ static inline struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache
  */
-static int shmem_getpage(struct inode *inode, unsigned long idx,
-			struct page **pagep, enum sgp_type sgp, int *type)
+int shmem_getpage(struct inode *inode, unsigned long idx,
+		  struct page **pagep, enum sgp_type sgp, int *type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
