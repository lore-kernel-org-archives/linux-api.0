From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/10] KVM: add commentary for kvm_debug_exit_arch
 struct
Date: Mon, 13 Apr 2015 12:57:44 +0200
Message-ID: <20150413105744.GL6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427814488-28467-2-git-send-email-alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, agraf-l3A5Bk7waGM@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhichao.huang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, r65777-KZfg59tc24xl57MIdRCFDg@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 31, 2015 at 04:07:59PM +0100, Alex Benn=E9e wrote:
> Bring into line with the commentary for the other structures and thei=
r
> KVM_EXIT_* cases.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>=20
> ---
>=20
> v2
>   - add comments for other exit types
>=20
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8055706..5eedf84 100644
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
> @@ -274,6 +275,7 @@ struct kvm_run {
>  			__u32 data;
>  			__u8  is_write;
>  		} dcr;
> +		/* KVM_EXIT_INTERNAL_ERROR */
>  		struct {
>  			__u32 suberror;
>  			/* Available with KVM_CAP_INTERNAL_ERROR_DATA: */
> @@ -284,6 +286,7 @@ struct kvm_run {
>  		struct {
>  			__u64 gprs[32];
>  		} osi;
> +		/* KVM_EXIT_PAPR_HCALL */
>  		struct {
>  			__u64 nr;
>  			__u64 ret;
> --=20
> 2.3.4
>=20

I'm fine with this change as it is, but I think it should update the
documenation of the kvm_run structure along with it, and in there it
seems the debug struct is listed as 'unused'; this should be addressed
in this patch set somewhere if we start using this struct?

-Christoffer
