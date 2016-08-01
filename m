From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] vfs: cap dedupe request structure size at PAGE_SIZE
Date: Sun, 31 Jul 2016 23:31:28 -0700
Message-ID: <20160801063128.GA15590@infradead.org>
References: <20160728183534.GB15753@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160728183534.GB15753-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 28, 2016 at 11:35:34AM -0700, Darrick J. Wong wrote:
> Kirill A. Shutemov reports that the kernel doesn't try to cap dest_count
> in any way, and uses the number to allocate kernel memory.  This causes
> high order allocation warnings in the kernel log if someone passes in a
> big enough value.  We should clamp the allocation at PAGE_SIZE to avoid
> stressing the VM.
> 
> The two existing users of the dedupe ioctl never send more than 120
> requests, so we can safely clamp dest_range at PAGE_SIZE, because with
> 4k pages we can handle up to 127 dedupe candidates.  Given the max
> extent length of 16MB, we can end up doing 2GB of IO which is plenty.

Looks fine,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

> @@ -582,6 +582,10 @@ static int ioctl_file_dedupe_range(struct file *file, void __user *arg)

This function returns long in mainline.  Maybe you should resend your
return type fix to Al while you're at it?
