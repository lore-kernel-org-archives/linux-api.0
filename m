From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 28/33] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #11]
Date: Sat, 11 Aug 2018 21:20:08 +0100
Message-ID: <5152.1534018808@warthog.procyon.org.uk>
References: <CAJfpegvWE9htLjqeR6=2BWBSuvJzJpWcjBC_EmX_k1RCGXTfbw@mail.gmail.com> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk> <87in4n9zg0.fsf@xmission.com> <27374.1533824694@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvWE9htLjqeR6=2BWBSuvJzJpWcjBC_EmX_k1RCGXTfbw@mail.gmail.com>
Content-ID: <5151.1534018808.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> You can determine at fsopen() time whether the filesystem is able to
> support the O_EXCL behavior?  If so, then it's trivial to enable this
> conditionally.  I think that's what Eric is asking for, it's obviously
> not fair to ask for a change in behavior of the legacy interface.

It's not trivial, see btrfs and nfs :-/

David
