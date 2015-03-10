From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [dmidecode] [Patch v4] firmware: dmi-sysfs: add SMBIOS entry
 point area attribute
Date: Tue, 10 Mar 2015 10:13:27 +0100
Message-ID: <1425978807.24849.22.camel@chaos.site>
References: <1423069563-26467-1-git-send-email-ivan.khoronzhuk@linaro.org>
	 <20150226103622.09b9870a@endymion.delvare> <54F6FAE7.30801@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F6FAE7.30801-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Ivan,

Sorry for the late reply. I think I addressed some points in other
replies already, but for completeness let me reply to this post too.

Le Wednesday 04 March 2015 =C3=A0 14:30 +0200, Ivan.khoronzhuk a =C3=A9=
crit :
> On 02/26/2015 11:36 AM, Jean Delvare wrote:
> > On Wed,  4 Feb 2015 19:06:03 +0200, Ivan Khoronzhuk wrote:
> >> diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Docume=
ntation/ABI/testing/sysfs-firmware-dmi
> >> index c78f9ab..3a9ffe8 100644
> >> --- a/Documentation/ABI/testing/sysfs-firmware-dmi
> >> +++ b/Documentation/ABI/testing/sysfs-firmware-dmi
> >> @@ -12,6 +12,16 @@ Description:
> >>   		cannot ensure that the data as exported to userland is
> >>   		without error either.
> >>  =20
> >> +		The firmware provides DMI structures as a packed list of
> >> +		data referenced by a SMBIOS table entry point. The SMBIOS
> >> +		entry point contains general information, like SMBIOS
> >> +		version, DMI table size, etc. The structure, content and
> >> +		size of SMBIOS entry point is dependent on SMBIOS version.
> >> +		That's why SMBIOS entry point is represented in dmi sysfs
> >> +		like a raw attribute and is accessible via
> >> +		/sys/firmware/dmi/smbios_raw_header. The format of SMBIOS
> > As mentioned before, I don't like the name "smbios_raw_header". I t=
hink
> > it should be "smbios_entry_point" or similar.
>=20
> If Matt is OK to get another version,
> Let it be smbios_entry_point.
> If it's more convenient, it should be changed while it's possible.

Great, thanks.

> >> @@ -669,6 +699,18 @@ static int __init dmi_sysfs_init(void)
> >>   		goto err;
> >>   	}
> >>  =20
> >> +	smbios_raw_header =3D dmi_get_smbios_entry_area(&size);
> >> +	if (!smbios_raw_header) {
> >> +		pr_debug("dmi-sysfs: SMBIOS raw data is not available.\n");
> >> +		error =3D -EINVAL;
> >> +		goto err;
> >> +	}
> > I don't think this should have been a fatal error. Just because for
> > some reason dmi_get_smbios_entry_area() returned NULL is no good re=
ason
> > for nor exposing /sys/firmware/dmi/entries as we used to.
>=20
> It issues an error only in case of when entry table is not available,
> if entry point is absent then dmi table is not available a fortiori.
> So there is no reason to continue from that point.

Well it could also fail because of an error in the code ;-) But OK, I
agree with you here.

> > But anyway this is no longer relevant if the code is moved to dmi_s=
can
> > as I suggested.
> >
> >> +
> >> +	/* Create the raw binary file to access the entry area */
> >> +	smbios_raw_area_attr.size =3D size;
> >> +	if (sysfs_create_bin_file(dmi_kobj, &smbios_raw_area_attr))
> >> +		goto err;
> > I think this should have had a corresponding call to
> > sysfs_remove_bin_file() in dmi_sysfs_exit(). (Again no longer relev=
ant
> > if the code is moved.)
>=20
> The removing is done in kobject_del().
> Doesn't it? In another way it should be done for
> dmi/entries/*/raw attributes also.

It _is_ done for other attributes already:

	kset_unregister(dmi_kset);

Which is exactly why I believe it should be done for
smbios_raw_area_attr too. All other kernel drivers are calling
sysfs_create_bin_file() or equivalent in their cleanup function and I
see no reason why this driver would be an exception.

> > There's one thing I do not understand. I seem to understand that th=
e
> > goal behind this patch is to be able to run dmidecode without /dev/=
mem.
> > Dmidecode currently reads 2 areas from /dev/mem: the 0xF0000-0xFFFF=
=46
> > area in search of the entry point, and the DMI data table itself. W=
ith
> > this patch you make the entry point available through sysfs. But
> > dmidecode will still need to access /dev/mem to access the DMI data
> > table. So that does not really solve anything, does it?
>=20
> It's supposed to read DMI table via entries presented by dmi-sysfs.
> It contains raw attributes that can be used for these purposes.
> No need to use /dev/mem.

Yes, I understood this meanwhile, sorry.

> Another case if you want to add binary of whole dmi table to be able =
to
> read it directly in order to parse in dmidecode w/o any additional he=
adache
> with open/close. Well, it partly dupes currently present dmi-sysfs.

In fact dmi-sysfs already duplicates a lot of code which was already
present in dmidecode and libsmbios. And exporting the raw table will
require way less code than the implementation you proposed originally.
So the code duplication argument doesn't hold, sorry.

> But it simplifies dmi table parsing for dmidecode, and who wants to u=
se
> dmi-sysfs, let them use it, but dmidecode will be reading raw entry.
> Well let it be. Why not.

Yes, this is exactly my point.

> If others are OK, for dmidecode, and probably others tools also,
> kernel can constantly expose two tables under /sys/firmware/dmi/table=
s/
> smbios_entry_point and dmi_table. Independently on dmi-sysfs.

That's what I would like to see implemented, yes, thank you very much.

--=20
Jean Delvare
SUSE L3 Support
