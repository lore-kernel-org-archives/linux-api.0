From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/36] fs: update documentation for __poll_t
Date: Mon, 19 Mar 2018 19:19:35 -0700
Message-ID: <20180320021935.GH7282@magnolia>
References: <20180305212743.16664-1-hch@lst.de>
 <20180305212743.16664-12-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180305212743.16664-12-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 05, 2018 at 01:27:18PM -0800, Christoph Hellwig wrote:

No commit message... "Update documentation to match the headers"?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/Locking | 2 +-
>  Documentation/filesystems/vfs.txt | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
> index 75d2d57e2c44..220bba28f72b 100644
> --- a/Documentation/filesystems/Locking
> +++ b/Documentation/filesystems/Locking
> @@ -439,7 +439,7 @@ prototypes:
>  	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
>  	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
>  	int (*iterate) (struct file *, struct dir_context *);
> -	unsigned int (*poll) (struct file *, struct poll_table_struct *);
> +	__poll_t (*poll) (struct file *, struct poll_table_struct *);
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>  	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index 5fd325df59e2..f608180ad59d 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -856,7 +856,7 @@ struct file_operations {
>  	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
>  	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
>  	int (*iterate) (struct file *, struct dir_context *);
> -	unsigned int (*poll) (struct file *, struct poll_table_struct *);
> +	__poll_t (*poll) (struct file *, struct poll_table_struct *);
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>  	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
> -- 
> 2.14.2
> 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
