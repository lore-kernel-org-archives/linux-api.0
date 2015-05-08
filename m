From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Fri, 8 May 2015 12:42:59 +1000
Message-ID: <20150508024259.GL4327@dastard>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard>
 <20150507172053.GA659@lenny.home.zabbo.net>
 <CAFLxGvw8ESrM6vZ4iB70JFQN-qR-Trs3j1O_+y36tSOn0GVH4A@mail.gmail.com>
 <CALCETrWNDMq0nK3ac-uZweV5BKK_yWTQHH5D0YkyEu7bcONo9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWNDMq0nK3ac-uZweV5BKK_yWTQHH5D0YkyEu7bcONo9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 07, 2015 at 12:53:46PM -0700, Andy Lutomirski wrote:
> On Thu, May 7, 2015 at 12:09 PM, Richard Weinberger
> <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Thu, May 7, 2015 at 7:20 PM, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
> >>> On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
> >>> > Add the O_NOMTIME flag which prevents mtime from being updated which can
> >>> > greatly reduce the IO overhead of writes to allocated and initialized
> >>> > regions of files.
> >>>
> >>> Hmmm. How do backup programs now work out if the file has changed
> >>> and hence needs copying again? ie. applications using this will
> >>> break other critical infrastructure in subtle ways.
> >>
> >> By using backup infrastructure that doesn't use cmtime.  Like btrfs
> >> send/recv.  Or application level backups that know how to do
> >> incrementals from metadata in giant database files, say, without
> >> walking, comparing, and copying the entire thing.
> >
> > But how can Joey random user know that some of his
> > applications are using O_NOMTIME and his KISS backup
> > program does no longer function as expected?
> >
> 
> Joey random user can't have a working KISS backup anyway, though,
> because we screw up mtime updates on mmap writes.  I have patches
> gathering dust that fix that, though.

They are close enough to be good for backup purposes. The mtime only
need change once per backup period - it doesn't need to be
millisecond accurate. Yes, I know you needed that changed for
different reasons (avoid variable page fault latency), but it
doesn't matter for once-a-day or even once-an-hour incremental
backup scans.

Besides, anyone who cares about accurate backups is doing a backup
from a snapshot so they data and metadata is consistent across the
entire backup. And that makes worries about mmap and mtime
completely irrelevant because a snapshot freezes the filesystem and
hence cleans all the mapped pages. Once the snapshot is taken
the next mmap write will trigger a page fault and so change the
mtime and it will be picked up in the next backup scan...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
