From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v7 6/6] x86/arch_prctl: Add ARCH_[GET|SET]_CPUID
Date: Thu, 27 Oct 2016 15:34:53 -0700
Message-ID: <CALCETrUXCA+-gWxvAVJf=zRPFP=_t600pdVPC44SFL5v_YxOMQ@mail.gmail.com>
References: <20161019020333.3766-1-khuey@kylehuey.com> <20161019020333.3766-7-khuey@kylehuey.com>
 <alpine.DEB.2.20.1610271022030.4817@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1610271022030.4817@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>, Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <user-mode-linux-dev>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 27, 2016 at 4:15 AM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> This is insane. The compiler makes that a conditional jump and then in
> switch_cpuid_faulting we get another one. Further switch_cpuid_faulting()
> calls into lib/msr which is adding even more overhead.
>
> msr_set/clear_bit() are nice for random driver code, but complete overkill
> for the context switch hotpath.
>
> That's just not acceptable for switch_to(). We keep adding cruft and then
> wonder why context switches slow down despite machines getting faster.
>
> This can and needs to be done smarter. See untested patch below. The
> resulting code has a single conditional jump, which is obviously the check
> for a change between prev and next. Everything else is done with straight
> linear shift,add,and,rdmsr,wrmsr instructions.
>

...

>  #define MSR_IA32_SYSENTER_ESP          0x00000175
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -193,12 +193,17 @@ int set_tsc_mode(unsigned int val)
>         return 0;
>  }
>
> -static void switch_cpuid_faulting(bool on)
> +#define CPUID_FAULT_ON_MASK    (~0ULL)
> +#define CPUID_FAULT_OFF_MASK   (~CPUID_FAULT_ENABLE)
> +
> +static void cpuid_fault_ctrl(u64 msk)
>  {
> -       if (on)
> -               msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);
> -       else
> -               msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
> +       u64 msrval;
> +
> +       rdmsrl(MSR_MISC_FEATURES_ENABLES, msrval);
> +       msrval |= CPUID_FAULT_ENABLE;
> +       msrval &= msk;
> +       wrmsrl(MSR_MISC_FEATURES_ENABLES, msrval);
>  }

Let's just do this right from day one:

static void set_cpuid_faulting(bool on)
{
  u64 msrval;

  DEBUG_LOCKS_WARN_ON(!irqs_disabled());

  msrval = this_cpu_read(msr_misc_features_enables_shadow);
  msrval &= CPUID_FAULT_ENABLE;
  msrval |= (on << CPUID_FAULT_ENABLE_BIT);
  this_cpu_write(msr_misc_features_enables_shadow, msrval);
  wrmsrl(MSR_MISC_FEATURES_ENABLES, msrval);
}

RDMSR may be considerably faster than WRMSR, but that doesn't mean it's *fast*.

Obviously this needs some initialization code, but that's fine IMO.

--Andy
