From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] fs: Add dirreadahead syscall and VFS hooks
Date: Thu, 31 Jul 2014 13:31:56 +1000
Message-ID: <20140731033156.GQ26465@dastard>
References: <1406309851-10628-1-git-send-email-adas@redhat.com>
 <1406309851-10628-2-git-send-email-adas@redhat.com>
 <CAHO5Pa2fW6mZRTao3uEx2p_X9GvO1btrbb9Bg2ns94+p4biKAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHO5Pa2fW6mZRTao3uEx2p_X9GvO1btrbb9Bg2ns94+p4biKAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cluster-devel <cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 29, 2014 at 10:21:50AM +0200, Michael Kerrisk wrote:
> [CC+=linux-api]
> 
> On Fri, Jul 25, 2014 at 7:37 PM, Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Also adds a void *opaque field to struct dir_context that can be
> > used by filesystems to temporarily store any context as this
> > struct gets passed around in the fs.

So the prototype is:

int dir_readahead(int fd, off64_t offset, unsigned int count);

Why do we need a new syscall for this?

$ man 2 readahead
....
ssize_t readahead(int fd, off64_t offset, size_t count);
....
	EINVAL fd does not refer to a file type to which readahead() can be applied.


Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
