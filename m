From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 2/5] IB/uverbs: ex_query_device: check request's comp_mask
Date: Sun, 1 Feb 2015 10:12:20 +0200
Message-ID: <54CDDFE4.7030003@mellanox.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
 <335da45738872e446f63db338ca766a34608c90a.1422553023.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <335da45738872e446f63db338ca766a34608c90a.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 29/01/2015 19:59, Yann Droneaud wrote:
> This patch ensures the extended QUERY_DEVICE uverbs request's
> comp_mask has only known and supported bits (currently none).
> 
> If userspace set unknown features bits, -EINVAL will be returned,
> ensuring current programs are not allowed to set random feature
> bits: such bits could enable new extended features in future kernel
> versions and those features can trigger a behavior not unsupported
> by the older programs or make the newer kernels return an error
> for a request which was valid on older kernels.
> 
> Additionally, returning an error for unsupported feature would
> allow userspace to probe/discover which extended features are
> currently supported by a kernel.

As I wrote before, I hope in the future we don't force userspace to
probe features this way, because it may be unnecessarily complex.

I agree though that we should have a way to extend this verb in the future.

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> 
> Link: http://mid.gmane.org/cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 6ef06a9b4362..fbcc54b86795 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3312,6 +3312,9 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
>  	if (err)
>  		return err;
>  
> +	if (cmd.comp_mask)
> +		return -EINVAL;
> +
>  	if (cmd.reserved)
>  		return -EINVAL;
>  
> 
