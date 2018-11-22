From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Thu, 22 Nov 2018 19:23:01 +1100
Message-ID: <20181122082301.egku57yzlmxbam2v@yavin>
References: <20181120105124.14733-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3jh4s5fbhujkntjl"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181120105124.14733-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org


--3jh4s5fbhujkntjl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-11-20, Christian Brauner <christian@brauner.io> wrote:
> The kill() syscall operates on process identifiers. After a process has
> exited its pid can be reused by another process. If a caller sends a sign=
al
> to a reused pid it will end up signaling the wrong process. This issue has
> often surfaced and there has been a push [1] to address this problem.
>=20
> This patch uses file descriptors from proc/<pid> as stable handles on
> struct pid. Even if a pid is recycled the handle will not change. The file
> descriptor can be used to send signals to the referenced process.
> Thus, the  new syscall procfd_signal() is introduced to solve this proble=
m.
> It operates on a process file descriptor.
> The syscall takes an additional siginfo_t and flags argument. If siginfo_t
> is NULL then procfd_signal() behaves like kill() if it is not NULL it
> behaves like rt_sigqueueinfo.
> The flags argument is added to allow for future extensions of this syscal=
l.
> It currently needs to be passed as 0.
>=20
> With this patch a process can be killed via:
>=20
>  #define _GNU_SOURCE
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <signal.h>
>  #include <sys/stat.h>
>  #include <sys/syscall.h>
>  #include <sys/types.h>
>  #include <unistd.h>
>=20
>  int main(int argc, char *argv[])
>  {
>          int ret;
>          char buf[1000];
>=20
>          if (argc < 2)
>                  exit(EXIT_FAILURE);
>=20
>          ret =3D snprintf(buf, sizeof(buf), "/proc/%s", argv[1]);
>          if (ret < 0)
>                  exit(EXIT_FAILURE);
>=20
>          int fd =3D open(buf, O_DIRECTORY | O_CLOEXEC);
>          if (fd < 0) {
>                  printf("%s - Failed to open \"%s\"\n", strerror(errno), =
buf);
>                  exit(EXIT_FAILURE);
>          }
>=20
>          ret =3D syscall(__NR_procfd_signal, fd, SIGKILL, NULL, 0);
>          if (ret < 0) {
>                  printf("Failed to send SIGKILL \"%s\"\n", strerror(errno=
));
>                  close(fd);
>                  exit(EXIT_FAILURE);
>          }
>=20
>          close(fd);
>=20
>          exit(EXIT_SUCCESS);
>  }
>=20
> [1]: https://lkml.org/lkml/2018/11/18/130
>=20
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirsky <luto@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Aleksa Sarai <cyphar@cyphar.com>

Acked-by: Aleksa Sarai <cyphar@cyphar.com>

> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Christian Brauner <christian@brauner.io>
> ---
> Changelog:
> v2:
> - define __NR_procfd_signal in unistd.h
> - wire up compat syscall
> - s/proc_is_procfd/proc_is_tgid_procfd/g
> - provide stubs when CONFIG_PROC_FS=3Dn
> - move proc_pid() to linux/proc_fs.h header
> - use proc_pid() to grab struct pid from /proc/<pid> fd
> v1:
> - patch introduced
> ---
>  arch/x86/entry/syscalls/syscall_32.tbl |   1 +
>  arch/x86/entry/syscalls/syscall_64.tbl |   2 +
>  fs/proc/base.c                         |  11 ++-
>  fs/proc/internal.h                     |   5 -
>  include/linux/proc_fs.h                |  12 +++
>  include/linux/syscalls.h               |   2 +
>  include/uapi/asm-generic/unistd.h      |   4 +-
>  kernel/signal.c                        | 127 +++++++++++++++++++++++--
>  8 files changed, 151 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/sysc=
alls/syscall_32.tbl
> index 3cf7b533b3d1..3f27ffd8ae87 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -398,3 +398,4 @@
>  384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
>  385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgeteven=
ts
>  386	i386	rseq			sys_rseq			__ia32_sys_rseq
> +387	i386	procfd_signal		sys_procfd_signal		__ia32_compat_sys_procfd_sign=
al
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/sysc=
alls/syscall_64.tbl
> index f0b1709a5ffb..8a30cde82450 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -343,6 +343,7 @@
>  332	common	statx			__x64_sys_statx
>  333	common	io_pgetevents		__x64_sys_io_pgetevents
>  334	common	rseq			__x64_sys_rseq
> +335	64	procfd_signal		__x64_sys_procfd_signal
> =20
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> @@ -386,3 +387,4 @@
>  545	x32	execveat		__x32_compat_sys_execveat/ptregs
>  546	x32	preadv2			__x32_compat_sys_preadv64v2
>  547	x32	pwritev2		__x32_compat_sys_pwritev64v2
> +548	x32	procfd_signal		__x32_compat_sys_procfd_signal
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index ce3465479447..771c6bd1cac6 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -716,7 +716,10 @@ static int proc_pid_permission(struct inode *inode, =
int mask)
>  	return generic_permission(inode, mask);
>  }
> =20
> -
> +struct pid *proc_pid(const struct inode *inode)
> +{
> +       return PROC_I(inode)->pid;
> +}
> =20
>  static const struct inode_operations proc_def_inode_operations =3D {
>  	.setattr	=3D proc_setattr,
> @@ -3038,6 +3041,12 @@ static const struct file_operations proc_tgid_base=
_operations =3D {
>  	.llseek		=3D generic_file_llseek,
>  };
> =20
> +bool proc_is_tgid_procfd(const struct file *file)
> +{
> +	return d_is_dir(file->f_path.dentry) &&
> +	       (file->f_op =3D=3D &proc_tgid_base_operations);
> +}
> +
>  static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct de=
ntry *dentry, unsigned int flags)
>  {
>  	return proc_pident_lookup(dir, dentry,
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 5185d7f6a51e..eb69afba83f3 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -113,11 +113,6 @@ static inline void *__PDE_DATA(const struct inode *i=
node)
>  	return PDE(inode)->data;
>  }
> =20
> -static inline struct pid *proc_pid(const struct inode *inode)
> -{
> -	return PROC_I(inode)->pid;
> -}
> -
>  static inline struct task_struct *get_proc_task(const struct inode *inod=
e)
>  {
>  	return get_pid_task(proc_pid(inode), PIDTYPE_PID);
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index d0e1f1522a78..96df2fe6311d 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -73,6 +73,8 @@ struct proc_dir_entry *proc_create_net_single_write(con=
st char *name, umode_t mo
>  						    int (*show)(struct seq_file *, void *),
>  						    proc_write_t write,
>  						    void *data);
> +extern bool proc_is_tgid_procfd(const struct file *file);
> +extern struct pid *proc_pid(const struct inode *inode);
> =20
>  #else /* CONFIG_PROC_FS */
> =20
> @@ -114,6 +116,16 @@ static inline int remove_proc_subtree(const char *na=
me, struct proc_dir_entry *p
>  #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
>  #define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
> =20
> +static inline bool proc_is_tgid_procfd(const struct file *file)
> +{
> +	return false;
> +}
> +
> +static inline struct pid *proc_pid(const struct inode *inode)
> +{
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_PROC_FS */
> =20
>  struct net;
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 2ac3d13a915b..a5ca8cb84566 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -907,6 +907,8 @@ asmlinkage long sys_statx(int dfd, const char __user =
*path, unsigned flags,
>  			  unsigned mask, struct statx __user *buffer);
>  asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
>  			 int flags, uint32_t sig);
> +asmlinkage long sys_procfd_signal(int fd, int sig, siginfo_t __user *inf=
o,
> +				  int flags);
> =20
>  /*
>   * Architecture-specific system calls
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic=
/unistd.h
> index 538546edbfbd..4dc81a994ad1 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -738,9 +738,11 @@ __SYSCALL(__NR_statx,     sys_statx)
>  __SC_COMP(__NR_io_pgetevents, sys_io_pgetevents, compat_sys_io_pgetevent=
s)
>  #define __NR_rseq 293
>  __SYSCALL(__NR_rseq, sys_rseq)
> +#define __NR_procfd_signal 294
> +__SC_COMP(__NR_procfd_signal, sys_procfd_signal, compat_sys_procfd_signa=
l)
> =20
>  #undef __NR_syscalls
> -#define __NR_syscalls 294
> +#define __NR_syscalls 295
> =20
>  /*
>   * 32 bit systems traditionally used different
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 9a32bc2088c9..13695342f150 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -19,7 +19,9 @@
>  #include <linux/sched/task.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/sched/cputime.h>
> +#include <linux/file.h>
>  #include <linux/fs.h>
> +#include <linux/proc_fs.h>
>  #include <linux/tty.h>
>  #include <linux/binfmts.h>
>  #include <linux/coredump.h>
> @@ -3286,6 +3288,16 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sig=
set_t __user *, uthese,
>  }
>  #endif
> =20
> +static inline void prepare_kill_siginfo(int sig, struct kernel_siginfo *=
info)
> +{
> +	clear_siginfo(info);
> +	info->si_signo =3D sig;
> +	info->si_errno =3D 0;
> +	info->si_code =3D SI_USER;
> +	info->si_pid =3D task_tgid_vnr(current);
> +	info->si_uid =3D from_kuid_munged(current_user_ns(), current_uid());
> +}
> +
>  /**
>   *  sys_kill - send a signal to a process
>   *  @pid: the PID of the process
> @@ -3295,16 +3307,119 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
>  {
>  	struct kernel_siginfo info;
> =20
> -	clear_siginfo(&info);
> -	info.si_signo =3D sig;
> -	info.si_errno =3D 0;
> -	info.si_code =3D SI_USER;
> -	info.si_pid =3D task_tgid_vnr(current);
> -	info.si_uid =3D from_kuid_munged(current_user_ns(), current_uid());
> +	prepare_kill_siginfo(sig, &info);
> =20
>  	return kill_something_info(sig, &info, pid);
>  }
> =20
> +/*
> + * Verify that the signaler and signalee either are in the same pid name=
space
> + * or that the signaler's pid namespace is an ancestor of the signalee's=
 pid
> + * namespace.
> + */
> +static bool may_signal_procfd(struct pid *pid)
> +{
> +	struct pid_namespace *active =3D task_active_pid_ns(current);
> +	struct pid_namespace *p =3D ns_of_pid(pid);
> +
> +	for (;;) {
> +		if (!p)
> +			return false;
> +		if (p =3D=3D active)
> +			break;
> +		p =3D p->parent;
> +	}
> +
> +	return true;
> +}
> +
> +static int do_procfd_signal(int fd, int sig, kernel_siginfo_t *kinfo, in=
t flags,
> +			    bool had_siginfo)
> +{
> +	int ret;
> +	struct fd f;
> +	struct pid *pid;
> +
> +	/* Enforce flags be set to 0 until we add an extension. */
> +	if (flags)
> +		return -EINVAL;
> +
> +	f =3D fdget_raw(fd);
> +	if (!f.file)
> +		return -EBADF;
> +
> +	/* Is this a process file descriptor? */
> +	ret =3D -EINVAL;
> +	if (!proc_is_tgid_procfd(f.file))
> +		goto err;
> +
> +	/* Without CONFIG_PROC_FS proc_pid() returns NULL. */
> +	pid =3D proc_pid(file_inode(f.file));
> +	if (!pid)
> +		goto err;
> +
> +	if (!may_signal_procfd(pid))
> +		goto err;
> +
> +	if (had_siginfo) {
> +		/*
> +		 * Not even root can pretend to send signals from the kernel.
> +		 * Nor can they impersonate a kill()/tgkill(), which adds
> +		 * source info.
> +		 */
> +		ret =3D -EPERM;
> +		if ((kinfo->si_code >=3D 0 || kinfo->si_code =3D=3D SI_TKILL) &&
> +		    (task_pid(current) !=3D pid))
> +			goto err;
> +	} else {
> +		prepare_kill_siginfo(sig, kinfo);
> +	}
> +
> +	ret =3D kill_pid_info(sig, kinfo, pid);
> +
> +err:
> +	fdput(f);
> +	return ret;
> +}
> +
> +/**
> + *  sys_procfd_signal - send a signal to a process through a process file
> + *                      descriptor
> + *  @fd: the file descriptor of the process
> + *  @sig: signal to be sent
> + *  @info: the signal info
> + *  @flags: future flags to be passed
> + */
> +SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig, siginfo_t __user *, in=
fo,
> +		int, flags)
> +{
> +	kernel_siginfo_t kinfo;
> +
> +	if (info) {
> +		int ret =3D __copy_siginfo_from_user(sig, &kinfo, info);
> +		if (unlikely(ret))
> +			return ret;
> +	}
> +
> +	return do_procfd_signal(fd, sig, &kinfo, flags, !!info);
> +}
> +
> +#ifdef CONFIG_COMPAT
> +COMPAT_SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig,
> +		       struct compat_siginfo __user *, info, int, flags)
> +{
> +	kernel_siginfo_t kinfo;
> +
> +	if (info) {
> +		int ret =3D __copy_siginfo_from_user32(sig, &kinfo, info);
> +		if (unlikely(ret))
> +			return ret;
> +	}
> +
> +	return do_procfd_signal(fd, sig, &kinfo, flags, !!info);
> +}
> +#endif
> +
>  static int
>  do_send_specific(pid_t tgid, pid_t pid, int sig, struct kernel_siginfo *=
info)
>  {
> --=20
> 2.19.1
>=20


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--3jh4s5fbhujkntjl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlv2Z2QACgkQSnvnv3De
m59ciBAAgMOAiK15+FqhLQCZ84Ds/QGRcwd39fErbsULQroK4R9tzZjd9t+l2nGd
0/VgUpcXRqrTVIRm3TeVrhkx8OOGdplB+TfjsQiGwIf1z5ErytswssLeGS5uXLLL
/mVV+BuyWkbQb+8xtNzOXiqabQkA2KwGfDIxfjavGc0GpgSy5tsc7HS/qaxi8kbT
Dy7lsfwc+kyGrFtg5vs08Q4MtjbrCXvVBkoyo2GNEH4wykbKhp60/a8jajUtPNQ2
gzvXLJFXYiNhIiGbM8eqFHofa5WRUL8BT+WJjWW3jSPx39oz3kxpAnDTsBLhqr6Q
YglwjjxnRV4Lkhn8jAszw+Ja3eZUEgLWJIOgyTgp5wj56NdN/RJiHPMegQGRyyTM
AR9fUYkFZkW/wlA+JqNyI7FQv3EFjTxOPRCYksCUqmGbNEaiaPPpYQKjNbh27Au5
4wWLznOBfdiBC69WJM98P878QRb9J5EJwvWYTJ3GCEV3jDmIHdVcuJDPBdvKmkW6
HQJ20ZnZpNlJsXy3VPv02IF0jmq2O2w3KJHsviryshWV6anWy7NoDAaMwcN3lgco
aELXgups60y9sE7hmWV6cTwx4n04jFpAlbrY47c9YeeocorkqIxtp2wTOUL0fTR0
yJumiXjW+Yh8C6BHcfCBq22shIBPXL+HoX7YjSOfga7f7dlVuCE=
=GPqB
-----END PGP SIGNATURE-----

--3jh4s5fbhujkntjl--
