From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 15:29:24 +0100
Message-ID: <201101251529.24779.arnd@arndb.de>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, GLIBC Devel <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-ports-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday 24 January 2011, Linas Vepstas wrote:
> Chris, Arnd, all,

[adding linux-api list]

> Found a bug/incompatibility in the generic syscalls chmod implementation;
> not sure if this is a kernel bug or a glibc bug, or how to correctly resolve it.
> 
> The new "generic chmod" implementation for glibc sends chmod to the
> kernel call sys_fchmodat with  AT_FDCWD, instead of using the older
> "deprecated" chmod syscall.  These two behave slightly differently:  with
> the new implementation, the file "" (i.e. string of length zero) gets
> interpreted
> as . and so the syscall succeeds, setting perms on .  The old syscall would
> return an errno=2 No such file or directory for this filename.
> 
> My gut instinct is that this is a kernel bug, but am not so sure; perhaps this
> is "working as designed".  I thought of submitting a patch to fs/namei.c to
> fix this, but then got lost in the details: there didn't seem to be
> any particularly
> good place to add this check.  Meanwhile, a glibc test case (posix/tst-chmod.c)
> is failing as a result.
> 
> Should we put a check for this funky non-filename into the glibc
> generic code, or into sys_chmodat? Recommendations?

My feeling is that it should be in glibc: as Mike mentioned, we don't normally
change the behavior of existing system calls unless they are obviously
broken to start with. If we want to keep fchmodat getting the implicit
"." directory, and at the same time keep fchmod returning an error, the fchmod
wrapper around fchmodat is the only place that can enforce this.

	Arnd
