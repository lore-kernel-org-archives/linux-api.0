From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v5 3/6] x86/arch_prctl Add a new do_arch_prctl
Date: Thu, 22 Sep 2016 15:19:09 -0700
Message-ID: <CALCETrUnyjg7cKECBRYsBmJRJKnH8indgJ6kwfN6iwfgSfGNeA@mail.gmail.com>
References: <20160921185824.18980-1-khuey@kylehuey.com> <20160921185824.18980-4-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160921185824.18980-4-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Cc: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, user
List-Id: linux-api@vger.kernel.org

On Wed, Sep 21, 2016 at 11:58 AM, Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org> wrote:
> Add a new do_arch_prctl to handle arch_prctls that are not specific to 64
> bits. Call it from the syscall entry point, but not any of the other
> callsites in the kernel, which all want one of the existing 64 bit only
> arch_prctls.
>
> Signed-off-by: Kyle Huey <khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
> ---
>  arch/x86/include/asm/proto.h | 1 +
>  arch/x86/kernel/process.c    | 5 +++++
>  arch/x86/kernel/process_64.c | 8 +++++++-
>  3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
> index 95c3e51..94a57cc 100644
> --- a/arch/x86/include/asm/proto.h
> +++ b/arch/x86/include/asm/proto.h
> @@ -30,6 +30,7 @@ void x86_report_nx(void);
>
>  extern int reboot_force;
>
> +long do_arch_prctl(struct task_struct *task, int code, unsigned long arg2);
>  #ifdef CONFIG_X86_64
>  long do_arch_prctl_64(struct task_struct *task, int code, unsigned long arg2);
>  #endif
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 62c0b0e..97aa104 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -567,3 +567,8 @@ unsigned long get_wchan(struct task_struct *p)
>         } while (count++ < 16 && p->state != TASK_RUNNING);
>         return 0;
>  }
> +
> +long do_arch_prctl(struct task_struct *task, int code, unsigned long arg2)
> +{
> +       return -EINVAL;
> +}

This should be do_arch_prctl_common or similar to avoid confusion.

P.S. The subject should be "x86/arch_prctl: ...".
