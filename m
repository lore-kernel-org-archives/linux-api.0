From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/6] vfs: vfs: Define new syscalls preadv2,pwritev2
Date: Mon, 25 Apr 2016 01:47:15 -0700
Message-ID: <20160425084715.GA29255@infradead.org>
References: <1457017443-17662-1-git-send-email-hch@lst.de>
 <1457017443-17662-3-git-send-email-hch@lst.de>
 <56E1B9A8.3070904@gmail.com>
 <20160311095357.GA29350@lst.de>
 <5714E676.4090007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5714E676.4090007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Apr 18, 2016 at 02:51:50PM +0100, Michael Kerrisk (man-pages) wrote:
> Thanks. I applied the patch, but I see one point where the doc
> and code differ, and I suspect that the code needs to be fixed.
> See below.

> >  .TP
> >  .B EINVAL
> >  The vector count \fIiovcnt\fP is less than zero or greater than the
> > -permitted maximum.
> > +permitted maximum. Or, an unknown flag is specified in \fIflags\fP.
> 
> In the case described in the last sentence, the code currently appears
> to be returning EOPNOTSUPP. EINVAL is more usual here, so I think the
> code needs adjusting. Your thoughts?

I'd rather update the man page - EOPNOTSUPP is a much more descriptive
error code for this case.  I'll send you a patch.
