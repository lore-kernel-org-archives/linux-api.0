From: "Andrew Karpow" <andy-AJ3FZg74QxY@public.gmane.org>
Subject: =?utf-8?q?Re=3A?==?utf-8?q?_=5Bfuse-devel=5D?==?utf-8?q?_=5BPATCH?=
 =?utf-8?q?_v5=5D?==?utf-8?q?_fuse=3A?= Add support for passthrough
 =?utf-8?q?read=2Fwrite?=
Date: Fri, 04 Mar 2016 13:23:48 +0100
Message-ID: <3ee-56d97e80-3b-4a1d2580@40597794>
References: <56AFAA5B.3000006@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
in-reply-to: <56AFAA5B.3000006-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Mike Shal <marfey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!

Thanks for the passthrough patch, exactly what I was searching for.
I'am currently trying to port your code to a prehistoric RedHat 6 Kernel, but I wonder about some implementation details...
 
> +++ b/fs/fuse/passthrough.c
...
> +void fuse_setup_passthrough(struct fuse_conn *fc, struct fuse_req *req)
..
> +	daemon_fd = (int)open_out->passthrough_fd;
...

> +++ b/include/uapi/linux/fuse.h
...
> @@ -480,7 +481,7 @@ struct fuse_create_in {
>  struct fuse_open_out {
>  	uint64_t	fh;
>  	uint32_t	open_flags;
> -	uint32_t	padding;
> +	int32_t         passthrough_fd;
>  };
 
I don't get where the passthrough_fd struct member is ever set?

with best regards,

Andy
