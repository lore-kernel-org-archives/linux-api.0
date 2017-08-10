From: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH RFC v2] Add /proc/pid/smaps_rollup
Date: Thu, 10 Aug 2017 11:56:54 -0700
Message-ID: <CAPz6YkUNu1uH057ENuH+Umq5J=J24my0p91mvYMtEb4Vy6Dhqg@mail.gmail.com>
References: <20170808132554.141143-1-dancol@google.com> <20170810001557.147285-1-dancol@google.com>
 <20170810043831.GB2249@bbox> <20170810084617.GI23863@dhcp22.suse.cz>
 <r0251soju3fo.fsf@dancol.org> <20170810105852.GM23863@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810105852.GM23863-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, joelaf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Luigi Semenzato <semenzato-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 10, 2017 at 3:58 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu 10-08-17 03:23:23, Daniel Colascione wrote:
>> Thanks for taking a look at the patch!
>>
>> On Thu, Aug 10 2017, Michal Hocko wrote:
>> > [CC linux-api - the patch was posted here
>> > http://lkml.kernel.org/r/20170810001557.147285-1-dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org]
>> >
>> > On Thu 10-08-17 13:38:31, Minchan Kim wrote:
>> >> On Wed, Aug 09, 2017 at 05:15:57PM -0700, Daniel Colascione wrote:
>> >> > /proc/pid/smaps_rollup is a new proc file that improves the
>> >> > performance of user programs that determine aggregate memory
>> >> > statistics (e.g., total PSS) of a process.
>> >> >
>> >> > Android regularly "samples" the memory usage of various processes in
>> >> > order to balance its memory pool sizes. This sampling process involves
>> >> > opening /proc/pid/smaps and summing certain fields. For very large
>> >> > processes, sampling memory use this way can take several hundred
>> >> > milliseconds, due mostly to the overhead of the seq_printf calls in
>> >> > task_mmu.c.
>> >
>> > Have you tried to reduce that overhead? E.g. by replacing seq_printf by
>> > something more simple
>> > http://lkml.kernel.org/r/20160817130320.GC20703-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org?
>>
>> I haven't tried that yet, but if I'm reading that thread correctly, it
>> looks like using more efficient printing primitives gives us a 7%
>> speedup. The smaps_rollup patch gives us a much bigger speedup while
>> reusing almost all the smaps code, so it seems easier and simpler than a
>> bunch of incremental improvements to smaps. And even an efficient smaps
>> would have to push 2MB through seq_file for the 3000-VMA process case.
>
> The thing is that more users would benefit from a more efficient
> /proc/pid/smaps call. Maybe we can use some caching tricks etc...  We
> should make sure that existing options should be attempted before a new
> user visible interface is added. It is kind of sad that the real work
> (pte walk) is less expensive than formating the output and copying it to
> the userspace...
>
>> > How often you you need to read this information?
>>
>> It varies depending on how often processes change state.  We sample a
>> short time (tens of seconds) after processes change state (e.g., enters
>> foreground) and every few minutes thereafter. We're particularly
>> concerned from an energy perspective about needlessly burning CPU on
>> background samples.
>
> Please make sure this is documented in the patch along with some numbers
> ideally.
>
> [...]
>
>> >> FYI, there was trial but got failed at that time so in this time,
>> >> https://marc.info/?l=linux-kernel&m=147310650003277&w=2
>> >> http://www.mail-archive.com/linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg1229163.html
>> >
>> > Yes I really disliked the previous attempt and this one is not all that
>> > better. The primary unanswered question back then was a relevant
>> > usecase. Back then it was argued [1] that PSS was useful for userspace
>> > OOM handling but arguments were rather dubious. Follow up questions [2]
>> > shown that the useage of PSS was very workload specific. Minchan has
>> > noted some usecase as well but not very specific either.
>>
>> Anyway, I see what you mean about PSS being iffy for user-space OOM
>> processing (because PSS doesn't tell you how much memory you get back in
>> exchange for killing a given process at a particular moment). We're not
>> using it like that.
>>
>> Instead, we're using the PSS samples we collect asynchronously for
>> system-management tasks like fine-tuning oom_adj_score, memory use
>> tracking for debugging, application-level memory-use attribution, and
>> deciding whether we want to kill large processes during system idle
>> maintenance windows. Android has been using PSS for these purposes for a
>> long time; as the average process VMA count has increased and and
>> devices become more efficiency-conscious, PSS-collection inefficiency
>> has started to matter more. IMHO, it'd be a lot safer to optimize the
>> existing PSS-collection model, which has been fine-tuned over the years,
>> instead of changing the memory tracking approach entirely to work around
>> smaps-generation inefficiency.
>
> This is really vague. Please be more specific.

I actually think this is really similar to the Chrome OS use case --
we need to do proper accounting of memory from user space, and we need
something more accurate than what we have now (usually RSS) to figure
it out.  I'm not sure what is vague about that statement?

PSS is not perfect but in closed systems where we have some knowledge
about what is being shared amongst process, PSS is much better than
RSS and readily available.  So, I disagree that this is a dubious
usage -- if there's a better metric for making this kind of decision,
please share it.

Also I realized there's another argument for presenting this
information outside of smaps which is that we expose far less
information about a process and it's address space via something like
this, so it's much better for isolation to have a separate file with
different permissions.  Right now the process in charge of accounting
for memory usage also gains knowledge about each process's address
space which is unnecessary.

IMHO, the fact that multiple folks have independently asked for this
seems like an argument that something like this is needed.


> --
> Michal Hocko
> SUSE Labs
