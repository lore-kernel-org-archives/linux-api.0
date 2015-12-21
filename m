From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCH v1 1/4] um: Fix ptrace GETREGS/SETREGS bugs
Date: Mon, 21 Dec 2015 01:20:51 +0100
Message-ID: <567745E3.1030509@nod.at>
References: <1450656209-2676-1-git-send-email-mic@digikod.net>
 <1450656209-2676-2-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450656209-2676-2-git-send-email-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>, Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>, Anton Ivanov <aivanov-43mecJUBy8ZBDgjK7y7TUQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am 21.12.2015 um 01:03 schrieb Micka=C3=ABl Sala=C3=BCn:
> This fix two related bugs:
> * PTRACE_GETREGS doesn't get the right orig_ax (syscall) value
> * PTRACE_SETREGS can't set the orig_ax value (erased by initial value=
)
>=20
> Remove the now useless and error-prone get_syscall().
>=20
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
> Cc: Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>
> Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
> Cc: Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>
> Cc: Anton Ivanov <aivanov-43mecJUBy8ZBDgjK7y7TUQ@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Cc: user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Cc: Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>
> Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/um/kernel/skas/syscall.c   | 7 ++++++-
>  arch/um/os-Linux/skas/process.c | 7 -------
>  2 files changed, 6 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/sysc=
all.c
> index 1683b8e..65f0d1a 100644
> --- a/arch/um/kernel/skas/syscall.c
> +++ b/arch/um/kernel/skas/syscall.c
> @@ -7,6 +7,7 @@
>  #include <linux/ptrace.h>
>  #include <kern_util.h>
>  #include <sysdep/ptrace.h>
> +#include <sysdep/ptrace_user.h>
>  #include <sysdep/syscalls.h>
>  #include <os.h>
> =20
> @@ -16,12 +17,16 @@ void handle_syscall(struct uml_pt_regs *r)
>  	long result;
>  	int syscall;
> =20
> +	/* Save the syscall register. */
> +	UPT_SYSCALL_NR(r) =3D PT_SYSCALL_NR(r->gp);
> +
>  	if (syscall_trace_enter(regs)) {
>  		result =3D -ENOSYS;
>  		goto out;
>  	}
> =20
> -	syscall =3D get_syscall(r);
> +	/* Get the syscall after being potentially updated with ptrace. */
> +	syscall =3D UPT_SYSCALL_NR(r);

Doesn't this break the support for changing syscall numbers using PTRAC=
E_SETREGS?

Thanks,
//richard
