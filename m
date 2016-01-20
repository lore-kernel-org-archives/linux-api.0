From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH v3] fuse: Add support for passthrough read/write
Date: Thu, 21 Jan 2016 00:38:41 +0100
Message-ID: <20160120233841.GA16235@pc.thejh.net>
References: <56A01642.7030806@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56A01642.7030806@codeaurora.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Cc: torvalds@linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@linuxfoundation.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Richard Weinberger <richard.weinberger@gmail.com>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, Antonio SJ Musumeci <trapexit@spawn.link>, sven.utcke@gmx.de, Nikolaus Rath <nikolaus@rath.org>, Jann Horn <jannhorn@googlemail.com>
List-Id: linux-api@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 20, 2016 at 03:20:34PM -0800, Nikhilesh Reddy wrote:
> Add support for filesystem passthrough read/write of files
> when enabled in userspace through the option FUSE_PASSTHROUGH.
[...]
> +	daemon_fd = (int)open_out->passthrough_fd;
> +	if (daemon_fd < 0)
> +		return;
> +
> +	passthrough_filp = fget_raw(daemon_fd);
> +	if (!passthrough_filp)
> +		return;
> +
> +	passthrough_inode = file_inode(passthrough_filp);
> +	passthrough_sb = passthrough_inode->i_sb;
> +	fs_stack_depth = passthrough_sb->s_stack_depth + 1;
> +
> +	/* If we reached the stacking limit go through regular io */
> +	if (fs_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
> +		pr_err("FUSE: maximum fs stacking depth exceeded, cannot use passthrough for this file\n");
> +		return;
> +	}

I think this needs an fput() in the error case to prevent a refcount leak.

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWoBqBAAoJED4KNFJOeCOoysQP/RhUnDXn54/ikdhN9KEqKwuK
9FgoLmdIUAWVMCWdZ36nvj2t5E+fgPAYTQ/YiSowSY+F/2nPz+6MuUOUw14r9d7j
1LjOm6dIdjT35zDdVV6hGmuwZEE57lJL08gDNLFvbvlQm3Pe6+nWhaZG7DueUgrW
KzB8/GTQybvYk0lZYopRfnlNf6jkSYEg31ZOzsxErlxJSuPTflVMSnSDCBblLhTJ
03Za2+6hKGy97iWQyU0t3UvFFXJ5n7rSYvlClqMiJ4J+OdGaqucIs0VCHeTrjvuE
9umCrpq0rz5E59DTORrQ9vVePTTg2qAT3Pvgkfh9dapY0FkdfJRzERChjK8SI8JM
P3LkDbV51uRv+ctIPU78vXLB2R7HkUf32bqpT/noUKYOkHQ5DW33Cu+K5X8awBi6
bugIGprCsHJz4A3e3CqSTo9yNmqKXkbPWAMUc2gtReUQFouaqQc+brHGU9GwD1Ic
BkeGiLS03YcFykuxfv7wrE/XfaYoD4oDbNDJsuzOWByCxPR9oByCdiRx3fexuRL1
3Tk7F60/N2bg7Vdgfo5X2+JvpaJi5rsi/dBR0Bb+xpAKnk3Z1vi91SIsEzcGOoSj
Aa26iJpXj5eZ06bP3fRyHojX8zMe2qQVwXWyIKodNPpAWNivaYUEpgpSLXx70KwL
VuDQOe7R9UNHYTsaIw/V
=zkJj
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
