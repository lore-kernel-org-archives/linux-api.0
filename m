From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
Date: Tue, 2 Dec 2014 14:17:53 +0100
Message-ID: <20141202131753.GC545@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
 <20141130102137.GH23653@cbox>
 <87r3wj1te1.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87r3wj1te1.fsf-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 01, 2014 at 11:50:14AM +0000, Alex Benn=E9e wrote:
>=20
> Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>=20
> > On Tue, Nov 25, 2014 at 04:10:03PM +0000, Alex Benn=E9e wrote:
> >> This adds support for single-stepping the guest. As userspace can =
and
> >> will manipulate guest registers before restarting any tweaking of =
the
> >> registers has to occur just before control is passed back to the g=
uest.
> >> Furthermore while guest debugging is in effect we need to squash t=
he
> >> ability of the guest to single-step itself as we have no easy way =
of
> >> re-entering the guest after the exception has been delivered to th=
e
> >> hypervisor.
> >
> > Admittedly this is a corner case, but wouldn't the only really nast=
y bit
> > of this be to emulate the guest debug exception?
>=20
> Well yes - currently this is all squashed by ignoring the guest's wis=
hes
> while we are debugging (save for SW breakpoints).
>=20
> >
> >>=20
> >> Signed-off-by: Alex Benn=E9e <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >>=20
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index 48d26bb..a76daae 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -38,6 +38,7 @@
> >>  #include <asm/tlbflush.h>
> >>  #include <asm/cacheflush.h>
> >>  #include <asm/virt.h>
> >> +#include <asm/debug-monitors.h>
> >>  #include <asm/kvm_arm.h>
> >>  #include <asm/kvm_asm.h>
> >>  #include <asm/kvm_mmu.h>
> >> @@ -300,6 +301,17 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >>  	kvm_arm_set_running_vcpu(NULL);
> >>  }
> >> =20
> >> +/**
> >> + * kvm_arch_vcpu_ioctl_set_guest_debug - Setup guest debugging
> >> + * @kvm:	pointer to the KVM struct
> >> + * @kvm_guest_debug: the ioctl data buffer
> >> + *
> >> + * This sets up the VM for guest debugging. Care has to be taken =
when
> >> + * manipulating guest registers as these will be set/cleared by t=
he
> >> + * hyper-visor controller, typically before each kvm_run event. A=
s a
> >
> > hypervisor
> >
> >> + * result modification of the guest registers needs to take place
> >> + * after they have been restored in the hyp.S trampoline code.
> >
> > I don't understand this??
>=20
> We can't use GET/SET one reg to manipulate the registers we want as
> these are the guest visible versions and subject to modification by
> userspace. This is why the debugging code makes it's changes after th=
e
> guest state has been restored.
>=20

eh, once you're in the KVM_RUN ioctl, user space can't fiddle your VCPU
regs because you're holding the vcpu mutex, so doing stuff in some
callout from kvm_arch_vcpu_ioctl_run() seems every bid as valid for thi=
s
case as doing it in EL2.  In fact, the only reason why we're doing
anything in EL2 is when you're accessing state only accessible in EL2,
when you need to write the whole thing in assembly (like the context
switch of GP registers) etc.

If it doesn't have huge performance costs, we should use C-code in EL1
to the furthest extent possible.

> >
> >> + */
> >>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >>  					struct kvm_guest_debug *dbg)
> >>  {
> >> @@ -317,8 +329,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct=
 kvm_vcpu *vcpu,
> >> =20
> >>  	/* Single Step */
> >>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> >> -		kvm_info("SS requested, not yet implemented\n");
> >> -		return -EINVAL;
> >> +		kvm_info("SS requested\n");
> >> +		route_el2 =3D true;
> >>  	}
> >> =20
> >>  	/* Software Break Points */
> >> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/a=
sm-offsets.c
> >> index 8da1043..78e5ae1 100644
> >> --- a/arch/arm64/kernel/asm-offsets.c
> >> +++ b/arch/arm64/kernel/asm-offsets.c
> >> @@ -121,6 +121,7 @@ int main(void)
> >>    DEFINE(VCPU_FAR_EL2,		offsetof(struct kvm_vcpu, arch.fault.far_=
el2));
> >>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpf=
ar_el2));
> >>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_f=
lags));
> >> +  DEFINE(GUEST_DEBUG,		offsetof(struct kvm_vcpu, guest_debug));
> >>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
> >>    DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2))=
;
> >>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines=
));
> >> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_=
exit.c
> >> index 28dc92b..6def054 100644
> >> --- a/arch/arm64/kvm/handle_exit.c
> >> +++ b/arch/arm64/kvm/handle_exit.c
> >> @@ -91,6 +91,25 @@ static int kvm_handle_bkpt(struct kvm_vcpu *vcp=
u, struct kvm_run *run)
> >>  	return 0;
> >>  }
> >> =20
> >> +/**
> >> + * kvm_handle_ss - handle single step exceptions
> >> + *
> >> + * @vcpu:	the vcpu pointer
> >> + *
> >> + * See: ARM ARM D2.12 for the details. While the host is routing =
debug
> >> + * exceptions to it's handlers we have to suppress the ability of=
 the
> >
> > its handlers
> >
> >> + * guest to trigger exceptions.
> >
> > not really sure why this comment is here?  Does it really help anyo=
ne
> > reading this specific function or does it just confuse people more?
> >
> >> + */
> >> +static int kvm_handle_ss(struct kvm_vcpu *vcpu, struct kvm_run *r=
un)
> >> +{
> >> +	WARN_ON(!(vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP));
> >
> > is this something that can actually happen or should it be a BUG_ON=
() -
> > which may even go away once you're doing hacking on this?
>=20
> It shouldn't happen. I was treating more like an assert, failure of
> which would indicate something has gone wrong somewhere although
> generally not worth bringing the kernel down for.
>=20

huh, I guess that's fair enough, but somewhat unconventional for kernel
code.  Typically I read WARN_ON (I could be wrong here) as something
that may happen under extreme circumstances (debugging turned on, crazy
low-memory situations etc.), but not as something that catches a bug.

I've seen the argument before that if something that sholdn't ever
happen in the kernel, indeed does happen in the kernel, then that is a
bug, and then you should panic().

So I do feel that this is either a kvm_info()/kvm_err() situation or a
BUG_ON() situation, or nothing at all.

> >
> >> +
> >> +	run->exit_reason =3D KVM_EXIT_DEBUG;
> >> +	run->debug.arch.exit_type =3D KVM_DEBUG_EXIT_SINGLE_STEP;
> >> +	run->debug.arch.address =3D *vcpu_pc(vcpu);
> >> +	return 0;
> >> +}
> >> +
> >>  static exit_handle_fn arm_exit_handlers[] =3D {
> >>  	[ESR_EL2_EC_WFI]	=3D kvm_handle_wfx,
> >>  	[ESR_EL2_EC_CP15_32]	=3D kvm_handle_cp15_32,
> >> @@ -105,6 +124,7 @@ static exit_handle_fn arm_exit_handlers[] =3D =
{
> >>  	[ESR_EL2_EC_SYS64]	=3D kvm_handle_sys_reg,
> >>  	[ESR_EL2_EC_IABT]	=3D kvm_handle_guest_abort,
> >>  	[ESR_EL2_EC_DABT]	=3D kvm_handle_guest_abort,
> >> +	[ESR_EL2_EC_SOFTSTP]    =3D kvm_handle_ss,
> >>  	[ESR_EL2_EC_BKPT32]	=3D kvm_handle_bkpt,
> >>  	[ESR_EL2_EC_BRK64]	=3D kvm_handle_bkpt,
> >>  };
> >> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> >> index 3c733ea..c0bc218 100644
> >> --- a/arch/arm64/kvm/hyp.S
> >> +++ b/arch/arm64/kvm/hyp.S
> >> @@ -16,6 +16,7 @@
> >>   */
> >> =20
> >>  #include <linux/linkage.h>
> >> +#include <linux/kvm.h>
> >> =20
> >>  #include <asm/assembler.h>
> >>  #include <asm/memory.h>
> >> @@ -168,6 +169,31 @@
> >>  	// x19-x29, lr, sp*, elr*, spsr*
> >>  	restore_common_regs
> >> =20
> >> +	// After restoring the guest registers but before we return to t=
he guest
> >> +	// we may want to make some final tweaks to support guest debugg=
ing.
> >
> > "we may want" sounds like we're not sure what we'll be doing here. =
 We
> > probably want to write something like "If the guest is being debugg=
ed we
> > need to set blah blah blah".
> >
> >> +	ldr	x3, [x0, #GUEST_DEBUG]
> >> +	tbz	x3, #KVM_GUESTDBG_ENABLE_SHIFT, 2f	// No guest debug
> >> +
> >> +	// x0 - preserved as VCPU ptr
> >> +	// x1 - spsr
> >> +	// x2 - mdscr
> >
> > not sure we need this comment
> >
> >> +	mrs	x1, spsr_el2
> >> +	mrs 	x2, mdscr_el1
> >> +
> >> +	// See ARM ARM D2.12.3 The software step state machine
> >> +	// If we are doing Single Step - set MDSCR_EL1.SS and PSTATE.SS
> >> +	orr	x1, x1, #DBG_SPSR_SS
> >> +	orr	x2, x2, #DBG_MDSCR_SS
> >> +	tbnz	x3, #KVM_GUESTDBG_SINGLESTEP_SHIFT, 1f
> >> +	// If we are not doing Single Step we want to prevent the guest =
doing so
> >> +	// as otherwise we will have to deal with the re-routed exceptio=
ns as we
> >> +	// are doing other guest debug related things
> >> +	eor	x1, x1, #DBG_SPSR_SS
> >> +	eor	x2, x2, #DBG_MDSCR_SS
> >
> > this really confuses me: so you're setting the SS bits in both
> > registers, and then if we're not single-stepping the guest, you cle=
ar
> > both bits again?
> >
> > Wouldn't it be much simper to mask off the bits with a 'bic' and th=
en
> > setting the bits when needed?
>=20
> Is there a non-vector BIC #imm? I was being frugal with register usag=
e
> at this point. The orr/eor steps where just to avoid having too many
> branch cases.
>=20

there are "bic x3, x3, #1" and such in this very file, so I would guess=
,
yes.

> > Alternatively, we could manage all these registers from C code and =
just
> > save/restore them off the VCPU struct.
>=20
> Yes but this has to be done as we run into the hyp.S code after all
> guest registers are confirmed as the changes are on-top of whatever t=
he
> guest view is (for the _el1 regs).
>=20
> Where would you suggest that goes?
>=20

As a call-out from the arch-specific KVM_RUN ioctl, call
kvm_setup_guest_debug() or something like that, just like we do to chec=
k
if our vmid is valid and to setup the vgic state and so on.  Does that
work?

-Christoffer
