From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 14/20] MIPS: KVM: Expose FPU registers
Date: Thu, 26 Mar 2015 14:55:56 +0100
Message-ID: <55140FEC.5010403@redhat.com>
References: <1426085096-12932-1-git-send-email-james.hogan@imgtec.com> <1426085096-12932-15-git-send-email-james.hogan@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1426085096-12932-15-git-send-email-james.hogan@imgtec.com>
Sender: linux-doc-owner@vger.kernel.org
To: James Hogan <james.hogan@imgtec.com>, kvm@vger.kernel.org, linux-mips@linux-mips.org
Cc: Paul Burton <paul.burton@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 11/03/2015 15:44, James Hogan wrote:
> Add KVM register numbers for the MIPS FPU registers, and implement
> access to them with the KVM_GET_ONE_REG / KVM_SET_ONE_REG ioctls when
> the FPU capability is enabled (exposed in a later patch) and present in
> the guest according to its Config1.FP bit.
> 
> The registers are accessible in the current mode of the guest, with each
> sized access showing what the guest would see with an equivalent access,
> and like the architecture they may become UNPREDICTABLE if the FR mode
> is changed. When FR=0, odd doubles are inaccessible as they do not exist
> in that mode.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Paul Burton <paul.burton@imgtec.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-mips@linux-mips.org
> Cc: kvm@vger.kernel.org
> Cc: linux-api@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> ---
>  Documentation/virtual/kvm/api.txt | 16 +++++++++
>  arch/mips/include/uapi/asm/kvm.h  | 37 ++++++++++++++------
>  arch/mips/kvm/mips.c              | 72 ++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 114 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 1e59515b6d1f..8ba55b9c903e 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1979,6 +1979,10 @@ registers, find a list below:
>    MIPS  | KVM_REG_MIPS_COUNT_CTL        | 64
>    MIPS  | KVM_REG_MIPS_COUNT_RESUME     | 64
>    MIPS  | KVM_REG_MIPS_COUNT_HZ         | 64
> +  MIPS  | KVM_REG_MIPS_FPR_32(0..31)    | 32
> +  MIPS  | KVM_REG_MIPS_FPR_64(0..31)    | 64
> +  MIPS  | KVM_REG_MIPS_FCR_IR           | 32
> +  MIPS  | KVM_REG_MIPS_FCR_CSR          | 32
>  
>  ARM registers are mapped using the lower 32 bits.  The upper 16 of that
>  is the register group type, or coprocessor number:
> @@ -2032,6 +2036,18 @@ patterns depending on whether they're 32-bit or 64-bit registers:
>  MIPS KVM control registers (see above) have the following id bit patterns:
>    0x7030 0000 0002 <reg:16>
>  
> +MIPS FPU registers (see KVM_REG_MIPS_FPR_{32,64}() above) have the following
> +id bit patterns depending on the size of the register being accessed. They are
> +always accessed according to the current guest FPU mode (Status.FR and
> +Config5.FRE), i.e. as the guest would see them, and they become unpredictable
> +if the guest FPU mode is changed:
> +  0x7020 0000 0003 00 <0:3> <reg:5> (32-bit FPU registers)
> +  0x7030 0000 0003 00 <0:3> <reg:5> (64-bit FPU registers)
> +
> +MIPS FPU control registers (see KVM_REG_MIPS_FCR_{IR,CSR} above) have the
> +following id bit patterns:
> +  0x7020 0000 0003 01 <0:3> <reg:5>
> +
>  
>  4.69 KVM_GET_ONE_REG
>  
> diff --git a/arch/mips/include/uapi/asm/kvm.h b/arch/mips/include/uapi/asm/kvm.h
> index 75d6d8557e57..401e6a6f8bb8 100644
> --- a/arch/mips/include/uapi/asm/kvm.h
> +++ b/arch/mips/include/uapi/asm/kvm.h
> @@ -36,18 +36,8 @@ struct kvm_regs {
>  
>  /*
>   * for KVM_GET_FPU and KVM_SET_FPU
> - *
> - * If Status[FR] is zero (32-bit FPU), the upper 32-bits of the FPRs
> - * are zero filled.
>   */
>  struct kvm_fpu {
> -	__u64 fpr[32];
> -	__u32 fir;
> -	__u32 fccr;
> -	__u32 fexr;
> -	__u32 fenr;
> -	__u32 fcsr;
> -	__u32 pad;
>  };
>  
>  
> @@ -68,6 +58,8 @@ struct kvm_fpu {
>   *
>   * Register set = 2: KVM specific registers (see definitions below).
>   *
> + * Register set = 3: FPU registers (see definitions below).
> + *
>   * Other sets registers may be added in the future.  Each set would
>   * have its own identifier in bits[31..16].
>   */
> @@ -75,6 +67,7 @@ struct kvm_fpu {
>  #define KVM_REG_MIPS_GP		(KVM_REG_MIPS | 0x0000000000000000ULL)
>  #define KVM_REG_MIPS_CP0	(KVM_REG_MIPS | 0x0000000000010000ULL)
>  #define KVM_REG_MIPS_KVM	(KVM_REG_MIPS | 0x0000000000020000ULL)
> +#define KVM_REG_MIPS_FPU	(KVM_REG_MIPS | 0x0000000000030000ULL)
>  
>  
>  /*
> @@ -155,6 +148,30 @@ struct kvm_fpu {
>  
>  
>  /*
> + * KVM_REG_MIPS_FPU - Floating Point registers.
> + *
> + *  bits[15..8]  - Register subset (see definitions below).
> + *  bits[7..5]   - Must be zero.
> + *  bits[4..0]   - Register number within register subset.
> + */
> +
> +#define KVM_REG_MIPS_FPR	(KVM_REG_MIPS_FPU | 0x0000000000000000ULL)
> +#define KVM_REG_MIPS_FCR	(KVM_REG_MIPS_FPU | 0x0000000000000100ULL)
> +
> +/*
> + * KVM_REG_MIPS_FPR - Floating point / Vector registers.
> + */
> +#define KVM_REG_MIPS_FPR_32(n)	(KVM_REG_MIPS_FPR | KVM_REG_SIZE_U32  | (n))
> +#define KVM_REG_MIPS_FPR_64(n)	(KVM_REG_MIPS_FPR | KVM_REG_SIZE_U64  | (n))
> +
> +/*
> + * KVM_REG_MIPS_FCR - Floating point control registers.
> + */
> +#define KVM_REG_MIPS_FCR_IR	(KVM_REG_MIPS_FCR | KVM_REG_SIZE_U32 |  0)
> +#define KVM_REG_MIPS_FCR_CSR	(KVM_REG_MIPS_FCR | KVM_REG_SIZE_U32 | 31)
> +
> +
> +/*
>   * KVM MIPS specific structures and definitions
>   *
>   */
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index dd0833833bea..5e41afe15ae8 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -526,10 +526,13 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
>  			    const struct kvm_one_reg *reg)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> +	struct mips_fpu_struct *fpu = &vcpu->arch.fpu;
>  	int ret;
>  	s64 v;
> +	unsigned int idx;
>  
>  	switch (reg->id) {
> +	/* General purpose registers */
>  	case KVM_REG_MIPS_R0 ... KVM_REG_MIPS_R31:
>  		v = (long)vcpu->arch.gprs[reg->id - KVM_REG_MIPS_R0];
>  		break;
> @@ -543,6 +546,38 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
>  		v = (long)vcpu->arch.pc;
>  		break;
>  
> +	/* Floating point registers */
> +	case KVM_REG_MIPS_FPR_32(0) ... KVM_REG_MIPS_FPR_32(31):
> +		if (!kvm_mips_guest_has_fpu(&vcpu->arch))
> +			return -EINVAL;
> +		idx = reg->id - KVM_REG_MIPS_FPR_32(0);
> +		/* Odd singles in top of even double when FR=0 */
> +		if (kvm_read_c0_guest_status(cop0) & ST0_FR)
> +			v = get_fpr32(&fpu->fpr[idx], 0);
> +		else
> +			v = get_fpr32(&fpu->fpr[idx & ~1], idx & 1);
> +		break;
> +	case KVM_REG_MIPS_FPR_64(0) ... KVM_REG_MIPS_FPR_64(31):
> +		if (!kvm_mips_guest_has_fpu(&vcpu->arch))
> +			return -EINVAL;
> +		idx = reg->id - KVM_REG_MIPS_FPR_64(0);
> +		/* Can't access odd doubles in FR=0 mode */
> +		if (idx & 1 && !(kvm_read_c0_guest_status(cop0) & ST0_FR))
> +			return -EINVAL;
> +		v = get_fpr64(&fpu->fpr[idx], 0);
> +		break;
> +	case KVM_REG_MIPS_FCR_IR:
> +		if (!kvm_mips_guest_has_fpu(&vcpu->arch))
> +			return -EINVAL;
> +		v = boot_cpu_data.fpu_id;
> +		break;
> +	case KVM_REG_MIPS_FCR_CSR:
> +		if (!kvm_mips_guest_has_fpu(&vcpu->arch))
> +			return -EINVAL;
> +		v = fpu->fcr31;
> +		break;
> +
> +	/* Co-processor 0 registers */
>  	case KVM_REG_MIPS_CP0_INDEX:
>  		v = (long)kvm_read_c0_guest_index(cop0);
>  		break;
> @@ -636,7 +671,9 @@ static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
>  			    const struct kvm_one_reg *reg)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> -	u64 v;
> +	struct mips_fpu_struct *fpu = &vcpu->arch.fpu;
> +	s64 v;
> +	unsigned int idx;
>  
>  	if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64) {
>  		u64 __user *uaddr64 = (u64 __user *)(long)reg->addr;
> @@ -655,6 +692,7 @@ static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
>  	}
>  
>  	switch (reg->id) {
> +	/* General purpose registers */
>  	case KVM_REG_MIPS_R0:
>  		/* Silently ignore requests to set $0 */
>  		break;
> @@ -671,6 +709,38 @@ static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
>  		vcpu->arch.pc = v;
>  		break;
>  
> +	/* Floating point registers */
> +	case KVM_REG_MIPS_FPR_32(0) ... KVM_REG_MIPS_FPR_32(31):
> +		if (!kvm_mips_guest_has_fpu(&vcpu->arch))
> +			return -EINVAL;
> +		idx = reg->id - KVM_REG_MIPS_FPR_32(0);
> +		/* Odd singles in top of even double when FR=0 */
> +		if (kvm_read_c0_guest_status(cop0) & ST0_FR)
> +			set_fpr32(&fpu->fpr[idx], 0, v);
> +		else
> +			set_fpr32(&fpu->fpr[idx & ~1], idx & 1, v);
> +		break;
> +	case KVM_REG_MIPS_FPR_64(0) ... KVM_REG_MIPS_FPR_64(31):
> +		if (!kvm_mips_guest_has_fpu(&vcpu->arch))
> +			return -EINVAL;
> +		idx = reg->id - KVM_REG_MIPS_FPR_64(0);
> +		/* Can't access odd doubles in FR=0 mode */
> +		if (idx & 1 && !(kvm_read_c0_guest_status(cop0) & ST0_FR))
> +			return -EINVAL;
> +		set_fpr64(&fpu->fpr[idx], 0, v);
> +		break;
> +	case KVM_REG_MIPS_FCR_IR:
> +		if (!kvm_mips_guest_has_fpu(&vcpu->arch))
> +			return -EINVAL;
> +		/* Read-only */
> +		break;
> +	case KVM_REG_MIPS_FCR_CSR:
> +		if (!kvm_mips_guest_has_fpu(&vcpu->arch))
> +			return -EINVAL;
> +		fpu->fcr31 = v;
> +		break;
> +
> +	/* Co-processor 0 registers */
>  	case KVM_REG_MIPS_CP0_INDEX:
>  		kvm_write_c0_guest_index(cop0, v);
>  		break;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
