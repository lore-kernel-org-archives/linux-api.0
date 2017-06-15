From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 0/10 v12] No wait AIO
Date: Thu, 15 Jun 2017 11:25:28 -0700
Message-ID: <20170615112528.7cbdfd6cdf26a5c13450acdf@linux-foundation.org>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615160002.17233-1-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 15 Jun 2017 10:59:52 -0500 Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org> wrote:

> This series adds nonblocking feature to asynchronous I/O writes.
> io_submit() can be delayed because of a number of reason:
>  - Block allocation for files
>  - Data writebacks for direct I/O
>  - Sleeping because of waiting to acquire i_rwsem
>  - Congested block device
> 
> The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
> any of these conditions are met. This way userspace can push most
> of the write()s to the kernel to the best of its ability to complete
> and if it returns -EAGAIN, can defer it to another thread.
> 
> In order to enable this, IOCB_RW_FLAG_NOWAIT is introduced in
> uapi/linux/aio_abi.h. If set for aio_rw_flags, it translates to
> IOCB_NOWAIT for struct iocb, REQ_NOWAIT for bio.bi_opf and IOMAP_NOWAIT for
> iomap. aio_rw_flags is a new flag replacing aio_reserved1. We could
> not use aio_flags because it is not currently checked for invalidity
> in the kernel.
> 
> This feature is provided for direct I/O of asynchronous I/O only. I have
> tested it against xfs, ext4, and btrfs while I intend to add more filesystems.
> The nowait feature is for request based devices. In the future, I intend to
> add support to stacked devices such as md.
> 
> Applications will have to check supportability by sending a async direct write
> and any other error besides -EAGAIN would mean it is not supported.
> 

How accurate it this?  For example, the changes to
generic_file_direct_write() appear to greatly reduce the chances of
blocking but there are surely race opportunities which will still
result in userspace unexpectedly experiencing blocking in a succeednig
write() call?

If correct then I think there should be some discussion and perhaps
testing results in the changelog.


I have only minor quibbles - I'll grab the patch series for some -next
testing (at least).
