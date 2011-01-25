From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 19:21:14 +0100
Message-ID: <201101251921.15184.arnd@arndb.de>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <201101251529.24779.arnd@arndb.de> <20110125174515.C1DC2183C19@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110125174515.C1DC2183C19-nL1rrgvulkc2UH6IwYuUx0EOCMrvLtNR@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, GLIBC Devel <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-ports-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tuesday 25 January 2011 18:45:15 Roland McGrath wrote:
>  I know of no reason to
> think that the current treatment of the empty string was ever intended at
> the creation of the *at interfaces.

I always assumed that this was done so that the *at syscalls can replace
both the ones that take a file descriptor (e.g. fstat) and the ones that
take a pathname (e.g. stat), which is sensible for the non-AT_FDCWD case,
although not documented in the man pages.

Treating the empty string special for AT_FDCWD is rather pointless, but
at least consistent.

	Arnd
