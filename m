From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 7/7] KVM: arm64: guest debug, HW assisted debug support
Date: Sun, 30 Nov 2014 11:34:50 +0100
Message-ID: <20141130103450.GJ23653@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-8-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416931805-23223-8-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, pbonzini@redhat.com, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 25, 2014 at 04:10:05PM +0000, Alex Benn=E9e wrote:
> This adds support for userspace to control the HW debug registers for
> guest debug. We'll only copy the $ARCH defined number across as that'=
s
> all that hyp.S will use anyway. I've moved some helper functions into
> the hw_breakpoint.h header for re-use.
>=20
> As with single step we need to tweak the guest registers to enable th=
e
> exceptions but we don't want to overwrite the guest copy of these
> registers so this is done close to the guest entry.
>=20
> Two new capabilities have been added to the KVM_EXTENSION ioctl to al=
low
> userspace to query the number of hardware break and watch points
> available on the host hardware.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> index 9383359..5e8c673 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2593,7 +2593,7 @@ The top 16 bits of the control field are archit=
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
> @@ -2606,7 +2606,10 @@ we need to ensure the guest vCPUs architecture=
 specific registers are
>  updated to the correct (supplied) values.
> =20
>  The second part of the structure is architecture specific and
> -typically contains a set of debug registers.
> +typically contains a set of debug registers. For arm64 the number of

new paragraph for the arch-specific stuff.

> +debug registers is implementation defined and can be determined by
> +querying the KVM_CAP_GUEST_DEBUG_HW_BPS and KVM_CAP_GUEST_DEBUG_HW_W=
PS
> +capabilities.
> =20
>  When debug events exit the main run loop with the reason
>  KVM_EXIT_DEBUG with the kvm_debug_exit_arch part of the kvm_run
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index a76daae..c8ec23a 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -39,6 +39,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/virt.h>
>  #include <asm/debug-monitors.h>
> +#include <asm/hw_breakpoint.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
> @@ -341,8 +342,37 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct k=
vm_vcpu *vcpu,
> =20
>  	/* Hardware assisted Break and Watch points */
>  	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> -		kvm_info("HW BP support requested, not yet implemented\n");
> -		return -EINVAL;
> +		int i;
> +		int nb =3D get_num_brps();
> +		int nw =3D get_num_wrps();
> +
> +		/* Copy across up to IMPDEF debug registers to our

coding style

> +		 * shadow copy in the vcpu structure. The hyp.S code
> +		 * will then set them up before we re-enter the guest.
> +		 */
> +		memcpy(vcpu->arch.guest_debug_regs.dbg_bcr,
> +			dbg->arch.dbg_bcr, sizeof(__u64)*nb);
> +		memcpy(vcpu->arch.guest_debug_regs.dbg_bvr,
> +			dbg->arch.dbg_bvr, sizeof(__u64)*nb);
> +		memcpy(vcpu->arch.guest_debug_regs.dbg_wcr,
> +			dbg->arch.dbg_wcr, sizeof(__u64)*nw);
> +		memcpy(vcpu->arch.guest_debug_regs.dbg_wvr,
> +			dbg->arch.dbg_wvr, sizeof(__u64)*nw);
> +
> +		kvm_info("HW BP support requested\n");
> +		for (i =3D 0; i < nb; i++) {
> +			kvm_info("%d: dbg_bcr=3D0x%llx dbg_bvr=3D0x%llx\n",
> +				 i,
> +				vcpu->arch.guest_debug_regs.dbg_bcr[i],
> +				vcpu->arch.guest_debug_regs.dbg_bvr[i]);
> +		}
> +		for (i =3D 0; i < nw; i++) {
> +			kvm_info("%d: dbg_wcr=3D0x%llx dbg_wvr=3D0x%llx\n",
> +				 i,
> +				 vcpu->arch.guest_debug_regs.dbg_wcr[i],
> +				 vcpu->arch.guest_debug_regs.dbg_wvr[i]);
> +		}
> +		route_el2 =3D true;
>  	}
> =20
>  	/* If we are going to handle any debug exceptions we need to
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
>  extern struct pmu perf_ops_bp;
> =20
>  #endif	/* __KERNEL__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> index 38b0f07..e386bf4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -103,8 +103,9 @@ struct kvm_vcpu_arch {
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
> =20
> -	/* Debug state */
> +	/* Guest debug state */
>  	u64 debug_flags;
> +	struct kvm_guest_debug_arch guest_debug_regs;
> =20
>  	/* Pointer to host CPU context */
>  	kvm_cpu_context_t *host_cpu_context;
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-=
offsets.c
> index 78e5ae1..c9ecfd3 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -122,6 +122,10 @@ int main(void)
>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_=
el2));
>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flag=
s));
>    DEFINE(GUEST_DEBUG,		offsetof(struct kvm_vcpu, guest_debug));
> +  DEFINE(GUEST_DEBUG_BCR,	offsetof(struct kvm_vcpu, arch.guest_debug=
_regs.dbg_bcr));
> +  DEFINE(GUEST_DEBUG_BVR,	offsetof(struct kvm_vcpu, arch.guest_debug=
_regs.dbg_bvr));
> +  DEFINE(GUEST_DEBUG_WCR,	offsetof(struct kvm_vcpu, arch.guest_debug=
_regs.dbg_wcr));
> +  DEFINE(GUEST_DEBUG_WVR,	offsetof(struct kvm_vcpu, arch.guest_debug=
_regs.dbg_wvr));
>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>    DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
> diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw=
_breakpoint.c
> index df1cf15..45dcc6f 100644
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
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exi=
t.c
> index 6def054..d024e47 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -110,6 +110,42 @@ static int kvm_handle_ss(struct kvm_vcpu *vcpu, =
struct kvm_run *run)
>  	return 0;
>  }
> =20
> +/**
> + * kvm_handle_hw_bp - handle HW assisted break point
> + *
> + * @vcpu:	the vcpu pointer
> + *
> + */
> +static int kvm_handle_hw_bp(struct kvm_vcpu *vcpu, struct kvm_run *r=
un)
> +{
> +	WARN_ON(!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP));
> +
> +	run->exit_reason =3D KVM_EXIT_DEBUG;
> +	run->debug.arch.exit_type =3D KVM_DEBUG_EXIT_HW_BKPT;
> +	run->debug.arch.address =3D *vcpu_pc(vcpu);
> +	return 0;
> +}
> +
> +/**
> + * kvm_handle_watch - handle HW assisted watch point
> + *
> + * @vcpu:	the vcpu pointer
> + *
> + * These are basically the same as breakpoints (and indeed may use t=
he
> + * breakpoint in a linked fashion). However they generate a specific
> + * exception so we trap it here for reporting to the guest.
> + *
> + */
> +static int kvm_handle_watch(struct kvm_vcpu *vcpu, struct kvm_run *r=
un)
> +{
> +	WARN_ON(!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP));
> +
> +	run->exit_reason =3D KVM_EXIT_DEBUG;
> +	run->debug.arch.exit_type =3D KVM_DEBUG_EXIT_HW_WTPT;
> +	run->debug.arch.address =3D *vcpu_pc(vcpu);
> +	return 0;
> +}

the usual comments about the @run documentation and let's get rid of al=
l
these WARN_ON() statements.

> +
>  static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_EL2_EC_WFI]	=3D kvm_handle_wfx,
>  	[ESR_EL2_EC_CP15_32]	=3D kvm_handle_cp15_32,
> @@ -125,6 +161,8 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_EL2_EC_IABT]	=3D kvm_handle_guest_abort,
>  	[ESR_EL2_EC_DABT]	=3D kvm_handle_guest_abort,
>  	[ESR_EL2_EC_SOFTSTP]    =3D kvm_handle_ss,
> +	[ESR_EL2_EC_WATCHPT]	=3D kvm_handle_watch,
> +	[ESR_EL2_EC_BREAKPT]	=3D kvm_handle_hw_bp,
>  	[ESR_EL2_EC_BKPT32]	=3D kvm_handle_bkpt,
>  	[ESR_EL2_EC_BRK64]	=3D kvm_handle_bkpt,
>  };
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index b38ce3d..96f71ab 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -18,6 +18,7 @@
>  #include <linux/linkage.h>
>  #include <linux/kvm.h>
> =20
> +#include <uapi/asm/kvm.h>
>  #include <asm/assembler.h>
>  #include <asm/memory.h>
>  #include <asm/asm-offsets.h>
> @@ -174,6 +175,7 @@
>  	ldr	x3, [x0, #GUEST_DEBUG]
>  	tbz	x3, #KVM_GUESTDBG_ENABLE_SHIFT, 2f	// No guest debug
> =20
> +	// Both Step and HW BP/WP ops need to modify spsr_el2 and mdscr_el1
>  	// x0 - preserved as VCPU ptr
>  	// x1 - spsr
>  	// x2 - mdscr
> @@ -191,6 +193,11 @@
>  	eor	x1, x1, #DBG_SPSR_SS
>  	eor	x2, x2, #DBG_MDSCR_SS
>  1:
> +	// If we are doing HW BP/WP - set MDSCR_EL1.KDE/MDE
> +	tbz	x3, #KVM_GUESTDBG_USE_HW_BP_SHIFT, 3f
> +	orr	x2, x2, #DBG_MDSCR_KDE
> +	orr	x2, x2, #DBG_MDSCR_MDE
> +3:
>  	msr	spsr_el2, x1
>  	msr	mdscr_el1, x2
>  2:
> @@ -815,6 +822,33 @@ __restore_debug:
> =20
>  	ret
> =20
> +/* Setup debug state for debug of guest */
> +__setup_debug:
> +	// x0: vcpu base address
> +	// x3: ptr to guest registers passed to setup_debug_registers
> +	// x5..x20/x26: trashed
> +
> +	mrs	x26, id_aa64dfr0_el1
> +	ubfx	x24, x26, #12, #4	// Extract BRPs
> +	ubfx	x25, x26, #20, #4	// Extract WRPs
> +	mov	w26, #15
> +	sub	w24, w26, w24		// How many BPs to skip
> +	sub	w25, w26, w25		// How many WPs to skip
> +
> +	mov     x4, x24
> +	add	x3, x0, #GUEST_DEBUG_BCR
> +	setup_debug_registers dbgbcr
> +	add	x3, x0, #GUEST_DEBUG_BVR
> +	setup_debug_registers dbgbvr
> +
> +	mov     x4, x25
> +	add	x3, x0, #GUEST_DEBUG_WCR
> +	setup_debug_registers dbgwcr
> +	add	x3, x0, #GUEST_DEBUG_WVR
> +	setup_debug_registers dbgwvr
> +
> +	ret
> +
>  __save_fpsimd:
>  	save_fpsimd
>  	ret
> @@ -861,6 +895,13 @@ ENTRY(__kvm_vcpu_run)
>  	bl __restore_sysregs
>  	bl __restore_fpsimd
> =20
> +        // Now is the time to set-up the debug registers if we
> +        // are debugging the guest
> +	ldr	x3, [x0, #GUEST_DEBUG]
> +	tbz	x3, #KVM_GUESTDBG_USE_HW_BP_SHIFT, 2f
> +	bl	__setup_debug
> +	b	1f
> +2:
>  	skip_debug_state x3, 1f
>  	bl	__restore_debug
>  1:
> @@ -881,6 +922,11 @@ __kvm_vcpu_return:
>  	bl __save_fpsimd
>  	bl __save_sysregs
> =20
> +	// If we are debugging the guest don't save debug registers
> +	// otherwise we'll be trashing are only good copy we have.
> +	ldr	x3, [x0, #GUEST_DEBUG]
> +	tbnz	x3, #KVM_GUESTDBG_USE_HW_BP_SHIFT, 1f
> +

we're introducing an awful lot of conditionals in the assembly code wit=
h
these patches, can you re-consider if there's a cleaner abstraction tha=
t
allows us to deal with some of this stuff in C-code?

-Christoffer
