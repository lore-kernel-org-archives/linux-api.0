From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 30/38] vfs: syscall: Add fsmount() to create a mount for a superblock [ver #10]
Date: Fri, 27 Jul 2018 23:06:19 +0100
Message-ID: <8835.1532729179@warthog.procyon.org.uk>
References: <D09916DC-DA22-48AA-A62B-F874BB3C15BC@amacapital.net> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271288242.9458.18050138471208178879.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D09916DC-DA22-48AA-A62B-F874BB3C15BC@amacapital.net>
Content-ID: <8834.1532729179.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> I have a potentially silly objection. For the old timers, "mount" means to
> stick a reel of tape or some similar object onto a reader, which seems to
> imply that "mount" means to start up the filesystem. For younguns, this
> meaning is probably lost, and the more obvious meaning is to "mount" it into
> some location in the VFS hierarchy a la vfsmount. The patch description
> doesn't disambiguate it, and obviously people used to mount(2)/mount(8) are
> just likely to be confused.

The problem is that inside the kernel it *is* a "mount".

How about I change the first paragraph to:

	Provide a system call by which a filesystem opened with fsopen() and
	configured by a series of fsconfig() calls can have a detached mount
	object created for it.  This mount object can then be attached to the
	VFS mount hierarchy using move_mount() by passing the returned file
	descriptor as the from directory fd.

> At the very least, your description should make it absolutely clear what you
> mean. Even better IMO would be to drop the use of the word "mount" entirely

I'm not sure that's a reasonable idea, given the "mounting" is how this is
done.

Can you suggest a word that encapsulates what it is that fsmount() returns?
It's almost, but not quite identical with what open(O_PATH) returns, since it
has to be torn down if not actually mounted somewhere when the fd is closed.

> and maybe rename the syscall.
> 
> From a very brief reading, I think you are giving it the meaning that would
> be implied by fsstart(2).

Do you have a reference for the manpage for that?  Google doesn't seem to find
it.

David
