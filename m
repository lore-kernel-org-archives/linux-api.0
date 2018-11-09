From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v6] pidns: introduce syscall translate_pid
Date: Fri, 9 Nov 2018 06:49:19 +0300
Message-ID: <20181109034919.GA21681@altlinux.org>
References: <152788068212.768348.15192457501079586650.stgit@buzz>
 <db8d560e-47d1-c32f-e4a2-407110f2b5b6@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <db8d560e-47d1-c32f-e4a2-407110f2b5b6@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Prakash Sangappa <prakash.sangappa@oracle.com>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 16, 2018 at 10:57:48AM -0700, Nagarathnam Muthusamy wrote:
> On 06/01/2018 12:18 PM, Konstantin Khlebnikov wrote:
> > Each process have different pids, one for each pid namespace it belongs.
> > When interaction happens within single pid-ns translation isn't require=
d.
> > More complicated scenarios needs special handling.
> >
> > For example:
> > - reading pid-files or logs written inside container with pid namespace
> > - writing logs with internal pids outside container for pushing them in=
to
> > - attaching with ptrace to tasks from different pid namespace
> >
> > Generally speaking, any cross pid-ns API with pids needs translation.
> >
> > Currently there are several interfaces that could be used here:
> >
> > Pid namespaces are identified by device and inode of /proc/[pid]/ns/pid.
> >
> > Pids for nested pid namespaces are shown in file /proc/[pid]/status.
> > In some cases pid translation could be easily done using this informati=
on.
> > Backward translation requires scanning all tasks and becomes really
> > complicated for deeper namespace nesting.
> >
> > Unix socket automatically translates pid attached to SCM_CREDENTIALS.
> > This requires CAP_SYS_ADMIN for sending arbitrary pids and entering
> > into pid namespace, this expose process and could be insecure.
> >
> > This patch adds new syscall for converting pids between pid namespaces:
> >
> > pid_t translate_pid(pid_t pid, int source, int target);
> >
> > Pid-namespaces are referred file descriptors opened to proc files
> > /proc/[pid]/ns/pid or /proc/[pid]/ns/pid_for_children.
> > Negative argument points to current pid namespace.
> >
> > Syscall returns pid in target pid-ns or zero if task have no pid there.
> >
> > Error codes:
> > EBADF    - file descriptor is closed
> > EINVAL   - file descriptor isn't pid namespace
> > ESRCH    - task not found in @source namespace
> >
> > Translation could breach pid-ns isolation and return pids from outer pid
> > namespaces iff process already has file descriptor for these namespaces.
> >
> > Examples:
> > translate_pid(pid, ns, -1)      - get pid in our pid namespace
> > translate_pid(pid, -1, ns)      - get pid in other pid namespace
> > translate_pid(1, ns, -1)        - get pid of init task for namespace
> > translate_pid(pid, -1, ns) > 0  - is pid is reachable from ns?
> > translate_pid(1, ns1, ns2) > 0  - is ns1 inside ns2?
> > translate_pid(1, ns1, ns2) =3D=3D 0 - is ns1 outside ns2?
> > translate_pid(1, ns1, ns2) =3D=3D 1 - is ns1 equal ns2?
> >
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > Reanimated-by: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
> >
> > ---
> >
> > v1: https://lkml.org/lkml/2015/9/15/411
> > v2: https://lkml.org/lkml/2015/9/24/278
> >   * use namespace-fd as second/third argument
> >   * add -pid for getting parent pid
> >   * move code into kernel/sys.c next to getppid
> >   * drop ifdef CONFIG_PID_NS
> >   * add generic syscall
> > v3: https://lkml.org/lkml/2015/9/28/3
> >   * use proc_ns_fdget()
> >   * update description
> >   * rebase to next-20150925
> >   * fix conflict with mlock2
> > v4: https://lkml.org/lkml/2017/10/13/177
> >   * rename from getvpid() into translate_pid()
> >   * remove syscall if CONFIG_PID_NS=3Dn
> >   * drop -pid for parent task
> >   * drop fget-fdget optimizations
> >   * add helper get_pid_ns_by_fd()
> >   * wire only into x86
> > v5: https://lkml.org/lkml/2018/4/4/677
> >   * rewrite commit message
> >   * resolve pidns by task pid or by pidns fd
> >   * add arguments source_type and target_type
> > v6:
> >   * revert back minimized v4 design
> >   * rebase to next-20180601
> >   * fix COND_SYSCALL stub
> >   * use next syscall number, old used for io_pgetevents
> >
> > --- sample tool ---
> >
> > #define _GNU_SOURCE
> > #include <sys/syscall.h>
> > #include <sys/types.h>
> > #include <fcntl.h>
> > #include <unistd.h>
> > #include <stdlib.h>
> > #include <stdio.h>
> > #include <err.h>
> >
> > #ifndef SYS_translate_pid
> > #ifdef __x86_64__
> > #define SYS_translate_pid 334
> > #elif defined __i386__
> > #define SYS_translate_pid 386
> > #endif
> > #endif
> >
> > pid_t translate_pid(pid_t pid, int source, int target) {
> > 	return syscall(SYS_translate_pid, pid, source, target);
> > }
> >
> > int main(int argc, char **argv) {
> > 	int pid, source, target;
> > 	char buf[64];
> >
> > 	if (argc !=3D 4)
> > 		errx(1, "usage: %s <pid> <source> <target>", argv[0]);
> >
> > 	pid =3D atoi(argv[1]);
> > 	source =3D atoi(argv[2]);
> > 	target =3D atoi(argv[3]);
> >
> > 	if (source > 0) {
> > 		snprintf(buf, sizeof(buf), "/proc/%d/ns/pid", source);
> > 		source =3D open(buf, O_RDONLY);
> > 		if (source < 0)
> > 			err(2, "open source %s", buf);
> > 	}
> >
> > 	if (target > 0) {
> > 		snprintf(buf, sizeof(buf), "/proc/%d/ns/pid", target);
> > 		target =3D open(buf, O_RDONLY);
> > 		if (target < 0)
> > 			err(2, "open target %s", buf);
> > 	}
> >
> > 	pid =3D translate_pid(pid, source, target);
> > 	if (pid < 0)
> > 		err(2, "translate_pid");
> >
> > 	printf("%d\n", pid);
> > 	return 0;
> > }
> >
> > ---
> > ---
> >   arch/x86/entry/syscalls/syscall_32.tbl |    1
> >   arch/x86/entry/syscalls/syscall_64.tbl |    1
> >   include/linux/syscalls.h               |    1
> >   kernel/pid_namespace.c                 |   66 +++++++++++++++++++++++=
+++++++++
> >   kernel/sys_ni.c                        |    3 +
> >   5 files changed, 72 insertions(+)
> >
> > diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/sy=
scalls/syscall_32.tbl
> > index 14a2f996e543..e70685750d43 100644
> > --- a/arch/x86/entry/syscalls/syscall_32.tbl
> > +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> > @@ -397,3 +397,4 @@
> >   383	i386	statx			sys_statx			__ia32_sys_statx
> >   384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
> >   385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgete=
vents
> > +386	i386	translate_pid		sys_translate_pid		__ia32_sys_translate_pid
> > diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/sy=
scalls/syscall_64.tbl
> > index cd36232ab62f..ebfd89055424 100644
> > --- a/arch/x86/entry/syscalls/syscall_64.tbl
> > +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> > @@ -342,6 +342,7 @@
> >   331	common	pkey_free		__x64_sys_pkey_free
> >   332	common	statx			__x64_sys_statx
> >   333	common	io_pgetevents		__x64_sys_io_pgetevents
> > +334	common	translate_pid		__x64_sys_translate_pid
> >  =20
> >   #
> >   # x32-specific system call numbers start at 512 to avoid cache impact
> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > index 390e814fdc8d..3f33971cf1c8 100644
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -843,6 +843,7 @@ asmlinkage long sys_clock_adjtime(clockid_t which_c=
lock,
> >   				struct timex __user *tx);
> >   asmlinkage long sys_syncfs(int fd);
> >   asmlinkage long sys_setns(int fd, int nstype);
> > +asmlinkage long sys_translate_pid(pid_t pid, int source, int target);
> >   asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
> >   			     unsigned int vlen, unsigned flags);
> >   asmlinkage long sys_process_vm_readv(pid_t pid,
> > diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> > index 2a2ac53d8b8b..3b872cbbe264 100644
> > --- a/kernel/pid_namespace.c
> > +++ b/kernel/pid_namespace.c
> > @@ -13,6 +13,7 @@
> >   #include <linux/user_namespace.h>
> >   #include <linux/syscalls.h>
> >   #include <linux/cred.h>
> > +#include <linux/file.h>
> >   #include <linux/err.h>
> >   #include <linux/acct.h>
> >   #include <linux/slab.h>
> > @@ -380,6 +381,71 @@ static void pidns_put(struct ns_common *ns)
> >   	put_pid_ns(to_pid_ns(ns));
> >   }
> >  =20
> > +static struct pid_namespace *get_pid_ns_by_fd(int fd)
> > +{
> > +	struct pid_namespace *pidns;
> > +	struct ns_common *ns;
> > +	struct file *file;
> > +
> > +	file =3D proc_ns_fget(fd);
> > +	if (IS_ERR(file))
> > +		return ERR_CAST(file);
> > +
> > +	ns =3D get_proc_ns(file_inode(file));
> > +	if (ns->ops->type =3D=3D CLONE_NEWPID)
> > +		pidns =3D get_pid_ns(to_pid_ns(ns));
> > +	else
> > +		pidns =3D ERR_PTR(-EINVAL);
> > +
> > +	fput(file);
> > +	return pidns;
> > +}
> > +
> > +/*
> > + * translate_pid - convert pid in source pid-ns into target pid-ns.
> > + * @pid:    pid for translation
> > + * @source: pid-ns file descriptor or -1 for active namespace
> > + * @target: pid-ns file descriptor or -1 for active namesapce
> > + *
> > + * Returns pid in @target pid-ns, zero if task have no pid there,
> > + * or -ESRCH if task with @pid does not found in @source pid-ns.
> > + */
> > +SYSCALL_DEFINE3(translate_pid, pid_t, pid, int, source, int, target)
> > +{
> > +	struct pid_namespace *source_ns, *target_ns;
> > +	struct pid *struct_pid;
> > +	pid_t result;
> > +
> > +	if (source >=3D 0) {
> > +		source_ns =3D get_pid_ns_by_fd(source);
> > +		result =3D PTR_ERR(source_ns);
> > +		if (IS_ERR(source_ns))
> > +			goto err_source;
> > +	} else
> > +		source_ns =3D task_active_pid_ns(current);
> > +
> > +	if (target >=3D 0) {
> > +		target_ns =3D get_pid_ns_by_fd(target);
> > +		result =3D PTR_ERR(target_ns);
> > +		if (IS_ERR(target_ns))
> > +			goto err_target;
> > +	} else
> > +		target_ns =3D task_active_pid_ns(current);
> > +
> > +	rcu_read_lock();
> > +	struct_pid =3D find_pid_ns(pid, source_ns);
> > +	result =3D struct_pid ? pid_nr_ns(struct_pid, target_ns) : -ESRCH;
> > +	rcu_read_unlock();
> > +
> > +	if (target >=3D 0)
> > +		put_pid_ns(target_ns);
> > +err_target:
> > +	if (source >=3D 0)
> > +		put_pid_ns(source_ns);
> > +err_source:
> > +	return result;
> > +}
> > +
> >   static int pidns_install(struct nsproxy *nsproxy, struct ns_common *n=
s)
> >   {
> >   	struct pid_namespace *active =3D task_active_pid_ns(current);
> > diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> > index 06b4ccee0047..bf276e9ace9a 100644
> > --- a/kernel/sys_ni.c
> > +++ b/kernel/sys_ni.c
> > @@ -153,6 +153,9 @@ COND_SYSCALL_COMPAT(kexec_load);
> >   COND_SYSCALL(init_module);
> >   COND_SYSCALL(delete_module);
> >  =20
> > +/* kernel/pid_namespace.c */
> > +COND_SYSCALL(translate_pid);
> > +
> >   /* kernel/posix-timers.c */
> >  =20
> >   /* kernel/printk.c */
> >
>=20
> Ping :-) Checking back again for Ack or comments.

JFYI, I'll try to attract more attention to this proposal
by mentioning it in my talk at the LPC 2018 as a potential solution
for one of several problems we have in strace, see
https://www.linuxplumbersconf.org/event/2/contributions/78/


--=20
ldv

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb5QO/AAoJEAVFT+BVnCUIbhsP/Rb3dXmc0O3oZ08GSipPJOf9
wSBxAg6nz0pCHw45dI/N0sC0REvn3LyB7ERRB40RKvcnSBTQJoqK8o85uitFARJz
TyzDm8vvczgb5SQp893qR8QER/622hZrqh1qNCCyCGy+G+B/tYltcDzh4DbqIjk/
2gUP5N6m/LdRvc35XzNw24BXlWouez73KjJIZtsZiXZrDSahYvTC60DqEv+I3fb9
Z6h//N14WvpWQU1dRL7dOZJEDnGkem6D7cbzb1yJWBrjF+mEr/Ufnoi/xkuySjtU
iqJCE/BoKUkIv94fY0rCABv+qylTAqiYj11OLvDfOhZRWZkhAUR2iMDowhTyGd7x
2Vt+gQVJNymn0VKFbAN8pW+/uq326uYwnWypQ0Ap8TFrFoOflOZEt0+amtOli+kc
fwv+yLbrFjsqzw0dP2Dwe6nnAGopE5q4Xs/ncVsvx/2ldeUOPAt3bHjvu9WNCOIw
sDw1xX7vwzfiUrowRJIDgKJH3wR2bL3kUqzGgyIJOvQrKniVfxw5QnEbJPF2P0tM
X3MXxZpzSTwUPlXKERIMxP2sOXhUWWtzcI0S8POzIbzXnqngBfySdorzkDGM2Vo8
a9HZfPETYYu0pkjmtbxaeqTQFp8GjbSf6AOYkYoQfY+051bBAZyXwX9481kPIX23
ChgZr+nKlceBXTr+2LRo
=jDif
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
