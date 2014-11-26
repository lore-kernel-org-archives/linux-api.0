From: Andrew Jones <drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
Date: Wed, 26 Nov 2014 17:40:58 +0100
Message-ID: <20141126164057.GE3245@hawk.usersys.redhat.com>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1416931805-23223-6-git-send-email-alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 25, 2014 at 04:10:03PM +0000, Alex Benn=E9e wrote:
> This adds support for single-stepping the guest. As userspace can and
> will manipulate guest registers before restarting any tweaking of the
> registers has to occur just before control is passed back to the gues=
t.
> Furthermore while guest debugging is in effect we need to squash the
> ability of the guest to single-step itself as we have no easy way of
> re-entering the guest after the exception has been delivered to the
> hypervisor.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>=20
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 48d26bb..a76daae 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -38,6 +38,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/cacheflush.h>
>  #include <asm/virt.h>
> +#include <asm/debug-monitors.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
> @@ -300,6 +301,17 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arm_set_running_vcpu(NULL);
>  }
> =20
> +/**
> + * kvm_arch_vcpu_ioctl_set_guest_debug - Setup guest debugging
> + * @kvm:	pointer to the KVM struct
> + * @kvm_guest_debug: the ioctl data buffer
> + *
> + * This sets up the VM for guest debugging. Care has to be taken whe=
n
> + * manipulating guest registers as these will be set/cleared by the
> + * hyper-visor controller, typically before each kvm_run event. As a
> + * result modification of the guest registers needs to take place
> + * after they have been restored in the hyp.S trampoline code.
> + */
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
>  {
> @@ -317,8 +329,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kv=
m_vcpu *vcpu,
> =20
>  	/* Single Step */
>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> -		kvm_info("SS requested, not yet implemented\n");
> -		return -EINVAL;
> +		kvm_info("SS requested\n");
> +		route_el2 =3D true;
>  	}
> =20
>  	/* Software Break Points */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-=
offsets.c
> index 8da1043..78e5ae1 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -121,6 +121,7 @@ int main(void)
>    DEFINE(VCPU_FAR_EL2,		offsetof(struct kvm_vcpu, arch.fault.far_el2=
));
>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_=
el2));
>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flag=
s));
> +  DEFINE(GUEST_DEBUG,		offsetof(struct kvm_vcpu, guest_debug));
>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>    DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exi=
t.c
> index 28dc92b..6def054 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -91,6 +91,25 @@ static int kvm_handle_bkpt(struct kvm_vcpu *vcpu, =
struct kvm_run *run)
>  	return 0;
>  }
> =20
> +/**
> + * kvm_handle_ss - handle single step exceptions
> + *
> + * @vcpu:	the vcpu pointer

same @run comment as other handler header in previous patch

> + *
> + * See: ARM ARM D2.12 for the details. While the host is routing deb=
ug
> + * exceptions to it's handlers we have to suppress the ability of th=
e
> + * guest to trigger exceptions.
> + */
> +static int kvm_handle_ss(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	WARN_ON(!(vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP));

I'm not sure about this WARN_ON. Is there some scenario you were
thinking of when you put it here? Is there some scenario where this
could trigger so frequently we kill the log buffer?

> +
> +	run->exit_reason =3D KVM_EXIT_DEBUG;
> +	run->debug.arch.exit_type =3D KVM_DEBUG_EXIT_SINGLE_STEP;
> +	run->debug.arch.address =3D *vcpu_pc(vcpu);
> +	return 0;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_EL2_EC_WFI]	=3D kvm_handle_wfx,
>  	[ESR_EL2_EC_CP15_32]	=3D kvm_handle_cp15_32,
> @@ -105,6 +124,7 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_EL2_EC_SYS64]	=3D kvm_handle_sys_reg,
>  	[ESR_EL2_EC_IABT]	=3D kvm_handle_guest_abort,
>  	[ESR_EL2_EC_DABT]	=3D kvm_handle_guest_abort,
> +	[ESR_EL2_EC_SOFTSTP]    =3D kvm_handle_ss,
>  	[ESR_EL2_EC_BKPT32]	=3D kvm_handle_bkpt,
>  	[ESR_EL2_EC_BRK64]	=3D kvm_handle_bkpt,
>  };
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 3c733ea..c0bc218 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -16,6 +16,7 @@
>   */
> =20
>  #include <linux/linkage.h>
> +#include <linux/kvm.h>
> =20
>  #include <asm/assembler.h>
>  #include <asm/memory.h>
> @@ -168,6 +169,31 @@
>  	// x19-x29, lr, sp*, elr*, spsr*
>  	restore_common_regs
> =20
> +	// After restoring the guest registers but before we return to the =
guest
> +	// we may want to make some final tweaks to support guest debugging=
=2E
> +	ldr	x3, [x0, #GUEST_DEBUG]
> +	tbz	x3, #KVM_GUESTDBG_ENABLE_SHIFT, 2f	// No guest debug
> +
> +	// x0 - preserved as VCPU ptr
> +	// x1 - spsr
> +	// x2 - mdscr
> +	mrs	x1, spsr_el2
> +	mrs 	x2, mdscr_el1
> +
> +	// See ARM ARM D2.12.3 The software step state machine
> +	// If we are doing Single Step - set MDSCR_EL1.SS and PSTATE.SS
> +	orr	x1, x1, #DBG_SPSR_SS
> +	orr	x2, x2, #DBG_MDSCR_SS
> +	tbnz	x3, #KVM_GUESTDBG_SINGLESTEP_SHIFT, 1f
> +	// If we are not doing Single Step we want to prevent the guest doi=
ng so
> +	// as otherwise we will have to deal with the re-routed exceptions =
as we
> +	// are doing other guest debug related things
> +	eor	x1, x1, #DBG_SPSR_SS
> +	eor	x2, x2, #DBG_MDSCR_SS
> +1:
> +	msr	spsr_el2, x1
> +	msr	mdscr_el1, x2
> +2:
>  	// Last bits of the 64bit state
>  	pop	x2, x3
>  	pop	x0, x1
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 523f476..347e5b0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -7,6 +7,8 @@
>   * Note: you must update KVM_API_VERSION if you change this interfac=
e.
>   */
> =20
> +#ifndef __ASSEMBLY__
> +
>  #include <linux/types.h>
>  #include <linux/compiler.h>
>  #include <linux/ioctl.h>
> @@ -515,11 +517,6 @@ struct kvm_s390_irq {
>  	} u;
>  };
> =20
> -/* for KVM_SET_GUEST_DEBUG */
> -
> -#define KVM_GUESTDBG_ENABLE		0x00000001
> -#define KVM_GUESTDBG_SINGLESTEP		0x00000002
> -
>  struct kvm_guest_debug {
>  	__u32 control;
>  	__u32 pad;
> @@ -1189,4 +1186,15 @@ struct kvm_assigned_msix_entry {
>  	__u16 padding[3];
>  };
> =20
> +#endif /* __ASSEMBLY__ */
> +
> +/* for KVM_SET_GUEST_DEBUG */
> +
> +#define KVM_GUESTDBG_ENABLE_SHIFT	0
> +#define KVM_GUESTDBG_ENABLE		(1 << KVM_GUESTDBG_ENABLE_SHIFT)
> +#define KVM_GUESTDBG_SINGLESTEP_SHIFT	1
> +#define KVM_GUESTDBG_SINGLESTEP	(1 << KVM_GUESTDBG_SINGLESTEP_SHIFT)

EALIGN: we can tab these defines up better

> +
> +
> +
>  #endif /* __LINUX_KVM_H */
> --=20
> 2.1.3
>=20
> _______________________________________________
> kvmarm mailing list
> kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
