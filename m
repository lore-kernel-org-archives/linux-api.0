From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 00/10] Mount, FS, Block and Keyrings notifications
 [ver #3]
Date: Thu, 6 Jun 2019 09:43:37 -0700
Message-ID: <0eb007c5-b4a0-9384-d915-37b0e5a158bf@schaufler-ca.com>
References: <b91710d8-cd2d-6b93-8619-130b9d15983d@tycho.nsa.gov>
 <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
 <3813.1559827003@warthog.procyon.org.uk>
 <8382af23-548c-f162-0e82-11e308049735@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8382af23-548c-f162-0e82-11e308049735@tycho.nsa.gov>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>, David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 6/6/2019 7:05 AM, Stephen Smalley wrote:
> On 6/6/19 9:16 AM, David Howells wrote:
>> Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>
>> This might be easier to discuss if you can reply to:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0https://lore.kernel.org/lkml/5393.1559768763@w=
arthog.procyon.org.uk/
>>
>> which is on the ver #2 posting of this patchset.
>
> Sorry for being late to the party.=C2=A0 Not sure whether you're asking=
 me to respond only there or both there and here to your comments below.=C2=
=A0 I'll start here but can revisit if it's a problem.
>>
>>>> LSM support is included, but controversial:
>>>>
>>>> =C2=A0=C2=A0 (1) The creds of the process that did the fput() that r=
educed the refcount
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to zero are cached in the file =
struct.
>>>>
>>>> =C2=A0=C2=A0 (2) __fput() overrides the current creds with the creds=
 from (1) whilst
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 doing the cleanup, thereby maki=
ng sure that the creds seen by the
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 destruction notification genera=
ted by mntput() appears to come from
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the last fputter.
>>>>
>>>> =C2=A0=C2=A0 (3) security_post_notification() is called for each que=
ue that we might
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 want to post a notification int=
o, thereby allowing the LSM to prevent
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 covert communications.
>>>>
>>>> =C2=A0=C2=A0 (?) Do I need to add security_set_watch(), say, to rule=
 on whether a watch
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 may be set in the first place?=C2=
=A0 I might need to add a variant per
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 watch-type.
>>>>
>>>> =C2=A0=C2=A0 (?) Do I really need to keep track of the process creds=
 in which an
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 implicit object destruction hap=
pened?=C2=A0 For example, imagine you create
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 an fd with fsopen()/fsmount().=C2=
=A0 It is marked to dissolve the mount it
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refers to on close unless move_=
mount() clears that flag.=C2=A0 Now, imagine
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 someone looking at that fd thro=
ugh procfs at the same time as you exit
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 due to an error.=C2=A0 The LSM =
sees the destruction notification come from
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the looker if they happen to do=
 their fput() after yours.
>>>
>>>
>>> I'm not in favor of this approach.
>>
>> Which bit?=C2=A0 The last point?=C2=A0 Keeping track of the process cr=
eds after an
>> implicit object destruction.
>
> (1), (2), (3), and the last point.
>
>>> Can we check permission to the object being watched when a watch is s=
et
>>> (read-like access),
>>
>> Yes, and I need to do that.=C2=A0 I think it's likely to require an ex=
tra hook for
>> each entry point added because the objects are different:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0int security_watch_key(struct watch *watch, st=
ruct key *key);
>> =C2=A0=C2=A0=C2=A0=C2=A0int security_watch_sb(struct watch *watch, str=
uct path *path);
>> =C2=A0=C2=A0=C2=A0=C2=A0int security_watch_mount(struct watch *watch, =
struct path *path);
>> =C2=A0=C2=A0=C2=A0=C2=A0int security_watch_devices(struct watch *watch=
);
>>
>>> make sure every access that can trigger a notification requires a
>>> (write-like) permission to the accessed object,
>>
>> "write-like permssion" for whom?=C2=A0 The triggerer or the watcher?
>
> The former, i.e. the process that performed the operation that triggere=
d the notification.=C2=A0 Think of it as a write from the process to the =
accessed object, which triggers a notification (another write) on some re=
lated object (the watched object), which is then read by the watcher.

We agree that the process that performed the operation that triggered
the notification is the initial subject. Smack will treat the process
with the watch set (in particular, its ring buffer) as the object
being written to. SELinux, with its finer grained controls, will
involve other things as noted above. There are other place where we
see this, notably IP packet delivery.

The implication is that the information about the triggering
process needs to be available throughout.

>
>> There are various 'classes' of events:
>>
>> =C2=A0 (1) System events (eg. hardware I/O errors, automount points ex=
piring).
>>
>> =C2=A0 (2) Direct events (eg. automounts, manual mounts, EDQUOT, key l=
inkage).
>>
>> =C2=A0 (3) Indirect events (eg. exit/close doing the last fput and cau=
sing an
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unmount).
>>
>> Class (1) are uncaused by a process, so I use init_cred for them.=C2=A0=
 One could
>> argue that the automount point expiry should perhaps take place under =
the
>> creds of whoever triggered it in the first place, but we need to be ca=
reful
>> about long-term cred pinning.
>
> This seems equivalent to just checking whether the watcher is allowed t=
o get that kind of event, no other cred truly needed.
>
>> Class (2) the causing process must've had permission to cause them - o=
therwise
>> we wouldn't have got the event.
>
> So we've already done a check on the causing process, and we're going t=
o check whether the watcher can set the watch. We just need to establish =
the connection between the accessed object and the watched object in some=
 manner.

I don't agree. That is, I don't believe it is sufficient.
There is no guarantee that being able to set a watch on an
object implies that every process that can trigger the event
can send it to you.

	Watcher has Smack label W
	Triggerer has Smack label T
	Watched object has Smack label O

	Relevant Smack rules are

	W O rw
	T O rw

The watcher will be able to set the watch,
the triggerer will be able to trigger the event,
but there is nothing that would allow the watcher
to receive the event. This is not a case of watcher
reading the watched object, as the event is delivered
without any action by watcher.

>
>> Class (3) is interesting since it's currently entirely cleanup events =
and the
>> process may have the right to do them (close, dup2, exit, but also exe=
cve)
>> whether the LSM thinks it should be able to cause the object to be des=
troyed
>> or not.
>>
>> It gets more complicated than that, though: multiple processes with di=
fferent
>> security attributes can all have fds pointing to a common file object =
- and
>> the last one to close carries the can as far as the LSM is concerned.
>
> Yes, I'd prefer to avoid that.=C2=A0 You can't write policy that is sta=
ble and meaningful that way.=C2=A0 This may fall under a similar situatio=
n as class (1) - all we can meaningfully do is check whether the watcher =
is allowed to see all such events.

Back in the day when we were doing security evaluations
the implications of "deleting" an object gave the security
evaluators fits. UNIX/Linux files don't get deleted, they
simply fall off the filesystem namespace when no one cares
about them anymore. The model we used back in the day was
that "delete" wasn't an operation that occurs on filesystem
objects.

But now you want to do something with security implications
when the object disappears. We could say that the event does
nothing but signal that the system has removed the watch on
your behalf because it is now meaningless. No reason to worry
about who dropped the last reference. We don't care about
that from a policy viewpoint anyway.

>
>> And yet more complicated when you throw in unix sockets with partially=
 passed
>> fds still in their queues.=C2=A0 That's what patch 01 is designed to t=
ry and cope
>> with.
>>
>>> and make sure there is some sane way to control the relationship betw=
een the
>>> accessed object and the watched object (write-like)?
>>
>> This is the trick.=C2=A0 Keys and superblocks have object labels of th=
eir own and
>> don't - for now - propagate their watches.=C2=A0 With these, the watch=
 is on the
>> object you initially assign it to and it goes no further than that.
>>
>> mount_notify() is the interesting case since we want to be able to det=
ect
>> mount topology change events from within the vfs subtree rooted at the=
 watched
>> directory without having to manually put a watch on every directory in=
 that
>> subtree - or even just every mount object. >
>> Or, maybe, that's what I'll have to do: make it mount_notify() can onl=
y apply
>> to the subtree within its superblock, and the caller must call mount_n=
otify()
>> for every mount object it wants to monitor.=C2=A0 That would at least =
ensure that
>> the caller can, at that point, reach all those mount points.
>
> Would that at least make it consistent with fanotify (not that it provi=
des a great example)?
>
>>> For cases where we have no object per se or at least no security
>>> structure/label associated with it, we may have to fall back to a
>>> coarse-grained "Can the watcher get this kind of notification in gene=
ral?".
>>
>> Agreed - and we should probably have that anyway.
>>
>> David
