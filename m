From: James Hogan <jhogan@kernel.org>
Subject: Re: [PATCH 7/7] aio: implement io_pgetevents
Date: Fri, 18 May 2018 09:28:38 +0100
Message-ID: <20180518082837.GA3264@jamesdev>
References: <20180502211448.18276-1-hch@lst.de>
 <20180502211448.18276-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180502211448.18276-8-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Given this:

On Wed, May 02, 2018 at 11:14:48PM +0200, Christoph Hellwig wrote:
> +struct __aio_sigset {
> +	sigset_t __user	*sigmask;
> +	size_t		sigsetsize;
> +};

and:

> +asmlinkage long sys_io_pgetevents(aio_context_t ctx_id,
> +				long min_nr,
> +				long nr,
> +				struct io_event __user *events,
> +				struct timespec __user *timeout,
> +				const struct __aio_sigset *sig);

The following paragraph in the commit message would appear to be
misleading since __aio_sigset contains a size:

> Note that unlike many other signal related calls we do not pass a sigmask
> size, as that would get us to 7 arguments, which aren't easily supported
> by the syscall infrastructure.  It seems a lot less painful to just add a
> new syscall variant in the unlikely case we're going to increase the
> sigset size.

Is it possible to correct it before this gets merged?

Thanks
James

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQS7lRNBWUYtqfDOVL41zuSGKxAj8gUCWv6OtAAKCRA1zuSGKxAj
8nzxAQC7f4RLhmqTHYo86l9+4h8Ta0h4zflObA+py2hwfuGW2wD/a+C9QJzr4ybw
XxWoWxP/rKTTnqobNheJw5wH6+HiqgQ=
=7rhk
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
