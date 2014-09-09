From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
Date: Tue, 9 Sep 2014 12:18:21 -0400
Message-ID: <20140909161820.GH1776@fieldses.org>
References: <5405FBAE.5020303@parallels.com>
 <20140902184456.GC31793@fieldses.org>
 <54061562.4080306@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54061562.4080306-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 02, 2014 at 11:07:14PM +0400, Pavel Emelyanov wrote:
> > Would it make sense to return the lock type held instead, so you could
> > do one flock(fd, LOCK_TEST) instead of flock(fd, LOCK_TEST|LOCK_SH) and
> > flock(fd, LOCK_TEST|LOCK_EX) ?
> 
> Well, in our case we parse /proc/locks anyway to see what
> files at least to test for being locked. But what you propose
> looks even better. I'll look what can be done here.

Actually I think I prefer your version.  It seems cleaner to define
LOCK_TEST as returning the same result as you'd get if you actually
tried the lock, just without applying the lock.  It avoids having a
different return-value convention for this one command.  It might avoid
some ambiguity in cases where the flock might be denied for reasons
other than a conflicting flock (e.g. on NFS where flocks and fcntl locks
conflict).  It's closer to what GETLK does in the fcntl case.

--b.
