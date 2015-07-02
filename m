From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v7 09/11] KVM: arm64: guest debug, HW assisted debug
 support
Date: Thu, 2 Jul 2015 09:48:47 +0100
Message-ID: <20150702084847.GB3418@arm.com>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
 <1435775343-20034-10-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435775343-20034-10-git-send-email-alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Marc Zyngier <Marc.Zyngier-5wv7dgnIgG8@public.gmane.org>, "peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "agraf-l3A5Bk7waGM@public.gmane.org" <agraf-l3A5Bk7waGM@public.gmane.org>, "drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org" <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org" <r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, "bp-l3A5Bk7waGM@public.gmane.org" <bp-l3A5Bk7waGM@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Lorenzo Pieralisi <Lorenzo.Pieralisi-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo@kernel.o>
List-Id: linux-api@vger.kernel.org

Hi Alex,

On Wed, Jul 01, 2015 at 07:29:01PM +0100, Alex Benn=E9e wrote:
> This adds support for userspace to control the HW debug registers for
> guest debug. In the debug ioctl we copy an IMPDEF registers into a ne=
w
> register set called host_debug_state.
>=20
> We use the recently introduced vcpu parameter debug_ptr to select whi=
ch
> register set is copied into the real registers when world switch occu=
rs.
>=20
> I've made some helper functions from hw_breakpoint.c more widely
> available for re-use.
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
> Reviewed-by: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

[...]

> diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw=
_breakpoint.c
> index e7d934d..ac07f2a 100644
> --- a/arch/arm64/kernel/hw_breakpoint.c
> +++ b/arch/arm64/kernel/hw_breakpoint.c
> @@ -50,13 +50,13 @@ static int core_num_brps;
>  static int core_num_wrps;
>=20
>  /* Determine number of BRP registers available. */
> -static int get_num_brps(void)
> +int get_num_brps(void)
>  {
>         return ((read_cpuid(ID_AA64DFR0_EL1) >> 12) & 0xf) + 1;
>  }
>=20
>  /* Determine number of WRP registers available. */
> -static int get_num_wrps(void)
> +int get_num_wrps(void)
>  {
>         return ((read_cpuid(ID_AA64DFR0_EL1) >> 20) & 0xf) + 1;
>  }

Sorry, just noticed this, but we already have a public interface for
figuring these numbers out as required by perf. Can't you use
hw_breakpoint_slots(...) instead of exposing these internal helpers?

Will
