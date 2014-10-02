From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCHv8.1] fanotify: enable close-on-exec on events' fd when
 requested in fanotify_init()
Date: Thu, 2 Oct 2014 12:44:10 +0200
Message-ID: <20141002104410.GB19748@quack.suse.cz>
References: <cover.1411562410.git.ydroneaud@opteya.com>
 <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
 <542481B3.8070300@gmx.de>
 <1411721898.7778.18.camel@localhost.localdomain>
 <542666B2.9080700@gmx.de>
 <1411980555-10818-1-git-send-email-ydroneaud@opteya.com>
 <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141001153621.65e9258e65a6167bf2e4cb50-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Lino Sanfilippo <LinoSanfilippo-Mmb7MZpHnFY@public.gmane.org>, Valdis Kletnieks <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 01-10-14 15:36:21, Andrew Morton wrote:
> On Mon, 29 Sep 2014 10:49:15 +0200 Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> 
> > According to commit 80af258867648 ('fanotify: groups can specify
> > their f_flags for new fd'), file descriptors created as part of
> > file access notification events inherit flags from the
> > event_f_flags argument passed to syscall fanotify_init(2).
> > 
> > So while it is legal for userspace to call fanotify_init() with
> > O_CLOEXEC as part of its second argument, O_CLOEXEC is currently
> > silently ignored.
> > 
> > Indeed event_f_flags are only given to dentry_open(), which only
> > seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
> > O_DIRECT in open_check_o_direct() and O_LARGEFILE in
> > generic_file_open().
> > 
> > But it seems logical to set close-on-exec flag on the file
> > descriptor if userspace is allowed to request it with O_CLOEXEC.
> > 
> > In fact, according to some lookup on http://codesearch.debian.net/
> > and various search engine, there's already some userspace code
> > requesting it:
> > 
> > - in systemd's readahead[2]:
> > 
> >     fanotify_fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);
> > 
> > - in clsync[3]:
> > 
> >     #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)
> > 
> >     int fanotify_d = fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVFLAGS);
> > 
> > - in examples [4] from "Filesystem monitoring in the Linux
> >   kernel" article[5] by Aleksander Morgado:
> > 
> >     if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
> >                                       O_RDONLY | O_CLOEXEC | O_LARGEFILE)) < 0)
> 
> So we have a number of apps which are setting O_CLOEXEC, but it doesn't
> actually work.  With this change it *will* work, so the behaviour of
> those apps might change, possibly breaking them?
  Possibly. OTOH I'd dare to say that most of the apps specifying O_CLOEXEC
want that behavior and their security may be weakened by the fact that
O_CLOEXEC is ignored. So we are weighting possible security issues for apps
doing things right (and Mihai mentioned in this thread that at least he has
an application which needs O_CLOEXEC working) against possible breakage for
apps which just randomly set O_CLOEXEC without wanting. So I'm really for
fixing O_CLOEXEC behavior.

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
