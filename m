From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 15:26:27 -0800
Message-ID: <b6faf739-1a4a-12e1-ad84-0b42166d68c1@nvidia.com>
References: <23066.59196.909026.689706@gargle.gargle.HOWL>
 <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
 <CAM43=SPVvBTPz31Uu=iz3fpS9tb75uSmL=pYP3AfsfmYr9u4Og@mail.gmail.com>
 <20171127195207.vderbbkbgygawuhx@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171127195207.vderbbkbgygawuhx-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/27/2017 11:52 AM, Michal Hocko wrote:
> On Mon 27-11-17 20:18:00, Mikael Pettersson wrote:
>> On Mon, Nov 27, 2017 at 11:12 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>> I've kept the kernel tunable to not break the API towards user-space,
>>>> but it's a no-op now.  Also the distinction between split_vma() and
>>>> __split_vma() disappears, so they are merged.
>>>
>>> Could you be more explicit about _why_ we need to remove this tunable?
>>> I am not saying I disagree, the removal simplifies the code but I do not
>>> really see any justification here.
>>
>> In principle you don't "need" to, as those that know about it can bump it
>> to some insanely high value and get on with life.  Meanwhile those that don't
>> (and I was one of them until fairly recently, and I'm no newcomer to Unix or
>> Linux) get to scratch their heads and wonder why the kernel says ENOMEM
>> when one has loads of free RAM.
> 
> I agree that our error reporting is more than suboptimal in this regard.
> These are all historical mistakes and we have much more of those. The
> thing is that we have means to debug these issues (check
> /proc/<pid>/maps e.g.).
> 
>> But what _is_ the justification for having this arbitrary limit?
>> There might have been historical reasons, but at least ELF core dumps
>> are no longer a problem.
> 
> Andi has already mentioned the the resource consumption. You can create
> a lot of unreclaimable memory and there should be some cap. Whether our
> default is good is questionable. Whether we can remove it altogether is
> a different thing.
> 
> As I've said I am not a great fan of the limit but "I've just notice it
> breaks on me" doesn't sound like a very good justification. You still
> have an option to increase it. Considering we do not have too many
> reports suggests that this is not such a big deal for most users.
> 

Let me add a belated report, then: we ran into this limit while implementing 
an early version of Unified Memory[1], back in 2013. The implementation
at the time depended on tracking that assumed "one allocation == one vma".
So, with only 64K vmas, we quickly ran out, and changed the design to work
around that. (And later, the design was *completely* changed to use a separate
tracking system altogether). 

The existing limit seems rather too low, at least from my perspective. Maybe
it would be better, if expressed as a function of RAM size?


[1] https://devblogs.nvidia.com/parallelforall/unified-memory-in-cuda-6/

    This is a way to automatically (via page faulting) migrate memory
    between CPUs and devices (GPUs, here). This is before HMM, of course.

thanks,
John Hubbard
      
