From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 11/17] dax: Allow tuning whether dax_insert_mapping_entry()
 dirties entry
Date: Thu, 19 Oct 2017 14:58:10 +0200
Message-ID: <20171019125817.11580-12-jack@suse.cz>
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

Currently we dirty radix tree entry whenever dax_insert_mapping_entry()
gets called for a write fault. With synchronous page faults we would
like to insert clean radix tree entry and dirty it only once we call
fdatasync() and update page tables to save some unnecessary cache
flushing. Add 'dirty' argument to dax_insert_mapping_entry() for that.

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5ddf15161390..efc210ff6665 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -526,13 +526,13 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 static void *dax_insert_mapping_entry(struct address_space *mapping,
 				      struct vm_fault *vmf,
 				      void *entry, sector_t sector,
-				      unsigned long flags)
+				      unsigned long flags, bool dirty)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
 	void *new_entry;
 	pgoff_t index = vmf->pgoff;
 
-	if (vmf->flags & FAULT_FLAG_WRITE)
+	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
 	if (dax_is_zero_entry(entry) && !(flags & RADIX_DAX_ZERO_PAGE)) {
@@ -569,7 +569,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 		entry = new_entry;
 	}
 
-	if (vmf->flags & FAULT_FLAG_WRITE)
+	if (dirty)
 		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
 
 	spin_unlock_irq(&mapping->tree_lock);
@@ -881,7 +881,7 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
 	}
 
 	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, 0,
-			RADIX_DAX_ZERO_PAGE);
+			RADIX_DAX_ZERO_PAGE, false);
 	if (IS_ERR(entry2)) {
 		ret = VM_FAULT_SIGBUS;
 		goto out;
@@ -1182,7 +1182,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry,
 						 dax_iomap_sector(&iomap, pos),
-						 0);
+						 0, write);
 		if (IS_ERR(entry)) {
 			error = PTR_ERR(entry);
 			goto error_finish_iomap;
@@ -1258,7 +1258,7 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 		goto fallback;
 
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, 0,
-			RADIX_DAX_PMD | RADIX_DAX_ZERO_PAGE);
+			RADIX_DAX_PMD | RADIX_DAX_ZERO_PAGE, false);
 	if (IS_ERR(ret))
 		goto fallback;
 
@@ -1379,7 +1379,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry,
 						dax_iomap_sector(&iomap, pos),
-						RADIX_DAX_PMD);
+						RADIX_DAX_PMD, write);
 		if (IS_ERR(entry))
 			goto finish_iomap;
 
-- 
2.12.3
