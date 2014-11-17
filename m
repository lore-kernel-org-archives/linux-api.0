From: Karol Lewandowski <lmctlx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] kdbus: extend structures with security pointer for
 lsm
Date: Mon, 17 Nov 2014 02:47:32 +0100
Message-ID: <20141117014732.GA21745@pix>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
 <1414773397-26490-2-git-send-email-k.lewandowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414773397-26490-2-git-send-email-k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, r.krypa-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 31, 2014 at 05:36:33PM +0100, Karol Lewandowski wrote:
> Signed-off-by: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/misc/kdbus/bus.h        | 2 ++
>  drivers/misc/kdbus/connection.h | 2 ++
>  drivers/misc/kdbus/domain.h     | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/drivers/misc/kdbus/bus.h b/drivers/misc/kdbus/bus.h
> index fd9d843..5c403ef 100644
> --- a/drivers/misc/kdbus/bus.h
> +++ b/drivers/misc/kdbus/bus.h
> @@ -49,6 +49,7 @@
>   * @conn_hash:		Map of connection IDs
>   * @monitors_list:	Connections that monitor this bus
>   * @meta:		Meta information about the bus creator
> + * @security:		LSM security blob
>   *
>   * A bus provides a "bus" endpoint / device node.
>   *
> @@ -84,6 +85,7 @@ struct kdbus_bus {
>  	struct list_head monitors_list;
>  
>  	struct kdbus_meta *meta;
> +	void *security;

One minor note - with possibility of LSM modules trying to access
these structures it would be worth to have kdbus headers in, say
include/linux/kdbus or similar globally accessible location.

Thanks
