From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unchecked flags in statx(2) [Should be fixed before 4.11-final?]
Date: Fri, 21 Apr 2017 14:28:22 +0200
Message-ID: <e8b8e13f-868e-07f7-1c0b-d1e9bbc2dcb3@gmail.com>
References: <a7d1fa79-b479-184e-af7e-b4319490f2a3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a7d1fa79-b479-184e-af7e-b4319490f2a3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[Adding a few people to CC, and correcting myself on one piece] 

On 04/21/2017 02:14 PM, Michael Kerrisk (man-pages) wrote:
> Hello David,
> 
>  I was reading your statx(2) man page, and noticed this text:
> 
>        Do not simply set mask to UINT_MAX as one or more bits may, in the
>        future, be used to specify an extension to the buffer.
> 
> (Here' 'mask' is the fourth argument to statx())
> 
> What is going on here? Why is there  not a check in the code to
> give EINVAL if any flag other than those in STATX_ALL (0x00000fffU)
> is specified? (There is a check that gives EINVAL flags in 
> STATX__RESERVED (0x80000000U), but STATX_ALL != ~STATX__RESERVED.
> 
> Similarly, there appears to be no check for invalid flags in the
> 'flags' argument of statx(). Why is there also not such a check
> there?
>
> The failure to do these sorts of checks has been the source of grief 
> in the past with other system calls.

So, it looks like the checks are there for 'flags' (I missed that 
they were one level deeper in the call sequence), but my question 
re 'mask' still stands.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
