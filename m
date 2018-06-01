From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 30/32] vfs: Allow cloning of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8]
Date: Fri, 01 Jun 2018 09:42:15 +0100
Message-ID: <7264.1527842535@warthog.procyon.org.uk>
References: <CAOQ4uxjbZEyqNPwE8m0QmCU7OG831r4Lpg+M1RWCOxDrsgErnA@mail.gmail.com> <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk> <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjbZEyqNPwE8m0QmCU7OG831r4Lpg+M1RWCOxDrsgErnA@mail.gmail.com>
Content-ID: <7263.1527842535.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-afs@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Amir Goldstein <amir73il@gmail.com> wrote:

> Reject O_NON_RECURSIVE without O_CLONE_MOUNT?

Yes, I should add that.

> I am not sure what are the consequences of opening O_PATH with old kernel
> and getting an open file, can't think of anything bad.
> Can the same be claimed for O_PATH|O_CLONE_MOUNT?

Yes, actually, there can be consequences.  Some files have side effects.
Think open("/dev/foobar", O_PATH).

> Wouldn't it be better to apply the O_TMPFILE kludge to the new
> open flag, so that apps can check if O_CLONE_MOUNT feature is supported
> by kernel?

Ugh.  The problem is that the O_TMPFILE kludge can't be done because O_PATH
currently just masks off any bits it's not interested in rather than giving an
error.

Even the O_TMPFILE kludge doesn't protect you against someone having set
random unassigned bits when testing on a kernel that didn't support it.

And this bit:

	/*
	 * Clear out all open flags we don't know about so that we don't report
	 * them in fcntl(F_GETFD) or similar interfaces.
	 */
	flags &= VALID_OPEN_FLAGS;

is just plain wrong.  Effectively, it allows userspace to set random reserved
bits without consequences.  It should give an error instead.

Probably we should really replace open() and openat() both before we can
allocate any further open flags.

</grumble>

David
