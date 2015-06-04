From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 10/12] KVM: arm64: guest debug, HW assisted debug
 support
Date: Thu, 4 Jun 2015 13:06:31 +0200
Message-ID: <20150604110631.GF7657@cbox>
References: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org>
 <1432891828-4816-11-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432891828-4816-11-git-send-email-alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 29, 2015 at 10:30:26AM +0100, Alex Benn=E9e wrote:
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
> v4
>    - use the new u32/u64 split debug_ptr approach
>    - fix some wording/comments
> v5
>    - don't set MDSCR_EL1.KDE (not needed)
> ---
>  Documentation/virtual/kvm/api.txt      |  7 ++++++-
>  arch/arm/kvm/arm.c                     |  7 +++++++
>  arch/arm64/include/asm/hw_breakpoint.h | 12 +++++++++++
>  arch/arm64/include/asm/kvm_host.h      |  3 ++-
>  arch/arm64/include/uapi/asm/kvm.h      |  2 +-
>  arch/arm64/kernel/hw_breakpoint.c      | 12 -----------
>  arch/arm64/kvm/debug.c                 | 37 ++++++++++++++++++++++++=
+++++-----
>  arch/arm64/kvm/handle_exit.c           |  6 ++++++
>  arch/arm64/kvm/reset.c                 | 12 +++++++++++
>  include/uapi/linux/kvm.h               |  2 ++
>  10 files changed, 80 insertions(+), 20 deletions(-)
>=20
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> index 33c8143..ada57df 100644
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
> +KVM_CAP_GUEST_DEBUG_HW_WPS capabilities which return a positive numb=
er
> +indicating the number of supported registers.
> +
>  When debug events exit the main run loop with the reason
>  KVM_EXIT_DEBUG with the kvm_debug_exit_arch part of the kvm_run
>  structure containing architecture specific debug information.
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 0d17c7b..6df47c1 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -307,6 +307,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> =20
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE |    \
>  			    KVM_GUESTDBG_USE_SW_BP | \
> +			    KVM_GUESTDBG_USE_HW_BP | \
>  			    KVM_GUESTDBG_SINGLESTEP)
> =20
>  /**
> @@ -327,6 +328,12 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct k=
vm_vcpu *vcpu,
> =20
>  	if (dbg->control & KVM_GUESTDBG_ENABLE) {
>  		vcpu->guest_debug =3D dbg->control;
> +
> +		/* Hardware assisted Break and Watch points */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {

does KVM_GUESTDBG_USE_HW_BP cover watch points as well or why is this
mentionend in the comment?

I asked this once before already...

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
>  extern struct pmu perf_ops_bp;
> =20
>  #endif	/* __KERNEL__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> index e5040b6..498d4f7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -113,12 +113,13 @@ struct kvm_vcpu_arch {
> =20
>  	/*
>  	 * For debugging the guest we need to keep a set of debug
> -	 * registers which can override the guests own debug state
> +	 * registers which can override the guest's own debug state

rebase error?

>  	 * while being used. These are set via the KVM_SET_GUEST_DEBUG
>  	 * ioctl.
>  	 */
>  	struct kvm_guest_debug_arch *debug_ptr;
>  	struct kvm_guest_debug_arch vcpu_debug_state;
> +	struct kvm_guest_debug_arch external_debug_state;
> =20
>  	/* Pointer to host CPU context */
>  	kvm_cpu_context_t *host_cpu_context;
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/u=
api/asm/kvm.h
> index 43758e7..95168c2 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -116,7 +116,7 @@ struct kvm_guest_debug_arch {
> =20
>  struct kvm_debug_exit_arch {
>  	__u32 hsr;
> -	__u64 far;
> +	__u64 far;	/* used for watchpoints */

and I noticed this one before as well...

>  };
> =20
>  /*
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
> index 10a6baa..3c0daae 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -98,10 +98,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  				MDCR_EL2_TDRA |
>  				MDCR_EL2_TDOSA);
> =20
> -	/* Trap on access to debug registers? */
> -	if (trap_debug)
> -		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
> -
>  	/* Is Guest debugging in effect? */
>  	if (vcpu->guest_debug) {
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
> @@ -124,11 +120,42 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  		} else {
>  			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
>  		}
> +
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
> +			/* Enable breakpoints/watchpoints */
> +			vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D DBG_MDSCR_MDE;
> +
> +			vcpu->arch.debug_ptr =3D &vcpu->arch.external_debug_state;
> +			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +			trap_debug =3D true;
> +		}
>  	}
> +
> +	/* Trap debug register access */
> +	if (trap_debug)
> +		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
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
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
> +			vcpu->arch.debug_ptr =3D &vcpu->arch.vcpu_debug_state;

you also ignored my comment (or never answered my question) on moving
this to kvm_arm_setup_debug() last time around.... oh well.

Thanks,
-Christoffer
