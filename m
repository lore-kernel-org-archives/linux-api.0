From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v8 2/2] samples: add an example of seccomp user trap
Date: Mon, 29 Oct 2018 23:31:00 +0000
Message-ID: <20181029233100.GA24103@mail.hallyn.com>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-3-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181029224031.29809-3-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 04:40:31PM -0600, Tycho Andersen wrote:
> The idea here is just to give a demonstration of how one could safely use
> the SECCOMP_RET_USER_NOTIF feature to do mount policies. This particular
> policy is (as noted in the comment) not very interesting, but it serves to
> illustrate how one might apply a policy dodging the various TOCTOU issues.
> 
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: Kees Cook <keescook@chromium.org>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> CC: Christian Brauner <christian@brauner.io>
> CC: Tyler Hicks <tyhicks@canonical.com>
> CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
> ---
> v5: new in v5
> v7: updates for v7 API changes
> v8: * add some more comments about what's happening in main() (Kees)
>     * move from ptrace API to SECCOMP_FILTER_FLAG_NEW_LISTENER
> ---
>  samples/seccomp/.gitignore  |   1 +
>  samples/seccomp/Makefile    |   7 +-
>  samples/seccomp/user-trap.c | 345 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 352 insertions(+), 1 deletion(-)
> 
> diff --git a/samples/seccomp/.gitignore b/samples/seccomp/.gitignore
> index 78fb78184291..d1e2e817d556 100644
> --- a/samples/seccomp/.gitignore
> +++ b/samples/seccomp/.gitignore
> @@ -1,3 +1,4 @@
>  bpf-direct
>  bpf-fancy
>  dropper
> +user-trap
> diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
> index cf34ff6b4065..4920903c8009 100644
> --- a/samples/seccomp/Makefile
> +++ b/samples/seccomp/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  ifndef CROSS_COMPILE
> -hostprogs-$(CONFIG_SAMPLE_SECCOMP) := bpf-fancy dropper bpf-direct
> +hostprogs-$(CONFIG_SAMPLE_SECCOMP) := bpf-fancy dropper bpf-direct user-trap
>  
>  HOSTCFLAGS_bpf-fancy.o += -I$(objtree)/usr/include
>  HOSTCFLAGS_bpf-fancy.o += -idirafter $(objtree)/include
> @@ -16,6 +16,10 @@ HOSTCFLAGS_bpf-direct.o += -I$(objtree)/usr/include
>  HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
>  bpf-direct-objs := bpf-direct.o
>  
> +HOSTCFLAGS_user-trap.o += -I$(objtree)/usr/include
> +HOSTCFLAGS_user-trap.o += -idirafter $(objtree)/include
> +user-trap-objs := user-trap.o
> +
>  # Try to match the kernel target.
>  ifndef CONFIG_64BIT
>  
> @@ -33,6 +37,7 @@ HOSTCFLAGS_bpf-fancy.o += $(MFLAG)
>  HOSTLDLIBS_bpf-direct += $(MFLAG)
>  HOSTLDLIBS_bpf-fancy += $(MFLAG)
>  HOSTLDLIBS_dropper += $(MFLAG)
> +HOSTLDLIBS_user-trap += $(MFLAG)
>  endif
>  always := $(hostprogs-m)
>  endif
> diff --git a/samples/seccomp/user-trap.c b/samples/seccomp/user-trap.c
> new file mode 100644
> index 000000000000..bba7ac803c6c
> --- /dev/null
> +++ b/samples/seccomp/user-trap.c
> @@ -0,0 +1,345 @@
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <string.h>
> +#include <stddef.h>
> +#include <sys/sysmacros.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +#include <sys/socket.h>
> +#include <sys/stat.h>
> +#include <sys/mman.h>
> +#include <sys/syscall.h>
> +#include <sys/user.h>
> +#include <sys/ioctl.h>
> +#include <sys/ptrace.h>
> +#include <sys/mount.h>
> +#include <linux/limits.h>
> +#include <linux/filter.h>
> +#include <linux/seccomp.h>
> +
> +#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
> +
> +static int seccomp(unsigned int op, unsigned int flags, void *args)
> +{
> +	errno = 0;
> +	return syscall(__NR_seccomp, op, flags, args);
> +}
> +
> +static int send_fd(int sock, int fd)
> +{
> +	struct msghdr msg = {};
> +	struct cmsghdr *cmsg;
> +	char buf[CMSG_SPACE(sizeof(int))] = {0}, c = 'c';
> +	struct iovec io = {
> +		.iov_base = &c,
> +		.iov_len = 1,
> +	};
> +
> +	msg.msg_iov = &io;
> +	msg.msg_iovlen = 1;
> +	msg.msg_control = buf;
> +	msg.msg_controllen = sizeof(buf);
> +	cmsg = CMSG_FIRSTHDR(&msg);
> +	cmsg->cmsg_level = SOL_SOCKET;
> +	cmsg->cmsg_type = SCM_RIGHTS;
> +	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
> +	*((int *)CMSG_DATA(cmsg)) = fd;
> +	msg.msg_controllen = cmsg->cmsg_len;
> +
> +	if (sendmsg(sock, &msg, 0) < 0) {
> +		perror("sendmsg");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int recv_fd(int sock)
> +{
> +	struct msghdr msg = {};
> +	struct cmsghdr *cmsg;
> +	char buf[CMSG_SPACE(sizeof(int))] = {0}, c = 'c';
> +	struct iovec io = {
> +		.iov_base = &c,
> +		.iov_len = 1,
> +	};
> +
> +	msg.msg_iov = &io;
> +	msg.msg_iovlen = 1;
> +	msg.msg_control = buf;
> +	msg.msg_controllen = sizeof(buf);
> +
> +	if (recvmsg(sock, &msg, 0) < 0) {
> +		perror("recvmsg");
> +		return -1;
> +	}
> +
> +	cmsg = CMSG_FIRSTHDR(&msg);
> +
> +	return *((int *)CMSG_DATA(cmsg));
> +}
> +
> +static int user_trap_syscall(int nr, unsigned int flags)
> +{
> +	struct sock_filter filter[] = {
> +		BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
> +			offsetof(struct seccomp_data, nr)),
> +		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, nr, 0, 1),
> +		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_USER_NOTIF),
> +		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
> +	};
> +
> +	struct sock_fprog prog = {
> +		.len = (unsigned short)ARRAY_SIZE(filter),
> +		.filter = filter,
> +	};
> +
> +	return seccomp(SECCOMP_SET_MODE_FILTER, flags, &prog);
> +}
> +
> +static int handle_req(struct seccomp_notif *req,
> +		      struct seccomp_notif_resp *resp, int listener)
> +{
> +	char path[PATH_MAX], source[PATH_MAX], target[PATH_MAX];
> +	int ret = -1, mem;
> +
> +	resp->id = req->id;
> +	resp->error = -EPERM;
> +	resp->val = 0;
> +
> +	if (req->data.nr != __NR_mount) {
> +		fprintf(stderr, "huh? trapped something besides mknod? %d\n", req->data.nr);

'besides mount' ?
