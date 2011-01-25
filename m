From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 21:04:57 +0100
Message-ID: <201101252104.58011.arnd@arndb.de>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <201101251921.15184.arnd@arndb.de> <20110125183437.7C6C2180999@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110125183437.7C6C2180999-nL1rrgvulkc2UH6IwYuUx0EOCMrvLtNR@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, GLIBC Devel <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-ports-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tuesday 25 January 2011 19:34:37 Roland McGrath wrote:
> I don't think this was part of the original intent when the calls were
> added, but I suppose it makes sense.

More importantly, even if it was never meant this way, anyone could have
assumed that it was and started using the system call in this way.

> > Treating the empty string special for AT_FDCWD is rather pointless, but
> > at least consistent.
> 
> I agree about the consistency point.  However, one could also call it
> consistent if the empty string fails to resolve when operating on either a
> directory file descriptor or AT_FDCWD but works on a non-directory file
> descriptor. 

Yes.

> POSIX does not mandate that *at calls fail with ENOTDIR when
> passed a non-directory file descriptor (it's a "may fail" error, not a
> "shall fail" error).  So that behavior would be consistent both with the
> POSIX requirements as I read them, and with the desire you mentioned to let
> the fblahat system call serve to implement fblah as well as blah.  Then
> libc would not have to wrap the *at calls with any special check to conform
> to POSIX.

Makes sense.

	Arnd
