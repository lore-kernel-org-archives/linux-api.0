From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH] ptrace: add PTRACE_GETFD request
Date: Fri, 6 Dec 2019 12:45:40 -0800
Message-ID: <4C3DA0D9-EF86-42E5-B80E-94EA9F7ED944@amacapital.net>
References: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, tycho@tycho.ws
List-Id: linux-api@vger.kernel.org


> On Dec 5, 2019, at 3:44 PM, Sargun Dhillon <sargun@sargun.me> wrote:
>=20
> =EF=BB=BFPTRACE_GETFD is a generic ptrace API that allows the tracer to
> get file descriptors from the traceee.
>=20
> The primary reason to use this syscall is to allow sandboxers to
> take action on an FD on behalf of the tracee. For example, this
> can be combined with seccomp's user notification feature to extract
> a file descriptor and call privileged syscalls, like binding
> a socket to a privileged port.

Can you document the circumstances under which you can call this?

Does it require that you be attached as a tracer?  Does the tracee need to b=
e stopped?  Does it work equivalently if the tracee is ptrace-stopped vs sto=
pped by seccomp?

If the tracee is running and is single-threaded, is the locking correct?

>=20
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
> include/uapi/linux/ptrace.h |  5 +++++
> kernel/ptrace.c             | 39 +++++++++++++++++++++++++++++++++++--
> 2 files changed, 42 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
> index a71b6e3b03eb..2b69f759826a 100644
> --- a/include/uapi/linux/ptrace.h
> +++ b/include/uapi/linux/ptrace.h
> @@ -101,6 +101,11 @@ struct ptrace_syscall_info {
>    };
> };
>=20
> +/* This gets a file descriptor from a running process. It doesn't require=
 the
> + * process to be stopped.
> + */
> +#define PTRACE_GETFD    0x420f
> +
> /*
>  * These values are stored in task->ptrace_message
>  * by tracehook_report_syscall_* to describe the current syscall-stop.
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index cb9ddcc08119..a1d7b289fe8e 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -31,6 +31,7 @@
> #include <linux/cn_proc.h>
> #include <linux/compat.h>
> #include <linux/sched/signal.h>
> +#include <linux/fdtable.h>
>=20
> #include <asm/syscall.h>    /* for syscall_get_* */
>=20
> @@ -994,6 +995,37 @@ ptrace_get_syscall_info(struct task_struct *child, un=
signed long user_size,
> }
> #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
>=20
> +static int ptrace_getfd(struct task_struct *child, unsigned long fd)
> +{
> +    struct files_struct *files;
> +    struct file *file;
> +    int ret =3D 0;
> +
> +    files =3D get_files_struct(child);
> +    if (!files)
> +        return -ENOENT;
> +
> +    spin_lock(&files->file_lock);
> +    file =3D fcheck_files(files, fd);
> +    if (!file)
> +        ret =3D -EBADF;
> +    else
> +        get_file(file);
> +    spin_unlock(&files->file_lock);
> +    put_files_struct(files);
> +
> +    if (ret)
> +        goto out;
> +
> +    ret =3D get_unused_fd_flags(0);
> +    if (ret >=3D 0)
> +        fd_install(ret, file);
> +
> +    fput(file);
> +out:
> +    return ret;
> +}
> +
> int ptrace_request(struct task_struct *child, long request,
>           unsigned long addr, unsigned long data)
> {
> @@ -1222,7 +1254,9 @@ int ptrace_request(struct task_struct *child, long r=
equest,
>    case PTRACE_SECCOMP_GET_METADATA:
>        ret =3D seccomp_get_metadata(child, addr, datavp);
>        break;
> -
> +    case PTRACE_GETFD:
> +        ret =3D ptrace_getfd(child, data);
> +        break;
>    default:
>        break;
>    }
> @@ -1265,7 +1299,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, un=
signed long, addr,
>    }
>=20
>    ret =3D ptrace_check_attach(child, request =3D=3D PTRACE_KILL ||
> -                  request =3D=3D PTRACE_INTERRUPT);
> +                  request =3D=3D PTRACE_INTERRUPT ||
> +                  request =3D=3D PTRACE_GETFD);
>    if (ret < 0)
>        goto out_put_task_struct;
>=20
> --=20
> 2.20.1
>=20
