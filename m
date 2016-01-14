From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Wed, 13 Jan 2016 20:57:16 -0800
Message-ID: <20160114045716.GB8006@kroah.com>
References: <565394BE.4040506@codeaurora.org>
 <5696E366.2080605@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5696E366.2080605@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Richard Weinberger <richard.weinberger@gmail.com>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de, Nikolaus Rath <nikolaus@rath.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 13, 2016 at 03:53:10PM -0800, Nikhilesh Reddy wrote:
> Add support for filesystem stacked read/write of files
> when enabled through a userspace init option of FUSE_STACKED_IO.
> 
> When FUSE_STACKED_IO is enabled all the reads and writes
> to the fuse mount point go directly to the native filesystem
> rather than through the fuse daemon. All requests that aren't
> read/write still go thought the userspace code.
> 
> Mmaped I/O is still not supported through stacking and can be
> added in.
> 
> This allows for significantly better performance on read and writes.
> The difference in performance  between fuse and the native lower
> filesystem is negligible.
> 
> There is also a significant cpu/power savings that is achieved which
> is really important on embedded systems that use fuse for I/O.
> 
> Signed-off-by: Nikhilesh Reddy <reddyn@codeaurora.org>
> ---
>  fs/fuse/Makefile          |   2 +-
>  fs/fuse/dev.c             |   4 ++
>  fs/fuse/dir.c             |   3 ++
>  fs/fuse/file.c            |  37 +++++++++++++--
>  fs/fuse/fuse_i.h          |  10 ++++
>  fs/fuse/fuse_stacked.h    |  31 +++++++++++++
>  fs/fuse/inode.c           |   5 ++
>  fs/fuse/stacked_io.c      | 113
> ++++++++++++++++++++++++++++++++++++++++++++++

Your patch is line-wrapped and impossible to apply.

And why cc: me?  This isn't my area of the kernel...

greg k-h
