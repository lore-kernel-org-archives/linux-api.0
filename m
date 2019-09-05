From: David Howells <dhowells@redhat.com>
Subject: Why add the general notification queue and its sources
Date: Thu, 05 Sep 2019 18:01:47 +0100
Message-ID: <17703.1567702907@warthog.procyon.org.uk>
References: <CAHk-=wh5ZNE9pBwrnr5MX3iqkUP4nspz17rtozrSxs5-OGygNw@mail.gmail.com> <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wh5ZNE9pBwrnr5MX3iqkUP4nspz17rtozrSxs5-OGygNw@mail.gmail.com>
Content-ID: <17702.1567702907.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rstrode@redhat.com, swhiteho@redhat.com, nicolas.dichtel@6wind.com, raven@themaw.net, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, Christian Brauner <christian@brauner.io>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Here's a set of patches to add a general notification queue concept and to
> > add event sources such as:
> 
> Why?
> 
> I'm just going to be very blunt about this, and say that there is no
> way I can merge any of this *ever*, unless other people stand up and
> say that
> 
>  (a) they'll use it
> 
> and
> 
>  (b) they'll actively develop it and participate in testing and coding

Besides the core notification buffer which ties this together, there are a
number of sources that I've implemented, not all of which are in this patch
series:

 (1) Key/keyring notifications.

     If you have your kerberos tickets in a file/directory, your gnome desktop
     will monitor that using something like fanotify and tell you if your
     credentials cache changes.

     We also have the ability to cache your kerberos tickets in the session,
     user or persistent keyring so that it isn't left around on disk across a
     reboot or logout.  Keyrings, however, cannot currently be monitored
     asynchronously, so the desktop has to poll for it - not so good on a
     laptop.

     This source will allow the desktop to avoid the need to poll.

 (2) USB notifications.

     GregKH was looking for a way to do USB notifications as I was looking to
     find additional sources to implement.  I'm not sure how he wants to use
     them, but I'll let him speak to that himself.

 (3) Block notifications.

     This one I was thinking that I could make something like ddrescue better
     by letting it get notifications this way.  This was a target of
     convenience since I had a dodgy disk I was trying to rescue.

     It could also potentially be used help systemd, say, detect broken
     devices and avoid trying to unmount them when trying to reboot the machine.

     I can drop this for now if you prefer.

 (4) Mount notifications.

     This one is wanted to avoid repeated trawling of /proc/mounts or similar
     to work out changes to the mount object attributes and mount topology.
     I'm told that the proc file holding the namespace_sem is a point of
     contention, especially as the process of generating the text descriptions
     of the mounts/superblocks can be quite involved.

     The notifications directly indicate the mounts involved in any particular
     event and what the change was.  You can poll /proc/mounts, but all you
     know is that something changed; you don't know what and you don't know
     how and reading that file may race with multiple changed being effected.

     I pair this with a new fsinfo() system call that allows, amongst other
     things, the ability to retrieve in one go an { id, change counter } tuple
     from all the children of a specified mount, allowing buffer overruns to
     be cleaned up quickly.

     It's not just Red Hat that's potentially interested in this:

	https://lore.kernel.org/linux-fsdevel/293c9bd3-f530-d75e-c353-ddeabac27cf6@6wind.com/

 (5) Superblock notifications.

     This one is provided to allow systemd or the desktop to more easily
     detect events such as I/O errors and EDQUOT/ENOSPC.

I've tried to make the core multipurpose so that the price of the code
footprint is mitigated.

David
