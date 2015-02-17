From: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 0/7] [RFC] kernel: add a netlink interface to get
 information about processes
Date: Tue, 17 Feb 2015 23:32:02 +0300
Message-ID: <20150217203202.GA7091@paralelels.com>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
 <54E367CB.9030309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54E367CB.9030309-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 09:09:47AM -0700, David Ahern wrote:
> On 2/17/15 1:20 AM, Andrey Vagin wrote:
> >And here are statistics about syscalls which were called by each
> >command.
> >$ perf stat -e syscalls:sys_exit* -- ps ax -o pid,ppid  2>&1 | grep syscalls | sort -n -r | head -n 5
> >             20,713      syscalls:sys_exit_open
> >             20,710      syscalls:sys_exit_close
> >             20,708      syscalls:sys_exit_read
> >             10,348      syscalls:sys_exit_newstat
> >                 31      syscalls:sys_exit_write
> >
> >$ perf stat -e syscalls:sys_exit* -- ./task_diag_all  2>&1 | grep syscalls | sort -n -r | head -n 5
> >                114      syscalls:sys_exit_recvfrom
> >                 49      syscalls:sys_exit_write
> >                  8      syscalls:sys_exit_mmap
> >                  4      syscalls:sys_exit_mprotect
> >                  3      syscalls:sys_exit_newfstat
> 
> 'perf trace -s' gives the summary with stats.
> e.g., perf trace -s --  ps ax -o pid,ppid

Thank you for this command, I haven't used it before.

 ps (21301), 145271 events, 100.0%, 0.000 msec

   syscall            calls      min       avg       max      stddev
                               (msec)    (msec)    (msec)        (%)
   --------------- -------- --------- --------- ---------     ------
   read               20717     0.000     0.020     1.631      0.64%
   write                  1     0.019     0.019     0.019      0.00%
   open               20722     0.025     0.035     3.624      0.93%
   close              20719     0.006     0.009     1.059      0.95%
   stat               10352     0.015     0.025     1.748      0.95%
   fstat                 12     0.010     0.012     0.020      6.17%
   lseek                  2     0.011     0.012     0.012      3.08%
   mmap                  30     0.012     0.034     0.094      9.35%
   mprotect              17     0.034     0.045     0.067      4.86%
   munmap                 3     0.028     0.058     0.108     44.12%
   brk                    4     0.011     0.015     0.019     11.24%
   rt_sigaction          25     0.011     0.011     0.014      1.27%
   rt_sigprocmask         1     0.012     0.012     0.012      0.00%
   ioctl                  4     0.010     0.012     0.014      6.94%
   access                 1     0.034     0.034     0.034      0.00%
   execve                 6     0.000     0.496     2.794     92.58%
   uname                  1     0.015     0.015     0.015      0.00%
   getdents              12     0.019     0.691     1.158     13.04%
   getrlimit              1     0.012     0.012     0.012      0.00%
   geteuid                1     0.012     0.012     0.012      0.00%
   arch_prctl             1     0.013     0.013     0.013      0.00%
   futex                  1     0.020     0.020     0.020      0.00%
   set_tid_address        1     0.012     0.012     0.012      0.00%
   openat                 1     0.030     0.030     0.030      0.00%
   set_robust_list        1     0.011     0.011     0.011      0.00%


 task_diag_all (21304), 569 events, 98.6%, 0.000 msec

   syscall            calls      min       avg       max      stddev
                               (msec)    (msec)    (msec)        (%)
   --------------- -------- --------- --------- ---------     ------
   read                   2     0.000     0.045     0.090    100.00%
   write                 77     0.010     0.013     0.083      7.93%
   open                   2     0.031     0.038     0.045     19.64%
   close                  3     0.010     0.014     0.017     13.43%
   fstat                  3     0.011     0.011     0.012      3.79%
   mmap                   8     0.013     0.027     0.049     16.72%
   mprotect               4     0.034     0.043     0.052      8.86%
   munmap                 1     0.031     0.031     0.031      0.00%
   brk                    1     0.014     0.014     0.014      0.00%
   ioctl                  1     0.010     0.010     0.010      0.00%
   access                 1     0.030     0.030     0.030      0.00%
   getpid                 1     0.011     0.011     0.011      0.00%
   socket                 1     0.045     0.045     0.045      0.00%
   sendto                 2     0.091     0.104     0.117     12.63%
   recvfrom             175     0.026     0.093     0.141      1.10%
   bind                   1     0.014     0.014     0.014      0.00%
   execve                 1     0.000     0.000     0.000      0.00%
   arch_prctl             1     0.011     0.011     0.011      0.00%

> 
>  ps (23850), 3117 events, 99.3%, 0.000 msec
> 
>    syscall            calls      min       avg       max      stddev
>                                (msec)    (msec)    (msec)        (%)
>    --------------- -------- --------- --------- ---------     ------
>    read                 353     0.000     0.010     0.035      3.14%
>    write                166     0.006     0.012     0.045      3.03%
>    open                 365     0.002     0.005     0.178     11.29%
>    close                354     0.001     0.002     0.024      3.57%
>    stat                 170     0.002     0.007     0.662     52.99%
>    fstat                 19     0.002     0.003     0.003      2.31%
>    lseek                  2     0.003     0.003     0.003      6.49%
>    mmap                  50     0.004     0.006     0.013      3.40%
> ...
