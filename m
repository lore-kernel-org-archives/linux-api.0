Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795418270;
	b=hUkZAV6ylA90cyIOEaq+PNWc3/t35v3aht8FkwrcjRHFWaLJKLS0yA/BVXAxWRXoMQ14
	 RKEoBD64DgHQY9Jtls/olEQmGrXcsDRklQ9Z000Tq2ZRhMrx2XPuOO67JE8LB10sKXEON
	 HTNn2vDV2PZVZHtYAas8OthtaTY+lZ8q5BbqfBT/WPHqiQkECPiv8xBgBB5WtBv1eAZ4z
	 MqhKHCNRjJDjE01YK7iw+6MrM9fFlmkVvmrB8vM8e6RbUcFh59syoPPaHASkgl4SdK58/
	 vrUmGhvoO5RK3fHx4FWCodpfQ9ywWdElqbjXi7Zf03PufY6WIscGFpYnPw+TsDAzo+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795418270;
	h=DMARC-Filter:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=tmeFFUNaR7P+349HGnSwB/OoAdyqRcKcfAcswYeJkZM=;
	b=Rg19TfYfqW1HAcKmnOsYA+Eay3hvOMKw6WPyvpvTJggux3IDgxB0Sxzth+v4fZ23JTWo
	 uOfR28ej5n5TZRht3icgkgzZy437XD+8X58be7v27zr35w6cN4B30RNVKtuN3I+/7NtYu
	 5NwrQ0LfQG9HtGOziiIYAbQG20H3FXEbqYVhI/Mop1GXZ9nQgokBaAFAl7Ie8I9heqPQD
	 Wh48rbQrdUV5CUbi3unM0bRpyK1w/ORAzJwzd5tpSoe/3ztc0u8/NG4y72uUpMy+h8Una
	 4dp1cdOQWvFpfUmriak5C0k58rShdaLsSLfpqW7f1ZhdgFQEa/1YFuB1eKJhH2zfHZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Sd1xJ8md;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7DC606A31A;
	Mon, 23 Nov 2026 07:17:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B7DC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Sd1xJ8md
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=tmeFFUNaR7P+349HGnSwB/OoAdyqRcKcfAcswYeJkZM=;
	b=Sd1xJ8mdAYQpUWubE4JOgUPAW88+eVslhgGMSEfOYmDmW9AeyJXLRLQL+hjT5M
	AmtR3GliiCIk4NjvbBy8AAwk5ISPBOTK+eHDAfm2elzjzyTdIkP7OVV8zJrtqksg
	drxlQ1GiymJvv/IlXkMaoQ0Dauzv5xKnZ2R1VpEWxwwIc=
Message-ID: <06c29ea2-c9d4-4e9b-bbe8-651ad868a9c4@163.com>
Date: Mon, 23 Nov 2026 15:16:31 +0800
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] platform/x86: lenovo-wmi-other: Add raw GetDataByPackage
 interface
To: Rong Zhang <i@rong.moe>, platform-driver-x86@vger.kernel.org
Cc: mpearson-lenovo@squebb.ca, derekjohn.clark@gmail.com, W_Armin@gmx.de,
 hansg@kernel.org, ilpo.jarvinen@linux.intel.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-api@vger.kernel.org
References: <20261116040532.154928-1-alanpluto@163.com>
 <4377ff90ffd0b030de7d4d33c188ba4b7551ad03.camel@rong.moe>
Content-Language: en-US
From: alan <alanpluto@163.com>
In-Reply-To: <4377ff90ffd0b030de7d4d33c188ba4b7551ad03.camel@rong.moe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnRhJP6ANrCA5YJg--.60774S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfXw4fJFWfJF1kZFWxtF4fKrg_yoW8tFWUto
	WSqws3W3WIqr1UZr1xCa48JFya9aykuF4DZa1YqwsxJF4jva1j93y7Zw4fJa93tF1FkF4D
	W34kJr40qFW0qa1rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU4XTmUUUUU
X-CM-SenderInfo: hdod01poxw0qqrwthudrp/xtbC0RLp3WsD6FJZowAA3f

Hi Rong,

在 2026/11/16 20:44, Rong Zhang 写道:
> Hi Alan,
> 
> Thanks for working on this.
> 
> On Mon, 2026-11-16 at 12:05 +0800, Alan Pluto wrote:
>> Expose Lenovo Other Mode WMI GetDataByPackage, method 99, through a
>> root-only character device so userspace can access the raw firmware
>> interface. And document the interface.
> 
> What's the practical purpose of the interface? Did you use this to tune
> anything on your device?
> 
>>
>> The upstream driver was build-tested with W=1 and checked with Sparse.
>> A backport using the five-argument wmidev_invoke_method() interface
>> was tested on Ubuntu 7.0.0-42 with Lenovo hardware. The upstream 7.4
>> driver has not been tested on hardware.
> 
> Don't include this in the commit message, but rather send a cover letter
> or place it under `---'.
> 
>>
>> Signed-off-by: Alan Pluto <alanpluto@163.com>
> 
> Is the work assisted by LLM?
> 
>> ---
>>  Documentation/ABI/testing/dev-tac             |  49 +++
>>  .../wmi/devices/lenovo-wmi-other.rst          |   8 +
>>  MAINTAINERS                                   |   1 +
>>  drivers/platform/x86/lenovo/wmi-other.c       | 325 ++++++++++++++++++
>>  4 files changed, 383 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/dev-tac
>>
>> diff --git a/Documentation/ABI/testing/dev-tac b/Documentation/ABI/testing/dev-tac
>> new file mode 100644
>> index 00000000000..a8be8e95e2d
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/dev-tac
>> @@ -0,0 +1,49 @@
>> +What:           /dev/tac[0-9]*
>> +Date:           November 2026
>> +Contact:        platform-driver-x86@vger.kernel.org
>> +Description:
>> +                Lenovo Other Mode WMI GetDataByPackage (method 99).
>> +                Each firmware WMI instance gets a misc character device with
>> +                mode 0600. 
>>
> 
> Why would you need to add a character device instead of a debugfs file?
> See also lwmi_debugfs_create_dir().
> 
> IMHO the interface is quite internal and undocumented. Exposing it as a
> character device makes it too reachable for users, unnecessarily
> increases the complexity of the driver, and requires some sorts of ABI
> stability.
> 
>> Numbering follows allocation order, not necessarily
>> +                the firmware instance number. 
>>
> 
> You must be using a wordy LLM if you are using one. Isn't this just
> obvious and natural for most character devices?
> 
>> Registration does not probe
>> +                support for method 99. The parent is the bound WMI device.
> 
> If it can't be probed, gate it unless a module parameter is set.
> 
>> +
>> +                Open with O_RDWR. One write submits one complete request of
>> +                1..100 raw bytes; shorter requests are padded with zeroes to
>> +                100 bytes. Empty and oversized writes fail with EINVAL without
> 
> sed -E 's/\bE[A-Z]+\b/-\0/g'
> 
>> +                calling firmware. Successful writes return the full submitted
>> +                length and execute two identical WMI calls for the BIOS
>> +                duplicate-call workaround. 
>>
> 
>> Request pairs through this
>> +                interface are serialized; calls made by other driver
>> +                interfaces are not covered by this serialization.
> 
> Why would you need to mention cross-interface implementation details in a
> user-facing documentation?
> 
>> +                Evaluation failures abort the pair; the driver does not
>> +                automatically retry.
>> +
>> +                Each open file description owns its response. 
>>
> 
> Why would you need to support multiple writers? Couldn't you simply
> return -EBUSY when there is a pending writer/reader?
> 
>> A write while
>> +                that response remains unread fails with EBUSY, including after
>> +                partial reads. 
>>
> 
> If userspace must write all data at once, why would you need to support
> partial reads?
> 
>> A new open cannot read another open's response.
>> +                Descriptors shared by dup/fork share the same transaction;
>> +                applications must coordinate the complete write/read sequence.
> 
> Aren't these just obvious and natural for most character devices, too?
> 
>> +
>> +                Read returns little-endian u32 DataSize followed by exactly
>> +                DataSize data bytes. Response storage is erased when fully
>> +                read or closed. Further reads return EOF until a new successful
>> +                write. Before a successful write, or after a failed firmware
>> +                evaluation, reads return ENODATA. A zero-length read returns
>> +                zero without consuming data.
>> +
>> +                Requests are synchronous even with O_NONBLOCK. Seeking and
>> +                positional I/O are not supported. 
>>
> 
> Aren't these just the default characteristic for most non-block character
> devices?
> 
>> There is no ioctl interface.
> 
> Too verbose. If you don't say it has some, it's obvious that it has none.
> 
>> +                A removed WMI device causes nonempty reads and valid writes
>> +                on existing descriptors to fail with ENODEV.
>> +
>> +                Firmware evaluation failures map to EIO. WMI marshalling
>> +                failures return the error reported by the WMI subsystem.
>> +                A truncated response or invalid DataSize maps to EPROTO.
>> +                Bad userspace memory maps to EFAULT. Failure does not imply
>> +                firmware had no side effects; never blindly resubmit commands.
>> +                Interrupted waits can return EINTR before firmware evaluation.
> 
> Obvious, no?
> 
>> +
>> +                The WMI subsystem converts returned ACPI objects to a buffer.
> 
> Yet another implementation detail.
> 
>> +                This raw firmware interface may change device state. Use only
>> +                commands whose behavior and side effects are understood.
>> diff --git a/Documentation/wmi/devices/lenovo-wmi-other.rst b/Documentation/wmi/devices/lenovo-wmi-other.rst
>> index 011054d64ea..ec85fdeeb7a 100644
>> --- a/Documentation/wmi/devices/lenovo-wmi-other.rst
>> +++ b/Documentation/wmi/devices/lenovo-wmi-other.rst
>> @@ -33,6 +33,10 @@ under the following path:
>>  
>>  Additionally, this driver also exports attributes to HWMON.
>>  
>> +The driver also exposes GetDataByPackage (method 99) through a raw character
>> +device for each WMI instance. See Documentation/ABI/testing/dev-tac for the
>> +request and response format and its access restrictions.
>> +
>>  LENOVO_CAPABILITY_DATA_00
>>  -------------------------
>>  
>> @@ -109,6 +113,10 @@ WMI interface description
>>  The WMI interface description can be decoded from the embedded binary MOF (bmof)
>>  data using the `bmfdec <https://github.com/pali/bmfdec>`_ utility:
>>  
>> +The example below describes an older firmware revision and specifies a
>> +40-byte maximum input for GetDataByPackage. Newer firmware uses a 100-byte
>> +input, which is the size used by the raw interface described above.
>> +
>>  ::
>>  
>>    [WMI, Dynamic, Provider("WmiProv"), Locale("MS\\0x409"), Description("LENOVO_OTHER_METHOD class"), guid("{dc2a8805-3a8c-41ba-a6f7-092e0089cd3b}")]
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 981eb3fdbef..84b1545f525 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15168,6 +15168,7 @@ M:	Derek J. Clark <derekjohn.clark@gmail.com>
>>  M:	Rong Zhang <i@rong.moe>
>>  L:	platform-driver-x86@vger.kernel.org
>>  S:	Maintained
>> +F:	Documentation/ABI/testing/dev-tac
>>  F:	Documentation/wmi/devices/lenovo-wmi-gamezone.rst
>>  F:	Documentation/wmi/devices/lenovo-wmi-other.rst
>>  F:	drivers/platform/x86/lenovo/*
>> diff --git a/drivers/platform/x86/lenovo/wmi-other.c b/drivers/platform/x86/lenovo/wmi-other.c
>> index bd64e7b4466..c15b3a2a758 100644
>> --- a/drivers/platform/x86/lenovo/wmi-other.c
>> +++ b/drivers/platform/x86/lenovo/wmi-other.c
>> @@ -34,16 +34,23 @@
>>  #include <linux/device.h>
>>  #include <linux/export.h>
>>  #include <linux/firmware_attributes.h>
>> +#include <linux/fs.h>
>>  #include <linux/gfp_types.h>
>>  #include <linux/hwmon.h>
>>  #include <linux/idr.h>
>>  #include <linux/kdev_t.h>
>>  #include <linux/kobject.h>
>> +#include <linux/kref.h>
>>  #include <linux/limits.h>
>> +#include <linux/miscdevice.h>
>>  #include <linux/module.h>
>> +#include <linux/mutex.h>
>>  #include <linux/platform_profile.h>
>>  #include <linux/power_supply.h>
>> +#include <linux/slab.h>
>>  #include <linux/types.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/unaligned.h>
>>  #include <linux/wmi.h>
>>  
>>  #include <acpi/battery.h>
>> @@ -91,6 +98,9 @@ enum lwmi_feature_id_psu {
>>  #define LWMI_FEATURE_VALUE_GET 17
>>  #define LWMI_FEATURE_VALUE_SET 18
>>  
>> +#define LWMI_DATA_PACKAGE_GET 99
>> +#define LWMI_DATA_PACKAGE_INPUT_MAX 100
>> +
>>  #define LWMI_FAN_ID_BASE 1
>>  #define LWMI_FAN_NR 4
>>  #define LWMI_FAN_ID(x) ((x) + LWMI_FAN_ID_BASE)
>> @@ -115,6 +125,27 @@ enum lwmi_feature_id_psu {
>>  
>>  static DEFINE_IDA(lwmi_om_ida);
>>  
>> +static DEFINE_IDA(lwmi_tac_ida);
>> +static DEFINE_MUTEX(lwmi_tac_lock);
>> +
>> +struct lwmi_tac {
>> +	struct miscdevice misc;
>> +	struct kref ref;
>> +	struct wmi_device *wdev;
>> +	u8 instance;
>> +	int id;
>> +};
>> +
>> +struct lwmi_tac_file {
>> +	struct lwmi_tac *tac;
>> +	/* Protects the per-open response and its position. */
>> +	struct mutex lock;
>> +	void *result;
>> +	size_t result_len;
>> +	loff_t position;
>> +	bool completed;
>> +};
>> +
>>  enum attribute_property {
>>  	DEFAULT_VAL,
>>  	MAX_VAL,
>> @@ -1609,6 +1640,295 @@ static void lwmi_om_fw_attr_remove(struct lwmi_om_priv *priv)
>>  	priv->ida_id = -EIDRM;
>>  }
>>  
>> +/**
>> + * lwmi_tac_free() - Free an unregistered endpoint after its last close
>> + * @ref: Reference belonging to the endpoint.
>> + */
>> +static void lwmi_tac_free(struct kref *ref)
>> +{
>> +	struct lwmi_tac *tac = container_of(ref, struct lwmi_tac, ref);
>> +
>> +	ida_free(&lwmi_tac_ida, tac->id);
>> +	kfree(tac->misc.name);
>> +	kfree(tac);
>> +}
>> +
>> +/**
>> + * lwmi_tac_open() - Allocate independent response state for an open file
>> + * @inode: Character device inode.
>> + * @file: File initially pointing to the registered miscdevice.
>> + *
>> + * The misc core serializes open against deregistration, so the registration
>> + * reference remains valid while the file acquires its own reference.
>> + *
>> + * Return: 0 on success, or -ENOMEM.
>> + */
>> +static int lwmi_tac_open(struct inode *inode, struct file *file)
>> +{
>> +	struct lwmi_tac *tac = container_of(file->private_data, struct lwmi_tac, misc);
>> +	struct lwmi_tac_file *state;
>> +
>> +	state = kzalloc_obj(*state);
>> +	if (!state)
>> +		return -ENOMEM;
>> +	mutex_init(&state->lock);
>> +	state->tac = tac;
>> +	kref_get(&tac->ref);
>> +	file->private_data = state;
>> +	return stream_open(inode, file);
> 
> Add line breaks to improve readability. Same for the following methods.
> 
>> +}
>> +
>> +/**
>> + * lwmi_tac_release() - Erase the response and drop the endpoint reference
>> + * @inode: Character device inode.
>> + * @file: File holding the endpoint state.
>> + *
>> + * Return: 0.
>> + */
>> +static int lwmi_tac_release(struct inode *inode, struct file *file)
>> +{
>> +	struct lwmi_tac_file *state = file->private_data;
>> +
>> +	kfree_sensitive(state->result);
> 
> Why on earth is it sensitive?
> 
>> +	mutex_destroy(&state->lock);
>> +	kref_put(&state->tac->ref, lwmi_tac_free);
>> +	kfree(state);
>> +	return 0;
>> +}
>> +
>> +/**
>> + * lwmi_tac_invoke() - Execute GetDataByPackage and retain the response
>> + * @state: Open file whose response buffer is empty.
>> + * @data: Zero-padded 100-byte input buffer.
>> + *
>> + * The caller holds state->lock and lwmi_tac_lock. 
>>
> 
> Add lockdep assertions instead of stating them in comments.
> 
>> The latter serializes call
>> + * pairs across instances and keeps the WMI device valid during evaluation.
>> + *
>> + * Return: 0 on success, or a negative error code.
>> + */
>> +static int lwmi_tac_invoke(struct lwmi_tac_file *state, u8 *data)
>> +{
>> +	struct lwmi_tac *tac = state->tac;
>> +	struct wmi_buffer input = { .length = LWMI_DATA_PACKAGE_INPUT_MAX, .data = data };
>> +	struct wmi_buffer output;
>> +	u32 data_size;
>> +	int ret;
>> +
>> +	if (!tac->wdev)
>> +		return -ENODEV;
>> +	/*
>> +	 * Duplicated call required to match BIOS workaround for behavior
>> +	 * seen when WMI accessed via scripting on other OS.
> 
> Reference? Where is the script?
> 
>> +	 */
>> +	for (unsigned int call = 0; call < 2; call++) {
>> +		ret = wmidev_invoke_method(tac->wdev, tac->instance,
>> +					   LWMI_DATA_PACKAGE_GET, &input, &output, 0);
>> +		if (ret)
>> +			return ret;
>> +		if (!call)
>> +			kfree_sensitive(output.data);
>> +	}
>> +	/* Validate DataSize before preserving the complete firmware response. */
> 
> Don't retell what the code does, but rather explain why.
> 
>> +	if (output.length < sizeof(__le32)) {
> 
> Why not use wmidev_invoke_method()'s min_size argument?
> 
>> +		ret = -EPROTO;
>> +		goto free_output;
>> +	}
>> +	data_size = get_unaligned_le32(output.data);
> 
> wmidev_invoke_method() returns aligned data.
> 
>> +	if (data_size > output.length - sizeof(__le32)) {
>> +		ret = -EPROTO;
>> +		goto free_output;
>> +	}
>> +	/* Transfer ownership without another allocation after firmware ran. */
>> +	state->result = output.data;
> 
> Use __free() and no_free_ptr().
> 
>> +	state->result_len = sizeof(__le32) + data_size;
> 
> Couldn't you declare a struct with a flex array member to represent this?
> 
>> +	state->position = 0;
>> +	state->completed = true;
>> +	return 0;
>> +free_output:
>> +	kfree_sensitive(output.data);
>> +	return ret;
>> +}
>> +
>> +/**
>> + * lwmi_tac_write() - Submit one complete TAC request
> 
> "complete"
> 
> Obvious.
> 
>> + * @file: Open TAC endpoint with independent response state.
>> + * @buffer: Userspace input bytes.
>> + * @count: Input size, from 1 to 100 bytes.
>> + * @ppos: Unused; 
>>
> 
>> TAC is a nonseekable request/response stream.
> 
> Obvious.
> 
>> + *
>> + * Short inputs are zero-padded. An unread response must be consumed before
>> + * submitting another request. A failed firmware call is never retried here.
>> + *
>> + * Return: @count on success, or a negative error code.
>> + */
>> +static ssize_t lwmi_tac_write(struct file *file, const char __user *buffer,
>> +			      size_t count, loff_t *ppos)
>> +{
>> +	struct lwmi_tac_file *state = file->private_data;
>> +	u8 input[LWMI_DATA_PACKAGE_INPUT_MAX] = {};
>> +	int ret;
>> +
>> +	if (!count || count > sizeof(input))
>> +		return -EINVAL;
>> +	if (copy_from_user(input, buffer, count)) {
>> +		ret = -EFAULT;
>> +		goto clear_input;
>> +	}
>> +	ret = mutex_lock_interruptible(&state->lock);
>> +	if (ret)
>> +		goto clear_input;
>> +	ret = mutex_lock_interruptible(&lwmi_tac_lock);
>> +	if (ret)
>> +		goto unlock;
> 
> Use scoped_cond_guard() or ACQUIRE().
> 
>> +	if (!state->tac->wdev) {
>> +		ret = -ENODEV;
>> +	} else if (state->result) {
>> +		ret = -EBUSY;
>> +	} else {
>> +		state->completed = false;
>> +		ret = lwmi_tac_invoke(state, input);
>> +	}
>> +	mutex_unlock(&lwmi_tac_lock);
>> +unlock:
>> +	mutex_unlock(&state->lock);
>> +clear_input:
>> +	memzero_explicit(input, sizeof(input));
> 
> Why on earth is it sensitive, too?
> 
>> +	if (ret)
>> +		return ret;
>> +	return count;
>> +}
>> +
>> +/**
>> + * lwmi_tac_read() - Read only this open file's firmware response
> 
> "only"
> 
> Obvious, no?
> 
>> + * @file: Open TAC endpoint.
>> + * @buffer: Userspace destination.
>> + * @count: Maximum number of bytes to return.
>> + * @ppos: Unused; the response position is protected by state->lock.
>> + *
>> + * Responses contain little-endian u32 DataSize followed by Data. Partial
>> + * reads advance the response position. Consuming the result erases its
>> + * storage immediately; subsequent reads return EOF until another write.
>> + *
>> + * Return: Bytes read, 0 at EOF or for zero @count, or a negative error code.
>> + */
>> +static ssize_t lwmi_tac_read(struct file *file, char __user *buffer,
>> +			     size_t count, loff_t *ppos)
>> +{
>> +	struct lwmi_tac_file *state = file->private_data;
>> +	ssize_t ret;
>> +
>> +	if (!count)
>> +		return 0;
>> +	ret = mutex_lock_interruptible(&state->lock);
>> +	if (ret)
>> +		return ret;
>> +	ret = mutex_lock_interruptible(&lwmi_tac_lock);
>> +	if (ret)
>> +		goto unlock;
>> +	if (!state->tac->wdev)
>> +		ret = -ENODEV;
>> +	mutex_unlock(&lwmi_tac_lock);
>> +	if (ret) {
>> +		kfree_sensitive(state->result);
>> +		state->result = NULL;
>> +		goto unlock;
>> +	}
>> +	if (!state->completed) {
>> +		ret = -ENODATA;
>> +		goto unlock;
>> +	}
>> +	if (!state->result)
>> +		goto unlock;
>> +	ret = simple_read_from_buffer(buffer, count, &state->position,
>> +				      state->result, state->result_len);
>> +	if (state->position == (loff_t)state->result_len) {
>> +		kfree_sensitive(state->result);
>> +		state->result = NULL;
>> +	}
>> +unlock:
>> +	mutex_unlock(&state->lock);
>> +	return ret;
> 
> The entire method is in a horrible mess. Drop the support for partial
> reads, and use scoped_cond_guard()/ACQUIRE(), and __free() to tidy it up.
> 
>> +}
>> +
>> +static const struct file_operations lwmi_tac_fops = {
>> +	.owner = THIS_MODULE,
>> +	.open = lwmi_tac_open,
>> +	.release = lwmi_tac_release,
>> +	.read = lwmi_tac_read,
>> +	.write = lwmi_tac_write,
>> +};
>> +
>> +/**
>> + * lwmi_tac_remove() - Unregister an endpoint and block further firmware calls
>> + * @data: Endpoint registered as a device-managed cleanup action.
>> + *
>> + * Stop new opens before waiting for an in-flight call pair. Existing files
>> + * retain the endpoint state, but their subsequent reads/writes return -ENODEV.
>> + */
>> +static void lwmi_tac_remove(void *data)
>> +{
>> +	struct lwmi_tac *tac = data;
>> +
>> +	misc_deregister(&tac->misc);
>> +	mutex_lock(&lwmi_tac_lock);
>> +	tac->wdev = NULL;
>> +	mutex_unlock(&lwmi_tac_lock);
>> +	kref_put(&tac->ref, lwmi_tac_free);
>> +}
>> +
>> +/**
>> + * lwmi_tac_add() - Register TAC endpoints independently of capability data
>> + * @wdev: Bound Lenovo Other Mode WMI device.
>> + *
>> + * No capability describes method 99, so registration does not probe firmware
>> + * support. Each firmware instance gets an endpoint; unsupported method calls
>> + * are reported to userspace when requested.
>> + *
>> + * Return: 0 on success, or a negative error code. Device-managed cleanup
>> + * unregisters earlier endpoints if a later registration or probe step fails.
>> + */
>> +static int lwmi_tac_add(struct wmi_device *wdev)
> 
> devm_
> 
>> +{
>> +	unsigned int instances = wmidev_instance_count(wdev);
>> +	int ret;
>> +
>> +	for (unsigned int instance = 0; instance < instances; instance++) {
>> +		struct lwmi_tac *tac;
>> +
>> +		tac = kzalloc_obj(*tac);
>> +		if (!tac)
>> +			return -ENOMEM;
>> +		ret = ida_alloc(&lwmi_tac_ida, GFP_KERNEL);
>> +		if (ret < 0) {
>> +			kfree(tac);
>> +			return ret;
>> +		}
>> +		tac->id = ret;
>> +		kref_init(&tac->ref);
>> +		tac->wdev = wdev;
>> +		tac->instance = instance;
>> +		tac->misc.minor = MISC_DYNAMIC_MINOR;
>> +		tac->misc.name = kasprintf(GFP_KERNEL, "tac%d", tac->id);
>> +		tac->misc.fops = &lwmi_tac_fops;
>> +		tac->misc.parent = &wdev->dev;
>> +		tac->misc.mode = 0600;
>> +		if (!tac->misc.name) {
>> +			kref_put(&tac->ref, lwmi_tac_free);
>> +			return -ENOMEM;
>> +		}
>> +		ret = misc_register(&tac->misc);
>> +		if (ret) {
>> +			kref_put(&tac->ref, lwmi_tac_free);
>> +			return ret;
>> +		}
>> +		/* Unregister before the WMI device and its managed state disappear. */
>> +		ret = devm_add_action_or_reset(&wdev->dev, lwmi_tac_remove, tac);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +	return 0;
>> +}
>> +
>>  /* ======== Self (master: lenovo-wmi-other) ======== */
>>  
>>  /**
>> @@ -1693,6 +2013,7 @@ static int lwmi_other_probe(struct wmi_device *wdev, const void *context)
>>  {
>>  	struct component_match *master_match = NULL;
>>  	struct lwmi_om_priv *priv;
>> +	int ret;
>>  
>>  	priv = devm_kzalloc_obj(&wdev->dev, *priv);
>>  	if (!priv)
>> @@ -1708,6 +2029,10 @@ static int lwmi_other_probe(struct wmi_device *wdev, const void *context)
>>  	if (IS_ERR(master_match))
>>  		return PTR_ERR(master_match);
>>  
>> +	ret = lwmi_tac_add(wdev);
>> +	if (ret)
>> +		return ret;
> 
> Why is this fatal?
> 
> Thanks,
> Rong
> 
>> +
>>  	return component_master_add_with_match(&wdev->dev, &lwmi_om_master_ops,
>>  					       master_match);
>>  }
>>
>> base-commit: 5680519168f65666d2c03cc6ed8fe2b7052aee12

Thanks for the detailed review. I sent v2 patch separately by referring
your suggestion. Please help review it.
My replies to your points are below.

1. Practical purpose and tuning

The known use is for Lenovo utility to communicate with firmware.
In v2 I use a default-off debugfs interface instead of stable userspace
interface.

2. Test information in the commit message

I removed the build and test details from the v2 commit message.

3. LLM assistance

Yes, I used AI assistance for the port and review. I reviewed the
changes and am responsible for the submission.

4. Character device versus debugfs, and the module parameter

I replaced the character device with a 0600 debugfs file created under
lwmi_debugfs_create_dir(). There is no non-invasive probe for method 99,
so creation is disabled by default and requires
enable_get_data_by_package=1 when loading the module. I removed the v1
ABI document and its MAINTAINERS entry.

5. ABI documentation and verbosity

Removed the character-device ABI document change.

6. Multiple writers and partial reads

The debugfs file permits one open only per WMI device.

7. Readability and comments

I simplified the handlers and removed the redundant kernel-doc and
comments that merely described normal file operations. I also removed
the unsupported reference to a script on another OS.

8. Locking

With one open per WMI device, a per-open lock protects the response and
serializes operations through shared descriptors. lwmi_package_invoke()
uses lockdep_assert_held() for that lock.

9. Sensitive data

The firmware response can contain sensitive data, so I retained
kfree_sensitive() for buffers returned successfully by WMI.

10. Duplicate calls

You can refer as think-lmi.c, same duplicated call. The reason is
invoking WMI under Windows OS will result the BIOS ACPI code execute
twice, so BIOS implemented the workaround, thus Linux driver will need
the duplicated call to match the BIOS workaround.

11. Response size, alignment and cleanup

The second wmidev_invoke_method() call passes the response header size
as min_size. The driver separately validates DataSize against the
returned buffer length. The response is represented by an aligned
structure with a flexible array; after the successful call I declare it
with __free(kfree_sensitive) and transfer ownership with no_free_ptr().

12. Scoped locking and probe failure

Read and write use ACQUIRE()/ACQUIRE_ERR(). The device-managed debugfs
cleanup action handles removal and setup rollback. A debugfs setup error
is reported with dev_warn(), but does not by itself fail driver probe.

Thanks,
Alan

