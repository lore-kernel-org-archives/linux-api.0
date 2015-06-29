From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH]: Mux n_gsm: Add a DLCI hangup state and callback
Date: Mon, 29 Jun 2015 09:04:48 -0700
Message-ID: <20150629160448.GC7455@kroah.com>
References: <1435593236.25711.3.camel@tldlab125>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435593236.25711.3.camel@tldlab125>
Sender: linux-kernel-owner@vger.kernel.org
To: Gwenn =?iso-8859-1?Q?Bourr=E9e?= <gwenn.bourree@intel.com>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 29, 2015 at 05:53:56PM +0200, Gwenn Bourr=E9e wrote:
>=20
> Dear kernel tty maintainers,
> =20
> Please review the following patch:
>=20
> From 6e006bd522124d0e8a2f6075099a21f7051a426f Mon Sep 17 00:00:00 200=
1
> From: Gwenn Bourree <gwenn.bourree@intel.com>
> Date: Mon, 29 Jun 2015 17:26:01 +0200
> Subject: [PATCH] Mux n_gsm: Add a DLCI hangup state and callback
>=20
> Use of asynchronous hangup instead of vhangup.
>=20
> Signed-off-by: Gwenn Bourree <gwenn.bourree@intel.com>
> Signed-off-by: Gwenn Bourree <gwenn.bourree@intel.com>
> Signed-off-by: Mustapha Ben Zoubeir <mustaphax.ben.zoubeir@intel.com>
> Signed-off-by: Nicolas LOUIS <nicolasx.louis@intel.com>
> Reviewed-by: Ravindran, Arun <arun.ravindran@intel.com
>=20
> ---
>  drivers/tty/n_gsm.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)

Same comments on this one, but as you are wanting to send a series of
patches, send a series of patches, each one numbered properly, otherwis=
e
I have no idea what order to apply them in.

greg k-h
