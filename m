From: Oscar Salvador <osalvador@suse.de>
Subject: Re: mremap vs sysctl_max_map_count
Date: Tue, 19 Feb 2019 16:53:24 +0100
Message-ID: <20190219155320.tkfkwvqk53tfdojt@d104.suse.de>
References: <20190218083326.xsnx7cx2lxurbmux@d104.suse.de>
 <a11a10b5-4a31-2537-7b14-83f4b22e5f6c@suse.cz>
 <20190218111535.dxkm7w7c2edgl2lh@kshutemo-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190218111535.dxkm7w7c2edgl2lh@kshutemo-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hughd@google.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 18, 2019 at 02:15:35PM +0300, Kirill A. Shutemov wrote:
> On Mon, Feb 18, 2019 at 10:57:18AM +0100, Vlastimil Babka wrote:
> > IMHO it makes sense to do all such resource limit checks upfront. It
> > should all be protected by mmap_sem and thus stable, right? Even if it
> > was racy, I'd think it's better to breach the limit a bit due to a race
> > than bail out in the middle of operation. Being also resilient against
> > "real" ENOMEM's due to e.g. failure to alocate a vma would be much
> > harder perhaps (but maybe it's already mostly covered by the
> > too-small-to-fail in page allocator), but I'd try with the artificial
> > limits at least.
> 
> There's slight chance of false-postive -ENOMEM with upfront approach:
> unmapping can reduce number of VMAs so in some cases upfront check would
> fail something that could succeed otherwise.
> 
> We could check also what number of VMA unmap would free (if any). But it
> complicates the picture and I don't think worth it in the end.

I came up with an approach which tries to check how many vma's are we going
to split and the number of vma's that we are going to free.
I did several tests and it worked for me, but I am not sure if I overlooked
something due to false assumptions.
I am also not sure either if the extra code is worth, but from my POV
it could avoid such cases where we unmap regions but move_vma()
is not going to succeed at all.


It is not yet complete (sanity checks are missing), but I wanted to show it
to see whether it is something that is worth spending time with:

diff --git a/mm/mremap.c b/mm/mremap.c
index 3320616ed93f..f504c29d2af4 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -494,6 +494,51 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
 	return vma;
 }
 
+static int pre_compute_maps(unsigned long addr, unsigned long len)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *vma_end;
+	unsigned long end;
+	int maps_needed = 0;
+
+	end = addr + len;
+
+	vma = find_vma(mm, addr);
+	if (!vma)
+		return 0;
+	vma_end = find_vma(mm, end);
+
+	if (addr >= vma->vm_start && end <= vma->vm_end) {
+		/*
+		 * Possible outcomes when dealing with a single vma:
+		 * the vma will be entirely removed: map_count will be decremented by 1
+		 * it needs to be split in 2 before unmapping: map_count not changed
+		 * it needs to be split in 3 before unmapping: map_count incremented by 1
+		 */
+		if (addr > vma->vm_start && end < vma->vm_end)
+			maps_needed++;
+		else if (addr == vma->vm_start && end == vma->vm_end)
+			maps_needed--;
+	} else {
+		struct vm_area_struct *tmp = vma;
+		int vmas;
+
+		if (addr > tmp->vm_start)
+			vmas = -1;
+		else
+			vmas = 0;
+
+		while (tmp != vma_end) {
+			if (end >= tmp->vm_end)
+				vmas++;
+			tmp = tmp->vm_next;
+		}
+		maps_needed -= vmas;
+	}
+
+	return maps_needed;
+}
+
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 		unsigned long new_addr, unsigned long new_len, bool *locked,
 		struct vm_userfaultfd_ctx *uf,
@@ -516,6 +561,24 @@ static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 	if (addr + old_len > new_addr && new_addr + new_len > addr)
 		goto out;
 
+	/*
+	 * Worst-scenario case is when a vma gets split in 3 before unmaping it.
+	 * So, that would mean 2 (1 for new_addr and 1 for addr) more maps to
+	 * the ones we already hold.
+	 * If that is the case, let us check further if we are going to free
+	 * enough to go beyond the check in move_vma().
+	 */
+	if ((mm->map_count + 2) >= sysctl_max_map_count - 3) {
+		int maps_needed = 0;
+
+		maps_needed += pre_compute_maps(new_addr, new_len);
+		if (old_len > new_len)
+			maps_needed += pre_compute_maps(addr + new_len, old_len - new_len);
+
+		if ((mm->map_count + maps_needed) >= sysctl_max_map_count - 3)
+			return -ENOMEM;
+	}
+
 	ret = do_munmap(mm, new_addr, new_len, uf_unmap_early);
 	if (ret)
 		goto out;
Thanks
-- 
Oscar Salvador
SUSE L3
