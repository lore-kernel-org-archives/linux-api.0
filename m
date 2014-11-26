From: Andrew Jones <drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/7] KVM: add commentary for kvm_debug_exit_arch struct
Date: Wed, 26 Nov 2014 15:20:40 +0100
Message-ID: <20141126142040.GA3245@hawk.usersys.redhat.com>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1416931805-23223-2-git-send-email-alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 25, 2014 at 04:09:59PM +0000, Alex Benn=E9e wrote:
> Bring into line with the commentary for the other structures and thei=
r
> KVM_EXIT_* cases.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>=20
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6076882..523f476 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -226,6 +226,7 @@ struct kvm_run {
>  			__u32 count;
>  			__u64 data_offset; /* relative to kvm_run start */
>  		} io;
> +		/* KVM_EXIT_DEBUG */
>  		struct {
>  			struct kvm_debug_exit_arch arch;
>  		} debug;
> --=20
> 2.1.3

Can we change this to a 'KVM: add commentary for kvm exit type data'
patch? We're also missing

/* KVM_EXIT_INTERNAL_ERROR */

and

/* KVM_EXIT_PAPR_HCALL */

>=20
> _______________________________________________
> kvmarm mailing list
> kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
