From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 29/38] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #10]
Date: Fri, 27 Jul 2018 22:51:40 +0100
Message-ID: <7034.1532728300@warthog.procyon.org.uk>
References: <CALCETrUXsOexKcj+K_v_bsW6DkGFgyNOaEs_qVOAcdNGBbEb2w@mail.gmail.com> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUXsOexKcj+K_v_bsW6DkGFgyNOaEs_qVOAcdNGBbEb2w@mail.gmail.com>
Content-ID: <7033.1532728300.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> Unless I'm rather confused, you have two or possibly three ways to
> pass in an open fd.  Can you clarify what the difference is and/or
> remove all but one of them?

No, they're not equivalent.

> >  (*) fsconfig_set_path: A non-empty path is specified.  The parameter must
> >      be expecting a path object.  value points to a NUL-terminated string
> >      that is the path and aux is a file descriptor at which to start a
> >      relative lookup or AT_FDCWD.

So, an example:

	fsconfig(fd, fsconfig_set_path, "source", "/dev/sda1", AT_FDCWD);

I don't want to require that the caller open /dev/sda1 and pass in an fd as
that might prevent the filesystem from "holding" it exclusively.

> >  (*) fsconfig_set_path_empty: As fsconfig_set_path, but with AT_EMPTY_PATH
> >      implied.

You can't do:

	fsconfig(fd, fsconfig_set_path, "source", "", dir_fd);

because AT_EMPTY_PATH cannot be specified directly[*].  What you do instead is:

	fsconfig(fd, fsconfig_set_path_empty, "source", "", dir_fd);

[*] Not without a 6-arg syscall or some other way of passing it.

I *could* require that the caller must call open(O_PATH) or openat(O_PATH)
before calling fsconfig() - so you don't pass a string, but only a path-fd.

> >  (*) fsconfig_set_fd: An open file descriptor is specified.  value must
> >      be NULL and aux indicates the file descriptor.

See fd=%u on fuse.  I think it's cleaner to do:

	fsconfig(fd, fsconfig_set_fd, "source", NULL, control_fd);

saying explicitly that there's an open file to be passed rather than:

	fsconfig(fd, fsconfig_set_path, "source", NULL, control_fd);

which indicates that you are actually providing a path.

David
