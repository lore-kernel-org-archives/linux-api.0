From: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Wed, 27 Apr 2011 17:12:19 +0200
Message-ID: <20110427151218.GA15335@linux.betterlinux.com>
References: <1303914545-15642-1-git-send-email-andrea@betterlinux.com>
 <201104271700.13013.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201104271700.13013.arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Mike Frysinger <vapier@gentoo.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 05:00:12PM +0200, Arnd Bergmann wrote:
> On Wednesday 27 April 2011 16:29:05 Andrea Righi wrote:
> > diff --git a/include/linux/fadvise.h b/include/linux/fadvise.h
> > index e8e7471..dc9ce98 100644
> > --- a/include/linux/fadvise.h
> > +++ b/include/linux/fadvise.h
> > @@ -13,9 +13,11 @@
> >  #if defined(__s390x__)
> >  #define POSIX_FADV_DONTNEED    6 /* Don't need these pages.  */
> >  #define POSIX_FADV_NOREUSE     7 /* Data will be accessed once.  */
> > +#define POSIX_FADV_DONTNEED_FS 8 /* Don't need these filesystem pages.  */
> >  #else
> >  #define POSIX_FADV_DONTNEED    4 /* Don't need these pages.  */
> >  #define POSIX_FADV_NOREUSE     5 /* Data will be accessed once.  */
> > +#define POSIX_FADV_DONTNEED_FS 6 /* Don't need these filesystem pages.  */
> >  #endif
> >  
> >  #endif /* FADVISE_H_INCLUDED */
> 
> Please don't make the s390 mess worse than it already is here.
> I think the best solution would be to assign new values starting
> from 8 so they can be common for all architectures.

Agreed.

> 
> > @@ -127,6 +128,12 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
> >                         invalidate_mapping_pages(mapping, start_index,
> >                                                 end_index);
> >                 break;
> > +       case POSIX_FADV_DONTNEED_FS:
> > +               if (!current_euid())
> > +                       drop_pagecache_sb(file->f_dentry->d_sb, NULL);
> > +               else
> > +                       ret = -EPERM;
> > +               break;
> 
> I somewhat disagree with keying the capability off the UID value, even
> if that is what the sysctl uses. CAP_SYS_ADMIN is not that nice either, but
> I think it's better than the UID here.

OK, I also prefer CAP_SYS_ADMIN.

> 
> Aside from these, I like the patch.
> 
> 	Arnd

I'll wait for other comments and post another version with the changes
you suggested.

Thanks for looking at it.

-Andrea
