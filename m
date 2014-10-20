From: josh@joshtriplett.org
Subject: Re: [PATCH 2/2] fs: Support compiling out sendfile
Date: Mon, 20 Oct 2014 15:24:22 -0700
Message-ID: <20141020222421.GE8929@cloud>
References: <1413841728-1313-1-git-send-email-pieter@boesman.nl>
 <1413841728-1313-2-git-send-email-pieter@boesman.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413841728-1313-2-git-send-email-pieter@boesman.nl>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Pieter Smith <pieter@boesman.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>, Matt Turner <mattst88@gmail.com>, Michal Hocko <mhocko@suse.cz>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Fabian Frederick <fabf@skynet.be>, Tejun Heo <tj@kernel.org>, =?utf-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>, "Luis R. Rodriguez" <mcgrof@suse.com>, Peter Foley <pefoley2@pefoley.com>, Konstantin Khlebnikov <koct9i@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 20, 2014 at 11:48:37PM +0200, Pieter Smith wrote:
> Many embedded systems will not need this syscall, and omitting it
> saves space.  Add a new EXPERT config option CONFIG_SENDFILE_SYSCALL
> (default y) to support compiling it out.

Nice work, thanks!

If there are no objections, and nobody has a tree they'd rather carry
this through, I'll take the series through the tiny tree when it's ready
to merge.

> bloat-o-meter:
> add/remove: 0/4 grow/shrink: 5/0 up/down: 23/-751 (-728)
> function                                     old     new   delta
> sys_pwritev                                  115     122      +7
> sys_preadv                                   115     122      +7
> fdput_pos                                     29      36      +7
> sys_pwrite64                                 115     116      +1
> sys_pread64                                  115     116      +1
> fdput                                         11       -     -11
> sys_sendfile                                 122       -    -122
> sys_sendfile64                               126       -    -126
> do_sendfile                                  492       -    -492

Interesting inlining decisions by GCC here.  Got a bloat-o-meter for the
two-patch series, by any chance?  (Also, is this with tinyconfig?  In
particular, with OPTIMIZE_INLINING and OPTIMIZE_FOR_SIZE?)  I'm
wondering if moving sendfile to a separate file made GCC put fdput
out-of-line, and compiling it out reversed that again.

> Signed-off-by: Pieter Smith <pieter@boesman.nl>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  fs/Makefile     |  3 ++-
>  init/Kconfig    | 10 ++++++++++
>  kernel/sys_ni.c |  4 ++++
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/Makefile b/fs/Makefile
> index 1e3423f..1bbfea7 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -5,7 +5,7 @@
>  # Rewritten to use lists instead of if-statements.
>  # 
>  
> -obj-y :=	open.o read_write.o sendfile.o file_table.o super.o \
> +obj-y :=	open.o read_write.o file_table.o super.o \
>  		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
>  		ioctl.o readdir.o select.o dcache.o inode.o \
>  		attr.o bad_inode.o file.o filesystems.o namespace.o \
> @@ -38,6 +38,7 @@ obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
>  obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
>  obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
>  obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
> +obj-$(CONFIG_SENDFILE_SYSCALL)	+= sendfile.o
>  
>  obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
>  obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o
> diff --git a/init/Kconfig b/init/Kconfig
> index 782a65b..df6785c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1547,6 +1547,16 @@ config ADVISE_SYSCALLS
>  	  applications use these syscalls, you can disable this option to save
>  	  space.
>  
> +config SENDFILE_SYSCALL
> +	bool "Enable sendfile syscall" if EXPERT
> +	default y
> +	help
> +	  This option enables the sendfile syscall, used by applications to copy
> +	  data between file descriptors. Because sendfile performs the copying
> +	  within the kernel, it is more efficient than the combination of read
> +	  and write.  If building an embedded system where no applications use
> +	  the sendfile syscall, you can disable this option to save space.
> +

I'm thinking of adding a submenu to group config FOO_SYSCALL options. :)
I'll probably push that as part of the 3.19 merge window, as a patch on
top of all of the individual tinification options.

>  config PCI_QUIRKS
>  	default y
>  	bool "Enable PCI quirk workarounds" if EXPERT
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index d4709d4..b068de7 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -159,6 +159,10 @@ cond_syscall(sys_uselib);
>  cond_syscall(sys_fadvise64);
>  cond_syscall(sys_fadvise64_64);
>  cond_syscall(sys_madvise);
> +cond_syscall(sys_sendfile);
> +cond_syscall(sys_sendfile64);
> +cond_syscall(compat_sys_sendfile);
> +cond_syscall(compat_sys_sendfile64);
>  
>  /* arch-specific weak syscall entries */
>  cond_syscall(sys_pciconfig_read);
> -- 
> 1.9.1
> 
