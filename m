From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v2 03/22] fpga: bridge: remove OF dependency for
 fpga-bridge
Date: Mon, 25 Sep 2017 09:34:48 -0700
Message-ID: <20170925163448.GA14795@tyrael.ni.corp.natinst.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-4-git-send-email-hao.wu@intel.com>
 <CANk1AXSUtTLVDKFyFB99Z0mjzGtgawkykQg29sRHdfWOFhhO2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXSUtTLVDKFyFB99Z0mjzGtgawkykQg29sRHdfWOFhhO2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Wu Hao <hao.wu@intel.com>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 02, 2017 at 04:21:19PM -0500, Alan Tull wrote:
> On Sun, Jun 25, 2017 at 8:51 PM, Wu Hao <hao.wu@intel.com> wrote:
> > This patch removes OF dependency of fpga-bridge, it allows drivers
> > to use fpga-bridge class without device tree support.
> >
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEWcxjJBP2M15CncZ7vkIQd6kWqi8FAlnJMCEACgkQvkIQd6kW
qi8Lygf/ZscsU99DV9bPxeZ7AggKhYG4LyCK5VXJANOHg2hRZdm6X/gPnONoYHEo
dkNHgiOlHPkbZrsG36WB1wt3mhOTrdIhKWuQbHVc0Ba+xOKfakM/hOm2fpVSr8j9
9w0Eb04VMt2+UubCNc37fNzyTvJAjhnuVj+pgezKMi8XBCWSvnBdS3HdLG6ntius
3sCdxOE3C85sfnVrlxh6L54s96p+vZbt81ZJnEnIjSWGF3R5YzaSKq9pepWSbRLy
RgbbQDZvxtXA3W/x0d1Y9M0kY1KUOFS1A25a5ma0h0hOwamuHsqUtHH5I7qGpt/e
yJPRDvBKm0IGapWE1tANyUnaEvjfPA==
=l4qk
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
