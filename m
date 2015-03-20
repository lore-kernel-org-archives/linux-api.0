From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [Patch] firmware: dmi_scan: split dmisubsystem from dmi-sysfs
Date: Fri, 20 Mar 2015 09:16:20 +0100
Message-ID: <20150320091620.04cf733a@endymion.delvare>
References: <1426539451-2119-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1426779055.4267.1907.camel@chaos.site>
	<550B08E6.5050200@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550B08E6.5050200-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Ivan,

On Thu, 19 Mar 2015 19:35:34 +0200, Ivan.khoronzhuk wrote:
> On 19.03.15 17:30, Jean Delvare wrote:
> > Le Monday 16 March 2015 =C3=A0 22:57 +0200, Ivan Khoronzhuk a =C3=A9=
crit :
> >> Some utils, like dmidecode and smbios, need to access SMBIOS entry
> >> table area in order to get information like SMBIOS version, size, =
etc.
> >> Currently it's done via /dev/mem. But for situation when /dev/mem
> >> usage is disabled, the utils have to use dmi sysfs instead, which
> >> doesn't represent SMBIOS entry and adds code/delay redundancy when=
 direct
> >> access for table is needed.
> >>
> >> So this patch creates dmi subsystem and adds SMBIOS entry point to=
 allow
> >> utils in question to work correctly without /dev/mem. Also patch a=
dds
> >> raw dmi table to simplify dmi table processing in user space, as w=
ere
> >> proposed by Jean Delvare.
> > "as was proposed" or even "as proposed" sounds more correct.
> >
> > BTW, which tree is your patch based on? I can't get it to apply cle=
anly
> > on top of any kernel version I tried. I adjusted the patch to my tr=
ee
> > but it means I'm not reviewing your code exactly. Please send patch=
es
> > which can be applied on top of some recent vanilla tree (3.19 or 4.=
0-rc4
> > would be OK at the moment.)
>=20
> Oh, sorry I forgot to mention, it's based on efi/next, but with consu=
mption
> that Matt will remove old version:
>   85c83ea firmware: dmi-sysfs: Add SMBIOS entry point area attribute
>=20
> As you remember, your propositions were slightly late,
> and patch had been applied on efi/next when you commented.

OK, I understand. Now I see the two patches I was missing, I'll pick
them so that I can apply your patch cleanly on top of my tree.

I would have appreciated to be Cc'd on these two patches, so I knew
they existed, and maybe I could even have commented on them.

> >> (...)
> >> @@ -118,6 +124,7 @@ static void dmi_table(u8 *buf,
> >>   }
> >>  =20
> >>   static phys_addr_t dmi_base;
> >> +static u8 *dmi_tb;
> > Where "tb" stands for... "table", but you couldn't use that because=
 a
> > function by that name already exist, right? I can think of two less
> > cryptic ways to solve this: either you rename function dmi_table to=
,
> > say, dmi_decode_table (which would be a better name anyway IMHO), o=
r you
> > name your variable dmi_table_p or dmi_raw_table. But "tb" is not
> > immediate enough to understand.
>=20
> If others are OK, I'll better rename dmi_table function to=20
> dmi_decode_table()
> (or maybe dmidecode_table :), joke)
> as it's more appropriate to what it's doing.
> And accordingly dmi_tb to dmi_table.

Yes, that's fine with me. The function rename should be a separate
patch for clarity.

> >> (...)
> >>   static int __init dmi_walk_early(void (*decode)(const struct dmi=
_header *,
> >>   		void *))
> >> @@ -476,6 +483,8 @@ static int __init dmi_present(const u8 *buf)
> >>   	if (memcmp(buf, "_SM_", 4) =3D=3D 0 &&
> >>   	    buf[5] < 32 && dmi_checksum(buf, buf[5])) {
> >>   		smbios_ver =3D get_unaligned_be16(buf + 6);
> >> +		smbios_entry_point_size =3D buf[5];
> >> +		memcpy(smbios_entry_point, buf, smbios_entry_point_size);
> >>  =20
> >>   		/* Some BIOS report weird SMBIOS version, fix that up */
> >>   		switch (smbios_ver) {
> >> @@ -508,6 +517,8 @@ static int __init dmi_present(const u8 *buf)
> >>   					dmi_ver >> 8, dmi_ver & 0xFF,
> >>   					(dmi_ver < 0x0300) ? "" : ".x");
> >>   			} else {
> >> +				smbios_entry_point_size =3D 15;
> >> +				memcpy(smbios_entry_point, buf, 15);
> >>   				dmi_ver =3D (buf[14] & 0xF0) << 4 |
> >>   					   (buf[14] & 0x0F);
> >>   				pr_info("Legacy DMI %d.%d present.\n",
> >> @@ -535,6 +546,8 @@ static int __init dmi_smbios3_present(const u8=
 *buf)
> >>   		dmi_ver &=3D 0xFFFFFF;
> >>   		dmi_len =3D get_unaligned_le32(buf + 12);
> >>   		dmi_base =3D get_unaligned_le64(buf + 16);
> >> +		smbios_entry_point_size =3D buf[6];
> >> +		memcpy(smbios_entry_point, buf, smbios_entry_point_size);
> >>  =20
> >>   		/*
> >>   		 * The 64-bit SMBIOS 3.0 entry point no longer has a field
> > This is inconsistent. You should either use smbios_entry_point_size=
 as
> > the last argument to memcpy() in all 3 cases (my preference), or yo=
u
> > should use buf[5], 15 and buf[6] respectively, but not mix.
>=20
> You probably meant "memcpy(smbios_entry_point, buf, 15)"

Yes.

> Just wanted to avoid redundant line break.

Line breaks are just fine, code consistency is more important.

> >> (...)
> >> +	if (!smbios_entry_point_size || !dmi_available) {
> > I already mentioned in a previous review that I don't think you nee=
d to
> > check for !dmi_available, and you said you agreed.
>=20
> No.
> Previously only smbios entry point was exported.
> Now DMI table was added.
> smbios_entry_point_size doesn't mean DMI table is present.

Thanks for the explanation, I understand the reasoning now. I can see
how smbios_entry_point_size could be set while dmi_available would
not. But I can't see how dmi_available could be set and
smbios_entry_point_size would not. So I think checking for
dmi_available is enough?

> >> (...)
> >> +		goto err;
> >> +	}
> >> +
> >> +	/* Set up dmi directory at /sys/firmware/dmi */
> >> +	dmi_kobj =3D kobject_create_and_add("dmi", firmware_kobj);
> >> +	if (!dmi_kobj)
> >> +		goto err;
> >> +
> >> +	bin_attr_smbios_entry_point.size =3D smbios_entry_point_size;
> >> +	ret =3D sysfs_create_bin_file(dmi_kobj, &bin_attr_smbios_entry_p=
oint);
> >> +	if (ret)
> >> +		goto err;
> >> +
> >> +	if (!dmi_tb) {
> > I don't like this. You should know which of this function and dmi_w=
alk()
> > is called first. If you don't, then how can you guarantee that a ra=
ce
> > condition can't happen?
>=20
> Shit.
> Maybe better to leave dmi_walk as it was
> and map it only here.

=46or the time being, yes, that might be better. We can always optimize
it later in a separate patch.

> > This makes me wonder if that code wouldn't rather go in
> > dmi_scan_machine() rather than a separate function.

> >> (...)
> >> +		dmi_tb =3D dmi_remap(dmi_base, dmi_len);
> >> +		if (!dmi_tb)
> >> +			goto err;
> >> +	}
> >> +
> >> +	bin_attr_dmi_table.size =3D dmi_len;
> >> +	ret =3D sysfs_create_bin_file(dmi_kobj, &bin_attr_dmi_table);
> >> +	if (ret)
> >> +		goto err;
> >> +
> >> +	return 0;
> >> +err:
> >> +	pr_err("dmi: Firmware registration failed.\n");
> >
> > I said in a previous review that files that have been created shoul=
d be
> > explicitly deleted, and I still think so.
>=20
> I dislike it, but if you insist I'll do this.

I'm only repeating something I was told myself when submitting that
kind of code long ago. Almost all other drivers seem to be cleaning up
such files explicitly, just look at the firmware drivers, efivars for
example.

If you don't want to do it, I don't really mind, that's an error path
that most probably nobody will ever walk unless explicitly testing it.
But then if something breaks, you'll be asked to fix it.

> >> (...)
> >> +	kobject_del(dmi_kobj);
> >> +	kobject_put(dmi_kobj);
> > I think you also need to explicitly set dmi_kobj to NULL here, othe=
rwise
> > dmi-sysfs will try to use an object which no longer exists.
>=20
> Yes.
>=20
> > An alternative approach would be to leave dmi_kobj available even i=
f the
> > binary files could not be created. As this case is very unlikely to
> > happen, I don't care which way you choose.
>=20
> I also thought about such approach. But imaged a situation when DMI=20
> catalog is
> empty and no one uses dmi-sysfs (which probably is more frequently), =
decided
> to delete it. So dmi_kobj =3D 0.

=46ine with me (but =3D NULL, not =3D 0.)

Thanks,
--=20
Jean Delvare
SUSE L3 Support
