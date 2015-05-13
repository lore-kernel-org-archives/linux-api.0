From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 4/5] doc: ABI: bone_capemgr sysfs API
Date: Wed, 13 May 2015 05:08:54 -0700
Message-ID: <20150513120854.GA1516@kroah.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1431503985-31853-5-git-send-email-pantelis.antoniou@konsulko.com>
 <20150513115259.GA1021@kroah.com>
 <28C3D47C-8D31-4DD9-8751-F72A7F09DF6F@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <28C3D47C-8D31-4DD9-8751-F72A7F09DF6F-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Robert Nelson <robertcnelson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Geert Uytterhoeven <geert+renesas-gXvu3+zWzMSzQB+pC5nmwQ@public.gmane.org>, =?iso-8859-1?Q?Beno=EEt?= Cousso <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 02:56:49PM +0300, Pantelis Antoniou wrote:
> Hi Greg,
>=20
> > On May 13, 2015, at 14:52 , Greg Kroah-Hartman <gregkh@linuxfoundat=
ion.org> wrote:
> >=20
> > On Wed, May 13, 2015 at 10:59:44AM +0300, Pantelis Antoniou wrote:
> >> Document the beaglebone's capemgr sysfs API
> >>=20
> >> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> >> ---
> >> .../testing/sysfs-devices-platform-bone_capemgr    | 63 ++++++++++=
++++++++++++
> >> 1 file changed, 63 insertions(+)
> >> create mode 100644 Documentation/ABI/testing/sysfs-devices-platfor=
m-bone_capemgr
> >>=20
> >> diff --git a/Documentation/ABI/testing/sysfs-devices-platform-bone=
_capemgr b/Documentation/ABI/testing/sysfs-devices-platform-bone_capemg=
r
> >> new file mode 100644
> >> index 0000000..e2df613
> >> --- /dev/null
> >> +++ b/Documentation/ABI/testing/sysfs-devices-platform-bone_capemg=
r
> >> @@ -0,0 +1,63 @@
> >> +What:		/sys/devices/platform/bone_capemgr/slots
> >> +Date:		May 2015
> >> +KernelVersion:	4.0
> >=20
> > I don't think that version is correct :)
> >=20
>=20
> Bah, ++
>=20
> >> +Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> >> +Description:
> >> +		READ:
> >> +		  Describe the state of all the slots of the beaglebone capemgr=
=2E
> >> +		  Each line of the output describes a slot:
> >=20
> > sysfs files are "one value per file", so a sysfs file that displays
> > multiple lines like this is not allowed at all, sorry.
> >=20
> > Please either make it a debugfs file (if this is only for debugging=
, or
> > split it out into individual files, one per slot (hint, one per slo=
t is
> > probably best.)
> >=20
>=20
> Well, it=E2=80=99s a status file. And it=E2=80=99s been used as is fo=
r a couple of years
> so it was worth a shot for backward compatibility.

There is not "backwards compatiblity" for when you do things wrong in
the first place, you can't claim that here, sorry.

And don't "try" to introduce things you know is wrong, that just makes
maintainers _very_ suspicious of everything else you are doing here...

> >> +		  The slot format is as following:
> >> +		  <slot-id>: [P-][F-][O-][l-][L-][D-] \
> >> +			  <overlay-id> <board-name>,<version>,
> >> +			  <manufacturer>,<part-number>
> >> +
> >> +		Where the flags are:
> >> +		P: Slot has been probed
> >> +		F: Slot has failed probing (i.e. no EEPROM detected)
> >> +		O: Slot has been overridden by the user
> >> +		l: Slot is current loading
> >> +		L: Slot has completed loading and is ready
> >> +		D: Slot has been disabled
> >> +
> >> +		Example:
> >> +		0: P---L-  -1 BeagleBone RS232 CAPE,00A1,Beagleboardtoys,BB-BON=
E-SERL-03
> >> +		1: PF----  -1
> >> +		2: PF----  -1
> >> +		3: PF----  -1
> >> +
> >> +		WRITE:
> >> +		  Writing a string of the form <part-number>[:version] issues a=
 request to
> >> +		  load a firmware blob containing an overlay. The name of the f=
irmware blob
> >> +		  is <part-number>-[version|00A0].dtbo. This act is defined as =
a slot override.
> >> +
> >> +		  Writing a negative slot id removes the slot if it was an over=
ridden one, or
> >> +		  unloads a slot that was probed.
> >> +
> >> +What:		/sys/devices/platform/bone_capemgr/baseboard/<eeprom-field=
>
> >> +Date:		May 2015
> >> +KernelVersion:	4.0
> >> +Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> >> +Description:	Contains the probed base board EEPROM field; one of:
> >> +		board-name		- board-name as stored in cape EEPROM
> >> +		dc-supplied		- whether the cape draws or supplies DC
> >> +		eeprom-format-revision	- EEPROM format rev, only 00A0 supported
> >> +		header			- header; should be 'aa 55 33 ee'
> >=20
> > If it's always this value, why have the file?
> >=20
>=20
> These are the contents of the EEPROM. If the format of the EEPROM cha=
nges then the
> header information will change.

Then don't say "should be", because what happens in the future if it is
not.

> >> +		manufacturer		- manufacturer string
> >> +		part-number		- part-number of the cape
> >> +		serial-number		- serial number of the cape
> >> +		version			- version of the cape, i.e. 00A0
> >> +		number-of-pins		- displayed but ignored
> >> +		pin-usage		- displayed but ignored
> >> +		sys-5v			- displayed but ignored
> >> +		vdd-3v3exp		- displayed but ignored
> >> +		vdd-5v			- displayed but ignored
> >=20
> > Are these all individual different files?
> >=20
>=20
> Yes

Then write out the individual files please as different entries.

Also, the "displayed but ignored" doesn't make sense, please fix that
up.

greg k-h
