From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 6/5] Fix unaligned memory accesses in dmi-sysfs
Date: Fri, 25 Feb 2011 15:20:39 -0800
Message-ID: <20110225232039.GA10930@kroah.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
 <4D6835F1.2050304@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D6835F1.2050304-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 25, 2011 at 03:06:25PM -0800, Mike Waychison wrote:
> DMI entries are arranged in memory back to back with no alignment
> guarantees. This means that the struct dmi_header passed to callbacks
> from dmi_walk() itself isn't byte aligned.  This causes problems on
> architectures that expect aligned data, such as IA64.
> 
> The dmi-sysfs patchset introduced structure member accesses through
> this passed in dmi_header.  Fix this by memcpy()ing the structures to
> temporary locations on stack when inspecting/copying them.
> 
> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Tested-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  dmi-sysfs.c |   28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
> index a5afd80..eb26d62 100644
> --- a/drivers/firmware/dmi-sysfs.c
> +++ b/drivers/firmware/dmi-sysfs.c
> @@ -263,20 +263,16 @@ struct dmi_system_event_log {
>  	u8	supported_log_type_descriptos[0];
>  } __packed;
> 
> -static const struct dmi_system_event_log *to_sel(const struct
> dmi_header *dh)

This patch is corrupted.  I tried to edit it by hand, but git still
didn't like it.

Please resend using whatever you did for your other patches, as this way
was not correct :(

thanks,

greg k-h
