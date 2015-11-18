From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm: Loosen MADV_NOHUGEPAGE to enable Qemu postcopy on
 s390
Date: Wed, 18 Nov 2015 14:31:54 +0100
Message-ID: <564C7DCA.8010400@suse.cz>
References: <1447341516-18076-1-git-send-email-jjherne@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447341516-18076-1-git-send-email-jjherne-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jason J. Herne" <jjherne-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[CC += linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

Since this is a kernel-user-space API change, please CC linux-api@. The kernel
source file Documentation/SubmitChecklist notes that all Linux kernel patches
that change userspace interfaces should be CCed to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so
that the various parties who are interested in API changes are informed. For
further information, see https://www.kernel.org/doc/man-pages/linux-api-ml.html

On 11/12/2015 04:18 PM, Jason J. Herne wrote:
> MADV_NOHUGEPAGE processing is too restrictive. kvm already disables
> hugepage but hugepage_madvise() takes the error path when we ask to turn
> on the MADV_NOHUGEPAGE bit and the bit is already on. This causes Qemu's
> new postcopy migration feature to fail on s390 because its first action is
> to madvise the guest address space as NOHUGEPAGE. This patch modifies the
> code so that the operation succeeds without error now.
> 
> Signed-off-by: Jason J. Herne <jjherne-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Reviewed-by: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks like the manpage should be fine, as it wasn't very specific wrt these
madvise flags. The only thing that potentially applies is:

"EINVAL advice is not a valid."

which itself looks like it needs fixing. Valid what, value? As in completely
unknown flags, or flags not valid for the given vma?

Anyway, I agree that it doesn't make sense to fail madvise when the given flag
is already set. On the other hand, I don't think the userspace app should fail
just because of madvise failing? It should in general be an advice that the
kernel is also strictly speaking free to ignore as it shouldn't affect
correctnes, just performance. Yeah, there are exceptions today like
MADV_DONTNEED, but that shouldn't apply to hugepages?
So I think Qemu needs fixing too. Also what happens if the kernel is build
without CONFIG_TRANSPARENT_HUGEPAGE? Then madvise also returns EINVAL, how does
Qemu handle that?

> ---
>  mm/huge_memory.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c29ddeb..62fe06b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2009,7 +2009,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  		/*
>  		 * Be somewhat over-protective like KSM for now!
>  		 */
> -		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
> +		if (*vm_flags & VM_NO_THP)
>  			return -EINVAL;
>  		*vm_flags &= ~VM_NOHUGEPAGE;
>  		*vm_flags |= VM_HUGEPAGE;
> @@ -2025,7 +2025,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  		/*
>  		 * Be somewhat over-protective like KSM for now!
>  		 */
> -		if (*vm_flags & (VM_NOHUGEPAGE | VM_NO_THP))
> +		if (*vm_flags & VM_NO_THP)
>  			return -EINVAL;
>  		*vm_flags &= ~VM_HUGEPAGE;
>  		*vm_flags |= VM_NOHUGEPAGE;
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
