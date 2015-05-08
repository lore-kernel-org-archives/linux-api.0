From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 02/12] KVM: define common __KVM_GUESTDBG_USE_SW/HW_BP
 values
Date: Fri, 8 May 2015 11:23:46 +0200
Message-ID: <20150508092346.GB24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430929407-3487-3-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430929407-3487-3-git-send-email-alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "maintainer:X86 ARCHITECTURE..." <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bharat Bhushan <Bharat.Bhushan-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, Mihai Caraman <mihai.caraman-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Nadav Amit <namit-FrESSTt7Abv7r6psnUbsSmZHpeb/A1Y/@public.gmane.org>, "open list:LINUX FOR POWERPC..." <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, open list <linux-kernel@vger.>
List-Id: linux-api@vger.kernel.org

On Wed, May 06, 2015 at 05:23:17PM +0100, Alex Benn=E9e wrote:
> Currently x86, powerpc and soon arm64 use the same two architecture
> specific bits for guest debug support for software and hardware
> breakpoints. This makes the shared values explicit while leaving the
> gate open for another architecture to use some other value if they
> really really want to.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Reviewed-by: Andrew Jones <drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/inclu=
de/uapi/asm/kvm.h
> index ab4d473..1731569 100644
> --- a/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> @@ -310,8 +310,8 @@ struct kvm_guest_debug_arch {
>   * and upper 16 bits are architecture specific. Architecture specifi=
c defines
>   * that ioctl is for setting hardware breakpoint or software breakpo=
int.
>   */
> -#define KVM_GUESTDBG_USE_SW_BP		0x00010000
> -#define KVM_GUESTDBG_USE_HW_BP		0x00020000
> +#define KVM_GUESTDBG_USE_SW_BP		__KVM_GUESTDBG_USE_SW_BP
> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
> =20
>  /* definition of registers in kvm_run */
>  struct kvm_sync_regs {
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/=
asm/kvm.h
> index d7dcef5..1438202 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -250,8 +250,8 @@ struct kvm_debug_exit_arch {
>  	__u64 dr7;
>  };
> =20
> -#define KVM_GUESTDBG_USE_SW_BP		0x00010000
> -#define KVM_GUESTDBG_USE_HW_BP		0x00020000
> +#define KVM_GUESTDBG_USE_SW_BP		__KVM_GUESTDBG_USE_SW_BP
> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
>  #define KVM_GUESTDBG_INJECT_DB		0x00040000
>  #define KVM_GUESTDBG_INJECT_BP		0x00080000
> =20
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 70ac641..3b6252e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -570,8 +570,16 @@ struct kvm_s390_irq_state {
> =20
>  /* for KVM_SET_GUEST_DEBUG */
> =20
> -#define KVM_GUESTDBG_ENABLE		0x00000001
> -#define KVM_GUESTDBG_SINGLESTEP		0x00000002
> +#define KVM_GUESTDBG_ENABLE		(1 << 0)
> +#define KVM_GUESTDBG_SINGLESTEP	(1 << 1)
> +
> +/*
> + * Architecture specific stuff uses the top 16 bits of the field,

s/stuff/<something more specific>/

> + * however there is some shared commonality for the common cases
> + */
> +#define __KVM_GUESTDBG_USE_SW_BP	(1 << 16)
> +#define __KVM_GUESTDBG_USE_HW_BP	(1 << 17)
> +
> =20
>  struct kvm_guest_debug {
>  	__u32 control;

We sort of left this discussion hanging with me expressing slight
concern about the usefulness about these defines.

Paolo, what are your thoughts?

-Christoffer
