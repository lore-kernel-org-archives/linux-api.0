From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available
Date: Fri, 18 Nov 2016 21:48:21 +0000
Message-ID: <9903.1479505701@warthog.procyon.org.uk>
References: <20161118212725.GA31101@dastard> <20161117234047.GE28177@dastard> <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk> <147938970382.13574.11581172952175034619.stgit@warthog.procyon.org.uk> <27040.1479464944@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161118212725.GA31101@dastard>
Content-ID: <9902.1479505701.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:

> > Btw, can you point me at the manpage that defines the fsxattr struct and its
> > flags?
> 
> man xfsctl is the original source. However, ....

	warthog>man xfsctl
	No manual entry for xfsctl

This should be in the kernel manpages repo since it's kernel UAPI.

David
