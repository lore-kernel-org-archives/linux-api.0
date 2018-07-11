From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Wed, 11 Jul 2018 09:51:59 -0600
Message-ID: <20180711095159.08e5435c@lwn.net>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
        <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 10 Jul 2018 23:44:09 +0100
David Howells <dhowells@redhat.com> wrote:

> 	sfd = fsopen("ext4", FSOPEN_CLOEXEC);
> 	write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
> 	write(sfd, "o noatime");
> 	write(sfd, "o acl");
> 	write(sfd, "o user_attr");
> 	write(sfd, "o iversion");
> 	write(sfd, "o ");
> 	write(sfd, "r /my/container"); // root inside the fs
> 	write(sfd, "x create"); // create the superblock

A minor detail but ... the "r" operation mentioned above is not actually
implemented in this system call.

jon
