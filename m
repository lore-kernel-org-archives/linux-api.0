From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
Date: Wed, 10 Sep 2014 09:32:32 -0400
Message-ID: <20140910093232.1252707e@tlielax.poochiereds.net>
References: <5405FBAE.5020303@parallels.com>
	<20140902184456.GC31793@fieldses.org>
	<54061562.4080306@parallels.com>
	<20140909161820.GH1776@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140909161820.GH1776@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 9 Sep 2014 12:18:21 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Tue, Sep 02, 2014 at 11:07:14PM +0400, Pavel Emelyanov wrote:
> > > Would it make sense to return the lock type held instead, so you could
> > > do one flock(fd, LOCK_TEST) instead of flock(fd, LOCK_TEST|LOCK_SH) and
> > > flock(fd, LOCK_TEST|LOCK_EX) ?
> > 
> > Well, in our case we parse /proc/locks anyway to see what
> > files at least to test for being locked. But what you propose
> > looks even better. I'll look what can be done here.
> 
> Actually I think I prefer your version.  It seems cleaner to define
> LOCK_TEST as returning the same result as you'd get if you actually
> tried the lock, just without applying the lock.  It avoids having a
> different return-value convention for this one command.  It might avoid
> some ambiguity in cases where the flock might be denied for reasons
> other than a conflicting flock (e.g. on NFS where flocks and fcntl locks
> conflict).  It's closer to what GETLK does in the fcntl case.
> 

Yeah, I think I agree here too. Best to keep the interface as simple
as possible, and the principle of least surprise would dictate that the
return value match how other flock() calls work.

I would still like to see a proposed manpage update for it. For bonus
points, writing a section on flock() for the glibc manual might help
get that piece merged as well.

It was my experience that getting the small header file #defines into
glibc for OFD locks was much more difficult than the kernel piece. YMMV
of course, but getting the glibc folks to buy into the idea ahead of
time would be good if possible.

-- 
Jeff Layton <jlayton@poochiereds.net>
