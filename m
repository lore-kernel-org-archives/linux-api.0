From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 22:00:18 +0100
Message-ID: <17749.1531429218@warthog.procyon.org.uk>
References: <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <7002.1531407244@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, tycho@tycho.ws
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> fsconfigure(contextfd, ADD_BLOCKDEV, dfd, path, flags);
> 
> fsconfigure(contextfd, ADD_OPTION, 0, “foo=bar”, flags);

That seems okayish.  I'm not sure we need the flags, but I do want to allow
for binary data in an option.  So perhaps something like:

	int fsconfig(int fd, unsigned int type,
		     const char *key, const void *val, size_t val_len);

for example:

	fd = fsopen("ext4", FSOPEN_CLOEXEC);
	fsconfig(fd, fsconfig_blockdev, "dev.data", "/dev/sda1", ...);
	fsconfig(fd, fsconfig_blockdev, "dev.journal", "/dev/sda2", ...);
	fsconfig(fd, fsconfig_option, "user_xattr", NULL, ...);
	fsconfig(fd, fsconfig_option, "errors", "continue", ...);
	fsconfig(fd, fsconfig_option, "data", "journal", ...);
	fsconfig(fd, fsconfig_security, "selinux.context", "unconfined_u:...");
	fsconfig(fd, fsconfig_create, NULL, NULL, 0);
	mfd = fsmount(fd, FSMOUNT_CLOEXEC, MS_NOEXEC);

or:

	fd = fsopen("nfs", FSOPEN_CLOEXEC);
	fsconfig(fd, fsconfig_namespace, "user", "<usernsfd>", ...);
	fsconfig(fd, fsconfig_namespace, "net", "<netnsfd>", ...);
	fsconfig(fd, fsconfig_option, "server", "foo.com", ...);
	fsconfig(fd, fsconfig_option, "root", "/bar", ...);
	fsconfig(fd, fsconfig_option, "soft", NULL, ...);
	fsconfig(fd, fsconfig_option, "retry", "3", ...);
	fsconfig(fd, fsconfig_option, "wsize", "4096", ...);
	fsconfig(fd, fsconfig_uidmap, "dhowells", "1234", ...);
	fsconfig(fd, fsconfig_security, "selinux.context", "unconfined_u:...");
	fsconfig(fd, fsconfig_create, NULL, NULL, 0);
	mfd = fsmount(fd, FSMOUNT_CLOEXEC, MS_NOEXEC);

This does mean that userspace has to work harder, though, but it would
simplify the LSM interface internally.

Al Viro <viro@ftp.linux.org.uk>

> First of all, block device *IS* a fucking option.

Whilst that is true, I still need to be able to separate it out for
unconverted filesystems.

David
