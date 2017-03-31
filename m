From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] statx: reject unknown flags when using NULL path
Date: Fri, 31 Mar 2017 16:51:24 +0100
Message-ID: <21301.1490975484@warthog.procyon.org.uk>
References: <20170331154315.GB29622@ZenIV.linux.org.uk> <20170311065823.4415-1-ebiggers3@gmail.com> <20170320171142.GA26906@gmail.com> <20170320174422.GA9304@infradead.org> <20170331153952.GA32460@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170331154315.GB29622-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Content-ID: <21300.1490975484.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:

> > can we get this in please?  It would be sad to grow another syscall
> > with an unchecked flags argument..
> 
> Applied, will be in tonight pull request...

I'm not convinced that this is right.  I'm more inclined to let any flag be
passed that is available to statx() with a filename and just mask off the
bits before handing them on.

David
