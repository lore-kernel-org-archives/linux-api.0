From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 30/32] vfs: Allow cloning of a mount tree with
 open(O_PATH|O_CLONE_MOUNT) [ver #8]
Date: Sat, 2 Jun 2018 05:04:34 +0100
Message-ID: <20180602040434.GW30522@ZenIV.linux.org.uk>
References: <20180601063928.GS30522@ZenIV.linux.org.uk>
 <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
 <20180601062654.GA32397@infradead.org>
 <7067.1527841663@warthog.procyon.org.uk>
 <20180602030913.GU30522@ZenIV.linux.org.uk>
 <20180602034255.GV30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180602034255.GV30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Jun 02, 2018 at 04:42:56AM +0100, Al Viro wrote:
> _If_ I'm interpreting that correctly, that should be something like a bitmap
> of attributes to modify + values to set for each.  Let's see -
> 	propagation	1 + 2 bits
> 	nodev		1 + 1
> 	noexec		1 + 1
> 	nosuid		1 + 1
> 	ro		1 + 1
> 	atime		1 + 3
> That's 15 bits.  On top of that, we have 1 bit for "clone or original"
> and 1 bit for "recursive or single-mount".  As well as AT_EMPTY_PATH,
> and AT_NO_AUTOMOUNT (inconvenient, since these are fixed bits).  In
> principle, that does fit into int, with some space to spare...
> 
> Is that what you have in mind?

TBH, I would probably prefer separate mount_setattr(2) for that kind
of work, with something like
	int mount_setattr(int dirfd, const char *path, int flags, int attr)
*not* opening any files.
flags:
	AT_EMPTY_PATH, AT_NO_AUTOMOUNT, AT_RECURSIVE
attr:
	MOUNT_SETATTR_DEV		(1<<0)
	MOUNT_SETATTR_NODEV		(1<<0)|(1<<1)
	MOUNT_SETATTR_EXEC		(1<<2)
	MOUNT_SETATTR_NOEXEC		(1<<2)|(1<<3)
	MOUNT_SETATTR_SUID		(1<<4)
	MOUNT_SETATTR_NOSUID		(1<<4)|(1<<5)
	MOUNT_SETATTR_RW		(1<<6)
	MOUNT_SETATTR_RO		(1<<6)|(1<<7)
	MOUNT_SETATTR_RELATIME		(1<<8)
	MOUNT_SETATTR_NOATIME		(1<<8)|(1<<9)
	MOUNT_SETATTR_NODIRATIME	(1<<8)|(2<<9)
	MOUNT_SETATTR_STRICTATIME	(1<<8)|(3<<9)
	MOUNT_SETATTR_PRIVATE		(1<<11)
	MOUNT_SETATTR_SHARED		(1<<11)|(1<<12)
	MOUNT_SETATTR_SLAVE		(1<<11)|(2<<12)
	MOUNT_SETATTR_UNBINDABLE	(1<<11)|(3<<12)

With either openat() used as in this series, or explicit
	int open_tree(int dirfd, const char *path, int flags)
returning a descriptor, with flags being
	AT_EMPTY_PATH, AT_NO_AUTOMOUNT, AT_RECURSIVE, AT_CLONE
with AT_RECURSIVE without AT_CLONE being an error.  Hell, might
even add AT_UMOUNT for "open root and detach, to be dissolved on
close", incompatible with AT_CLONE.

Comments?
