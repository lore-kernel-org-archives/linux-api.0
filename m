From: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Subject: Re: [PATCH v4] fuse: Add support for passthrough read/write
Date: Thu, 21 Jan 2016 13:38:32 +0100
Message-ID: <56A0D148.7080508@fastmail.fm>
References: <56A0235E.8090205@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A0235E.8090205-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 01/21/2016 01:16 AM, Nikhilesh Reddy wrote:
> Add support for filesystem passthrough read/write of files
> when enabled in userspace through the option FUSE_PASSTHROUGH.
> 
> There are many FUSE based filesystems that perform checks or
> enforce policy or perform some kind of decision making in certain
> functions like the "open" call but simply act as a "passthrough"
> when performing operations such as read or write.
> 
> When FUSE_PASSTHROUGH is enabled all the reads and writes
> to the fuse mount point go directly to the passthrough filesystem
> i.e a native filesystem that actually hosts the files rather than
> through the fuse daemon. All requests that aren't read/write still
> go thought the userspace code.
> 
> This allows for significantly better performance on read and writes.
> The difference in performance between fuse and the native lower
> filesystem is negligible.
> 
> There is also a significant cpu/power savings that is achieved which
> is really important on embedded systems that use fuse for I/O.
> 
> Signed-off-by: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

I think it is common style to add a change log between patch set
versions in the patch description.


Bernd
