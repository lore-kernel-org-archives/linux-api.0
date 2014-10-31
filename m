From: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Fri, 31 Oct 2014 15:21:39 +0100
Message-ID: <54539AF3.6060302@samsung.com>
References: <54520A21.20404@samsung.com> <20141030144709.GA19721@kroah.com>
 <545297CC.6020306@samsung.com> <5113482.YUK8i6Rueb@sifl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <5113482.YUK8i6Rueb@sifl>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karol Lewandowski <lmctlx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 2014-10-31 00:39, Paul Moore wrote:
> On Thursday, October 30, 2014 08:55:56 PM Karol Lewandowski wrote:
>> On 2014-10-30 15:47, Greg Kroah-Hartman wrote:
>>> Other than that, I don't know exactly what your patches do, or why they
>>> are needed, care to go into details?
>>
>> Patches in question were supposed to add few hooks for kdbus-specific
>> operations that doesn't seem to have compatible semantics with hooks
>> currently available in LSM.
>>
>> kdbus' bus introduces quite a few new concepts that we wanted to be able
>> to limit based on MAC label/context, eg.
>>
>>  - check flags at HELO stage (say disallow fd passing),
>>
>>  - restrict ability to acquire name to certain subjects (for system bus),
>>
>>  - disallow creation of new buses,
>>
>>  - limit scope of broadcasts,
>>
>>  - etc.
>>
>> Please take a look at hook list - I think most of names are
>> self-explanatory:
>>
>>  
>> https://github.com/lmctl/linux/blob/a9fe4c33b6e5ab25a243e0590df406aabb6add1
>> 2/include/linux/security.h#L1874
>>
>> kdbus modifications were pretty light - with most visible change being
>> addition of opaque security pointer to kdbus_bus and similar structs.
> 
> [NOTE: we really should add the LSM list to this discussion and future 
> patchset postings.]
> 
> Also, to be completely honest, I don't think we ever really arrived at any 
> final conclusion about those LSM/kdbus hooks either.  At least I don't think I 
> ever really satisfied myself that what we had was the "right" solution.

Agreed, "hooks" are far from being complete.  I think that patches
were and still are - a starting point for discussion, not "a solution"
itself.

Timing wasn't good either - since our last discussion (Apr/May 2014)
kdbus policy engine has been completely rewritten and few core concepts
changed too.

> We both got busy and kinda drifted away from this effort.  Karol, did you do 
> any further work on the hooks?

I didn't.  I was waiting for the peace of change in kdbus to slow
down a bit and, honestly, wasn't expecting submission in few next
months...

I'll do my best to post RFC patchset today or tomorrow.

Thanks
-- 
Karol Lewandowski, Samsung R&D Institute Poland
