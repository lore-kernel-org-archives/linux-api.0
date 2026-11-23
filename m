Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795428412;
	b=WhzZZb1BCPeNTFAWO3EiC2qf0AhK2Yw2OLeuz6c8BVje1X0FfXXOXq9mSwmIGflgzwoq
	 GvGKWwT0YkSVesf0SsUP957xQTwV8EgztK8vlNLytmPbcTw4pxrpGN+tUgvPdIsSv5v2s
	 pyOSmpEwBj7cIj/NsV6DlheJ8r2FuXnGbZSBMrYn0gtNNe1H3UM9kq3j9t2fdavXpDbf3
	 3HT9uquHpp+gpMy8R5JA6JN0sK1k4A2GGWNWh2oWBgzRY4PHIMKYzVRVxGRBZBvtajfMp
	 r50vKa1SesLQTkrbRlyvcIbLJSrGU8Tef3gT9ceR/jlgG8Iq9+3Ez7U2ODM2a01WQ2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795428412;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=KXp8naU/etmC1VzahAxeSl9qV7f97STu4n9jviVbfzQ=;
	b=yYWq2n1h2+o67dk908UunKlIGJ55yC3yq9kOrN+XCaRPMyr9f07JkeYOWMtXIQ+yox5C
	 lse7l563ASbKklFjsPf+nvihe4szuO/tPIbLqWEARWNHRQ0aTVkMXxEdso7zdkF+XRQ5Q
	 OFmnQV9GphXf6EkNuVu5Mz5OyNw4T2tXiJp2MLSlhQKp5T/cIMMn1TbNuAqUhk9i20/S6
	 pttDpZqCMRCpF0qXOmX+QrT08OFoYkhrDFgjFoX1foFD4OhphMxmHh6xwjSvSjZwlB/JJ
	 e5dFNF9n6vBhgMTCaYICcFkWHSQuDJI6AOuuMlihJhdIhCrYUtdvenhsoWzGKFzu8YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=a65fkKFL;
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BFA606A31E;
	Mon, 23 Nov 2026 10:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91BFA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=a65fkKFL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795428412; x=1826964412;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Ess3+l1NPR4G1pg355/cS8UNqaTJ67pbJVkEocweOh8=;
  b=a65fkKFL9X7mJSYWGvD1dh8BvjOhmYLQip+1G0OoFPs05hO6diMyMFJX
   zkp+/rCGjg7ONzZFud4/W/wiQ1Vifcus6tM4ZMAZSB7W9ZtO8Vy1t+L0Z
   esCmVRVMQdtjo6Qks0vBZfWCZilsrHcltMDGfSEsssHPwaLbJbUG2TCle
   dei7x1UM1K9yy+9esoumUi4wbRNGIX23BGoIpaBcOlJKeCv35qa1yWzV5
   01zWJAR3gNBmbcwmGasumfgWJB52k7hNSucFzk0UX86K5/n5qutz8QV8n
   u3HKQHkSXF2h87kK2VYgsBdMcJGNYlrlaL/L2NF+h8nLWng8zAiVhoNxS
   g==;
X-CSE-ConnectionGUID: KxwPW3efTMiyAYp3JUYlOg==
X-CSE-MsgGUID: 7550G2oUR0iwR+m/58GHjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11974"; a="4102001"
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="4102001"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 02:06:50 -0800
X-CSE-ConnectionGUID: OnwBYAuqSRKz2YcAMp3Ikw==
X-CSE-MsgGUID: K6uXUYQsQrWbleJJoA80lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="11672414"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.225])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 02:06:45 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 23 Nov 2026 12:06:42 +0200 (EET)
To: alan <alanpluto@163.com>
cc: Rong Zhang <i@rong.moe>, platform-driver-x86@vger.kernel.org, 
    Mark Pearson <mpearson-lenovo@squebb.ca>, derekjohn.clark@gmail.com, 
    W_Armin@gmx.de, Hans de Goede <hansg@kernel.org>, corbet@lwn.net, 
    skhan@linuxfoundation.org, rdunlap@infradead.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
    linux-api@vger.kernel.org
Subject: Re: [PATCH] platform/x86: lenovo-wmi-other: Add raw GetDataByPackage
 interface
In-Reply-To: <06c29ea2-c9d4-4e9b-bbe8-651ad868a9c4@163.com>
Message-ID: <600d2462-c586-3b58-3176-64a1330c583c@linux.intel.com>
References: <20261116040532.154928-1-alanpluto@163.com> <4377ff90ffd0b030de7d4d33c188ba4b7551ad03.camel@rong.moe> <06c29ea2-c9d4-4e9b-bbe8-651ad868a9c4@163.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-171610986-1795428402=:1065"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-171610986-1795428402=:1065
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 23 Nov 2026, alan wrote:

> Hi Rong,
>=20
> =E5=9C=A8 2026/11/16 20:44, Rong Zhang =E5=86=99=E9=81=93:
> > Hi Alan,
> >=20
> > Thanks for working on this.
> >=20
> > On Mon, 2026-11-16 at 12:05 +0800, Alan Pluto wrote:
> >> Expose Lenovo Other Mode WMI GetDataByPackage, method 99, through a
> >> root-only character device so userspace can access the raw firmware
> >> interface. And document the interface.
> >=20
> > What's the practical purpose of the interface? Did you use this to tune
> > anything on your device?
> >=20
> >>
> >> The upstream driver was build-tested with W=3D1 and checked with Spars=
e.
> >> A backport using the five-argument wmidev_invoke_method() interface
> >> was tested on Ubuntu 7.0.0-42 with Lenovo hardware. The upstream 7.4
> >> driver has not been tested on hardware.
> >=20
> > Don't include this in the commit message, but rather send a cover lette=
r
> > or place it under `---'.
> >=20
> >>
> >> Signed-off-by: Alan Pluto <alanpluto@163.com>
> >=20
> > Is the work assisted by LLM?
> >=20
> >> ---
> >>  Documentation/ABI/testing/dev-tac             |  49 +++
> >>  .../wmi/devices/lenovo-wmi-other.rst          |   8 +
> >>  MAINTAINERS                                   |   1 +
> >>  drivers/platform/x86/lenovo/wmi-other.c       | 325 +++++++++++++++++=
+
> >>  4 files changed, 383 insertions(+)
> >>  create mode 100644 Documentation/ABI/testing/dev-tac
> >>
> >> diff --git a/Documentation/ABI/testing/dev-tac b/Documentation/ABI/tes=
ting/dev-tac
> >> new file mode 100644
> >> index 00000000000..a8be8e95e2d
> >> --- /dev/null
> >> +++ b/Documentation/ABI/testing/dev-tac
> >> @@ -0,0 +1,49 @@
> >> +What:           /dev/tac[0-9]*
> >> +Date:           November 2026
> >> +Contact:        platform-driver-x86@vger.kernel.org
> >> +Description:
> >> +                Lenovo Other Mode WMI GetDataByPackage (method 99).
> >> +                Each firmware WMI instance gets a misc character devi=
ce with
> >> +                mode 0600.=C2=A0
> >>
> >=20
> > Why would you need to add a character device instead of a debugfs file?
> > See also lwmi_debugfs_create_dir().
> >=20
> > IMHO the interface is quite internal and undocumented. Exposing it as a
> > character device makes it too reachable for users, unnecessarily
> > increases the complexity of the driver, and requires some sorts of ABI
> > stability.
> >=20
> >> Numbering follows allocation order, not necessarily
> >> +                the firmware instance number.=C2=A0
> >>
> >=20
> > You must be using a wordy LLM if you are using one. Isn't this just
> > obvious and natural for most character devices?
> >=20
> >> Registration does not probe
> >> +                support for method 99. The parent is the bound WMI de=
vice.
> >=20
> > If it can't be probed, gate it unless a module parameter is set.
> >=20
> >> +
> >> +                Open with O_RDWR. One write submits one complete requ=
est of
> >> +                1..100 raw bytes; shorter requests are padded with ze=
roes to
> >> +                100 bytes. Empty and oversized writes fail with EINVA=
L without
> >=20
> > sed -E 's/\bE[A-Z]+\b/-\0/g'
> >=20
> >> +                calling firmware. Successful writes return the full s=
ubmitted
> >> +                length and execute two identical WMI calls for the BI=
OS
> >> +                duplicate-call workaround.=C2=A0
> >>
> >=20
> >> Request pairs through this
> >> +                interface are serialized; calls made by other driver
> >> +                interfaces are not covered by this serialization.
> >=20
> > Why would you need to mention cross-interface implementation details in=
 a
> > user-facing documentation?
> >=20
> >> +                Evaluation failures abort the pair; the driver does n=
ot
> >> +                automatically retry.
> >> +
> >> +                Each open file description owns its response.=C2=A0
> >>
> >=20
> > Why would you need to support multiple writers? Couldn't you simply
> > return -EBUSY when there is a pending writer/reader?
> >=20
> >> A write while
> >> +                that response remains unread fails with EBUSY, includ=
ing after
> >> +                partial reads.=C2=A0
> >>
> >=20
> > If userspace must write all data at once, why would you need to support
> > partial reads?
> >=20
> >> A new open cannot read another open's response.
> >> +                Descriptors shared by dup/fork share the same transac=
tion;
> >> +                applications must coordinate the complete write/read =
sequence.
> >=20
> > Aren't these just obvious and natural for most character devices, too?
> >=20
> >> +
> >> +                Read returns little-endian u32 DataSize followed by e=
xactly
> >> +                DataSize data bytes. Response storage is erased when =
fully
> >> +                read or closed. Further reads return EOF until a new =
successful
> >> +                write. Before a successful write, or after a failed f=
irmware
> >> +                evaluation, reads return ENODATA. A zero-length read =
returns
> >> +                zero without consuming data.
> >> +
> >> +                Requests are synchronous even with O_NONBLOCK. Seekin=
g and
> >> +                positional I/O are not supported.=C2=A0
> >>
> >=20
> > Aren't these just the default characteristic for most non-block charact=
er
> > devices?
> >=20
> >> There is no ioctl interface.
> >=20
> > Too verbose. If you don't say it has some, it's obvious that it has non=
e.
> >=20
> >> +                A removed WMI device causes nonempty reads and valid =
writes
> >> +                on existing descriptors to fail with ENODEV.
> >> +
> >> +                Firmware evaluation failures map to EIO. WMI marshall=
ing
> >> +                failures return the error reported by the WMI subsyst=
em.
> >> +                A truncated response or invalid DataSize maps to EPRO=
TO.
> >> +                Bad userspace memory maps to EFAULT. Failure does not=
 imply
> >> +                firmware had no side effects; never blindly resubmit =
commands.
> >> +                Interrupted waits can return EINTR before firmware ev=
aluation.
> >=20
> > Obvious, no?
> >=20
> >> +
> >> +                The WMI subsystem converts returned ACPI objects to a=
 buffer.
> >=20
> > Yet another implementation detail.
> >=20
> >> +                This raw firmware interface may change device state. =
Use only
> >> +                commands whose behavior and side effects are understo=
od.
> >> diff --git a/Documentation/wmi/devices/lenovo-wmi-other.rst b/Document=
ation/wmi/devices/lenovo-wmi-other.rst
> >> index 011054d64ea..ec85fdeeb7a 100644
> >> --- a/Documentation/wmi/devices/lenovo-wmi-other.rst
> >> +++ b/Documentation/wmi/devices/lenovo-wmi-other.rst
> >> @@ -33,6 +33,10 @@ under the following path:
> >> =20
> >>  Additionally, this driver also exports attributes to HWMON.
> >> =20
> >> +The driver also exposes GetDataByPackage (method 99) through a raw ch=
aracter
> >> +device for each WMI instance. See Documentation/ABI/testing/dev-tac f=
or the
> >> +request and response format and its access restrictions.
> >> +
> >>  LENOVO_CAPABILITY_DATA_00
> >>  -------------------------
> >> =20
> >> @@ -109,6 +113,10 @@ WMI interface description
> >>  The WMI interface description can be decoded from the embedded binary=
 MOF (bmof)
> >>  data using the `bmfdec <https://github.com/pali/bmfdec>`_ utility:
> >> =20
> >> +The example below describes an older firmware revision and specifies =
a
> >> +40-byte maximum input for GetDataByPackage. Newer firmware uses a 100=
-byte
> >> +input, which is the size used by the raw interface described above.
> >> +
> >>  ::
> >> =20
> >>    [WMI, Dynamic, Provider("WmiProv"), Locale("MS\\0x409"), Descriptio=
n("LENOVO_OTHER_METHOD class"), guid("{dc2a8805-3a8c-41ba-a6f7-092e0089cd3b=
}")]
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 981eb3fdbef..84b1545f525 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -15168,6 +15168,7 @@ M:=09Derek J. Clark <derekjohn.clark@gmail.com=
>
> >>  M:=09Rong Zhang <i@rong.moe>
> >>  L:=09platform-driver-x86@vger.kernel.org
> >>  S:=09Maintained
> >> +F:=09Documentation/ABI/testing/dev-tac
> >>  F:=09Documentation/wmi/devices/lenovo-wmi-gamezone.rst
> >>  F:=09Documentation/wmi/devices/lenovo-wmi-other.rst
> >>  F:=09drivers/platform/x86/lenovo/*
> >> diff --git a/drivers/platform/x86/lenovo/wmi-other.c b/drivers/platfor=
m/x86/lenovo/wmi-other.c
> >> index bd64e7b4466..c15b3a2a758 100644
> >> --- a/drivers/platform/x86/lenovo/wmi-other.c
> >> +++ b/drivers/platform/x86/lenovo/wmi-other.c
> >> @@ -34,16 +34,23 @@
> >>  #include <linux/device.h>
> >>  #include <linux/export.h>
> >>  #include <linux/firmware_attributes.h>
> >> +#include <linux/fs.h>
> >>  #include <linux/gfp_types.h>
> >>  #include <linux/hwmon.h>
> >>  #include <linux/idr.h>
> >>  #include <linux/kdev_t.h>
> >>  #include <linux/kobject.h>
> >> +#include <linux/kref.h>
> >>  #include <linux/limits.h>
> >> +#include <linux/miscdevice.h>
> >>  #include <linux/module.h>
> >> +#include <linux/mutex.h>
> >>  #include <linux/platform_profile.h>
> >>  #include <linux/power_supply.h>
> >> +#include <linux/slab.h>
> >>  #include <linux/types.h>
> >> +#include <linux/uaccess.h>
> >> +#include <linux/unaligned.h>
> >>  #include <linux/wmi.h>
> >> =20
> >>  #include <acpi/battery.h>
> >> @@ -91,6 +98,9 @@ enum lwmi_feature_id_psu {
> >>  #define LWMI_FEATURE_VALUE_GET 17
> >>  #define LWMI_FEATURE_VALUE_SET 18
> >> =20
> >> +#define LWMI_DATA_PACKAGE_GET 99
> >> +#define LWMI_DATA_PACKAGE_INPUT_MAX 100
> >> +
> >>  #define LWMI_FAN_ID_BASE 1
> >>  #define LWMI_FAN_NR 4
> >>  #define LWMI_FAN_ID(x) ((x) + LWMI_FAN_ID_BASE)
> >> @@ -115,6 +125,27 @@ enum lwmi_feature_id_psu {
> >> =20
> >>  static DEFINE_IDA(lwmi_om_ida);
> >> =20
> >> +static DEFINE_IDA(lwmi_tac_ida);
> >> +static DEFINE_MUTEX(lwmi_tac_lock);
> >> +
> >> +struct lwmi_tac {
> >> +=09struct miscdevice misc;
> >> +=09struct kref ref;
> >> +=09struct wmi_device *wdev;
> >> +=09u8 instance;
> >> +=09int id;
> >> +};
> >> +
> >> +struct lwmi_tac_file {
> >> +=09struct lwmi_tac *tac;
> >> +=09/* Protects the per-open response and its position. */
> >> +=09struct mutex lock;
> >> +=09void *result;
> >> +=09size_t result_len;
> >> +=09loff_t position;
> >> +=09bool completed;
> >> +};
> >> +
> >>  enum attribute_property {
> >>  =09DEFAULT_VAL,
> >>  =09MAX_VAL,
> >> @@ -1609,6 +1640,295 @@ static void lwmi_om_fw_attr_remove(struct lwmi=
_om_priv *priv)
> >>  =09priv->ida_id =3D -EIDRM;
> >>  }
> >> =20
> >> +/**
> >> + * lwmi_tac_free() - Free an unregistered endpoint after its last clo=
se
> >> + * @ref: Reference belonging to the endpoint.
> >> + */
> >> +static void lwmi_tac_free(struct kref *ref)
> >> +{
> >> +=09struct lwmi_tac *tac =3D container_of(ref, struct lwmi_tac, ref);
> >> +
> >> +=09ida_free(&lwmi_tac_ida, tac->id);
> >> +=09kfree(tac->misc.name);
> >> +=09kfree(tac);
> >> +}
> >> +
> >> +/**
> >> + * lwmi_tac_open() - Allocate independent response state for an open =
file
> >> + * @inode: Character device inode.
> >> + * @file: File initially pointing to the registered miscdevice.
> >> + *
> >> + * The misc core serializes open against deregistration, so the regis=
tration
> >> + * reference remains valid while the file acquires its own reference.
> >> + *
> >> + * Return: 0 on success, or -ENOMEM.
> >> + */
> >> +static int lwmi_tac_open(struct inode *inode, struct file *file)
> >> +{
> >> +=09struct lwmi_tac *tac =3D container_of(file->private_data, struct l=
wmi_tac, misc);
> >> +=09struct lwmi_tac_file *state;
> >> +
> >> +=09state =3D kzalloc_obj(*state);
> >> +=09if (!state)
> >> +=09=09return -ENOMEM;
> >> +=09mutex_init(&state->lock);
> >> +=09state->tac =3D tac;
> >> +=09kref_get(&tac->ref);
> >> +=09file->private_data =3D state;
> >> +=09return stream_open(inode, file);
> >=20
> > Add line breaks to improve readability. Same for the following methods.
> >=20
> >> +}
> >> +
> >> +/**
> >> + * lwmi_tac_release() - Erase the response and drop the endpoint refe=
rence
> >> + * @inode: Character device inode.
> >> + * @file: File holding the endpoint state.
> >> + *
> >> + * Return: 0.
> >> + */
> >> +static int lwmi_tac_release(struct inode *inode, struct file *file)
> >> +{
> >> +=09struct lwmi_tac_file *state =3D file->private_data;
> >> +
> >> +=09kfree_sensitive(state->result);
> >=20
> > Why on earth is it sensitive?
> >=20
> >> +=09mutex_destroy(&state->lock);
> >> +=09kref_put(&state->tac->ref, lwmi_tac_free);
> >> +=09kfree(state);
> >> +=09return 0;
> >> +}
> >> +
> >> +/**
> >> + * lwmi_tac_invoke() - Execute GetDataByPackage and retain the respon=
se
> >> + * @state: Open file whose response buffer is empty.
> >> + * @data: Zero-padded 100-byte input buffer.
> >> + *
> >> + * The caller holds state->lock and lwmi_tac_lock.=C2=A0
> >>
> >=20
> > Add lockdep assertions instead of stating them in comments.
> >=20
> >> The latter serializes call
> >> + * pairs across instances and keeps the WMI device valid during evalu=
ation.
> >> + *
> >> + * Return: 0 on success, or a negative error code.
> >> + */
> >> +static int lwmi_tac_invoke(struct lwmi_tac_file *state, u8 *data)
> >> +{
> >> +=09struct lwmi_tac *tac =3D state->tac;
> >> +=09struct wmi_buffer input =3D { .length =3D LWMI_DATA_PACKAGE_INPUT_=
MAX, .data =3D data };
> >> +=09struct wmi_buffer output;
> >> +=09u32 data_size;
> >> +=09int ret;
> >> +
> >> +=09if (!tac->wdev)
> >> +=09=09return -ENODEV;
> >> +=09/*
> >> +=09 * Duplicated call required to match BIOS workaround for behavior
> >> +=09 * seen when WMI accessed via scripting on other OS.
> >=20
> > Reference? Where is the script?
> >=20
> >> +=09 */
> >> +=09for (unsigned int call =3D 0; call < 2; call++) {
> >> +=09=09ret =3D wmidev_invoke_method(tac->wdev, tac->instance,
> >> +=09=09=09=09=09   LWMI_DATA_PACKAGE_GET, &input, &output, 0);
> >> +=09=09if (ret)
> >> +=09=09=09return ret;
> >> +=09=09if (!call)
> >> +=09=09=09kfree_sensitive(output.data);
> >> +=09}
> >> +=09/* Validate DataSize before preserving the complete firmware respo=
nse. */
> >=20
> > Don't retell what the code does, but rather explain why.
> >=20
> >> +=09if (output.length < sizeof(__le32)) {
> >=20
> > Why not use wmidev_invoke_method()'s min_size argument?
> >=20
> >> +=09=09ret =3D -EPROTO;
> >> +=09=09goto free_output;
> >> +=09}
> >> +=09data_size =3D get_unaligned_le32(output.data);
> >=20
> > wmidev_invoke_method() returns aligned data.
> >=20
> >> +=09if (data_size > output.length - sizeof(__le32)) {
> >> +=09=09ret =3D -EPROTO;
> >> +=09=09goto free_output;
> >> +=09}
> >> +=09/* Transfer ownership without another allocation after firmware ra=
n. */
> >> +=09state->result =3D output.data;
> >=20
> > Use __free() and no_free_ptr().
> >=20
> >> +=09state->result_len =3D sizeof(__le32) + data_size;
> >=20
> > Couldn't you declare a struct with a flex array member to represent thi=
s?
> >=20
> >> +=09state->position =3D 0;
> >> +=09state->completed =3D true;
> >> +=09return 0;
> >> +free_output:
> >> +=09kfree_sensitive(output.data);
> >> +=09return ret;
> >> +}
> >> +
> >> +/**
> >> + * lwmi_tac_write() - Submit one complete TAC request
> >=20
> > "complete"
> >=20
> > Obvious.
> >=20
> >> + * @file: Open TAC endpoint with independent response state.
> >> + * @buffer: Userspace input bytes.
> >> + * @count: Input size, from 1 to 100 bytes.
> >> + * @ppos: Unused;=20
> >>
> >=20
> >> TAC is a nonseekable request/response stream.
> >=20
> > Obvious.
> >=20
> >> + *
> >> + * Short inputs are zero-padded. An unread response must be consumed =
before
> >> + * submitting another request. A failed firmware call is never retrie=
d here.
> >> + *
> >> + * Return: @count on success, or a negative error code.
> >> + */
> >> +static ssize_t lwmi_tac_write(struct file *file, const char __user *b=
uffer,
> >> +=09=09=09      size_t count, loff_t *ppos)
> >> +{
> >> +=09struct lwmi_tac_file *state =3D file->private_data;
> >> +=09u8 input[LWMI_DATA_PACKAGE_INPUT_MAX] =3D {};
> >> +=09int ret;
> >> +
> >> +=09if (!count || count > sizeof(input))
> >> +=09=09return -EINVAL;
> >> +=09if (copy_from_user(input, buffer, count)) {
> >> +=09=09ret =3D -EFAULT;
> >> +=09=09goto clear_input;
> >> +=09}
> >> +=09ret =3D mutex_lock_interruptible(&state->lock);
> >> +=09if (ret)
> >> +=09=09goto clear_input;
> >> +=09ret =3D mutex_lock_interruptible(&lwmi_tac_lock);
> >> +=09if (ret)
> >> +=09=09goto unlock;
> >=20
> > Use scoped_cond_guard() or ACQUIRE().
> >=20
> >> +=09if (!state->tac->wdev) {
> >> +=09=09ret =3D -ENODEV;
> >> +=09} else if (state->result) {
> >> +=09=09ret =3D -EBUSY;
> >> +=09} else {
> >> +=09=09state->completed =3D false;
> >> +=09=09ret =3D lwmi_tac_invoke(state, input);
> >> +=09}
> >> +=09mutex_unlock(&lwmi_tac_lock);
> >> +unlock:
> >> +=09mutex_unlock(&state->lock);
> >> +clear_input:
> >> +=09memzero_explicit(input, sizeof(input));
> >=20
> > Why on earth is it sensitive, too?
> >=20
> >> +=09if (ret)
> >> +=09=09return ret;
> >> +=09return count;
> >> +}
> >> +
> >> +/**
> >> + * lwmi_tac_read() - Read only this open file's firmware response
> >=20
> > "only"
> >=20
> > Obvious, no?
> >=20
> >> + * @file: Open TAC endpoint.
> >> + * @buffer: Userspace destination.
> >> + * @count: Maximum number of bytes to return.
> >> + * @ppos: Unused;=C2=A0the response position is protected by state->l=
ock.
> >> + *
> >> + * Responses contain little-endian u32 DataSize followed by Data. Par=
tial
> >> + * reads advance the response position. Consuming the result erases i=
ts
> >> + * storage immediately; subsequent reads return EOF until another wri=
te.
> >> + *
> >> + * Return: Bytes read, 0 at EOF or for zero @count, or a negative err=
or code.
> >> + */
> >> +static ssize_t lwmi_tac_read(struct file *file, char __user *buffer,
> >> +=09=09=09     size_t count, loff_t *ppos)
> >> +{
> >> +=09struct lwmi_tac_file *state =3D file->private_data;
> >> +=09ssize_t ret;
> >> +
> >> +=09if (!count)
> >> +=09=09return 0;
> >> +=09ret =3D mutex_lock_interruptible(&state->lock);
> >> +=09if (ret)
> >> +=09=09return ret;
> >> +=09ret =3D mutex_lock_interruptible(&lwmi_tac_lock);
> >> +=09if (ret)
> >> +=09=09goto unlock;
> >> +=09if (!state->tac->wdev)
> >> +=09=09ret =3D -ENODEV;
> >> +=09mutex_unlock(&lwmi_tac_lock);
> >> +=09if (ret) {
> >> +=09=09kfree_sensitive(state->result);
> >> +=09=09state->result =3D NULL;
> >> +=09=09goto unlock;
> >> +=09}
> >> +=09if (!state->completed) {
> >> +=09=09ret =3D -ENODATA;
> >> +=09=09goto unlock;
> >> +=09}
> >> +=09if (!state->result)
> >> +=09=09goto unlock;
> >> +=09ret =3D simple_read_from_buffer(buffer, count, &state->position,
> >> +=09=09=09=09      state->result, state->result_len);
> >> +=09if (state->position =3D=3D (loff_t)state->result_len) {
> >> +=09=09kfree_sensitive(state->result);
> >> +=09=09state->result =3D NULL;
> >> +=09}
> >> +unlock:
> >> +=09mutex_unlock(&state->lock);
> >> +=09return ret;
> >=20
> > The entire method is in a horrible mess. Drop the support for partial
> > reads, and use scoped_cond_guard()/ACQUIRE(), and __free() to tidy it u=
p.
> >=20
> >> +}
> >> +
> >> +static const struct file_operations lwmi_tac_fops =3D {
> >> +=09.owner =3D THIS_MODULE,
> >> +=09.open =3D lwmi_tac_open,
> >> +=09.release =3D lwmi_tac_release,
> >> +=09.read =3D lwmi_tac_read,
> >> +=09.write =3D lwmi_tac_write,
> >> +};
> >> +
> >> +/**
> >> + * lwmi_tac_remove() - Unregister an endpoint and block further firmw=
are calls
> >> + * @data: Endpoint registered as a device-managed cleanup action.
> >> + *
> >> + * Stop new opens before waiting for an in-flight call pair. Existing=
 files
> >> + * retain the endpoint state, but their subsequent reads/writes retur=
n -ENODEV.
> >> + */
> >> +static void lwmi_tac_remove(void *data)
> >> +{
> >> +=09struct lwmi_tac *tac =3D data;
> >> +
> >> +=09misc_deregister(&tac->misc);
> >> +=09mutex_lock(&lwmi_tac_lock);
> >> +=09tac->wdev =3D NULL;
> >> +=09mutex_unlock(&lwmi_tac_lock);
> >> +=09kref_put(&tac->ref, lwmi_tac_free);
> >> +}
> >> +
> >> +/**
> >> + * lwmi_tac_add() - Register TAC endpoints independently of capabilit=
y data
> >> + * @wdev: Bound Lenovo Other Mode WMI device.
> >> + *
> >> + * No capability describes method 99, so registration does not probe =
firmware
> >> + * support. Each firmware instance gets an endpoint; unsupported meth=
od calls
> >> + * are reported to userspace when requested.
> >> + *
> >> + * Return: 0 on success, or a negative error code. Device-managed cle=
anup
> >> + * unregisters earlier endpoints if a later registration or probe ste=
p fails.
> >> + */
> >> +static int lwmi_tac_add(struct wmi_device *wdev)
> >=20
> > devm_
> >=20
> >> +{
> >> +=09unsigned int instances =3D wmidev_instance_count(wdev);
> >> +=09int ret;
> >> +
> >> +=09for (unsigned int instance =3D 0; instance < instances; instance++=
) {
> >> +=09=09struct lwmi_tac *tac;
> >> +
> >> +=09=09tac =3D kzalloc_obj(*tac);
> >> +=09=09if (!tac)
> >> +=09=09=09return -ENOMEM;
> >> +=09=09ret =3D ida_alloc(&lwmi_tac_ida, GFP_KERNEL);
> >> +=09=09if (ret < 0) {
> >> +=09=09=09kfree(tac);
> >> +=09=09=09return ret;
> >> +=09=09}
> >> +=09=09tac->id =3D ret;
> >> +=09=09kref_init(&tac->ref);
> >> +=09=09tac->wdev =3D wdev;
> >> +=09=09tac->instance =3D instance;
> >> +=09=09tac->misc.minor =3D MISC_DYNAMIC_MINOR;
> >> +=09=09tac->misc.name =3D kasprintf(GFP_KERNEL, "tac%d", tac->id);
> >> +=09=09tac->misc.fops =3D &lwmi_tac_fops;
> >> +=09=09tac->misc.parent =3D &wdev->dev;
> >> +=09=09tac->misc.mode =3D 0600;
> >> +=09=09if (!tac->misc.name) {
> >> +=09=09=09kref_put(&tac->ref, lwmi_tac_free);
> >> +=09=09=09return -ENOMEM;
> >> +=09=09}
> >> +=09=09ret =3D misc_register(&tac->misc);
> >> +=09=09if (ret) {
> >> +=09=09=09kref_put(&tac->ref, lwmi_tac_free);
> >> +=09=09=09return ret;
> >> +=09=09}
> >> +=09=09/* Unregister before the WMI device and its managed state disap=
pear. */
> >> +=09=09ret =3D devm_add_action_or_reset(&wdev->dev, lwmi_tac_remove, t=
ac);
> >> +=09=09if (ret)
> >> +=09=09=09return ret;
> >> +=09}
> >> +=09return 0;
> >> +}
> >> +
> >>  /* =3D=3D=3D=3D=3D=3D=3D=3D Self (master: lenovo-wmi-other) =3D=3D=3D=
=3D=3D=3D=3D=3D */
> >> =20
> >>  /**
> >> @@ -1693,6 +2013,7 @@ static int lwmi_other_probe(struct wmi_device *w=
dev, const void *context)
> >>  {
> >>  =09struct component_match *master_match =3D NULL;
> >>  =09struct lwmi_om_priv *priv;
> >> +=09int ret;
> >> =20
> >>  =09priv =3D devm_kzalloc_obj(&wdev->dev, *priv);
> >>  =09if (!priv)
> >> @@ -1708,6 +2029,10 @@ static int lwmi_other_probe(struct wmi_device *=
wdev, const void *context)
> >>  =09if (IS_ERR(master_match))
> >>  =09=09return PTR_ERR(master_match);
> >> =20
> >> +=09ret =3D lwmi_tac_add(wdev);
> >> +=09if (ret)
> >> +=09=09return ret;
> >=20
> > Why is this fatal?
> >=20
> > Thanks,
> > Rong
> >=20
> >> +
> >>  =09return component_master_add_with_match(&wdev->dev, &lwmi_om_master=
_ops,
> >>  =09=09=09=09=09       master_match);
> >>  }
> >>
> >> base-commit: 5680519168f65666d2c03cc6ed8fe2b7052aee12
>=20
> Thanks for the detailed review. I sent v2 patch separately by referring
> your suggestion. Please help review it.
> My replies to your points are below.
>=20
> 1. Practical purpose and tuning
>=20
> The known use is for Lenovo utility to communicate with firmware.
> In v2 I use a default-off debugfs interface instead of stable userspace
> interface.
>=20
> 2. Test information in the commit message
>=20
> I removed the build and test details from the v2 commit message.
>=20
> 3. LLM assistance
>=20
> Yes, I used AI assistance for the port and review. I reviewed the
> changes and am responsible for the submission.
>
> 4. Character device versus debugfs, and the module parameter
>=20
> I replaced the character device with a 0600 debugfs file created under
> lwmi_debugfs_create_dir(). There is no non-invasive probe for method 99,
> so creation is disabled by default and requires
> enable_get_data_by_package=3D1 when loading the module. I removed the v1
> ABI document and its MAINTAINERS entry.
>=20
> 5. ABI documentation and verbosity
>=20
> Removed the character-device ABI document change.
>=20
> 6. Multiple writers and partial reads
>=20
> The debugfs file permits one open only per WMI device.
>=20
> 7. Readability and comments
>=20
> I simplified the handlers and removed the redundant kernel-doc and
> comments that merely described normal file operations. I also removed
> the unsupported reference to a script on another OS.
>=20
> 8. Locking
>=20
> With one open per WMI device, a per-open lock protects the response and
> serializes operations through shared descriptors. lwmi_package_invoke()
> uses lockdep_assert_held() for that lock.
>=20
> 9. Sensitive data
>=20
> The firmware response can contain sensitive data, so I retained
> kfree_sensitive() for buffers returned successfully by WMI.

Vague and broad statements like that are unacceptable for me.

Either provide clear and unambiguous justification or do not use=20
_sensitive. I'll not accept doing it using "just in case" reasoning.
You might want to split code path for the sensitive case for clarity.

> 10. Duplicate calls
>=20
> You can refer as think-lmi.c, same duplicated call. The reason is
> invoking WMI under Windows OS will result the BIOS ACPI code execute
> twice, so BIOS implemented the workaround, thus Linux driver will need
> the duplicated call to match the BIOS workaround.
>=20
> 11. Response size, alignment and cleanup
>=20
> The second wmidev_invoke_method() call passes the response header size
> as min_size. The driver separately validates DataSize against the
> returned buffer length. The response is represented by an aligned
> structure with a flexible array; after the successful call I declare it
> with __free(kfree_sensitive) and transfer ownership with no_free_ptr().
>=20
> 12. Scoped locking and probe failure
>=20
> Read and write use ACQUIRE()/ACQUIRE_ERR(). The device-managed debugfs
> cleanup action handles removal and setup rollback. A debugfs setup error
> is reported with dev_warn(), but does not by itself fail driver probe.

In future, please reply properly to the review comments (inline), not=20
adding an LLM-generated reply to tail. Tail (or head) replies makes it=20
hard to connect the reviewer comment to your reply and you don't want=20
to upset the acting maintainer with that. ;-)

--=20
 i.

--8323328-171610986-1795428402=:1065--
