From: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 20:55:56 +0100
Message-ID: <545297CC.6020306@samsung.com>
References: <54520A21.20404@samsung.com> <54521697.1030900@samsung.com>
 <20141030144709.GA19721@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20141030144709.GA19721-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2014-10-30 15:47, Greg Kroah-Hartman wrote:
> On Thu, Oct 30, 2014 at 11:44:39AM +0100, Karol Lewandowski wrote:
>> [ Sorry for breaking thread and resend - gmane rejected my original message
>>   due to too long list of recipients... ]
>>
>> On 2014-10-30 00:40, Greg Kroah-Hartman wrote:
>>
>>> There is a 1815 line documentation file in this series, so we aren't
>>> trying to not provide this type of information here at all.  But yes,
>>> more background, about why this can't be done in userspace (zero copy,
>>> less context switches, proper credential passing, timestamping, availble
>>> at early-boot, LSM hooks for security models to tie into
>>
>> While you're at it... I did some work on proof-of-concept LSM patches for
>> kdbus some time ago, see [1][2].  Currently, these are completely of date.
>>
>>  [1] https://github.com/lmctl/linux/commits/kdbus-lsm-v4.for-systemd-v212
>>  [2] https://github.com/lmctl/kdbus/commit/aa0885489d19be92fa41c6f0a71df28763228a40
>>
>> May I ask if you guys have your own plan for LSM or maybe it would be
>> worth to resurrect [1]?
> 
> The core calls are already mediated by LSM today, right?  We don't want
> anyone to be parsing the data stream through an LSM, that idea got
> rejected a long time ago as something that is really not a good idea.

Parsing data is out of question, of course, but this is not what we were
proposing.

> Other than that, I don't know exactly what your patches do, or why they
> are needed, care to go into details?

Patches in question were supposed to add few hooks for kdbus-specific
operations that doesn't seem to have compatible semantics with hooks
currently available in LSM.

kdbus' bus introduces quite a few new concepts that we wanted to be able
to limit based on MAC label/context, eg.

 - check flags at HELO stage (say disallow fd passing),

 - restrict ability to acquire name to certain subjects (for system bus),

 - disallow creation of new buses,

 - limit scope of broadcasts,

 - etc.

Please take a look at hook list - I think most of names are self-explanatory:

  https://github.com/lmctl/linux/blob/a9fe4c33b6e5ab25a243e0590df406aabb6add12/include/linux/security.h#L1874

kdbus modifications were pretty light - with most visible change being
addition of opaque security pointer to kdbus_bus and similar structs.

Thanks!
-- 
Karol Lewandowski, Samsung R&D Institute Poland
