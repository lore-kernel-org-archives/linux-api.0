From: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>
Subject: Re: [RFC][PATCH 2/2] usb: gadget: configfs: notify userspace of usb
 state changes
Date: Thu, 13 Aug 2015 17:07:42 -0500
Message-ID: <20150813220742.GA25159@saruman.tx.rr.com>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
 <1439493140-22207-3-git-send-email-amit.pundir@linaro.org>
 <55CCF319.1070604@samsung.com>
Reply-To: <balbi-l0cyMroinI0@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55CCF319.1070604-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Lockwood <lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Benoit Goby <benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Peter Oh <poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Badhri Jagan Sridharan <Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Andrzej Pietrasiewicz <andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Yegor Yefremov <yegorslists-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Philippe Reynes <tremyfr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 13, 2015 at 09:42:17PM +0200, Krzysztof Opasiak wrote:
> Hello,
>=20
> On 08/13/2015 09:12 PM, Amit Pundir wrote:
> >This is more of an RFC than an actual submission. There are few
> >scattered #ifdefs..#endifs here and there which still need to be
> >taken care of before going for actual submission.
> >
> >Currently there is no way with the upstream ConfigFS gadget to
> >communicate state changes (connected, disconnected, configured), at
> >the gadget level. Instead such state changes are handled function by
> >function independently I presume. This is problematic, because some
> >coordination between the functions, across the state changes, may be
> >desired at the userspace level. Thus to address this issue, this
> >patch send uevents to allow userspace to be notified of these usb
> >state changes, allowing userspace to respond and configure the
> >configfs gadget appropriately.
> >
> >This patch is based on an Android patchset originaly authored by
> >Badhri Jagan Sridharan<Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>  to send uevent notifications
> >to Android userpace for USB state changes. I've folded his patches
> >together and modified it enough that I don't want him to be blamed for
> >any mistakes I've made condensing his patches down.
> >
> >This patch introduces USB_CONFIGFS_UEVENT Kconfig to handle userspace
> >notifications of usb state changes, and add setup and disconnect
> >functions to intercept the setup requests from the usb_core. It also
> >creates a sysfs device class entry and a device attribute (state) to
> >read and respond to gadget's current state from userspace. As of now
> >this sysfs device class (/sys/class/android_usb) and gadget device
> >(/sys/class/android_usb/android0) with state attribute
> >(/sys/class/android_usb/android0/state) are strictly tied up to
> >facilitate Android userspace requests. But going forward we may want
> >to bring all function devices (hid, printer etc) under a unified usb
> >gadget device class e.g. /sys/class/usb_gadget/g_{func0,func1} etc..
> >
> >Also I think it make sense to add this state attribute to the configfs
> >usb gadget itself i.e. have something like /config/usb_gadget/g1/state
> >to read USB gadget's current state. Since it is going to be consistent
> >throughout all the functions tied up to that gadget.
> >
> >Again this is just an initial RFC, thoughts and feedback would be
> >greatly appreciated.
> >
> >Cc: Mike Lockwood<lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> >Cc: Benoit Goby<benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> >Cc: Colin Cross<ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> >Cc: Arve Hj=F8nnev=E5g<arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> >Cc: Peter Oh<poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >Cc: Greg Hackmann<ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >Cc: Badhri Jagan Sridharan<Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >Cc: Android Kernel Team<kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> >Cc: Greg Kroah-Hartman<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> >Cc: Jonathan Corbet<corbet-T1hC0tSOHrs@public.gmane.org>
> >Cc: Felipe Balbi<balbi-l0cyMroinI0@public.gmane.org>
> >Cc: Andrzej Pietrasiewicz<andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> >Cc: Laurent Pinchart<laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
> >Cc: Yegor Yefremov<yegorslists-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> >Cc: Philippe Reynes<tremyfr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >Cc: John Stultz<john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >Cc: Sumit Semwal<sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >Signed-off-by: Amit Pundir<amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>=20
> Generally I agree that there should be some way of notifying userspace ab=
out

yes, and we already have a sysfs file for that. See udc-core.c:

static void usb_gadget_state_work(struct work_struct *work)
{
	struct usb_gadget *gadget =3D work_to_gadget(work);
	struct usb_udc *udc =3D gadget->udc;

	if (udc)
		sysfs_notify(&udc->dev.kobj, NULL, "state");
}

void usb_gadget_set_state(struct usb_gadget *gadget,
		enum usb_device_state state)
{
	gadget->state =3D state;
	schedule_work(&gadget->work);
}
EXPORT_SYMBOL_GPL(usb_gadget_set_state);

If it's not working for any UDC, it just means the UDC needs to be
patched and if we're missing any state, it means that either the UDC
can't provide that IRQ, or we need to add more states to that
enumeration (which I find unlikely).

--=20
balbi

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVzRUuAAoJEIaOsuA1yqREU38P/iIAY1h03+3hyoMHxyzOy/J3
lHffGjBJBXP/HIkvDfo8xp8And1/VGsQ/KY1PrKC8U/rwP4to11DuVExXmmp2F6f
BPFMiBcCbonNIzWkCyg5Mck3/NPIei07vwb2jPa13GXHnnYn5Z6Culiodg5JgM8y
wVVdJ8aKLBX7rGchZXSkKJVC3iFL6AzkRPtRDlIoZXfJRKGfhrHE8SR9khjFzOJe
5CRbnkoxrwBU4cDUWFwSK9BoFv9AzqmuHuHVw5qj/ptr5DY/7PYF3ivtWTyxEkwd
d0+OM6GuCBL+VogYGBh2JMW8JnyDP+/XhLzKuzezgiAojhUhZ4EVEO5v+FAWd8YP
VKduvGTpC2pntq9nYba163e23oNVNO+5ho/26MMA18987EQpMvwec9kQ/zFfPXck
Bmj4VVRLfhS2TNAnEPDZvKUTu9kwk5rEJdnyCTgkqx7Es7tT3UndlDb8IfCYotXy
bO8z9agkpY4tqFo/ULkn5J2kNYfvax4/gVnN7+C+ODeEIgGbaP0wr0I96ImETcFl
wj4693xsJwiDAsZEPDsWp+8DdYTGmGEwHSgIPWyDp5QD0hWQOQu3vZQfzioFFS6J
MAA9ob8vzOLgVhcd6uNpExvND/KcsVibVk74a1MDQOqbd1fg9A5nh19+i5y6I0zx
dM0LDbxyxqZbSUGqkO7z
=IuqV
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
