From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [PATCH] fcntl.h: Fix a typo
Date: Mon, 2 Feb 2015 19:18:40 +1100
Message-ID: <20150202191840.4207c7f3@canb.auug.org.au>
References: <54CF2A94.9080107@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Yq36=ooA3VtgCUm2h75VZk3"; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54CF2A94.9080107-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--Sig_/Yq36=ooA3VtgCUm2h75VZk3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Mon, 02 Feb 2015 08:43:16 +0100 Bart Van Assche <bart.vanassche@sandisk.=
com> wrote:
>
> In the source file fs/fcntl.c and also in the fcntl() man page one
> can see that the FD_CLOEXEC flag can be manipulated via F_GETFD and
> F_SETFD. Update the comment in <fcntl.h> accordingly.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> ---
>  include/uapi/asm-generic/fcntl.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/=
fcntl.h
> index e063eff..584fa2b 100644
> --- a/include/uapi/asm-generic/fcntl.h
> +++ b/include/uapi/asm-generic/fcntl.h
> @@ -157,7 +157,7 @@ struct f_owner_ex {
>  	__kernel_pid_t	pid;
>  };
> =20
> -/* for F_[GET|SET]FL */
> +/* for F_[GET|SET]FD */
>  #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
> =20
>  /* for posix fcntl() and lockf() */
> --=20
> 2.1.4

Looks good to me

Acked-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Sig_/Yq36=ooA3VtgCUm2h75VZk3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUzzLlAAoJEMDTa8Ir7ZwVaioP/RES7NLfULrk/MTUbByi8rWG
3d9yPEI6oxXDmIzmldj6zap83Q5dGRy0A0UButnjIJeqIRv6BGX0YTRaOpHuhQSj
kTMGnl+52mQSGShOWtRNR9uNFfFk7KdRlbxqnIQxVB+DeAH+Lu9W3PnFdQ1H5iR+
xEH+Uj4NQw2Uwh8DPwi0vPuOdyupze/IxpcCggeYAciJZnTZksMnBBJphUX1Mwfj
qSciwtYKs8oAyuU79WaClfGMkviBIexIPHdRnd2CX3crKH2xdoNK+cvhvatJDCwM
lxgIbC06YUoHw2LqYriLTJ/i+poMpRQvBUjOiIT2zyp/AoU2zxVyFdlTLkl26RTU
ro8rg90IbGDhPb+y2GQ2wcu6mQAV0kbHBcmyZmvZhbfes4y1eAPSGubICcMWP8Xf
z9xM56+8VwuU1StfRzMX86QAQIJhNnEve87l4ywwvT2jtY6dqlTuyJjLIGsDTrl0
eEfHnhHtmZ05/bqNF8xcW3Qb+ImGK8R0v2tGsUfuG256FCWtNHokHEgpX5lTQIA3
iPEz5CPhdCFGwWBlP03KC7BxxF12/ubpaG4JMW7Nd2LjBI5JBCwcqnw0DT4wA2UJ
SQ0u5yretaxj546tds9TLuF2A/AzMY96IWteicKXgp2HwFqW5y/kgaF5byOn5E7a
o/0rjkw/LD4f6ENx8LdB
=410Z
-----END PGP SIGNATURE-----

--Sig_/Yq36=ooA3VtgCUm2h75VZk3--
