From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Fri, 07 Dec 2018 06:14:34 +1300
Message-ID: <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io>
References: <20181206121858.12215-1-christian@brauner.io> <87sgzahf7k.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87sgzahf7k.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On December 7, 2018 4:01:19 AM GMT+13:00, ebiederm@xmission=2Ecom wrote:
>Christian Brauner <christian@brauner=2Eio> writes:
>
>> The kill() syscall operates on process identifiers (pid)=2E After a
>process
>> has exited its pid can be reused by another process=2E If a caller
>sends a
>> signal to a reused pid it will end up signaling the wrong process=2E
>This
>> issue has often surfaced and there has been a push [1] to address
>this
>> problem=2E
>>
>> This patch uses file descriptors (fd) from proc/<pid> as stable
>handles on
>> struct pid=2E Even if a pid is recycled the handle will not change=2E T=
he
>fd
>> can be used to send signals to the process it refers to=2E
>> Thus, the new syscall taskfd_send_signal() is introduced to solve
>this
>> problem=2E Instead of pids it operates on process fds (taskfd)=2E
>
>I am not yet thrilled with the taskfd naming=2E

Userspace cares about what does this thing operate on?
It operates on processes and threads=2E
The most common term people use is "task"=2E
I literally "polled" ten non-kernel people for that purpose and asked:
"What term would you use to refer to a process and a thread?"
Turns out it is task=2E So if find this pretty apt=2E
Additionally, the proc manpage uses task in the exact same way (also see t=
he commit message)=2E
If you can get behind that name even if feeling it's not optimal it would =
be great=2E

>Is there any plan to support sesssions and process groups?

I don't see the necessity=2E
As I said in previous mails:
we can emulate all interesting signal syscalls with this one=2E
We succeeded in doing that=2E
No need to get more fancy=2E
There's currently no obvious need for more features=2E
Features should be implemented when someone actually needs them=2E

>
>I am concerned about using kill_pid_info=2E  It does this:
>
>
>	rcu_read_lock();
>	p =3D pid_task(pid, PIDTYPE_PID);
>	if (p)
>		error =3D group_send_sig_info(sig, info, p, PIDTYPE_TGID);
>	rcu_read_unlock();
>
>That pid_task(PIDTYPE_PID) is fine for existing callers that need bug
>compatibility=2E  For new interfaces I would strongly prefer
>pid_task(PIDTYPE_TGID)=2E
>
>
>Eric
>
>>
>> /* prototype and argument /*
>> long taskfd_send_signal(int taskfd, int sig, siginfo_t *info,
>unsigned int flags);
>>
>> In addition to the taskfd and signal argument it takes an additional
>> siginfo_t and flags argument=2E If the siginfo_t argument is NULL then
>> taskfd_send_signal() behaves like kill()=2E If it is not NULL
>> taskfd_send_signal() behaves like rt_sigqueueinfo()=2E
>> The flags argument is added to allow for future extensions of this
>syscall=2E
>> It currently needs to be passed as 0=2E Failing to do so will cause
>EINVAL=2E
>>
>> /* taskfd_send_signal() replaces multiple pid-based syscalls */
>> The taskfd_send_signal() syscall currently takes on the job of the
>> following syscalls that operate on pids:
>> - kill(2)
>> - rt_sigqueueinfo(2)
>> The syscall is defined in such a way that it can also operate on
>thread fds
>> instead of process fds=2E In a future patchset I will extend it to
>operate on
>> taskfds from /proc/<pid>/task/<tid> at which point it will
>additionally
>> take on the job of:
>> - tgkill(2)
>> - rt_tgsigqueueinfo(2)
>> Right now this is intentionally left out to keep this patchset as
>simple as
>> possible (cf=2E [4])=2E If a taskfd of /proc/<pid>/task/<tid> is passed
>> EOPNOTSUPP will be returned to give userspace a way to detect when I
>add
>> support for such taskfds (cf=2E [10])=2E
>>
>> /* naming */
>> The original prefix of the syscall was "procfd_"=2E However, it has
>been
>> pointed out that since this syscall will eventually operate on both
>> processes and threads the name should reflect this (cf=2E [12])=2E The
>best
>> possible candidate even from a userspace perspective seems to be
>"task"=2E
>> Although "task" is used internally we are alreday deviating from
>POSIX by
>> using file descriptors to processes in the first place so it seems
>fine to
>> use the "taskfd_" prefix=2E
>>
>> The name taskfd_send_signal() was also chosen to reflect the fact
>that it
>> takes on the job of multiple syscalls=2E It is intentional that the
>name is
>> not reminiscent of neither kill(2) nor rt_sigqueueinfo(2)=2E Not the
>fomer
>> because it might imply that taskfd_send_signal() is only a
>replacement for
>> kill(2) and not the latter because it is a hazzle to remember the
>correct
>> spelling (especially for non-native speakers) and because it is not
>> descriptive enough of what the syscall actually does=2E The name
>> "taskfd_send_signal" makes it very clear that its job is to send
>signals=2E
>>
>> /* O_PATH file descriptors */
>> taskfds opened as O_PATH fds cannot be used to send signals to a
>process
>> (cf=2E [2])=2E Signaling processes through taskfds is the equivalent of
>writing
>> to a file=2E Thus, this is not an operation that operates "purely at
>the
>> file descriptor level" as required by the open(2) manpage=2E
>>
>> /* zombies */
>> Zombies can be signaled just as any other process=2E No special error
>will be
>> reported since a zombie state is an unreliable state (cf=2E [3])=2E
>>
>> /* cross-namespace signals */
>> The patch currently enforces that the signaler and signalee either
>are in
>> the same pid namespace or that the signaler's pid namespace is an
>ancestor
>> of the signalee's pid namespace=2E This is done for the sake of
>simplicity
>> and because it is unclear to what values certain members of struct
>> siginfo_t would need to be set to (cf=2E [5], [6])=2E
>>
>> /* compat syscalls */
>> It became clear that we would like to avoid adding compat syscalls
>(cf=2E
>> [7])=2E The compat syscall handling is now done in kernel/signal=2Ec
>itself by
>> adding __copy_siginfo_from_user_generic() which lets us avoid compat
>> syscalls (cf=2E [8])=2E It should be noted that the addition of
>> __copy_siginfo_from_user_any() is caused by a bug in the original
>> implementation of rt_sigqueueinfo(2) (cf=2E 12)=2E
>> With upcoming rework for syscall handling things might improve
>> significantly (cf=2E [11]) and __copy_siginfo_from_user_any() will not
>gain
>> any additional callers=2E
>>
>> /* testing */
>> This patch was tested on x64 and x86=2E
>>
>> /* userspace usage */
>> An asciinema recording for the basic functionality can be found under
>[9]=2E
>> With this patch a process can be killed via:
>>
>>  #define _GNU_SOURCE
>>  #include <errno=2Eh>
>>  #include <fcntl=2Eh>
>>  #include <signal=2Eh>
>>  #include <stdio=2Eh>
>>  #include <stdlib=2Eh>
>>  #include <string=2Eh>
>>  #include <sys/stat=2Eh>
>>  #include <sys/syscall=2Eh>
>>  #include <sys/types=2Eh>
>>  #include <unistd=2Eh>
>>
>>  static inline int do_taskfd_send_signal(int taskfd, int sig,
>siginfo_t *info,
>>                                          unsigned int flags)
>>  {
>>  #ifdef __NR_taskfd_send_signal
>>          return syscall(__NR_taskfd_send_signal, taskfd, sig, info,
>flags);
>>  #else
>>          return -ENOSYS;
>>  #endif
>>  }
>>
>>  int main(int argc, char *argv[])
>>  {
>>          int fd, ret, saved_errno, sig;
>>
>>          if (argc < 3)
>>                  exit(EXIT_FAILURE);
>>
>>          fd =3D open(argv[1], O_DIRECTORY | O_CLOEXEC);
>>          if (fd < 0) {
>>                  printf("%s - Failed to open \"%s\"\n",
>strerror(errno), argv[1]);
>>                  exit(EXIT_FAILURE);
>>          }
>>
>>          sig =3D atoi(argv[2]);
>>
>>          printf("Sending signal %d to process %s\n", sig, argv[1]);
>>          ret =3D do_taskfd_send_signal(fd, sig, NULL, 0);
>>
>>          saved_errno =3D errno;
>>          close(fd);
>>          errno =3D saved_errno;
>>
>>          if (ret < 0) {
>>                  printf("%s - Failed to send signal %d to process
>%s\n",
>>                         strerror(errno), sig, argv[1]);
>>                  exit(EXIT_FAILURE);
>>          }
>>
>>          exit(EXIT_SUCCESS);
>>  }
>>
>> [1]:=20
>https://lore=2Ekernel=2Eorg/lkml/20181029221037=2E87724-1-dancol@google=
=2Ecom/
>> [2]:=20
>https://lore=2Ekernel=2Eorg/lkml/874lbtjvtd=2Efsf@oldenburg2=2Estr=2Eredh=
at=2Ecom/
>> [3]:=20
>https://lore=2Ekernel=2Eorg/lkml/20181204132604=2Easpfupwjgjx6fhva@braune=
r=2Eio/
>> [4]:=20
>https://lore=2Ekernel=2Eorg/lkml/20181203180224=2Efkvw4kajtbvru2ku@braune=
r=2Eio/
>> [5]:=20
>https://lore=2Ekernel=2Eorg/lkml/20181121213946=2EGA10795@mail=2Ehallyn=
=2Ecom/
>> [6]:=20
>https://lore=2Ekernel=2Eorg/lkml/20181120103111=2Eetlqp7zop34v6nv4@braune=
r=2Eio/
>> [7]:=20
>https://lore=2Ekernel=2Eorg/lkml/36323361-90BD-41AF-AB5B-EE0D7BA02C21@ama=
capital=2Enet/
>> [8]:  https://lore=2Ekernel=2Eorg/lkml/87tvjxp8pc=2Efsf@xmission=2Ecom/
>> [9]:  https://asciinema=2Eorg/a/IQjuCHew6bnq1cr78yuMv16cy
>> [10]:
>https://lore=2Ekernel=2Eorg/lkml/20181203180224=2Efkvw4kajtbvru2ku@braune=
r=2Eio/
>> [11]:
>https://lore=2Ekernel=2Eorg/lkml/F53D6D38-3521-4C20-9034-5AF447DF62FF@ama=
capital=2Enet/
>> [12]: https://lore=2Ekernel=2Eorg/lkml/87zhtjn8ck=2Efsf@xmission=2Ecom/
>>
>> Cc: Arnd Bergmann <arnd@arndb=2Ede>
>> Cc: "Eric W=2E Biederman" <ebiederm@xmission=2Ecom>
>> Cc: Serge Hallyn <serge@hallyn=2Ecom>
>> Cc: Jann Horn <jannh@google=2Ecom>
>> Cc: Andy Lutomirsky <luto@kernel=2Eorg>
>> Cc: Andrew Morton <akpm@linux-foundation=2Eorg>
>> Cc: Oleg Nesterov <oleg@redhat=2Ecom>
>> Cc: Aleksa Sarai <cyphar@cyphar=2Ecom>
>> Cc: Al Viro <viro@zeniv=2Elinux=2Eorg=2Euk>
>> Cc: Florian Weimer <fweimer@redhat=2Ecom>
>> Signed-off-by: Christian Brauner <christian@brauner=2Eio>
>> Reviewed-by: Kees Cook <keescook@chromium=2Eorg>
>> ---
>> Changelog:
>> v4:
>> - updated asciinema to use "taskfd_" prefix
>> - s/procfd_send_signal/taskfd_send_signal/g
>> - s/proc_is_tgid_procfd/tgid_taskfd_to_pid/b
>> - s/proc_is_tid_procfd/tid_taskfd_to_pid/b
>> - s/__copy_siginfo_from_user_generic/__copy_siginfo_from_user_any/g
>> - make it clear that __copy_siginfo_from_user_any() is a workaround
>caused
>>   by a bug in the original implementation of rt_sigqueueinfo()
>> - when spoofing signals turn them into regular kill signals if
>si_code is
>>   set to SI_USER
>> - make proc_is_t{g}id_procfd() return struct pid to allow proc_pid()
>to
>>   stay private to fs/proc/
>> v3:
>> - add __copy_siginfo_from_user_generic() to avoid adding compat
>syscalls
>> - s/procfd_signal/procfd_send_signal/g
>> - change type of flags argument from int to unsigned int
>> - add comment about what happens to zombies
>> - add proc_is_tid_procfd()
>> - return EOPNOTSUPP when /proc/<pid>/task/<tid> fd is passed so
>userspace
>>   has a way of knowing that tidfds are not supported currently=2E
>> v2:
>> - define __NR_procfd_signal in unistd=2Eh
>> - wire up compat syscall
>> - s/proc_is_procfd/proc_is_tgid_procfd/g
>> - provide stubs when CONFIG_PROC_FS=3Dn
>> - move proc_pid() to linux/proc_fs=2Eh header
>> - use proc_pid() to grab struct pid from /proc/<pid> fd
>> v1:
>> - patch introduced
>> ---
>>  arch/x86/entry/syscalls/syscall_32=2Etbl |   1 +
>>  arch/x86/entry/syscalls/syscall_64=2Etbl |   1 +
>>  fs/proc/base=2Ec                         |  20 +++-
>>  include/linux/proc_fs=2Eh                |  12 +++
>>  include/linux/syscalls=2Eh               |   3 +
>>  include/uapi/asm-generic/unistd=2Eh      |   4 +-
>>  kernel/signal=2Ec                        | 132
>+++++++++++++++++++++++--
>>  7 files changed, 164 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/entry/syscalls/syscall_32=2Etbl
>b/arch/x86/entry/syscalls/syscall_32=2Etbl
>> index 3cf7b533b3d1=2E=2E7efb63fd0617 100644
>> --- a/arch/x86/entry/syscalls/syscall_32=2Etbl
>> +++ b/arch/x86/entry/syscalls/syscall_32=2Etbl
>> @@ -398,3 +398,4 @@
>>  384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
>>=20
>385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevent=
s
>>  386	i386	rseq			sys_rseq			__ia32_sys_rseq
>>
>+387	i386	taskfd_send_signal	sys_taskfd_send_signal		__ia32_sys_taskfd_se=
nd_signal
>> diff --git a/arch/x86/entry/syscalls/syscall_64=2Etbl
>b/arch/x86/entry/syscalls/syscall_64=2Etbl
>> index f0b1709a5ffb=2E=2Ebe894f4a84e9 100644
>> --- a/arch/x86/entry/syscalls/syscall_64=2Etbl
>> +++ b/arch/x86/entry/syscalls/syscall_64=2Etbl
>> @@ -343,6 +343,7 @@
>>  332	common	statx			__x64_sys_statx
>>  333	common	io_pgetevents		__x64_sys_io_pgetevents
>>  334	common	rseq			__x64_sys_rseq
>> +335	common	taskfd_send_signal	__x64_sys_taskfd_send_signal
>> =20
>>  #
>>  # x32-specific system call numbers start at 512 to avoid cache
>impact
>> diff --git a/fs/proc/base=2Ec b/fs/proc/base=2Ec
>> index ce3465479447=2E=2Eb8b88bfee455 100644
>> --- a/fs/proc/base=2Ec
>> +++ b/fs/proc/base=2Ec
>> @@ -716,8 +716,6 @@ static int proc_pid_permission(struct inode
>*inode, int mask)
>>  	return generic_permission(inode, mask);
>>  }
>> =20
>> -
>> -
>>  static const struct inode_operations proc_def_inode_operations =3D {
>>  	=2Esetattr	=3D proc_setattr,
>>  };
>> @@ -3038,6 +3036,15 @@ static const struct file_operations
>proc_tgid_base_operations =3D {
>>  	=2Ellseek		=3D generic_file_llseek,
>>  };
>> =20
>> +struct pid *tgid_taskfd_to_pid(const struct file *file)
>> +{
>> +	if (!d_is_dir(file->f_path=2Edentry) ||
>> +	    (file->f_op !=3D &proc_tgid_base_operations))
>> +		return ERR_PTR(-EBADF);
>> +
>> +	return proc_pid(file_inode(file));
>> +}
>> +
>>  static struct dentry *proc_tgid_base_lookup(struct inode *dir,
>struct dentry *dentry, unsigned int flags)
>>  {
>>  	return proc_pident_lookup(dir, dentry,
>> @@ -3422,6 +3429,15 @@ static const struct file_operations
>proc_tid_base_operations =3D {
>>  	=2Ellseek		=3D generic_file_llseek,
>>  };
>> =20
>> +struct pid *tid_taskfd_to_pid(const struct file *file)
>> +{
>> +	if (!d_is_dir(file->f_path=2Edentry) ||
>> +	    (file->f_op !=3D &proc_tid_base_operations))
>> +		return ERR_PTR(-EBADF);
>> +
>> +	return proc_pid(file_inode(file));
>> +}
>> +
>>  static const struct inode_operations proc_tid_base_inode_operations
>=3D {
>>  	=2Elookup		=3D proc_tid_base_lookup,
>>  	=2Egetattr	=3D pid_getattr,
>> diff --git a/include/linux/proc_fs=2Eh b/include/linux/proc_fs=2Eh
>> index d0e1f1522a78=2E=2E96817415c420 100644
>> --- a/include/linux/proc_fs=2Eh
>> +++ b/include/linux/proc_fs=2Eh
>> @@ -73,6 +73,8 @@ struct proc_dir_entry
>*proc_create_net_single_write(const char *name, umode_t mo
>>  						    int (*show)(struct seq_file *, void *),
>>  						    proc_write_t write,
>>  						    void *data);
>> +extern struct pid *tgid_taskfd_to_pid(const struct file *file);
>> +extern struct pid *tid_taskfd_to_pid(const struct file *file);
>> =20
>>  #else /* CONFIG_PROC_FS */
>> =20
>> @@ -114,6 +116,16 @@ static inline int remove_proc_subtree(const char
>*name, struct proc_dir_entry *p
>>  #define proc_create_net(name, mode, parent, state_size, ops)
>({NULL;})
>>  #define proc_create_net_single(name, mode, parent, show, data)
>({NULL;})
>> =20
>> +static inline struct pid *tgid_taskfd_to_pid(const struct file
>*file)
>> +{
>> +	return ERR_PTR(-EBADF);
>> +}
>> +
>> +static inline struct pid *tid_taskfd_to_pid(const struct file *file)
>> +{
>> +	return ERR_PTR(-EBADF);
>> +}
>> +
>>  #endif /* CONFIG_PROC_FS */
>> =20
>>  struct net;
>> diff --git a/include/linux/syscalls=2Eh b/include/linux/syscalls=2Eh
>> index 2ac3d13a915b=2E=2E5ffe194ef29b 100644
>> --- a/include/linux/syscalls=2Eh
>> +++ b/include/linux/syscalls=2Eh
>> @@ -907,6 +907,9 @@ asmlinkage long sys_statx(int dfd, const char
>__user *path, unsigned flags,
>>  			  unsigned mask, struct statx __user *buffer);
>>  asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t
>rseq_len,
>>  			 int flags, uint32_t sig);
>> +asmlinkage long sys_taskfd_send_signal(int taskfd, int sig,
>> +				       siginfo_t __user *info,
>> +				       unsigned int flags);
>> =20
>>  /*
>>   * Architecture-specific system calls
>> diff --git a/include/uapi/asm-generic/unistd=2Eh
>b/include/uapi/asm-generic/unistd=2Eh
>> index 538546edbfbd=2E=2E9343dca63fd9 100644
>> --- a/include/uapi/asm-generic/unistd=2Eh
>> +++ b/include/uapi/asm-generic/unistd=2Eh
>> @@ -738,9 +738,11 @@ __SYSCALL(__NR_statx,     sys_statx)
>>  __SC_COMP(__NR_io_pgetevents, sys_io_pgetevents,
>compat_sys_io_pgetevents)
>>  #define __NR_rseq 293
>>  __SYSCALL(__NR_rseq, sys_rseq)
>> +#define __NR_taskfd_send_signal 294
>> +__SYSCALL(__NR_taskfd_send_signal, sys_taskfd_send_signal)
>> =20
>>  #undef __NR_syscalls
>> -#define __NR_syscalls 294
>> +#define __NR_syscalls 295
>> =20
>>  /*
>>   * 32 bit systems traditionally used different
>> diff --git a/kernel/signal=2Ec b/kernel/signal=2Ec
>> index 9a32bc2088c9=2E=2Ea00a4bcb7605 100644
>> --- a/kernel/signal=2Ec
>> +++ b/kernel/signal=2Ec
>> @@ -19,7 +19,9 @@
>>  #include <linux/sched/task=2Eh>
>>  #include <linux/sched/task_stack=2Eh>
>>  #include <linux/sched/cputime=2Eh>
>> +#include <linux/file=2Eh>
>>  #include <linux/fs=2Eh>
>> +#include <linux/proc_fs=2Eh>
>>  #include <linux/tty=2Eh>
>>  #include <linux/binfmts=2Eh>
>>  #include <linux/coredump=2Eh>
>> @@ -3286,6 +3288,16 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait,
>compat_sigset_t __user *, uthese,
>>  }
>>  #endif
>> =20
>> +static inline void prepare_kill_siginfo(int sig, struct
>kernel_siginfo *info)
>> +{
>> +	clear_siginfo(info);
>> +	info->si_signo =3D sig;
>> +	info->si_errno =3D 0;
>> +	info->si_code =3D SI_USER;
>> +	info->si_pid =3D task_tgid_vnr(current);
>> +	info->si_uid =3D from_kuid_munged(current_user_ns(), current_uid());
>> +}
>> +
>>  /**
>>   *  sys_kill - send a signal to a process
>>   *  @pid: the PID of the process
>> @@ -3295,16 +3307,124 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
>>  {
>>  	struct kernel_siginfo info;
>> =20
>> -	clear_siginfo(&info);
>> -	info=2Esi_signo =3D sig;
>> -	info=2Esi_errno =3D 0;
>> -	info=2Esi_code =3D SI_USER;
>> -	info=2Esi_pid =3D task_tgid_vnr(current);
>> -	info=2Esi_uid =3D from_kuid_munged(current_user_ns(), current_uid());
>> +	prepare_kill_siginfo(sig, &info);
>> =20
>>  	return kill_something_info(sig, &info, pid);
>>  }
>> =20
>> +/*
>> + * Verify that the signaler and signalee either are in the same pid
>namespace
>> + * or that the signaler's pid namespace is an ancestor of the
>signalee's pid
>> + * namespace=2E
>> + */
>> +static bool may_signal_taskfd(struct pid *pid)
>> +{
>> +	struct pid_namespace *active =3D task_active_pid_ns(current);
>> +	struct pid_namespace *p =3D ns_of_pid(pid);
>> +
>> +	for (;;) {
>> +		if (!p)
>> +			return false;
>> +		if (p =3D=3D active)
>> +			break;
>> +		p =3D p->parent;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +static int copy_siginfo_from_user_any(kernel_siginfo_t *kinfo,
>siginfo_t *info)
>> +{
>> +#ifdef CONFIG_COMPAT
>> +	/*
>> +	 * Avoid hooking up compat syscalls and instead handle necessary
>> +	 * conversions here=2E Note, this is a stop-gap measure and should
>not be
>> +	 * considered a generic solution=2E
>> +	 */
>> +	if (in_compat_syscall())
>> +		return copy_siginfo_from_user32(
>> +			kinfo, (struct compat_siginfo __user *)info);
>> +#endif
>> +	return copy_siginfo_from_user(kinfo, info);
>> +}
>> +
>> +/**
>> + *  sys_taskfd_send_signal - send a signal to a process through a
>task file
>> + *                           descriptor
>> + *  @taskfd: the file descriptor of the process
>> + *  @sig:    signal to be sent
>> + *  @info:   the signal info
>> + *  @flags:  future flags to be passed
>> + *
>> + *  Return: 0 on success, negative errno on failure
>> + */
>> +SYSCALL_DEFINE4(taskfd_send_signal, int, taskfd, int, sig,
>> +		siginfo_t __user *, info, unsigned int, flags)
>> +{
>> +	int ret;
>> +	struct fd f;
>> +	struct pid *pid;
>> +	kernel_siginfo_t kinfo;
>> +
>> +	/* Enforce flags be set to 0 until we add an extension=2E */
>> +	if (flags)
>> +		return -EINVAL;
>> +
>> +	f =3D fdget_raw(taskfd);
>> +	if (!f=2Efile)
>> +		return -EBADF;
>> +
>> +	pid =3D tid_taskfd_to_pid(f=2Efile);
>> +	if (!IS_ERR(pid)) {
>> +		/*
>> +		 * Give userspace a way to detect /proc/<pid>/task/<tid>
>> +		 * support when we add it=2E
>> +		 */
>> +		ret =3D -EOPNOTSUPP;
>> +		goto err;
>> +	}
>> +
>> +	/* Is this a procfd? */
>> +	pid =3D tgid_taskfd_to_pid(f=2Efile);
>> +	if (IS_ERR(pid)) {
>> +		ret =3D PTR_ERR(pid);
>> +		goto err;
>> +	}
>> +
>> +	ret =3D -EINVAL;
>> +	if (!may_signal_taskfd(pid))
>> +		goto err;
>> +
>> +	if (info) {
>> +		ret =3D copy_siginfo_from_user_any(&kinfo, info);
>> +		if (unlikely(ret))
>> +			goto err;
>> +
>> +		ret =3D -EINVAL;
>> +		if (unlikely(sig !=3D kinfo=2Esi_signo))
>> +			goto err;
>> +
>> +		if ((task_pid(current) !=3D pid) &&
>> +		    (kinfo=2Esi_code >=3D 0 || kinfo=2Esi_code =3D=3D SI_TKILL)) {
>> +			/* Only allow sending arbitrary signals to yourself=2E */
>> +			ret =3D -EPERM;
>> +			if (kinfo=2Esi_code !=3D SI_USER)
>> +				goto err;
>> +
>> +			/* Turn this into a regular kill signal=2E */
>> +			prepare_kill_siginfo(sig, &kinfo);
>> +		}
>> +	} else {
>> +		prepare_kill_siginfo(sig, &kinfo);
>> +	}
>> +
>> +	ret =3D kill_pid_info(sig, &kinfo, pid);
>> +
>> +err:
>> +	fdput(f);
>> +	return ret;
>> +}
>> +
>>  static int
>>  do_send_specific(pid_t tgid, pid_t pid, int sig, struct
>kernel_siginfo *info)
>>  {
