From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 28/33] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #11]
Date: Thu, 09 Aug 2018 17:33:20 +0100
Message-ID: <13160.1533832400@warthog.procyon.org.uk>
References: <CAJfpegvWE9htLjqeR6=2BWBSuvJzJpWcjBC_EmX_k1RCGXTfbw@mail.gmail.com> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk> <87in4n9zg0.fsf@xmission.com> <27374.1533824694@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvWE9htLjqeR6=2BWBSuvJzJpWcjBC_EmX_k1RCGXTfbw@mail.gmail.com>
Content-ID: <13159.1533832400.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> > However, as I have said, I *am* willing to add one of more flags to help
> > with this, but I can't make any "legacy" fs honour them as this requires
> > the fs_context to be passed down to sget_fc() and the filesystem - which
> > is why I was considering leaving it for later.
>
> You can determine at fsopen() time whether the filesystem is able to
> support the O_EXCL behavior?  If so, then it's trivial to enable this
> conditionally.  I think that's what Eric is asking for, it's obviously
> not fair to ask for a change in behavior of the legacy interface.

What do you mean by "enable it conditionally"?  It cannot be enabled for
filesystems that don't pass fs_context down to sget().

mount(2) mustn't enable it lest it break userspace.

fsopen(2) can let userspace set a flag to enable it.

David
