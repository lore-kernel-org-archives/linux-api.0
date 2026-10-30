Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372580;
	b=qO4HS6gQy69/kQG+enifvD1Iahtlgn4v9Fo3Ut0q4lzvF8nfvoXul0JmgvXZll6Lt7SD
	 +bNirM8QnVNlwhm6WwMrma+0KGYyOX9GGqyTVvHuLkB4wKn1ogG5oD/IX0oUbMJ0/Rvy2
	 TJ/rf9PhJZvwl+/aKr6A+mUWtOl28Ge5n+PDzDG5izKNcf3OIvQ8Ei5quC1IUsspTm8wy
	 gqsOSNQUUS/4WeXzRokRH2EqaTUQ5qOwmuOgHC/BN1FR5HYtarjBMGQhm0law9fVy2SCI
	 zSpGSBe5VIYc1iYD8ppmRseWSdFzZwo6VZ22q3QAlD/AVL8SvdBfTGZD4yJbfTLpNQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372580;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=LD3FTctKH+htDtI40/USwM/+YwDf042Qy6l0BgbuGzY=;
	b=05muC9mvGHuE5Px65VvXMw58LBWF9he1AW5mNaTQimvkZKxzxIzdy41F+3pQsIqWONZP
	 /9Ea02jzdYj4EvwqzGfFAWK/c5EInmT8PzEA0oWhG3ZAKJhg3qvcHBRLdUAUiEJ0hQEFF
	 CHCvvG6sprA3N7izd8B5oqS8SgI8H0crttLqh8/xgONCKlgJiHniPHDZ57ZW8/D/4oMRk
	 Z3hshd7Wc1L/NMelgoSW+0EqXLgZB+zxu05JnGprSbla+1HZuAv+XC6n8jIE8M4BzUAAI
	 6EEZRzJAkm/9qNoFYwCTj7C+ASDACcdEuqauPHHfmU7Azzj/M274anIUm+1AwGlhFmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=wwfcN5xh;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88A8606A31F
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 15:02:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C88A8606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=wwfcN5xh
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so6262755e9.0
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 08:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793372577; x=1793977377; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LD3FTctKH+htDtI40/USwM/+YwDf042Qy6l0BgbuGzY=;
        b=wwfcN5xhJxmJIEs/AzLSOKGoZTkD6+8NGP2qYbyNFhJ3ZePhPC12lXgsmIHSzpBzcO
         71d0fBrr1/B0EVWRwTU4JSXXvJ/Wr1eHyWOr6vbvgmdkDIWvglRqf4i9q++G0XE3NJ8i
         S2xNR+q8cf0+NqHemf9xQpAofRPyggoeqvaCmnZTKQtViK6XnkkmWIqV5NXQQ7TxzVF2
         ZZ0TVZcs3kkfzqhYZ3v4MGg348nCq3l3bT/bwopwha2MLL2cYn1f5N9xcPZtRK96BFm0
         9J6dNo27JRTdybTsDSGt55KhTK18zZR2Ab+2mEsVjSiKfFzKHINGh8jYyPI2Ol1FvCLG
         s7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793372577; x=1793977377;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LD3FTctKH+htDtI40/USwM/+YwDf042Qy6l0BgbuGzY=;
        b=CKN+8JzVcXy18mUk23ENGTvS6AwemGCz4w7OOT/2RtEzh9R8yeTGJz5LI/E+FkvFDA
         OIiW6UPIDPDOzZagTcmFBpP1gLbQpd5Q2tC86eRz5I97Hl6maiDu5+96waW2iF4jXGTD
         EXwXvanxGOhlUXQkXt57YVqPFJ1omu5IMg7UDsZlLjA+3xbtxxu6sKHSTO1cCpnPJ0Bb
         OuuxocC6yEGPqJRSvqitzNLAtqCEv3RIxh7CUtwckZwxajWy5VGxY4DkMyoXDE5lFUON
         zRr9hDILiQEc1DWV4sbCnfIVlp1Wc5ZDKPvmZACEFVuUxw0lWWffIz5tcygc+ZyZm26A
         8gBg==
X-Forwarded-Encrypted: i=1; AKwUvBythkDnMeZ0IA5cUt9XYRcv+OYAW9wtaYf458xk875bvIfewJceOtWdtlKi76pGmUfEK2q6VxmvWtM=@vger.kernel.org
X-Gm-Message-State: AFq9FYKfYNoBGFVU+1kksREd5hwXkezGg4SNPkMahS3m+lMnN7D8Ufcq
	lZOTm7A4Td+kWLrJsDC009/XIxguTvDGpRRaU+j657Ad5bbcqjyyWRcX/9V+cvbcZEY=
X-Gm-Gg: AYBFou2s7k39VNZkNQRUYL2rA3nYQB5opo0Bu5Oz1DdNN/Qxv4wJMUYq3cCmqy7ouX4
	7odSsp63i3qG22OVVCtA+RyxMT2ypjSlkrj/CpqfSYvX3hWtuQzKiuwm8DCbT2iK2faqgbtumoB
	TNaqJcP02zBji/3z7tdzWxvsTCPlIqN348jC7yJQHyyPGzB752YtKlwLsf2umz55O+9Aq/HqFVf
	RCeiWf6ffA/eAAhab0xoVtwFYMJTXIFqT4SEvUIj/aLPz6ZKnj7XOT9+XV9u/qfUdmZSXlZIcRd
	soCTLzcbnWYb5ZnwXV1zao+iEVr2AkiAHDtobU7j+TCy7rXWeAt9c+wa/Dr041sAD6ooBhYtAq9
	EcJ5v8V9PQ2/PkrBUJeSY3H/Fz00plPNB68n2jwf7GYqcofQjpjSLSdO0uHSqlG8WHCcaghgwRr
	nSXxG3uVyzxBOrosqEwLtWZRcPVr1Wvp5qexr/N48QcScHlv0MU+SC6qOt2gKX9If+DMNbaoLUB
	e5XtfBBZM8Vmna2Djv/qCTusrE7Cd/RbAUsw/Jmxv4qmmcM0EwvFSVTeNN8wWGxLmJd5zbJqRZQ
	/cFMRyIiGLxyr9xrRS7hl88jBDuZJYtQ60nGZuk5
X-Received: by 2002:a05:600c:a00d:b0:4a5:e6fd:65e5 with SMTP id 5b1f17b1804b1-4ac19705d57mr55863395e9.31.1793372577101;
        Fri, 30 Oct 2026 08:02:57 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm3623785f8f.36.2026.10.30.08.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 08:02:56 -0700 (PDT)
Date: Fri, 30 Oct 2026 16:02:52 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 14/20] attestation: Add the base family specification
 and generated files
Message-ID: <auSxhgC30bubNJpI@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
 <179302367452.58760.3782556786585774917.b4-review@b4>
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
In-Reply-To: <179302367452.58760.3782556786585774917.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:

[..]


>> +++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
>> @@ -0,0 +1,184 @@
>> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>> +%YAML 1.2
>> +---
>> +# Checked-in ABI snapshot of the ctlv-attestation family, written by
>> +# "make -C tools/ctlv abi-update".
>> +#
>> +# The checker compares this family's declarations and inherited stub fills
>> +# against this file. Updating it is how a UAPI change gets reviewed; an update
>> +# that removes or renumbers anything, narrows a bound, or makes a placement
>> +# required is an ABI break, whatever this file says afterwards.
>
>Have the generator emit a line showing the original yaml file this was
>generated from?

Okay.

[..]
