From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 28/33] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #11]
Date: Thu, 09 Aug 2018 15:24:54 +0100
Message-ID: <27374.1533824694@warthog.procyon.org.uk>
References: <87in4n9zg0.fsf@xmission.com> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87in4n9zg0.fsf@xmission.com>
Content-ID: <27373.1533824694.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> First let me thank you for adding both FSCONFIG_CMD_CREATE and
> FSCONFIG_CMD_RECONFIGURE.  Unfortunately the implementation is currently
> broken.  So this patch gets my:
> 
> This is broken in two specific ways.
> ...
> 2) FSCONFIG_CMD_CREATE will succeed even if the superblock already
>    exists and it can not use all of the superblock parameters.
> 
>    This happens because vfs_get_super will only call fill_super
>    if the super block is created.  Which is reasonable on the face
>    of it.  But it in practice this introduces security problems.
> 
>    a) Either through reconfiguring a shared super block you did not
>       realize was shared (as we saw with devpts).
> 
>    b) Mounting a super block and not honoring it's mount options
>       because something has already mounted it.  As we see today
>       with proc.  Leaving userspace to think the filesystem will behave
>       one way when in fact it behaves another.
> 
> I have already explained this several times, and apparently I have been
> ignored.  This fundamental usability issue that leads to security
> problems.

I've also explained why you're wrong or at least only partially right.  I *do*
*not* want to implement sget() in userspace with the ability for userspace to
lock out other mount requests - which is what it appears that you've been
asking for.

However, as I have said, I *am* willing to add one of more flags to help with
this, but I can't make any "legacy" fs honour them as this requires the
fs_context to be passed down to sget_fc() and the filesystem - which is why I
was considering leaving it for later.

 (1) An FSOPEN_EXCL flag to tell sget_fc() to fail if the superblock already
     exists at all.

 (2) An FSOPEN_FAIL_ON_MISMATCH flag to explicitly say that we *don't* want a
     superblock with different parameters.

The implication of providing neither flag is that we are happy to accept a
superblock from the same source but with different parameters.

But it doesn't seem to be an absolute imperative to roll this out immediately,
since what I have exactly mirrors what the kernel currently does - and forcing
a change in that behaviour risks breaking userspace.  If it keeps you happy,
however, I can try and work one up.

David
