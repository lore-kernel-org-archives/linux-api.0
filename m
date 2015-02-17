From: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 0/7] [RFC] kernel: add a netlink interface to get
 information about processes
Date: Wed, 18 Feb 2015 00:33:13 +0300
Message-ID: <20150217213313.GB7091@paralelels.com>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
 <3238376.TxgiSSEfbZ@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3238376.TxgiSSEfbZ@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 09:53:09AM +0100, Arnd Bergmann wrote:
> On Tuesday 17 February 2015 11:20:19 Andrey Vagin wrote:
> > task_diag is based on netlink sockets and looks like socket-diag, which
> > is used to get information about sockets.
> > 
> > A request is described by the task_diag_pid structure:
> > 
> > struct task_diag_pid {
> >        __u64   show_flags;      /* specify which information are required */
> >        __u64   dump_stratagy;   /* specify a group of processes */
> > 
> >        __u32   pid;
> > };
> 
> Can you explain how the interface relates to the 'taskstats' genetlink
> API? Did you consider extending that interface to provide the
> information you need instead of basing on the socket-diag?

It isn't based on the socket-diag, it looks like socket-diag.

Current task_diag registers a new genl family, but we can use the taskstats
family and add task_diag commands to it.

Thanks,
Andrew

> 
> 	Arnd
