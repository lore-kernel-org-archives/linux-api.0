From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] vfs: vfs: Define new syscalls preadv2,pwritev2
Date: Mon, 25 Apr 2016 19:35:36 +0200
Message-ID: <CAKgNAki1ph1fV9EB9aARR1n8f6k=_KvHRiaPCAvetwigdKSpmw@mail.gmail.com>
References: <1457017443-17662-1-git-send-email-hch@lst.de> <1457017443-17662-3-git-send-email-hch@lst.de>
 <56E1B9A8.3070904@gmail.com> <20160311095357.GA29350@lst.de>
 <5714E676.4090007@gmail.com> <20160425084715.GA29255@infradead.org>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425084715.GA29255-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Christoph,

On 25 April 2016 at 10:47, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, Apr 18, 2016 at 02:51:50PM +0100, Michael Kerrisk (man-pages) wrote:
>> Thanks. I applied the patch, but I see one point where the doc
>> and code differ, and I suspect that the code needs to be fixed.
>> See below.
>
>> >  .TP
>> >  .B EINVAL
>> >  The vector count \fIiovcnt\fP is less than zero or greater than the
>> > -permitted maximum.
>> > +permitted maximum. Or, an unknown flag is specified in \fIflags\fP.
>>
>> In the case described in the last sentence, the code currently appears
>> to be returning EOPNOTSUPP. EINVAL is more usual here, so I think the
>> code needs adjusting. Your thoughts?
>
> I'd rather update the man page - EOPNOTSUPP is a much more descriptive
> error code for this case.  I'll send you a patch.

Unless I'm misunderstanding something here, you're proposing something
very inconsistent. The standard error for unknown flag bits is EINVAL.
This is so for dozens of systems calls (check the man pages; you might
find a rare exception, but that's the point, they are exceptions). It
seems to me here that it's really the implementation that needs
fixing, not the man page!

Cheers,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
