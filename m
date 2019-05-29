From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 0/7] Mount, FS, Block and Keyrings notifications
Date: Wed, 29 May 2019 10:09:44 +0100
Message-ID: <31751.1559120984@warthog.procyon.org.uk>
References: <20190528235810.GA5776@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528235810.GA5776@kroah.com>
Content-ID: <31750.1559120984.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

> >  (3) Letting users see events they shouldn't be able to see.
> 
> How are you handling namespaces then?  Are they determined by the
> namespace of the process that opened the original device handle, or the
> namespace that made the new syscall for the events to "start flowing"?

So far I haven't had to deal directly with namespaces.

mount_notify() requires you to have access to the mountpoint you want to watch
- and the entire tree rooted there is in one namespace, so your event sources
are restricted to that namespace.  Further, mount objects don't themselves
have any other namespaces, not even a user_ns.

sb_notify() requires you to have access to the superblock you want to watch.
superblocks aren't directly namespaced as a class, though individual
superblocks may participate in particular namespaces (ipc, net, etc.).  I'm
thinking some of these should be marked unwatchable (all pseudo superblocks,
kernfs-class, proc, for example).

Superblocks, however, do each have a user_ns - but you were allowed to access
the superblock by pathwalk, so you must have some access to the user_ns - I
think.

KEYCTL_NOTIFY requires you to have View access on the key you're watching.
Currently, keys have no real namespace restrictions, though I have patches to
include a namespace tag in the lookup criteria.

block_notify() doesn't require any direct access since you're watching a
global queue and there is no blockdev namespacing.  LSMs are given the option
to filter events, though.  The thought here is that if you can access dmesg,
you should be able to watch for blockdev events.


Actually, thinking further on this, restricting access to events is trickier
than I thought and than perhaps Casey was suggesting.

Say you're watching a mount object and someone in a different user_ns
namespace or with a different security label mounts on it.  What governs
whether you are allowed to see the event?

You're watching the object for changes - and it *has* changed.  Further, you
might be able to see the result of this change by other means (/proc/mounts,
for instance).

Should you be denied the event based on the security model?

On the other hand, if you're watching a tree of mount objects, it could be
argued that you should be denied access to events on any mount object you
can't reach by pathwalk.

On the third hand, if you can see it in /proc/mounts or by fsinfo(), you
should get an event for it.


> How are you handling namespaces then?

So to go back to the original question.  At the moment they haven't impinged
directly and I haven't had to deal with them directly.  There are indirect
namespace restrictions that I get for free just due to pathwalk, for instance.

David
