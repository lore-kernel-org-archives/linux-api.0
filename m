From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 10:20:17 -0700
Message-ID: <CFF29805.9D436%dvhart@linux.intel.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <871tte3bjw.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <871tte3bjw.fsf-KWJ+5VKanrL29G5dvP0v1laTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 7/21/14, 9:45, "Andi Kleen" <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:

>Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> writes:
>
>> Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org> writes:
>>
>>> This patch series introduces two new futex command codes to support
>>> a new optimistic spinning futex for implementing an exclusive lock
>>> primitive that should perform better than the same primitive using
>>> the wait-wake futex in cases where the lock owner is actively working
>>> instead of waiting for I/O completion.
>>
>> How would you distinguish those two cases automatically?
>
>Also BTW traditionally the spinning was just done in user space.
>
>This would be always even more efficient, because it would
>even avoid the syscall entry path.
>
>Given the glibc adaptive mutexes are not very good, but I'm sure those
>could be improved.

I presented on something along these lines a few years back, and various
people have asked for the sample code over the years. Andi is right, doing
this from user-space has the potential to be more efficient, the challenge
is getting access to privileged information, such as the state of the
mutex owner. You don't want to spin if the owner is sleeping. I did this
by adding a tidrunning call to the vdso. My somewhat hacked solution is
still available here:

http://git.infradead.org/users/dvhart/linux.git/shortlog/refs/heads/futex/t
idrunning/dev


I abandoned the spinning in the kernel thing due to the overhead of the
system call if I remember correctly. Also available here:

http://git.infradead.org/users/dvhart/linux.git/shortlog/refs/heads/futex/f
utex-lock-adaptive



-- 
Darren Hart					Open Source Technology Center
darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org				            Intel Corporation
