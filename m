From: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] crypto: AF_ALG: add random number generator support
Date: Wed, 12 Nov 2014 18:51:59 +0100
Message-ID: <54639E3F.2010504@redhat.com>
References: <4738444.A2vZX1nNCo@tachyon.chronox.de> <9137675.ZTbqvCU5Bi@tachyon.chronox.de> <5463978F.7020508@redhat.com> <26219337.yCCTlAE9Ns@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26219337.yCCTlAE9Ns@tauon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/12/2014 06:46 PM, Stephan Mueller wrote:
...
> * I unconditionally use the memset after memcpy as you indicated. Once
> the cryptodev tree contains the memzero_explicit call, I will start
> picking up that function.

Herbert merged it actually in this morning, so it's already part of
the cryptodev tree by now.

> Essentially, I throught of the line you suggested.

Ok, thanks.
