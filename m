From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Wed, 28 Oct 2015 00:47:53 +0100
Message-ID: <1885267.SGBklDhT9E@myon.chronox.de>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <1499937.MpmApGzYrd@tauon.atsec.com> <1445989396.3405.131.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445989396.3405.131.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 28. Oktober 2015, 08:43:16 schrieb David Woodhouse:

Hi David,

> > Albeit that all sounds like the crown jewel, how do you propose that shall
> > happen?
> > 
> > Assume that you have a web server that has a pub and priv key in its
> > current configuration -- I guess that is the vast majority of configs.
> > 
> > Can you please elaborate how the process for such a web server shall
> > really
> > work?
> 
> 1. Create a kernel-side key.
> 2. Use it.
> 
> That may require adding an API similar to the one you're proposing, but
> working with kernel keys instead of directly with akcipher. Or perhaps
> the key subsystem can already offer what you need in userspace. David?

Ohh, I see. So, you are saying that there should not be a setpub/privkey for 
the akcipher AF_ALG interface?!

If somebody wants to use akcipher, he shall set the key via the keyring and 
akcipher shall obtain it from the keyring?

However, for the actual data shoveling, AF_ALG should still be used?


-- 
Ciao
Stephan
