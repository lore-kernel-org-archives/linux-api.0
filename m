From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: Build failures in -next: sys_pkey_mprotect etc. undefined
Date: Mon, 12 Sep 2016 22:28:56 +0200
Message-ID: <3540553.8BkpiafJJ2@wuerfel>
References: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net> <57D70B6D.6010208@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57D70B6D.6010208-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Monday, September 12, 2016 1:09:17 PM CEST Dave Hansen wrote:
> 
> So, I've done what Arnd suggested, but I don't have a working
> cross-compiler than can do h8300 or c6x.  Could you test the attached
> patch and see if it gets things working for you?
> 
> Also, do you have a handy place to grab a cross-compiler for h8300
> without having to build one?  The kernel.org ones don't seem to work for
> h8300.
> 

I haven't tested it, but it looks good to me

Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

FWIW, you should be able to test this with an arm64 cross-compiler
too, many distros ship one.

	Arnd
