From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] namespaces: add transparent user namespaces
Date: Mon, 27 Jun 2016 05:34:35 +0200
Message-ID: <CAHO5Pa3T1N9t3+DO-kCf30vM2YmOh7-A5dp1q+X-avriLVQODA@mail.gmail.com>
References: <CAG48ez3ELMSsWhe9X_uq_3M7TjJxq=SnAr09g72nTkCRQY008g@mail.gmail.com>
 <1466814210-3778-1-git-send-email-jannh@google.com> <1466814210-3778-2-git-send-email-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466814210-3778-2-git-send-email-jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Janis Danisevskis <jdanis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Jann,

Patches such as this really should CC linux-api@ (added).

On Sat, Jun 25, 2016 at 2:23 AM, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> This allows the admin of a user namespace to mark the namespace as
> transparent. All other namespaces, by default, are opaque.
>
> While the current behavior of user namespaces is appropriate for use in
> containers, there are many programs that only use user namespaces because
> doing so enables them to do other things (e.g. unsharing the mount or
> network namespace) that require namespaced capabilities. For them, the
> inability to see the real UIDs and GIDs of things from inside the user
> namespace can be very annoying.
>
> In a transparent namespace, all UIDs and GIDs that are mapped into its
> first opaque ancestor are visible and are not remapped. This means that if
> a process e.g. stat()s the real root directory in a namespace, it will
> still see it as owned by UID 0.
>
> Traditionally, any UID or GID that was visible in a user namespace was also
> mapped into the namespace, giving the namespace admin full access to it.
> This patch introduces a distinction: In a transparent namespace, UIDs and
> GIDs can be visible without being mapped. Non-mapped, visible UIDs can be
> passed from the kernel to userspace, but userspace can't send them back to
> the kernel.

Can you explain "can't send them back to the kernel" in more detail?
(Some examples of what is and isn't possible would be helpul.)

> In order to be able to fully use specific UIDs/GIDs and gain
> privileges over them, mappings need to be set up in the usual way -
> however, to avoid aliasing problems, only identity mappings are permitted.
>
> v2:
> Ensure that all relevant from_k[ug]id callers show up in the patch.
> _transparent would be more verbose than _tp, but considering the line
> length rule, that's just too long.
>
> Yes, this makes the patch rather large.
>
> Behavior should be the same as in v1, except that I'm not touching orangefs
> in this patch because every single use of from_k[ug]id in it is wrong in
> some way. (Thanks for making me reread all that stuff, Eric.) I'll write a
> separate patch or at least report the issue with more detail later.
>
> (Also, the handling of user namespaces when dealing with signals is
> super-ugly and kind of incorrect. That should probably be cleaned up.)

I'm curious about this detail: can you say some more about the issues here?

> posix_acl_to_xattr would have changed behavior in the v1 patch, but isn't
> changed here. Because it's only used with init_user_ns, that won't change
> user-visible behavior relative to v1.
>
> This patch was compile-tested with allyesconfig. I also ran a VM with this
> patch applied and checked that it still works, but that probably doesn't
> mean much.

One of the things notably lacking from this commit message is any sort
of description of the user-space-API changes that it makes. I presume
it's a matter of some /proc files. Could you explain the changes (ad
add that detail in any further commit message)?

Thanks,

Michael

> Signed-off-by: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/alpha/kernel/osf_sys.c       |   4 +-
>  arch/arm/kernel/sys_oabi-compat.c |   4 +-
>  arch/ia64/kernel/signal.c         |   4 +-
>  arch/s390/kernel/compat_linux.c   |  26 +++---
>  arch/sparc/kernel/sys_sparc32.c   |   4 +-
>  arch/x86/ia32/sys_ia32.c          |   4 +-
>  drivers/android/binder.c          |   2 +-
>  drivers/gpu/drm/drm_info.c        |   2 +-
>  drivers/gpu/drm/drm_ioctl.c       |   2 +-
>  drivers/net/tun.c                 |   4 +-
>  fs/autofs4/dev-ioctl.c            |   4 +-
>  fs/autofs4/waitq.c                |   4 +-
>  fs/binfmt_elf.c                   |  12 +--
>  fs/binfmt_elf_fdpic.c             |  12 +--
>  fs/compat.c                       |   4 +-
>  fs/fcntl.c                        |   4 +-
>  fs/ncpfs/ioctl.c                  |  12 +--
>  fs/posix_acl.c                    |  11 ++-
>  fs/proc/array.c                   |  18 ++--
>  fs/proc/base.c                    |  30 +++++--
>  fs/quota/kqid.c                   |  12 ++-
>  fs/stat.c                         |  12 +--
>  include/linux/uidgid.h            |  24 +++--
>  include/linux/user_namespace.h    |   4 +
>  include/net/scm.h                 |   4 +-
>  ipc/mqueue.c                      |   2 +-
>  ipc/msg.c                         |   8 +-
>  ipc/sem.c                         |   8 +-
>  ipc/shm.c                         |   8 +-
>  ipc/util.c                        |   8 +-
>  kernel/acct.c                     |   4 +-
>  kernel/exit.c                     |   6 +-
>  kernel/groups.c                   |   2 +-
>  kernel/signal.c                   |  16 ++--
>  kernel/sys.c                      |  24 ++---
>  kernel/trace/trace.c              |   2 +-
>  kernel/tsacct.c                   |   4 +-
>  kernel/uid16.c                    |  22 ++---
>  kernel/user.c                     |   1 +
>  kernel/user_namespace.c           | 178 +++++++++++++++++++++++++++++++++++---
>  net/appletalk/atalk_proc.c        |   2 +-
>  net/ax25/ax25_uid.c               |   4 +-
>  net/bluetooth/af_bluetooth.c      |   2 +-
>  net/core/sock.c                   |   4 +-
>  net/ipv4/inet_diag.c              |   2 +-
>  net/ipv4/ping.c                   |   2 +-
>  net/ipv4/raw.c                    |   2 +-
>  net/ipv4/sysctl_net_ipv4.c        |   4 +-
>  net/ipv4/tcp_ipv4.c               |   6 +-
>  net/ipv4/udp.c                    |   2 +-
>  net/ipv6/datagram.c               |   2 +-
>  net/ipv6/ip6_flowlabel.c          |   2 +-
>  net/ipv6/tcp_ipv6.c               |   6 +-
>  net/ipx/ipx_proc.c                |   2 +-
>  net/key/af_key.c                  |   2 +-
>  net/llc/llc_proc.c                |   2 +-
>  net/netfilter/nfnetlink_log.c     |   4 +-
>  net/packet/af_packet.c            |   2 +-
>  net/packet/diag.c                 |   2 +-
>  net/phonet/socket.c               |   4 +-
>  net/sctp/proc.c                   |   4 +-
>  net/sunrpc/svcauth_unix.c         |   4 +-
>  security/keys/keyctl.c            |   4 +-
>  security/keys/proc.c              |   6 +-
>  64 files changed, 395 insertions(+), 197 deletions(-)
>
> diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
> index ffb93f49..6440f8e 100644
> --- a/arch/alpha/kernel/osf_sys.c
> +++ b/arch/alpha/kernel/osf_sys.c
> @@ -277,8 +277,8 @@ linux_to_osf_stat(struct kstat *lstat, struct osf_stat __user *osf_stat)
>         tmp.st_dev      = lstat->dev;
>         tmp.st_mode     = lstat->mode;
>         tmp.st_nlink    = lstat->nlink;
> -       tmp.st_uid      = from_kuid_munged(current_user_ns(), lstat->uid);
> -       tmp.st_gid      = from_kgid_munged(current_user_ns(), lstat->gid);
> +       tmp.st_uid      = from_kuid_tp_munged(current_user_ns(), lstat->uid);
> +       tmp.st_gid      = from_kgid_tp_munged(current_user_ns(), lstat->gid);
>         tmp.st_rdev     = lstat->rdev;
>         tmp.st_ldev     = lstat->rdev;
>         tmp.st_size     = lstat->size;
> diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
> index 087acb5..47748eb 100644
> --- a/arch/arm/kernel/sys_oabi-compat.c
> +++ b/arch/arm/kernel/sys_oabi-compat.c
> @@ -124,8 +124,8 @@ static long cp_oldabi_stat64(struct kstat *stat,
>         tmp.__st_ino = stat->ino;
>         tmp.st_mode = stat->mode;
>         tmp.st_nlink = stat->nlink;
> -       tmp.st_uid = from_kuid_munged(current_user_ns(), stat->uid);
> -       tmp.st_gid = from_kgid_munged(current_user_ns(), stat->gid);
> +       tmp.st_uid = from_kuid_tp_munged(current_user_ns(), stat->uid);
> +       tmp.st_gid = from_kgid_tp_munged(current_user_ns(), stat->gid);
>         tmp.st_rdev = huge_encode_dev(stat->rdev);
>         tmp.st_size = stat->size;
>         tmp.st_blocks = stat->blocks;
> diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
> index b3a124d..071b9c0 100644
> --- a/arch/ia64/kernel/signal.c
> +++ b/arch/ia64/kernel/signal.c
> @@ -209,7 +209,7 @@ ia64_rt_sigreturn (struct sigscratch *scr)
>         si.si_errno = 0;
>         si.si_code = SI_KERNEL;
>         si.si_pid = task_pid_vnr(current);
> -       si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> +       si.si_uid = from_kuid_tp_munged(current_user_ns(), current_uid());
>         si.si_addr = sc;
>         force_sig_info(SIGSEGV, &si, current);
>         return retval;
> @@ -306,7 +306,7 @@ force_sigsegv_info (int sig, void __user *addr)
>         si.si_errno = 0;
>         si.si_code = SI_KERNEL;
>         si.si_pid = task_pid_vnr(current);
> -       si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> +       si.si_uid = from_kuid_tp_munged(current_user_ns(), current_uid());
>         si.si_addr = addr;
>         force_sig_info(SIGSEGV, &si, current);
>         return 1;
> diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
> index 437e611..31a39ba 100644
> --- a/arch/s390/kernel/compat_linux.c
> +++ b/arch/s390/kernel/compat_linux.c
> @@ -136,9 +136,9 @@ COMPAT_SYSCALL_DEFINE3(s390_getresuid16, u16 __user *, ruidp,
>         int retval;
>         u16 ruid, euid, suid;
>
> -       ruid = high2lowuid(from_kuid_munged(cred->user_ns, cred->uid));
> -       euid = high2lowuid(from_kuid_munged(cred->user_ns, cred->euid));
> -       suid = high2lowuid(from_kuid_munged(cred->user_ns, cred->suid));
> +       ruid = high2lowuid(from_kuid_tp_munged(cred->user_ns, cred->uid));
> +       euid = high2lowuid(from_kuid_tp_munged(cred->user_ns, cred->euid));
> +       suid = high2lowuid(from_kuid_tp_munged(cred->user_ns, cred->suid));
>
>         if (!(retval   = put_user(ruid, ruidp)) &&
>             !(retval   = put_user(euid, euidp)))
> @@ -160,9 +160,9 @@ COMPAT_SYSCALL_DEFINE3(s390_getresgid16, u16 __user *, rgidp,
>         int retval;
>         u16 rgid, egid, sgid;
>
> -       rgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->gid));
> -       egid = high2lowgid(from_kgid_munged(cred->user_ns, cred->egid));
> -       sgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->sgid));
> +       rgid = high2lowgid(from_kgid_tp_munged(cred->user_ns, cred->gid));
> +       egid = high2lowgid(from_kgid_tp_munged(cred->user_ns, cred->egid));
> +       sgid = high2lowgid(from_kgid_tp_munged(cred->user_ns, cred->sgid));
>
>         if (!(retval   = put_user(rgid, rgidp)) &&
>             !(retval   = put_user(egid, egidp)))
> @@ -190,7 +190,7 @@ static int groups16_to_user(u16 __user *grouplist, struct group_info *group_info
>
>         for (i = 0; i < group_info->ngroups; i++) {
>                 kgid = GROUP_AT(group_info, i);
> -               group = (u16)from_kgid_munged(user_ns, kgid);
> +               group = (u16)from_kgid_tp_munged(user_ns, kgid);
>                 if (put_user(group, grouplist+i))
>                         return -EFAULT;
>         }
> @@ -271,22 +271,22 @@ COMPAT_SYSCALL_DEFINE2(s390_setgroups16, int, gidsetsize, u16 __user *, grouplis
>
>  COMPAT_SYSCALL_DEFINE0(s390_getuid16)
>  {
> -       return high2lowuid(from_kuid_munged(current_user_ns(), current_uid()));
> +       return high2lowuid(from_kuid_tp_munged(current_user_ns(), current_uid()));
>  }
>
>  COMPAT_SYSCALL_DEFINE0(s390_geteuid16)
>  {
> -       return high2lowuid(from_kuid_munged(current_user_ns(), current_euid()));
> +       return high2lowuid(from_kuid_tp_munged(current_user_ns(), current_euid()));
>  }
>
>  COMPAT_SYSCALL_DEFINE0(s390_getgid16)
>  {
> -       return high2lowgid(from_kgid_munged(current_user_ns(), current_gid()));
> +       return high2lowgid(from_kgid_tp_munged(current_user_ns(), current_gid()));
>  }
>
>  COMPAT_SYSCALL_DEFINE0(s390_getegid16)
>  {
> -       return high2lowgid(from_kgid_munged(current_user_ns(), current_egid()));
> +       return high2lowgid(from_kgid_tp_munged(current_user_ns(), current_egid()));
>  }
>
>  #ifdef CONFIG_SYSVIPC
> @@ -366,8 +366,8 @@ static int cp_stat64(struct stat64_emu31 __user *ubuf, struct kstat *stat)
>         tmp.__st_ino = (u32)stat->ino;
>         tmp.st_mode = stat->mode;
>         tmp.st_nlink = (unsigned int)stat->nlink;
> -       tmp.st_uid = from_kuid_munged(current_user_ns(), stat->uid);
> -       tmp.st_gid = from_kgid_munged(current_user_ns(), stat->gid);
> +       tmp.st_uid = from_kuid_tp_munged(current_user_ns(), stat->uid);
> +       tmp.st_gid = from_kgid_tp_munged(current_user_ns(), stat->gid);
>         tmp.st_rdev = huge_encode_dev(stat->rdev);
>         tmp.st_size = stat->size;
>         tmp.st_blksize = (u32)stat->blksize;
> diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
> index 022c30c..e65acab 100644
> --- a/arch/sparc/kernel/sys_sparc32.c
> +++ b/arch/sparc/kernel/sys_sparc32.c
> @@ -76,8 +76,8 @@ static int cp_compat_stat64(struct kstat *stat,
>         err |= put_user(stat->ino, &statbuf->st_ino);
>         err |= put_user(stat->mode, &statbuf->st_mode);
>         err |= put_user(stat->nlink, &statbuf->st_nlink);
> -       err |= put_user(from_kuid_munged(current_user_ns(), stat->uid), &statbuf->st_uid);
> -       err |= put_user(from_kgid_munged(current_user_ns(), stat->gid), &statbuf->st_gid);
> +       err |= put_user(from_kuid_tp_munged(current_user_ns(), stat->uid), &statbuf->st_uid);
> +       err |= put_user(from_kgid_tp_munged(current_user_ns(), stat->gid), &statbuf->st_gid);
>         err |= put_user(huge_encode_dev(stat->rdev), &statbuf->st_rdev);
>         err |= put_user(0, (unsigned long __user *) &statbuf->__pad3[0]);
>         err |= put_user(stat->size, &statbuf->st_size);
> diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
> index 719cd70..e8d4532 100644
> --- a/arch/x86/ia32/sys_ia32.c
> +++ b/arch/x86/ia32/sys_ia32.c
> @@ -71,8 +71,8 @@ static int cp_stat64(struct stat64 __user *ubuf, struct kstat *stat)
>  {
>         typeof(ubuf->st_uid) uid = 0;
>         typeof(ubuf->st_gid) gid = 0;
> -       SET_UID(uid, from_kuid_munged(current_user_ns(), stat->uid));
> -       SET_GID(gid, from_kgid_munged(current_user_ns(), stat->gid));
> +       SET_UID(uid, from_kuid_tp_munged(current_user_ns(), stat->uid));
> +       SET_GID(gid, from_kgid_tp_munged(current_user_ns(), stat->gid));
>         if (!access_ok(VERIFY_WRITE, ubuf, sizeof(struct stat64)) ||
>             __put_user(huge_encode_dev(stat->dev), &ubuf->st_dev) ||
>             __put_user(stat->ino, &ubuf->__st_ino) ||
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index 16288e7..c8fcf71 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -2400,7 +2400,7 @@ retry:
>                 }
>                 tr.code = t->code;
>                 tr.flags = t->flags;
> -               tr.sender_euid = from_kuid(current_user_ns(), t->sender_euid);
> +               tr.sender_euid = from_kuid_tp(current_user_ns(), t->sender_euid);
>
>                 if (t->from) {
>                         struct task_struct *sender = t->from->proc->tsk;
> diff --git a/drivers/gpu/drm/drm_info.c b/drivers/gpu/drm/drm_info.c
> index 5d469b2..07ab3d4 100644
> --- a/drivers/gpu/drm/drm_info.c
> +++ b/drivers/gpu/drm/drm_info.c
> @@ -186,7 +186,7 @@ int drm_clients_info(struct seq_file *m, void *data)
>                            priv->minor->index,
>                            priv->is_master ? 'y' : 'n',
>                            priv->authenticated ? 'y' : 'n',
> -                          from_kuid_munged(seq_user_ns(m), priv->uid),
> +                          from_kuid_tp_munged(seq_user_ns(m), priv->uid),
>                            priv->magic);
>                 rcu_read_unlock();
>         }
> diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> index b7a39771c..2e18837 100644
> --- a/drivers/gpu/drm/drm_ioctl.c
> +++ b/drivers/gpu/drm/drm_ioctl.c
> @@ -181,7 +181,7 @@ static int drm_getclient(struct drm_device *dev, void *data,
>         if (client->idx == 0) {
>                 client->auth = file_priv->authenticated;
>                 client->pid = pid_vnr(file_priv->pid);
> -               client->uid = from_kuid_munged(current_user_ns(),
> +               client->uid = from_kuid_tp_munged(current_user_ns(),
>                                                file_priv->uid);
>                 client->magic = 0;
>                 client->iocs = 0;
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index e16487c..8965a26 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1659,7 +1659,7 @@ static ssize_t tun_show_owner(struct device *dev, struct device_attribute *attr,
>         struct tun_struct *tun = netdev_priv(to_net_dev(dev));
>         return uid_valid(tun->owner)?
>                 sprintf(buf, "%u\n",
> -                       from_kuid_munged(current_user_ns(), tun->owner)):
> +                       from_kuid_tp_munged(current_user_ns(), tun->owner)) :
>                 sprintf(buf, "-1\n");
>  }
>
> @@ -1669,7 +1669,7 @@ static ssize_t tun_show_group(struct device *dev, struct device_attribute *attr,
>         struct tun_struct *tun = netdev_priv(to_net_dev(dev));
>         return gid_valid(tun->group) ?
>                 sprintf(buf, "%u\n",
> -                       from_kgid_munged(current_user_ns(), tun->group)):
> +                       from_kgid_tp_munged(current_user_ns(), tun->group)) :
>                 sprintf(buf, "-1\n");
>  }
>
> diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> index c7fcc74..4c75a4c 100644
> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -460,9 +460,9 @@ static int autofs_dev_ioctl_requester(struct file *fp,
>                 autofs4_expire_wait(path.dentry, 0);
>                 spin_lock(&sbi->fs_lock);
>                 param->requester.uid =
> -                       from_kuid_munged(current_user_ns(), ino->uid);
> +                       from_kuid_tp_munged(current_user_ns(), ino->uid);
>                 param->requester.gid =
> -                       from_kgid_munged(current_user_ns(), ino->gid);
> +                       from_kgid_tp_munged(current_user_ns(), ino->gid);
>                 spin_unlock(&sbi->fs_lock);
>         }
>         path_put(&path);
> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> index 0146d91..7d55752 100644
> --- a/fs/autofs4/waitq.c
> +++ b/fs/autofs4/waitq.c
> @@ -157,8 +157,8 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
>                 packet->name[wq->name.len] = '\0';
>                 packet->dev = wq->dev;
>                 packet->ino = wq->ino;
> -               packet->uid = from_kuid_munged(user_ns, wq->uid);
> -               packet->gid = from_kgid_munged(user_ns, wq->gid);
> +               packet->uid = from_kuid_tp_munged(user_ns, wq->uid);
> +               packet->gid = from_kgid_tp_munged(user_ns, wq->gid);
>                 packet->pid = wq->pid;
>                 packet->tgid = wq->tgid;
>                 break;
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index a7a28110..3f9be45 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -240,10 +240,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>         NEW_AUX_ENT(AT_BASE, interp_load_addr);
>         NEW_AUX_ENT(AT_FLAGS, 0);
>         NEW_AUX_ENT(AT_ENTRY, exec->e_entry);
> -       NEW_AUX_ENT(AT_UID, from_kuid_munged(cred->user_ns, cred->uid));
> -       NEW_AUX_ENT(AT_EUID, from_kuid_munged(cred->user_ns, cred->euid));
> -       NEW_AUX_ENT(AT_GID, from_kgid_munged(cred->user_ns, cred->gid));
> -       NEW_AUX_ENT(AT_EGID, from_kgid_munged(cred->user_ns, cred->egid));
> +       NEW_AUX_ENT(AT_UID, from_kuid_tp_munged(cred->user_ns, cred->uid));
> +       NEW_AUX_ENT(AT_EUID, from_kuid_tp_munged(cred->user_ns, cred->euid));
> +       NEW_AUX_ENT(AT_GID, from_kgid_tp_munged(cred->user_ns, cred->gid));
> +       NEW_AUX_ENT(AT_EGID, from_kgid_tp_munged(cred->user_ns, cred->egid));
>         NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
>         NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
>  #ifdef ELF_HWCAP2
> @@ -1474,8 +1474,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
>         psinfo->pr_flag = p->flags;
>         rcu_read_lock();
>         cred = __task_cred(p);
> -       SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
> -       SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
> +       SET_UID(psinfo->pr_uid, from_kuid_tp_munged(cred->user_ns, cred->uid));
> +       SET_GID(psinfo->pr_gid, from_kgid_tp_munged(cred->user_ns, cred->gid));
>         rcu_read_unlock();
>         strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
>
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 2035893..9d76bb7 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -644,10 +644,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
>         NEW_AUX_ENT(AT_BASE,    interp_params->elfhdr_addr);
>         NEW_AUX_ENT(AT_FLAGS,   0);
>         NEW_AUX_ENT(AT_ENTRY,   exec_params->entry_addr);
> -       NEW_AUX_ENT(AT_UID,     (elf_addr_t) from_kuid_munged(cred->user_ns, cred->uid));
> -       NEW_AUX_ENT(AT_EUID,    (elf_addr_t) from_kuid_munged(cred->user_ns, cred->euid));
> -       NEW_AUX_ENT(AT_GID,     (elf_addr_t) from_kgid_munged(cred->user_ns, cred->gid));
> -       NEW_AUX_ENT(AT_EGID,    (elf_addr_t) from_kgid_munged(cred->user_ns, cred->egid));
> +       NEW_AUX_ENT(AT_UID,     (elf_addr_t) from_kuid_tp_munged(cred->user_ns, cred->uid));
> +       NEW_AUX_ENT(AT_EUID,    (elf_addr_t) from_kuid_tp_munged(cred->user_ns, cred->euid));
> +       NEW_AUX_ENT(AT_GID,     (elf_addr_t) from_kgid_tp_munged(cred->user_ns, cred->gid));
> +       NEW_AUX_ENT(AT_EGID,    (elf_addr_t) from_kgid_tp_munged(cred->user_ns, cred->egid));
>         NEW_AUX_ENT(AT_SECURE,  security_bprm_secureexec(bprm));
>         NEW_AUX_ENT(AT_EXECFN,  bprm->exec);
>
> @@ -1434,8 +1434,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
>         psinfo->pr_flag = p->flags;
>         rcu_read_lock();
>         cred = __task_cred(p);
> -       SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
> -       SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
> +       SET_UID(psinfo->pr_uid, from_kuid_tp_munged(cred->user_ns, cred->uid));
> +       SET_GID(psinfo->pr_gid, from_kgid_tp_munged(cred->user_ns, cred->gid));
>         rcu_read_unlock();
>         strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
>
> diff --git a/fs/compat.c b/fs/compat.c
> index be6e48b..8e3cb5d3 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -142,8 +142,8 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
>         tmp.st_nlink = stat->nlink;
>         if (tmp.st_nlink != stat->nlink)
>                 return -EOVERFLOW;
> -       SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
> -       SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
> +       SET_UID(tmp.st_uid, from_kuid_tp_munged(current_user_ns(), stat->uid));
> +       SET_GID(tmp.st_gid, from_kgid_tp_munged(current_user_ns(), stat->gid));
>         tmp.st_rdev = old_encode_dev(stat->rdev);
>         if ((u64) stat->size > MAX_NON_LFS)
>                 return -EOVERFLOW;
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 350a2c8..bcba367 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -225,8 +225,8 @@ static int f_getowner_uids(struct file *filp, unsigned long arg)
>         int err;
>
>         read_lock(&filp->f_owner.lock);
> -       src[0] = from_kuid(user_ns, filp->f_owner.uid);
> -       src[1] = from_kuid(user_ns, filp->f_owner.euid);
> +       src[0] = from_kuid_tp(user_ns, filp->f_owner.uid);
> +       src[1] = from_kuid_tp(user_ns, filp->f_owner.euid);
>         read_unlock(&filp->f_owner.lock);
>
>         err  = put_user(src[0], &dst[0]);
> diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
> index 0a3f9b5..65631c2 100644
> --- a/fs/ncpfs/ioctl.c
> +++ b/fs/ncpfs/ioctl.c
> @@ -45,7 +45,7 @@ ncp_get_fs_info(struct ncp_server * server, struct inode *inode,
>                 return -EINVAL;
>         }
>         /* TODO: info.addr = server->m.serv_addr; */
> -       SET_UID(info.mounted_uid, from_kuid_munged(current_user_ns(), server->m.mounted_uid));
> +       SET_UID(info.mounted_uid, from_kuid_tp_munged(current_user_ns(), server->m.mounted_uid));
>         info.connection         = server->connection;
>         info.buffer_size        = server->buffer_size;
>         info.volume_number      = NCP_FINFO(inode)->volNumber;
> @@ -69,7 +69,7 @@ ncp_get_fs_info_v2(struct ncp_server * server, struct inode *inode,
>                 ncp_dbg(1, "info.version invalid: %d\n", info2.version);
>                 return -EINVAL;
>         }
> -       info2.mounted_uid   = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
> +       info2.mounted_uid   = from_kuid_tp_munged(current_user_ns(), server->m.mounted_uid);
>         info2.connection    = server->connection;
>         info2.buffer_size   = server->buffer_size;
>         info2.volume_number = NCP_FINFO(inode)->volNumber;
> @@ -135,7 +135,7 @@ ncp_get_compat_fs_info_v2(struct ncp_server * server, struct inode *inode,
>                 ncp_dbg(1, "info.version invalid: %d\n", info2.version);
>                 return -EINVAL;
>         }
> -       info2.mounted_uid   = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
> +       info2.mounted_uid   = from_kuid_tp_munged(current_user_ns(), server->m.mounted_uid);
>         info2.connection    = server->connection;
>         info2.buffer_size   = server->buffer_size;
>         info2.volume_number = NCP_FINFO(inode)->volNumber;
> @@ -347,21 +347,21 @@ static long __ncp_ioctl(struct inode *inode, unsigned int cmd, unsigned long arg
>                 {
>                         u16 uid;
>
> -                       SET_UID(uid, from_kuid_munged(current_user_ns(), server->m.mounted_uid));
> +                       SET_UID(uid, from_kuid_tp_munged(current_user_ns(), server->m.mounted_uid));
>                         if (put_user(uid, (u16 __user *)argp))
>                                 return -EFAULT;
>                         return 0;
>                 }
>         case NCP_IOC_GETMOUNTUID32:
>         {
> -               uid_t uid = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
> +               uid_t uid = from_kuid_tp_munged(current_user_ns(), server->m.mounted_uid);
>                 if (put_user(uid, (u32 __user *)argp))
>                         return -EFAULT;
>                 return 0;
>         }
>         case NCP_IOC_GETMOUNTUID64:
>         {
> -               uid_t uid = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
> +               uid_t uid = from_kuid_tp_munged(current_user_ns(), server->m.mounted_uid);
>                 if (put_user(uid, (u64 __user *)argp))
>                         return -EFAULT;
>                 return 0;
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index 8a4a266..c3e7ecb 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -653,14 +653,21 @@ static void posix_acl_fix_xattr_userns(
>                 return;
>
>         for (end = entry + count; entry != end; entry++) {
> +               /* from_k[ug]id_tp is safe here because the callers are:
> +                *  - posix_acl_fix_xattr_from_user() calls this with
> +                *    to=init_user_ns
> +                *  - posix_acl_fix_xattr_to_user() calls this with
> +                *    to=current_user_ns() and is only used in getxattr(),
> +                *    which copies the result to the caller
> +                */
>                 switch(le16_to_cpu(entry->e_tag)) {
>                 case ACL_USER:
>                         uid = make_kuid(from, le32_to_cpu(entry->e_id));
> -                       entry->e_id = cpu_to_le32(from_kuid(to, uid));
> +                       entry->e_id = cpu_to_le32(from_kuid_tp(to, uid));
>                         break;
>                 case ACL_GROUP:
>                         gid = make_kgid(from, le32_to_cpu(entry->e_id));
> -                       entry->e_id = cpu_to_le32(from_kgid(to, gid));
> +                       entry->e_id = cpu_to_le32(from_kgid_tp(to, gid));
>                         break;
>                 default:
>                         break;
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 88c7de1..a827d6e 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -198,20 +198,20 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>                 "FDSize:\t%d\nGroups:\t",
>                 get_task_state(p),
>                 tgid, ngid, pid_nr_ns(pid, ns), ppid, tpid,
> -               from_kuid_munged(user_ns, cred->uid),
> -               from_kuid_munged(user_ns, cred->euid),
> -               from_kuid_munged(user_ns, cred->suid),
> -               from_kuid_munged(user_ns, cred->fsuid),
> -               from_kgid_munged(user_ns, cred->gid),
> -               from_kgid_munged(user_ns, cred->egid),
> -               from_kgid_munged(user_ns, cred->sgid),
> -               from_kgid_munged(user_ns, cred->fsgid),
> +               from_kuid_tp_munged(user_ns, cred->uid),
> +               from_kuid_tp_munged(user_ns, cred->euid),
> +               from_kuid_tp_munged(user_ns, cred->suid),
> +               from_kuid_tp_munged(user_ns, cred->fsuid),
> +               from_kgid_tp_munged(user_ns, cred->gid),
> +               from_kgid_tp_munged(user_ns, cred->egid),
> +               from_kgid_tp_munged(user_ns, cred->sgid),
> +               from_kgid_tp_munged(user_ns, cred->fsgid),
>                 max_fds);
>
>         group_info = cred->group_info;
>         for (g = 0; g < group_info->ngroups; g++)
>                 seq_printf(m, "%d ",
> -                          from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
> +                          from_kgid_tp_munged(user_ns, GROUP_AT(group_info, g)));
>         put_cred(cred);
>
>  #ifdef CONFIG_PID_NS
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index a11eb71..2203b81 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1236,7 +1236,7 @@ static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
>         if (!task)
>                 return -ESRCH;
>         length = scnprintf(tmpbuf, TMPBUFLEN, "%u",
> -                          from_kuid(file->f_cred->user_ns,
> +                          from_kuid_tp(file->f_cred->user_ns,
>                                      audit_get_loginuid(task)));
>         put_task_struct(task);
>         return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> @@ -2744,7 +2744,8 @@ static const struct file_operations proc_projid_map_operations = {
>         .release        = proc_id_map_release,
>  };
>
> -static int proc_setgroups_open(struct inode *inode, struct file *file)
> +static int proc_nsadmin_open(struct inode *inode, struct file *file,
> +       int (*show)(struct seq_file *, void *))
>  {
>         struct user_namespace *ns = NULL;
>         struct task_struct *task;
> @@ -2767,7 +2768,7 @@ static int proc_setgroups_open(struct inode *inode, struct file *file)
>                         goto err_put_ns;
>         }
>
> -       ret = single_open(file, &proc_setgroups_show, ns);
> +       ret = single_open(file, show, ns);
>         if (ret)
>                 goto err_put_ns;
>
> @@ -2778,7 +2779,7 @@ err:
>         return ret;
>  }
>
> -static int proc_setgroups_release(struct inode *inode, struct file *file)
> +static int proc_nsadmin_release(struct inode *inode, struct file *file)
>  {
>         struct seq_file *seq = file->private_data;
>         struct user_namespace *ns = seq->private;
> @@ -2787,12 +2788,30 @@ static int proc_setgroups_release(struct inode *inode, struct file *file)
>         return ret;
>  }
>
> +static int proc_setgroups_open(struct inode *inode, struct file *file)
> +{
> +       return proc_nsadmin_open(inode, file, &proc_setgroups_show);
> +}
> +
>  static const struct file_operations proc_setgroups_operations = {
>         .open           = proc_setgroups_open,
>         .write          = proc_setgroups_write,
>         .read           = seq_read,
>         .llseek         = seq_lseek,
> -       .release        = proc_setgroups_release,
> +       .release        = proc_nsadmin_release,
> +};
> +
> +static int proc_transparent_open(struct inode *inode, struct file *file)
> +{
> +       return proc_nsadmin_open(inode, file, &proc_transparent_show);
> +}
> +
> +static const struct file_operations proc_transparent_operations = {
> +       .open           = proc_transparent_open,
> +       .write          = proc_transparent_write,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = proc_nsadmin_release,
>  };
>  #endif /* CONFIG_USER_NS */
>
> @@ -2901,6 +2920,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>         REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
>         REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
>         REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
> +       REG("transparent", S_IRUGO|S_IWUSR, proc_transparent_operations),
>  #endif
>  #ifdef CONFIG_CHECKPOINT_RESTORE
>         REG("timers",     S_IRUGO, proc_timers_operations),
> diff --git a/fs/quota/kqid.c b/fs/quota/kqid.c
> index ebc5e62..1cd3d8b 100644
> --- a/fs/quota/kqid.c
> +++ b/fs/quota/kqid.c
> @@ -66,11 +66,15 @@ EXPORT_SYMBOL(qid_lt);
>   */
>  qid_t from_kqid(struct user_namespace *targ, struct kqid kqid)
>  {
> +       /* transparent UID/GID are okay here; this method is only
> +        * called either with targ=&init_user_ns or directly
> +        * before a copy_from_user(), with current_user_ns()
> +        */
>         switch (kqid.type) {
>         case USRQUOTA:
> -               return from_kuid(targ, kqid.uid);
> +               return from_kuid_tp(targ, kqid.uid);
>         case GRPQUOTA:
> -               return from_kgid(targ, kqid.gid);
> +               return from_kgid_tp(targ, kqid.gid);
>         case PRJQUOTA:
>                 return from_kprojid(targ, kqid.projid);
>         default:
> @@ -101,9 +105,9 @@ qid_t from_kqid_munged(struct user_namespace *targ, struct kqid kqid)
>  {
>         switch (kqid.type) {
>         case USRQUOTA:
> -               return from_kuid_munged(targ, kqid.uid);
> +               return from_kuid_tp_munged(targ, kqid.uid);
>         case GRPQUOTA:
> -               return from_kgid_munged(targ, kqid.gid);
> +               return from_kgid_tp_munged(targ, kqid.gid);
>         case PRJQUOTA:
>                 return from_kprojid_munged(targ, kqid.projid);
>         default:
> diff --git a/fs/stat.c b/fs/stat.c
> index bc045c7..b8cff6c 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -160,8 +160,8 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
>         tmp.st_nlink = stat->nlink;
>         if (tmp.st_nlink != stat->nlink)
>                 return -EOVERFLOW;
> -       SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
> -       SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
> +       SET_UID(tmp.st_uid, from_kuid_tp_munged(current_user_ns(), stat->uid));
> +       SET_GID(tmp.st_gid, from_kgid_tp_munged(current_user_ns(), stat->gid));
>         tmp.st_rdev = old_encode_dev(stat->rdev);
>  #if BITS_PER_LONG == 32
>         if (stat->size > MAX_NON_LFS)
> @@ -246,8 +246,8 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
>         tmp.st_nlink = stat->nlink;
>         if (tmp.st_nlink != stat->nlink)
>                 return -EOVERFLOW;
> -       SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
> -       SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
> +       SET_UID(tmp.st_uid, from_kuid_tp_munged(current_user_ns(), stat->uid));
> +       SET_GID(tmp.st_gid, from_kgid_tp_munged(current_user_ns(), stat->gid));
>         tmp.st_rdev = encode_dev(stat->rdev);
>         tmp.st_size = stat->size;
>         tmp.st_atime = stat->atime.tv_sec;
> @@ -381,8 +381,8 @@ static long cp_new_stat64(struct kstat *stat, struct stat64 __user *statbuf)
>  #endif
>         tmp.st_mode = stat->mode;
>         tmp.st_nlink = stat->nlink;
> -       tmp.st_uid = from_kuid_munged(current_user_ns(), stat->uid);
> -       tmp.st_gid = from_kgid_munged(current_user_ns(), stat->gid);
> +       tmp.st_uid = from_kuid_tp_munged(current_user_ns(), stat->uid);
> +       tmp.st_gid = from_kgid_tp_munged(current_user_ns(), stat->gid);
>         tmp.st_atime = stat->atime.tv_sec;
>         tmp.st_atime_nsec = stat->atime.tv_nsec;
>         tmp.st_mtime = stat->mtime.tv_sec;
> diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
> index 0383552..bb7e2c5 100644
> --- a/include/linux/uidgid.h
> +++ b/include/linux/uidgid.h
> @@ -124,8 +124,10 @@ extern kgid_t make_kgid(struct user_namespace *from, gid_t gid);
>
>  extern uid_t from_kuid(struct user_namespace *to, kuid_t uid);
>  extern gid_t from_kgid(struct user_namespace *to, kgid_t gid);
> -extern uid_t from_kuid_munged(struct user_namespace *to, kuid_t uid);
> -extern gid_t from_kgid_munged(struct user_namespace *to, kgid_t gid);
> +extern uid_t from_kuid_tp(struct user_namespace *to, kuid_t uid);
> +extern gid_t from_kgid_tp(struct user_namespace *to, kgid_t gid);
> +extern uid_t from_kuid_tp_munged(struct user_namespace *to, kuid_t uid);
> +extern gid_t from_kgid_tp_munged(struct user_namespace *to, kgid_t gid);
>
>  static inline bool kuid_has_mapping(struct user_namespace *ns, kuid_t uid)
>  {
> @@ -159,17 +161,27 @@ static inline gid_t from_kgid(struct user_namespace *to, kgid_t kgid)
>         return __kgid_val(kgid);
>  }
>
> -static inline uid_t from_kuid_munged(struct user_namespace *to, kuid_t kuid)
> +static inline uid_t from_kuid_tp(struct user_namespace *to, kuid_t kuid)
>  {
> -       uid_t uid = from_kuid(to, kuid);
> +       return __kuid_val(kuid);
> +}
> +
> +static inline gid_t from_kgid_tp(struct user_namespace *to, kgid_t kgid)
> +{
> +       return __kgid_val(kgid);
> +}
> +
> +static inline uid_t from_kuid_tp_munged(struct user_namespace *to, kuid_t kuid)
> +{
> +       uid_t uid = from_kuid_tp(to, kuid);
>         if (uid == (uid_t)-1)
>                 uid = overflowuid;
>         return uid;
>  }
>
> -static inline gid_t from_kgid_munged(struct user_namespace *to, kgid_t kgid)
> +static inline gid_t from_kgid_tp_munged(struct user_namespace *to, kgid_t kgid)
>  {
> -       gid_t gid = from_kgid(to, kgid);
> +       gid_t gid = from_kgid_tp(to, kgid);
>         if (gid == (gid_t)-1)
>                 gid = overflowgid;
>         return gid;
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 8297e5b..18291ac 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -28,6 +28,8 @@ struct user_namespace {
>         struct uid_gid_map      projid_map;
>         atomic_t                count;
>         struct user_namespace   *parent;
> +       /* self for normal ns; first opaque parent for transparent ns */
> +       struct user_namespace   *opaque;
>         int                     level;
>         kuid_t                  owner;
>         kgid_t                  group;
> @@ -71,6 +73,8 @@ extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, lo
>  extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
>  extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
>  extern int proc_setgroups_show(struct seq_file *m, void *v);
> +extern ssize_t proc_transparent_write(struct file *, const char __user *, size_t, loff_t *);
> +extern int proc_transparent_show(struct seq_file *m, void *v);
>  extern bool userns_may_setgroups(const struct user_namespace *ns);
>  #else
>
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 59fa93c..601450a 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -121,8 +121,8 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>                 struct user_namespace *current_ns = current_user_ns();
>                 struct ucred ucreds = {
>                         .pid = scm->creds.pid,
> -                       .uid = from_kuid_munged(current_ns, scm->creds.uid),
> -                       .gid = from_kgid_munged(current_ns, scm->creds.gid),
> +                       .uid = from_kuid_tp_munged(current_ns, scm->creds.uid),
> +                       .gid = from_kgid_tp_munged(current_ns, scm->creds.gid),
>                 };
>                 put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(ucreds), &ucreds);
>         }
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index ade739f..b6de6f4 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -645,7 +645,7 @@ static void __do_notify(struct mqueue_inode_info *info)
>                         rcu_read_lock();
>                         sig_i.si_pid = task_tgid_nr_ns(current,
>                                                 ns_of_pid(info->notify_owner));
> -                       sig_i.si_uid = from_kuid_munged(info->notify_user_ns, current_uid());
> +                       sig_i.si_uid = from_kuid_tp_munged(info->notify_user_ns, current_uid());
>                         rcu_read_unlock();
>
>                         kill_pid_info(info->notify.sigev_signo,
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 1471db9..e49adeb 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -1052,10 +1052,10 @@ static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
>                    msq->q_qnum,
>                    msq->q_lspid,
>                    msq->q_lrpid,
> -                  from_kuid_munged(user_ns, msq->q_perm.uid),
> -                  from_kgid_munged(user_ns, msq->q_perm.gid),
> -                  from_kuid_munged(user_ns, msq->q_perm.cuid),
> -                  from_kgid_munged(user_ns, msq->q_perm.cgid),
> +                  from_kuid_tp_munged(user_ns, msq->q_perm.uid),
> +                  from_kgid_tp_munged(user_ns, msq->q_perm.gid),
> +                  from_kuid_tp_munged(user_ns, msq->q_perm.cuid),
> +                  from_kgid_tp_munged(user_ns, msq->q_perm.cgid),
>                    msq->q_stime,
>                    msq->q_rtime,
>                    msq->q_ctime);
> diff --git a/ipc/sem.c b/ipc/sem.c
> index b3757ea..99589c3 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -2208,10 +2208,10 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
>                    sma->sem_perm.id,
>                    sma->sem_perm.mode,
>                    sma->sem_nsems,
> -                  from_kuid_munged(user_ns, sma->sem_perm.uid),
> -                  from_kgid_munged(user_ns, sma->sem_perm.gid),
> -                  from_kuid_munged(user_ns, sma->sem_perm.cuid),
> -                  from_kgid_munged(user_ns, sma->sem_perm.cgid),
> +                  from_kuid_tp_munged(user_ns, sma->sem_perm.uid),
> +                  from_kgid_tp_munged(user_ns, sma->sem_perm.gid),
> +                  from_kuid_tp_munged(user_ns, sma->sem_perm.cuid),
> +                  from_kgid_tp_munged(user_ns, sma->sem_perm.cgid),
>                    sem_otime,
>                    sma->sem_ctime);
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 1328251..599ab25 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -1392,10 +1392,10 @@ static int sysvipc_shm_proc_show(struct seq_file *s, void *it)
>                    shp->shm_cprid,
>                    shp->shm_lprid,
>                    shp->shm_nattch,
> -                  from_kuid_munged(user_ns, shp->shm_perm.uid),
> -                  from_kgid_munged(user_ns, shp->shm_perm.gid),
> -                  from_kuid_munged(user_ns, shp->shm_perm.cuid),
> -                  from_kgid_munged(user_ns, shp->shm_perm.cgid),
> +                  from_kuid_tp_munged(user_ns, shp->shm_perm.uid),
> +                  from_kgid_tp_munged(user_ns, shp->shm_perm.gid),
> +                  from_kuid_tp_munged(user_ns, shp->shm_perm.cuid),
> +                  from_kgid_tp_munged(user_ns, shp->shm_perm.cgid),
>                    shp->shm_atim,
>                    shp->shm_dtim,
>                    shp->shm_ctim,
> diff --git a/ipc/util.c b/ipc/util.c
> index 798cad1..81b39d5 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -513,10 +513,10 @@ int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
>  void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out)
>  {
>         out->key        = in->key;
> -       out->uid        = from_kuid_munged(current_user_ns(), in->uid);
> -       out->gid        = from_kgid_munged(current_user_ns(), in->gid);
> -       out->cuid       = from_kuid_munged(current_user_ns(), in->cuid);
> -       out->cgid       = from_kgid_munged(current_user_ns(), in->cgid);
> +       out->uid        = from_kuid_tp_munged(current_user_ns(), in->uid);
> +       out->gid        = from_kgid_tp_munged(current_user_ns(), in->gid);
> +       out->cuid       = from_kuid_tp_munged(current_user_ns(), in->cuid);
> +       out->cgid       = from_kgid_tp_munged(current_user_ns(), in->cgid);
>         out->mode       = in->mode;
>         out->seq        = in->seq;
>  }
> diff --git a/kernel/acct.c b/kernel/acct.c
> index 74963d1..bbfa0b9 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -489,8 +489,8 @@ static void do_acct_process(struct bsd_acct_struct *acct)
>
>         fill_ac(&ac);
>         /* we really need to bite the bullet and change layout */
> -       ac.ac_uid = from_kuid_munged(file->f_cred->user_ns, orig_cred->uid);
> -       ac.ac_gid = from_kgid_munged(file->f_cred->user_ns, orig_cred->gid);
> +       ac.ac_uid = from_kuid_tp_munged(file->f_cred->user_ns, orig_cred->uid);
> +       ac.ac_gid = from_kgid_tp_munged(file->f_cred->user_ns, orig_cred->gid);
>  #if ACCT_VERSION == 1 || ACCT_VERSION == 2
>         /* backward-compatible 16 bit fields */
>         ac.ac_uid16 = ac.ac_uid;
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 9e6e135..207e284 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -983,7 +983,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
>  {
>         int state, retval, status;
>         pid_t pid = task_pid_vnr(p);
> -       uid_t uid = from_kuid_munged(current_user_ns(), task_uid(p));
> +       uid_t uid = from_kuid_tp_munged(current_user_ns(), task_uid(p));
>         struct siginfo __user *infop;
>
>         if (!likely(wo->wo_flags & WEXITED))
> @@ -1189,7 +1189,7 @@ static int wait_task_stopped(struct wait_opts *wo,
>         if (!unlikely(wo->wo_flags & WNOWAIT))
>                 *p_code = 0;
>
> -       uid = from_kuid_munged(current_user_ns(), task_uid(p));
> +       uid = from_kuid_tp_munged(current_user_ns(), task_uid(p));
>  unlock_sig:
>         spin_unlock_irq(&p->sighand->siglock);
>         if (!exit_code)
> @@ -1263,7 +1263,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
>         }
>         if (!unlikely(wo->wo_flags & WNOWAIT))
>                 p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
> -       uid = from_kuid_munged(current_user_ns(), task_uid(p));
> +       uid = from_kuid_tp_munged(current_user_ns(), task_uid(p));
>         spin_unlock_irq(&p->sighand->siglock);
>
>         pid = task_pid_vnr(p);
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 74d431d..ec2ecf8 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -70,7 +70,7 @@ static int groups_to_user(gid_t __user *grouplist,
>
>         for (i = 0; i < count; i++) {
>                 gid_t gid;
> -               gid = from_kgid_munged(user_ns, GROUP_AT(group_info, i));
> +               gid = from_kgid_tp_munged(user_ns, GROUP_AT(group_info, i));
>                 if (put_user(gid, grouplist+i))
>                         return -EFAULT;
>         }
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 96e9bc4..2d7e071 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -958,7 +958,7 @@ static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_str
>                 return;
>
>         rcu_read_lock();
> -       info->si_uid = from_kuid_munged(task_cred_xxx(t, user_ns),
> +       info->si_uid = from_kuid_tp_munged(task_cred_xxx(t, user_ns),
>                                         make_kuid(current_user_ns(), info->si_uid));
>         rcu_read_unlock();
>  }
> @@ -1027,7 +1027,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>                         q->info.si_code = SI_USER;
>                         q->info.si_pid = task_tgid_nr_ns(current,
>                                                         task_active_pid_ns(t));
> -                       q->info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> +                       q->info.si_uid = from_kuid_tp_munged(current_user_ns(), current_uid());
>                         break;
>                 case (unsigned long) SEND_SIG_PRIV:
>                         q->info.si_signo = sig;
> @@ -1609,7 +1609,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
>          */
>         rcu_read_lock();
>         info.si_pid = task_pid_nr_ns(tsk, task_active_pid_ns(tsk->parent));
> -       info.si_uid = from_kuid_munged(task_cred_xxx(tsk->parent, user_ns),
> +       info.si_uid = from_kuid_tp_munged(task_cred_xxx(tsk->parent, user_ns),
>                                        task_uid(tsk));
>         rcu_read_unlock();
>
> @@ -1695,7 +1695,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
>          */
>         rcu_read_lock();
>         info.si_pid = task_pid_nr_ns(tsk, task_active_pid_ns(parent));
> -       info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
> +       info.si_uid = from_kuid_tp_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
>         rcu_read_unlock();
>
>         task_cputime(tsk, &utime, &stime);
> @@ -1904,7 +1904,7 @@ static void ptrace_do_notify(int signr, int exit_code, int why)
>         info.si_signo = signr;
>         info.si_code = exit_code;
>         info.si_pid = task_pid_vnr(current);
> -       info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> +       info.si_uid = from_kuid_tp_munged(current_user_ns(), current_uid());
>
>         /* Let the debugger run.  */
>         ptrace_stop(exit_code, why, 1, &info);
> @@ -2113,7 +2113,7 @@ static int ptrace_signal(int signr, siginfo_t *info)
>                 info->si_code = SI_USER;
>                 rcu_read_lock();
>                 info->si_pid = task_pid_vnr(current->parent);
> -               info->si_uid = from_kuid_munged(current_user_ns(),
> +               info->si_uid = from_kuid_tp_munged(current_user_ns(),
>                                                 task_uid(current->parent));
>                 rcu_read_unlock();
>         }
> @@ -2856,7 +2856,7 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
>         info.si_errno = 0;
>         info.si_code = SI_USER;
>         info.si_pid = task_tgid_vnr(current);
> -       info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> +       info.si_uid = from_kuid_tp_munged(current_user_ns(), current_uid());
>
>         return kill_something_info(sig, &info, pid);
>  }
> @@ -2899,7 +2899,7 @@ static int do_tkill(pid_t tgid, pid_t pid, int sig)
>         info.si_errno = 0;
>         info.si_code = SI_TKILL;
>         info.si_pid = task_tgid_vnr(current);
> -       info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> +       info.si_uid = from_kuid_tp_munged(current_user_ns(), current_uid());
>
>         return do_send_specific(tgid, pid, sig, &info);
>  }
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 89d5be4..ce7833d 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -648,9 +648,9 @@ SYSCALL_DEFINE3(getresuid, uid_t __user *, ruidp, uid_t __user *, euidp, uid_t _
>         int retval;
>         uid_t ruid, euid, suid;
>
> -       ruid = from_kuid_munged(cred->user_ns, cred->uid);
> -       euid = from_kuid_munged(cred->user_ns, cred->euid);
> -       suid = from_kuid_munged(cred->user_ns, cred->suid);
> +       ruid = from_kuid_tp_munged(cred->user_ns, cred->uid);
> +       euid = from_kuid_tp_munged(cred->user_ns, cred->euid);
> +       suid = from_kuid_tp_munged(cred->user_ns, cred->suid);
>
>         retval = put_user(ruid, ruidp);
>         if (!retval) {
> @@ -722,9 +722,9 @@ SYSCALL_DEFINE3(getresgid, gid_t __user *, rgidp, gid_t __user *, egidp, gid_t _
>         int retval;
>         gid_t rgid, egid, sgid;
>
> -       rgid = from_kgid_munged(cred->user_ns, cred->gid);
> -       egid = from_kgid_munged(cred->user_ns, cred->egid);
> -       sgid = from_kgid_munged(cred->user_ns, cred->sgid);
> +       rgid = from_kgid_tp_munged(cred->user_ns, cred->gid);
> +       egid = from_kgid_tp_munged(cred->user_ns, cred->egid);
> +       sgid = from_kgid_tp_munged(cred->user_ns, cred->sgid);
>
>         retval = put_user(rgid, rgidp);
>         if (!retval) {
> @@ -751,7 +751,7 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
>         kuid_t kuid;
>
>         old = current_cred();
> -       old_fsuid = from_kuid_munged(old->user_ns, old->fsuid);
> +       old_fsuid = from_kuid_tp_munged(old->user_ns, old->fsuid);
>
>         kuid = make_kuid(old->user_ns, uid);
>         if (!uid_valid(kuid))
> @@ -790,7 +790,7 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
>         kgid_t kgid;
>
>         old = current_cred();
> -       old_fsgid = from_kgid_munged(old->user_ns, old->fsgid);
> +       old_fsgid = from_kgid_tp_munged(old->user_ns, old->fsgid);
>
>         kgid = make_kgid(old->user_ns, gid);
>         if (!gid_valid(kgid))
> @@ -858,25 +858,25 @@ SYSCALL_DEFINE0(getppid)
>  SYSCALL_DEFINE0(getuid)
>  {
>         /* Only we change this so SMP safe */
> -       return from_kuid_munged(current_user_ns(), current_uid());
> +       return from_kuid_tp_munged(current_user_ns(), current_uid());
>  }
>
>  SYSCALL_DEFINE0(geteuid)
>  {
>         /* Only we change this so SMP safe */
> -       return from_kuid_munged(current_user_ns(), current_euid());
> +       return from_kuid_tp_munged(current_user_ns(), current_euid());
>  }
>
>  SYSCALL_DEFINE0(getgid)
>  {
>         /* Only we change this so SMP safe */
> -       return from_kgid_munged(current_user_ns(), current_gid());
> +       return from_kgid_tp_munged(current_user_ns(), current_gid());
>  }
>
>  SYSCALL_DEFINE0(getegid)
>  {
>         /* Only we change this so SMP safe */
> -       return from_kgid_munged(current_user_ns(), current_egid());
> +       return from_kgid_tp_munged(current_user_ns(), current_egid());
>  }
>
>  void do_sys_times(struct tms *tms)
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8a4bd6b..d4f03ee 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2743,7 +2743,7 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
>         seq_printf(m, "#    | task: %.16s-%d "
>                    "(uid:%d nice:%ld policy:%ld rt_prio:%ld)\n",
>                    data->comm, data->pid,
> -                  from_kuid_munged(seq_user_ns(m), data->uid), data->nice,
> +                  from_kuid_tp_munged(seq_user_ns(m), data->uid), data->nice,
>                    data->policy, data->rt_priority);
>         seq_puts(m, "#    -----------------\n");
>
> diff --git a/kernel/tsacct.c b/kernel/tsacct.c
> index f8e26ab..19e3a61 100644
> --- a/kernel/tsacct.c
> +++ b/kernel/tsacct.c
> @@ -60,8 +60,8 @@ void bacct_add_tsk(struct user_namespace *user_ns,
>         stats->ac_pid    = task_pid_nr_ns(tsk, pid_ns);
>         rcu_read_lock();
>         tcred = __task_cred(tsk);
> -       stats->ac_uid    = from_kuid_munged(user_ns, tcred->uid);
> -       stats->ac_gid    = from_kgid_munged(user_ns, tcred->gid);
> +       stats->ac_uid    = from_kuid_tp_munged(user_ns, tcred->uid);
> +       stats->ac_gid    = from_kgid_tp_munged(user_ns, tcred->gid);
>         stats->ac_ppid   = pid_alive(tsk) ?
>                 task_tgid_nr_ns(rcu_dereference(tsk->real_parent), pid_ns) : 0;
>         rcu_read_unlock();
> diff --git a/kernel/uid16.c b/kernel/uid16.c
> index d58cc4d..f91f270 100644
> --- a/kernel/uid16.c
> +++ b/kernel/uid16.c
> @@ -63,9 +63,9 @@ SYSCALL_DEFINE3(getresuid16, old_uid_t __user *, ruidp, old_uid_t __user *, euid
>         int retval;
>         old_uid_t ruid, euid, suid;
>
> -       ruid = high2lowuid(from_kuid_munged(cred->user_ns, cred->uid));
> -       euid = high2lowuid(from_kuid_munged(cred->user_ns, cred->euid));
> -       suid = high2lowuid(from_kuid_munged(cred->user_ns, cred->suid));
> +       ruid = high2lowuid(from_kuid_tp_munged(cred->user_ns, cred->uid));
> +       euid = high2lowuid(from_kuid_tp_munged(cred->user_ns, cred->euid));
> +       suid = high2lowuid(from_kuid_tp_munged(cred->user_ns, cred->suid));
>
>         if (!(retval   = put_user(ruid, ruidp)) &&
>             !(retval   = put_user(euid, euidp)))
> @@ -87,9 +87,9 @@ SYSCALL_DEFINE3(getresgid16, old_gid_t __user *, rgidp, old_gid_t __user *, egid
>         int retval;
>         old_gid_t rgid, egid, sgid;
>
> -       rgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->gid));
> -       egid = high2lowgid(from_kgid_munged(cred->user_ns, cred->egid));
> -       sgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->sgid));
> +       rgid = high2lowgid(from_kgid_tp_munged(cred->user_ns, cred->gid));
> +       egid = high2lowgid(from_kgid_tp_munged(cred->user_ns, cred->egid));
> +       sgid = high2lowgid(from_kgid_tp_munged(cred->user_ns, cred->sgid));
>
>         if (!(retval   = put_user(rgid, rgidp)) &&
>             !(retval   = put_user(egid, egidp)))
> @@ -118,7 +118,7 @@ static int groups16_to_user(old_gid_t __user *grouplist,
>
>         for (i = 0; i < group_info->ngroups; i++) {
>                 kgid = GROUP_AT(group_info, i);
> -               group = high2lowgid(from_kgid_munged(user_ns, kgid));
> +               group = high2lowgid(from_kgid_tp_munged(user_ns, kgid));
>                 if (put_user(group, grouplist+i))
>                         return -EFAULT;
>         }
> @@ -198,20 +198,20 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
>
>  SYSCALL_DEFINE0(getuid16)
>  {
> -       return high2lowuid(from_kuid_munged(current_user_ns(), current_uid()));
> +       return high2lowuid(from_kuid_tp_munged(current_user_ns(), current_uid()));
>  }
>
>  SYSCALL_DEFINE0(geteuid16)
>  {
> -       return high2lowuid(from_kuid_munged(current_user_ns(), current_euid()));
> +       return high2lowuid(from_kuid_tp_munged(current_user_ns(), current_euid()));
>  }
>
>  SYSCALL_DEFINE0(getgid16)
>  {
> -       return high2lowgid(from_kgid_munged(current_user_ns(), current_gid()));
> +       return high2lowgid(from_kgid_tp_munged(current_user_ns(), current_gid()));
>  }
>
>  SYSCALL_DEFINE0(getegid16)
>  {
> -       return high2lowgid(from_kgid_munged(current_user_ns(), current_egid()));
> +       return high2lowgid(from_kgid_tp_munged(current_user_ns(), current_egid()));
>  }
> diff --git a/kernel/user.c b/kernel/user.c
> index b069ccb..e1fd9e5 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -48,6 +48,7 @@ struct user_namespace init_user_ns = {
>                 },
>         },
>         .count = ATOMIC_INIT(3),
> +       .opaque = &init_user_ns,
>         .owner = GLOBAL_ROOT_UID,
>         .group = GLOBAL_ROOT_GID,
>         .ns.inum = PROC_USER_INIT_INO,
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 9bafc21..44a7d3d 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -98,6 +98,7 @@ int create_user_ns(struct cred *new)
>         atomic_set(&ns->count, 1);
>         /* Leave the new->user_ns reference with the new user namespace. */
>         ns->parent = parent_ns;
> +       ns->opaque = ns;
>         ns->level = parent_ns->level + 1;
>         ns->owner = owner;
>         ns->group = group;
> @@ -249,7 +250,8 @@ EXPORT_SYMBOL(make_kuid);
>   *     @kuid: The kernel internal uid to start with.
>   *
>   *     Map @kuid into the user-namespace specified by @targ and
> - *     return the resulting uid.
> + *     return the resulting uid. This ignores transparent user
> + *     namespaces and is therefore appropriate for security checks.
>   *
>   *     There is always a mapping into the initial user_namespace.
>   *
> @@ -263,33 +265,63 @@ uid_t from_kuid(struct user_namespace *targ, kuid_t kuid)
>  EXPORT_SYMBOL(from_kuid);
>
>  /**
> - *     from_kuid_munged - Create a uid from a kuid user-namespace pair.
> + *     from_kuid_tp - Create a uid from a kuid user-namespace pair.
> + *     @targ: The user namespace we want a uid in.
> + *     @kuid: The kernel internal uid to start with.
> + *
> + *     Map @kuid into the user-namespace specified by @targ and
> + *     return the resulting uid.
> + *
> + *     This function is *not* appropriate for security checks because
> + *     if @targ is transparent, the mappings of an ancestor namespace
> + *     are used. If you intend to do anything with the result apart from
> + *     returning it to a process in @targ, you might want to use
> + *     from_kuid() instead.
> + *
> + *     There is always a mapping into the initial user_namespace.
> + *
> + *     If @kuid is not visible in @targ (uid_t)-1 is returned.
> + */
> +uid_t from_kuid_tp(struct user_namespace *targ, kuid_t kuid)
> +{
> +       /* Map the uid from a global kernel uid */
> +       struct user_namespace *opaque = READ_ONCE(targ->opaque);
> +
> +       return map_id_up(&opaque->uid_map, __kuid_val(kuid));
> +}
> +EXPORT_SYMBOL(from_kuid_tp);
> +
> +/**
> + *     from_kuid_tp_munged - Create a uid from a kuid user-namespace pair.
>   *     @targ: The user namespace we want a uid in.
>   *     @kuid: The kernel internal uid to start with.
>   *
>   *     Map @kuid into the user-namespace specified by @targ and
>   *     return the resulting uid.
>   *
> + *     This function is *not* appropriate for security checks; see the
> + *     comment above from_kuid_tp().
> + *
>   *     There is always a mapping into the initial user_namespace.
>   *
> - *     Unlike from_kuid from_kuid_munged never fails and always
> - *     returns a valid uid.  This makes from_kuid_munged appropriate
> + *     Unlike from_kuid_tp from_kuid_tp_munged never fails and always
> + *     returns a valid uid.  This makes from_kuid_tp_munged appropriate
>   *     for use in syscalls like stat and getuid where failing the
>   *     system call and failing to provide a valid uid are not an
>   *     options.
>   *
>   *     If @kuid has no mapping in @targ overflowuid is returned.
>   */
> -uid_t from_kuid_munged(struct user_namespace *targ, kuid_t kuid)
> +uid_t from_kuid_tp_munged(struct user_namespace *targ, kuid_t kuid)
>  {
>         uid_t uid;
> -       uid = from_kuid(targ, kuid);
> +       uid = from_kuid_tp(targ, kuid);
>
>         if (uid == (uid_t) -1)
>                 uid = overflowuid;
>         return uid;
>  }
> -EXPORT_SYMBOL(from_kuid_munged);
> +EXPORT_SYMBOL(from_kuid_tp_munged);
>
>  /**
>   *     make_kgid - Map a user-namespace gid pair into a kgid.
> @@ -317,7 +349,8 @@ EXPORT_SYMBOL(make_kgid);
>   *     @kgid: The kernel internal gid to start with.
>   *
>   *     Map @kgid into the user-namespace specified by @targ and
> - *     return the resulting gid.
> + *     return the resulting gid. This ignores transparent user
> + *     namespaces and is therefore appropriate for security checks.
>   *
>   *     There is always a mapping into the initial user_namespace.
>   *
> @@ -331,32 +364,62 @@ gid_t from_kgid(struct user_namespace *targ, kgid_t kgid)
>  EXPORT_SYMBOL(from_kgid);
>
>  /**
> - *     from_kgid_munged - Create a gid from a kgid user-namespace pair.
> + *     from_kgid_tp - Create a gid from a kgid user-namespace pair.
>   *     @targ: The user namespace we want a gid in.
>   *     @kgid: The kernel internal gid to start with.
>   *
>   *     Map @kgid into the user-namespace specified by @targ and
>   *     return the resulting gid.
>   *
> + *     This function is *not* appropriate for security checks because
> + *     if @targ is transparent, the mappings of an ancestor namespace
> + *     are used. If you intend to do anything with the result apart from
> + *     returning it to a process in @targ, you might want to use
> + *     from_kgid() instead.
> + *
>   *     There is always a mapping into the initial user_namespace.
>   *
> - *     Unlike from_kgid from_kgid_munged never fails and always
> - *     returns a valid gid.  This makes from_kgid_munged appropriate
> + *     If @kgid is not visible in @targ (gid_t)-1 is returned.
> + */
> +gid_t from_kgid_tp(struct user_namespace *targ, kgid_t kgid)
> +{
> +       /* Map the gid from a global kernel gid */
> +       struct user_namespace *opaque = READ_ONCE(targ->opaque);
> +
> +       return map_id_up(&opaque->gid_map, __kgid_val(kgid));
> +}
> +EXPORT_SYMBOL(from_kgid_tp);
> +
> +/**
> + *     from_kgid_tp_munged - Create a gid from a kgid user-namespace pair.
> + *     @targ: The user namespace we want a gid in.
> + *     @kgid: The kernel internal gid to start with.
> + *
> + *     Map @kgid into the user-namespace specified by @targ and
> + *     return the resulting gid.
> + *
> + *     This function is *not* appropriate for security checks; see the
> + *     comment above from_kgid_tp().
> + *
> + *     There is always a mapping into the initial user_namespace.
> + *
> + *     Unlike from_kgid_tp from_kgid_tp_munged never fails and always
> + *     returns a valid gid.  This makes from_kgid_tp_munged appropriate
>   *     for use in syscalls like stat and getgid where failing the
>   *     system call and failing to provide a valid gid are not options.
>   *
>   *     If @kgid has no mapping in @targ overflowgid is returned.
>   */
> -gid_t from_kgid_munged(struct user_namespace *targ, kgid_t kgid)
> +gid_t from_kgid_tp_munged(struct user_namespace *targ, kgid_t kgid)
>  {
>         gid_t gid;
> -       gid = from_kgid(targ, kgid);
> +       gid = from_kgid_tp(targ, kgid);
>
>         if (gid == (gid_t) -1)
>                 gid = overflowgid;
>         return gid;
>  }
> -EXPORT_SYMBOL(from_kgid_munged);
> +EXPORT_SYMBOL(from_kgid_tp_munged);
>
>  /**
>   *     make_kprojid - Map a user-namespace projid pair into a kprojid.
> @@ -811,6 +874,18 @@ static bool new_idmap_permitted(const struct file *file,
>                                 struct uid_gid_map *new_map)
>  {
>         const struct cred *cred = file->f_cred;
> +       unsigned int idx;
> +
> +       /* Don't allow non-identity mappings in transparent namespaces. */
> +       if (ns != ns->opaque) {
> +               for (idx = 0; idx < new_map->nr_extents; idx++) {
> +                       struct uid_gid_extent *ext = &new_map->extent[idx];
> +
> +                       if (ext->first != ext->lower_first)
> +                               return false;
> +               }
> +       }
> +
>         /* Don't allow mappings that would allow anything that wouldn't
>          * be allowed without the establishment of unprivileged mappings.
>          */
> @@ -922,6 +997,81 @@ out_unlock:
>         goto out;
>  }
>
> +int proc_transparent_show(struct seq_file *seq, void *v)
> +{
> +       struct user_namespace *ns = seq->private;
> +       struct user_namespace *opaque = READ_ONCE(ns->opaque);
> +
> +       seq_printf(seq, "%d\n", (ns == opaque) ? 0 : 1);
> +       return 0;
> +}
> +
> +ssize_t proc_transparent_write(struct file *file, const char __user *buf,
> +                            size_t count, loff_t *ppos)
> +{
> +       struct seq_file *seq = file->private_data;
> +       struct user_namespace *ns = seq->private;
> +       char kbuf[8], *pos;
> +       bool transparent;
> +       ssize_t ret;
> +
> +       /* Only allow a very narrow range of strings to be written */
> +       ret = -EINVAL;
> +       if ((*ppos != 0) || (count >= sizeof(kbuf)))
> +               goto out;
> +
> +       /* What was written? */
> +       ret = -EFAULT;
> +       if (copy_from_user(kbuf, buf, count))
> +               goto out;
> +       kbuf[count] = '\0';
> +       pos = kbuf;
> +
> +       /* What is being requested? */
> +       ret = -EINVAL;
> +       if (pos[0] == '1') {
> +               pos += 1;
> +               transparent = true;
> +       } else if (pos[0] == '0') {
> +               pos += 1;
> +               transparent = false;
> +       } else
> +               goto out;
> +
> +       /* Verify there is not trailing junk on the line */
> +       pos = skip_spaces(pos);
> +       if (*pos != '\0')
> +               goto out;
> +
> +       ret = -EPERM;
> +       mutex_lock(&userns_state_mutex);
> +       /* Is the requested state different from the current one? */
> +       if (transparent != (ns->opaque != ns)) {
> +               /* You can't turn off transparent mode. */
> +               if (!transparent)
> +                       goto out_unlock;
> +               /* If there are existing mappings, they might be
> +                * non-identity mappings. Therefore, block transparent
> +                * mode. This also prevents making the init namespace
> +                * transparent (which wouldn't work).
> +                */
> +               if (ns->uid_map.nr_extents != 0 || ns->gid_map.nr_extents != 0)
> +                       goto out_unlock;
> +               /* Okay! Make the namespace transparent. */
> +               ns->opaque = ns->parent->opaque;
> +       }
> +       mutex_unlock(&userns_state_mutex);
> +
> +       /* Report a successful write */
> +       *ppos = count;
> +       ret = count;
> +out:
> +       return ret;
> +out_unlock:
> +       mutex_unlock(&userns_state_mutex);
> +       goto out;
> +}
> +
>  bool userns_may_setgroups(const struct user_namespace *ns)
>  {
>         bool allowed;
> diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
> index af46bc4..c0f45bc 100644
> --- a/net/appletalk/atalk_proc.c
> +++ b/net/appletalk/atalk_proc.c
> @@ -184,7 +184,7 @@ static int atalk_seq_socket_show(struct seq_file *seq, void *v)
>                    sk_wmem_alloc_get(s),
>                    sk_rmem_alloc_get(s),
>                    s->sk_state,
> -                  from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)));
> +                  from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(s)));
>  out:
>         return 0;
>  }
> diff --git a/net/ax25/ax25_uid.c b/net/ax25/ax25_uid.c
> index 4ad2fb7..b28e339 100644
> --- a/net/ax25/ax25_uid.c
> +++ b/net/ax25/ax25_uid.c
> @@ -81,7 +81,7 @@ int ax25_uid_ioctl(int cmd, struct sockaddr_ax25 *sax)
>                 read_lock(&ax25_uid_lock);
>                 ax25_uid_for_each(ax25_uid, &ax25_uid_list) {
>                         if (ax25cmp(&sax->sax25_call, &ax25_uid->call) == 0) {
> -                               res = from_kuid_munged(current_user_ns(), ax25_uid->uid);
> +                               res = from_kuid_tp_munged(current_user_ns(), ax25_uid->uid);
>                                 break;
>                         }
>                 }
> @@ -175,7 +175,7 @@ static int ax25_uid_seq_show(struct seq_file *seq, void *v)
>
>                 pt = hlist_entry(v, struct ax25_uid_assoc, uid_node);
>                 seq_printf(seq, "%6d %s\n",
> -                       from_kuid_munged(seq_user_ns(seq), pt->uid),
> +                       from_kuid_tp_munged(seq_user_ns(seq), pt->uid),
>                         ax2asc(buf, &pt->call));
>         }
>         return 0;
> diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
> index 3df7aef..5e9906b 100644
> --- a/net/bluetooth/af_bluetooth.c
> +++ b/net/bluetooth/af_bluetooth.c
> @@ -625,7 +625,7 @@ static int bt_seq_show(struct seq_file *seq, void *v)
>                            atomic_read(&sk->sk_refcnt),
>                            sk_rmem_alloc_get(sk),
>                            sk_wmem_alloc_get(sk),
> -                          from_kuid(seq_user_ns(seq), sock_i_uid(sk)),
> +                          from_kuid_tp(seq_user_ns(seq), sock_i_uid(sk)),
>                            sock_i_ino(sk),
>                            bt->parent? sock_i_ino(bt->parent): 0LU);
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 08bf97e..1e6192d 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1020,8 +1020,8 @@ static void cred_to_ucred(struct pid *pid, const struct cred *cred,
>         if (cred) {
>                 struct user_namespace *current_ns = current_user_ns();
>
> -               ucred->uid = from_kuid_munged(current_ns, cred->euid);
> -               ucred->gid = from_kgid_munged(current_ns, cred->egid);
> +               ucred->uid = from_kuid_tp_munged(current_ns, cred->euid);
> +               ucred->gid = from_kgid_tp_munged(current_ns, cred->egid);
>         }
>  }
>
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index 25af124..26f1ec2 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -134,7 +134,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>         }
>  #endif
>
> -       r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
> +       r->idiag_uid = from_kuid_tp_munged(user_ns, sock_i_uid(sk));
>         r->idiag_inode = sock_i_ino(sk);
>
>         return 0;
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 66ddcb6..f3b27ea 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -1121,7 +1121,7 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
>                 sk_wmem_alloc_get(sp),
>                 sk_rmem_alloc_get(sp),
>                 0, 0L, 0,
> -               from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
> +               from_kuid_tp_munged(seq_user_ns(f), sock_i_uid(sp)),
>                 0, sock_i_ino(sp),
>                 atomic_read(&sp->sk_refcnt), sp,
>                 atomic_read(&sp->sk_drops));
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index 438f50c..759095ee 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -1033,7 +1033,7 @@ static void raw_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
>                 sk_wmem_alloc_get(sp),
>                 sk_rmem_alloc_get(sp),
>                 0, 0L, 0,
> -               from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
> +               from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(sp)),
>                 0, sock_i_ino(sp),
>                 atomic_read(&sp->sk_refcnt), sp, atomic_read(&sp->sk_drops));
>  }
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 1cb67de..4e19885 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -133,8 +133,8 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
>         };
>
>         inet_get_ping_group_range_table(table, &low, &high);
> -       urange[0] = from_kgid_munged(user_ns, low);
> -       urange[1] = from_kgid_munged(user_ns, high);
> +       urange[0] = from_kgid_tp_munged(user_ns, low);
> +       urange[1] = from_kgid_tp_munged(user_ns, high);
>         ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
>
>         if (write && ret == 0) {
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 3708de2..5a5ae86 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2161,8 +2161,8 @@ static void get_openreq4(const struct request_sock *req,
>                 1,    /* timers active (only the expire timer) */
>                 jiffies_delta_to_clock_t(delta),
>                 req->num_timeout,
> -               from_kuid_munged(seq_user_ns(f),
> -                                sock_i_uid(req->rsk_listener)),
> +               from_kuid_tp_munged(seq_user_ns(f),
> +                                   sock_i_uid(req->rsk_listener)),
>                 0,  /* non standard timer */
>                 0, /* open_requests have no inode */
>                 0,
> @@ -2217,7 +2217,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
>                 timer_active,
>                 jiffies_delta_to_clock_t(timer_expires - jiffies),
>                 icsk->icsk_retransmits,
> -               from_kuid_munged(seq_user_ns(f), sock_i_uid(sk)),
> +               from_kuid_tp_munged(seq_user_ns(f), sock_i_uid(sk)),
>                 icsk->icsk_probes_out,
>                 sock_i_ino(sk),
>                 atomic_read(&sk->sk_refcnt), sk,
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 0ff31d9..e3579b2 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2408,7 +2408,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
>                 sk_wmem_alloc_get(sp),
>                 sk_rmem_alloc_get(sp),
>                 0, 0L, 0,
> -               from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
> +               from_kuid_tp_munged(seq_user_ns(f), sock_i_uid(sp)),
>                 0, sock_i_ino(sp),
>                 atomic_read(&sp->sk_refcnt), sp,
>                 atomic_read(&sp->sk_drops));
> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index 37874e2..d66dd7c 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c
> @@ -1028,7 +1028,7 @@ void ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp,
>                    sk_wmem_alloc_get(sp),
>                    sk_rmem_alloc_get(sp),
>                    0, 0L, 0,
> -                  from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
> +                  from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(sp)),
>                    0,
>                    sock_i_ino(sp),
>                    atomic_read(&sp->sk_refcnt), sp,
> diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
> index b912f0d..a1c7516 100644
> --- a/net/ipv6/ip6_flowlabel.c
> +++ b/net/ipv6/ip6_flowlabel.c
> @@ -789,7 +789,7 @@ static int ip6fl_seq_show(struct seq_file *seq, void *v)
>                            ((fl->share == IPV6_FL_S_PROCESS) ?
>                             pid_nr_ns(fl->owner.pid, state->pid_ns) :
>                             ((fl->share == IPV6_FL_S_USER) ?
> -                            from_kuid_munged(seq_user_ns(seq), fl->owner.uid) :
> +                            from_kuid_tp_munged(seq_user_ns(seq), fl->owner.uid) :
>                              0)),
>                            atomic_read(&fl->users),
>                            fl->linger/HZ,
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index f36c2d0..04643ca 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1696,8 +1696,8 @@ static void get_openreq6(struct seq_file *seq,
>                    1,   /* timers active (only the expire timer) */
>                    jiffies_to_clock_t(ttd),
>                    req->num_timeout,
> -                  from_kuid_munged(seq_user_ns(seq),
> -                                   sock_i_uid(req->rsk_listener)),
> +                  from_kuid_tp_munged(seq_user_ns(seq),
> +                                      sock_i_uid(req->rsk_listener)),
>                    0,  /* non standard timer */
>                    0, /* open_requests have no inode */
>                    0, req);
> @@ -1760,7 +1760,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
>                    timer_active,
>                    jiffies_delta_to_clock_t(timer_expires - jiffies),
>                    icsk->icsk_retransmits,
> -                  from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
> +                  from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(sp)),
>                    icsk->icsk_probes_out,
>                    sock_i_ino(sp),
>                    atomic_read(&sp->sk_refcnt), sp,
> diff --git a/net/ipx/ipx_proc.c b/net/ipx/ipx_proc.c
> index c1d247e..fc1d1fe 100644
> --- a/net/ipx/ipx_proc.c
> +++ b/net/ipx/ipx_proc.c
> @@ -217,7 +217,7 @@ static int ipx_seq_socket_show(struct seq_file *seq, void *v)
>                    sk_wmem_alloc_get(s),
>                    sk_rmem_alloc_get(s),
>                    s->sk_state,
> -                  from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)));
> +                  from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(s)));
>  out:
>         return 0;
>  }
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index f9c9ecb..b76105f 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -3714,7 +3714,7 @@ static int pfkey_seq_show(struct seq_file *f, void *v)
>                                atomic_read(&s->sk_refcnt),
>                                sk_rmem_alloc_get(s),
>                                sk_wmem_alloc_get(s),
> -                              from_kuid_munged(seq_user_ns(f), sock_i_uid(s)),
> +                              from_kuid_tp_munged(seq_user_ns(f), sock_i_uid(s)),
>                                sock_i_ino(s)
>                                );
>         return 0;
> diff --git a/net/llc/llc_proc.c b/net/llc/llc_proc.c
> index 29c509c..96d2dff 100644
> --- a/net/llc/llc_proc.c
> +++ b/net/llc/llc_proc.c
> @@ -151,7 +151,7 @@ static int llc_seq_socket_show(struct seq_file *seq, void *v)
>                    sk_wmem_alloc_get(sk),
>                    sk_rmem_alloc_get(sk) - llc->copied_seq,
>                    sk->sk_state,
> -                  from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
> +                  from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(sk)),
>                    llc->link);
>  out:
>         return 0;
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 11f81c8..3263bca 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -552,8 +552,8 @@ __build_packet_message(struct nfnl_log_net *log,
>                         struct file *file = sk->sk_socket->file;
>                         const struct cred *cred = file->f_cred;
>                         struct user_namespace *user_ns = inst->peer_user_ns;
> -                       __be32 uid = htonl(from_kuid_munged(user_ns, cred->fsuid));
> -                       __be32 gid = htonl(from_kgid_munged(user_ns, cred->fsgid));
> +                       __be32 uid = htonl(from_kuid_tp_munged(user_ns, cred->fsuid));
> +                       __be32 gid = htonl(from_kgid_tp_munged(user_ns, cred->fsgid));
>                         read_unlock_bh(&sk->sk_callback_lock);
>                         if (nla_put_be32(inst->skb, NFULA_UID, uid) ||
>                             nla_put_be32(inst->skb, NFULA_GID, gid))
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 9bff6ef..21443c8 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -4497,7 +4497,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
>                            po->ifindex,
>                            po->running,
>                            atomic_read(&s->sk_rmem_alloc),
> -                          from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)),
> +                          from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(s)),
>                            sock_i_ino(s));
>         }
>
> diff --git a/net/packet/diag.c b/net/packet/diag.c
> index 0ed68f0..40b8df7 100644
> --- a/net/packet/diag.c
> +++ b/net/packet/diag.c
> @@ -153,7 +153,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
>
>         if ((req->pdiag_show & PACKET_SHOW_INFO) &&
>             nla_put_u32(skb, PACKET_DIAG_UID,
> -                       from_kuid_munged(user_ns, sock_i_uid(sk))))
> +                       from_kuid_tp_munged(user_ns, sock_i_uid(sk))))
>                 goto out_nlmsg_trim;
>
>         if ((req->pdiag_show & PACKET_SHOW_MCLIST) &&
> diff --git a/net/phonet/socket.c b/net/phonet/socket.c
> index ffd5f22..fa90d85 100644
> --- a/net/phonet/socket.c
> +++ b/net/phonet/socket.c
> @@ -610,7 +610,7 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
>                         sk->sk_protocol, pn->sobject, pn->dobject,
>                         pn->resource, sk->sk_state,
>                         sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
> -                       from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
> +                       from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(sk)),
>                         sock_i_ino(sk),
>                         atomic_read(&sk->sk_refcnt), sk,
>                         atomic_read(&sk->sk_drops));
> @@ -795,7 +795,7 @@ static int pn_res_seq_show(struct seq_file *seq, void *v)
>
>                 seq_printf(seq, "%02X %5u %lu",
>                            (int) (psk - pnres.sk),
> -                          from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
> +                          from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(sk)),
>                            sock_i_ino(sk));
>         }
>         seq_pad(seq, '\n');
> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> index 4cb5aed..a893492 100644
> --- a/net/sctp/proc.c
> +++ b/net/sctp/proc.c
> @@ -224,7 +224,7 @@ static int sctp_eps_seq_show(struct seq_file *seq, void *v)
>                 seq_printf(seq, "%8pK %8pK %-3d %-3d %-4d %-5d %5u %5lu ", ep, sk,
>                            sctp_sk(sk)->type, sk->sk_state, hash,
>                            epb->bind_addr.port,
> -                          from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
> +                          from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(sk)),
>                            sock_i_ino(sk));
>
>                 sctp_seq_dump_local_addrs(seq, epb);
> @@ -346,7 +346,7 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
>                    assoc->assoc_id,
>                    assoc->sndbuf_used,
>                    atomic_read(&assoc->rmem_alloc),
> -                  from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
> +                  from_kuid_tp_munged(seq_user_ns(seq), sock_i_uid(sk)),
>                    sock_i_ino(sk),
>                    epb->bind_addr.port,
>                    assoc->peer.port);
> diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
> index dfacdc9..ce7a1ce 100644
> --- a/net/sunrpc/svcauth_unix.c
> +++ b/net/sunrpc/svcauth_unix.c
> @@ -562,9 +562,9 @@ static int unix_gid_show(struct seq_file *m,
>         else
>                 glen = 0;
>
> -       seq_printf(m, "%u %d:", from_kuid_munged(user_ns, ug->uid), glen);
> +       seq_printf(m, "%u %d:", from_kuid_tp_munged(user_ns, ug->uid), glen);
>         for (i = 0; i < glen; i++)
> -               seq_printf(m, " %d", from_kgid_munged(user_ns, GROUP_AT(ug->gi, i)));
> +               seq_printf(m, " %d", from_kgid_tp_munged(user_ns, GROUP_AT(ug->gi, i)));
>         seq_printf(m, "\n");
>         return 0;
>  }
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index d580ad0..b88f73d 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -619,8 +619,8 @@ okay:
>         infobuf = kasprintf(GFP_KERNEL,
>                             "%s;%d;%d;%08x;",
>                             key->type->name,
> -                           from_kuid_munged(current_user_ns(), key->uid),
> -                           from_kgid_munged(current_user_ns(), key->gid),
> +                           from_kuid_tp_munged(current_user_ns(), key->uid),
> +                           from_kgid_tp_munged(current_user_ns(), key->gid),
>                             key->perm);
>         if (!infobuf)
>                 goto error2;
> diff --git a/security/keys/proc.c b/security/keys/proc.c
> index f0611a6..f71449d 100644
> --- a/security/keys/proc.c
> +++ b/security/keys/proc.c
> @@ -255,8 +255,8 @@ static int proc_keys_show(struct seq_file *m, void *v)
>                    atomic_read(&key->usage),
>                    xbuf,
>                    key->perm,
> -                  from_kuid_munged(seq_user_ns(m), key->uid),
> -                  from_kgid_munged(seq_user_ns(m), key->gid),
> +                  from_kuid_tp_munged(seq_user_ns(m), key->uid),
> +                  from_kgid_tp_munged(seq_user_ns(m), key->gid),
>                    key->type->name);
>
>  #undef showflag
> @@ -339,7 +339,7 @@ static int proc_key_users_show(struct seq_file *m, void *v)
>                 key_quota_root_maxbytes : key_quota_maxbytes;
>
>         seq_printf(m, "%5u: %5d %d/%d %d/%d %d/%d\n",
> -                  from_kuid_munged(seq_user_ns(m), user->uid),
> +                  from_kuid_tp_munged(seq_user_ns(m), user->uid),
>                    atomic_read(&user->usage),
>                    atomic_read(&user->nkeys),
>                    atomic_read(&user->nikeys),
> --
> 2.8.0.rc3.226.g39d4020
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
