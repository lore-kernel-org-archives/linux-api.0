From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Tue, 27 Oct 2015 11:50:04 +0100
Message-ID: <9859277.cZClo5B21s@tauon.atsec.com>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <1979544.kURdYDnObN@tauon.atsec.com> <1445937541.3405.75.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445937541.3405.75.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 27. Oktober 2015, 18:19:01 schrieb David Woodhouse:

Hi David,
>
>That's largely orthogonal to the point Marcel was making.
>
>The point is that akcipher is limited to using keys for which we have
>the private key material available directly in software. We cannot

Agreed.

>expose that critically limited API to userspace. We need to expose an
>API which supports hardware keys, and basically that means using the
>kernel's key subsystem.

Agreed. But at the same time, that interface should be able to support the use 
case where the software wants to be in control (just take OpenSSL as the 
simple example where you can add an engine for the Linux kernel backed RSA 
operation).

Note, the goal with AF_ALG is simply to expose asymmetric hardware support to 
user space for unspecified use cases to make user space faster.
>
>For a key which *happens* to be in software, the key subsystem may end
>up *using* akcipher behind the scenes. But the API we expose to
>userspace cannot simply be based on akcipher.

So, how do you propose that would work? Based on what I understand the 
suggested logic flow for a simple OpenSSL-like approach would be:

1. OpenSSL opens the interface with the kernel key subsystem and sends the 
pub/priv key along
 
2. the key subsystem hooks the key in

3. the key subsystem sees that there is a simple RSA operation to be made

4. the key subsystem initiates an akcipher operation and sends the keys along

5. the akcipher returns the cipher result to the key subsystem

6. the key subsystem sends the data to user space

Currently I fail to understand why that key subsystem would help me in that 
common use case (note, I totally understand to use the key subsystem when you 
have some key management schema in place).

Also, I fail to see that this logic flow would be fast to warrant a detour 
from user land into kernel land for an RSA operation.

Thanks
Stephan
