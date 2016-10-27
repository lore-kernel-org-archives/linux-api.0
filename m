From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v7 6/6] x86/arch_prctl: Add ARCH_[GET|SET]_CPUID
Date: Fri, 28 Oct 2016 00:38:54 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1610280038260.4913@nanos>
References: <20161019020333.3766-1-khuey@kylehuey.com> <20161019020333.3766-7-khuey@kylehuey.com> <alpine.DEB.2.20.1610271022030.4817@nanos> <CALCETrUXCA+-gWxvAVJf=zRPFP=_t600pdVPC44SFL5v_YxOMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUXCA+-gWxvAVJf=zRPFP=_t600pdVPC44SFL5v_YxOMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kyle Huey <me@kylehuey.com>, Robert O'Callahan <robert@ocallahan.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Dmitry Safonov <dsafonov@virtuozzo.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "user-mode-linux-devel@lists.sourceforge.net" <user-mode-linux-devel>
List-Id: linux-api@vger.kernel.org

On Thu, 27 Oct 2016, Andy Lutomirski wrote:
> On Thu, Oct 27, 2016 at 4:15 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Let's just do this right from day one:
> 
> static void set_cpuid_faulting(bool on)
> {
>   u64 msrval;
> 
>   DEBUG_LOCKS_WARN_ON(!irqs_disabled());
> 
>   msrval = this_cpu_read(msr_misc_features_enables_shadow);
>   msrval &= CPUID_FAULT_ENABLE;
>   msrval |= (on << CPUID_FAULT_ENABLE_BIT);
>   this_cpu_write(msr_misc_features_enables_shadow, msrval);
>   wrmsrl(MSR_MISC_FEATURES_ENABLES, msrval);
> }
> 
> RDMSR may be considerably faster than WRMSR, but that doesn't mean it's *fast*.

Good point!
