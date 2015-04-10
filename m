From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 01/10] KVM: add commentary for kvm_debug_exit_arch
 struct
Date: Fri, 10 Apr 2015 14:58:54 +0200
Message-ID: <20150410125853.GD3227@hawk.usersys.redhat.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427814488-28467-2-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 31, 2015 at 04:07:59PM +0100, Alex Benn=E9e wrote:
> Bring into line with the commentary for the other structures and thei=
r
> KVM_EXIT_* cases.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
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

I echo David's commit message tweak, otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>
