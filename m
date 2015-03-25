From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] vt: add cursor blink interval escape sequence
Date: Wed, 25 Mar 2015 12:19:49 +0100
Message-ID: <20150325111949.GA24230@kroah.com>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
 <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
 <20150225094946.GA24627@amd>
 <alpine.LNX.2.11.1502252319330.276@localhost>
 <20150226220243.GC9935@amd>
 <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1502271911380.4248@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Machek <pavel@ucw.cz>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 27, 2015 at 07:13:48PM +0000, Scot Doyle wrote:
> Add an escape sequence to specify the current console's cursor blink
> interval. The interval is specified as a number of milliseconds until
> the next cursor display state toggle, from 50 to 65535. /proc/loadavg
> did not show a difference with a one msec interval, but the lower
> bound is set to 50 msecs since slower hardware wasn't tested.
> 
> Store the interval in the vc_data structure for later access by fbcon,
> initializing the value to fbcon's current hardcoded value of 200 msecs.
> 
> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
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

Where is this now documented?  Is this a "standard" ASCII command
somewhere?  Adding new userspace apis have to be documented properly.

Without that, I can't take this series, sorry.

greg k-h
