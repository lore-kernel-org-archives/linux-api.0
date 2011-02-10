From: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Thu, 10 Feb 2011 10:17:20 -0800 (PST)
Message-ID: <20110210181720.475EE1806EE@magilla.sf.frob.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
	<201101251529.24779.arnd@arndb.de>
	<20110125174515.C1DC2183C19@magilla.sf.frob.com>
	<20110210181221.GA19413@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Andries Brouwer's message of  Thursday, 10 February 2011 19:12:21 +0100 <20110210181221.GA19413-ek1Qb6IBo2Pz+pZb47iToQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andries Brouwer <aebr-ek1Qb6IBo2Pz+pZb47iToQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, GLIBC Devel <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-ports-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> On Tue, Jan 25, 2011 at 09:45:15AM -0800, Roland McGrath wrote:
> 
> > the empty string has never been a valid relative pathname.
> 
> Hmm. I definitely recall otherwise.
> 
> The old Unix definition is that the empty string stands for "."
> so that 'ls ""' means the same as 'ls .'
> and 'ls /tmp/""' the same as 'ls /tmp/.'.

I'm aware of that.  I was talking about Linux and POSIX.


Thanks,
Roland
