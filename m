From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 30/32] vfs: Allow cloning of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8]
Date: Sat, 02 Jun 2018 16:45:21 +0100
Message-ID: <21804.1527954321@warthog.procyon.org.uk>
References: <20180602040434.GW30522@ZenIV.linux.org.uk> <20180601063928.GS30522@ZenIV.linux.org.uk> <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk> <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk> <20180601062654.GA32397@infradead.org> <7067.1527841663@warthog.procyon.org.uk> <20180602030913.GU30522@ZenIV.linux.org.uk> <20180602034255.GV30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180602040434.GW30522@ZenIV.linux.org.uk>
Content-ID: <21803.1527954321.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> TBH, I would probably prefer separate mount_setattr(2) for that kind
> of work, with something like
> 	int mount_setattr(int dirfd, const char *path, int flags, int attr)
> *not* opening any files.
> flags:
> 	AT_EMPTY_PATH, AT_NO_AUTOMOUNT, AT_RECURSIVE

I would call these MOUNT_SETATTR_* rather than AT_*.

> attr:
> 	MOUNT_SETATTR_DEV		(1<<0)
> 	MOUNT_SETATTR_NODEV		(1<<0)|(1<<1)
> 	MOUNT_SETATTR_EXEC		(1<<2)
> 	MOUNT_SETATTR_NOEXEC		(1<<2)|(1<<3)
> 	MOUNT_SETATTR_SUID		(1<<4)
> 	MOUNT_SETATTR_NOSUID		(1<<4)|(1<<5)
> 	MOUNT_SETATTR_RW		(1<<6)
> 	MOUNT_SETATTR_RO		(1<<6)|(1<<7)
> 	MOUNT_SETATTR_RELATIME		(1<<8)
> 	MOUNT_SETATTR_NOATIME		(1<<8)|(1<<9)
> 	MOUNT_SETATTR_NODIRATIME	(1<<8)|(2<<9)
> 	MOUNT_SETATTR_STRICTATIME	(1<<8)|(3<<9)
> 	MOUNT_SETATTR_PRIVATE		(1<<11)
> 	MOUNT_SETATTR_SHARED		(1<<11)|(1<<12)
> 	MOUNT_SETATTR_SLAVE		(1<<11)|(2<<12)
> 	MOUNT_SETATTR_UNBINDABLE	(1<<11)|(3<<12)

So, I like this generally, some notes though:

I wonder if this should be two separate parameters, a mask and the settings?
I'm not sure that's worth it since some of the mask bits would cover multiple
settings.

Also, should NODIRATIME be separate from the other *ATIME flags?  I do also
like treating some of these settings as enumerations rather than a set of
bits.

I would make the prototype:

	int mount_setattr(int dirfd, const char *path,
			  unsigned int flags, unsigned int attr,
			  void *reserved5);

Further, do we want to say you can either change the propagation type *or*
reconfigure the mountpoint restrictions, but not both at the same time?

> With either openat() used as in this series, or explicit
> 	int open_tree(int dirfd, const char *path, int flags)

Maybe open_mount(), grab_mount() or pick_mount()?

I wonder if fsopen()/fspick() should be create_fs()/open_fs()...

> returning a descriptor, with flags being
> 	AT_EMPTY_PATH, AT_NO_AUTOMOUNT, AT_RECURSIVE, AT_CLONE
> with AT_RECURSIVE without AT_CLONE being an error.

You also need an O_CLOEXEC equivalent.

I would make it:

	OPEN_TREE_CLOEXEC		0x00000001
	OPEN_TREE_EMPTY_PATH		0x00000002
	OPEN_TREE_FOLLOW_SYMLINK	0x00000004
	OPEN_TREE_NO_AUTOMOUNT		0x00000008
	OPEN_TREE_CLONE			0x00000010
	OPEN_TREE_RECURSIVE		0x00000020

adding the follow-symlinks so that you don't grab a symlink target by
accident.  (Can you actually mount on top of a symlink?)

> Hell, might even add AT_UMOUNT for "open root and detach, to be dissolved on
> close", incompatible with AT_CLONE.

Cute.  Guess you could do:

	fd = open_mount(..., OPEN_TREE_DETACH);
	mount_setattr(fd, "",
		      MOUNT_SETATTR_EMPTY_PATH,
		      MOUNT_SETATTR_NOSUID, NULL);
	move_mount(fd, "", ...);

David
