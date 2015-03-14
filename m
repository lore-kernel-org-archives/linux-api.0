From: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 1/2] vt: add cursor blink interval escape sequence
Date: Sat, 14 Mar 2015 17:48:13 +0000 (GMT)
Message-ID: <alpine.DEB.2.11.1503141728120.1887@local>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain> <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain> <20150225094946.GA24627@amd> <alpine.LNX.2.11.1502252319330.276@localhost> <20150226220243.GC9935@amd> <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.11.1502271911380.4248@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 27 Feb 2015, Scot Doyle wrote:
> Add an escape sequence to specify the current console's cursor blink
> interval. The interval is specified as a number of milliseconds until
> the next cursor display state toggle, from 50 to 65535. /proc/loadavg
> did not show a difference with a one msec interval, but the lower
> bound is set to 50 msecs since slower hardware wasn't tested.
> 
> Store the interval in the vc_data structure for later access by fbcon,
> initializing the value to fbcon's current hardcoded value of 200 msecs.
> 
> Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
> Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>

Hi Greg, sorry about your backlog. Is it too soon for a ping?

> ---
>  drivers/tty/vt/vt.c            | 9 +++++++++
>  include/linux/console_struct.h | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 6e00572..ab1f173 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -135,6 +135,7 @@ const struct consw *conswitchp;
>   */
>  #define DEFAULT_BELL_PITCH	750
>  #define DEFAULT_BELL_DURATION	(HZ/8)
> +#define DEFAULT_CURSOR_BLINK_MS	200
>  
>  struct vc vc_cons [MAX_NR_CONSOLES];
>  
> @@ -1590,6 +1591,13 @@ static void setterm_command(struct vc_data *vc)
>  		case 15: /* activate the previous console */
>  			set_console(last_console);
>  			break;
> +		case 16: /* set cursor blink duration in msec */
> +			if (vc->vc_npar >= 1 && vc->vc_par[1] >= 50 &&
> +					vc->vc_par[1] <= USHRT_MAX)
> +				vc->vc_cur_blink_ms = vc->vc_par[1];
> +			else
> +				vc->vc_cur_blink_ms = DEFAULT_CURSOR_BLINK_MS;
> +			break;
>  	}
>  }
>  
> @@ -1717,6 +1725,7 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
>  
>  	vc->vc_bell_pitch = DEFAULT_BELL_PITCH;
>  	vc->vc_bell_duration = DEFAULT_BELL_DURATION;
> +	vc->vc_cur_blink_ms = DEFAULT_CURSOR_BLINK_MS;
>  
>  	gotoxy(vc, 0, 0);
>  	save_cur(vc);
> diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
> index e859c98..e329ee2 100644
> --- a/include/linux/console_struct.h
> +++ b/include/linux/console_struct.h
> @@ -104,6 +104,7 @@ struct vc_data {
>  	unsigned int    vc_resize_user;         /* resize request from user */
>  	unsigned int	vc_bell_pitch;		/* Console bell pitch */
>  	unsigned int	vc_bell_duration;	/* Console bell duration */
> +	unsigned short	vc_cur_blink_ms;	/* Cursor blink duration */
>  	struct vc_data **vc_display_fg;		/* [!] Ptr to var holding fg console for this display */
>  	struct uni_pagedir *vc_uni_pagedir;
>  	struct uni_pagedir **vc_uni_pagedir_loc; /* [!] Location of uni_pagedir variable for this console */
> -- 
> 2.3.0
> 
