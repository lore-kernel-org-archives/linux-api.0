From: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC 1/4] fs: Add generic file system event notifications
Date: Fri, 17 Apr 2015 11:46:46 +0200
Message-ID: <5530D686.9080807@samsung.com>
References: <1429082147-4151-1-git-send-email-b.michalska@samsung.com>
 <1429082147-4151-2-git-send-email-b.michalska@samsung.com>
 <55302FFB.4010108@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <55302FFB.4010108-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux Filesystem Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Hi,

On 04/16/2015 11:56 PM, Heinrich Schuchardt wrote:
> On 15.04.2015 09:15, Beata Michalska wrote:
>> Introduce configurable generic interface for file
>> system-wide event notifications to provide file
>> systems with a common way of reporting any potential
>> issues as they emerge.
>>
>> The notifications are to be issued through generic
>> netlink interface, by a dedicated, for file system
>> events, multicast group. The file systems might as
>> well use this group to send their own custom messages.
>>
>> The events have been split into four base categories:
>> information, warnings, errors and threshold notifications,
>> with some very basic event types like running out of space
>> or file system being remounted as read-only.
>>
>> Threshold notifications have been included to allow
>> triggering an event whenever the amount of free space
>> drops below a certain level - or levels to be more precise
>> as two of them are being supported: the lower and the upper
>> range. The notifications work both ways: once the threshold
>> level has been reached, an event shall be generated whenever
>> the number of available blocks goes up again re-activating
>> the threshold.
>>
>> The interface has been exposed through a vfs. Once mounted,
>> it serves as an entry point for the set-up where one can
>> register for particular file system events.
> 
> Having a framework for notification for file systems is a great idea.
> Your solution covers an important part of the possible application scope.
> 
> Before moving forward I suggest we should analyze if this scope should
> be enlarged.
> 
> Many filesystems are remote (e.g. CIFS/Samba) or distributed over many
> network nodes (e.g. Lustre). How should file system notification work here?
> 
> How will fuse file systems be served?
> 
> The current point of reference is a single mount point.
> Every time I insert an USB stick several file system may be automounted.
> I would like to receive events for these automounted file systems.
> 
> A similar case arises when starting new virtual machines. How will I
> receive events on the host system for the file systems of the virtual
> machines?

> In your implementation events are received via Netlink.
> Using Netlink for marking mounts for notification would create a much
> more homogenous interface. So why should we use a virtual file system here?
> 
> Best regards
> 
> Heinrich Schuchardt
> 
> 

I'd be more than happy to extend the scope of suggested changes.
I hope I'll be able to collect more comments - in this way there 
is a chance we might get here smth that is really useful, for everyone.

I've tried to make the interface rather flexible, so that new cases
can be easily added - so the notification whenever a file system
is being mounted is definitely doable.

The vfs here merely serves the purpose to configure which type of events
and for which filesystems are to be issued. Having this done through
netlink is also an option, though it needs some more thoughts. The way
notifications are being sent might be extended: so there could be more
than one option for this. We might also want to consider if we want to
have this widely available - everything for everyone. (?)

As for the rest, I must admit I'm not really an fs person, so I assume
there will be more comments and questions like yours. This is also why
any comments/hints/remarks/doubts/issues etc would me more than just
welcomed. I'll try to answer them all, though this will require some
time on my side, thus apologies if I have some delays.


I'll get beck to this asap.

BR
Beata
