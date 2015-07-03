From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v7 09/11] KVM: arm64: guest debug, HW assisted debug
 support
Date: Fri, 3 Jul 2015 10:23:23 +0100
Message-ID: <20150703092323.GA1588@arm.com>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
 <1435775343-20034-10-git-send-email-alex.bennee@linaro.org>
 <20150702084847.GB3418@arm.com>
 <87pp4asm6u.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87pp4asm6u.fsf@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "r65777@freescale.com" <r65777@freescale.com>, "bp@suse.de" <bp@suse.de>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <Catalin.Marinas@arm.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Ingo Molnar <mingo@kernel.o>
List-Id: linux-api@vger.kernel.org

Hi Alex,

On Thu, Jul 02, 2015 at 02:50:33PM +0100, Alex Benn=E9e wrote:
> Are you happy with this?:

[...]

> +/**
> + * kvm_arch_dev_ioctl_check_extension
> + *
> + * We currently assume that the number of HW registers is uniform
> + * across all CPUs (see cpuinfo_sanity_check).
> + */
>  int kvm_arch_dev_ioctl_check_extension(long ext)
>  {
>         int r;
> @@ -64,6 +71,12 @@ int kvm_arch_dev_ioctl_check_extension(long ext)
>         case KVM_CAP_ARM_EL1_32BIT:
>                 r =3D cpu_has_32bit_el1();
>                 break;
> +       case KVM_CAP_GUEST_DEBUG_HW_BPS:
> +               r =3D hw_breakpoint_slots(TYPE_INST);
> +               break;
> +       case KVM_CAP_GUEST_DEBUG_HW_WPS:
> +               r  =3D hw_breakpoint_slots(TYPE_DATA);
> +               break;

Whilst I much prefer this code, it actually adds an unwanted dependency
on PERF_EVENTS that I didn't think about to start with. Sorry to keep
messing you about -- I guess your original patch is the best thing afte=
r
all.

Will
