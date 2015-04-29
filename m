From: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC v2 1/4] fs: Add generic file system event notifications
Date: Wed, 29 Apr 2015 13:10:34 +0200
Message-ID: <5540BC2A.8010504@samsung.com>
References: <1430135504-24334-2-git-send-email-b.michalska@samsung.com>
 <20150427142421.GB21942@kroah.com> <553E50EB.3000402@samsung.com>
 <20150427153711.GA23428@kroah.com> <20150428135653.GD9955@quack.suse.cz>
 <20150428140936.GA13406@kroah.com> <553F9D56.6030301@samsung.com>
 <20150428173900.GA16708@kroah.com> <5540822C.10000@samsung.com>
 <20150429074259.GA31089@quack.suse.cz> <20150429091303.GA4090@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20150429091303.GA4090-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/29/2015 11:13 AM, Greg KH wrote:
> On Wed, Apr 29, 2015 at 09:42:59AM +0200, Jan Kara wrote:
>> On Wed 29-04-15 09:03:08, Beata Michalska wrote:
>>> On 04/28/2015 07:39 PM, Greg KH wrote:
>>>> On Tue, Apr 28, 2015 at 04:46:46PM +0200, Beata Michalska wrote:
>>>>> On 04/28/2015 04:09 PM, Greg KH wrote:
>>>>>> On Tue, Apr 28, 2015 at 03:56:53PM +0200, Jan Kara wrote:
>>>>>>> On Mon 27-04-15 17:37:11, Greg KH wrote:
>>>>>>>> On Mon, Apr 27, 2015 at 05:08:27PM +0200, Beata Michalska wrote:
>>>>>>>>> On 04/27/2015 04:24 PM, Greg KH wrote:
>>>>>>>>>> On Mon, Apr 27, 2015 at 01:51:41PM +0200, Beata Michalska wrote:
>>>>>>>>>>> Introduce configurable generic interface for file
>>>>>>>>>>> system-wide event notifications, to provide file
>>>>>>>>>>> systems with a common way of reporting any potential
>>>>>>>>>>> issues as they emerge.
>>>>>>>>>>>
>>>>>>>>>>> The notifications are to be issued through generic
>>>>>>>>>>> netlink interface by newly introduced multicast group.
>>>>>>>>>>>
>>>>>>>>>>> Threshold notifications have been included, allowing
>>>>>>>>>>> triggering an event whenever the amount of free space drops
>>>>>>>>>>> below a certain level - or levels to be more precise as two
>>>>>>>>>>> of them are being supported: the lower and the upper range.
>>>>>>>>>>> The notifications work both ways: once the threshold level
>>>>>>>>>>> has been reached, an event shall be generated whenever
>>>>>>>>>>> the number of available blocks goes up again re-activating
>>>>>>>>>>> the threshold.
>>>>>>>>>>>
>>>>>>>>>>> The interface has been exposed through a vfs. Once mounted,
>>>>>>>>>>> it serves as an entry point for the set-up where one can
>>>>>>>>>>> register for particular file system events.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>>>>>>>>>> ---
>>>>>>>>>>>  Documentation/filesystems/events.txt |  231 ++++++++++
>>>>>>>>>>>  fs/Makefile                          |    1 +
>>>>>>>>>>>  fs/events/Makefile                   |    6 +
>>>>>>>>>>>  fs/events/fs_event.c                 |  770 ++++++++++++++++++++++++++++++++++
>>>>>>>>>>>  fs/events/fs_event.h                 |   25 ++
>>>>>>>>>>>  fs/events/fs_event_netlink.c         |   99 +++++
>>>>>>>>>>>  fs/namespace.c                       |    1 +
>>>>>>>>>>>  include/linux/fs.h                   |    6 +-
>>>>>>>>>>>  include/linux/fs_event.h             |   58 +++
>>>>>>>>>>>  include/uapi/linux/fs_event.h        |   54 +++
>>>>>>>>>>>  include/uapi/linux/genetlink.h       |    1 +
>>>>>>>>>>>  net/netlink/genetlink.c              |    7 +-
>>>>>>>>>>>  12 files changed, 1257 insertions(+), 2 deletions(-)
>>>>>>>>>>>  create mode 100644 Documentation/filesystems/events.txt
>>>>>>>>>>>  create mode 100644 fs/events/Makefile
>>>>>>>>>>>  create mode 100644 fs/events/fs_event.c
>>>>>>>>>>>  create mode 100644 fs/events/fs_event.h
>>>>>>>>>>>  create mode 100644 fs/events/fs_event_netlink.c
>>>>>>>>>>>  create mode 100644 include/linux/fs_event.h
>>>>>>>>>>>  create mode 100644 include/uapi/linux/fs_event.h
>>>>>>>>>>
>>>>>>>>>> Any reason why you just don't do uevents for the block devices today,
>>>>>>>>>> and not create a new type of netlink message and userspace tool required
>>>>>>>>>> to read these?
>>>>>>>>>
>>>>>>>>> The idea here is to have support for filesystems with no backing device as well.
>>>>>>>>> Parsing the message with libnl is really simple and requires few lines of code
>>>>>>>>> (sample application has been presented in the initial version of this RFC)
>>>>>>>>
>>>>>>>> I'm not saying it's not "simple" to parse, just that now you are doing
>>>>>>>> something that requires a different tool.  If you have a block device,
>>>>>>>> you should be able to emit uevents for it, you don't need a backing
>>>>>>>> device, we handle virtual filesystems in /sys/block/ just fine :)
>>>>>>>>
>>>>>>>> People already have tools that listen to libudev for system monitoring
>>>>>>>> and management, why require them to hook up to yet-another-library?  And
>>>>>>>> what is going to provide the ability for multiple userspace tools to
>>>>>>>> listen to these netlink messages in case you have more than one program
>>>>>>>> that wants to watch for these things (i.e. multiple desktop filesystem
>>>>>>>> monitoring tools, system-health checkers, etc.)?
>>>>>>>   As much as I understand your concerns I'm not convinced uevent interface
>>>>>>> is a good fit. There are filesystems that don't have underlying block
>>>>>>> device - think of e.g. tmpfs or filesystems working directly on top of
>>>>>>> flash devices.  These still want to send notification to userspace (one of
>>>>>>> primary motivation for this interfaces was so that tmpfs can notify about
>>>>>>> something). And creating some fake nodes in /sys/block for tmpfs and
>>>>>>> similar filesystems seems like doing more harm than good to me...
>>>>>>
>>>>>> If these are "fake" block devices, what's going to be present in the
>>>>>> block major/minor fields of the netlink message?  For some reason I
>>>>>> thought it was a required field, and because of that, I thought we had a
>>>>>> "real" filesystem somewhere to refer to, otherwise how would userspace
>>>>>> know what filesystem was creating these events?
>>>>>>
>>>>>> What am I missing here?
>>>>>>
>>>>>> confused,
>>>>>>
>>>>>> greg k-h
>>>>>>
>>>>>
>>>>> For those 'fake' block devs, upon mount, get_anon_bdev will assign
>>>>> the major:minor numbers. Userspace might get those through stat.
>>>>
>>>> How can userspace do the mapping backwards from this "anonymous"
>>>> major:minor number for these types of filesystems in such a way that
>>>> they can "know" how to report the block device that is causing the
>>>> event?
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>> It needs to be done internally by the app but is doable.
>>> The app knows what it is watching, so it can maintain the mappings.
>>> So prior to activating the notifications it can call 'stat' on the mount point.
>>> Stat struct gives the 'st_dev' which is the device id. Same will be reported
>>> within the message payload (through major:minor numbers). So having this,
>>> the app is able to get any other information it needs. 
>>> Note that the events refer to the file system as a whole and they may not
>>> necessarily have anything to do with the actual block device. 
> 
> How are you going to show an event for a filesystem that is made up of
> multiple block devices?

AFAIK, for such filesystems there will be similar case with the anonymous
major:minor numbers - at least the btrfs is doing so. Not sure we can
differentiate here the actual block device. So in this case such events
serves merely as a hint for the userspace. At this point a user might
decide to run some scanning tools. We might extend the scope of the
info being sent, though I would consider this as a nice-to-have but not
required for this initial version of notifications. The filesystems
might also want to decide to send their own custom messages so it is
possible for filesystems like btrfs to send more detailed information
using the new genetlink multicast group.


> 
>>   Or you can use /proc/self/mountinfo for the mapping. There you can see
>> device numbers, real device names if applicable and mountpoints. This has
>> the advantage that it works even if filesystem mountpoints change.
> 
> Ok, then that brings up my next question, how does this handle
> namespaces?  What namespace is the event being sent in?  block devices
> aren't namespaced, but the mount points are, is that going to cause
> problems?
> 

The path should get resolved properly (as from root level). though I must
admit I'm not sure if there will be no issues when it comes to the network
namespaces. I'll double check it. Any hints though are more than welcomed :)

> thanks,
> 
> greg k-h
> 

BR
Beata
