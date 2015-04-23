From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 3/4] of: overlay: Add sysfs attributes
Date: Thu, 23 Apr 2015 15:04:09 +0200
Message-ID: <20150423130409.GA4437@kroah.com>
References: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1428434632-13789-4-git-send-email-pantelis.antoniou@konsulko.com>
 <CAL_JsqLMVBfQpmSjg9qfOvtM3RXMY3Dm+knN8h54gDCzx513-g@mail.gmail.com>
 <6E391B8F-936A-4FD1-B8CC-C9B5FCE0B291@konsulko.com>
 <20150423123346.GA19166@kroah.com>
 <98237E9E-04CB-4CD5-8B2F-63F070B54459@konsulko.com>
 <20150423125441.GA32303@kroah.com>
 <5F0BA9FB-8345-4296-8595-0E4CD1C816AA@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5F0BA9FB-8345-4296-8595-0E4CD1C816AA@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 23, 2015 at 03:59:02PM +0300, Pantelis Antoniou wrote:
> >>>> It=E2=80=99s the same reason that the device tree core is using =
it.
> >>>=20
> >>> It is doing that for "raw" device tree files, not individual attr=
ibutes,
> >>> right?
> >>>=20
> >>=20
> >> Each property of a device tree is a binary attribute.
> >=20
> > Because they export binary data, right?  I don't have access to a
> > machine that uses device tree at the moment to check this...
> >=20
> > Any specific file/function you are referring to?
> >=20
>=20
> Yes, they export binary data. It works because the device tree nodes
> are raw kobjs.

Great, then the device tree is doing this correctly :)

=46or text files, use real attribute files, that's the proper way to
handle sysfs from kobjects.

thanks,

greg k-h
