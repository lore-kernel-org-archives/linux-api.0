From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/7] [RFC] kernel: add a netlink interface to get information about processes
Date: Wed, 18 Feb 2015 12:06:40 +0100
Message-ID: <2631974.u59Ona1mDt@wuerfel>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org> <3238376.TxgiSSEfbZ@wuerfel> <20150217213313.GB7091@paralelels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150217213313.GB7091-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 18 February 2015 00:33:13 Andrew Vagin wrote:
> On Tue, Feb 17, 2015 at 09:53:09AM +0100, Arnd Bergmann wrote:
> > On Tuesday 17 February 2015 11:20:19 Andrey Vagin wrote:
> > > task_diag is based on netlink sockets and looks like socket-diag, which
> > > is used to get information about sockets.
> > > 
> > > A request is described by the task_diag_pid structure:
> > > 
> > > struct task_diag_pid {
> > >        __u64   show_flags;      /* specify which information are required */
> > >        __u64   dump_stratagy;   /* specify a group of processes */
> > > 
> > >        __u32   pid;
> > > };
> > 
> > Can you explain how the interface relates to the 'taskstats' genetlink
> > API? Did you consider extending that interface to provide the
> > information you need instead of basing on the socket-diag?
> 
> It isn't based on the socket-diag, it looks like socket-diag.
> 
> Current task_diag registers a new genl family, but we can use the taskstats
> family and add task_diag commands to it.

What I meant was more along the lines of making it look like taskstats
by adding new fields to 'struct taskstat' for what you want return.
I don't know if that is possible or a good idea for the information
you want to get out of the kernel, but it seems like a more natural
interface, as it already has some of the same data (comm, gid, pid,
ppid, ...).

	Arnd
