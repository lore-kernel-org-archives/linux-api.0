From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Wed, 11 Jul 2018 09:38:35 -0700
Message-ID: <20180711163835.GB27454@gmail.com>
References: <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
 <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <22370.1531293761@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <22370.1531293761@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, jannh@google.com
List-Id: linux-api@vger.kernel.org

On Wed, Jul 11, 2018 at 08:22:41AM +0100, David Howells wrote:
> Andy Lutomirski <luto@amacapital.net> wrote:
> 
> > >    sfd = fsopen("ext4", FSOPEN_CLOEXEC);
> > >    write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
> > 
> > Imagine some malicious program passes sfd as stdout to a setuid
> > program. That program gets persuaded to write "s /etc/shadow".  What
> > happens?  You’re okay as long as *every single fs* gets it right, but that’s
> > asking a lot.
> 
> Do note that you must already have CAP_SYS_ADMIN to be able to call fsopen().
> 
> David

Not really, by default an unprivileged user can still do:

	unshare(CLONE_NEWUSER|CLONE_NEWNS);
	syscall(__NR_fsopen, "ext4", 0);

- Eric
