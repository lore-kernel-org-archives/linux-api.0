From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 1/4] of: overlay: kobjectify overlay objects
Date: Wed, 21 Oct 2015 16:28:33 +0300
Message-ID: <302128B9-A82A-477D-A158-3283DE30F43A@konsulko.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com> <1445368397-8732-2-git-send-email-pantelis.antoniou@konsulko.com> <20151020210349.GA28724@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151020210349.GA28724-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Oct 21, 2015, at 00:03 , Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
>=20
> On Tue, Oct 20, 2015 at 10:13:14PM +0300, Pantelis Antoniou wrote:
>> We are going to need the overlays to appear on sysfs with runtime
>> global properties (like master enable) so turn them into kobjects.
>=20
> Why kobjects and not 'struct device=E2=80=99?
>=20

Cause it=E2=80=99s overkill.

There is no hardware/abstract device connection between an overlay and =
a device as what=E2=80=99s being used right now in driver core.

kobjs are enough to present them in the filesystem hierarchy.

> Why even have them in sysfs at all?  You need more information here a=
s
> to why you want to do this.
>=20

They have to be in sysfs so that people can have information about the =
overlays applied in the system, i.e. where their targets are and whethe=
r removal is possible. That=E2=80=99s what=E2=80=99s possible for now; =
in the future we might present the full contents of the overlay there, =
and what changes to the live tree were made.

> thanks,
>=20
> greg k-h

Regards

=E2=80=94 Pantelis
