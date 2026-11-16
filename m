Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=136.143.188.112
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794833142;
	b=Wp5C6rA+8+Ug0VIwbd6v/NYU4tbw3K/psKBFzG0EOZzPWn1DOOoVIQDElvE73sXMSTFk
	 0eevnGA5CHyZAkEowi7bepprarC1toq4yqVPYm4vb2guTft16RTwKnnoI82kCcRL9hmT5
	 1M8sceYf3PBIVRCc8eNHjbvkcprFowKmphJERKQ0Xq0z8RmqY0DuqR84n1OiODl1Cthgp
	 nb6h0ZBbczeiYmVe7PvrRmhjFj0TlDZQXsefTORR0NyHc9kqvYZ8l08g3Uy8TBQSJ0Znt
	 tPkQ9RR5Tp3xcRzs9gDVLBs9cGLbWicPLGImlkN7mD5vmHsLis8pwWdGh7RkamVWNFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833142;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-ZohoMailClient;
	bh=WyJcdl632QwJO5aLsTyVauuriQNcqNB4F0rBgwqosEc=;
	b=2KaUBRcpJ13BULNbqgWdi9iIA7nOVxVmml08ovHHBN792nI9gThJwK+o0htikTW4zXwA
	 shs3fRIHIeFg2oKpM2KkonysHve/KNXNE5shfibnU8eoORoK3UBNIP91VY4vibBBUtl78
	 OL6/As/b+rxLP6DBqRKd+/c6QFE13TJe+PNIuR1mGya6ZmDm47LofNBbeDE1n9HAUckc8
	 kmKOODSe1nKfcLr9OJg347OlUJuMoYaWMNVHc0ZpJvRxwhtbOIUC/H9EiQg81GeymS1SI
	 7homF1ZLA9nZew08EzKn3Ls3Fsdg2aYL/Wf8qznUyr2ZiylbJtTQVQViYItCwOSZhxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rong.moe;
	spf=pass smtp.mailfrom=rong.moe;
	dkim=pass header.d=rong.moe header.i=@rong.moe header.a=rsa-sha256 header.s=zmail2048 header.b=Ba4BSlCd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=136.143.188.112
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C810606A323;
	Mon, 16 Nov 2026 12:45:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C810606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rong.moe
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rong.moe
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rong.moe header.i=@rong.moe header.a=rsa-sha256 header.s=zmail2048 header.b=Ba4BSlCd
ARC-Seal: i=1; a=rsa-sha256; t=1794833102; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lxAVT07d0eTryf+szWngpycXxEQmfAUle4ijsXNI7SuragQAdVwVXRKLp/Sd/dzyrMvOpCXvogxEBiclGKn9xGeuOWJAesvqpRuH1xaTK7g7fV8VwnENyLO7XhJDkv0UJvEcPLMdArgU+jVA3FgbUgDPBlD2nLJZqK4fOudjnIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794833102; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WyJcdl632QwJO5aLsTyVauuriQNcqNB4F0rBgwqosEc=; 
	b=V5aItFJtcmlvDL6pJw4P+oueVO0KRXCT3plHWgYXrToL7AGDnZZnkwz//zWyPRXYXiSCpyoCkyLH8QyAVgoDh94U5YhBY6cNgLKxK1+2M7axZHjQzdQdGac1Eg0O6tJKV8uuX0x7wYZzTZ/CrEcsSlLcCzv1xO9Z8WY5xB0fRw0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=rong.moe;
	spf=pass  smtp.mailfrom=i@rong.moe;
	dmarc=pass header.from=<i@rong.moe>
DKIM-Signature: a=rsa-sha256; b=Ba4BSlCd1MseOuIE2bQuLWaum/dRfKEam9xQRP4wcyXpweaJGVqGTFGx8K+03adLwnoGarn0O4SamSmu4EHeTZoXuOKee1U2Ig0Wy8aIZt4PUzNUeYkN2V5Oka8OqBDkXaKHwUJ0ZHTmJdibxbZmeu4PpYBgLUhQS1pV7diCMvVo4iAUC3GZwf+LoEJRc5w2qADnXM0KT6wonxSM1Y/ZOxKM2kEf+ug3c8Ysn5/BC0mACUtkfEfqJV92Xwd17oV8UvDo0kxrqiiqcbm779eFRfqPzg3JdAJAKwiOOuROZM7pr8VRPr5MFE6rFfnVRFm7QFC5yQomgUKCKFhHy80gOQ==; c=relaxed/relaxed; s=zmail2048; d=rong.moe; v=1; bh=WyJcdl632QwJO5aLsTyVauuriQNcqNB4F0rBgwqosEc=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794833100081448.7408237875288;
	Mon, 16 Nov 2026 04:45:00 -0800 (PST)
Message-ID: <4377ff90ffd0b030de7d4d33c188ba4b7551ad03.camel@rong.moe>
Subject: Re: [PATCH] platform/x86: lenovo-wmi-other: Add raw
 GetDataByPackage interface
From: Rong Zhang <i@rong.moe>
To: Alan Pluto <alanpluto@163.com>, platform-driver-x86@vger.kernel.org
Cc: mpearson-lenovo@squebb.ca, derekjohn.clark@gmail.com, W_Armin@gmx.de, 
	hansg@kernel.org, ilpo.jarvinen@linux.intel.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org,
 linux-kernel@vger.kernel.org, 	linux-doc@vger.kernel.org,
 linux-api@vger.kernel.org
In-Reply-To: <20261116040532.154928-1-alanpluto@163.com>
References: <20261116040532.154928-1-alanpluto@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 20:44:42 +0800
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Evolution 3.62.1-3 
X-ZohoMailClient: External

Hi Alan,

Thanks for working on this.

On Mon, 2026-11-16 at 12:05 +0800, Alan Pluto wrote:
> Expose Lenovo Other Mode WMI GetDataByPackage, method 99, through a
> root-only character device so userspace can access the raw firmware
> interface. And document the interface.

What's the practical purpose of the interface? Did you use this to tune
anything on your device?

>=20
> The upstream driver was build-tested with W=3D1 and checked with Sparse.
> A backport using the five-argument wmidev_invoke_method() interface
> was tested on Ubuntu 7.0.0-42 with Lenovo hardware. The upstream 7.4
> driver has not been tested on hardware.

Don't include this in the commit message, but rather send a cover letter
or place it under `---'.

>=20
> Signed-off-by: Alan Pluto <alanpluto@163.com>

Is the work assisted by LLM?

> ---
>  Documentation/ABI/testing/dev-tac             |  49 +++
>  .../wmi/devices/lenovo-wmi-other.rst          |   8 +
>  MAINTAINERS                                   |   1 +
>  drivers/platform/x86/lenovo/wmi-other.c       | 325 ++++++++++++++++++
>  4 files changed, 383 insertions(+)
>  create mode 100644 Documentation/ABI/testing/dev-tac
>=20
> diff --git a/Documentation/ABI/testing/dev-tac b/Documentation/ABI/testin=
g/dev-tac
> new file mode 100644
> index 00000000000..a8be8e95e2d
> --- /dev/null
> +++ b/Documentation/ABI/testing/dev-tac
> @@ -0,0 +1,49 @@
> +What:           /dev/tac[0-9]*
> +Date:           November 2026
> +Contact:        platform-driver-x86@vger.kernel.org
> +Description:
> +                Lenovo Other Mode WMI GetDataByPackage (method 99).
> +                Each firmware WMI instance gets a misc character device =
with
> +                mode 0600.=C2=A0
>=20

Why would you need to add a character device instead of a debugfs file?
See also lwmi_debugfs_create_dir().

IMHO the interface is quite internal and undocumented. Exposing it as a
character device makes it too reachable for users, unnecessarily
increases the complexity of the driver, and requires some sorts of ABI
stability.

> Numbering follows allocation order, not necessarily
> +                the firmware instance number.=C2=A0
>=20

You must be using a wordy LLM if you are using one. Isn't this just
obvious and natural for most character devices?

> Registration does not probe
> +                support for method 99. The parent is the bound WMI devic=
e.

If it can't be probed, gate it unless a module parameter is set.

> +
> +                Open with O_RDWR. One write submits one complete request=
 of
> +                1..100 raw bytes; shorter requests are padded with zeroe=
s to
> +                100 bytes. Empty and oversized writes fail with EINVAL w=
ithout

sed -E 's/\bE[A-Z]+\b/-\0/g'

> +                calling firmware. Successful writes return the full subm=
itted
> +                length and execute two identical WMI calls for the BIOS
> +                duplicate-call workaround.=C2=A0
>=20

> Request pairs through this
> +                interface are serialized; calls made by other driver
> +                interfaces are not covered by this serialization.

Why would you need to mention cross-interface implementation details in a
user-facing documentation?

> +                Evaluation failures abort the pair; the driver does not
> +                automatically retry.
> +
> +                Each open file description owns its response.=C2=A0
>=20

Why would you need to support multiple writers? Couldn't you simply
return -EBUSY when there is a pending writer/reader?

> A write while
> +                that response remains unread fails with EBUSY, including=
 after
> +                partial reads.=C2=A0
>=20

If userspace must write all data at once, why would you need to support
partial reads?

> A new open cannot read another open's response.
> +                Descriptors shared by dup/fork share the same transactio=
n;
> +                applications must coordinate the complete write/read seq=
uence.

Aren't these just obvious and natural for most character devices, too?

> +
> +                Read returns little-endian u32 DataSize followed by exac=
tly
> +                DataSize data bytes. Response storage is erased when ful=
ly
> +                read or closed. Further reads return EOF until a new suc=
cessful
> +                write. Before a successful write, or after a failed firm=
ware
> +                evaluation, reads return ENODATA. A zero-length read ret=
urns
> +                zero without consuming data.
> +
> +                Requests are synchronous even with O_NONBLOCK. Seeking a=
nd
> +                positional I/O are not supported.=C2=A0
>=20

Aren't these just the default characteristic for most non-block character
devices?

> There is no ioctl interface.

Too verbose. If you don't say it has some, it's obvious that it has none.

> +                A removed WMI device causes nonempty reads and valid wri=
tes
> +                on existing descriptors to fail with ENODEV.
> +
> +                Firmware evaluation failures map to EIO. WMI marshalling
> +                failures return the error reported by the WMI subsystem.
> +                A truncated response or invalid DataSize maps to EPROTO.
> +                Bad userspace memory maps to EFAULT. Failure does not im=
ply
> +                firmware had no side effects; never blindly resubmit com=
mands.
> +                Interrupted waits can return EINTR before firmware evalu=
ation.

Obvious, no?

> +
> +                The WMI subsystem converts returned ACPI objects to a bu=
ffer.

Yet another implementation detail.

> +                This raw firmware interface may change device state. Use=
 only
> +                commands whose behavior and side effects are understood.
> diff --git a/Documentation/wmi/devices/lenovo-wmi-other.rst b/Documentati=
on/wmi/devices/lenovo-wmi-other.rst
> index 011054d64ea..ec85fdeeb7a 100644
> --- a/Documentation/wmi/devices/lenovo-wmi-other.rst
> +++ b/Documentation/wmi/devices/lenovo-wmi-other.rst
> @@ -33,6 +33,10 @@ under the following path:
> =20
>  Additionally, this driver also exports attributes to HWMON.
> =20
> +The driver also exposes GetDataByPackage (method 99) through a raw chara=
cter
> +device for each WMI instance. See Documentation/ABI/testing/dev-tac for =
the
> +request and response format and its access restrictions.
> +
>  LENOVO_CAPABILITY_DATA_00
>  -------------------------
> =20
> @@ -109,6 +113,10 @@ WMI interface description
>  The WMI interface description can be decoded from the embedded binary MO=
F (bmof)
>  data using the `bmfdec <https://github.com/pali/bmfdec>`_ utility:
> =20
> +The example below describes an older firmware revision and specifies a
> +40-byte maximum input for GetDataByPackage. Newer firmware uses a 100-by=
te
> +input, which is the size used by the raw interface described above.
> +
>  ::
> =20
>    [WMI, Dynamic, Provider("WmiProv"), Locale("MS\\0x409"), Description("=
LENOVO_OTHER_METHOD class"), guid("{dc2a8805-3a8c-41ba-a6f7-092e0089cd3b}")=
]
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 981eb3fdbef..84b1545f525 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15168,6 +15168,7 @@ M:=09Derek J. Clark <derekjohn.clark@gmail.com>
>  M:=09Rong Zhang <i@rong.moe>
>  L:=09platform-driver-x86@vger.kernel.org
>  S:=09Maintained
> +F:=09Documentation/ABI/testing/dev-tac
>  F:=09Documentation/wmi/devices/lenovo-wmi-gamezone.rst
>  F:=09Documentation/wmi/devices/lenovo-wmi-other.rst
>  F:=09drivers/platform/x86/lenovo/*
> diff --git a/drivers/platform/x86/lenovo/wmi-other.c b/drivers/platform/x=
86/lenovo/wmi-other.c
> index bd64e7b4466..c15b3a2a758 100644
> --- a/drivers/platform/x86/lenovo/wmi-other.c
> +++ b/drivers/platform/x86/lenovo/wmi-other.c
> @@ -34,16 +34,23 @@
>  #include <linux/device.h>
>  #include <linux/export.h>
>  #include <linux/firmware_attributes.h>
> +#include <linux/fs.h>
>  #include <linux/gfp_types.h>
>  #include <linux/hwmon.h>
>  #include <linux/idr.h>
>  #include <linux/kdev_t.h>
>  #include <linux/kobject.h>
> +#include <linux/kref.h>
>  #include <linux/limits.h>
> +#include <linux/miscdevice.h>
>  #include <linux/module.h>
> +#include <linux/mutex.h>
>  #include <linux/platform_profile.h>
>  #include <linux/power_supply.h>
> +#include <linux/slab.h>
>  #include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/unaligned.h>
>  #include <linux/wmi.h>
> =20
>  #include <acpi/battery.h>
> @@ -91,6 +98,9 @@ enum lwmi_feature_id_psu {
>  #define LWMI_FEATURE_VALUE_GET 17
>  #define LWMI_FEATURE_VALUE_SET 18
> =20
> +#define LWMI_DATA_PACKAGE_GET 99
> +#define LWMI_DATA_PACKAGE_INPUT_MAX 100
> +
>  #define LWMI_FAN_ID_BASE 1
>  #define LWMI_FAN_NR 4
>  #define LWMI_FAN_ID(x) ((x) + LWMI_FAN_ID_BASE)
> @@ -115,6 +125,27 @@ enum lwmi_feature_id_psu {
> =20
>  static DEFINE_IDA(lwmi_om_ida);
> =20
> +static DEFINE_IDA(lwmi_tac_ida);
> +static DEFINE_MUTEX(lwmi_tac_lock);
> +
> +struct lwmi_tac {
> +=09struct miscdevice misc;
> +=09struct kref ref;
> +=09struct wmi_device *wdev;
> +=09u8 instance;
> +=09int id;
> +};
> +
> +struct lwmi_tac_file {
> +=09struct lwmi_tac *tac;
> +=09/* Protects the per-open response and its position. */
> +=09struct mutex lock;
> +=09void *result;
> +=09size_t result_len;
> +=09loff_t position;
> +=09bool completed;
> +};
> +
>  enum attribute_property {
>  =09DEFAULT_VAL,
>  =09MAX_VAL,
> @@ -1609,6 +1640,295 @@ static void lwmi_om_fw_attr_remove(struct lwmi_om=
_priv *priv)
>  =09priv->ida_id =3D -EIDRM;
>  }
> =20
> +/**
> + * lwmi_tac_free() - Free an unregistered endpoint after its last close
> + * @ref: Reference belonging to the endpoint.
> + */
> +static void lwmi_tac_free(struct kref *ref)
> +{
> +=09struct lwmi_tac *tac =3D container_of(ref, struct lwmi_tac, ref);
> +
> +=09ida_free(&lwmi_tac_ida, tac->id);
> +=09kfree(tac->misc.name);
> +=09kfree(tac);
> +}
> +
> +/**
> + * lwmi_tac_open() - Allocate independent response state for an open fil=
e
> + * @inode: Character device inode.
> + * @file: File initially pointing to the registered miscdevice.
> + *
> + * The misc core serializes open against deregistration, so the registra=
tion
> + * reference remains valid while the file acquires its own reference.
> + *
> + * Return: 0 on success, or -ENOMEM.
> + */
> +static int lwmi_tac_open(struct inode *inode, struct file *file)
> +{
> +=09struct lwmi_tac *tac =3D container_of(file->private_data, struct lwmi=
_tac, misc);
> +=09struct lwmi_tac_file *state;
> +
> +=09state =3D kzalloc_obj(*state);
> +=09if (!state)
> +=09=09return -ENOMEM;
> +=09mutex_init(&state->lock);
> +=09state->tac =3D tac;
> +=09kref_get(&tac->ref);
> +=09file->private_data =3D state;
> +=09return stream_open(inode, file);

Add line breaks to improve readability. Same for the following methods.

> +}
> +
> +/**
> + * lwmi_tac_release() - Erase the response and drop the endpoint referen=
ce
> + * @inode: Character device inode.
> + * @file: File holding the endpoint state.
> + *
> + * Return: 0.
> + */
> +static int lwmi_tac_release(struct inode *inode, struct file *file)
> +{
> +=09struct lwmi_tac_file *state =3D file->private_data;
> +
> +=09kfree_sensitive(state->result);

Why on earth is it sensitive?

> +=09mutex_destroy(&state->lock);
> +=09kref_put(&state->tac->ref, lwmi_tac_free);
> +=09kfree(state);
> +=09return 0;
> +}
> +
> +/**
> + * lwmi_tac_invoke() - Execute GetDataByPackage and retain the response
> + * @state: Open file whose response buffer is empty.
> + * @data: Zero-padded 100-byte input buffer.
> + *
> + * The caller holds state->lock and lwmi_tac_lock.=C2=A0
>=20

Add lockdep assertions instead of stating them in comments.

> The latter serializes call
> + * pairs across instances and keeps the WMI device valid during evaluati=
on.
> + *
> + * Return: 0 on success, or a negative error code.
> + */
> +static int lwmi_tac_invoke(struct lwmi_tac_file *state, u8 *data)
> +{
> +=09struct lwmi_tac *tac =3D state->tac;
> +=09struct wmi_buffer input =3D { .length =3D LWMI_DATA_PACKAGE_INPUT_MAX=
, .data =3D data };
> +=09struct wmi_buffer output;
> +=09u32 data_size;
> +=09int ret;
> +
> +=09if (!tac->wdev)
> +=09=09return -ENODEV;
> +=09/*
> +=09 * Duplicated call required to match BIOS workaround for behavior
> +=09 * seen when WMI accessed via scripting on other OS.

Reference? Where is the script?

> +=09 */
> +=09for (unsigned int call =3D 0; call < 2; call++) {
> +=09=09ret =3D wmidev_invoke_method(tac->wdev, tac->instance,
> +=09=09=09=09=09   LWMI_DATA_PACKAGE_GET, &input, &output, 0);
> +=09=09if (ret)
> +=09=09=09return ret;
> +=09=09if (!call)
> +=09=09=09kfree_sensitive(output.data);
> +=09}
> +=09/* Validate DataSize before preserving the complete firmware response=
. */

Don't retell what the code does, but rather explain why.

> +=09if (output.length < sizeof(__le32)) {

Why not use wmidev_invoke_method()'s min_size argument?

> +=09=09ret =3D -EPROTO;
> +=09=09goto free_output;
> +=09}
> +=09data_size =3D get_unaligned_le32(output.data);

wmidev_invoke_method() returns aligned data.

> +=09if (data_size > output.length - sizeof(__le32)) {
> +=09=09ret =3D -EPROTO;
> +=09=09goto free_output;
> +=09}
> +=09/* Transfer ownership without another allocation after firmware ran. =
*/
> +=09state->result =3D output.data;

Use __free() and no_free_ptr().

> +=09state->result_len =3D sizeof(__le32) + data_size;

Couldn't you declare a struct with a flex array member to represent this?

> +=09state->position =3D 0;
> +=09state->completed =3D true;
> +=09return 0;
> +free_output:
> +=09kfree_sensitive(output.data);
> +=09return ret;
> +}
> +
> +/**
> + * lwmi_tac_write() - Submit one complete TAC request

"complete"

Obvious.

> + * @file: Open TAC endpoint with independent response state.
> + * @buffer: Userspace input bytes.
> + * @count: Input size, from 1 to 100 bytes.
> + * @ppos: Unused;=20
>=20

> TAC is a nonseekable request/response stream.

Obvious.

> + *
> + * Short inputs are zero-padded. An unread response must be consumed bef=
ore
> + * submitting another request. A failed firmware call is never retried h=
ere.
> + *
> + * Return: @count on success, or a negative error code.
> + */
> +static ssize_t lwmi_tac_write(struct file *file, const char __user *buff=
er,
> +=09=09=09      size_t count, loff_t *ppos)
> +{
> +=09struct lwmi_tac_file *state =3D file->private_data;
> +=09u8 input[LWMI_DATA_PACKAGE_INPUT_MAX] =3D {};
> +=09int ret;
> +
> +=09if (!count || count > sizeof(input))
> +=09=09return -EINVAL;
> +=09if (copy_from_user(input, buffer, count)) {
> +=09=09ret =3D -EFAULT;
> +=09=09goto clear_input;
> +=09}
> +=09ret =3D mutex_lock_interruptible(&state->lock);
> +=09if (ret)
> +=09=09goto clear_input;
> +=09ret =3D mutex_lock_interruptible(&lwmi_tac_lock);
> +=09if (ret)
> +=09=09goto unlock;

Use scoped_cond_guard() or ACQUIRE().

> +=09if (!state->tac->wdev) {
> +=09=09ret =3D -ENODEV;
> +=09} else if (state->result) {
> +=09=09ret =3D -EBUSY;
> +=09} else {
> +=09=09state->completed =3D false;
> +=09=09ret =3D lwmi_tac_invoke(state, input);
> +=09}
> +=09mutex_unlock(&lwmi_tac_lock);
> +unlock:
> +=09mutex_unlock(&state->lock);
> +clear_input:
> +=09memzero_explicit(input, sizeof(input));

Why on earth is it sensitive, too?

> +=09if (ret)
> +=09=09return ret;
> +=09return count;
> +}
> +
> +/**
> + * lwmi_tac_read() - Read only this open file's firmware response

"only"

Obvious, no?

> + * @file: Open TAC endpoint.
> + * @buffer: Userspace destination.
> + * @count: Maximum number of bytes to return.
> + * @ppos: Unused;=C2=A0the response position is protected by state->lock=
.
> + *
> + * Responses contain little-endian u32 DataSize followed by Data. Partia=
l
> + * reads advance the response position. Consuming the result erases its
> + * storage immediately; subsequent reads return EOF until another write.
> + *
> + * Return: Bytes read, 0 at EOF or for zero @count, or a negative error =
code.
> + */
> +static ssize_t lwmi_tac_read(struct file *file, char __user *buffer,
> +=09=09=09     size_t count, loff_t *ppos)
> +{
> +=09struct lwmi_tac_file *state =3D file->private_data;
> +=09ssize_t ret;
> +
> +=09if (!count)
> +=09=09return 0;
> +=09ret =3D mutex_lock_interruptible(&state->lock);
> +=09if (ret)
> +=09=09return ret;
> +=09ret =3D mutex_lock_interruptible(&lwmi_tac_lock);
> +=09if (ret)
> +=09=09goto unlock;
> +=09if (!state->tac->wdev)
> +=09=09ret =3D -ENODEV;
> +=09mutex_unlock(&lwmi_tac_lock);
> +=09if (ret) {
> +=09=09kfree_sensitive(state->result);
> +=09=09state->result =3D NULL;
> +=09=09goto unlock;
> +=09}
> +=09if (!state->completed) {
> +=09=09ret =3D -ENODATA;
> +=09=09goto unlock;
> +=09}
> +=09if (!state->result)
> +=09=09goto unlock;
> +=09ret =3D simple_read_from_buffer(buffer, count, &state->position,
> +=09=09=09=09      state->result, state->result_len);
> +=09if (state->position =3D=3D (loff_t)state->result_len) {
> +=09=09kfree_sensitive(state->result);
> +=09=09state->result =3D NULL;
> +=09}
> +unlock:
> +=09mutex_unlock(&state->lock);
> +=09return ret;

The entire method is in a horrible mess. Drop the support for partial
reads, and use scoped_cond_guard()/ACQUIRE(), and __free() to tidy it up.

> +}
> +
> +static const struct file_operations lwmi_tac_fops =3D {
> +=09.owner =3D THIS_MODULE,
> +=09.open =3D lwmi_tac_open,
> +=09.release =3D lwmi_tac_release,
> +=09.read =3D lwmi_tac_read,
> +=09.write =3D lwmi_tac_write,
> +};
> +
> +/**
> + * lwmi_tac_remove() - Unregister an endpoint and block further firmware=
 calls
> + * @data: Endpoint registered as a device-managed cleanup action.
> + *
> + * Stop new opens before waiting for an in-flight call pair. Existing fi=
les
> + * retain the endpoint state, but their subsequent reads/writes return -=
ENODEV.
> + */
> +static void lwmi_tac_remove(void *data)
> +{
> +=09struct lwmi_tac *tac =3D data;
> +
> +=09misc_deregister(&tac->misc);
> +=09mutex_lock(&lwmi_tac_lock);
> +=09tac->wdev =3D NULL;
> +=09mutex_unlock(&lwmi_tac_lock);
> +=09kref_put(&tac->ref, lwmi_tac_free);
> +}
> +
> +/**
> + * lwmi_tac_add() - Register TAC endpoints independently of capability d=
ata
> + * @wdev: Bound Lenovo Other Mode WMI device.
> + *
> + * No capability describes method 99, so registration does not probe fir=
mware
> + * support. Each firmware instance gets an endpoint; unsupported method =
calls
> + * are reported to userspace when requested.
> + *
> + * Return: 0 on success, or a negative error code. Device-managed cleanu=
p
> + * unregisters earlier endpoints if a later registration or probe step f=
ails.
> + */
> +static int lwmi_tac_add(struct wmi_device *wdev)

devm_

> +{
> +=09unsigned int instances =3D wmidev_instance_count(wdev);
> +=09int ret;
> +
> +=09for (unsigned int instance =3D 0; instance < instances; instance++) {
> +=09=09struct lwmi_tac *tac;
> +
> +=09=09tac =3D kzalloc_obj(*tac);
> +=09=09if (!tac)
> +=09=09=09return -ENOMEM;
> +=09=09ret =3D ida_alloc(&lwmi_tac_ida, GFP_KERNEL);
> +=09=09if (ret < 0) {
> +=09=09=09kfree(tac);
> +=09=09=09return ret;
> +=09=09}
> +=09=09tac->id =3D ret;
> +=09=09kref_init(&tac->ref);
> +=09=09tac->wdev =3D wdev;
> +=09=09tac->instance =3D instance;
> +=09=09tac->misc.minor =3D MISC_DYNAMIC_MINOR;
> +=09=09tac->misc.name =3D kasprintf(GFP_KERNEL, "tac%d", tac->id);
> +=09=09tac->misc.fops =3D &lwmi_tac_fops;
> +=09=09tac->misc.parent =3D &wdev->dev;
> +=09=09tac->misc.mode =3D 0600;
> +=09=09if (!tac->misc.name) {
> +=09=09=09kref_put(&tac->ref, lwmi_tac_free);
> +=09=09=09return -ENOMEM;
> +=09=09}
> +=09=09ret =3D misc_register(&tac->misc);
> +=09=09if (ret) {
> +=09=09=09kref_put(&tac->ref, lwmi_tac_free);
> +=09=09=09return ret;
> +=09=09}
> +=09=09/* Unregister before the WMI device and its managed state disappea=
r. */
> +=09=09ret =3D devm_add_action_or_reset(&wdev->dev, lwmi_tac_remove, tac)=
;
> +=09=09if (ret)
> +=09=09=09return ret;
> +=09}
> +=09return 0;
> +}
> +
>  /* =3D=3D=3D=3D=3D=3D=3D=3D Self (master: lenovo-wmi-other) =3D=3D=3D=3D=
=3D=3D=3D=3D */
> =20
>  /**
> @@ -1693,6 +2013,7 @@ static int lwmi_other_probe(struct wmi_device *wdev=
, const void *context)
>  {
>  =09struct component_match *master_match =3D NULL;
>  =09struct lwmi_om_priv *priv;
> +=09int ret;
> =20
>  =09priv =3D devm_kzalloc_obj(&wdev->dev, *priv);
>  =09if (!priv)
> @@ -1708,6 +2029,10 @@ static int lwmi_other_probe(struct wmi_device *wde=
v, const void *context)
>  =09if (IS_ERR(master_match))
>  =09=09return PTR_ERR(master_match);
> =20
> +=09ret =3D lwmi_tac_add(wdev);
> +=09if (ret)
> +=09=09return ret;

Why is this fatal?

Thanks,
Rong

> +
>  =09return component_master_add_with_match(&wdev->dev, &lwmi_om_master_op=
s,
>  =09=09=09=09=09       master_match);
>  }
>=20
> base-commit: 5680519168f65666d2c03cc6ed8fe2b7052aee12
