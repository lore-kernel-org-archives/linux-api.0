From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] Docmentation, ABI: Update contact for L3 cache index
 disable
Date: Thu, 14 May 2015 11:25:19 +0200
Message-ID: <20150514092518.GB29132@pd.tnic>
References: <1431125098-9470-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431125098-9470-1-git-send-email-Aravind.Gopalakrishnan-5C7GfCeVMHo@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan-5C7GfCeVMHo@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, May 08, 2015 at 05:44:58PM -0500, Aravind Gopalakrishnan wrote:
> The mailing list discuss-Wa75r+71Mmgdnm+yROfE0A@public.gmane.org is now defunct.
> Using x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org in its place.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan-5C7GfCeVMHo@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 99983e6..f1c46d0 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -162,7 +162,7 @@ Description:	Discover CPUs in the same CPU frequency coordination domain
>  What:		/sys/devices/system/cpu/cpu*/cache/index3/cache_disable_{0,1}
>  Date:		August 2008
>  KernelVersion:	2.6.27
> -Contact:	discuss-Wa75r+71Mmgdnm+yROfE0A@public.gmane.org
> +Contact:	x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>  Description:	Disable L3 cache indices
>  
>  		These files exist in every CPU's cache/index3 directory. Each

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
