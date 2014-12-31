From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v6 4/4] crypto: AF_ALG: enable RNG interface compilation
Date: Wed, 31 Dec 2014 08:57:36 +0100
Message-ID: <18935950.yYgBXEvjNf@tachyon.chronox.de>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de> <1531939.gTKbxagG6Z@tachyon.chronox.de> <20141229104158.GB13699@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141229104158.GB13699-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Montag, 29. Dezember 2014, 21:41:58 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Dec 25, 2014 at 11:00:39PM +0100, Stephan Mueller wrote:
> > Enable compilation of the RNG AF_ALG support and provide a Kconfig
> > option to compile the RNG AF_ALG support.
> > 
> > Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
> 
> Patch applied.

May I ask you to push the change so that I can create an AEAD Makefile/Kconfig 
patch that applies cleanly?


-- 
Ciao
Stephan
