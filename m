From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Fri, 14 Nov 2014 13:45:02 -0500
Message-ID: <CANP1eJH6BNiJ8zwA2Ba4Dc-2NZ5s2TBE4NVg3Ydk_cvSdDQUFQ@mail.gmail.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
	<x49mw7tyc7e.fsf@segfault.boston.devel.redhat.com>
	<20141114163912.GA23769@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141114163912.GA23769-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 14, 2014 at 11:39 AM, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, Nov 14, 2014 at 11:32:53AM -0500, Jeff Moyer wrote:
>
>  > > Can you write a test (or set of) for fstests that exercises this new
>  > > functionality? I'm not worried about performance, just
>  > > correctness....
>  >
>  > On the subject of testing, I added support to trinity (attached,
>  > untested).  That did raise one question.  Do we expect applications to
>  > #include <linux/fs.h> to get the RWF_NONBLOCK definition?
>
> Trinity will at least need an addition to include/compat.h for
> older headers that won't have the definition.  Looks ok otherwise.
>
> Also, I usually sit on stuff like this until the syscall numbers are
> in Linus tree. This is 3.19 stuff I presume ?
> istr akpm picked up execveat recently, so if that goes in first, we'll
> need to respin this anyway..

Yes, I am hoping to get it into 3.19. It's a large pain having to deal
with other changes to the syscall code.

On a unrelated note I just back to figuring out how to add this to
xfstests. I got busy with other things the last few days. I'm still
not quite sure how to write a test using the framework, the
documentation (README) seams very XFS specific and otherwise the test
seam to be be split between many different files / directories / C
code / shell code. I might be me being slow... but it's just not
obvious for me how to glue the whole thing together.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org
