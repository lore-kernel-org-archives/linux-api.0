From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] Non-blocking AIO
Date: Fri, 3 Mar 2017 11:50:49 +0100
Message-ID: <CAHO5Pa3Egzwx6eP03OkTyf+xXkhku8cCTO9vUtRMBebZ9xxJ-g@mail.gmail.com>
References: <20170214024603.9563-1-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214024603.9563-1-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api]

Hello Goldwyn,

Since this is a kernel-user-space API change, please CC linux-api@
(and for future iterations of this patch series).

The kernel source file Documentation/SubmitChecklist notes that all
Linux kernel patches that change userspace interfaces should be CCed
to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so that the various parties who are
interested in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Cheers,

Michael



On Tue, Feb 14, 2017 at 3:45 AM, Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org> wrote:
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
> In order to enable this, IOCB_FLAG_NONBLOCKING is introduced in
> uapi/linux/aio_abi.h which translates to IOCB_BLOCKING for struct iocb.
>
> This feature is provided for direct I/O of asynchronous I/O only. I have
> tested it against xfs, ext4, and btrfs.
>
> --
> Goldwyn
>
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
