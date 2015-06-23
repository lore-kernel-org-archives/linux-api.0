From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 10/23] userfaultfd: add new syscall to provide memory
 externalization
Date: Tue, 23 Jun 2015 12:00:19 -0700
Message-ID: <5589ACC3.3060401@intel.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com> <1431624680-20153-11-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431624680-20153-11-git-send-email-aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhang.zhanghailiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/14/2015 10:31 AM, Andrea Arcangeli wrote:
> +static int userfaultfd_wake_function(wait_queue_t *wq, unsigned mode,
> +				     int wake_flags, void *key)
> +{
> +	struct userfaultfd_wake_range *range = key;
> +	int ret;
> +	struct userfaultfd_wait_queue *uwq;
> +	unsigned long start, len;
> +
> +	uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
> +	ret = 0;
> +	/* don't wake the pending ones to avoid reads to block */
> +	if (uwq->pending && !ACCESS_ONCE(uwq->ctx->released))
> +		goto out;
> +	/* len == 0 means wake all */
> +	start = range->start;
> +	len = range->len;
> +	if (len && (start > uwq->address || start + len <= uwq->address))
> +		goto out;
> +	ret = wake_up_state(wq->private, mode);
> +	if (ret)
> +		/* wake only once, autoremove behavior */
> +		list_del_init(&wq->task_list);
> +out:
> +	return ret;
> +}
...
> +static __always_inline int validate_range(struct mm_struct *mm,
> +					  __u64 start, __u64 len)
> +{
> +	__u64 task_size = mm->task_size;
> +
> +	if (start & ~PAGE_MASK)
> +		return -EINVAL;
> +	if (len & ~PAGE_MASK)
> +		return -EINVAL;
> +	if (!len)
> +		return -EINVAL;
> +	if (start < mmap_min_addr)
> +		return -EINVAL;
> +	if (start >= task_size)
> +		return -EINVAL;
> +	if (len > task_size - start)
> +		return -EINVAL;
> +	return 0;
> +}

Hey Andrea,

Down in userfaultfd_wake_function(), it looks like you intended for a
len=0 to mean "wake all".  But the validate_range() that we do from
userspace has a !len check in it, which keeps us from passing a len=0 in
from userspace.

Was that "wake all" for some internal use, or is the check too strict?

I was trying to use the wake ioctl after an madvise() (as opposed to
filling things in using a userfd copy).
