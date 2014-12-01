From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 7/7] KVM: arm64: guest debug, HW assisted debug support
Date: Mon, 01 Dec 2014 11:54:46 +0000
Message-ID: <87oarn1t6h.fsf@linaro.org>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-8-git-send-email-alex.bennee@linaro.org> <20141130103450.GJ23653@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <20141130103450.GJ23653@cbox>
Sender: linux-doc-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, pbonzini@redhat.com, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Tue, Nov 25, 2014 at 04:10:05PM +0000, Alex Benn=C3=A9e wrote:
<snip>
>> --- a/arch/arm64/kvm/hyp.S
>> +++ b/arch/arm64/kvm/hyp.S
>> @@ -18,6 +18,7 @@
>>  #include <linux/linkage.h>
>>  #include <linux/kvm.h>
>> =20
>> +#include <uapi/asm/kvm.h>
>>  #include <asm/assembler.h>
>>  #include <asm/memory.h>
>>  #include <asm/asm-offsets.h>
>> @@ -174,6 +175,7 @@
>>  	ldr	x3, [x0, #GUEST_DEBUG]
>>  	tbz	x3, #KVM_GUESTDBG_ENABLE_SHIFT, 2f	// No guest debug
>> =20
>> +	// Both Step and HW BP/WP ops need to modify spsr_el2 and mdscr_el=
1
>>  	// x0 - preserved as VCPU ptr
>>  	// x1 - spsr
>>  	// x2 - mdscr
>> @@ -191,6 +193,11 @@
>>  	eor	x1, x1, #DBG_SPSR_SS
>>  	eor	x2, x2, #DBG_MDSCR_SS
>>  1:
>> +	// If we are doing HW BP/WP - set MDSCR_EL1.KDE/MDE
>> +	tbz	x3, #KVM_GUESTDBG_USE_HW_BP_SHIFT, 3f
>> +	orr	x2, x2, #DBG_MDSCR_KDE
>> +	orr	x2, x2, #DBG_MDSCR_MDE
>> +3:
>>  	msr	spsr_el2, x1
>>  	msr	mdscr_el1, x2
>>  2:
>> @@ -815,6 +822,33 @@ __restore_debug:
>> =20
>>  	ret
>> =20
>> +/* Setup debug state for debug of guest */
>> +__setup_debug:
>> +	// x0: vcpu base address
>> +	// x3: ptr to guest registers passed to setup_debug_registers
>> +	// x5..x20/x26: trashed
>> +
>> +	mrs	x26, id_aa64dfr0_el1
>> +	ubfx	x24, x26, #12, #4	// Extract BRPs
>> +	ubfx	x25, x26, #20, #4	// Extract WRPs
>> +	mov	w26, #15
>> +	sub	w24, w26, w24		// How many BPs to skip
>> +	sub	w25, w26, w25		// How many WPs to skip
>> +
>> +	mov     x4, x24
>> +	add	x3, x0, #GUEST_DEBUG_BCR
>> +	setup_debug_registers dbgbcr
>> +	add	x3, x0, #GUEST_DEBUG_BVR
>> +	setup_debug_registers dbgbvr
>> +
>> +	mov     x4, x25
>> +	add	x3, x0, #GUEST_DEBUG_WCR
>> +	setup_debug_registers dbgwcr
>> +	add	x3, x0, #GUEST_DEBUG_WVR
>> +	setup_debug_registers dbgwvr
>> +
>> +	ret
>> +
>>  __save_fpsimd:
>>  	save_fpsimd
>>  	ret
>> @@ -861,6 +895,13 @@ ENTRY(__kvm_vcpu_run)
>>  	bl __restore_sysregs
>>  	bl __restore_fpsimd
>> =20
>> +        // Now is the time to set-up the debug registers if we
>> +        // are debugging the guest
>> +	ldr	x3, [x0, #GUEST_DEBUG]
>> +	tbz	x3, #KVM_GUESTDBG_USE_HW_BP_SHIFT, 2f
>> +	bl	__setup_debug
>> +	b	1f
>> +2:
>>  	skip_debug_state x3, 1f
>>  	bl	__restore_debug
>>  1:
>> @@ -881,6 +922,11 @@ __kvm_vcpu_return:
>>  	bl __save_fpsimd
>>  	bl __save_sysregs
>> =20
>> +	// If we are debugging the guest don't save debug registers
>> +	// otherwise we'll be trashing are only good copy we have.
>> +	ldr	x3, [x0, #GUEST_DEBUG]
>> +	tbnz	x3, #KVM_GUESTDBG_USE_HW_BP_SHIFT, 1f
>> +
>
> we're introducing an awful lot of conditionals in the assembly code w=
ith
> these patches, can you re-consider if there's a cleaner abstraction t=
hat
> allows us to deal with some of this stuff in C-code?

See previous mail. It would be good but we need a place to do it before
we enter hyp.S on a KVM_RUN ioctl. I'm open to suggestions.

>
> -Christoffer

--=20
Alex Benn=C3=A9e
