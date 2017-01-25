From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Add further ioctl() operations for namespace
 discovery
Date: Wed, 25 Jan 2017 13:39:01 +1300
Message-ID: <38ec76ed-8f4c-b0be-b144-d17ffd1ae0c1@gmail.com>
References: <93e5c7f9-9dc1-6c93-ad20-0ba053d8bfef@gmail.com>
 <CAKgNAkimuGpJ1MzLs3wexU+tJakX07Kj_1c+bnGjgk3zgDUGLg@mail.gmail.com>
 <87a8aggjx5.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87a8aggjx5.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Eric,

On 01/25/2017 11:41 AM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> 
>> Hi Eric,
>>
>> Do you have any input for this small patch set? I've still to tweak a
>> comment as suggested by Trevor King, but otherwise I'd like to know if
>> this is good to go for the next merge window.
> 
> Apologies I have been bogged down with other things.  Basically the
> code looks fine, and now that I have caught up with things I will be
> happy to merge your for the next merge window.

Thanks.

> I do wonder if returning -EOVERFLOW may be more useful than running
> the overflow_uid when mapping fails.

Yes, it I think you're right. I'll fix that.

> Also, now that I think about it.  Please let's use (uid_t __user *) for
> the type of argp.  I think that will be more maintainable in the long
> run.  Easier to grep for etc.

Yes, I'll make that change.

> Neither of these things are big or would prevent me from merging your
> change just things that I think would be nice to have.

Both seem worth having to me.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
