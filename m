From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ioctl_list.2: BLKRASET/BLKRAGET take unsigned long
Date: Mon, 10 Apr 2017 17:21:34 +0200
Message-ID: <f421cf72-791c-ba59-42d4-4dcef9a71b04@gmail.com>
References: <20170215112015.GA27080@rei.lan> <20170215112205.GA27269@rei.lan>
 <CAK8P3a0KzhqFZqvPH4q7_Nb6+TMmhCWXDi_-wQG=mi-1U=Ccxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK8P3a0KzhqFZqvPH4q7_Nb6+TMmhCWXDi_-wQG=mi-1U=Ccxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/15/2017 01:04 PM, Arnd Bergmann wrote:
> On Wed, Feb 15, 2017 at 12:22 PM, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org> wrote:
>> [CCing linux api as well]
>>> The BLKRASET/BLKRAGET ioctls() take unsigned long, if I pass int * to
>>> the BLKRAGET ioctl on x86_64 (or on any other arch where sizeof(int) !=
>>> sizeof(long)) the BLKRAGET ioctl will rewrite four bytes on the stack.
>>>
>>> If you look at block/ioctl.c in kernel sources you can clearly see that
>>> BLKRAGET ioctl calls put_long().
> 
> BLKFRAGET as well, fwiw, see compat_blkdev_ioctl().
> We might as well include them in the list.
> 
>>> I also wonder if it's OK to pass int value to ioctl() at all, the arg
>>> value seems to be unsigned long in the syscall definition in fs/ioctl.c
>>> and there does not seem to be any glibc magic around the syscall.
> 
> This shouldn't matter, if you pass an 'int' into a function that takes
> a 'long', it will be extended if necessary. The question is more about
> how it gets interpreted, and in this case it's done by assigning to
> 
> struct backing_dev_info {
> ...
>         unsigned long ra_pages; /* max readahead in PAGE_SIZE units */
> ...
> };
> 
> Large values will not be used in practice (these are capped by the
> I/O sizes), but I guess you can set a value larger than UINT_MAX
> and read it back later.
> 
>>>  man2/ioctl_list.2 | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/man2/ioctl_list.2 b/man2/ioctl_list.2
>>> index 0165c77..c8efd66 100644
>>> --- a/man2/ioctl_list.2
>>> +++ b/man2/ioctl_list.2
>>> @@ -311,8 +311,8 @@ l l l l.
>>>  0x0000125F   BLKRRPART       void
>>>  0x00001260   BLKGETSIZE      unsigned long *
>>>  0x00001261   BLKFLSBUF       void
>>> -0x00001262   BLKRASET        int
>>> -0x00001263   BLKRAGET        int *
>>> +0x00001262   BLKRASET        unsigned long
>>> +0x00001263   BLKRAGET        unsigned long *
>>>  0x00000001   FIBMAP  int *   // I-O
>>>  0x00000002   FIGETBSZ        int *
>>>  0x80086601   FS_IOC_GETFLAGS int *
> 
> Looks correct to me.

Thanks for reviewing this, Arnd.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
