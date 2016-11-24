From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available [ver #3]
Date: Thu, 24 Nov 2016 09:13:49 +0100
Message-ID: <5a4327bd-06ef-d24e-cc87-715bc2de6f62@gmail.com>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
 <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
 <768343b5-e9b4-a86c-53de-2929bc290342@gmail.com>
 <19284F6D-73B9-4A1A-8227-2B2B87F29FE9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19284F6D-73B9-4A1A-8227-2B2B87F29FE9-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Andreas,

On 11/23/2016 11:57 PM, Andreas Dilger wrote:
> On Nov 23, 2016, at 1:37 AM, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>

[...]

>>> ===============
>>> NEW SYSTEM CALL
>>> ===============
>>>
>>> The new system call is:
>>>
>>> 	int ret = statx(int dfd,
>>> 			const char *filename,
>>> 			unsigned int flags,
>>
>> In the 0/4 of this patch series, this argument is called 'atflags'.
>> These should be consistent. 'flags' seems correct to me.
> 
> Given that there are a number of different flags and masks in use for
> this syscall, naming this field "atflags" makes it more clear what it
> is used for.

Well, yes, but in all of the "at" calls the argument is just flags.
So, better to be consistent in that dimension, I'd say, and then 
make sure we perhaps have meaningfil names for the fiellds, as you suggest next:


>>> 			unsigned int mask,
> 
> Similarly, naming this field "request_mask" would also be more clear,
> and matches what is used elsewhere in the code.
> 
> That said, I don't care enough about this detail to request a patch refresh,
> but it would be useful for the man pages.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
