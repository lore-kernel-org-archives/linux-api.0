From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Build failures in -next: sys_pkey_mprotect etc. undefined
Date: Mon, 12 Sep 2016 13:34:54 -0700
Message-ID: <57D7116E.4050708@linux.intel.com>
References: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net>
 <57D70B6D.6010208@linux.intel.com> <3540553.8BkpiafJJ2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3540553.8BkpiafJJ2@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/12/2016 01:28 PM, Arnd Bergmann wrote:
> FWIW, you should be able to test this with an arm64 cross-compiler
> too, many distros ship one.

arm64 build fine for me with and without the patch.  There must be
something else specific to h8300 and the other broken architectures.

Is there some other part of the configuration that could be hiding the
issue in my arm64 build?
