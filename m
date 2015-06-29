From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH]: MUX n_gsm debug print improvements
Date: Mon, 29 Jun 2015 09:02:38 -0700
Message-ID: <20150629160238.GA7455@kroah.com>
References: <1435593298.25711.4.camel@tldlab125>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435593298.25711.4.camel@tldlab125>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gwenn =?iso-8859-1?Q?Bourr=E9e?= <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jslaby-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 29, 2015 at 05:54:58PM +0200, Gwenn Bourr=E9e wrote:
>=20
> Dear kernel tty maintainers,
>=20
> Please review the following patch:
>=20
> From 0ac5da0a4653f43ce4b0761a2be8073185c549bb Mon Sep 17 00:00:00 200=
1
> From: Gwenn Bourree <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date: Mon, 29 Jun 2015 16:09:06 +0200
> Subject: [PATCH] Add Debug define
>=20
> Improve the debug print out and make be clearest
>=20
> Signed-off-by: Gwenn Bourree <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mustapha Ben Zoubeir <mustaphax.ben.zoubeir-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Nicolas LOUIS <nicolasx.louis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ravindran, Arun <arun.ravindran-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Any reason you didn't cc the linux-serial mailing list?  And linux-api
only cares about external api changes, which I don't think you did here=
=2E

Also, what's with the odd format, I would have to hand-edit this in
order to apply it properly.  Please fix it up and send it without the
"Dear..." lines, that's not needed at all, nor is the "From" lines.

thanks,

greg k-h
