From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Sat, 10 May 2014 19:18:45 +0200
Message-ID: <20140510171845.GA799@kroah.com>
References: <20140509191914.GA7286@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140509191914.GA7286@jtriplet-mobl1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, May 09, 2014 at 12:19:16PM -0700, Josh Triplett wrote:
> @@ -827,6 +898,9 @@ static const struct memdev {
>  #ifdef CONFIG_PRINTK
>  	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
>  #endif
> +#ifdef CONFIG_DEVPORT
> +	 [12] = { "ioports", 0, &ioports_fops, NULL },

Odd extra space?
