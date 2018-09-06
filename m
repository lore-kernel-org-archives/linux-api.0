From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v6 1/5] seccomp: add a return code to trap to userspace
Date: Thu, 6 Sep 2018 22:15:12 +0000
Message-ID: <20180906221412.GA26209@sec>
References: <20180906152859.7810-1-tycho@tycho.ws>
 <20180906152859.7810-2-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180906152859.7810-2-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Tycho - I'm finally getting around to reviewing this patch set. I
don't have access to previous review comments while I'm doing this
review so I hope I'm not revisiting too many previous discussions.

On 2018-09-06 09:28:55, Tycho Andersen wrote:
> This patch introduces a means for syscalls matched in seccomp to notify
> some other task that a particular filter has been triggered.
>=20
> The motivation for this is primarily for use with containers. For example,
> if a container does an init_module(), we obviously don't want to load this
> untrusted code, which may be compiled for the wrong version of the kernel
> anyway. Instead, we could parse the module image, figure out which module
> the container is trying to load and load it on the host.
>=20
> As another example, containers cannot mknod(), since this checks
> capable(CAP_SYS_ADMIN). However, harmless devices like /dev/null or
> /dev/zero should be ok for containers to mknod, but we'd like to avoid ha=
rd
> coding some whitelist in the kernel. Another example is mount(), which has
> many security restrictions for good reason, but configuration or runtime
> knowledge could potentially be used to relax these restrictions.
>=20
> This patch adds functionality that is already possible via at least two
> other means that I know about, both of which involve ptrace(): first, one
> could ptrace attach, and then iterate through syscalls via PTRACE_SYSCALL.
> Unfortunately this is slow, so a faster version would be to install a
> filter that does SECCOMP_RET_TRACE, which triggers a PTRACE_EVENT_SECCOMP.
> Since ptrace allows only one tracer, if the container runtime is that
> tracer, users inside the container (or outside) trying to debug it will n=
ot
> be able to use ptrace, which is annoying. It also means that older
> distributions based on Upstart cannot boot inside containers using ptrace,
> since upstart itself uses ptrace to start services.
>=20
> The actual implementation of this is fairly small, although getting the
> synchronization right was/is slightly complex.
>=20
> Finally, it's worth noting that the classic seccomp TOCTOU of reading
> memory data from the task still applies here, but can be avoided with
> careful design of the userspace handler: if the userspace handler reads a=
ll
> of the task memory that is necessary before applying its security policy,
> the tracee's subsequent memory edits will not be read by the tracer.
>=20
> v2: * make id a u64; the idea here being that it will never overflow,
>       because 64 is huge (one syscall every nanosecond =3D> wrap every 584
>       years) (Andy)
>     * prevent nesting of user notifications: if someone is already attach=
ed
>       the tree in one place, nobody else can attach to the tree (Andy)
>     * notify the listener of signals the tracee receives as well (Andy)
>     * implement poll
> v3: * lockdep fix (Oleg)
>     * drop unnecessary WARN()s (Christian)
>     * rearrange error returns to be more rpetty (Christian)
>     * fix build in !CONFIG_SECCOMP_USER_NOTIFICATION case
> v4: * fix implementation of poll to use poll_wait() (Jann)
>     * change listener's fd flags to be 0 (Jann)
>     * hoist filter initialization out of ifdefs to its own function
>       init_user_notification()
>     * add some more testing around poll() and closing the listener while a
>       syscall is in action
>     * s/GET_LISTENER/NEW_LISTENER, since you can't _get_ a listener, but =
it
>       creates a new one (Matthew)
>     * correctly handle pid namespaces, add some testcases (Matthew)
>     * use EINPROGRESS instead of EINVAL when a notification response is
>       written twice (Matthew)
>     * fix comment typo from older version (SEND vs READ) (Matthew)
>     * whitespace and logic simplification (Tobin)
>     * add some Documentation/ bits on userspace trapping
> v5: * fix documentation typos (Jann)
>     * add signalled field to struct seccomp_notif (Jann)
>     * switch to using ioctls instead of read()/write() for struct passing
>       (Jann)
>     * add an ioctl to ensure an id is still valid
> v6: * docs typo fixes, update docs for ioctl() change (Christian)
>=20
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: Kees Cook <keescook@chromium.org>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> CC: Christian Brauner <christian.brauner@ubuntu.com>
> CC: Tyler Hicks <tyhicks@canonical.com>
> CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
> ---
>  Documentation/ioctl/ioctl-number.txt          |   1 +
>  .../userspace-api/seccomp_filter.rst          |  73 +++
>  arch/Kconfig                                  |   9 +
>  include/linux/seccomp.h                       |   7 +-
>  include/uapi/linux/seccomp.h                  |  33 +-
>  kernel/seccomp.c                              | 453 +++++++++++++++++-
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 403 +++++++++++++++-
>  7 files changed, 969 insertions(+), 10 deletions(-)
>=20
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/i=
octl-number.txt
> index 13a7c999c04a..31e9707f7e06 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -345,4 +345,5 @@ Code  Seq#(hex)	Include File		Comments
>  					<mailto:raph@8d.com>
>  0xF6	all	LTTng			Linux Trace Toolkit Next Generation
>  					<mailto:mathieu.desnoyers@efficios.com>
> +0xF7    00-1F   uapi/linux/seccomp.h
>  0xFD	all	linux/dm-ioctl.h
> diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentati=
on/userspace-api/seccomp_filter.rst
> index 82a468bc7560..d1498885c1c7 100644
> --- a/Documentation/userspace-api/seccomp_filter.rst
> +++ b/Documentation/userspace-api/seccomp_filter.rst
> @@ -122,6 +122,11 @@ In precedence order, they are:
>  	Results in the lower 16-bits of the return value being passed
>  	to userland as the errno without executing the system call.
> =20
> +``SECCOMP_RET_USER_NOTIF``:
> +    Results in a ``struct seccomp_notif`` message sent on the userspace
> +    notification fd, if it is attached, or ``-ENOSYS`` if it is not. See=
 below
> +    on discussion of how to handle user notifications.
> +
>  ``SECCOMP_RET_TRACE``:
>  	When returned, this value will cause the kernel to attempt to
>  	notify a ``ptrace()``-based tracer prior to executing the system
> @@ -183,6 +188,74 @@ The ``samples/seccomp/`` directory contains both an =
x86-specific example
>  and a more generic example of a higher level macro interface for BPF
>  program generation.
> =20
> +Userspace Notification
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The ``SECCOMP_RET_USER_NOTIF`` return code lets seccomp filters pass a
> +particular syscall to userspace to be handled. This may be useful for
> +applications like container managers, which wish to intercept particular
> +syscalls (``mount()``, ``finit_module()``, etc.) and change their behavi=
or.
> +
> +There are currently two APIs to acquire a userspace notification fd for a
> +particular filter. The first is when the filter is installed, the task
> +installing the filter can ask the ``seccomp()`` syscall:
> +
> +.. code-block::
> +
> +    fd =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_NEW_LIST=
ENER, &prog);
> +
> +which (on success) will return a listener fd for the filter, which can t=
hen be
> +passed around via ``SCM_RIGHTS`` or similar. Alternatively, a filter fd =
can be
> +acquired via:
> +
> +.. code-block::
> +
> +    fd =3D ptrace(PTRACE_SECCOMP_NEW_LISTENER, pid, 0);
> +
> +which grabs the 0th filter for some task which the tracer has privilege =
over.
> +Note that filter fds correspond to a particular filter, and not a partic=
ular
> +task. So if this task then forks, notifications from both tasks will app=
ear on
> +the same filter fd. Reads and writes to/from a filter fd are also synchr=
onized,
> +so a filter fd can safely have many readers.
> +
> +The interface for a seccomp notification fd consists of two structures:
> +
> +.. code-block::
> +
> +    struct seccomp_notif {
> +        __u16 len;
> +        __u64 id;
> +        pid_t pid;
> +        __u8 signalled;
> +        struct seccomp_data data;
> +    };
> +
> +    struct seccomp_notif_resp {
> +        __u16 len;
> +        __u64 id;
> +        __s32 error;
> +        __s64 val;
> +    };
> +
> +Users can read via ``ioctl(SECCOMP_NOTIF_RECV)``  (or ``poll()``) on a s=
eccomp
> +notification fd to receive a ``struct seccomp_notif``, which contains fi=
ve
> +members: the input length of the structure, a globally unique ``id``, the

This documentation says that id is "globally unique" but an in-code
comment below says "this is unique for this filter". IIUC, the id is
only guaranteed to be unique for the filter so this documentation should
be updated slightly to make it clear that the id is only global in those
terms.

> +``pid`` of the task which triggered this request (which may be 0 if the =
task is
> +in a pid ns not visible from the listener's pid namespace), a flag repre=
senting
> +whether or not the notification is a result of a non-fatal signal, and t=
he
> +``data`` passed to seccomp. Userspace can then make a decision based on =
this
> +information about what to do, and ``ioctl(SECCOMP_NOTIF_SEND)`` a respon=
se,
> +indicating what should be returned to userspace. The ``id`` member of ``=
struct
> +seccomp_notif_resp`` should be the same ``id`` as in ``struct seccomp_no=
tif``.
> +
> +It is worth noting that ``struct seccomp_data`` contains the values of r=
egister
> +arguments to the syscall, but does not contain pointers to memory. The t=
ask's
> +memory is accessible to suitably privileged traces via ``ptrace()`` or
> +``/proc/pid/map_files/``. However, care should be taken to avoid the TOC=
TOU
> +mentioned above in this document: all arguments being read from the trac=
ee's
> +memory should be read into the tracer's memory before any policy decisio=
ns are
> +made. This allows for an atomic decision on syscall arguments.
> +
>  Sysctls
>  =3D=3D=3D=3D=3D=3D=3D
> =20
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 6801123932a5..42f3585d925d 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -419,6 +419,15 @@ config SECCOMP_FILTER
> =20
>  	  See Documentation/userspace-api/seccomp_filter.rst for details.
> =20
> +config SECCOMP_USER_NOTIFICATION

Did someone request a Kconfig option for this new feature? If not, I
think that nuking the Kconfig option would reduce the test matrix. No
other filter flags have their own build time option but maybe it makes
sense in this case if this filter flag exposes the kernel to significant
new attack surface since there's more to this than just a new filter
flag.

If someone has a requirement to disable this feature, maybe it'd be
better to leave the decision up to the distro *and* the admin via a
sysctl instead of taking the admin out of the decision with a build
time option.

> +	bool "Enable the SECCOMP_RET_USER_NOTIF seccomp action"
> +	depends on SECCOMP_FILTER
> +	help
> +	  Enable SECCOMP_RET_USER_NOTIF, a return code which can be used by sec=
comp
> +	  programs to notify a userspace listener that a particular event happe=
ned.
> +
> +	  See Documentation/userspace-api/seccomp_filter.rst for details.
> +
>  config HAVE_STACKPROTECTOR
>  	bool
>  	help
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index e5320f6c8654..017444b5efed 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -4,9 +4,10 @@
> =20
>  #include <uapi/linux/seccomp.h>
> =20
> -#define SECCOMP_FILTER_FLAG_MASK	(SECCOMP_FILTER_FLAG_TSYNC	| \
> -					 SECCOMP_FILTER_FLAG_LOG	| \
> -					 SECCOMP_FILTER_FLAG_SPEC_ALLOW)
> +#define SECCOMP_FILTER_FLAG_MASK	(SECCOMP_FILTER_FLAG_TSYNC | \
> +					 SECCOMP_FILTER_FLAG_LOG | \
> +					 SECCOMP_FILTER_FLAG_SPEC_ALLOW | \
> +					 SECCOMP_FILTER_FLAG_NEW_LISTENER)
> =20
>  #ifdef CONFIG_SECCOMP
> =20
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 9efc0e73d50b..aa5878972128 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -17,9 +17,10 @@
>  #define SECCOMP_GET_ACTION_AVAIL	2
> =20
>  /* Valid flags for SECCOMP_SET_MODE_FILTER */
> -#define SECCOMP_FILTER_FLAG_TSYNC	(1UL << 0)
> -#define SECCOMP_FILTER_FLAG_LOG		(1UL << 1)
> -#define SECCOMP_FILTER_FLAG_SPEC_ALLOW	(1UL << 2)
> +#define SECCOMP_FILTER_FLAG_TSYNC		(1UL << 0)
> +#define SECCOMP_FILTER_FLAG_LOG			(1UL << 1)
> +#define SECCOMP_FILTER_FLAG_SPEC_ALLOW		(1UL << 2)
> +#define SECCOMP_FILTER_FLAG_NEW_LISTENER	(1UL << 3)
> =20
>  /*
>   * All BPF programs must return a 32-bit value.
> @@ -35,6 +36,7 @@
>  #define SECCOMP_RET_KILL	 SECCOMP_RET_KILL_THREAD
>  #define SECCOMP_RET_TRAP	 0x00030000U /* disallow and force a SIGSYS */
>  #define SECCOMP_RET_ERRNO	 0x00050000U /* returns an errno */
> +#define SECCOMP_RET_USER_NOTIF   0x7fc00000U /* notifies userspace */
>  #define SECCOMP_RET_TRACE	 0x7ff00000U /* pass to a tracer or disallow */
>  #define SECCOMP_RET_LOG		 0x7ffc0000U /* allow after logging */
>  #define SECCOMP_RET_ALLOW	 0x7fff0000U /* allow */
> @@ -60,4 +62,29 @@ struct seccomp_data {
>  	__u64 args[6];
>  };
> =20
> +struct seccomp_notif {
> +	__u16 len;
> +	__u64 id;
> +	__u32 pid;
> +	__u8 signalled;

I think signaled is the best spelling to go with. There are a lot of
other instances of signalled in the kernel sources but, ultimately, it
makes sense to follow the lead of the WIFSIGNALED macro from wait(2).

> +	struct seccomp_data data;
> +};
> +
> +struct seccomp_notif_resp {
> +	__u16 len;
> +	__u64 id;
> +	__s32 error;
> +	__s64 val;
> +};
> +
> +#define SECCOMP_IOC_MAGIC		0xF7
> +
> +/* Flags for seccomp notification fd ioctl. */
> +#define SECCOMP_NOTIF_RECV		_IOWR(SECCOMP_IOC_MAGIC, 0,	\
> +						struct seccomp_notif)
> +#define SECCOMP_NOTIF_SEND		_IOWR(SECCOMP_IOC_MAGIC, 1,	\
> +						struct seccomp_notif_resp)

This is pedantic but it would make sense to me to have the ioctl names
match the struct names. That would leave us with:

#define SECCOMP_NOTIF			_IOWR(SECCOMP_IOC_MAGIC, 0,	\
					      struct seccomp_notif)
#define SECCOMP_NOTIF_RESP		_IOWR(SECCOMP_IOC_MAGIC, 1,	\
					      struct seccomp_notif_resp)

Change it if you agree. Ignore this comment if you don't.

> +#define SECCOMP_NOTIF_IS_ID_VALID	_IOR(SECCOMP_IOC_MAGIC, 2,	\
> +						__u64)
> +
>  #endif /* _UAPI_LINUX_SECCOMP_H */
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index fd023ac24e10..a09eb5c05f68 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -33,6 +33,7 @@
>  #endif
> =20
>  #ifdef CONFIG_SECCOMP_FILTER
> +#include <linux/file.h>
>  #include <linux/filter.h>
>  #include <linux/pid.h>
>  #include <linux/ptrace.h>
> @@ -40,6 +41,53 @@
>  #include <linux/tracehook.h>
>  #include <linux/uaccess.h>
> =20
> +#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
> +#include <linux/anon_inodes.h>
> +
> +enum notify_state {
> +	SECCOMP_NOTIFY_INIT,
> +	SECCOMP_NOTIFY_SENT,
> +	SECCOMP_NOTIFY_REPLIED,
> +};
> +
> +struct seccomp_knotif {
> +	/* The struct pid of the task whose filter triggered the notification */
> +	struct pid *pid;
> +
> +	/* The "cookie" for this request; this is unique for this filter. */
> +	u32 id;
> +
> +	/* Whether or not this task has been given an interruptible signal. */
> +	bool signalled;
> +
> +	/*
> +	 * The seccomp data. This pointer is valid the entire time this
> +	 * notification is active, since it comes from __seccomp_filter which
> +	 * eclipses the entire lifecycle here.
> +	 */
> +	const struct seccomp_data *data;
> +
> +	/*
> +	 * Notification states. When SECCOMP_RET_USER_NOTIF is returned, a
> +	 * struct seccomp_knotif is created and starts out in INIT. Once the
> +	 * handler reads the notification off of an FD, it transitions to SENT.
> +	 * If a signal is received the state transitions back to INIT and
> +	 * another message is sent. When the userspace handler replies, state
> +	 * transitions to REPLIED.
> +	 */
> +	enum notify_state state;
> +
> +	/* The return values, only valid when in SECCOMP_NOTIFY_REPLIED */
> +	int error;
> +	long val;
> +
> +	/* Signals when this has entered SECCOMP_NOTIFY_REPLIED */
> +	struct completion ready;
> +
> +	struct list_head list;
> +};
> +#endif
> +
>  /**
>   * struct seccomp_filter - container for seccomp BPF programs
>   *
> @@ -66,6 +114,30 @@ struct seccomp_filter {
>  	bool log;
>  	struct seccomp_filter *prev;
>  	struct bpf_prog *prog;
> +
> +#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
> +	/*
> +	 * A semaphore that users of this notification can wait on for
> +	 * changes. Actual reads and writes are still controlled with
> +	 * filter->notify_lock.
> +	 */
> +	struct semaphore request;
> +
> +	/* A lock for all notification-related accesses. */
> +	struct mutex notify_lock;
> +
> +	/* Is there currently an attached listener? */
> +	bool has_listener;
> +
> +	/* The id of the next request. */
> +	u64 next_id;
> +
> +	/* A list of struct seccomp_knotif elements. */
> +	struct list_head notifications;
> +
> +	/* A wait queue for poll. */
> +	wait_queue_head_t wqh;
> +#endif

I suspect that these additions would benefit from better struct packing
since there could be a lot of seccomp_filter structs floating around in
memory on a system with a large number of running containers or
otherwise sandboxed processes.

IIRC, there's a 3 byte hole following the log member that could be used
by has_listener, at least, and I'm not sure how the rest of the new
members affect things.

>  };
> =20
>  /* Limit any path through the tree to 256KB worth of instructions. */
> @@ -359,6 +431,19 @@ static inline void seccomp_sync_threads(unsigned lon=
g flags)
>  	}
>  }
> =20
> +#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
> +static void init_user_notification(struct seccomp_filter *sfilter)
> +{
> +	mutex_init(&sfilter->notify_lock);
> +	sema_init(&sfilter->request, 0);
> +	INIT_LIST_HEAD(&sfilter->notifications);
> +	sfilter->next_id =3D get_random_u64();
> +	init_waitqueue_head(&sfilter->wqh);
> +}
> +#else
> +static inline void init_user_notification(struct seccomp_filter *sfilter=
) { }
> +#endif
> +
>  /**
>   * seccomp_prepare_filter: Prepares a seccomp filter for use.
>   * @fprog: BPF program to install
> @@ -392,6 +477,8 @@ static struct seccomp_filter *seccomp_prepare_filter(=
struct sock_fprog *fprog)
>  	if (!sfilter)
>  		return ERR_PTR(-ENOMEM);
> =20
> +	init_user_notification(sfilter);
> +
>  	ret =3D bpf_prog_create_from_user(&sfilter->prog, fprog,
>  					seccomp_check_filter, save_orig);
>  	if (ret < 0) {
> @@ -556,13 +643,15 @@ static void seccomp_send_sigsys(int syscall, int re=
ason)
>  #define SECCOMP_LOG_TRACE		(1 << 4)
>  #define SECCOMP_LOG_LOG			(1 << 5)
>  #define SECCOMP_LOG_ALLOW		(1 << 6)
> +#define SECCOMP_LOG_USER_NOTIF		(1 << 7)
> =20
>  static u32 seccomp_actions_logged =3D SECCOMP_LOG_KILL_PROCESS |
>  				    SECCOMP_LOG_KILL_THREAD  |
>  				    SECCOMP_LOG_TRAP  |
>  				    SECCOMP_LOG_ERRNO |
>  				    SECCOMP_LOG_TRACE |
> -				    SECCOMP_LOG_LOG;
> +				    SECCOMP_LOG_LOG |
> +				    SECCOMP_LOG_USER_NOTIF;
> =20
>  static inline void seccomp_log(unsigned long syscall, long signr, u32 ac=
tion,
>  			       bool requested)
> @@ -581,6 +670,9 @@ static inline void seccomp_log(unsigned long syscall,=
 long signr, u32 action,
>  	case SECCOMP_RET_TRACE:
>  		log =3D requested && seccomp_actions_logged & SECCOMP_LOG_TRACE;
>  		break;
> +	case SECCOMP_RET_USER_NOTIF:
> +		log =3D requested && seccomp_actions_logged & SECCOMP_LOG_USER_NOTIF;
> +		break;
>  	case SECCOMP_RET_LOG:
>  		log =3D seccomp_actions_logged & SECCOMP_LOG_LOG;
>  		break;
> @@ -651,6 +743,83 @@ void secure_computing_strict(int this_syscall)
>  }
>  #else
> =20
> +#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
> +static u64 seccomp_next_notify_id(struct seccomp_filter *filter)
> +{
> +	/* Note: overflow is ok here, the id just needs to be unique */
> +	return filter->next_id++;
> +}
> +
> +static void seccomp_do_user_notification(int this_syscall,
> +					 struct seccomp_filter *match,
> +					 const struct seccomp_data *sd)
> +{
> +	int err;
> +	long ret =3D 0;
> +	struct seccomp_knotif n =3D {};
> +
> +	mutex_lock(&match->notify_lock);
> +	err =3D -ENOSYS;
> +	if (!match->has_listener)
> +		goto out;
> +
> +	n.pid =3D task_pid(current);
> +	n.state =3D SECCOMP_NOTIFY_INIT;
> +	n.data =3D sd;
> +	n.id =3D seccomp_next_notify_id(match);
> +	init_completion(&n.ready);
> +
> +	list_add(&n.list, &match->notifications);
> +	wake_up_poll(&match->wqh, EPOLLIN | EPOLLRDNORM);
> +
> +	mutex_unlock(&match->notify_lock);
> +	up(&match->request);
> +
> +	err =3D wait_for_completion_interruptible(&n.ready);
> +	mutex_lock(&match->notify_lock);
> +
> +	/*
> +	 * Here it's possible we got a signal and then had to wait on the mutex
> +	 * while the reply was sent, so let's be sure there wasn't a response
> +	 * in the meantime.
> +	 */
> +	if (err < 0 && n.state !=3D SECCOMP_NOTIFY_REPLIED) {
> +		/*
> +		 * We got a signal. Let's tell userspace about it (potentially
> +		 * again, if we had already notified them about the first one).
> +		 */
> +		n.signalled =3D true;
> +		if (n.state =3D=3D SECCOMP_NOTIFY_SENT) {
> +			n.state =3D SECCOMP_NOTIFY_INIT;
> +			up(&match->request);
> +		}
> +		mutex_unlock(&match->notify_lock);

Is it intentional that you call mutex_unlocked() followed by up() when
initially waiting but then switch up the order before re-waiting here? I
don't yet fully understand the locking but this looked odd to me.

> +		err =3D wait_for_completion_killable(&n.ready);
> +		mutex_lock(&match->notify_lock);
> +		if (err < 0)
> +			goto remove_list;
> +	}
> +
> +	ret =3D n.val;
> +	err =3D n.error;
> +
> +remove_list:
> +	list_del(&n.list);
> +out:
> +	mutex_unlock(&match->notify_lock);
> +	syscall_set_return_value(current, task_pt_regs(current),
> +				 err, ret);
> +}
> +#else
> +static void seccomp_do_user_notification(int this_syscall,
> +					 struct seccomp_filter *match,
> +					 const struct seccomp_data *sd)
> +{
> +	seccomp_log(this_syscall, SIGSYS, SECCOMP_RET_USER_NOTIF, true);
> +	do_exit(SIGSYS);
> +}
> +#endif
> +
>  #ifdef CONFIG_SECCOMP_FILTER
>  static int __seccomp_filter(int this_syscall, const struct seccomp_data =
*sd,
>  			    const bool recheck_after_trace)
> @@ -728,6 +897,9 @@ static int __seccomp_filter(int this_syscall, const s=
truct seccomp_data *sd,
> =20
>  		return 0;
> =20
> +	case SECCOMP_RET_USER_NOTIF:
> +		seccomp_do_user_notification(this_syscall, match, sd);
> +		goto skip;
>  	case SECCOMP_RET_LOG:
>  		seccomp_log(this_syscall, 0, action, true);
>  		return 0;
> @@ -834,6 +1006,9 @@ static long seccomp_set_mode_strict(void)
>  }
> =20
>  #ifdef CONFIG_SECCOMP_FILTER
> +static struct file *init_listener(struct task_struct *,
> +				  struct seccomp_filter *);
> +
>  /**
>   * seccomp_set_mode_filter: internal function for setting seccomp filter
>   * @flags:  flags to change filter behavior
> @@ -853,6 +1028,8 @@ static long seccomp_set_mode_filter(unsigned int fla=
gs,
>  	const unsigned long seccomp_mode =3D SECCOMP_MODE_FILTER;
>  	struct seccomp_filter *prepared =3D NULL;
>  	long ret =3D -EINVAL;
> +	int listener =3D 0;
> +	struct file *listener_f =3D NULL;
> =20
>  	/* Validate flags. */
>  	if (flags & ~SECCOMP_FILTER_FLAG_MASK)
> @@ -863,13 +1040,28 @@ static long seccomp_set_mode_filter(unsigned int f=
lags,
>  	if (IS_ERR(prepared))
>  		return PTR_ERR(prepared);
> =20
> +	if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
> +		listener =3D get_unused_fd_flags(0);
> +		if (listener < 0) {
> +			ret =3D listener;
> +			goto out_free;
> +		}
> +
> +		listener_f =3D init_listener(current, prepared);
> +		if (IS_ERR(listener_f)) {
> +			put_unused_fd(listener);
> +			ret =3D PTR_ERR(listener_f);
> +			goto out_free;
> +		}
> +	}
> +
>  	/*
>  	 * Make sure we cannot change seccomp or nnp state via TSYNC
>  	 * while another thread is in the middle of calling exec.
>  	 */
>  	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
>  	    mutex_lock_killable(&current->signal->cred_guard_mutex))
> -		goto out_free;
> +		goto out_put_fd;
> =20
>  	spin_lock_irq(&current->sighand->siglock);
> =20
> @@ -887,6 +1079,16 @@ static long seccomp_set_mode_filter(unsigned int fl=
ags,
>  	spin_unlock_irq(&current->sighand->siglock);
>  	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
>  		mutex_unlock(&current->signal->cred_guard_mutex);
> +out_put_fd:
> +	if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
> +		if (ret < 0) {
> +			fput(listener_f);
> +			put_unused_fd(listener);
> +		} else {
> +			fd_install(listener, listener_f);
> +			ret =3D listener;
> +		}
> +	}
>  out_free:
>  	seccomp_filter_free(prepared);
>  	return ret;
> @@ -915,6 +1117,9 @@ static long seccomp_get_action_avail(const char __us=
er *uaction)
>  	case SECCOMP_RET_LOG:
>  	case SECCOMP_RET_ALLOW:
>  		break;
> +	case SECCOMP_RET_USER_NOTIF:
> +		if (IS_ENABLED(CONFIG_SECCOMP_USER_NOTIFICATION))
> +			break;

Lets add a "/* fall through */" comment here to support the ongoing
effort of marking these sorts of cases in prep for
-Wimplicit-fallthrough.

>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -1111,6 +1316,7 @@ long seccomp_get_metadata(struct task_struct *task,
>  #define SECCOMP_RET_KILL_THREAD_NAME	"kill_thread"
>  #define SECCOMP_RET_TRAP_NAME		"trap"
>  #define SECCOMP_RET_ERRNO_NAME		"errno"
> +#define SECCOMP_RET_USER_NOTIF_NAME	"user_notif"
>  #define SECCOMP_RET_TRACE_NAME		"trace"
>  #define SECCOMP_RET_LOG_NAME		"log"
>  #define SECCOMP_RET_ALLOW_NAME		"allow"
> @@ -1120,6 +1326,7 @@ static const char seccomp_actions_avail[] =3D
>  				SECCOMP_RET_KILL_THREAD_NAME	" "
>  				SECCOMP_RET_TRAP_NAME		" "
>  				SECCOMP_RET_ERRNO_NAME		" "
> +				SECCOMP_RET_USER_NOTIF_NAME     " "
>  				SECCOMP_RET_TRACE_NAME		" "
>  				SECCOMP_RET_LOG_NAME		" "
>  				SECCOMP_RET_ALLOW_NAME;
> @@ -1137,6 +1344,7 @@ static const struct seccomp_log_name seccomp_log_na=
mes[] =3D {
>  	{ SECCOMP_LOG_TRACE, SECCOMP_RET_TRACE_NAME },
>  	{ SECCOMP_LOG_LOG, SECCOMP_RET_LOG_NAME },
>  	{ SECCOMP_LOG_ALLOW, SECCOMP_RET_ALLOW_NAME },
> +	{ SECCOMP_LOG_USER_NOTIF, SECCOMP_RET_USER_NOTIF_NAME },

Probably best to keep this list in order. Can you stick it in front of
the element for TRACE?

>  	{ }
>  };
> =20
> @@ -1342,3 +1550,244 @@ static int __init seccomp_sysctl_init(void)
>  device_initcall(seccomp_sysctl_init)
> =20
>  #endif /* CONFIG_SYSCTL */
> +
> +#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
> +static int seccomp_notify_release(struct inode *inode, struct file *file)
> +{
> +	struct seccomp_filter *filter =3D file->private_data;
> +	struct seccomp_knotif *knotif;
> +
> +	mutex_lock(&filter->notify_lock);
> +
> +	/*
> +	 * If this file is being closed because e.g. the task who owned it
> +	 * died, let's wake everyone up who was waiting on us.
> +	 */
> +	list_for_each_entry(knotif, &filter->notifications, list) {
> +		if (knotif->state =3D=3D SECCOMP_NOTIFY_REPLIED)
> +			continue;
> +
> +		knotif->state =3D SECCOMP_NOTIFY_REPLIED;
> +		knotif->error =3D -ENOSYS;

ENOSYS seems odd to me since the functionality is implemented. Is EIO
more appropriate? It feels like it better matches an EIO from read(2),
for example.

> +		knotif->val =3D 0;
> +
> +		complete(&knotif->ready);
> +	}
> +
> +	wake_up_all(&filter->wqh);
> +	filter->has_listener =3D false;
> +	mutex_unlock(&filter->notify_lock);
> +	__put_seccomp_filter(filter);
> +	return 0;
> +}
> +
> +static long seccomp_notify_recv(struct seccomp_filter *filter,
> +				unsigned long arg)
> +{
> +	struct seccomp_knotif *knotif =3D NULL, *cur;
> +	struct seccomp_notif unotif =3D {};
> +	ssize_t ret;
> +	u16 size;
> +	void __user *buf =3D (void __user *)arg;
> +
> +	if (copy_from_user(&size, buf, sizeof(size)))
> +		return -EFAULT;
> +
> +	ret =3D down_interruptible(&filter->request);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&filter->notify_lock);
> +	list_for_each_entry(cur, &filter->notifications, list) {
> +		if (cur->state =3D=3D SECCOMP_NOTIFY_INIT) {
> +			knotif =3D cur;
> +			break;
> +		}
> +	}
> +
> +	/*
> +	 * If we didn't find a notification, it could be that the task was
> +	 * interrupted between the time we were woken and when we were able to
> +	 * acquire the rw lock.
> +	 */
> +	if (!knotif) {
> +		ret =3D -ENOENT;
> +		goto out;
> +	}
> +
> +	size =3D min_t(size_t, size, sizeof(unotif));
> +
> +	unotif.len =3D size;
> +	unotif.id =3D knotif->id;
> +	unotif.pid =3D pid_vnr(knotif->pid);
> +	unotif.signalled =3D knotif->signalled;
> +	unotif.data =3D *(knotif->data);
> +
> +	if (copy_to_user(buf, &unotif, size)) {
> +		ret =3D -EFAULT;
> +		goto out;
> +	}
> +
> +	ret =3D sizeof(unotif);

I would have thought that ret =3D size since only size bytes are copied.

> +	knotif->state =3D SECCOMP_NOTIFY_SENT;
> +	wake_up_poll(&filter->wqh, EPOLLOUT | EPOLLWRNORM);
> +
> +out:
> +	mutex_unlock(&filter->notify_lock);
> +	return ret;
> +}
> +
> +static long seccomp_notify_send(struct seccomp_filter *filter,
> +				unsigned long arg)
> +{
> +	struct seccomp_notif_resp resp =3D {};
> +	struct seccomp_knotif *knotif =3D NULL;
> +	long ret;
> +	u16 size;
> +	void __user *buf =3D (void __user *)arg;
> +
> +	if (copy_from_user(&size, buf, sizeof(size)))
> +		return -EFAULT;
> +	size =3D min_t(size_t, size, sizeof(resp));
> +	if (copy_from_user(&resp, buf, size))
> +		return -EFAULT;
> +
> +	ret =3D mutex_lock_interruptible(&filter->notify_lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	list_for_each_entry(knotif, &filter->notifications, list) {
> +		if (knotif->id =3D=3D resp.id)
> +			break;
> +	}
> +
> +	if (!knotif || knotif->id !=3D resp.id) {
> +		ret =3D -EINVAL;

ENOENT here instead? It clearly conveys that there is no notification
matching the requested ID. We'll probably have a more ambiguous error
path that we can use to abuse EINVAL. :)

> +		goto out;
> +	}
> +
> +	/* Allow exactly one reply. */
> +	if (knotif->state !=3D SECCOMP_NOTIFY_SENT) {
> +		ret =3D -EINPROGRESS;
> +		goto out;
> +	}
> +
> +	ret =3D size;
> +	knotif->state =3D SECCOMP_NOTIFY_REPLIED;
> +	knotif->error =3D resp.error;
> +	knotif->val =3D resp.val;
> +	complete(&knotif->ready);
> +out:
> +	mutex_unlock(&filter->notify_lock);
> +	return ret;
> +}
> +
> +static long seccomp_notify_is_id_valid(struct seccomp_filter *filter,
> +				       unsigned long arg)
> +{
> +	struct seccomp_knotif *knotif =3D NULL;
> +	void __user *buf =3D (void __user *)arg;
> +	u64 id;
> +
> +	if (copy_from_user(&id, buf, sizeof(id)))
> +		return -EFAULT;
> +
> +	list_for_each_entry(knotif, &filter->notifications, list) {
> +		if (knotif->id =3D=3D id)
> +			return 1;
> +	}
> +
> +	return 0;

I understand the desire to return 1 from
ioctl(fd, SECCOMP_NOTIF_IS_ID_VALID, id) when id is valid but it goes
against the common case where a syscall returns 0 on success. Also, the
ioctl_list(2) man page states:

 Decent ioctls return 0 on success and -1 on error, ...

The only suggestion that I have here is to change the ioctl name to
SECCOMP_NOTIF_VALID_ID (or similiar) and return 0 if the id is valid and
-EINVAL if the id is invalid. I don't feel strongly about it so take it
or leave it.

> +}
> +
> +static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
> +				 unsigned long arg)
> +{
> +	struct seccomp_filter *filter =3D file->private_data;
> +
> +	switch (cmd) {
> +	case SECCOMP_NOTIF_RECV:
> +		return seccomp_notify_recv(filter, arg);
> +	case SECCOMP_NOTIF_SEND:
> +		return seccomp_notify_send(filter, arg);
> +	case SECCOMP_NOTIF_IS_ID_VALID:
> +		return seccomp_notify_is_id_valid(filter, arg);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static __poll_t seccomp_notify_poll(struct file *file,
> +				    struct poll_table_struct *poll_tab)
> +{
> +	struct seccomp_filter *filter =3D file->private_data;
> +	__poll_t ret =3D 0;
> +	struct seccomp_knotif *cur;
> +
> +	poll_wait(file, &filter->wqh, poll_tab);
> +
> +	ret =3D mutex_lock_interruptible(&filter->notify_lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	list_for_each_entry(cur, &filter->notifications, list) {
> +		if (cur->state =3D=3D SECCOMP_NOTIFY_INIT)
> +			ret |=3D EPOLLIN | EPOLLRDNORM;
> +		if (cur->state =3D=3D SECCOMP_NOTIFY_SENT)
> +			ret |=3D EPOLLOUT | EPOLLWRNORM;
> +		if (ret & EPOLLIN && ret & EPOLLOUT)
> +			break;
> +	}
> +
> +	mutex_unlock(&filter->notify_lock);
> +
> +	return ret;
> +}
> +
> +static const struct file_operations seccomp_notify_ops =3D {
> +	.poll =3D seccomp_notify_poll,
> +	.release =3D seccomp_notify_release,
> +	.unlocked_ioctl =3D seccomp_notify_ioctl,
> +};
> +
> +static struct file *init_listener(struct task_struct *task,
> +				  struct seccomp_filter *filter)
> +{
> +	struct file *ret =3D ERR_PTR(-EBUSY);
> +	struct seccomp_filter *cur, *last_locked =3D NULL;
> +	int filter_nesting =3D 0;
> +
> +	for (cur =3D task->seccomp.filter; cur; cur =3D cur->prev) {
> +		mutex_lock_nested(&cur->notify_lock, filter_nesting);
> +		filter_nesting++;
> +		last_locked =3D cur;
> +		if (cur->has_listener)
> +			goto out;
> +	}
> +
> +	ret =3D anon_inode_getfile("seccomp notify", &seccomp_notify_ops,
> +				 filter, O_RDWR);
> +	if (IS_ERR(ret))
> +		goto out;
> +
> +
> +	/* The file has a reference to it now */
> +	__get_seccomp_filter(filter);
> +	filter->has_listener =3D true;
> +
> +out:
> +	for (cur =3D task->seccomp.filter; cur; cur =3D cur->prev) {
> +		mutex_unlock(&cur->notify_lock);
> +		if (cur =3D=3D last_locked)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +#else
> +static struct file *init_listener(struct task_struct *task,
> +				  struct seccomp_filter *filter)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +#endif
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testin=
g/selftests/seccomp/seccomp_bpf.c
> index e1473234968d..89f2c788a06b 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -5,6 +5,7 @@
>   * Test code for seccomp bpf.
>   */

[...]

I only gave the tests a quick review so far but nothing stood out.

I'm anxious to give this patch set some testing. I'll get to the other
patches soon.

Tyler

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJbkaa0AAoJENaSAD2qAscKdwYQAI2oR/SmetqlXjwj5VdDYrzO
dNbX1mvgNn4ZRi43seg6uzrZ8ZTvBT9Y3XFyLdZhuXNhYipQzQXRcBLOMan+Ipee
k1uDQ0Tu/roqeI5RxE3UjLmg1Whp3IJ4BxsGxvx36Td+wqcxbmEwu7esVuf8JWNE
p88aPiu8skcf1sGhufXATTOGxZ628I3XP//vGSbGHLaQERKZwRQ/jTrWXQ4UHNqp
P88o/7v/MTRbViClxO3muvcUi6oncCgRSulsOZsKzfuVYkkk0epFIMjh+U8eWWYf
jvWv0QTOhN0IvJT99r3vYC2z3ebOdNKJWMBZkN0+ySKIgQpVlqVb0uLsKkeDI8LL
CSWKuSXtx6RMTbwF5KG4IJ3WHutZApKezqvzEu2GQsg475fDc4hkf5ZfMU+IuJWU
9LqzKHLrpvTQFtGFDjsD1KRf8QRFblbkeT2Dtmwyaw6U8tup0yMAz0Z5A82pkPFR
psChsZtSgN68c/Zz43FGQNy/Wo29Xnikauv8D/pIfW8vnVsMymuMWDD4i0Vi9rOZ
rv7wbhxX4F2mhFf9x5YVYKtJd/MoFKd+ldxUdlb3p3j374xzy9TG7HlDVwFZf3b/
poJOJ5sacE+EKV1LiQki7JY0Qa24iwMTOL4H/HIim/HE8ytruYsZh/hXh+cLL+jq
P3Sr/L+OJCpWd0SrZfAO
=RWK6
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
