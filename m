From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 02/25] vfs: Allow fsinfo() to query what's in an fs_context [ver #13]
Date: Fri, 21 Jun 2019 15:50:50 +0100
Message-ID: <27768.1561128650@warthog.procyon.org.uk>
References: <20190621132839.6ggsppexqfp5htpw@brauner.io> <20190621094757.zijugn6cfulmchnf@brauner.io> <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk> <155905627927.1662.13276277442207649583.stgit@warthog.procyon.org.uk> <21652.1561122763@warthog.procyon.org.uk> <E76F5188-CED8-4472-9136-BDCDFDAF57F0@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621132839.6ggsppexqfp5htpw@brauner.io>
Content-ID: <27767.1561128650.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian@brauner.io> wrote:

> > >If you tried to go through /proc/pid/fd with open(O_PATH), I think
> > >you'd get
> > >the symlink, not the target.
> > 
> > Then you should use fdget(), no? :)
> 
> That is unless you want fsinfo() to be useable on any fd and just fds
> that are returned from the new mount-api syscalls. Maybe that wasn't
> clear from my first mail.

fsinfo(), as coded, is usable on any fd, as for fstat(), statx() and
fstatfs().

I have made it such that if you do this on the fd returned by fsopen() or
fspick(), the access is diverted to the filesystem that the fs_context refers
to since querying anon_inodes is of little value.

Now, it could be argued that it should require an AT_xxx flag to cause this
diversion to happen.

> Is the information returned for:
> 
> int fd = fsopen()/fspick();
> fsinfo(fd);
> 
> int ofd = open("/", O_PATH);
> fsinfo(ofd, ...);
> 
> the same if they refer to the same mount or would they differ?

At the moment it differs.  In the former case, there may not even be a
superblock attached to the fd to query, though invariants like filesystem
parameter types and names can be queried.

David
