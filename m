From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] Add pidfs filesystem
Date: Mon, 27 Feb 2017 19:56:59 +0100
Message-ID: <CAHO5Pa3b-9zvXmFzwtWZQhNuH5TyZdD66qnT1froJjzZw9O7YQ@mail.gmail.com>
References: <20170218225307.GA10345@comp-core-i7-2640m-0182e6.fortress>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170218225307.GA10345@comp-core-i7-2640m-0182e6.fortress>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Vasiliy Kulikov <segoon@openwall.com>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@vger.kernel.org]

Hi Alexey

This is a change to the kernel-user-space API. Please CC
linux-api@vger.kernel.org on any future iterations of this patch.

Thanks,

Michael


On Sat, Feb 18, 2017 at 11:53 PM, Alexey Gladkov
<gladkov.alexey@gmail.com> wrote:
> The pidfs filesystem contains a subset of the /proc file system which
> contains only information about the processes.
>
> Some of the container virtualization systems are mounted /proc inside
> the container. This is done in most cases to operate with information
> about the processes. Knowing that /proc filesystem is not fully
> virtualized they are mounted on top of dangerous places empty files or
> directories (for exmaple /proc/kcore, /sys/firmware, etc.).
>
> The structure of this filesystem is dynamic and any module can create a
> new object which will not necessarily be virtualized. There are
> proprietary modules that aren't in the mainline whose work we can not
> verify.
>
> This opens up a potential threat to the system. The developers of the
> virtualization system can't predict all dangerous places in /proc by
> definition.
>
> A more effective solution would be to mount into the container only what
> is necessary and ignore the rest.
>
> Right now there is the opportunity to pass in the container any port of
> the /proc filesystem using mount --bind expect the pids.
>
> This patch allows to mount only the part of /proc related to pids
> without rest objects. Since this is an addon to /proc, flags applied to
> /proc have an effect on this pidfs filesystem.
>
> Why not implement it as another flag to /proc ?
>
> The /proc flags is stored in the pid_namespace and are global for
> namespace. It means that if you add a flag to hide all except the pids,
> then it will act on all mounted instances of /proc.
>
> Originally the idea was that the container will be mounted only pidfs
> and additional required files will be mounted on top using the
> overlayfs. But I found out that /proc does not support overlayfs and
> does not allow to mount anything on top or under it.
>
> My question is whether it's possible to add overlayfs support for /proc?
>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  Documentation/filesystems/pidfs.txt | 16 ++++++++
>  fs/proc/Kconfig                     |  8 ++++
>  fs/proc/inode.c                     |  8 +++-
>  fs/proc/internal.h                  |  2 +
>  fs/proc/root.c                      | 76 ++++++++++++++++++++++++++++++++++---
>  fs/proc/self.c                      |  6 +++
>  fs/proc/thread_self.c               |  6 +++
>  include/linux/pid_namespace.h       |  5 +++
>  8 files changed, 119 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/filesystems/pidfs.txt
>
> diff --git a/Documentation/filesystems/pidfs.txt b/Documentation/filesystems/pidfs.txt
> new file mode 100644
> index 0000000..ce958a5
> --- /dev/null
> +++ b/Documentation/filesystems/pidfs.txt
> @@ -0,0 +1,16 @@
> +The PIDFS Filesystem
> +====================
> +
> +The pidfs filesystem contains a subset of the /proc file system which contains
> +only information about the processes. The link self points to the process
> +reading the file system. All other special files and directories in /proc are
> +not available in this filesystem.
> +
> +The pidfs is not an independent filesystem, its implementation shares code
> +with /proc.
> +
> +All mount options applicable to /proc filesystem are also applicable
> +to pidfs filesystem. For example, access to the information in /proc/[pid]
> +directories can be restricted using hidepid option.
> +
> +To get more information about the processes read the proc.txt
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index 1ade120..fa568f6 100644
> --- a/fs/proc/Kconfig
> +++ b/fs/proc/Kconfig
> @@ -43,6 +43,14 @@ config PROC_VMCORE
>          help
>          Exports the dump image of crashed kernel in ELF format.
>
> +config PROC_PIDFS
> +       bool "pidfs file system support"
> +       depends on PROC_FS
> +       default n
> +       help
> +         The pidfs filesystem contains a subset of the /proc file system
> +         which contains only information only about the processes.
> +
>  config PROC_SYSCTL
>         bool "Sysctl support (/proc/sys)" if EXPERT
>         depends on PROC_FS
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 783bc19..1be65b4 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -474,12 +474,16 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
>  int proc_fill_super(struct super_block *s, void *data, int silent)
>  {
>         struct pid_namespace *ns = get_pid_ns(s->s_fs_info);
> +       struct proc_dir_entry *fs_root = &proc_root;
>         struct inode *root_inode;
>         int ret;
>
>         if (!proc_parse_options(data, ns))
>                 return -EINVAL;
>
> +       if (IS_ENABLED(CONFIG_PROC_PIDFS) && s->s_type == &pidfs_fs_type)
> +               fs_root = &pidfs_root;
> +
>         /* User space would break if executables or devices appear on proc */
>         s->s_iflags |= SB_I_USERNS_VISIBLE | SB_I_NOEXEC | SB_I_NODEV;
>         s->s_flags |= MS_NODIRATIME | MS_NOSUID | MS_NOEXEC;
> @@ -496,8 +500,8 @@ int proc_fill_super(struct super_block *s, void *data, int silent)
>          */
>         s->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
>
> -       pde_get(&proc_root);
> -       root_inode = proc_get_inode(s, &proc_root);
> +       pde_get(fs_root);
> +       root_inode = proc_get_inode(s, fs_root);
>         if (!root_inode) {
>                 pr_err("proc_fill_super: get root inode failed\n");
>                 return -ENOMEM;
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 2de5194..a7c068c 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -267,6 +267,8 @@ static inline void proc_tty_init(void) {}
>  /*
>   * root.c
>   */
> +extern struct file_system_type pidfs_fs_type;
> +extern struct proc_dir_entry pidfs_root;
>  extern struct proc_dir_entry proc_root;
>  extern int proc_parse_options(char *options, struct pid_namespace *pid);
>
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 4bd0373..de16ac1 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -102,10 +102,21 @@ static void proc_kill_sb(struct super_block *sb)
>         struct pid_namespace *ns;
>
>         ns = (struct pid_namespace *)sb->s_fs_info;
> -       if (ns->proc_self)
> -               dput(ns->proc_self);
> -       if (ns->proc_thread_self)
> -               dput(ns->proc_thread_self);
> +
> +       if (IS_ENABLED(CONFIG_PROC_PIDFS) && sb->s_type == &pidfs_fs_type) {
> +               if (ns->pidfs_self)
> +                       dput(ns->pidfs_self);
> +
> +               if (ns->pidfs_thread_self)
> +                       dput(ns->pidfs_thread_self);
> +       } else {
> +               if (ns->proc_self)
> +                       dput(ns->proc_self);
> +
> +               if (ns->proc_thread_self)
> +                       dput(ns->proc_thread_self);
> +       }
> +
>         kill_anon_super(sb);
>         put_pid_ns(ns);
>  }
> @@ -117,6 +128,13 @@ static struct file_system_type proc_fs_type = {
>         .fs_flags       = FS_USERNS_MOUNT,
>  };
>
> +struct file_system_type pidfs_fs_type = {
> +       .name           = "pidfs",
> +       .mount          = proc_mount,
> +       .kill_sb        = proc_kill_sb,
> +       .fs_flags       = FS_USERNS_MOUNT,
> +};
> +
>  void __init proc_root_init(void)
>  {
>         int err;
> @@ -127,6 +145,10 @@ void __init proc_root_init(void)
>         if (err)
>                 return;
>
> +       err = register_filesystem(&pidfs_fs_type);
> +       if (err)
> +               return;
> +
>         proc_self_init();
>         proc_thread_self_init();
>         proc_symlink("mounts", NULL, "self/mounts");
> @@ -148,8 +170,7 @@ void __init proc_root_init(void)
>         proc_sys_init();
>  }
>
> -static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat
> -)
> +static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
>  {
>         generic_fillattr(d_inode(dentry), stat);
>         stat->nlink = proc_root.nlink + nr_processes();
> @@ -176,6 +197,14 @@ static int proc_root_readdir(struct file *file, struct dir_context *ctx)
>         return proc_pid_readdir(file, ctx);
>  }
>
> +static int pidfs_root_readdir(struct file *file, struct dir_context *ctx)
> +{
> +       if (ctx->pos < FIRST_PROCESS_ENTRY)
> +               ctx->pos = FIRST_PROCESS_ENTRY;
> +
> +       return proc_pid_readdir(file, ctx);
> +}
> +
>  /*
>   * The root /proc directory is special, as it has the
>   * <pid> directories. Thus we don't use the generic
> @@ -187,6 +216,12 @@ static const struct file_operations proc_root_operations = {
>         .llseek         = generic_file_llseek,
>  };
>
> +static const struct file_operations pidfs_root_operations = {
> +       .read            = generic_read_dir,
> +       .iterate_shared  = pidfs_root_readdir,
> +       .llseek         = generic_file_llseek,
> +};
> +
>  /*
>   * proc root can do almost nothing..
>   */
> @@ -195,6 +230,11 @@ static const struct inode_operations proc_root_inode_operations = {
>         .getattr        = proc_root_getattr,
>  };
>
> +static const struct inode_operations pidfs_root_inode_operations = {
> +       .lookup         = proc_pid_lookup,
> +       .getattr        = proc_root_getattr,
> +};
> +
>  /*
>   * This is the root "inode" in the /proc tree..
>   */
> @@ -211,6 +251,19 @@ struct proc_dir_entry proc_root = {
>         .name           = "/proc",
>  };
>
> +struct proc_dir_entry pidfs_root = {
> +       .low_ino        = PROC_ROOT_INO,
> +       .namelen        = 6,
> +       .mode           = S_IFDIR | S_IRUGO | S_IXUGO,
> +       .nlink          = 2,
> +       .count          = ATOMIC_INIT(1),
> +       .proc_iops      = &pidfs_root_inode_operations,
> +       .proc_fops      = &pidfs_root_operations,
> +       .parent         = &pidfs_root,
> +       .subdir         = RB_ROOT,
> +       .name           = "/pidfs",
> +};
> +
>  int pid_ns_prepare_proc(struct pid_namespace *ns)
>  {
>         struct vfsmount *mnt;
> @@ -220,10 +273,21 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
>                 return PTR_ERR(mnt);
>
>         ns->proc_mnt = mnt;
> +
> +       if (IS_ENABLED(CONFIG_PROC_PIDFS)) {
> +               mnt = kern_mount_data(&pidfs_fs_type, ns);
> +               if (IS_ERR(mnt))
> +                       return PTR_ERR(mnt);
> +
> +               ns->pidfs_mnt = mnt;
> +       }
>         return 0;
>  }
>
>  void pid_ns_release_proc(struct pid_namespace *ns)
>  {
>         kern_unmount(ns->proc_mnt);
> +
> +       if (IS_ENABLED(CONFIG_PROC_PIDFS))
> +               kern_unmount(ns->pidfs_mnt);
>  }
> diff --git a/fs/proc/self.c b/fs/proc/self.c
> index 4024595..dea7e17 100644
> --- a/fs/proc/self.c
> +++ b/fs/proc/self.c
> @@ -74,6 +74,12 @@ int proc_setup_self(struct super_block *s)
>                 pr_err("proc_fill_super: can't allocate /proc/self\n");
>                 return PTR_ERR(self);
>         }
> +
> +       if (IS_ENABLED(CONFIG_PROC_PIDFS) && s->s_type == &pidfs_fs_type) {
> +               ns->pidfs_self = self;
> +               return 0;
> +       }
> +
>         ns->proc_self = self;
>         return 0;
>  }
> diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
> index 595b90a97..274c618 100644
> --- a/fs/proc/thread_self.c
> +++ b/fs/proc/thread_self.c
> @@ -76,6 +76,12 @@ int proc_setup_thread_self(struct super_block *s)
>                 pr_err("proc_fill_super: can't allocate /proc/thread_self\n");
>                 return PTR_ERR(thread_self);
>         }
> +
> +       if (IS_ENABLED(CONFIG_PROC_PIDFS) && s->s_type == &pidfs_fs_type) {
> +               ns->pidfs_thread_self = thread_self;
> +               return 0;
> +       }
> +
>         ns->proc_thread_self = thread_self;
>         return 0;
>  }
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 34cce96..fca3a76 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -46,6 +46,11 @@ struct pid_namespace {
>         int hide_pid;
>         int reboot;     /* group exit code if this pidns was rebooted */
>         struct ns_common ns;
> +#ifdef CONFIG_PROC_PIDFS
> +       struct vfsmount *pidfs_mnt;
> +       struct dentry *pidfs_self;
> +       struct dentry *pidfs_thread_self;
> +#endif
>  };
>
>  extern struct pid_namespace init_pid_ns;
> --
> 2.10.2
>
>
> --
> Rgrds, legion
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
