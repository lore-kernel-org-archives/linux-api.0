From: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/22] fpga: bridge: remove OF dependency for
 fpga-bridge
Date: Thu, 21 Sep 2017 12:11:09 -0700
Message-ID: <20170921191109.GA7814@tyrael.ni.corp.natinst.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-4-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498441938-14046-4-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 26, 2017 at 09:51:59AM +0800, Wu Hao wrote:
> This patch removes OF dependency of fpga-bridge, it allows drivers
> to use fpga-bridge class without device tree support.
>=20
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/fpga/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index ed600d5..c1d8f41 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -75,7 +75,6 @@ config FPGA_MGR_ZYNQ_FPGA
> =20
>  config FPGA_BRIDGE
>  	tristate "FPGA Bridge Framework"
> -	depends on OF

Shouldn't that dependency be removed in the patch that removes the
dependency, or was the dependency never there in the first place?

>  	help
>  	  Say Y here if you want to support bridges connected between host
>  	  processors and FPGAs or between FPGAs.
> --=20
> 1.8.3.1
>=20

Thanks,

Moritz

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEWcxjJBP2M15CncZ7vkIQd6kWqi8FAlnEDscACgkQvkIQd6kW
qi9dFAf+LaKa0COHduicmXWIMRRM01UyaFy5dwfLS8TbcyF7QznXUojU56YX1jly
GFQLuIIrfm8ddThl7nxvZi79gHxzexE13kg9WI3OeuKaQhFmyYTmXAJSaReeB4Bl
7EJaYz6PxGlpRfZlylqZghKUGXVsFDrxFIwtKzA5dt1Y7GOU2CtIBOKOVq1VdDYb
ytBsRta8CfflggqEmuAUEoH71QIsQyJLdp3RcMuYvIb2H/1XgBIs+V3hXJXgeXQ2
AlVGwBA9Q9SDp5UvBWaswJednfUMk/DNA78hx6Pbs4hPGLdEqG2DoBeXwUey4U2f
CdQDlEjrfQZ51Bs6Ya6dJ0xoGmnfrw==
=2mmH
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
