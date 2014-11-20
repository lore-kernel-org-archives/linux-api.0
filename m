From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher
 info
Date: Thu, 20 Nov 2014 07:32:06 +0100
Message-ID: <20141120063206.GQ6390@secunet.com>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2688209.3bGZus2TD9@tachyon.chronox.de>
 <20141118140822.GB12100@gondor.apana.org.au>
 <16101836.sTaxopCThb@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16101836.sTaxopCThb@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 20, 2014 at 05:03:24AM +0100, Stephan Mueller wrote:
> 
> Btw: is there an example that uses that interface? The ordering of data 
> structures in the netlink message is not really clear from looking at the 
> code.

I wrote to tool that uses this API some time ago, it is still
a bit rudimentary but should work. You can find it at:
https://sourceforge.net/projects/crconf/
