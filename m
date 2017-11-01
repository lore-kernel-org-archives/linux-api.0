From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 03/18] dax: Simplify arguments of dax_insert_mapping()
Date: Wed,  1 Nov 2017 16:36:32 +0100
Message-ID: <20171101153648.30166-4-jack@suse.cz>
References: <20171101153648.30166-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20171101153648.30166-1-jack-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

dax_insert_mapping() has lots of arguments and a lot of them is actuall
duplicated by passing vm_fault structure as well. Change the function to
take the same arguments as dax_pmd_insert_mapping().

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f001d8c72a06..0bc42ac294ca 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -820,23 +820,30 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-static int dax_insert_mapping(struct address_space *mapping,
-		struct block_device *bdev, struct dax_device *dax_dev,
-		sector_t sector, size_t size, void *entry,
-		struct vm_area_struct *vma, struct vm_fault *vmf)
+static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
+{
+	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
+}
+
+static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
+			      loff_t pos, void *entry)
 {
+	const sector_t sector = dax_iomap_sector(iomap, pos);
+	struct vm_area_struct *vma = vmf->vma;
+	struct address_space *mapping = vma->vm_file->f_mapping;
 	unsigned long vaddr = vmf->address;
 	void *ret, *kaddr;
 	pgoff_t pgoff;
 	int id, rc;
 	pfn_t pfn;
 
-	rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
 	if (rc)
 		return rc;
 
 	id = dax_read_lock();
-	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
+	rc = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(PAGE_SIZE),
+			       &kaddr, &pfn);
 	if (rc < 0) {
 		dax_read_unlock(id);
 		return rc;
@@ -936,11 +943,6 @@ int __dax_zero_page_range(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
-static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
-{
-	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
-}
-
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -1087,7 +1089,6 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
-	sector_t sector;
 	struct iomap iomap = { 0 };
 	unsigned flags = IOMAP_FAULT;
 	int error, major = 0;
@@ -1140,9 +1141,9 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		goto error_finish_iomap;
 	}
 
-	sector = dax_iomap_sector(&iomap, pos);
-
 	if (vmf->cow_page) {
+		sector_t sector = dax_iomap_sector(&iomap, pos);
+
 		switch (iomap.type) {
 		case IOMAP_HOLE:
 		case IOMAP_UNWRITTEN:
@@ -1175,8 +1176,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_insert_mapping(mapping, iomap.bdev, iomap.dax_dev,
-				sector, PAGE_SIZE, entry, vmf->vma, vmf);
+		error = dax_insert_mapping(vmf, &iomap, pos, entry);
 		/* -EBUSY is fine, somebody else faulted on the same PTE */
 		if (error == -EBUSY)
 			error = 0;
-- 
2.12.3
