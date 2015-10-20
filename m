From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 0/4] of: overlay: kobject & sysfs'ation
Date: Wed, 21 Oct 2015 00:11:00 +0300
Message-ID: <BFDE85A8-5F13-4CB7-A027-2E7BEB8A8F1C@konsulko.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKzwUeZp=pBcxh=4kBhY-6EQDozBweiACUYW1L=1gC4SQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqKzwUeZp=pBcxh=4kBhY-6EQDozBweiACUYW1L=1gC4SQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Oct 21, 2015, at 00:06 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>=20
> On Tue, Oct 20, 2015 at 2:13 PM, Pantelis Antoniou
> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>> The first patch puts the overlays as objects in the sysfs in
>> /sys/firmware/devicetree/overlays.
>>=20
>> The next adds a master overlay enable switch (that once is set to
>> disabled can't be re-enabled), while the one after that
>> introduces a number of default per overlay attributes.
>>=20
>> The patchset is against linus's tree as of today.
>>=20
>> The last patch updates the ABI docs for the sysfs entries.
>=20
> I think I told you I would take patches 1 and 2 if you split out the
> sysfs documentation for that part of it.
>=20

Sorry, but I haven=E2=80=99t seen them being picked up anywhere, so I r=
esent them to be on the safe side.

> Rob

Regards

=E2=80=94 Pantelis
