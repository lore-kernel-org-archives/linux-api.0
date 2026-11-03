Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698199;
	b=414S8llAcjmaelY9auXrH7OS9IUvgV2BRMYy+f3ZGl2uDjbuOGNPQBux7UlGsHBNq1/7
	 R5PXkK0X2BQUqH9hQuuukLDXkx4UzfnIxe25fqCxblT6+gl6KMBkEhGdX0y3146oziPPY
	 F/sQ12irr5g9j2ulZQ75evj8PV4XRm0DOexCQOwdWap+3fcOiiiOK54hEXqtk8DIo0J/j
	 8rhi70/DhSGjXmguCnWIHxwXnAK9H8hHoJpcY0F5UAQtcDWvGMq8vGR5tWEwc5pIaEbVu
	 H9eXhS/UEr+zEeBLoMLL7iayMGDI421FlV3H7jO/+ArVVF0tZ02mNPkZW6RO/UagZ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698199;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=CkFM9E5nfWdnLbDGQzZA+rThnrcRob04z1+EqW99MTE=;
	b=3Iwy318R/TxFn40hWdt1b8xXtwAEHtHXw3MMF15lJ3a1Y+uhdDdwo99CIK34bdqnI07f
	 Q0OY5YJ/H1SpruoAUGarWfUO+Z4XDER7Z0B98YkiTZhFgnL9HFZ2OSQG2RnRUMtzGqf3P
	 Gj3xSffyMG7Qm1jQfuXHepAOQMp7bHDw4B9K1JnpjGszqrwNSfY5n1IRXnGGCNVF6QD2g
	 mYa50jMLc8KCUn6vTAw/lJ/7mVt+sXDBU6MOMcZwPyqPUFtE/Go6ptkHOQuI3PLyTFSJm
	 t9mEBhDLvJ6aMD0Phe/TgRCXzbF+Az8JCshYZi0Qp13ocnMUO9DINNIZWWglbnioNZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C01606A32D
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 09:29:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22C01606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so4040787f8f.1
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 01:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793698191; x=1794302991; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CkFM9E5nfWdnLbDGQzZA+rThnrcRob04z1+EqW99MTE=;
        b=nD17MX4VzW88+nrnz9SgdcaYPQcOIkfh/S0yrXnMfUgiGGl0fkKSlltWyjDbQPyYMJ
         eyJkJVCpvVbC4gP0OT8sEk1TVUj+BlCLU49pQgURFggfuzWLnbpspFwvtmXmiSM7p97k
         Avk1+QdCZOKyymL8Xg/4fiDOAl4JzMdXU+h4yuR2KLxssHGZ1M6W1XKjWStlpIxt+gQG
         EFvhWnv2HNS5oUqS9tj0RFT7ennBps/r5yNAsEvJLGB++paTLGgKMOvxgHjaZHrL2mF/
         ShzDEeNLBnaPa9J3paZGOvdsYyNmHo4uMXZnKOLeuiZJYrrkShVMAtnqhblAA5vTMEZM
         xpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793698191; x=1794302991;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CkFM9E5nfWdnLbDGQzZA+rThnrcRob04z1+EqW99MTE=;
        b=nC0yjNPLtjoPQ8dUpfJt6vefI9v9clxcIoNQy52lFm+xS9M6dMPMA2hpVf08Qjm6ef
         482GBtx4z3TDPkTr9Uf49Fc0RTc+mXYxp1AxO0fSYdM8jgrvt278NAU/i2f2V9U1vnTF
         oAmaEMRgWT6xnZ78l3aiQWkTE5Hd7ffRMeA99toYg0gOuYJod1lTfWuhMNBIireTiuYI
         oG8LEXga8DMucUJqohGkk4cDgNG1eSTCxiHKTs+4thaLkKEsah5rtH4GvoFABdL9br4u
         i2VYkbe87bC55tPWnw36ZSxnzN+ZpUHas9UWjs+pYAo7vYOl9gnXOSC7cGZm71d/jGlg
         0UBg==
X-Forwarded-Encrypted: i=1; AKwUvBwyImXHb0YPqgAzkTusQfh7eYXdwz1l1/c3v0a3r+7Pu5WS/f68znd6k7sdMiTmwfnET0ykScK4Qiw=@vger.kernel.org
X-Gm-Message-State: APuU4Z8FVQa2z9kNnMXIgI83w1xnQIBUfOdbuMZoWdBhso1c68MR643/
	Nx5IA1bbACEnVIf1/qR5Hzq3+XMzzNSXmk9LMU7D4CiruZ3hvkB1hbrvKa1wbIcIBTY=
X-Gm-Gg: AYBFou2JU6f/UKYAp/1fi0JktaM6TRDGti4pxMfkUSjw57ya4C2KpjMXYS6xRN4br2+
	ORuHCUbA7d+shU5ldSt9/ODea5oBMdcTBzImog4KFrcYR75HpavtQOmiQrrZ+CXAuSxwkdlr/nv
	2ss3iXal8wXP30gY60zUczm8Vp0F5zKZ55XrtnXjFaiKpQQc8oETKCEAmwi9bDcK52XTBriMQ6I
	8XXFYmPZGXqBtT6PaGgJGRIheOjK4imy9cho5RsqP5D3VXXyQ5K1jJb0xjfMqy20JacEZnPuTXR
	w/4jEjctDkhKkSb/pRJjKL7ugV+Kt6iy2YcY/1gZc0busopOAxTQ/AeMadvzKy9p2xlYyRN93fF
	SHqTr2/wfY3WbHVBt6trbuDVfDGd0Pa0ipqbIxYenpknCcOKqIJi/TX615UTWDNCZpW377nkZe4
	wkarv8a3qzLxPeMTSZtfui+XbBIWlpToxsvRwdErAMdhZrFbAyxq+GDYNejCsmTYmfn2NWhP1Bk
	Me0LZWngjWsVheqYEpeEYEKKj+P1aVRYhYMz5X6UlAU8SwMbHqOv71X2tZLHoltWPJMVNq+jqm5
	UUmH5LHT2sILtSjv/S0ARIQ81UdczWPJmvM2
X-Received: by 2002:a05:6000:26c1:b0:48e:870:7791 with SMTP id ffacd0b85a97d-48e6e30b824mr25816174f8f.26.1793698190820;
        Tue, 03 Nov 2026 01:29:50 -0800 (PST)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80eb1sm25441683f8f.34.2026.11.03.01.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:29:50 -0800 (PST)
Date: Tue, 3 Nov 2026 10:29:45 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 11/20] ctlv: Prepare runtime introspection
Message-ID: <aumogVKtYnY0QJ2r@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-12-jiri@resnulli.us>
 <179302367452.58760.11808905856343064399.b4-review@b4>
 <auRmMPfaFINUIchi@FV6GYCPJ69>
 <20261103010537.GI3889730@ziepe.ca>
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
In-Reply-To: <20261103010537.GI3889730@ziepe.ca>

Tue, Nov 03, 2026 at 02:05:37AM +0100, jgg@ziepe.ca wrote:
>On Fri, Oct 30, 2026 at 10:53:11AM +0100, Jiri Pirko wrote:
>> >So.. how about could we drop the sets, use a direct description of the
>> >layout and do something else for the ID numbering? Maybe the numbering
>> >can be solved directly by only listing the names in:
>> >
>> >numbering:
>> >  - device-get.reply
>> >  - device-get.reply.caps
>> >  - device-get.caps.evidence
>> >  -[..]
>> >
>> >?
>> 
>> I'm still committed to implicit numbering. For "inline records" I
>> resolved it by having it encoded as a tree with 4 levels:
>> 
>>  63         48 47 46 45        32 31  28 27  24 23  20 19  16 15               0
>> +-------------+-----+------------+------+------+------+------+------------------+
>> |   family    |kind |   index    |  L1  |  L2  |  L3  |  L4  |      field       |
>> +-------------+-----+------------+------+------+------+------+------------------+
>>               |<------------------ record ------------------>|
>
>Fascinating idea. Sort of like an oid
>
>I guarentee we will run out of bits someday :) I saw recently we ran
>out of bits in RDMA :\ 3 bits seems like quite a small number..

Well, this is just for inlines. I think if user comes to the point this
will not be enough, he can use named record, as he probably should with
more than 8 inline records anyway :) Also, we can introduce "mapping"
mechanism to allow inline conversion to named record without breaking
userspace. I just didn't bother to implement now as it is a theoretical
problem now as I see it.


>
>Maybe increasing op to 128 bits?
>
>Maybe family/kind/index/field spread over the first 64 and then the
>Lx's over the second?
>
>At the very least there should be an escape hatch so that if this
>becomes too small there is a way to opt into some new layout and fix
>it without breaking everything.
>
>Jason
