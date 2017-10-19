From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 04/17] dax: Factor out getting of pfn out of iomap
Date: Thu, 19 Oct 2017 14:58:03 +0200
Message-ID: <20171019125817.11580-5-jack@suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20171019125817.11580-1-jack-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Factor out code to get pfn out of iomap that is shared between PTE and
PMD fault path.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 83 +++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 0bc42ac294ca..116eef8d6c69 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -825,30 +825,53 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
 }
 
-static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
-			      loff_t pos, void *entry)
+static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
+			 pfn_t *pfnp)
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
-	struct vm_area_struct *vma = vmf->vma;
-	struct address_space *mapping = vma->vm_file->f_mapping;
-	unsigned long vaddr = vmf->address;
-	void *ret, *kaddr;
 	pgoff_t pgoff;
+	void *kaddr;
 	int id, rc;
-	pfn_t pfn;
+	long length;
 
-	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
+	rc = bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
 	if (rc)
 		return rc;
-
 	id = dax_read_lock();
-	rc = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(PAGE_SIZE),
-			       &kaddr, &pfn);
-	if (rc < 0) {
-		dax_read_unlock(id);
-		return rc;
+	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
+				   &kaddr, pfnp);
+	if (length < 0) {
+		rc = length;
+		goto out;
 	}
+	rc = -EINVAL;
+	if (PFN_PHYS(length) < size)
+		goto out;
+	if (pfn_t_to_pfn(*pfnp) & (PHYS_PFN(size)-1))
+		goto out;
+	/* For larger pages we need devmap */
+	if (length > 1 && !pfn_t_devmap(*pfnp))
+		goto out;
+	rc = 0;
+out:
 	dax_read_unlock(id);
+	return rc;
+}
+
+static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
+			      loff_t pos, void *entry)
+{
+	const sector_t sector = dax_iomap_sector(iomap, pos);
+	struct vm_area_struct *vma = vmf->vma;
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	unsigned long vaddr = vmf->address;
+	void *ret;
+	int rc;
+	pfn_t pfn;
+
+	rc = dax_iomap_pfn(iomap, pos, PAGE_SIZE, &pfn);
+	if (rc < 0)
+		return rc;
 
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector, 0);
 	if (IS_ERR(ret))
@@ -1223,46 +1246,26 @@ static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	const sector_t sector = dax_iomap_sector(iomap, pos);
-	struct dax_device *dax_dev = iomap->dax_dev;
-	struct block_device *bdev = iomap->bdev;
 	struct inode *inode = mapping->host;
-	const size_t size = PMD_SIZE;
-	void *ret = NULL, *kaddr;
-	long length = 0;
-	pgoff_t pgoff;
+	void *ret = NULL;
 	pfn_t pfn = {};
-	int id;
+	int rc;
 
-	if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0)
+	rc = dax_iomap_pfn(iomap, pos, PMD_SIZE, &pfn);
+	if (rc < 0)
 		goto fallback;
 
-	id = dax_read_lock();
-	length = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
-	if (length < 0)
-		goto unlock_fallback;
-	length = PFN_PHYS(length);
-
-	if (length < size)
-		goto unlock_fallback;
-	if (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR)
-		goto unlock_fallback;
-	if (!pfn_t_devmap(pfn))
-		goto unlock_fallback;
-	dax_read_unlock(id);
-
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector,
 			RADIX_DAX_PMD);
 	if (IS_ERR(ret))
 		goto fallback;
 
-	trace_dax_pmd_insert_mapping(inode, vmf, length, pfn, ret);
+	trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, ret);
 	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
 			pfn, vmf->flags & FAULT_FLAG_WRITE);
 
-unlock_fallback:
-	dax_read_unlock(id);
 fallback:
-	trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret);
+	trace_dax_pmd_insert_mapping_fallback(inode, vmf, PMD_SIZE, pfn, ret);
 	return VM_FAULT_FALLBACK;
 }
 
-- 
2.12.3
