From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: Revised statx(2) man page for review [and AT_EMPTY_PATH question]
Date: Wed, 26 Apr 2017 16:53:00 +0100
Message-ID: <20170426155259.GY29622@ZenIV.linux.org.uk>
References: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3@gmail.com>
 <14390.1493206508@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14390.1493206508-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 26, 2017 at 12:35:08PM +0100, David Howells wrote:

> AT_EMPTY_PATH wasn't there back in 2010.  I could eliminate the:
> 
> 	statx(fd, NULL, 0, ...);
> 
> option in favour of:
> 
> 	statx(fd, "", AT_EMPTY_PATH, ...);
> 
> Any thoughts either way, Al?
> 
> It would seem that AT_EMPTY_PATH should be redundant, though, since you can
> just set the pathname pointer to NULL.

NULL pathname pointer means an error for a lot of existing syscalls, so
if you want to turn them into wrappers for ...at() ones at libc level,
you'd need to do special-casing of NULL both kernel-side and in libc wrappers.

Requiring "" + AT_EMPTY_PATH means a single dereference of userland pointer.  
OTOH, that's not a terrible burden...
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
