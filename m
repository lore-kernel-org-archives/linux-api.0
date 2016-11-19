From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available
Date: Sat, 19 Nov 2016 11:21:53 +0100
Message-ID: <CAKgNAkj2n9gcJNJrvezXhC6Zu6Ddoo6vh5uJsF80ULc8kF2LMw@mail.gmail.com>
References: <20161118212725.GA31101@dastard> <20161117234047.GE28177@dastard>
 <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk>
 <147938970382.13574.11581172952175034619.stgit@warthog.procyon.org.uk>
 <27040.1479464944@warthog.procyon.org.uk> <9903.1479505701@warthog.procyon.org.uk>
 <20161118221728.GD31101@dastard>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161118221728.GD31101@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Li Xi <pkuelelixi@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi Dave,

[Best to CC me when I'm mentioned in the discussion. I only caught
this by chance.]

On 18 November 2016 at 23:17, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Nov 18, 2016 at 09:48:21PM +0000, David Howells wrote:
>> Dave Chinner <david@fromorbit.com> wrote:
>>
>> > > Btw, can you point me at the manpage that defines the fsxattr struct and its
>> > > flags?
>> >
>> > man xfsctl is the original source. However, ....
>>
>>       warthog>man xfsctl
>>       No manual entry for xfsctl
>>
>> This should be in the kernel manpages repo since it's kernel UAPI.
>
> "original source" is where the API came from - that's
> XFS_IOC_FSGETXATTR - and xfsctl from xfsprogs is where that was
> documented. That page documents a bunch of other XFS specific
> ioctls, too, so it is appropriately located.
>
> Like I said, I thought patches had been sent to Michael to lift the
> FS_IOC_FSGETXATTR documentation from this page into the official
> linux man pages package. If not, that can be chased up separately,
> but the XFS ioctl man page certainly does not belong there.

No patches for FS_IOC_FSGETXATTR documentation came to man-pages, as
far as I know. I'll be happy to take them.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
