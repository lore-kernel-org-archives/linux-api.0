From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v5 7/7] add a flag for per-operation O_DSYNC semantics
Date: Fri, 7 Nov 2014 06:22:48 +0200
Message-ID: <BF30FAEC-D4D3-4079-9ECD-2743747279BD@cam.ac.uk>
References: <cover.1415220890.git.milosz@adfin.com> <cover.1415220890.git.milosz@adfin.com> <c188b04ede700ce5f986b19de12fa617d158540f.1415220890.git.milosz@adfin.com> <x49r3xf28qn.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <x49r3xf28qn.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Jeff,

> On 7 Nov 2014, at 01:46, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org> writes:
> 
>> -		if (type == READ && (flags & RWF_NONBLOCK))
>> -			return -EAGAIN;
>> +		if (type == READ) {
>> +			if (flags & RWF_NONBLOCK)
>> +				return -EAGAIN;
>> +		} else {
>> +			if (flags & RWF_DSYNC)
>> +				return -EINVAL;
>> +		}
> 
> Minor nit, but I'd rather read something that looks like this:
> 
> 	if (type == READ && (flags & RWF_NONBLOCK))
> 		return -EAGAIN;
> 	else if (type == WRITE && (flags & RWF_DSYNC))
> 		return -EINVAL;

But your version is less logically efficient for the case where "type == READ" is true and "flags & RWF_NONBLOCK" is false because your version then has to do the "if (type == WRITE" check before discovering it does not need to take that branch either, whilst the original version does not have to do such a test at all.

Best regards,

	Anton

> I won't lose sleep over it, though.
> 
> Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK
