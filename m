From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Fri, 15 Jan 2016 01:29:49 -0800
Message-ID: <20160115092949.GA11468@infradead.org>
References: <565394BE.4040506@codeaurora.org>
 <5696E366.2080605@codeaurora.org>
 <20160114082554.GA12489@infradead.org>
 <87mvs8qhun.fsf@thinkpad.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mvs8qhun.fsf-Zv899e0YUSYPWKMTL/zdXNi2O/JbrIOy@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 14, 2016 at 07:52:00AM -0800, Nikolaus Rath wrote:
> > Please write your stacked features as kernel drivers.
> 
> Could you explain in more detail? I think I don't understand either the
> why, the how, or what you mean with driver in this context (not sure
> which one it is). 
> 
> 
> (I'm not the original submitter but interested in this)


If someone is doing stacked pass through I/O, which basically is some
form of unioning or file hiding it should be using overlayfs or a new
kernel stackable file system.  That's not to say it could be prototyped
entirely in userspace, but it's not something we should add any bypasses
for.
