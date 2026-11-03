Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701849;
	b=JzfesJ3lhdrsYL6iMJaOf5Zk+euH/laf8pW5dwHFR5/R7B37zgcDjOHGd9LQMA2oXGtj
	 pYKepYsfGojnyAdtPNtXMqEElny30rgfIXZveVsliRdk0VzvPlrMKCSievO/jJUrZRd4C
	 HexIc3PvJzEFJN/TslshNVce1tNvgLA2oUMqhHv0dIWr0C4to495Kh26xW/68/dZRp7io
	 KALZa2i1O5zXpgtle5eWOKe94Y5yQcW5CL353DIur13Iyf2JRc9HRkxWDWR9aOSsGF9Le
	 QxFDmfKLHGd2DCedACYJvhjTPzcdB2oHrZFyp1h57GmOP6VLvzhxNKUA2NrxsMkD2EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701849;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=rUKedcpVkiNEfx49bKB2qoAIuRwcwKKFeuE1z3r00s0=;
	b=xBsUgFMnyzr0EGPp4GhMXzrDMrH0/Ti1yAJFKNyjaoqhmzifw88/Ey15OUdqwNBJAiwf
	 oaxDf0gq82BbwS5zeZ+/xgti4dEEPN0/huffvLUK9gswkb7ZQsJedfa9wgsQFtKVelTDz
	 a58qqDpBGMrj381qJp1RxrMyf8P4jqyztloXSCK2uf8CxbsxG7ulmW68G8Xmc95s9fdvp
	 4FpWd7Pc8z1hS87QL5GAjan+gauMVeje6kFXbJjJa5omZWsLW4k+NA9gfwUGuMfHS2V8x
	 C8MxyAvt9oOLGVH996GkijMIq7BziJYDKjoPDVxL0s1ct9E6kphSilVomDnXmLfA3ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="lGHJ2/7A";
	arc=none smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A27606A33E
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 10:30:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07A27606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=lGHJ2/7A
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bfc346401aso2871450e87.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 02:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793701846; x=1794306646; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rUKedcpVkiNEfx49bKB2qoAIuRwcwKKFeuE1z3r00s0=;
        b=lGHJ2/7A+c8PAoafyItHPUKePCeXbliM9fGrD5xJcz3JpBqpvmtWUxQjud4v3HS62O
         o56E7Kb9SRzktK6NhMfa+6ZtWZSbmJt5LWEKR7WrQ7rUzzjWF1A7JanQ/LBl9m+BcH5b
         Hzj2p5p+gNiDVEYaUnNESbOXtEC6L+gDN07LWsuh2VkoM20HAjPss5X+ikBTBh7+8MSb
         fRowcjM7MMC/xob+HTP4ofXA99I7jUj/tlGctRB3e4cl8CR6CwYX4+wvJ9ZFiDNJ6clq
         hOUOuJC6Bn7TKlqDLYFX4IfP9cuODLqnkxgxEbNnyzV5lAWIst7n/Yu3jEY4/fh8qwN6
         4tdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701846; x=1794306646;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rUKedcpVkiNEfx49bKB2qoAIuRwcwKKFeuE1z3r00s0=;
        b=klLxo/0DwxyyJBXKGIdEkdzSS7xv1wEs9hOZaP2qWmFefuhfVnaoUJnUUauA5r/JF8
         k7T8nJwnVoVHZeWHyVCH80V92qDsCyJLo15K9vC0/F18TydEFHSnaXxAN6LvbQY91QK2
         SZWGB9/OpHBJfFrDtqQ5b4GKqb6ApmF9fg1kHLl5bIlQ9XULkDf8xH2fecHEGnEXEA06
         +f7KSKCltl9Dv0BJhEOKQ5n1HpOVG+NDiPm+VEZ9QN5MTNvd4FpWOMxBaFH+JwXTDDAB
         PfCVF2Fsyi0+Ibecc4PRosNXpM13Dhe5OKgT274mtMoM3Nyhi6345Voh4s7CqnaexezK
         MzwA==
X-Forwarded-Encrypted: i=1; AKwUvByteFLrilXHyHj1ecqj40o8hxA91fYIVybDJeqMS0M7iKy3eC+IKE/7OGN94ZbZNlk2GHH8wMDEvwE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/wV7wgjVVemOfauksfAreob70y5RjcHEua6CRddv9fsWWDPT+u
	jkI4Fk2sJo445C4K6W8FrdpuERPfrsL6bVynviqO8YQ25ZmpsEiwCZvTL0LrK7IiJtE=
X-Gm-Gg: AYBFou364ZIqsL2Fhb0Pj3sjrcJgZenIlqjd6KSdIt+9Prd10Y3u7v0TVydhBzJND03
	UAf+lmDrd3amINwzCCZK7heeZnWLOS58haQkczccE46BJ4hPAxKCGqnYOYIt3CjyNYd6yk/Qil8
	nTv4KRXV8+BGlQ/p9uwDiUCoQfEbslRK3eZdB3fuKIWRvlqCJC6OxQl7ppmJ1/9asExyG4kz2SP
	MBTKcj+v6PBYKC5RoIfJcDd0TpIRKx/tZesbaheCJT5mtIYHjBXudJKJpS22CkQ/xWT1xztOFMi
	gMDa/alzgjHgnrpb+Sdt1mbQCUtios/Vi0WaPel1ZytF28359n7rZE3eqk4cxYiUSeri11vhhpn
	nk4i7brpJqCdDuRUXm3gHdirQZBGSY63HoF7Clxli+lv2Gv8RKZPXNCvDvq7CvPE3t0U9EHbPUU
	hmzcir/SuZ9eJpehaRwJKy3MB4FhfFPqGDlOpe8HaQl5P0Sy0tXShXcfl+76jgcJ9AYA7DNChEX
	f8Uyni1LUzvbdWR+hZnI0HjBO8JqdF74i7mUosAlII1HNfnjSJM8jjBzs088joyzzdt34Ba3D/0
	EI9uSRMc82LQtfNa2OXATif94XerC4WtTWJu
X-Received: by 2002:a05:6512:3da9:b0:5be:41a1:d2c3 with SMTP id 2adb3069b0e04-5bfd958d569mr4093510e87.49.1793701845873;
        Tue, 03 Nov 2026 02:30:45 -0800 (PST)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe074aad9sm2132213e87.75.2026.11.03.02.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:30:45 -0800 (PST)
Date: Tue, 3 Nov 2026 11:30:39 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Sergii Dmytruk <sergii.dmytruk@3mdeb.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 04/20] Documentation: ctlv: Add userspace ABI
Message-ID: <aum3xbO4lbiBWUtL@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-5-jiri@resnulli.us>
 <auOWFzX5N7HBbcH3@MjU3Nj>
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
In-Reply-To: <auOWFzX5N7HBbcH3@MjU3Nj>

Thu, Oct 29, 2026 at 07:53:11PM +0100, sergii.dmytruk@3mdeb.com wrote:
>On Thu, Oct 15, 2026 at 04:50:37PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>>
>> Describe the CTLV transport, discovery, wire format and userspace
>> compatibility rules.
>>
>> Assisted-by: Cursor: GPT-5.6 Sol
>> Assisted-by: Cursor: Claude Opus 5.5
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  Documentation/userspace-api/ctlv.rst  | 507 ++++++++++++++++++++++++++
>>  Documentation/userspace-api/index.rst |   1 +
>>  MAINTAINERS                           |   1 +
>>  3 files changed, 509 insertions(+)
>>  create mode 100644 Documentation/userspace-api/ctlv.rst
>>
>> diff --git a/Documentation/userspace-api/ctlv.rst b/Documentation/userspace-api/ctlv.rst
>> new file mode 100644
>> index 000000000000..5ebca3d4d94a
>> --- /dev/null
>> +++ b/Documentation/userspace-api/ctlv.rst
>
>[...]
>
>> +Errors
>> +------
>> +
>> +A failed operation returns a negative errno. Where the failure is a rule the
>> +message broke and the caller offered a reply buffer, CTLV also writes
>> +error information there in TLV form: a ``validation-reason`` value, a
>> +human-readable message, the offset of the offending attribute, the offset of
>> +the nest it was in, the ID of a missing attribute, and for a stale query the
>> +expected and the current generation. A buffer too small leaves it unwritten;
>> +the errno is authoritative either way.
>> +
>> +What the transport answers with, as against a family's own callback:
>
>It seems like this mixes results of several syscalls (e.g., `open()` and
>`ioctl()`).  Does it?

Right, will split.


>
>> +
>> +``ENOTTY``
>> +    Not ``CTLV_IOC_OP_EXEC``; this transport has one ioctl.
>> +
>> +``EINVAL``
>> +    A reserved field was not zero, ``op_id`` was zero, ``generation`` or
>> +    ``cursor`` was set on something that is not a query, or the message broke
>> +    a rule of the format or of the schema.
>> +
>> +``EFAULT``
>> +    The structure, the request or the reply was not accessible.
>> +
>> +``EOPNOTSUPP``
>> +    The device does not publish the operation, publishes it but has it
>> +    disabled, or the operation is an event, which is read rather than executed.
>> +
>> +``EACCES``
>> +    The fd lacks the operation's declared authority, or an ``O_WRONLY`` open
>> +    was attempted.
>> +
>> +``EMSGSIZE``
>> +    ``reply_len`` is smaller than the smallest fragment the operation can
>> +    answer with. Nothing was executed.
>> +
>> +``ESTALE``
>> +    A continuation whose ``generation`` no longer matches. Start the query
>> +    again.
>> +
>> +``ENODEV``
>> +    The device was unregistered. Descriptors stay open and every operation on
>> +    them fails this way.
>> +
>> +``EBADF``, ``EIO``
>> +    A blob descriptor named something that is not a file, or the file refused
>> +    the transfer.
>> +
>> +``ENOMEM``
>> +    The kernel could not allocate what the operation needed.
>> +
>> +``read()`` answers ``EAGAIN`` when no record is queued on a non-blocking
>> +description, ``EINTR`` when a blocking read was interrupted, ``EMSGSIZE`` when
>> +the buffer cannot hold the record at the head of the queue, and ``ENODEV``
>> +once a removed device's queue has been drained.
>
>[...]
