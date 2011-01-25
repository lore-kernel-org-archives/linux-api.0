From: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 10:34:37 -0800 (PST)
Message-ID: <20110125183437.7C6C2180999@magilla.sf.frob.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
	<201101251529.24779.arnd@arndb.de>
	<20110125174515.C1DC2183C19@magilla.sf.frob.com>
	<201101251921.15184.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Arnd Bergmann's message of  Tuesday, 25 January 2011 19:21:14 +0100 <201101251921.15184.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, GLIBC Devel <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-ports-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> On Tuesday 25 January 2011 18:45:15 Roland McGrath wrote:
> >  I know of no reason to
> > think that the current treatment of the empty string was ever intended at
> > the creation of the *at interfaces.
> 
> I always assumed that this was done so that the *at syscalls can replace
> both the ones that take a file descriptor (e.g. fstat) and the ones that
> take a pathname (e.g. stat), which is sensible for the non-AT_FDCWD case,
> although not documented in the man pages.

I see your point.  That is, having the empty string relative to a file
descriptor work means it can replace f* calls on non-directories, whereas
the standard method of passing "." for descriptor-relative resolution can
only work on a file descriptor open on a directory.  Is that what you mean?

I don't think this was part of the original intent when the calls were
added, but I suppose it makes sense.

> Treating the empty string special for AT_FDCWD is rather pointless, but
> at least consistent.

I agree about the consistency point.  However, one could also call it
consistent if the empty string fails to resolve when operating on either a
directory file descriptor or AT_FDCWD but works on a non-directory file
descriptor.  POSIX does not mandate that *at calls fail with ENOTDIR when
passed a non-directory file descriptor (it's a "may fail" error, not a
"shall fail" error).  So that behavior would be consistent both with the
POSIX requirements as I read them, and with the desire you mentioned to let
the fblahat system call serve to implement fblah as well as blah.  Then
libc would not have to wrap the *at calls with any special check to conform
to POSIX.


Thanks,
Roland
