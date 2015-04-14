From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/10] KVM: arm64: guest debug, HW assisted debug
 support
Date: Tue, 14 Apr 2015 12:17:24 +0200
Message-ID: <20150414101724.GU6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-9-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427814488-28467-9-git-send-email-alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 31, 2015 at 04:08:06PM +0100, Alex Benn=E9e wrote:
> This adds support for userspace to control the HW debug registers for
> guest debug. We'll only copy the $ARCH defined number across as that =
is
> all that hyp.S will use anyway.=20

I don't really understand what this sentence means?

> I've moved some helper functions into
> the hw_breakpoint.h header for re-use.
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
> As QEMU tests for watchpoints based on the address and not the PC we
> also need to export the value of far_el2 to userspace.
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
>    - add support fro trapping debug register access
>=20
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> index 17d4f9c..ac34093 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2627,7 +2627,7 @@ The top 16 bits of the control field are archit=
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
> @@ -2642,6 +2642,10 @@ updated to the correct (supplied) values.
>  The second part of the structure is architecture specific and
>  typically contains a set of debug registers.
> =20
> +For arm64 the number of debug registers is implementation defined an=
d
> +can be determined by querying the KVM_CAP_GUEST_DEBUG_HW_BPS and
> +KVM_CAP_GUEST_DEBUG_HW_WPS capabilities.
> +

can you document their behavior more specifically?  I assume they both
return 0 if HW assisted debugging is not supported and return the numbe=
r
of implemented hardware registers otherwise?

How does this work on big.LITTLE systems where cores may have a differe=
nt
number of implemented registers?

>  When debug events exit the main run loop with the reason
>  KVM_EXIT_DEBUG with the kvm_debug_exit_arch part of the kvm_run
>  structure containing architecture specific debug information.
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index c1ed8cb..a286026 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -306,6 +306,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> =20
>  #define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE |    \
>  			    KVM_GUESTDBG_USE_SW_BP | \
> +			    KVM_GUESTDBG_USE_HW_BP | \
>  			    KVM_GUESTDBG_SINGLESTEP)
> =20
>  /**
> @@ -328,6 +329,26 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct k=
vm_vcpu *vcpu,
>  			return -EINVAL;
> =20
>  		vcpu->guest_debug =3D dbg->control;
> +
> +		/* Hardware assisted Break and Watch points */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +			int nb =3D get_num_brps();
> +			int nw =3D get_num_wrps();
> +
> +			/* Copy across up to IMPDEF debug registers to our
> +			 * shadow copy in the vcpu structure. The debug code
> +			 * will then set them up before we re-enter the guest.
> +			 */
> +			memcpy(vcpu->arch.guest_debug_regs.dbg_bcr,
> +				dbg->arch.dbg_bcr, sizeof(__u64)*nb);
> +			memcpy(vcpu->arch.guest_debug_regs.dbg_bvr,
> +				dbg->arch.dbg_bvr, sizeof(__u64)*nb);
> +			memcpy(vcpu->arch.guest_debug_regs.dbg_wcr,
> +				dbg->arch.dbg_wcr, sizeof(__u64)*nw);
> +			memcpy(vcpu->arch.guest_debug_regs.dbg_wvr,
> +				dbg->arch.dbg_wvr, sizeof(__u64)*nw);
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
>  extern struct pmu perf_ops_bp;
> =20
>  #endif	/* __KERNEL__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> index 6a33647..2c359c9 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -106,8 +106,9 @@ struct kvm_vcpu_arch {
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
> @@ -126,6 +127,7 @@ struct kvm_vcpu_arch {
>  		u32	pstate_ss_bit;
>  		u32	mdscr_el1_bits;
> =20
> +		struct kvm_guest_debug_arch debug_regs;
>  	} debug_saved_regs;
> =20
>  	/* Don't run the guest */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/u=
api/asm/kvm.h
> index 6ee70a0..73f21e4 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -118,6 +118,7 @@ struct kvm_guest_debug_arch {
>  struct kvm_debug_exit_arch {
>  	__u64 pc;
>  	__u32 hsr;
> +	__u64 far;	/* used for watchpoints */
>  };
> =20
>  struct kvm_sync_regs {
> diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw=
_breakpoint.c
> index 98bbe06..923be44 100644
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
> index b32362c..3b368f3 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -50,14 +50,19 @@
> =20
>  void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  {
> +	bool trap_debug =3D false;
> +
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM | MDCR_EL2_TPMCR);
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TDRA | MDCR_EL2_TDOSA);
> =20
> -	/* Trap debug register access? */
> +	trace_kvm_arch_setup_debug_reg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> +
> +	/*
> +	 * If we are not treating debug registers are dirty we need
> +	 * to trap if the guest starts accessing them.
> +	 */

Hmmm, this comment could have been added when introducing the original
logic instead.  Also:

s/are/as/

I'm not sure the 'treating them as dirty' part of the comment is
helpful.  Perhaps you want something like:

  If the guest debug register state is dirty (the guest is actively
  accesing them), then we context-switch the registers in EL2.
  Otherwise, we trap-and-emulate all guest accesses to them.

>  	if (!vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
> -		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
> -	else
> -		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
> +		trap_debug =3D true;
> =20
>  	/* Is Guest debugging in effect? */
>  	if (vcpu->guest_debug) {
> @@ -84,10 +89,69 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
>  		}
> =20
> +		/*
> +		 * HW Break/Watch points
> +		 */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +			int nb =3D get_num_brps();
> +			int nw =3D get_num_wrps();

again, don't you have to be careful to be in a non-preemptible section
here?

> +			struct kvm_guest_debug_arch *saved, *host;
> +
> +			vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
> +				(DBG_MDSCR_KDE|DBG_MDSCR_MDE);

Can you always set the KDE bit?  What if you only want debug exceptions
from guest user mode?  Is that supported through the KVM interface
and/or GDB?

style: spaces around the '|' operator.

> +
> +			/*
> +			 * First we need to make a copy of the guest
> +			 * debug registers before we wipe them out
> +			 * with the ones we want to use.
> +			 */

ok, I may be over-doing this, but you've sort of gotten me on the track
here; First typically implies that there's a Second, or subsequently, o=
r
something like that here.

Also, regarding 'need to' vs. 'must', I found this a nice read:
http://www.kirkmahoney.com/blog/2008/02/must-vs-needs-to/

I think this comment would be more clear if it was written something
like:

  We are about to set the hw debug registers with values used to debug
  the VM.  Make a copy of the guest debug register state to preserve
  the guest's view of the debug register state.

> +			saved =3D &vcpu_debug_saved_reg(vcpu, debug_regs);
> +			host =3D &vcpu->arch.guest_debug_regs;
> +
> +			/* Save guest values */
> +			memcpy(&saved->dbg_bcr,
> +			       &vcpu_sys_reg(vcpu, DBGBCR0_EL1),
> +			       sizeof(__u64)*nb);
> +			memcpy(&saved->dbg_bvr,
> +			       &vcpu_sys_reg(vcpu, DBGBVR0_EL1),
> +			       sizeof(__u64)*nb);
> +			memcpy(&saved->dbg_wcr,
> +			       &vcpu_sys_reg(vcpu, DBGWCR0_EL1),
> +			       sizeof(__u64)*nw);
> +			memcpy(&saved->dbg_wvr,
> +			       &vcpu_sys_reg(vcpu, DBGWVR0_EL1),
> +			       sizeof(__u64)*nw);
> +
> +			/* Copy in host values */
> +			memcpy(&vcpu_sys_reg(vcpu, DBGBCR0_EL1),
> +			       &host->dbg_bcr,
> +			       sizeof(__u64)*nb);
> +			memcpy(&vcpu_sys_reg(vcpu, DBGBVR0_EL1),
> +			       &host->dbg_bvr,
> +			       sizeof(__u64)*nb);
> +			memcpy(&vcpu_sys_reg(vcpu, DBGWCR0_EL1),
> +			       &host->dbg_wcr,
> +			       sizeof(__u64)*nw);
> +			memcpy(&vcpu_sys_reg(vcpu, DBGWVR0_EL1),
> +			       &host->dbg_wvr,
> +			       sizeof(__u64)*nw);

you need spaces around all the '*' operators.


Instead of copying back and forth, could we just have a pointer on the
vcpu->arch struct to the debug regs struct that the EL2 code will
context-switch (if trapping is disabled) and then just shift the pointe=
r
in C code instead of doing all this?

> +
> +			/* Make sure hyp.S copies them in/out */
> +			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +			/* Also track guest changes */
> +			trap_debug =3D true;
> +		}
> +
>  	} else {
>  		/* Debug operations can go straight to the guest */
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;
>  	}
> +
> +	/* Trap debug register access? */
> +	if (trap_debug)
> +		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
> +	else
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
>  }
> =20
>  void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
> @@ -100,5 +164,31 @@ void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
>  		vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~MDSCR_EL1_DEBUG_BITS;
>  		vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
>  			vcpu_debug_saved_reg(vcpu, mdscr_el1_bits);
> +
> +		/*
> +		 * If we were using HW debug we need to restore the
> +		 * values the guest had set them up with
> +		 */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +			struct kvm_guest_debug_arch *regs;
> +			int nb =3D get_num_brps();
> +			int nw =3D get_num_wrps();
> +
> +			regs =3D &vcpu_debug_saved_reg(vcpu, debug_regs);
> +
> +			/* Restore the saved debug register values */
> +			memcpy(&vcpu_sys_reg(vcpu, DBGBCR0_EL1),
> +			       &regs->dbg_bcr,
> +			       sizeof(__u64)*nb);
> +			memcpy(&vcpu_sys_reg(vcpu, DBGBVR0_EL1),
> +			       &regs->dbg_bvr,
> +			       sizeof(__u64)*nb);
> +			memcpy(&vcpu_sys_reg(vcpu, DBGWCR0_EL1),
> +			       &regs->dbg_wcr,
> +			       sizeof(__u64)*nw);
> +			memcpy(&vcpu_sys_reg(vcpu, DBGWVR0_EL1),
> +			       &regs->dbg_wvr,
> +			       sizeof(__u64)*nw);

same style comment as above

> +		}

this is called on iteration of the run-loop, right?

it really seems excessive to do all this copying on every single
iteration.  I think it's cleaner if you have on piece of state on the
vcpu struct for the guest state, and one piece of state for guest
debugging, and for all emulation and userspace sync purposes you access
the guest state directly and you switch a pointer to the struct that
EL2 uses to save/restore the underlying hardware state.  Would that
work?


>  	}
>  }
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exi=
t.c
> index 16accae..460a1aa 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -101,7 +101,11 @@ static int kvm_handle_guest_debug(struct kvm_vcp=
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
>  		run->debug.arch.pc =3D *vcpu_pc(vcpu);
> @@ -129,6 +133,8 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
>  	[ESR_ELx_EC_SOFTSTP_LOW]=3D kvm_handle_guest_debug,
> +	[ESR_ELx_EC_WATCHPT_LOW]=3D kvm_handle_guest_debug,
> +	[ESR_ELx_EC_BREAKPT_LOW]=3D kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
>  };
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 0b43265..c2732c7 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -64,6 +64,12 @@ int kvm_arch_dev_ioctl_check_extension(long ext)
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
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c370b40..be9b188 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -196,16 +196,49 @@ static bool trap_dbgauthstatus_el1(struct kvm_v=
cpu *vcpu,
>   * - If the dirty bit is set, save guest registers, restore host
>   *   registers and clear the dirty bit. This ensure that the host ca=
n
>   *   now use the debug registers.
> + *
> + * We also use this mechanism to set-up the debug registers for gues=
t
                                    set up
> + * debugging. If this is the case we want to ensure the guest sees
> + * the right versions of the registers - even if they are not going =
to
> + * be effective while guest debug is using HW debug.
> + *
>   */
> +
>  static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> -	if (p->is_write) {
> -		vcpu_sys_reg(vcpu, r->reg) =3D *vcpu_reg(vcpu, p->Rt);
> -		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +		struct kvm_guest_debug_arch *saved;
> +		__u64 *val;
> +
> +		saved =3D &vcpu_debug_saved_reg(vcpu, debug_regs);
> +
> +		if (r->reg >=3D DBGBCR0_EL1 && r->reg <=3D DBGBCR15_EL1)
> +			val =3D &saved->dbg_bcr[r->reg - DBGBCR0_EL1];
> +		else if (r->reg >=3D DBGBVR0_EL1 && r->reg <=3D DBGBVR15_EL1)
> +			val =3D &saved->dbg_bvr[r->reg - DBGBVR0_EL1];
> +		else if (r->reg >=3D DBGWCR0_EL1 && r->reg <=3D DBGWCR15_EL1)
> +			val =3D &saved->dbg_wcr[r->reg - DBGWCR0_EL1];
> +		else if (r->reg >=3D DBGWVR0_EL1 && r->reg <=3D DBGWVR15_EL1)
> +			val =3D &saved->dbg_wvr[r->reg - DBGWVR0_EL1];
> +		else {
> +			kvm_err("Bad register index %d\n", r->reg);
> +			return false;
> +		}

you should be able to greatly simplify this as well if you follow my
suggestion above.

> +
> +		if (p->is_write)
> +			*val =3D *vcpu_reg(vcpu, p->Rt);
> +		else
> +			*vcpu_reg(vcpu, p->Rt) =3D *val;
> +
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) =3D vcpu_sys_reg(vcpu, r->reg);
> +		if (p->is_write) {
> +			vcpu_sys_reg(vcpu, r->reg) =3D *vcpu_reg(vcpu, p->Rt);
> +			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +		} else {
> +			*vcpu_reg(vcpu, p->Rt) =3D vcpu_sys_reg(vcpu, r->reg);
> +		}
>  	}
> =20
>  	return true;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ce2db14..0e48c0d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -771,6 +771,8 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_PPC_ENABLE_HCALL 104
>  #define KVM_CAP_CHECK_EXTENSION_VM 105
>  #define KVM_CAP_S390_USER_SIGP 106
> +#define KVM_CAP_GUEST_DEBUG_HW_BPS 107
> +#define KVM_CAP_GUEST_DEBUG_HW_WPS 108
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
> --=20
> 2.3.4
>=20
