From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/24] kernel: add a netlink interface to get information about processes (v2)
Date: Mon,  6 Jul 2015 11:47:01 +0300
Message-ID: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently we use the proc file system, where all information are
presented in text files, what is convenient for humans.  But if we need
to get information about processes from code (e.g. in C), the procfs
doesn't look so cool.

=46rom code we would prefer to get information in binary format and to =
be
able to specify which information and for which tasks are required. Her=
e
is a new interface with all these features, which is called task_diag.
In addition it's much faster than procfs.

task_diag is based on netlink sockets and looks like socket-diag, which
is used to get information about sockets.

A request is described by the task_diag_pid structure:

struct task_diag_pid {
       __u64   show_flags;	/* specify which information are required */
       __u64   dump_stratagy;   /* specify a group of processes */

       __u32   pid;
};

dump_stratagy specifies a group of processes:
/* per-process strategies */
TASK_DIAG_DUMP_CHILDREN	- all children
TASK_DIAG_DUMP_THREAD	- all threads
TASK_DIAG_DUMP_ONE	- one process
/* system wide strategies (the pid fiel is ignored) */
TASK_DIAG_DUMP_ALL	  - all processes
TASK_DIAG_DUMP_ALL_THREAD - all threads

show_flags specifies which information are required.
If we set the TASK_DIAG_SHOW_BASE flag, the response message will
contain the TASK_DIAG_BASE attribute which is described by the
task_diag_base structure.

struct task_diag_base {
	__u32	tgid;
	__u32	pid;
	__u32	ppid;
	__u32	tpid;
	__u32	sid;
	__u32	pgid;
	__u8	state;
	char	comm[TASK_DIAG_COMM_LEN];
};

In future, it can be extended by optional attributes. The request
describes which task properties are required and for which processes
they are required for.

A response can be divided into a few netlink packets if the NETLINK_DUM=
P
has been set in a request. Each task is described by a message. Each
message contains the TASK_DIAG_PID attribute and optional attributes
which have been requested (show_flags). A message can be divided into a
few parts if it doesn=E2=80=99t fit into a current netlink packet. In t=
his case,
the first message in the next packet contains the same PID and
attributes which doesn=E2=80=99t =C2=A0fit into the previous message.

The task diag is much faster than the proc file system. We don't need t=
o
create a new file descriptor for each task. We need to send a request
and get a response. It allows to get information for a few tasks in one
request-response iteration.

As for security, task_diag always works as procfs with hidepid =3D 2 (h=
ighest
level of security).

I have compared performance of procfs and task-diag for the
"ps ax -o pid,ppid" command.

A test stand contains 30108 processes.
$ ps ax -o pid,ppid | wc -l
30108

$ time ps ax -o pid,ppid > /dev/null

real	0m0.836s
user	0m0.238s
sys	0m0.583s

Read /proc/PID/stat for each task
$ time ./task_proc_all > /dev/null

real	0m0.258s
user	0m0.019s
sys	0m0.232s

$ time ./task_diag_all > /dev/null

real	0m0.052s
user	0m0.013s
sys	0m0.036s

And here are statistics on syscalls which were called by each
command.

$ perf trace -s -o log -- ./task_proc_all > /dev/null

 Summary of events:

 task_proc_all (30781), 180785 events, 100.0%, 0.000 msec

   syscall            calls      min       avg       max      stddev
                               (msec)    (msec)    (msec)        (%)
   --------------- -------- --------- --------- ---------     ------
   read               30111     0.000     0.013     0.107      0.21%
   write                  1     0.008     0.008     0.008      0.00%
   open               30111     0.007     0.012     0.145      0.24%
   close              30112     0.004     0.011     0.110      0.20%
   fstat                  3     0.009     0.013     0.016     16.15%
   mmap                   8     0.011     0.020     0.027     11.24%
   mprotect               4     0.019     0.023     0.028      8.33%
   munmap                 1     0.026     0.026     0.026      0.00%
   brk                    8     0.007     0.015     0.024     11.94%
   ioctl                  1     0.007     0.007     0.007      0.00%
   access                 1     0.019     0.019     0.019      0.00%
   execve                 1     0.000     0.000     0.000      0.00%
   getdents              29     0.008     1.010     2.215      8.88%
   arch_prctl             1     0.016     0.016     0.016      0.00%
   openat                 1     0.021     0.021     0.021      0.00%


$ perf trace -s -o log -- ./task_diag_all > /dev/null
 Summary of events:

 task_diag_all (30762), 717 events, 98.9%, 0.000 msec

   syscall            calls      min       avg       max      stddev
                               (msec)    (msec)    (msec)        (%)
   --------------- -------- --------- --------- ---------     ------
   read                   2     0.000     0.008     0.016    100.00%
   write                197     0.008     0.019     0.041      3.00%
   open                   2     0.023     0.029     0.036     22.45%
   close                  3     0.010     0.012     0.014     11.34%
   fstat                  3     0.012     0.044     0.106     70.52%
   mmap                   8     0.014     0.031     0.054     18.88%
   mprotect               4     0.016     0.023     0.027     10.93%
   munmap                 1     0.022     0.022     0.022      0.00%
   brk                    1     0.040     0.040     0.040      0.00%
   ioctl                  1     0.011     0.011     0.011      0.00%
   access                 1     0.032     0.032     0.032      0.00%
   getpid                 1     0.012     0.012     0.012      0.00%
   socket                 1     0.032     0.032     0.032      0.00%
   sendto                 2     0.032     0.095     0.157     65.77%
   recvfrom             129     0.009     0.235     0.418      2.45%
   bind                   1     0.018     0.018     0.018      0.00%
   execve                 1     0.000     0.000     0.000      0.00%
   arch_prctl             1     0.012     0.012     0.012      0.00%

You can find the test program from this experiment in tools/test/selfte=
st/taskdiag.

The idea of this functionality was suggested by Pavel Emelyanov
(xemul@), when he found that operations with /proc forms a significant
part of a checkpointing time.

Ten years ago there was attempt to add a netlink interface to access to=
 /proc
information:
http://lwn.net/Articles/99600/

git repo: https://github.com/avagin/linux-task-diag

Changes from the first version:

David Ahern implemented all required functionality to use task_diag in
perf.

Bellow you can find his results how it affects performance.
> Using the fork test command:
>    10,000 processes; 10k proc with 5 threads =3D 50,000 tasks
>    reading /proc: 11.3 sec
>    task_diag:      2.2 sec
>
> @7,440 tasks, reading /proc is at 0.77 sec and task_diag at 0.096
>
> 128 instances of sepcjbb, 80,000+ tasks:
>     reading /proc: 32.1 sec
>     task_diag:      3.9 sec
>
> So overall much snappier startup times.

Many thanks to David Ahern for the help with improving task_diag.

Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
--
2.1.0
