From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 0/7] Mount, FS, Block and Keyrings notifications
Date: Wed, 29 May 2019 08:41:43 -0700
Message-ID: <c3d76089-cd0a-a378-f6e8-2fe6e9a5c254@schaufler-ca.com>
References: <20190528235810.GA5776@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <31751.1559120984@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <31751.1559120984@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 5/29/2019 2:09 AM, David Howells wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
>
>>>  (3) Letting users see events they shouldn't be able to see.
>> How are you handling namespaces then?  Are they determined by the
>> namespace of the process that opened the original device handle, or th=
e
>> namespace that made the new syscall for the events to "start flowing"?=

> So far I haven't had to deal directly with namespaces.
>
> mount_notify() requires you to have access to the mountpoint you want t=
o watch
> - and the entire tree rooted there is in one namespace, so your event s=
ources
> are restricted to that namespace.  Further, mount objects don't themsel=
ves
> have any other namespaces, not even a user_ns.
>
> sb_notify() requires you to have access to the superblock you want to w=
atch.
> superblocks aren't directly namespaced as a class, though individual
> superblocks may participate in particular namespaces (ipc, net, etc.). =
 I'm
> thinking some of these should be marked unwatchable (all pseudo superbl=
ocks,
> kernfs-class, proc, for example).
>
> Superblocks, however, do each have a user_ns - but you were allowed to =
access
> the superblock by pathwalk, so you must have some access to the user_ns=
 - I
> think.
>
> KEYCTL_NOTIFY requires you to have View access on the key you're watchi=
ng.
> Currently, keys have no real namespace restrictions, though I have patc=
hes to
> include a namespace tag in the lookup criteria.
>
> block_notify() doesn't require any direct access since you're watching =
a
> global queue and there is no blockdev namespacing.  LSMs are given the =
option
> to filter events, though.  The thought here is that if you can access d=
mesg,
> you should be able to watch for blockdev events.
>
>
> Actually, thinking further on this, restricting access to events is tri=
ckier
> than I thought and than perhaps Casey was suggesting.
>
> Say you're watching a mount object and someone in a different user_ns
> namespace or with a different security label mounts on it.  What govern=
s
> whether you are allowed to see the event?

Conceptually it should be simple, but we have a variety of different
policies in the core OS, never mind what goes on inside the LSMs.
If you want to treat a notification like a signal you would only deliver
it if the process that performed the action that triggered the event
has the same UID as the process receiving the notification. Should you
decide to treat it like an IP packet only the LSMs would filter delivery.=

If there are mode bits on the thing being watched shouldn't you respect
them?

> You're watching the object for changes - and it *has* changed.  Further=
, you
> might be able to see the result of this change by other means (/proc/mo=
unts,
> for instance).
>
> Should you be denied the event based on the security model?

=46rom a subject/object model view there are two objects and one
subject involved. The subject (active entity) is the process that
changes the first object, triggering an event. The watching process
(that will receive the notification) is the second object, because
its state will change (be written to) when the notification is
delivered. For the watching process to receive the notification
the changing process needs write access to the watching process.
The indirection of the notification mechanism isn't relevant.
If the changing process couldn't directly notify the watching process
it shouldn't be able to do it indirectly, either.

> On the other hand, if you're watching a tree of mount objects, it could=
 be
> argued that you should be denied access to events on any mount object y=
ou
> can't reach by pathwalk.
>
> On the third hand, if you can see it in /proc/mounts or by fsinfo(), yo=
u
> should get an event for it.

Right. We've done a pretty good job of muddling the security
landscape by adding spiffy features to make life easier for
particular use cases. /proc is chuck full of examples. Objects
that can be viewed in many different ways make for confusing
security models. Try explaining /proc/234/fd/2 to a security
theory student.

>> How are you handling namespaces then?
> So to go back to the original question.  At the moment they haven't imp=
inged
> directly and I haven't had to deal with them directly.  There are indir=
ect
> namespace restrictions that I get for free just due to pathwalk, for in=
stance.
>
> David
