From: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 09:45:15 -0800 (PST)
Message-ID: <20110125174515.C1DC2183C19@magilla.sf.frob.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
	<201101251529.24779.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Arnd Bergmann's message of  Tuesday, 25 January 2011 15:29:24 +0100 <201101251529.24779.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, GLIBC Devel <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-ports-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> My feeling is that it should be in glibc: as Mike mentioned, we don't normally
> change the behavior of existing system calls unless they are obviously
> broken to start with. If we want to keep fchmodat getting the implicit
> "." directory, and at the same time keep fchmod returning an error, the fchmod
> wrapper around fchmodat is the only place that can enforce this.

My point was that it's quite arguable that the *at syscall interfaces were
broken to begin with.  I've never seen anything suggesting their intent was
other than to permit relative pathnames, and the empty string has never
been a valid relative pathname.  To fit the POSIX requirements as I read
them, the *at functions must refuse to resolve the empty string.  So if the
kernel does not change and my interpretation of POSIX stands, then libc
must wrap all the *at syscalls with a function that checks for the empty
string and fails with ENOENT as a special case.

I don't have any strong opinion about this subject, but it makes the most
sense to me for the kernel's behavior to change.  I know of no reason to
think that the current treatment of the empty string was ever intended at
the creation of the *at interfaces.


Thanks,
Roland
