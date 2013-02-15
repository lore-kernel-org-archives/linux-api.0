From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/3] posix timers: Allocate timer id per process
Date: Fri, 15 Feb 2013 09:13:19 +0400
Message-ID: <511DC3EF.60904@parallels.com>
References: <511D0E50.7090505@parallels.com> <511D0E77.2090907@parallels.com> <CA+1xoqdk5PArnjSnu=7gUq_4got09a0PxBd4Yy=inezPTGsdAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+1xoqdk5PArnjSnu=7gUq_4got09a0PxBd4Yy=inezPTGsdAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/15/2013 12:13 AM, Sasha Levin wrote:
> On Thu, Feb 14, 2013 at 11:19 AM, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>> From: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>
>> Patch replaces global idr with global hash table for posix timers and
>> makes timer ids unique not globally, but per process. Next free timer id is
>> type of integer and stored on signal struct (posix_timer_id). If free timer
>> id reaches negative value on timer creation, it will be dropped to zero and
>> -EAGAIN will be returned to user.
>>
>> Hash table has 512 slots.
>> Key is constructed as follows:
>> key = hash_32(hash_32(current->signal) ^ posix_timer_id));
>>
>> Note: with this patch, id, returned to user, is not the minimal free
>> amymore. It means, that id, returned to user space in loop, listed below, will
>> be increasing on each iteration till INT_MAX and then dropped to zero:
>>
>> while(1) {
>>         id = timer_create(...);
>>         timer_delete(id);
>> }
>>
>> Signed-off-by: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> Signed-off-by: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 
> Hi Pavel,
> 
> Why not use linux/hashtable.h?

Simply because this patch was just picked from the previous discussions
as is :) I will tune it to use hashtable.h in the next iteration.

> 
> Thanks,
> Sasha
> .
> 
