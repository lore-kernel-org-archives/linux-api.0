From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/7] [RFC] kernel: add a netlink interface to get
 information about processes
Date: Wed, 18 Feb 2015 17:18:38 -0800
Message-ID: <CALCETrU5B+1g9B3GH2WpPMaB98thXxpL1fAsHjssK1t_fDM_ZQ@mail.gmail.com>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
 <CALCETrWyQpr-x=No4mK_95gSANL-_fTr3qC7WjT_5TyFQb_rGw@mail.gmail.com> <20150218142718.GA30542@paralelels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150218142718.GA30542-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Feb 18, 2015 6:27 AM, "Andrew Vagin" <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>
> On Tue, Feb 17, 2015 at 11:05:31AM -0800, Andy Lutomirski wrote:
> > On Feb 17, 2015 12:40 AM, "Andrey Vagin" <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > Here is a preview version. It provides restricted set of functionality.
> > > I would like to collect feedback about this idea.
> > >
> > > Currently we use the proc file system, where all information are
> > > presented in text files, what is convenient for humans.  But if we need
> > > to get information about processes from code (e.g. in C), the procfs
> > > doesn't look so cool.
> > >
> > > From code we would prefer to get information in binary format and to be
> > > able to specify which information and for which tasks are required. Here
> > > is a new interface with all these features, which is called task_diag.
> > > In addition it's much faster than procfs.
> > >
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
> > >
> > > A respone is a set of netlink messages. Each message describes one task.
> > > All task properties are divided on groups. A message contains the
> > > TASK_DIAG_MSG group and other groups if they have been requested in
> > > show_flags. For example, if show_flags contains TASK_DIAG_SHOW_CRED, a
> > > response will contain the TASK_DIAG_CRED group which is described by the
> > > task_diag_creds structure.
> > >
> > > struct task_diag_msg {
> > >         __u32   tgid;
> > >         __u32   pid;
> > >         __u32   ppid;
> > >         __u32   tpid;
> > >         __u32   sid;
> > >         __u32   pgid;
> > >         __u8    state;
> > >         char    comm[TASK_DIAG_COMM_LEN];
> > > };
> > >
> > > Another good feature of task_diag is an ability to request information
> > > for a few processes. Currently here are two stratgies
> > > TASK_DIAG_DUMP_ALL      - get information for all tasks
> > > TASK_DIAG_DUMP_CHILDREN - get information for children of a specified
> > >                           tasks
> > >
> > > The task diag is much faster than the proc file system. We don't need to
> > > create a new file descriptor for each task. We need to send a request
> > > and get a response. It allows to get information for a few task in one
> > > request-response iteration.
> > >
> > > I have compared performance of procfs and task-diag for the
> > > "ps ax -o pid,ppid" command.
> > >
> > > A test stand contains 10348 processes.
> > > $ ps ax -o pid,ppid | wc -l
> > > 10348
> > >
> > > $ time ps ax -o pid,ppid > /dev/null
> > >
> > > real    0m1.073s
> > > user    0m0.086s
> > > sys     0m0.903s
> > >
> > > $ time ./task_diag_all > /dev/null
> > >
> > > real    0m0.037s
> > > user    0m0.004s
> > > sys     0m0.020s
> > >
> > > And here are statistics about syscalls which were called by each
> > > command.
> > > $ perf stat -e syscalls:sys_exit* -- ps ax -o pid,ppid  2>&1 | grep syscalls | sort -n -r | head -n 5
> > >             20,713      syscalls:sys_exit_open
> > >             20,710      syscalls:sys_exit_close
> > >             20,708      syscalls:sys_exit_read
> > >             10,348      syscalls:sys_exit_newstat
> > >                 31      syscalls:sys_exit_write
> > >
> > > $ perf stat -e syscalls:sys_exit* -- ./task_diag_all  2>&1 | grep syscalls | sort -n -r | head -n 5
> > >                114      syscalls:sys_exit_recvfrom
> > >                 49      syscalls:sys_exit_write
> > >                  8      syscalls:sys_exit_mmap
> > >                  4      syscalls:sys_exit_mprotect
> > >                  3      syscalls:sys_exit_newfstat
> > >
> > > You can find the test program from this experiment in the last patch.
> > >
> > > The idea of this functionality was suggested by Pavel Emelyanov
> > > (xemul@), when he found that operations with /proc forms a significant
> > > part of a checkpointing time.
> > >
> > > Ten years ago here was attempt to add a netlink interface to access to /proc
> > > information:
> > > http://lwn.net/Articles/99600/
> >
> > I don't suppose this could use real syscalls instead of netlink.  If
> > nothing else, netlink seems to conflate pid and net namespaces.
>
> What do you mean by "conflate pid and net namespaces"?

A netlink socket is bound to a network namespace, but you should be
returning data specific to a pid namespace.

On a related note, how does this interact with hidepid?  More
generally, what privileges are you requiring to obtain what data?

>
> >
> > Also, using an asynchronous interface (send, poll?, recv) for
> > something that's inherently synchronous (as the kernel a local
> > question) seems awkward to me.
>
> Actually all requests are handled synchronously. We call sendmsg to send
> a request and it is handled in this syscall.
>  2)               |  netlink_sendmsg() {
>  2)               |    netlink_unicast() {
>  2)               |      taskdiag_doit() {
>  2)   2.153 us    |        task_diag_fill();
>  2)               |        netlink_unicast() {
>  2)   0.185 us    |          netlink_attachskb();
>  2)   0.291 us    |          __netlink_sendskb();
>  2)   2.452 us    |        }
>  2) + 33.625 us   |      }
>  2) + 54.611 us   |    }
>  2) + 76.370 us   |  }
>  2)               |  netlink_recvmsg() {
>  2)   1.178 us    |    skb_recv_datagram();
>  2) + 46.953 us   |  }
>
> If we request information for a group of tasks (NLM_F_DUMP), a first
> portion of data is filled from the sendmsg syscall. And then when we read
> it, the kernel fills the next portion.
>
>  3)               |  netlink_sendmsg() {
>  3)               |    __netlink_dump_start() {
>  3)               |      netlink_dump() {
>  3)               |        taskdiag_dumpid() {
>  3)   0.685 us    |          task_diag_fill();
> ...
>  3)   0.224 us    |          task_diag_fill();
>  3) + 74.028 us   |        }
>  3) + 88.757 us   |      }
>  3) + 89.296 us   |    }
>  3) + 98.705 us   |  }
>  3)               |  netlink_recvmsg() {
>  3)               |    netlink_dump() {
>  3)               |      taskdiag_dumpid() {
>  3)   0.594 us    |        task_diag_fill();
> ...
>  3)   0.242 us    |        task_diag_fill();
>  3) + 60.634 us   |      }
>  3) + 72.803 us   |    }
>  3) + 88.005 us   |  }
>  3)               |  netlink_recvmsg() {
>  3)               |    netlink_dump() {
>  3)   2.403 us    |      taskdiag_dumpid();
>  3) + 26.236 us   |    }
>  3) + 40.522 us   |  }
>  0) + 20.407 us   |  netlink_recvmsg();
>
>
> netlink is really good for this type of tasks.  It allows to create an
> extendable interface which can be easy customized for different needs.
>
> I don't think that we would want to create another similar interface
> just to be independent from network subsystem.

I guess this is a bit streamy in that you ask one question and get
multiple answers.

>
> Thanks,
> Andrew
>
> >
> > --Andy
