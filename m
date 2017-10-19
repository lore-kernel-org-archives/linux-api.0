From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 07/17] dax: Inline dax_insert_mapping() into the callsite
Date: Thu, 19 Oct 2017 14:58:06 +0200
Message-ID: <20171019125817.11580-8-jack@suse.cz>
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

dax_insert_mapping() has only one callsite and we will need to further
fine tune what it does for synchronous faults. Just inline it into the
callsite so that we don't have to pass awkward bools around.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5ea71381dba0..5b20c6456926 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -858,32 +858,6 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 	return rc;
 }
 
-static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
-			      loff_t pos, void *entry)
-{
-	const sector_t sector = dax_iomap_sector(iomap, pos);
-	struct vm_area_struct *vma = vmf->vma;
-	struct address_space *mapping = vma->vm_file->f_mapping;
-	unsigned long vaddr = vmf->address;
-	void *ret;
-	int rc;
-	pfn_t pfn;
-
-	rc = dax_iomap_pfn(iomap, pos, PAGE_SIZE, &pfn);
-	if (rc < 0)
-		return rc;
-
-	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector, 0);
-	if (IS_ERR(ret))
-		return PTR_ERR(ret);
-
-	trace_dax_insert_mapping(mapping->host, vmf, ret);
-	if (vmf->flags & FAULT_FLAG_WRITE)
-		return vm_insert_mixed_mkwrite(vma, vaddr, pfn);
-	else
-		return vm_insert_mixed(vma, vaddr, pfn);
-}
-
 /*
  * The user has performed a load from a hole in the file.  Allocating a new
  * page in the file would cause excessive storage usage for workloads with
@@ -1119,6 +1093,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	int vmf_ret = 0;
 	void *entry;
+	pfn_t pfn;
 
 	trace_dax_pte_fault(inode, vmf, vmf_ret);
 	/*
@@ -1201,7 +1176,24 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_insert_mapping(vmf, &iomap, pos, entry);
+		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
+		if (error < 0)
+			goto error_finish_iomap;
+
+		entry = dax_insert_mapping_entry(mapping, vmf, entry,
+						 dax_iomap_sector(&iomap, pos),
+						 0);
+		if (IS_ERR(entry)) {
+			error = PTR_ERR(entry);
+			goto error_finish_iomap;
+		}
+
+		trace_dax_insert_mapping(inode, vmf, entry);
+		if (write)
+			error = vm_insert_mixed_mkwrite(vma, vaddr, pfn);
+		else
+			error = vm_insert_mixed(vma, vaddr, pfn);
+
 		/* -EBUSY is fine, somebody else faulted on the same PTE */
 		if (error == -EBUSY)
 			error = 0;
-- 
2.12.3
