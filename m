From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 19:15:05 +0200
Message-ID: <20180712171505.GA23780@kroah.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 10, 2018 at 11:44:09PM +0100, David Howells wrote:
> Provide an fsopen() system call that starts the process of preparing to
> create a superblock that will then be mountable, using an fd as a context
> handle.  fsopen() is given the name of the filesystem that will be used:
> 
> 	int mfd = fsopen(const char *fsname, unsigned int flags);
> 
> where flags can be 0 or FSOPEN_CLOEXEC.
> 
> For example:
> 
> 	sfd = fsopen("ext4", FSOPEN_CLOEXEC);
> 	write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
> 	write(sfd, "o noatime");
> 	write(sfd, "o acl");
> 	write(sfd, "o user_attr");
> 	write(sfd, "o iversion");
> 	write(sfd, "o ");
> 	write(sfd, "r /my/container"); // root inside the fs
> 	write(sfd, "x create"); // create the superblock

Ugh, creating configfs again in a syscall form?  I know people love
file descriptors, but can't you do this with a configfs entry instead if
you really want to do this type of thing from userspace in this type of
"style"?

Why reinvent the wheel again?

thanks,

greg k-h
