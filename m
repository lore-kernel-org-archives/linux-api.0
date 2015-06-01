From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v5 10/12] KVM: arm64: guest debug, HW assisted debug
 support
Date: Mon, 1 Jun 2015 10:15:52 +0100
Message-ID: <20150601091552.GA1641@arm.com>
References: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org>
 <1432891828-4816-11-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432891828-4816-11-git-send-email-alex.bennee@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "r65777@freescale.com" <r65777@freescale.com>, "bp@suse.de" <bp@suse.de>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <Catalin.Marinas@arm.com>, Ingo Molnar <mingo@kernel.org>, Pe
List-Id: linux-api@vger.kernel.org

Hi Alex,

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
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>

[...]

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

I'm fine with moving these into the header file, but we should probably
revisit this at some point so that we use a shadow value to indicate th=
e
minimum number of registers across the system for e.g. big.LITTLE platf=
orms
that don't have uniform debug resources.

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

Why not just add the comment with the field in your earlier patch?

Will
