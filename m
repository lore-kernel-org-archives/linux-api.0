Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.105.50.107
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793300002;
	b=pywJINc2bgeJ5vz5qexKJU4F2CTDmuQG5ok2gZWzgt2BWEgqfIivg/Seu/0+cxfOYWzX
	 os+ocQfC5iCjXxJW7kJJO2lhNpitw56vvQ85mp26qoV6QwOqmyT5Kb5KB+X8Za44dAh22
	 HorI6qj82GdEqkHfK9bn6rWEVX3z70Yd8JnbqW3NTc1Jkmymw9JmFWfCr2oCG41OqGcx/
	 JaOmi/puE1n2SWTluImegWm5vBZNbTjItAM/2iN3II1M0k00cjls92hx889tbQTxjRz8K
	 zWOyZDTQsK0A5/CO0G2o5JrEaYOmcKB8Z/M9upvtCq6xMsaOkk6Q5E3Tm+gq2lJ9Rdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793300002;
	h=DMARC-Filter:Received:Received:Received:X-OVh-ClientIp:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:x-ovh-tracer-id:X-VR-SPAMSTATE:
	 X-VR-SPAMSCORE:X-VR-SPAMCAUSE:DKIM-Signature;
	bh=yhrtAoUmb1ba6pgSshpme+NeuozvjU6Nr2zb8FJ6bno=;
	b=POHEGQ1KA9ABTGe+MXx8zN6JcwvVcVXiTDA3R4DVDjHpTlVpUKf/PlZpoCbfWJ0bO2wx
	 UDZEyGkHtSyF677Nj6syxdpJXT4569en8ji0aSFN3brNnlyKeeP9vq2R1Q6fQ2jKoATIx
	 dezonTr7Qi+8KjyD2FnNNAckqVO1Ykp9PCsTZrdAijPCJh+RyFmmUXdU1m+CE9tqt/Qvp
	 Df5rdRzHEvVTzsR4N8Gmy4msIQFVglmD55nwBOOuNy0iYP4nQSsG23LC5IlMXan3UTwoh
	 WcPbCkt7LMYSW6NlmIXssYkdAfxQo3+17xxEe+1zhMugffq8VJZEx2WIduZnsTUybZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=3mdeb.com;
	spf=pass smtp.mailfrom=3mdeb.com;
	dkim=pass header.d=3mdeb.com header.i=@3mdeb.com header.a=rsa-sha256 header.s=ovhmo3617313-selector1 header.b=m8s+fdBI;
	arc=none smtp.remote-ip=46.105.50.107
Received: from 6.mo576.mail-out.ovh.net (6.mo576.mail-out.ovh.net [46.105.50.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECFC606A323
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 18:53:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ECFC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=3mdeb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=3mdeb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=3mdeb.com header.i=@3mdeb.com header.a=rsa-sha256 header.s=ovhmo3617313-selector1 header.b=m8s+fdBI
Received: from director4.ghost.mail-out.ovh.net (unknown [10.109.231.5])
	by mo576.mail-out.ovh.net (Postfix) with ESMTP id 4jFtfM4QN0z5vyJ
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 18:53:15 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-zwq2g (unknown [10.111.174.98])
	by director4.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 1772CC21F8;
	Thu, 29 Oct 2026 18:53:11 +0000 (UTC)
Received: from 3mdeb.com ([37.59.142.109])
	by ghost-submission-7ccd8bbbb6-zwq2g with ESMTPSA
	id X7pGMReW42oUfhwAcildmA
	(envelope-from <sergii.dmytruk@3mdeb.com>); Thu, 29 Oct 2026 18:53:11 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-109S0032d2b680c-5f01-4095-bf1b-8325b6a5fbb6,
                    80E54DDF43994B3DD4677030DFD12DA1D43C0C90) smtp.auth=sergii.dmytruk@3mdeb.com
X-OVh-ClientIp:176.111.182.218
Date: Thu, 29 Oct 2026 20:53:11 +0200
From: Sergii Dmytruk <sergii.dmytruk@3mdeb.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@HansenPartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 04/20] Documentation: ctlv: Add userspace ABI
Message-ID: <auOWFzX5N7HBbcH3@MjU3Nj>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-5-jiri@resnulli.us>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015145053.3664509-5-jiri@resnulli.us>
x-ovh-tracer-id: 10816238932508026193
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTFRGI1yaOcyDfLgNXjfMxwmupW2IW64ehzRIoHhqwLBlPIe0jAgyJB0LlqKu0wtkov5oTsfOtxqVTrvMp41g1IW4164qf3YzjiVMHIil3j9rRAWoNXx3GiQVReQC9kv4gSz1+UST8GFYnYUTcgZllXIwzyufvQL6rB4SnBRobHyvpxxp4dydBi/G8rhr8eTNISs6C4cfrkUVgVh7QKeICXeIwY/NFnauWbK7VIpUUiWDXk+YLgM8Xrc0YK6W+iMtkXMPrXLTTZNhDWHz5rTmMOLTH9a6noJ9yg9Av2enhV1YX1pjSh9SByPSMh2zOloOHaeU/23sH8dlgGVpp2yd+qdCaIUecu+GSVPgaiiaTXiehtOgnol/EoZXwLePR5UdIimdVYZb5Qw+AcAu+2J0BBPVoTDcM4s2p29HGv6yy4mIVWBMlvGFlyAG4aj3ruPUwlaE+0+mh2/ukZ7wFNm1sku5TQVNR7HekrGgJrKzmjGBvU3ehz+DRKLrZESgZQJvLco4t0qtdclxELox8oMIiInthotUOCqgUmbWPmg/m4avTiVBPBURxk/L5uNgMfpe5AykF3Hem0IlU2wb3CPxiTEhNmOMNtESfimASgjnyCbzJAr+PRkwq1tC3pciUiMMtjL4AnYax81+MXYx4nXeiJ7TMQYzlT0IxqUdSebWqIxUQ
DKIM-Signature: a=rsa-sha256; bh=yhrtAoUmb1ba6pgSshpme+NeuozvjU6Nr2zb8FJ6bno=;
 c=relaxed/relaxed; d=3mdeb.com; h=From; s=ovhmo3617313-selector1;
 t=1793299995; v=1;
 b=m8s+fdBIL36ZAq008qBhqVz6RAHTHjlxNuQvwTcsNQlaE4Mtdv5HHoQW3qYXaHAGelZoqqDZ
 wuuSMUt0E7NFN1CiFV6+9Vh8s1iBHc1iVKFt2DIPaWlPJwo87MVwa6dh5F/YrWdGXOgdl+Af9lQ
 MwjUX7MhDUJRVXqprkwtKnRdRcqKELnJHjX6+CjhJ+s+jg1248O9/NsO72HDCmSBV2rg/dzRvuu
 W01X8YCRBGS8H+UEXtkKdL4CpYquFzR8HjASzSqNF2yzWuSNikI1oIUPXvVN+acwbjCuyW1vtgT
 PXQp0BFNgruNTNuLw5E/+1aKByLuIrenexkQlHKf3fTmQ==

On Thu, Oct 15, 2026 at 04:50:37PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
>
> Describe the CTLV transport, discovery, wire format and userspace
> compatibility rules.
>
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  Documentation/userspace-api/ctlv.rst  | 507 ++++++++++++++++++++++++++
>  Documentation/userspace-api/index.rst |   1 +
>  MAINTAINERS                           |   1 +
>  3 files changed, 509 insertions(+)
>  create mode 100644 Documentation/userspace-api/ctlv.rst
>
> diff --git a/Documentation/userspace-api/ctlv.rst b/Documentation/userspace-api/ctlv.rst
> new file mode 100644
> index 000000000000..5ebca3d4d94a
> --- /dev/null
> +++ b/Documentation/userspace-api/ctlv.rst

[...]

> +Errors
> +------
> +
> +A failed operation returns a negative errno. Where the failure is a rule the
> +message broke and the caller offered a reply buffer, CTLV also writes
> +error information there in TLV form: a ``validation-reason`` value, a
> +human-readable message, the offset of the offending attribute, the offset of
> +the nest it was in, the ID of a missing attribute, and for a stale query the
> +expected and the current generation. A buffer too small leaves it unwritten;
> +the errno is authoritative either way.
> +
> +What the transport answers with, as against a family's own callback:

It seems like this mixes results of several syscalls (e.g., `open()` and
`ioctl()`).  Does it?

> +
> +``ENOTTY``
> +    Not ``CTLV_IOC_OP_EXEC``; this transport has one ioctl.
> +
> +``EINVAL``
> +    A reserved field was not zero, ``op_id`` was zero, ``generation`` or
> +    ``cursor`` was set on something that is not a query, or the message broke
> +    a rule of the format or of the schema.
> +
> +``EFAULT``
> +    The structure, the request or the reply was not accessible.
> +
> +``EOPNOTSUPP``
> +    The device does not publish the operation, publishes it but has it
> +    disabled, or the operation is an event, which is read rather than executed.
> +
> +``EACCES``
> +    The fd lacks the operation's declared authority, or an ``O_WRONLY`` open
> +    was attempted.
> +
> +``EMSGSIZE``
> +    ``reply_len`` is smaller than the smallest fragment the operation can
> +    answer with. Nothing was executed.
> +
> +``ESTALE``
> +    A continuation whose ``generation`` no longer matches. Start the query
> +    again.
> +
> +``ENODEV``
> +    The device was unregistered. Descriptors stay open and every operation on
> +    them fails this way.
> +
> +``EBADF``, ``EIO``
> +    A blob descriptor named something that is not a file, or the file refused
> +    the transfer.
> +
> +``ENOMEM``
> +    The kernel could not allocate what the operation needed.
> +
> +``read()`` answers ``EAGAIN`` when no record is queued on a non-blocking
> +description, ``EINTR`` when a blocking read was interrupted, ``EMSGSIZE`` when
> +the buffer cannot hold the record at the head of the queue, and ``ENODEV``
> +once a removed device's queue has been drained.

[...]
