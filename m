From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 3/6] fs/splice: support compiling out splice-family
 syscalls
Date: Sat, 22 Nov 2014 13:50:50 -0800
Message-ID: <20141122215050.GC23711@thin>
References: <1416690001-20817-1-git-send-email-pieter@boesman.nl>
 <1416690001-20817-4-git-send-email-pieter@boesman.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1416690001-20817-4-git-send-email-pieter-qeJ+1H9vRZbz+pZb47iToQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pieter Smith <pieter-qeJ+1H9vRZbz+pZb47iToQ@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, =?utf-8?B?6JSh5q2j6b6Z?= <zhenglong.cai-TJRtMXcVgQTM1kAEIRd3EQ@public.gmane.org>, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Bertrand Jacquin <beber-2YnHqweIUXrk1uMJSBkQmQ@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Peter Foley <pefoley2-lY0TAiDIAFlBDgjK7y7TUQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Iulia Manda <iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Catalina Mocanu <catalina.mocanu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TaqPxH82wqD4g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 22, 2014 at 09:59:58PM +0100, Pieter Smith wrote:
> Many embedded systems will not need the splice-family syscalls (splice,
> vmsplice, tee and sendfile). Omitting them saves space.  This adds a new EXPERT
> config option CONFIG_SYSCALL_SPLICE (default y) to support compiling them out.
> 
> This patch removes almost all callers of .splice_read() and .splice_write()
> in the file_operations struct. This paves the way to eventually compile out the
> .splice_read and .splice_write members of the file_operations struct as well as
> the remaining splice-related infrastructure.

This commit message doesn't reflect the new approach of leaving those
members in the structure.

The patch looks good otherwise.

- Josh Triplett

> add/remove: 0/16 grow/shrink: 2/5 up/down: 114/-3693 (-3579)
> function                                     old     new   delta
> splice_direct_to_actor                       348     416     +68
> splice_to_pipe                               371     417     +46
> splice_from_pipe_next                        107     106      -1
> fdput                                         11       -     -11
> signal_pending                                39      26     -13
> fdget                                         56      42     -14
> user_page_pipe_buf_ops                        20       -     -20
> user_page_pipe_buf_steal                      25       -     -25
> file_end_write                                58      29     -29
> file_start_write                              68      34     -34
> pipe_to_user                                  43       -     -43
> wakeup_pipe_readers                           54       -     -54
> do_splice_to                                  87       -     -87
> ipipe_prep.part                               92       -     -92
> opipe_prep.part                              119       -    -119
> sys_sendfile                                 122       -    -122
> sys_sendfile64                               126       -    -126
> sys_vmsplice                                 137       -    -137
> vmsplice_to_user                             205       -    -205
> sys_tee                                      491       -    -491
> do_sendfile                                  492       -    -492
> vmsplice_to_pipe                             558       -    -558
> sys_splice                                  1020       -   -1020
> 
> Signed-off-by: Pieter Smith <pieter-qeJ+1H9vRZbz+pZb47iToQ@public.gmane.org>
> ---
>  fs/splice.c     |  2 ++
>  init/Kconfig    | 10 ++++++++++
>  kernel/sys_ni.c |  8 ++++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 44b201b..7c4c695 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1316,6 +1316,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_SYSCALL_SPLICE
>  static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
>  			       struct pipe_inode_info *opipe,
>  			       size_t len, unsigned int flags);
> @@ -2200,4 +2201,5 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
>  	return do_sendfile(out_fd, in_fd, NULL, count, 0);
>  }
>  #endif
> +#endif
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index d811d5f..dec9819 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1571,6 +1571,16 @@ config NTP
>  	  system clock to an NTP server, you can disable this option to save
>  	  space.
>  
> +config SYSCALL_SPLICE
> +	bool "Enable splice/vmsplice/tee/sendfile syscalls" if EXPERT
> +	default y
> +	help
> +	  This option enables the splice, vmsplice, tee and sendfile syscalls. These
> +	  are used by applications to: move data between buffers and arbitrary file
> +	  descriptors; "copy" data between buffers; or copy data from userspace into
> +	  buffers. If building an embedded system where no applications use these
> +	  syscalls, you can disable this option to save space.
> +
>  config PCI_QUIRKS
>  	default y
>  	bool "Enable PCI quirk workarounds" if EXPERT
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index d2f5b00..25d5551 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -170,6 +170,14 @@ cond_syscall(sys_fstat);
>  cond_syscall(sys_stat);
>  cond_syscall(sys_uname);
>  cond_syscall(sys_olduname);
> +cond_syscall(sys_vmsplice);
> +cond_syscall(sys_splice);
> +cond_syscall(sys_tee);
> +cond_syscall(sys_sendfile);
> +cond_syscall(sys_sendfile64);
> +cond_syscall(compat_sys_vmsplice);
> +cond_syscall(compat_sys_sendfile);
> +cond_syscall(compat_sys_sendfile64);
>  
>  /* arch-specific weak syscall entries */
>  cond_syscall(sys_pciconfig_read);
> -- 
> 1.9.1
> 
