From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
Date: Tue, 22 Feb 2011 15:58:19 -0800
Message-ID: <AANLkTikTCCWLUVpQXXOVB+x0J_8VRgUVr52ZQ-oVwZBx@mail.gmail.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
 <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com> <AANLkTi=wpVRSxY0HTnnJEeEN-VEOBQ7XJM5TrUu9Chqd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=wpVRSxY0HTnnJEeEN-VEOBQ7XJM5TrUu9Chqd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 22, 2011 at 3:49 PM, Rob Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Thu, Feb 17, 2011 at 1:28 PM, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> Introduce a new module "dmi-sysfs" that exports the broken out entri=
es
>> of the DMI table through sysfs.
>>
>> Entries are enumerated via dmi_walk() on module load, and are popula=
ted
>> as kobjects rooted at /sys/firmware/dmi/entries.
>>
>> Entries are named "<type>-<instance>", where:
>> =A0 <type> =A0 =A0 =A0 : is the type of the entry, and
>> =A0 <instance> =A0 : is the ordinal count within the DMI table of th=
at
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry type. =A0This instance is u=
sed in lieu the DMI
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry's handle as no assurances a=
re made by the kernel
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that handles are unique.
>>
>> All entries export the following attributes:
>
> Can you add an entry here for index/ordinal in the set of all tables?
> This way the user can walk the tables in the original order exported
> by the BIOS. =A0Some (buggy) BIOSes don't properly set up links betwe=
en
> things like MEM_ARRAY and MEM_DEVICE tables but depend on the positio=
n
> of the table relative to other tables.
>

Oh weird.  I can add an attribute called "position" if that works?
I'd rather not put the position in the directory name itself if I can
help it though, it just looks -- odd.

>> +/*
>> + * Calculate and return the byte length of the dmi entry identified=
 by
>> + * dh. =A0This includes both the formatted portion as well as the
>> + * unformatted string space, including the two trailing nul charact=
ers.
>> + */
>> +static size_t dmi_entry_length(const struct dmi_header *dh)
>> +{
>> + =A0 =A0 =A0 const char *p =3D (const char *)dh;
>> +
>> + =A0 =A0 =A0 p +=3D dh->length;
>> +
>> + =A0 =A0 =A0 while (p[0] || p[1])
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p++;
>> +
>
> Is there any chance this could walk outside of SMBIOS space on a
> corrupted table? =A0I can point you at some machines with corrupted
> tables to test on if you want.

AFAICT, this should be safe to do.  dmi_table() is the code that
iterates through the table of entries, and will not callback any
entries if it can't find the double nul characters within dmi_len
bytes (as described by the dmi table header).

I'd be happy to test this on machines that get it wrong though.  Just
add me to the auth files and IM me the hostnames :)
