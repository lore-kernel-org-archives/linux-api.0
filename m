From: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC v3 1/4] fs: Add generic file system event notifications
Date: Fri, 19 Jun 2015 19:28:11 +0200
Message-ID: <5584512B.5020301@samsung.com>
References: <1434460173-18427-1-git-send-email-b.michalska@samsung.com>
 <1434460173-18427-2-git-send-email-b.michalska@samsung.com>
 <20150617230605.GK10224@dastard> <55828064.5040301@samsung.com>
 <20150619000341.GM10224@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20150619000341.GM10224@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/19/2015 02:03 AM, Dave Chinner wrote:
> On Thu, Jun 18, 2015 at 10:25:08AM +0200, Beata Michalska wrote:
>> On 06/18/2015 01:06 AM, Dave Chinner wrote:
>>> On Tue, Jun 16, 2015 at 03:09:30PM +0200, Beata Michalska wrote:
>>>> Introduce configurable generic interface for file
>>>> system-wide event notifications, to provide file
>>>> systems with a common way of reporting any potential
>>>> issues as they emerge.
>>>>
>>>> The notifications are to be issued through generic
>>>> netlink interface by newly introduced multicast group.
>>>>
>>>> Threshold notifications have been included, allowing
>>>> triggering an event whenever the amount of free space drops
>>>> below a certain level - or levels to be more precise as two
>>>> of them are being supported: the lower and the upper range.
>>>> The notifications work both ways: once the threshold level
>>>> has been reached, an event shall be generated whenever
>>>> the number of available blocks goes up again re-activating
>>>> the threshold.
>>>>
>>>> The interface has been exposed through a vfs. Once mounted,
>>>> it serves as an entry point for the set-up where one can
>>>> register for particular file system events.
>>>>
>>>> Signed-off-by: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>>
>>> This has massive scalability problems:
> ....
>>> Have you noticed that the filesystems have percpu counters for
>>> tracking global space usage? There's good reason for that - taking a
>>> spinlock in such a hot accounting path causes severe contention.
> ....
>>> Then puts the entire netlink send path inside this spinlock, which
>>> includes memory allocation and all sorts of non-filesystem code
>>> paths. And it may be inside critical filesystem locks as well....
>>>
>>> Apart from the serialisation problem of the locking, adding
>>> memory allocation and the network send path to filesystem code
>>> that is effectively considered "innermost" filesystem code is going
>>> to have all sorts of problems for various filesystems. In the XFS
>>> case, we simply cannot execute this sort of function in the places
>>> where we update global space accounting.
>>>
>>> As it is, I think the basic concept of separate tracking of free
>>> space if fundamentally flawed. What I think needs to be done is that
>>> filesystems need access to the thresholds for events, and then the
>>> filesystems call fs_event_send_thresh() themselves from appropriate
>>> contexts (ie. without compromising locking, scalability, memory
>>> allocation recursion constraints, etc).
>>>
>>> e.g. instead of tracking every change in free space, a filesystem
>>> might execute this once every few seconds from a workqueue:
>>>
>>> 	event = fs_event_need_space_warning(sb, <fs_free_space>)
>>> 	if (event)
>>> 		fs_event_send_thresh(sb, event);
>>>
>>> User still gets warnings about space usage, but there's no runtime
>>> overhead or problems with lock/memory allocation contexts, etc.
>>
>> Having fs to keep a firm hand on thresholds limits would indeed be
>> far more sane approach though that would require each fs to
>> add support for that and handle most of it on their own. Avoiding
>>> this was the main rationale behind this rfc.
>> If fs people agree to that, I'll be more than willing to drop this
>> in favour of the per-fs tracking solution. 
>> Personally, I hope they will.
> 
> I was hoping that you'd think a little more about my suggestion and
> work out how to do background threshold event detection generically.
> I kind of left it as "an exercise for the reader" because it seems
> obvious to me.
> 
> Hint: ->statfs allows you to get the total, free and used space
> from filesystems in a generic manner.
> 
> Cheers,
> 
> Dave.
> 

I haven't given up on that, so yes, I'm still working on a more suitable
generic solution.
Background detection is one of the options, though it needs some more thoughts.
Giving up the sync approach means less accuracy for the threshold notifications,
but I guess this could be fine-tuned to get an acceptable level. Another bump:
how this tuning is supposed to be done (additional config option maybe)? 
The interface would have to keep it somehow sane - but what would 'sane' mean
in this case (?) Also, I'm not sure whether single approach would server here
well for all the potentially supported file systems so this would have to be
properly adjusted (taking the threshold levels into consideration as well). 
And still,it would require some form of synchronization with tracked fs so that
this 'detection' is not being unnecessarily performed (i.e. while fs remains frozen).

There is also an idea of using an interface resembling the stackable fs:
a transparent file system layered on top of the tracked one 
(solely for the tracking purposes). This would simplify handling the trace 
object's lifetime - no more list of registered traces.
It would also give a way of tracking (to some extent) the changes in the amount
of available space, which combined with tweaked background check could give
a solution with less performance overhead than the original one.
I'll try this one and see how it goes.

Thank You for your feedback so far - I really appreciate it.


Best Regards
Beata 
