From: Andrew Vagin <avagin@parallels.com>
Subject: Re: [PATCH 0/7] [RFC] kernel: add a netlink interface to get
 information about processes
Date: Thu, 19 Feb 2015 17:04:20 +0300
Message-ID: <20150219140420.GA22693@paralelels.com>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
 <2631974.u59Ona1mDt@wuerfel>
 <20150218123659.GA24098@paralelels.com>
 <2264653.BOMoOiAVWc@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2264653.BOMoOiAVWc@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 18, 2015 at 03:46:31PM +0100, Arnd Bergmann wrote:
> On Wednesday 18 February 2015 15:42:11 Andrew Vagin wrote:
> > On Wed, Feb 18, 2015 at 12:06:40PM +0100, Arnd Bergmann wrote:
> > > On Wednesday 18 February 2015 00:33:13 Andrew Vagin wrote:
> > > > On Tue, Feb 17, 2015 at 09:53:09AM +0100, Arnd Bergmann wrote:
> > > > > On Tuesday 17 February 2015 11:20:19 Andrey Vagin wrote:
> > > > > > task_diag is based on netlink sockets and looks like socket-diag, which
> > > > > > is used to get information about sockets.
> > > > > > 
> > > > > > A request is described by the task_diag_pid structure:
> > > > > > 
> > > > > > struct task_diag_pid {
> > > > > >        __u64   show_flags;      /* specify which information are required */
> > > > > >        __u64   dump_stratagy;   /* specify a group of processes */
> > > > > > 
> > > > > >        __u32   pid;
> > > > > > };
> > > > > 
> > > > > Can you explain how the interface relates to the 'taskstats' genetlink
> > > > > API? Did you consider extending that interface to provide the
> > > > > information you need instead of basing on the socket-diag?
> > > > 
> > > > It isn't based on the socket-diag, it looks like socket-diag.
> > > > 
> > > > Current task_diag registers a new genl family, but we can use the taskstats
> > > > family and add task_diag commands to it.
> > > 
> > > What I meant was more along the lines of making it look like taskstats
> > > by adding new fields to 'struct taskstat' for what you want return.
> > > I don't know if that is possible or a good idea for the information
> > > you want to get out of the kernel, but it seems like a more natural
> > > interface, as it already has some of the same data (comm, gid, pid,
> > > ppid, ...).
> > 
> > Now I see what you mean. task_diag has more flexible and universal
> > interface than taskstat. A response of taskstat only contains a
> > taskstats structure. A response of taskdiag can contains a few types of
> > properties. Each type is described by its own structure.
> 
> Right, so the question is whether that flexibility is actually required
> here. Independent of which design you personally prefer, what are the
> downsides of extending the existing but less flexible interface?

I have looked at taskstat once again.

The format of response messages for taskstat and taskdiag are the same.
It's a netlink message with a set of nested attributes. New attributes
can be added without breaking backward compatibility.

The request can be expanded to be able to specified which information is
required and for which tasks.

These two features allow to significantly improve performance, because
in this case we don't need to do a system call for each task.

I have done a few experiments to prove these words.

task_proc_all reads /proc/pid/stat for each tast
$ time ./task_proc_all > /dev/null

real	0m1.528s
user	0m0.016s
sys	0m1.341s

task_diag uses task_diag and requests information for each task
separately.
$ time ./task_diag > /dev/null

real	0m1.166s
user	0m0.024s
sys	0m1.127s

task_diag_all uses task_diag and requests information for all tasks in
one request.
$ time ./task_diag_all > /dev/null

real	0m0.077s
user	0m0.018s
sys	0m0.053s

So you can see that the ability to request information for a group of
tasks allows to be more effective.

The summary of this message is that we can use the interface of
taskstats with some extensions.

Arnd, thank you for your opinion and suggestions.

> 
> If it's good enough, that would seem to provide a more consistent
> API, which in turn helps users understand the interface and use it
> correctly.
> 
> > Curently here are only two groups of parameters: task_diag_msg and
> > task_diag_creds.
> > 
> > task_diag_msg contains a few basic parameters.
> > task_diag_creds contains credentials.
> > 
> > I'm going to add other groups to describe all kind of task properties
> > which currently are presented in procfs (e.g. /proc/pid/maps,
> > /proc/pid/fding/*, /proc/pid/status, etc).
> > 
> > One of features of task_diag is an ability to choose which information
> > are required. This allows to minimize a response size and a time, which
> > is requred to fill this response.
> 
> I realize that you are trying to optimize for performance, but it
> would be nice to quantify this if you want to argue for requiring
> a split interface.
> 
> > struct task_diag_msg {
> >         __u32   tgid;
> >         __u32   pid;
> >         __u32   ppid;
> >         __u32   tpid;
> >         __u32   sid;
> >         __u32   pgid;
> >         __u8    state;
> >         char    comm[TASK_DIAG_COMM_LEN];
> > };
> 
> I guess this part would be a very natural extension to the
> existing taskstats structure, and we should only add a new
> one here if there are extremely good reasons for it.

The task_diag_msg structure contains properties which are used more
frequently than statistics from the taststats structure.

The size of the task_diag_msg structure is 44 bytes, the size of the
taststats structure 328.  If we have more data, we need to do more
system calls. So I have done one more experiment to look how it affects
perfomance:

If we use the task_diag_msg structure:
$ time ./task_diag_all > /dev/null

real	0m0.077s
user	0m0.018s
sys	0m0.053s

If we use the taststats structure:
$ time ./task_diag_all > /dev/null

real	0m0.117s
user	0m0.029s
sys	0m0.085s

Thanks,
Andrew
