From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 04/25] vfs: Implement parameter value retrieval with
 fsinfo() [ver #13]
Date: Wed, 19 Jun 2019 08:33:40 +0200
Message-ID: <CAJfpegtXp0bQRFGaZia_MGmFGFjKG5XoCnDCy=onmsWBJGHMHw@mail.gmail.com>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905629702.1662.7233272785972036117.stgit@warthog.procyon.org.uk>
 <CAJfpegutheVtnmN6BFSjzrmz8p9+DpZxFoKa4CoShoh4MW+5gQ@mail.gmail.com> <24127.1560897289@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <24127.1560897289@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 19, 2019 at 12:34 AM David Howells <dhowells@redhat.com> wrote:

> > Same goes for vfs_parse_sb_flag() btw.   It should be moved into each
> > filesystem's ->parse_param() and not be a mandatory thing.
>
> I disagree.  Every filesystem *must* be able to accept these standard flags,
> even if it then ignores them.

"posixacl" is not a standard flag.  It never was accepted by mount(8)
so I don't see where you got that from.

Can you explain why you think "mand", "sync", "dirsync", "lazytime"
should be accepted by a filesystem such as proc?  The argument that it
breaks userspace is BS, because this is a new interface, hence by
definition we cannot break old userspace.  If mount(8) wants to use
the new API and there really is breakage if these options are rejected
(which I doubt) then it can easily work around that by ignoring them
itself.

Also why should "rw" not be rejected for filesystems which are
read-only by definition, such as iso9660?

Thanks,
Miklos
