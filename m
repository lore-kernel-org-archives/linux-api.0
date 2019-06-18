From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 04/25] vfs: Implement parameter value retrieval with fsinfo() [ver #13]
Date: Tue, 18 Jun 2019 23:34:49 +0100
Message-ID: <24127.1560897289@warthog.procyon.org.uk>
References: <CAJfpegutheVtnmN6BFSjzrmz8p9+DpZxFoKa4CoShoh4MW+5gQ@mail.gmail.com> <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk> <155905629702.1662.7233272785972036117.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegutheVtnmN6BFSjzrmz8p9+DpZxFoKa4CoShoh4MW+5gQ@mail.gmail.com>
Content-ID: <24126.1560897289.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Again, don't blindly transform s_flags into options, because some of
> them may have been internally manipulated by the filesystem.

In what filesystems do I need to undo this manipulation?

> You could do a helper for filesystems that does the the common ones
> (ro/sync/dirsync) but all of that *should* go through the filesystem.

I don't agree, but since you keep insisting, I've changed the helper function
that renders these so that it now takes s_flags as an argument and is called
from generic_fsinfo() if the filesystem doesn't handle FSINFO_ATTR_PARAMETERS.

Therefore, every filesystem that handles FSINFO_ATTR_PARAMETERS, *must* call
the function itself (or do the noting directly) otherwise these parameters
will not get rendered.

The helper function has been exported, and the calling filesystem can give any
s_flags it likes.  All the filesystems so far just use
path->dentry->d_sb->s_flags.

> Same goes for vfs_parse_sb_flag() btw.   It should be moved into each
> filesystem's ->parse_param() and not be a mandatory thing.

I disagree.  Every filesystem *must* be able to accept these standard flags,
even if it then ignores them.

David
