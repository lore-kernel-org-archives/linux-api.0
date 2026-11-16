Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794848218;
	b=ZxmxkFTZ5icLP0jkLIxd4bdFqGfOCwYPXusVZq8ltvcMkrH31yVACksV4w1hPAR8XGpK
	 P0m/1kiWsoX+EHhgTRTJe6vXC8g1+iVHGMQ7cIzoUJB2PAuohzXf3eEkp8fvkU3Kd0YNx
	 /7YdGQXFoX2Y7hk6EpwBAcR4looFJwXq/hV9SKc5Yqs0juGaU9E0HMLi+eeyPDwpvqFFn
	 +tbXXvhD1K0M/neDyjtT0uEid8RnXoQg1Btw7KMqyQaK2oeqIjokp12GPnUbrm4kYRn6F
	 jYAqzb4mGwO4X/Orwu+/oFVFI6rL3wws3qYaJLCF3Y99l4ctkB+qB759aIWf7Cs8jQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848218;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=wLnbZve+OkQ6YTZYC3Sz6BV0QtHRhOr4tbKex2cYIK8=;
	b=UcJYEzFeGRCnBh1++Wubmv9V3TMsuQGdsHlLjy3/TSUmpOVIYxjW9YVAIrDvXooKCdHJ
	 1XtP+wz0/9uVUYcu//MWC29pr6hpJ5k8TdMWbYjaIn1CRDCUKRbZdPjLd1B01haplR0cN
	 j+6BQFrR4jq1D3VlTCfAvUHxpDPIFtma5d2Ro80czKA1xWgxXIvWHCTuVEnhHiiH8rGn4
	 outQe8GX/+bE7jk8+LqDC1EcJCnBkyrMQwBB0dHLmUCUsGcWvz9INV7B56kzrn+OvXfYm
	 /6jJ8g/3H1Oc8MohnHeUlBFZ1tTm9ltFISKClDXsKBmzOmeVNP4uIgQmeCBHx85i23Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=squebb.ca;
	spf=pass smtp.mailfrom=squebb.ca;
	dkim=pass header.d=squebb.ca header.i=@squebb.ca header.a=rsa-sha256 header.s=fm1 header.b=aGL5EJju;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=R3m5vGF3;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F363F606A89D
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 16:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F363F606A89D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=squebb.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=squebb.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=squebb.ca header.i=@squebb.ca header.a=rsa-sha256 header.s=fm1 header.b=aGL5EJju;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=R3m5vGF3
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C3F5A140007E
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 11:56:54 -0500 (EST)
Received: from stl-imap-02 ([10.204.2.93])
  by stl-compute-04.internal (MEProxy); Mon, 16 Nov 2026 11:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1794848212;
	 x=1794934612; bh=wLnbZve+OkQ6YTZYC3Sz6BV0QtHRhOr4tbKex2cYIK8=; b=
	aGL5EJjuXY0h3pFz+NyD9p32tUni6iGra9sn1pMcpPPK7EmuSRb+Ne7qGwqh/drL
	r73vW5+dzlIaO5788fI1C2YTfFFG1Kjt65l31KRbqRod3qus1MeH1kBA1gehKLZj
	+odEhAMOue/xfMiRQToyn/NyOAjgQo/RbC1D8zqlxpkmmbi+5eF8N3KT10DvM8tb
	vrDJtFD4mCwcGtavZ6wTlFStSvRs5LHiXj3CO9Vzat/QS/hJAhNFMgtSPzaGTp5d
	kn+SpIeMuLDMMPPseQCnKSbyaztAj+RKRy6gPdTxYnbPOrcHiFWfNKi6S5AQXYea
	PXXlVbPAaZI5eK53eVk+Rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794848212; x=
	1794934612; bh=wLnbZve+OkQ6YTZYC3Sz6BV0QtHRhOr4tbKex2cYIK8=; b=R
	3m5vGF3KgG5HzTbG7DFA99ackUgmBGNzYGibdcfYXlR8zaXdWpK17QDmMecpYcrl
	yMXwaIGctqwXi4kOPvvwqLbz02KrrfAY5yUL0JTLliKscgMIJJY2S/NTmHRt2G0F
	6zep/wW6XH811eu3twEFZDoDy4jna3/gifu3r2Ith8FYKwSFEj4ed9p4NnvNGbzK
	n4HucR5MY3bOwCgNfNhLwfbQN72dlml7ohmcLf2GWrR7WRnPLFeCmQgWRprJof8t
	GrU6cwJjAhOUvOxHnsn1Lk4hbGQr9vnIB8lGFU9lZUXiAf97LgSTWtND4eBhaPJ7
	53HIIaYom3GmJ9NeCTyxQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=squebb.ca a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794848212; d=squebb.ca;
	mf=PG1wZWFyc29uLWxlbm92b0BzcXVlYmIuY2E+;
	rt=PGxpbnV4LWFwaUB2Z2VyLmtlcm5lbC5vcmc+;
	s=fm1:rsa-sha256:PME0rMOSbuTco2RNGeZpdM3zquthcVOdIMhNZyPrhPIp/lD
	2rv7Q0EkUhPpAFR9njkJkUtxaAlaMLsr1MPHT9RyP0sy8oQ1lEbUN+r7ErGAXPls
	2PpIRWzpy2q0nMLGmDNBvwvvwJRmfjoj5+91wvwvblQSmn3EcPifWOY+Js2cRK4M
	lpcH0vWq78pFs4oB79FgPXFwIN6wKYXB6gV8VZ7WwAQpMeKb75io1gqfS02cAeUT
	9pgYgrcP69TVB1XZT9PTWWiiPw8Ew9f80Xn0PH/HB7ZRJarRMz2yx6uLGLVgdHUi
	qrBgr0Sst4KXKaWR6uik7D2JIbT8fpI3k5Ri9oQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:ZkQMNJ1Vs2ffPX930/yb7Jv06SjiQPVkwN60EMvYOHw=:qZIwAzne+fEx/iaHFoTI8JjWFpBebSGFSQAX4LGGZpA=;
X-ME-Sender: <xms:0zX7aidpbdaAAd4tSA7rVyPEAIdj9MyS43Icn11Y9Y30RhDdKR034A>
    <xme:0zX7anCjkTZhiYI9ImamJ8rsX_QfLWfYuUtKaSoddIRKpJ4ES0BMy8kFeHUQa1UW7
    mFgdJwixiMBaK77-phmJAzcNdxGRiwJkKAb7_prGgL6nPH0TzpjBHH7>
X-ME-Proxy-Cause: dmFkZTEK4AwU3c7juGKDHnx3zstPI90UpZcPrDZ0ExSyvnG3qx1og7rZvj7ku4Mq4p460d
    rQBBIQwFPH1qz45g6rFdlsEY4C043TlqybR7XoyoDPrq52rCMohdjbxc9Gx+rkTBQNC8KF
    y4ynly08ugcGvufv8WJhZvqfE6vvaHUp8wd05Dz7Ktf9sq1nBGajHzs5UV0C8ZpHO5NaWK
    XM/cY4bsgTqSozWDCy0yXQJ6xjlDsusnmQ8ilfB9YtKGtlCcuobJvi6U+0gwsIdUyCfICY
    0PkQ5qKRYwyF7Fz1euQLewEi1G+dO05gs+mcVCbeydGmyE3+VmThsJJu6OMnbv6fpdpCY3
    f0nGBl7Sl97Rd+ixz6cJN33SeBVBirEHNjb528cMvTGuuSa7bz4MGWpn5wANp1ZOANdEmq
    enGwKdauZtc4wXmbjY/5wrftCgz9iHuZLvLarSe9YaUX6RDskGJmpx91fe4Ke6z8FN6gpz
    N7D44TbEgp+onJ+zAtkYcbqKytzQCepss4lSaU0P2wTSblf+0QOz2zX+t1Hr9N51UD9SDM
    UULvS8R9sWAHspbgpuWp7/Vu+k+qSqH9LXxKaTvFQcIF6ZFYndS7tfY61E19r2fwECQ/Xj
    Yzwn+eIN7JA63/lQqwzKMQayku8tiT3n+uORvwbGqEBsiwyG3clp8/CbuJ2A
X-ME-Proxy: <xmx:0zX7apKhsGQIt3U4e-dtJ125Vf7p6f2Y0KA6BkifNkkmixycE1l6dw>
    <xmx:0zX7apuKcQGSLKfI8EjH3G1ChlCX7KwgPuAx7cuR0BOy7bgH-MKA3Q>
    <xmx:0zX7au3FoxHKi9NZinAWo6Qglrvd6dBA3dIacEcurT2Xs8_NADDgNw>
    <xmx:0zX7ahPFxeVsvBGT7R-G1X5fh9V-AdJS3hKe4ECqwoGpIRqlPlpErg>
    <xmx:1DX7anttEkKVRBlsUdUazWEvt3ejOArFUznSzfxmveNKsY2aoA1PdCJ2>
Feedback-ID: ibe194615:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 3149E2C00085; Mon, 16 Nov 2026 11:56:51 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AxqS-XYwZQCk
Date: Mon, 16 Nov 2026 11:56:31 -0500
From: "Mark Pearson" <mpearson-lenovo@squebb.ca>
To: "Alan Pluto" <alanpluto@163.com>,
 "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>
Cc: "Derek J . Clark" <derekjohn.clark@gmail.com>, "Rong Zhang" <i@rong.moe>,
 "Armin Wolf" <W_Armin@gmx.de>, "Hans de Goede" <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 "Jonathan Corbet" <corbet@lwn.net>, skhan@linuxfoundation.org,
 "Randy Dunlap" <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Message-Id: <85830240-1444-4e88-9d2c-97e3d39ae4b2@app.fastmail.com>
In-Reply-To: <20261116040532.154928-1-alanpluto@163.com>
References: <20261116040532.154928-1-alanpluto@163.com>
Subject: Re: [PATCH] platform/x86: lenovo-wmi-other: Add raw GetDataByPackage interface
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Alan,

On Sun, Nov 15, 2026, at 11:05 PM, Alan Pluto wrote:
> Expose Lenovo Other Mode WMI GetDataByPackage, method 99, through a
> root-only character device so userspace can access the raw firmware
> interface. And document the interface.
>
> The upstream driver was build-tested with W=1 and checked with Sparse.
> A backport using the five-argument wmidev_invoke_method() interface
> was tested on Ubuntu 7.0.0-42 with Lenovo hardware. The upstream 7.4
> driver has not been tested on hardware.
>
> Signed-off-by: Alan Pluto <alanpluto@163.com>
> ---
>  Documentation/ABI/testing/dev-tac             |  49 +++
>  .../wmi/devices/lenovo-wmi-other.rst          |   8 +
>  MAINTAINERS                                   |   1 +
>  drivers/platform/x86/lenovo/wmi-other.c       | 325 ++++++++++++++++++
>  4 files changed, 383 insertions(+)
>  create mode 100644 Documentation/ABI/testing/dev-tac
>
> diff --git a/Documentation/ABI/testing/dev-tac 
> b/Documentation/ABI/testing/dev-tac
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
> +                Each firmware WMI instance gets a misc character 
> device with
> +                mode 0600. Numbering follows allocation order, not 
> necessarily
> +                the firmware instance number. Registration does not 
> probe
> +                support for method 99. The parent is the bound WMI 
> device.
> +
> +                Open with O_RDWR. One write submits one complete 
> request of
> +                1..100 raw bytes; shorter requests are padded with 
> zeroes to
> +                100 bytes. Empty and oversized writes fail with EINVAL 
> without
> +                calling firmware. Successful writes return the full 
> submitted
> +                length and execute two identical WMI calls for the BIOS
> +                duplicate-call workaround. Request pairs through this
> +                interface are serialized; calls made by other driver
> +                interfaces are not covered by this serialization.
> +                Evaluation failures abort the pair; the driver does not
> +                automatically retry.
> +
> +                Each open file description owns its response. A write 
> while
> +                that response remains unread fails with EBUSY, 
> including after
> +                partial reads. A new open cannot read another open's 
> response.
> +                Descriptors shared by dup/fork share the same 
> transaction;
> +                applications must coordinate the complete write/read 
> sequence.
> +
> +                Read returns little-endian u32 DataSize followed by 
> exactly
> +                DataSize data bytes. Response storage is erased when 
> fully
> +                read or closed. Further reads return EOF until a new 
> successful
> +                write. Before a successful write, or after a failed 
> firmware
> +                evaluation, reads return ENODATA. A zero-length read 
> returns
> +                zero without consuming data.
> +
> +                Requests are synchronous even with O_NONBLOCK. Seeking 
> and
> +                positional I/O are not supported. There is no ioctl 
> interface.
> +                A removed WMI device causes nonempty reads and valid 
> writes
> +                on existing descriptors to fail with ENODEV.
> +
> +                Firmware evaluation failures map to EIO. WMI 
> marshalling
> +                failures return the error reported by the WMI 
> subsystem.
> +                A truncated response or invalid DataSize maps to 
> EPROTO.
> +                Bad userspace memory maps to EFAULT. Failure does not 
> imply
> +                firmware had no side effects; never blindly resubmit 
> commands.
> +                Interrupted waits can return EINTR before firmware 
> evaluation.
> +
> +                The WMI subsystem converts returned ACPI objects to a 
> buffer.
> +                This raw firmware interface may change device state. 
> Use only
> +                commands whose behavior and side effects are 
> understood.
> diff --git a/Documentation/wmi/devices/lenovo-wmi-other.rst 
> b/Documentation/wmi/devices/lenovo-wmi-other.rst
> index 011054d64ea..ec85fdeeb7a 100644
> --- a/Documentation/wmi/devices/lenovo-wmi-other.rst
> +++ b/Documentation/wmi/devices/lenovo-wmi-other.rst
> @@ -33,6 +33,10 @@ under the following path:
> 
>  Additionally, this driver also exports attributes to HWMON.
> 
> +The driver also exposes GetDataByPackage (method 99) through a raw character
> +device for each WMI instance. See Documentation/ABI/testing/dev-tac for the
> +request and response format and its access restrictions.
> +
>  LENOVO_CAPABILITY_DATA_00
>  -------------------------
> 
> @@ -109,6 +113,10 @@ WMI interface description
>  The WMI interface description can be decoded from the embedded binary 
> MOF (bmof)
>  data using the `bmfdec <https://github.com/pali/bmfdec>`_ utility:
> 
> +The example below describes an older firmware revision and specifies a
> +40-byte maximum input for GetDataByPackage. Newer firmware uses a 100-byte
> +input, which is the size used by the raw interface described above.
> +
>  ::
> 
>    [WMI, Dynamic, Provider("WmiProv"), Locale("MS\\0x409"), 
> Description("LENOVO_OTHER_METHOD class"), 
> guid("{dc2a8805-3a8c-41ba-a6f7-092e0089cd3b}")]
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 981eb3fdbef..84b1545f525 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15168,6 +15168,7 @@ M:	Derek J. Clark <derekjohn.clark@gmail.com>
>  M:	Rong Zhang <i@rong.moe>
>  L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/ABI/testing/dev-tac
>  F:	Documentation/wmi/devices/lenovo-wmi-gamezone.rst
>  F:	Documentation/wmi/devices/lenovo-wmi-other.rst
>  F:	drivers/platform/x86/lenovo/*
> diff --git a/drivers/platform/x86/lenovo/wmi-other.c 
> b/drivers/platform/x86/lenovo/wmi-other.c
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
> 
>  #include <acpi/battery.h>
> @@ -91,6 +98,9 @@ enum lwmi_feature_id_psu {
>  #define LWMI_FEATURE_VALUE_GET 17
>  #define LWMI_FEATURE_VALUE_SET 18
> 
> +#define LWMI_DATA_PACKAGE_GET 99
> +#define LWMI_DATA_PACKAGE_INPUT_MAX 100
> +
>  #define LWMI_FAN_ID_BASE 1
>  #define LWMI_FAN_NR 4
>  #define LWMI_FAN_ID(x) ((x) + LWMI_FAN_ID_BASE)
> @@ -115,6 +125,27 @@ enum lwmi_feature_id_psu {
> 
>  static DEFINE_IDA(lwmi_om_ida);
> 
> +static DEFINE_IDA(lwmi_tac_ida);
> +static DEFINE_MUTEX(lwmi_tac_lock);
> +
> +struct lwmi_tac {
> +	struct miscdevice misc;
> +	struct kref ref;
> +	struct wmi_device *wdev;
> +	u8 instance;
> +	int id;
> +};
> +
> +struct lwmi_tac_file {
> +	struct lwmi_tac *tac;
> +	/* Protects the per-open response and its position. */
> +	struct mutex lock;
> +	void *result;
> +	size_t result_len;
> +	loff_t position;
> +	bool completed;
> +};
> +
>  enum attribute_property {
>  	DEFAULT_VAL,
>  	MAX_VAL,
> @@ -1609,6 +1640,295 @@ static void lwmi_om_fw_attr_remove(struct 
> lwmi_om_priv *priv)
>  	priv->ida_id = -EIDRM;
>  }
> 
> +/**
> + * lwmi_tac_free() - Free an unregistered endpoint after its last close
> + * @ref: Reference belonging to the endpoint.
> + */
> +static void lwmi_tac_free(struct kref *ref)
> +{
> +	struct lwmi_tac *tac = container_of(ref, struct lwmi_tac, ref);
> +
> +	ida_free(&lwmi_tac_ida, tac->id);
> +	kfree(tac->misc.name);
> +	kfree(tac);
> +}
> +
> +/**
> + * lwmi_tac_open() - Allocate independent response state for an open 
> file
> + * @inode: Character device inode.
> + * @file: File initially pointing to the registered miscdevice.
> + *
> + * The misc core serializes open against deregistration, so the 
> registration
> + * reference remains valid while the file acquires its own reference.
> + *
> + * Return: 0 on success, or -ENOMEM.
> + */
> +static int lwmi_tac_open(struct inode *inode, struct file *file)
> +{
> +	struct lwmi_tac *tac = container_of(file->private_data, struct 
> lwmi_tac, misc);
> +	struct lwmi_tac_file *state;
> +
> +	state = kzalloc_obj(*state);
> +	if (!state)
> +		return -ENOMEM;
> +	mutex_init(&state->lock);
> +	state->tac = tac;
> +	kref_get(&tac->ref);
> +	file->private_data = state;
> +	return stream_open(inode, file);
> +}
> +
> +/**
> + * lwmi_tac_release() - Erase the response and drop the endpoint 
> reference
> + * @inode: Character device inode.
> + * @file: File holding the endpoint state.
> + *
> + * Return: 0.
> + */
> +static int lwmi_tac_release(struct inode *inode, struct file *file)
> +{
> +	struct lwmi_tac_file *state = file->private_data;
> +
> +	kfree_sensitive(state->result);
> +	mutex_destroy(&state->lock);
> +	kref_put(&state->tac->ref, lwmi_tac_free);
> +	kfree(state);
> +	return 0;
> +}
> +
> +/**
> + * lwmi_tac_invoke() - Execute GetDataByPackage and retain the response
> + * @state: Open file whose response buffer is empty.
> + * @data: Zero-padded 100-byte input buffer.
> + *
> + * The caller holds state->lock and lwmi_tac_lock. The latter 
> serializes call
> + * pairs across instances and keeps the WMI device valid during 
> evaluation.
> + *
> + * Return: 0 on success, or a negative error code.
> + */
> +static int lwmi_tac_invoke(struct lwmi_tac_file *state, u8 *data)
> +{
> +	struct lwmi_tac *tac = state->tac;
> +	struct wmi_buffer input = { .length = LWMI_DATA_PACKAGE_INPUT_MAX, 
> .data = data };
> +	struct wmi_buffer output;
> +	u32 data_size;
> +	int ret;
> +
> +	if (!tac->wdev)
> +		return -ENODEV;
> +	/*
> +	 * Duplicated call required to match BIOS workaround for behavior
> +	 * seen when WMI accessed via scripting on other OS.
> +	 */
> +	for (unsigned int call = 0; call < 2; call++) {
> +		ret = wmidev_invoke_method(tac->wdev, tac->instance,
> +					   LWMI_DATA_PACKAGE_GET, &input, &output, 0);
> +		if (ret)
> +			return ret;
> +		if (!call)
> +			kfree_sensitive(output.data);
> +	}
> +	/* Validate DataSize before preserving the complete firmware 
> response. */
> +	if (output.length < sizeof(__le32)) {
> +		ret = -EPROTO;
> +		goto free_output;
> +	}
> +	data_size = get_unaligned_le32(output.data);
> +	if (data_size > output.length - sizeof(__le32)) {
> +		ret = -EPROTO;
> +		goto free_output;
> +	}
> +	/* Transfer ownership without another allocation after firmware ran. 
> */
> +	state->result = output.data;
> +	state->result_len = sizeof(__le32) + data_size;
> +	state->position = 0;
> +	state->completed = true;
> +	return 0;
> +free_output:
> +	kfree_sensitive(output.data);
> +	return ret;
> +}
> +
> +/**
> + * lwmi_tac_write() - Submit one complete TAC request
> + * @file: Open TAC endpoint with independent response state.
> + * @buffer: Userspace input bytes.
> + * @count: Input size, from 1 to 100 bytes.
> + * @ppos: Unused; TAC is a nonseekable request/response stream.
> + *
> + * Short inputs are zero-padded. An unread response must be consumed 
> before
> + * submitting another request. A failed firmware call is never retried 
> here.
> + *
> + * Return: @count on success, or a negative error code.
> + */
> +static ssize_t lwmi_tac_write(struct file *file, const char __user 
> *buffer,
> +			      size_t count, loff_t *ppos)
> +{
> +	struct lwmi_tac_file *state = file->private_data;
> +	u8 input[LWMI_DATA_PACKAGE_INPUT_MAX] = {};
> +	int ret;
> +
> +	if (!count || count > sizeof(input))
> +		return -EINVAL;
> +	if (copy_from_user(input, buffer, count)) {
> +		ret = -EFAULT;
> +		goto clear_input;
> +	}
> +	ret = mutex_lock_interruptible(&state->lock);
> +	if (ret)
> +		goto clear_input;
> +	ret = mutex_lock_interruptible(&lwmi_tac_lock);
> +	if (ret)
> +		goto unlock;
> +	if (!state->tac->wdev) {
> +		ret = -ENODEV;
> +	} else if (state->result) {
> +		ret = -EBUSY;
> +	} else {
> +		state->completed = false;
> +		ret = lwmi_tac_invoke(state, input);
> +	}
> +	mutex_unlock(&lwmi_tac_lock);
> +unlock:
> +	mutex_unlock(&state->lock);
> +clear_input:
> +	memzero_explicit(input, sizeof(input));
> +	if (ret)
> +		return ret;
> +	return count;
> +}
> +
> +/**
> + * lwmi_tac_read() - Read only this open file's firmware response
> + * @file: Open TAC endpoint.
> + * @buffer: Userspace destination.
> + * @count: Maximum number of bytes to return.
> + * @ppos: Unused; the response position is protected by state->lock.
> + *
> + * Responses contain little-endian u32 DataSize followed by Data. 
> Partial
> + * reads advance the response position. Consuming the result erases its
> + * storage immediately; subsequent reads return EOF until another 
> write.
> + *
> + * Return: Bytes read, 0 at EOF or for zero @count, or a negative 
> error code.
> + */
> +static ssize_t lwmi_tac_read(struct file *file, char __user *buffer,
> +			     size_t count, loff_t *ppos)
> +{
> +	struct lwmi_tac_file *state = file->private_data;
> +	ssize_t ret;
> +
> +	if (!count)
> +		return 0;
> +	ret = mutex_lock_interruptible(&state->lock);
> +	if (ret)
> +		return ret;
> +	ret = mutex_lock_interruptible(&lwmi_tac_lock);
> +	if (ret)
> +		goto unlock;
> +	if (!state->tac->wdev)
> +		ret = -ENODEV;
> +	mutex_unlock(&lwmi_tac_lock);
> +	if (ret) {
> +		kfree_sensitive(state->result);
> +		state->result = NULL;
> +		goto unlock;
> +	}
> +	if (!state->completed) {
> +		ret = -ENODATA;
> +		goto unlock;
> +	}
> +	if (!state->result)
> +		goto unlock;
> +	ret = simple_read_from_buffer(buffer, count, &state->position,
> +				      state->result, state->result_len);
> +	if (state->position == (loff_t)state->result_len) {
> +		kfree_sensitive(state->result);
> +		state->result = NULL;
> +	}
> +unlock:
> +	mutex_unlock(&state->lock);
> +	return ret;
> +}
> +
> +static const struct file_operations lwmi_tac_fops = {
> +	.owner = THIS_MODULE,
> +	.open = lwmi_tac_open,
> +	.release = lwmi_tac_release,
> +	.read = lwmi_tac_read,
> +	.write = lwmi_tac_write,
> +};
> +
> +/**
> + * lwmi_tac_remove() - Unregister an endpoint and block further 
> firmware calls
> + * @data: Endpoint registered as a device-managed cleanup action.
> + *
> + * Stop new opens before waiting for an in-flight call pair. Existing 
> files
> + * retain the endpoint state, but their subsequent reads/writes return 
> -ENODEV.
> + */
> +static void lwmi_tac_remove(void *data)
> +{
> +	struct lwmi_tac *tac = data;
> +
> +	misc_deregister(&tac->misc);
> +	mutex_lock(&lwmi_tac_lock);
> +	tac->wdev = NULL;
> +	mutex_unlock(&lwmi_tac_lock);
> +	kref_put(&tac->ref, lwmi_tac_free);
> +}
> +
> +/**
> + * lwmi_tac_add() - Register TAC endpoints independently of capability 
> data
> + * @wdev: Bound Lenovo Other Mode WMI device.
> + *
> + * No capability describes method 99, so registration does not probe 
> firmware
> + * support. Each firmware instance gets an endpoint; unsupported 
> method calls
> + * are reported to userspace when requested.
> + *
> + * Return: 0 on success, or a negative error code. Device-managed 
> cleanup
> + * unregisters earlier endpoints if a later registration or probe step 
> fails.
> + */
> +static int lwmi_tac_add(struct wmi_device *wdev)
> +{
> +	unsigned int instances = wmidev_instance_count(wdev);
> +	int ret;
> +
> +	for (unsigned int instance = 0; instance < instances; instance++) {
> +		struct lwmi_tac *tac;
> +
> +		tac = kzalloc_obj(*tac);
> +		if (!tac)
> +			return -ENOMEM;
> +		ret = ida_alloc(&lwmi_tac_ida, GFP_KERNEL);
> +		if (ret < 0) {
> +			kfree(tac);
> +			return ret;
> +		}
> +		tac->id = ret;
> +		kref_init(&tac->ref);
> +		tac->wdev = wdev;
> +		tac->instance = instance;
> +		tac->misc.minor = MISC_DYNAMIC_MINOR;
> +		tac->misc.name = kasprintf(GFP_KERNEL, "tac%d", tac->id);
> +		tac->misc.fops = &lwmi_tac_fops;
> +		tac->misc.parent = &wdev->dev;
> +		tac->misc.mode = 0600;
> +		if (!tac->misc.name) {
> +			kref_put(&tac->ref, lwmi_tac_free);
> +			return -ENOMEM;
> +		}
> +		ret = misc_register(&tac->misc);
> +		if (ret) {
> +			kref_put(&tac->ref, lwmi_tac_free);
> +			return ret;
> +		}
> +		/* Unregister before the WMI device and its managed state disappear. 
> */
> +		ret = devm_add_action_or_reset(&wdev->dev, lwmi_tac_remove, tac);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
>  /* ======== Self (master: lenovo-wmi-other) ======== */
> 
>  /**
> @@ -1693,6 +2013,7 @@ static int lwmi_other_probe(struct wmi_device 
> *wdev, const void *context)
>  {
>  	struct component_match *master_match = NULL;
>  	struct lwmi_om_priv *priv;
> +	int ret;
> 
>  	priv = devm_kzalloc_obj(&wdev->dev, *priv);
>  	if (!priv)
> @@ -1708,6 +2029,10 @@ static int lwmi_other_probe(struct wmi_device 
> *wdev, const void *context)
>  	if (IS_ERR(master_match))
>  		return PTR_ERR(master_match);
> 
> +	ret = lwmi_tac_add(wdev);
> +	if (ret)
> +		return ret;
> +
>  	return component_master_add_with_match(&wdev->dev, &lwmi_om_master_ops,
>  					       master_match);
>  }
>
> base-commit: 5680519168f65666d2c03cc6ed8fe2b7052aee12
> -- 
> 2.53.0

Are you working within Lenovo? I looked up what this method does and details in the spec I have are very limited, but I was wondering if you're working on one of the new products?

If so, please ping me on my work address. You should be able to look me (Mark Pearson) up - or reach out to the Linux preload team. I think it would be good to discuss what is being done here.

If you're not from within Lenovo please let me know how/why you're using this interface. I would rather go and discuss with the FW team to confirm what is being exposed first, before we enable it blindly.

Thanks
Mark
