From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V
 host messages
Date: Fri, 24 Oct 2014 15:14:25 +0000
Message-ID: <c05e07e89fff4419b8c6a545507067ec@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1414146027-1915-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1414146027-1915-1-git-send-email-vkuznets@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jason Wang <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Friday, October 24, 2014 3:20 AM
> To: linux-api@vger.kernel.org; KY Srinivasan
> Cc: Greg Kroah-Hartman; Jason Wang; linux-kernel@vger.kernel.org
> Subject: [PATCH] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V
> host messages
> 
> An attempt to fix fcopy on i586 (bc5a5b0 Drivers: hv: util: Properly pack the
> data for file copy functionality) led to a regression on x86_64 (and actually
> didn't fix
> i586 breakage). Fcopy messages from Hyper-V host come in the following
> format:
> 
> struct do_fcopy_hdr   |   36 bytes
> 0000                  |    4 bytes
> offset                |    8 bytes
> size                  |    4 bytes
> data                  | 6144 bytes
> 
> On x86_64 struct hv_do_fcopy matched this format without '
> __attribute__((packed))'
> and on i586 adding ' __attribute__((packed))' to it doesn't change anything.
> Keep the structure packed and add padding to match re reality. Tested both
> i586 and x86_64 on Hyper-V Server 2012 R2.

Thanks Vitaly.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
> ---
>  include/uapi/linux/hyperv.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h index
> 0a8e6ba..bb1cb73 100644
> --- a/include/uapi/linux/hyperv.h
> +++ b/include/uapi/linux/hyperv.h
> @@ -134,6 +134,7 @@ struct hv_start_fcopy {
> 
>  struct hv_do_fcopy {
>  	struct hv_fcopy_hdr hdr;
> +	__u32   pad;
>  	__u64	offset;
>  	__u32	size;
>  	__u8	data[DATA_FRAGMENT];
> --
> 1.9.3
