From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Tue, 17 Jul 2018 10:40:41 +0100
Message-ID: <11586.1531820441@warthog.procyon.org.uk>
References: <F80F34FD-CFD3-4A53-AECC-AEC8D9EF3EAE@amacapital.net> <CA+55aFzaTQJp6aHG_9+W2ShxeZncq7k9G3FkVFjFm7W=ECUiMw@mail.gmail.com> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <7002.1531407244@warthog.procyon.org.uk> <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net> <17749.1531429218@warthog.procyon.org.uk> <21131.1531488422@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F80F34FD-CFD3-4A53-AECC-AEC8D9EF3EAE@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> > Whilst I'm at it, do we want the option of doing the equivalent of
> > mountat()?  I.e. offering the option to open all the device files used by
> > a superblock with dfd and AT_* flags in combination with the filename?
> > 
> 
> Isn’t that more or less what I was suggesting?  I suggested dfd and path and I also suggested just an fd and letting the caller open the file itself.

Do we need AT_* flags?  There are three that we could use:

	AT_SYMLINK_NOFOLLOW
	AT_NO_AUTOMOUNT
	AT_EMPTY_PATH

AT_EMPTY_PATH I can see, but I don't see it as likely that we'd want to use
the other two for selecting a source?  Note that we can always do:

	fsfd = fsopen("ext4");
	sfd = open("/dev/", O_PATH);
	fsconfig(fsfd, fsconfig_set_path, "journal_path", "sda1", sfd);

or:

	fsfd = fsopen("ext4");
	sfd = open("/dev/sda1", O_PATH);
	fsconfig(fsfd, fsconfig_set_path_empty, "journal_path", "", sfd);

or:

	fsfd = fsopen("ext4");
	jfd = open("/dev/sda1", O_RDWR);
	fsconfig(fsfd, fsconfig_set_fd, "journal_path", NULL, jfd);

assuming the open on the latter doesn't exclude the use by the filesystem.

This way I don't need a second syscall or a 6-arg syscall to handle path
specification.

David
