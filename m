From: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC v2 1/4] fs: Add generic file system event notifications
Date: Tue, 26 May 2015 18:39:48 +0200
Message-ID: <5564A1D4.4040309@samsung.com>
References: <1430135504-24334-2-git-send-email-b.michalska@samsung.com>
 <20150427142421.GB21942@kroah.com> <553E50EB.3000402@samsung.com>
 <20150427153711.GA23428@kroah.com> <20150428135653.GD9955@quack.suse.cz>
 <20150428140936.GA13406@kroah.com> <553F9D56.6030301@samsung.com>
 <20150428173900.GA16708@kroah.com> <5540822C.10000@samsung.com>
 <20150429074259.GA31089@quack.suse.cz> <20150429091303.GA4090@kroah.com>
 <5548B4BB.7050503@samsung.com> <554B5329.8040907@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <554B5329.8040907-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On 05/07/2015 01:57 PM, Beata Michalska wrote:
> Hi,
>=20
> On 05/05/2015 02:16 PM, Beata Michalska wrote:
>> Hi again,
>>
>> On 04/29/2015 11:13 AM, Greg KH wrote:
>>> On Wed, Apr 29, 2015 at 09:42:59AM +0200, Jan Kara wrote:
>>>> On Wed 29-04-15 09:03:08, Beata Michalska wrote:
>>>>> On 04/28/2015 07:39 PM, Greg KH wrote:
>>>>>> On Tue, Apr 28, 2015 at 04:46:46PM +0200, Beata Michalska wrote:
>>>>>>> On 04/28/2015 04:09 PM, Greg KH wrote:
>>>>>>>> On Tue, Apr 28, 2015 at 03:56:53PM +0200, Jan Kara wrote:
>>>>>>>>> On Mon 27-04-15 17:37:11, Greg KH wrote:
>>>>>>>>>> On Mon, Apr 27, 2015 at 05:08:27PM +0200, Beata Michalska wr=
ote:
>>>>>>>>>>> On 04/27/2015 04:24 PM, Greg KH wrote:
>>>>>>>>>>>> On Mon, Apr 27, 2015 at 01:51:41PM +0200, Beata Michalska =
wrote:
>>>>>>>>>>>>> Introduce configurable generic interface for file
>>>>>>>>>>>>> system-wide event notifications, to provide file
>>>>>>>>>>>>> systems with a common way of reporting any potential
>>>>>>>>>>>>> issues as they emerge.
>>>>>>>>>>>>>
>>>>>>>>>>>>> The notifications are to be issued through generic
>>>>>>>>>>>>> netlink interface by newly introduced multicast group.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Threshold notifications have been included, allowing
>>>>>>>>>>>>> triggering an event whenever the amount of free space dro=
ps
>>>>>>>>>>>>> below a certain level - or levels to be more precise as t=
wo
>>>>>>>>>>>>> of them are being supported: the lower and the upper rang=
e.
>>>>>>>>>>>>> The notifications work both ways: once the threshold leve=
l
>>>>>>>>>>>>> has been reached, an event shall be generated whenever
>>>>>>>>>>>>> the number of available blocks goes up again re-activatin=
g
>>>>>>>>>>>>> the threshold.
>>>>>>>>>>>>>
>>>>>>>>>>>>> The interface has been exposed through a vfs. Once mounte=
d,
>>>>>>>>>>>>> it serves as an entry point for the set-up where one can
>>>>>>>>>>>>> register for particular file system events.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>  Documentation/filesystems/events.txt |  231 ++++++++++
>>>>>>>>>>>>>  fs/Makefile                          |    1 +
>>>>>>>>>>>>>  fs/events/Makefile                   |    6 +
>>>>>>>>>>>>>  fs/events/fs_event.c                 |  770 ++++++++++++=
++++++++++++++++++++++
>>>>>>>>>>>>>  fs/events/fs_event.h                 |   25 ++
>>>>>>>>>>>>>  fs/events/fs_event_netlink.c         |   99 +++++
>>>>>>>>>>>>>  fs/namespace.c                       |    1 +
>>>>>>>>>>>>>  include/linux/fs.h                   |    6 +-
>>>>>>>>>>>>>  include/linux/fs_event.h             |   58 +++
>>>>>>>>>>>>>  include/uapi/linux/fs_event.h        |   54 +++
>>>>>>>>>>>>>  include/uapi/linux/genetlink.h       |    1 +
>>>>>>>>>>>>>  net/netlink/genetlink.c              |    7 +-
>>>>>>>>>>>>>  12 files changed, 1257 insertions(+), 2 deletions(-)
>>>>>>>>>>>>>  create mode 100644 Documentation/filesystems/events.txt
>>>>>>>>>>>>>  create mode 100644 fs/events/Makefile
>>>>>>>>>>>>>  create mode 100644 fs/events/fs_event.c
>>>>>>>>>>>>>  create mode 100644 fs/events/fs_event.h
>>>>>>>>>>>>>  create mode 100644 fs/events/fs_event_netlink.c
>>>>>>>>>>>>>  create mode 100644 include/linux/fs_event.h
>>>>>>>>>>>>>  create mode 100644 include/uapi/linux/fs_event.h
>>>>>>>>>>>>
>>>>>>>>>>>> Any reason why you just don't do uevents for the block dev=
ices today,
>>>>>>>>>>>> and not create a new type of netlink message and userspace=
 tool required
>>>>>>>>>>>> to read these?
>>>>>>>>>>>
>>>>>>>>>>> The idea here is to have support for filesystems with no ba=
cking device as well.
>>>>>>>>>>> Parsing the message with libnl is really simple and require=
s few lines of code
>>>>>>>>>>> (sample application has been presented in the initial versi=
on of this RFC)
>>>>>>>>>>
>>>>>>>>>> I'm not saying it's not "simple" to parse, just that now you=
 are doing
>>>>>>>>>> something that requires a different tool.  If you have a blo=
ck device,
>>>>>>>>>> you should be able to emit uevents for it, you don't need a =
backing
>>>>>>>>>> device, we handle virtual filesystems in /sys/block/ just fi=
ne :)
>>>>>>>>>>
>>>>>>>>>> People already have tools that listen to libudev for system =
monitoring
>>>>>>>>>> and management, why require them to hook up to yet-another-l=
ibrary?  And
>>>>>>>>>> what is going to provide the ability for multiple userspace =
tools to
>>>>>>>>>> listen to these netlink messages in case you have more than =
one program
>>>>>>>>>> that wants to watch for these things (i.e. multiple desktop =
filesystem
>>>>>>>>>> monitoring tools, system-health checkers, etc.)?
>>>>>>>>>   As much as I understand your concerns I'm not convinced uev=
ent interface
>>>>>>>>> is a good fit. There are filesystems that don't have underlyi=
ng block
>>>>>>>>> device - think of e.g. tmpfs or filesystems working directly =
on top of
>>>>>>>>> flash devices.  These still want to send notification to user=
space (one of
>>>>>>>>> primary motivation for this interfaces was so that tmpfs can =
notify about
>>>>>>>>> something). And creating some fake nodes in /sys/block for tm=
pfs and
>>>>>>>>> similar filesystems seems like doing more harm than good to m=
e...
>>>>>>>>
>>>>>>>> If these are "fake" block devices, what's going to be present =
in the
>>>>>>>> block major/minor fields of the netlink message?  For some rea=
son I
>>>>>>>> thought it was a required field, and because of that, I though=
t we had a
>>>>>>>> "real" filesystem somewhere to refer to, otherwise how would u=
serspace
>>>>>>>> know what filesystem was creating these events?
>>>>>>>>
>>>>>>>> What am I missing here?
>>>>>>>>
>>>>>>>> confused,
>>>>>>>>
>>>>>>>> greg k-h
>>>>>>>>
>>>>>>>
>>>>>>> For those 'fake' block devs, upon mount, get_anon_bdev will ass=
ign
>>>>>>> the major:minor numbers. Userspace might get those through stat=
=2E
>>>>>>
>>>>>> How can userspace do the mapping backwards from this "anonymous"
>>>>>> major:minor number for these types of filesystems in such a way =
that
>>>>>> they can "know" how to report the block device that is causing t=
he
>>>>>> event?
>>>>>>
>>>>>> thanks,
>>>>>>
>>>>>> greg k-h
>>>>>>
>>>>>
>>>>> It needs to be done internally by the app but is doable.
>>>>> The app knows what it is watching, so it can maintain the mapping=
s.
>>>>> So prior to activating the notifications it can call 'stat' on th=
e mount point.
>>>>> Stat struct gives the 'st_dev' which is the device id. Same will =
be reported
>>>>> within the message payload (through major:minor numbers). So havi=
ng this,
>>>>> the app is able to get any other information it needs.=20
>>>>> Note that the events refer to the file system as a whole and they=
 may not
>>>>> necessarily have anything to do with the actual block device.=20
>>>
>>> How are you going to show an event for a filesystem that is made up=
 of
>>> multiple block devices?
>>>
>>>>   Or you can use /proc/self/mountinfo for the mapping. There you c=
an see
>>>> device numbers, real device names if applicable and mountpoints. T=
his has
>>>> the advantage that it works even if filesystem mountpoints change.
>>>
>>> Ok, then that brings up my next question, how does this handle
>>> namespaces?  What namespace is the event being sent in?  block devi=
ces
>>> aren't namespaced, but the mount points are, is that going to cause
>>> problems?
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Getting back to the namespaces ...=20
>> In the current state the notifications will be sent to the init netw=
ork namespace,
>> which means that processes belonging to a different net namespace wi=
ll not
>> be able to receive them. To be more precise, those processes will no=
t be=20
>> able to subscribe to the multicast group, though this can be easily =
changed.
>> Furthermore, the notifications might also be sent to specific namesp=
ace.
>> In this case, the one, with which the trace for the mount point has =
been registered,
>> which as I believe would be the best approach.
>>
>> As for the mount namespaces, reading the config file needs to be sli=
ghtly tweaked,=20
>> to hide away all the registered mount points which does not belong t=
o the current
>> mount namespace.
>>
>> Still, there is one possible 'issue' - the private/slave mount point=
s.=20
>> As the notifications will be sent to all the listeners (within the s=
ame netns),
>> the events might be visible to processes outside the given mount ns.
>> This should be limited to only those listeners that share the mount =
namespace,
>> to which such private/slave mount points belong. As using the generi=
c netlink
>> to filter the outgoing messages is doable (with small changes to cur=
rent
>> implementation), the filters themselves seem rather cumbersome, as t=
hey would require
>> finding the socket=E2=80=99s owner mount namespace, which just doesn=
't seems right.
>> On the other hand, identifying the file system, which generated the =
event, will
>> not be possible for processes outside such namespace, as device majo=
r:minor
>> numbers are not bound to any namespace (afaict) so they will not pro=
vide any
>> valid information. They will remain unresolved.
>>
>> The best way out here though, is to leave it to userspace to properl=
y setup new namespaces:
>> the mount namespace with possible private/slave mounts should have a=
 separate=20
>> network namespace to isolate the potential fs events, if required.
>>
>>
>> BR
>> Beata
>>
>>
>>
>=20
> I'm not really sure where we are with this RFC now (?).
> Just wanted to let You know I won't be available for the next two wee=
ks,
> in case this comes around.
>=20
> Best Regards
> Beata
>=20
>=20

Things has gone a bit quiet thread wise ...
As I believe I've managed to snap back to reality, I was hoping we coul=
d continue with this?
I'm not sure if we've got everything cleared up or ... have we reached =
a dead end?
Please let me know if we can move to the next stage? Or, if there are a=
ny showstoppers?

Thank You,

Best Regards
Beata
