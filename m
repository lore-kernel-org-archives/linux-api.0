From: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 5/5] firmware: Add documentation for /sys/firmware/dmi
Date: Thu, 17 Feb 2011 13:50:15 -0800
Message-ID: <AANLkTi=_8iU+QVTo+bDUjDc=md7E=fW6HpNuf_EFW2Nn@mail.gmail.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com> <20110217212821.3967.22439.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110217212821.3967.22439.stgit-tzAwxxnF6Tt6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 17, 2011 at 1:28 PM, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrot=
e:
> Document the new ABI added by the dmi-sysfs module.
>
> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> =A0Documentation/ABI/testing/sysfs-firmware-dmi | =A0101 ++++++++++++=
++++++++++++++
> =A01 files changed, 101 insertions(+), 0 deletions(-)
> =A0create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi
>
> diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documenta=
tion/ABI/testing/sysfs-firmware-dmi
> new file mode 100644
> index 0000000..c6526b0
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-dmi
> @@ -0,0 +1,101 @@
> +What: =A0 =A0 =A0 =A0 =A0/sys/firmware/dmi/
> +Date: =A0 =A0 =A0 =A0 =A0February 2011
> +Contact: =A0 =A0 =A0 Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> +Description:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Many machine's firmware (x86 and ia64) =
export DMI /

machines'

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMBIOS tables to the operating system. =
=A0Getting at this
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 information is often valuable to userla=
nd, especially in
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cases where there are OEM extensions us=
ed.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 The kernel itself does not rely on the =
majority of the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 information in these tables being corre=
ct. =A0It equally
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cannot ensure that the data as exported=
 to userland is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 without error either.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMI is structured as a large table of e=
ntries, where
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 each entry has a common header indicati=
ng the type and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length of the entry, as well as 'handle=
' that is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 supposed to be unique amongst all entri=
es.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Some entries are required by the specif=
ication, but many
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 others are optional. =A0In general thou=
gh, user's should

users

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 never expect to find a specific entry t=
ype on their
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 system unless they know for certain wha=
t their firmware
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 is doing. =A0Machine to machine will va=
ry.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Multiple entries of the same type are a=
llowed. =A0In order
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 to handle these duplicate entry types, =
each entry is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 assigned by the operating system an 'in=
stance', which is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 derived from an entry type's ordinal po=
sition. =A0That is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 to say, if there are 'N' multiple entri=
es with the same type
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 'T' in the DMI tables (adjacent or spre=
ad apart, it
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 doesn't matter), they will be represent=
ed in sysfs as
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 entries "T-0" through "T-(N-1)":
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Example entry directories:
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /sys/firmware/dmi/entri=
es/17-0
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /sys/firmware/dmi/entri=
es/17-1
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /sys/firmware/dmi/entri=
es/17-2
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /sys/firmware/dmi/entri=
es/17-3
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ...
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Instance numbers are used in lieu of th=
e firmware
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 assigned entry handles as there is kern=
el itself makes

s/there is/the/

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 no guarantees that handles as exported =
are unique, and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 there are likely firmware images that g=
et this wrong in
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 the wild.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Each DMI entry in sysfs has the common =
header values
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 exported as attributes:
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =A0: The 16bit 'handle' that is =
assigned to this
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry by the firmwa=
re. =A0This handle may be
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 referred to by othe=
r entries.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =A0: The length of the entry, as=
 presented in the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry itself. =A0No=
te that this is _not the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total count of byte=
s associated with the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry_. =A0This val=
ue represents the length of
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the "formatted" por=
tion of the entry. =A0This
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "formatted" region =
is sometimes followed by
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the "unformatted" r=
egion composed of nul
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 terminated strings,=
 with termination signalled
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 by a two nul charac=
ters in series.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 raw =A0 =A0 : The raw bytes of the entr=
y. This includes the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "formatted" portion=
 of the entry, the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "unformatted" strin=
gs portion of the entry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 and the two termina=
ting nul characters.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=3D=3D Entry Specialization =3D=3D=3D
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Some entry types may have other informa=
tion available in
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sysfs.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 --- Type 15 - System Event Log ---
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 This entry allows the firmware to expor=
t a log of
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 events the system has taken. =A0This in=
formation is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 typically backed by nvram, but the impl=
ementation
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 details are abstracted by this table. =A0=
This entries data
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 is exported in the directory:
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /sys/firmware/dmi/entries/15-0/system_e=
vent_log
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 and has the following attributes (docum=
ented in the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMBIOS / DMI specification under "Syste=
m Event Log (Type 15)":
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 area_length
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 header_start_offset
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_start_offset
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 access_method
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 change_token
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 access_method_address
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 header_format
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 per_log_type_descriptor_length
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 type_descriptors_supported_count
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 As well, the kernel exports the binary =
attribute:
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 raw_event_log =A0 : The raw binary bits=
 of the event log
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 as =
described by the DMI entry.
>
>
