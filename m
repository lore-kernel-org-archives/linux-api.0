From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 02/10] KVM: define common __KVM_GUESTDBG_USE_SW/HW_BP
 values
Date: Mon, 13 Apr 2015 17:07:16 +0200
Message-ID: <20150413150716.GA6410@hawk.usersys.redhat.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-3-git-send-email-alex.bennee@linaro.org>
 <20150413115535.GM6186@cbox> <871tjokrnu.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <871tjokrnu.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu, Nadav Amit <namit@cs.technion.ac.il>, Michael Ellerman <mpe@ellerman.id.au>, "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>, Ingo Molnar <mingo@redhat.com>, zhichao.huang@linaro.org, jan.kiszka@siemens.com, bp@suse.de, marc.zyngier@arm.com, r65777@freescale.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, pbonzini@redhat.com, "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 13, 2015 at 03:51:33PM +0100, Alex Benn=E9e wrote:
> =

> Christoffer Dall <christoffer.dall@linaro.org> writes:
> =

> > On Tue, Mar 31, 2015 at 04:08:00PM +0100, Alex Benn=E9e wrote:
> >> Currently x86, powerpc and soon arm64 use the same two architecture
> >> specific bits for guest debug support for software and hardware
> >> breakpoints. This makes the shared values explicit while leaving the
> >> gate open for another architecture to use some other value if they
> >> really really want to.
> >> =

> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >> =

> >> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/includ=
e/uapi/asm/kvm.h
> >> index ab4d473..1731569 100644
> >> --- a/arch/powerpc/include/uapi/asm/kvm.h
> >> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> >> @@ -310,8 +310,8 @@ struct kvm_guest_debug_arch {
> >>   * and upper 16 bits are architecture specific. Architecture specific=
 defines
> >>   * that ioctl is for setting hardware breakpoint or software breakpoi=
nt.
> >>   */
> >> -#define KVM_GUESTDBG_USE_SW_BP		0x00010000
> >> -#define KVM_GUESTDBG_USE_HW_BP		0x00020000
> >> +#define KVM_GUESTDBG_USE_SW_BP		__KVM_GUESTDBG_USE_SW_BP
> >> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
> >>  =

> >>  /* definition of registers in kvm_run */
> >>  struct kvm_sync_regs {
> >> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/a=
sm/kvm.h
> >> index d7dcef5..1438202 100644
> >> --- a/arch/x86/include/uapi/asm/kvm.h
> >> +++ b/arch/x86/include/uapi/asm/kvm.h
> >> @@ -250,8 +250,8 @@ struct kvm_debug_exit_arch {
> >>  	__u64 dr7;
> >>  };
> >>  =

> >> -#define KVM_GUESTDBG_USE_SW_BP		0x00010000
> >> -#define KVM_GUESTDBG_USE_HW_BP		0x00020000
> >> +#define KVM_GUESTDBG_USE_SW_BP		__KVM_GUESTDBG_USE_SW_BP
> >> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
> >>  #define KVM_GUESTDBG_INJECT_DB		0x00040000
> >>  #define KVM_GUESTDBG_INJECT_BP		0x00080000
> >>  =

> >> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >> index 5eedf84..ce2db14 100644
> >> --- a/include/uapi/linux/kvm.h
> >> +++ b/include/uapi/linux/kvm.h
> >> @@ -525,8 +525,16 @@ struct kvm_s390_irq {
> >>  =

> >>  /* for KVM_SET_GUEST_DEBUG */
> >>  =

> >> -#define KVM_GUESTDBG_ENABLE		0x00000001
> >> -#define KVM_GUESTDBG_SINGLESTEP		0x00000002
> >> +#define KVM_GUESTDBG_ENABLE		(1 << 0)
> >> +#define KVM_GUESTDBG_SINGLESTEP	(1 << 1)
> >> +
> >> +/*
> >> + * Architecture specific stuff uses the top 16 bits of the field,
> >
> > can you be more specific than 'stuff' here?  features?
> >
> >> + * however there is some shared commonality for the common cases
> >
> > I don't like this sentence; shared commonality is a pleonasm and the use
> > of however makes it sounds like there's some caveat here.
> =

> OK I can see that - after I looked it up ;-)
> =

> > If the top 16 bits are indeed arhictecture specific, then I think they
> > should just be defined in their architecture specific headers.  Unless
> > the idea here is that there's a fixed set of of flags that architectures
> > can choose to support, in which case it should simply be defined in the
> > common header.
> =

> Well an architecture might not support some features and want to use
> those bits for something else? I didn't want to force the bottom two
> of the architecture specific bits to wasted if the features don't exist.

This change comes from a discussion we had on v1 of this series
http://www.spinics.net/lists/kvm-arm/msg12409.html

> =

> >
> >
> >> + */
> >> +#define __KVM_GUESTDBG_USE_SW_BP	(1 << 16)
> >> +#define __KVM_GUESTDBG_USE_HW_BP	(1 << 17)
> >> +
> >>  =

> >>  struct kvm_guest_debug {
> >>  	__u32 control;
> >> -- =

> >> 2.3.4
> >> =

> =

> -- =

> Alex Benn=E9e
