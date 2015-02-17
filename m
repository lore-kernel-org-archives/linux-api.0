From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] [RFC] kernel: add a netlink interface to get information
 about processes
Date: Tue, 17 Feb 2015 09:09:47 -0700
Message-ID: <54E367CB.9030309@gmail.com>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424161226-15176-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 2/17/15 1:20 AM, Andrey Vagin wrote:
> And here are statistics about syscalls which were called by each
> command.
> $ perf stat -e syscalls:sys_exit* -- ps ax -o pid,ppid  2>&1 | grep syscalls | sort -n -r | head -n 5
>              20,713      syscalls:sys_exit_open
>              20,710      syscalls:sys_exit_close
>              20,708      syscalls:sys_exit_read
>              10,348      syscalls:sys_exit_newstat
>                  31      syscalls:sys_exit_write
>
> $ perf stat -e syscalls:sys_exit* -- ./task_diag_all  2>&1 | grep syscalls | sort -n -r | head -n 5
>                 114      syscalls:sys_exit_recvfrom
>                  49      syscalls:sys_exit_write
>                   8      syscalls:sys_exit_mmap
>                   4      syscalls:sys_exit_mprotect
>                   3      syscalls:sys_exit_newfstat

'perf trace -s' gives the summary with stats.
e.g., perf trace -s --  ps ax -o pid,ppid

  ps (23850), 3117 events, 99.3%, 0.000 msec

    syscall            calls      min       avg       max      stddev
                                (msec)    (msec)    (msec)        (%)
    --------------- -------- --------- --------- ---------     ------
    read                 353     0.000     0.010     0.035      3.14%
    write                166     0.006     0.012     0.045      3.03%
    open                 365     0.002     0.005     0.178     11.29%
    close                354     0.001     0.002     0.024      3.57%
    stat                 170     0.002     0.007     0.662     52.99%
    fstat                 19     0.002     0.003     0.003      2.31%
    lseek                  2     0.003     0.003     0.003      6.49%
    mmap                  50     0.004     0.006     0.013      3.40%
...
