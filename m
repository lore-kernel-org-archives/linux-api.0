From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Tue, 27 Oct 2015 08:16:53 -0700
Message-ID: <562F9565.3090005@intel.com>
References: <1831785.BBs8Hj3CxY@myon.chronox.de>
 <BDD3AC1F-26D5-41D2-863B-CF8C7BF5FFEE@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BDD3AC1F-26D5-41D2-863B-CF8C7BF5FFEE-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Marcel,
On 10/26/2015 09:54 PM, Marcel Holtmann wrote:
> after having discussions with David Howells and David Woodhouse, I don't think we should expose akcipher via AF_ALG at all. I think the akcipher operations for sign/verify/encrypt/decrypt should operate on asymmetric keys in the first place. With akcipher you are pretty much bound to public and private keys and the key is the important part and not the akcipher itself. Especially since we want to support private keys in hardware (like TPM for example).
> 
> It seems more appropriate to use keyctl to derive the symmetric session key from your asymmetric key. And then use the symmetric session key id with skcipher via AF_ALG. Especially once symmetric key type has been introduced this seems to be trivial then.
> 
> I am not really in favor of having two userspace facing APIs for asymmetric cipher usage. And we need to have an API that is capable to work with hardware keys.

The main use case for algif_akcipher will be to allow a web server, which needs to handle
tens of thousand TLS handshakes per second, to offload the RSA operation to a HW accelerator.
Do you think we can use keyctl for this?
Thanks,
T
