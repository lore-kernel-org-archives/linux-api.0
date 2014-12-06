From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Date: Sun, 7 Dec 2014 07:27:34 +0800
Message-ID: <20141206232734.GA6409@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
 <20141205154606.GA30180@gondor.apana.org.au>
 <45756810.oFuGYtKPb9@tachyon.chronox.de>
 <1677221.HN3xC7fa4q@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1677221.HN3xC7fa4q-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Dec 06, 2014 at 09:08:54PM +0100, Stephan Mueller wrote:
>
> While implementing that request, I thought about setting the auth size as part 
> of the msg control in sendmsg instead of setsockopt. This would save us a 
> system call and thus CPU cycles.

No, this is a tfm property and therefore you can't set them on the
child sockets sicne two child sockets would share the same tfm.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
