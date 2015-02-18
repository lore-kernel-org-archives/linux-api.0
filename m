From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 0/7] [RFC] kernel: add a netlink interface to get information about processes
Date: Wed, 18 Feb 2015 15:46:31 +0100
Message-ID: <2264653.BOMoOiAVWc@wuerfel>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org> <2631974.u59Ona1mDt@wuerfel> <20150218123659.GA24098@paralelels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150218123659.GA24098-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 18 February 2015 15:42:11 Andrew Vagin wrote:
> On Wed, Feb 18, 2015 at 12:06:40PM +0100, Arnd Bergmann wrote:
> > On Wednesday 18 February 2015 00:33:13 Andrew Vagin wrote:
> > > On Tue, Feb 17, 2015 at 09:53:09AM +0100, Arnd Bergmann wrote:
> > > > On Tuesday 17 February 2015 11:20:19 Andrey Vagin wrote:
> > > > > task_diag is based on netlink sockets and looks like socket-diag, which
> > > > > is used to get information about sockets.
> > > > > 
> > > > > A request is described by the task_diag_pid structure:
> > > > > 
> > > > > struct task_diag_pid {
> > > > >        __u64   show_flags;      /* specify which information are required */
> > > > >        __u64   dump_stratagy;   /* specify a group of processes */
> > > > > 
> > > > >        __u32   pid;
> > > > > };
> > > > 
> > > > Can you explain how the interface relates to the 'taskstats' genetlink
> > > > API? Did you consider extending that interface to provide the
> > > > information you need instead of basing on the socket-diag?
> > > 
> > > It isn't based on the socket-diag, it looks like socket-diag.
> > > 
> > > Current task_diag registers a new genl family, but we can use the taskstats
> > > family and add task_diag commands to it.
> > 
> > What I meant was more along the lines of making it look like taskstats
> > by adding new fields to 'struct taskstat' for what you want return.
> > I don't know if that is possible or a good idea for the information
> > you want to get out of the kernel, but it seems like a more natural
> > interface, as it already has some of the same data (comm, gid, pid,
> > ppid, ...).
> 
> Now I see what you mean. task_diag has more flexible and universal
> interface than taskstat. A response of taskstat only contains a
> taskstats structure. A response of taskdiag can contains a few types of
> properties. Each type is described by its own structure.

Right, so the question is whether that flexibility is actually required
here. Independent of which design you personally prefer, what are the
downsides of extending the existing but less flexible interface?

If it's good enough, that would seem to provide a more consistent
API, which in turn helps users understand the interface and use it
correctly.

> Curently here are only two groups of parameters: task_diag_msg and
> task_diag_creds.
> 
> task_diag_msg contains a few basic parameters.
> task_diag_creds contains credentials.
> 
> I'm going to add other groups to describe all kind of task properties
> which currently are presented in procfs (e.g. /proc/pid/maps,
> /proc/pid/fding/*, /proc/pid/status, etc).
> 
> One of features of task_diag is an ability to choose which information
> are required. This allows to minimize a response size and a time, which
> is requred to fill this response.

I realize that you are trying to optimize for performance, but it
would be nice to quantify this if you want to argue for requiring
a split interface.

> struct task_diag_msg {
>         __u32   tgid;
>         __u32   pid;
>         __u32   ppid;
>         __u32   tpid;
>         __u32   sid;
>         __u32   pgid;
>         __u8    state;
>         char    comm[TASK_DIAG_COMM_LEN];
> };

I guess this part would be a very natural extension to the
existing taskstats structure, and we should only add a new
one here if there are extremely good reasons for it.

> struct task_diag_creds {
>         struct task_diag_caps cap_inheritable;
>         struct task_diag_caps cap_permitted;
>         struct task_diag_caps cap_effective;
>         struct task_diag_caps cap_bset;
> 
>         __u32 uid;
>         __u32 euid;
>         __u32 suid;
>         __u32 fsuid;
>         __u32 gid;
>         __u32 egid;
>         __u32 sgid;
>         __u32 fsgid;
> };

while this part could well be kept separate so you can query
it individually from the rest of taskstats, but through a
related interface.

	Arnd
