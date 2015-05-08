From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 09/12] KVM: arm64: guest debug, HW assisted debug
 support
Date: Fri, 8 May 2015 18:32:46 +0200
Message-ID: <20150508163246.GI24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430989647-22501-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430989647-22501-2-git-send-email-alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>open lis
List-Id: linux-api@vger.kernel.org

On Thu, May 07, 2015 at 10:07:12AM +0100, Alex Benn=E9e wrote:
> This adds support for userspace to control the HW debug registers for
> guest debug. In the debug ioctl we copy the IMPDEF defined number of
> registers into a new register set called host_debug_state. There is n=
ow
> a new vcpu parameter called debug_ptr which selects which register se=
t
> is to copied into the real registers when world switch occurs.
>=20
> I've moved some helper functions into the hw_breakpoint.h header for
> re-use.
>=20
> As with single step we need to tweak the guest registers to enable th=
e
> exceptions so we need to save and restore those bits.
>=20
> Two new capabilities have been added to the KVM_EXTENSION ioctl to al=
low
> userspace to query the number of hardware break and watch points
> available on the host hardware.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>=20
> ---
> v2
>    - switched to C setup
>    - replace host debug registers directly into context
>    - minor tweak to api docs
>    - setup right register for debug
>    - add FAR_EL2 to debug exit structure
>    - add support for trapping debug register access
> v3
>    - remove stray trace statement
>    - fix spacing around operators (various)
>    - clean-up usage of trap_debug
>    - introduce debug_ptr, replace excessive memcpy stuff
>    - don't use memcpy in ioctl, just assign
>    - update cap ioctl documentation
>    - reword a number comments
>    - rename host_debug_state->external_debug_state
>=20
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> index 5ef937c..419f7a8 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2668,7 +2668,7 @@ The top 16 bits of the control field are archit=
ecture specific control
>  flags which can include the following:
> =20
>    - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86, arm=
64]
> -  - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s39=
0]
> +  - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s39=
0, arm64]
>    - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
>    - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
>    - KVM_GUESTDBG_EXIT_PENDING:  trigger an immediate guest exit [s39=
0]
> @@ -2683,6 +2683,11 @@ updated to the correct (supplied) values.
>  The second part of the structure is architecture specific and
>  typically contains a set of debug registers.
> =20
> +For arm64 the number of debug registers is implementation defined an=
d
> +can be determined by querying the KVM_CAP_GUEST_DEBUG_HW_BPS and
> +KVM_CAP_GUEST_DEBUG_HW_WPS capabilities which returns a +ve number

s/returns/return/
s/+ve/positive/

> +indicating the number of supported registers.
> +
>  When debug events exit the main run loop with the reason
>  KVM_EXIT_DEBUG with the kvm_debug_exit_arch part of the kvm_run
>  structure containing architecture specific debug information.
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 9b3ed6d..2920185 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -279,6 +279,10 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	/* Set up the timer */
>  	kvm_timer_vcpu_init(vcpu);
> =20
> +	/* Set the debug registers to be the guests */
> +	vcpu->arch.debug_ptr =3D (struct kvm_guest_debug_arch *)
> +				&vcpu_sys_reg(vcpu, DBGBCR0_EL1);
> +

yikes, I don't like this cast, how bad is it to get rid of the debug
registers in the sys_regs array ?

Also, pretty sure this is part of the breakage for the 32-bit build...

>  	return 0;
>  }
> =20
> @@ -304,6 +308,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> =20
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE |    \
>  			    KVM_GUESTDBG_USE_SW_BP | \
> +			    KVM_GUESTDBG_USE_HW_BP | \
>  			    KVM_GUESTDBG_SINGLESTEP)
> =20
>  /**
> @@ -324,6 +329,12 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct k=
vm_vcpu *vcpu,
> =20
>  	if (dbg->control & KVM_GUESTDBG_ENABLE) {
>  		vcpu->guest_debug =3D dbg->control;
> +
> +		/* Hardware assisted Break and Watch points */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {

is this only breakpoints or breakpoints and watch points?

> +			vcpu->arch.external_debug_state =3D dbg->arch;
> +		}
> +
>  	} else {
>  		/* If not enabled clear all flags */
>  		vcpu->guest_debug =3D 0;
> diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/incl=
ude/asm/hw_breakpoint.h
> index 52b484b..c450552 100644
> --- a/arch/arm64/include/asm/hw_breakpoint.h
> +++ b/arch/arm64/include/asm/hw_breakpoint.h
> @@ -130,6 +130,18 @@ static inline void ptrace_hw_copy_thread(struct =
task_struct *task)
>  }
>  #endif
> =20
> +/* Determine number of BRP registers available. */
> +static inline int get_num_brps(void)
> +{
> +	return ((read_cpuid(ID_AA64DFR0_EL1) >> 12) & 0xf) + 1;
> +}
> +
> +/* Determine number of WRP registers available. */
> +static inline int get_num_wrps(void)
> +{
> +	return ((read_cpuid(ID_AA64DFR0_EL1) >> 20) & 0xf) + 1;
> +}
> +

I will need an ack from Catalin/Will to merge this.  It may be better t=
o
move these functions in a separate patch.

>  extern struct pmu perf_ops_bp;
> =20
>  #endif	/* __KERNEL__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> index b60fa7a..a44fb32 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -108,9 +108,18 @@ struct kvm_vcpu_arch {
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
> =20
> -	/* Debug state */
> +	/* Guest debug state */
>  	u64 debug_flags;
> =20
> +	/*
> +	 * For debugging the guest we need to keep a set of debug
> +	 * registers which can override the guests own debug state

s/guests/guest's/

> +	 * while being used. These are set via the KVM_SET_GUEST_DEBUG
> +	 * ioctl.
> +	 */
> +	struct kvm_guest_debug_arch *debug_ptr;
> +	struct kvm_guest_debug_arch external_debug_state;
> +
>  	/* Pointer to host CPU context */
>  	kvm_cpu_context_t *host_cpu_context;
> =20
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/u=
api/asm/kvm.h
> index 04957d7..98e82ef 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -121,7 +121,7 @@ struct kvm_guest_debug_arch {
> =20
>  struct kvm_debug_exit_arch {
>  	__u32 hsr;
> -	__u64 far;
> +	__u64 far;	/* used for watchpoints */

seems strange to amend this now?

>  };
> =20
>  struct kvm_sync_regs {
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-=
offsets.c
> index ce7b7dd..671ab13 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -116,6 +116,7 @@ int main(void)
>    DEFINE(VCPU_FAR_EL2,		offsetof(struct kvm_vcpu, arch.fault.far_el2=
));
>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_=
el2));
>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flag=
s));
> +  DEFINE(VCPU_DEBUG_PTR,	offsetof(struct kvm_vcpu, arch.debug_ptr));
>    DEFINE(DEBUG_BCR, 		offsetof(struct kvm_guest_debug_arch, dbg_bcr)=
);
>    DEFINE(DEBUG_BVR, 		offsetof(struct kvm_guest_debug_arch, dbg_bvr)=
);
>    DEFINE(DEBUG_WCR, 		offsetof(struct kvm_guest_debug_arch, dbg_wcr)=
);
> diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw=
_breakpoint.c
> index e7d934d..3a41bbf 100644
> --- a/arch/arm64/kernel/hw_breakpoint.c
> +++ b/arch/arm64/kernel/hw_breakpoint.c
> @@ -49,18 +49,6 @@ static DEFINE_PER_CPU(int, stepping_kernel_bp);
>  static int core_num_brps;
>  static int core_num_wrps;
> =20
> -/* Determine number of BRP registers available. */
> -static int get_num_brps(void)
> -{
> -	return ((read_cpuid(ID_AA64DFR0_EL1) >> 12) & 0xf) + 1;
> -}
> -
> -/* Determine number of WRP registers available. */
> -static int get_num_wrps(void)
> -{
> -	return ((read_cpuid(ID_AA64DFR0_EL1) >> 20) & 0xf) + 1;
> -}
> -
>  int hw_breakpoint_slots(int type)
>  {
>  	/*
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 19346e8..1ab63dd 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -99,12 +99,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  				MDCR_EL2_TDRA |
>  				MDCR_EL2_TDOSA);
> =20
> -	/* Trap on access to debug registers? */
> -	if (trap_debug)
> -		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
> -	else
> -		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
> -
>  	/* Is Guest debugging in effect? */
>  	if (vcpu->guest_debug) {
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
> @@ -128,14 +122,54 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
>  		}
> =20
> +		/*
> +		 * HW Break/Watch points
> +		 *
> +		 * We simply switch the debug_ptr to point to our new
> +		 * external_debug_state which has been populated by the
> +		 * debug ioctl. The existing KVM_ARM64_DEBUG_DIRTY
> +		 * mechanism ensures the registers are updated on the
> +		 * world switch.
> +		 */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +
> +			vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
> +				(DBG_MDSCR_KDE | DBG_MDSCR_MDE);

Why do we need to set these two bits?  Is it obvious or does it deserve
a comment?

> +
> +			vcpu->arch.debug_ptr =3D &vcpu->arch.external_debug_state;
> +			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +			trap_debug =3D true;
> +		}
> +
>  	} else {
>  		/* Debug operations can go straight to the guest */
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;
>  	}
> +
> +	/*
> +	 * If the guest debug register state is dirty (the guest is
> +	 * actively accessing them), then we context-switch the
> +	 * registers in EL2. Otherwise, we trap-and-emulate all guest
> +	 * accesses to them.
> +	 */

I think this comment now feels strange, because it was explaining why w=
e
would set the trap_debug variable when the dirty flag was set, but the
code just sets TDA when trap_debug is set.  So you should either move
this comment to the top of the function and have it above a separate
line that sets trap_debug based on KVM_ARM64_DEBUG_DIRTY (instead of
initializing at declaration), or you should explain which conditions se=
t
trap_debug (guest is using the regs or we are debugging the guest), or
just get rid of the comment.

> +	if (trap_debug)
> +		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
> +	else
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;

still don't need the else.

>  }
> =20
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  {
> -	if (vcpu->guest_debug)
> +	if (vcpu->guest_debug) {
>  		restore_guest_debug_regs(vcpu);
> +
> +		/*
> +		 * If we were using HW debug we need to restore the
> +		 * debug_ptr to the guest debug state.
> +		 */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +			vcpu->arch.debug_ptr =3D (struct kvm_guest_debug_arch *)
> +				&vcpu_sys_reg(vcpu, DBGBCR0_EL1);
> +		}

I would find it easier to follow the code if you only configure the
debug_ptr in kvm_arm_setup_debug() because it feels like you're setting
up state here which will not be used before in a very long time (after
handle_exit, exit to userspace etc.).

> +	}
>  }
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exi=
t.c
> index e9de13e..68a0759 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -103,7 +103,11 @@ static int kvm_handle_guest_debug(struct kvm_vcp=
u *vcpu, struct kvm_run *run)
>  	run->debug.arch.hsr =3D hsr;
> =20
>  	switch (hsr >> ESR_ELx_EC_SHIFT) {
> +	case ESR_ELx_EC_WATCHPT_LOW:
> +		run->debug.arch.far =3D vcpu->arch.fault.far_el2;
> +		/* fall through */
>  	case ESR_ELx_EC_SOFTSTP_LOW:
> +	case ESR_ELx_EC_BREAKPT_LOW:
>  	case ESR_ELx_EC_BKPT32:
>  	case ESR_ELx_EC_BRK64:
>  		break;
> @@ -132,6 +136,8 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
>  	[ESR_ELx_EC_SOFTSTP_LOW]=3D kvm_handle_guest_debug,
> +	[ESR_ELx_EC_WATCHPT_LOW]=3D kvm_handle_guest_debug,
> +	[ESR_ELx_EC_BREAKPT_LOW]=3D kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
>  };
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index dd51fb1..921d248 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -706,7 +706,8 @@ ENTRY(__kvm_vcpu_run)
>  	bl __restore_fpsimd
> =20
>  	skip_debug_state x3, 1f
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> +	ldr	x3, [x0, #VCPU_DEBUG_PTR]
> +	kern_hyp_va x3
>  	bl	__restore_debug
>  1:
>  	restore_guest_32bit_state
> @@ -727,7 +728,8 @@ __kvm_vcpu_return:
>  	bl __save_sysregs
> =20
>  	skip_debug_state x3, 1f
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> +	ldr	x3, [x0, #VCPU_DEBUG_PTR]
> +	kern_hyp_va x3
>  	bl	__save_debug
>  1:
>  	save_guest_32bit_state
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 0b43265..21d5a62 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -56,6 +56,12 @@ static bool cpu_has_32bit_el1(void)
>  	return !!(pfr0 & 0x20);
>  }
> =20
> +/**
> + * kvm_arch_dev_ioctl_check_extension
> + *
> + * We currently assume that the number of HW registers is uniform
> + * across all CPUs (see cpuinfo_sanity_check).
> + */
>  int kvm_arch_dev_ioctl_check_extension(long ext)
>  {
>  	int r;
> @@ -64,6 +70,12 @@ int kvm_arch_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_ARM_EL1_32BIT:
>  		r =3D cpu_has_32bit_el1();
>  		break;
> +	case KVM_CAP_GUEST_DEBUG_HW_BPS:
> +		r =3D get_num_brps();
> +		break;
> +	case KVM_CAP_GUEST_DEBUG_HW_WPS:
> +		r  =3D get_num_wrps();
> +		break;
>  	default:
>  		r =3D 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3b6252e..923c2aa 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -825,6 +825,8 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_S390_INJECT_IRQ 113
>  #define KVM_CAP_S390_IRQ_STATE 114
>  #define KVM_CAP_PPC_HWRNG 115
> +#define KVM_CAP_GUEST_DEBUG_HW_BPS 116
> +#define KVM_CAP_GUEST_DEBUG_HW_WPS 117
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
> --=20
> 2.3.5
>=20
Thanks,
-Christoffer
