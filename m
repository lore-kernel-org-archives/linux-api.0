From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 1/3] syscalls,x86 Expose arch_prctl on x86-32.
Date: Fri, 16 Sep 2016 09:50:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1609160847420.5384@nanos>
References: <20160915233324.6060-1-khuey@kylehuey.com> <20160915233324.6060-2-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915233324.6060-2-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Cc: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, Peter Zijlstra <peterz>
List-Id: linux-api@vger.kernel.org

On Thu, 15 Sep 2016, Kyle Huey wrote:

First of all, please add a cover letter [PATCH 0/N] to your patch series
and send it with something which provides proper mail threading. 
See: git-send-email, quilt 

> arch_prctl is currently 64-bit only. Wire it up for 32-bits, as a no-op for
> now. Rename the second arg to a more generic name.

This changelog is useless.

- it does not provide any rationale for this change, i.e. why this is
  required. Just because its 64bit only is not a reason.

- "Rename the second arg to a more generic name" does not give
  any useful information.

Misleading information is worse than no information.

Further your patch does 5 things at once. It wants to be split into parts:

1) Rename do_arch_prctl() and change the argument name,

> -long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
> +long do_arch_prctl_64(struct task_struct *task, int code, unsigned long arg2)

2) Provide do_arch_prctl_common() and hook it up to the arch_prctl syscall

> -long sys_arch_prctl(int code, unsigned long addr)
> +SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
>  {
> -	return do_arch_prctl(current, code, addr);
> +	long ret;
> +
> +	ret = do_arch_prctl_64(current, code, arg2);
> +	if (ret == -EINVAL)
> +		ret = do_arch_prctl_common(current, code, arg2);
> +
> +	return ret;
>  }

3) Implement the compat version
  
Thanks,

	tflx
