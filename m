Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794335257;
	b=ySigXDttLGuYxTFmg+EqDlNGDaZdl4bZtVODtFHxOkDNHN8nk/lU6CqqSDg5QxtCCYT/
	 +1EjpfRSlHDErq2gyP1qyuHjUEA6i0hG9RqG7d8WYYeuyUZU9WSnGJclSZj9AYO0HaTKz
	 QEY2381Twb/acJXIftD89jkQ6NKHp3xyr9ukVMDmybL1GvkF1zU98MKuGtE8Q2FUElTbD
	 ZQYOFBORhUHOlaw8zFxLXBwygw8g1y3klexSeq7Ylhg5OyvSYH6v4Sx6U0LJmty5/2+Vr
	 t+0yZu2LftJLumJBk1Yo9iiJHPD3FzXXVCrDEQ/tAosMorZRriLFXlWsA8PM/vzuqUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335257;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=YXIy2qRY3m4JoNqfvZNIVm9KUne3fxI0qe7Yqqt3EGs=;
	b=tn3XOd74x8+dkY2erNPzdNQ/oKCOw31l8pYjT4KSDv3gVGyfsuvjCrHYFlxggPPqklmg
	 +V1mxmjCWQ3sBJQGCR4V+YLag4C8kD8ojzwjDQZU+0ToVd9L6peje4izuPyGI7bxjVX0a
	 Zu8PKCYsiESKiUansQNGyPLH7OvPbS7Pfdmj4YGYyvX/nbJP3ih+Ii2URJufaWDCXM4YB
	 KJePGId3lFEO4ZlLe9bO53vQ7mAMT2SaavoVKrhzjpyhfqgKMxP2eaiMc7NIHMYSFoSlN
	 L0rGPlTz7SbWUnSCpv7yVhfh9RIOSnxou5F7fgipjlAnNkvpKfKD+Z/n/+Sa8LWYhlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=J7TMm8T3;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D42606A32A
	for <linux-api@vger.kernel.org>; Tue, 10 Nov 2026 18:27:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37D42606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=J7TMm8T3
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5364042eecfso28939031cf.2
        for <linux-api@vger.kernel.org>; Tue, 10 Nov 2026 10:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794335250; x=1794940050; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YXIy2qRY3m4JoNqfvZNIVm9KUne3fxI0qe7Yqqt3EGs=;
        b=J7TMm8T34Tu4l5OHcANKwx0/ZOzfapRBnEg4cXPKDFAtzJrkdsQLmXQH1PNBaI+LZH
         HQxhcvnWaPMv4Mdu99jEJKX1gAfpkqK9bmVZNQr4gKf5Et/58JlVsH9oOxDsx7bqpFQu
         ZXW3WV+2lrudMoNdhU32xg9MgdSNO1NqIogSK+UVa/6AQgjRkJQkqGErKB9UAMu1XqgJ
         3fZPTlqW+B98MNIeDrnpleLnnPacRQ56XVQM2pIc4xb54sJcW/ZDtQ/K4p7vR1GL4gM3
         rK7V1sGMQaqI7HfANYUEMk0S5fY/S6x9xF1CTrUP9NqUwRARSKYQRXehKzOgiVLCp6ft
         i0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335250; x=1794940050;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YXIy2qRY3m4JoNqfvZNIVm9KUne3fxI0qe7Yqqt3EGs=;
        b=dWwCqj7P1Z4tLvjsGgKy6PK1kTFrsAkObO0im8q8aXCOHs5LIX2tE1jG9HIZZrPZ5S
         1MNYczx/ZIfLfRYYJ+EF3o1H1GmTnryQIaGKaBXscBxaI1qh2N067qDfN9cPA8znq2AS
         zkbWeIXM4rTMjXOnRLjQDR+i/koRHlLHdIChBDC2GCHsySO8rGn072u2ifG+KRn0w8Hw
         wCsY9sJs2sKu3S7fVvVkKrgTm20/TdPU7mwhI0RavU+8j87s4KIpfxDaim89F0ndI4r5
         LSVMGcqCtavxBrPFtNLfrm5FB3P01/bbGJH64pqaEBpR02iPA3Au7SRskaAVjnS71KrR
         dt3A==
X-Forwarded-Encrypted: i=1; AL+hErGfqGaAWaiYFJUE8HkzRIGp62/QAU3efaQyqtG58HsQKwVgn/hdbew+KhCFhgTg8lJJYN6ccQ+zYPE=@vger.kernel.org
X-Gm-Message-State: APuU4Z9s1TC+8GzPUXCmKEt/Tr5NpX7sDTwWYGsUIvC70izkj037GGxO
	AvHLLE8Zg8e3n3t+J4Eq2nDWTtCrSL/JnF7ajZ+GYiK/GtqYe+y75QVLwuaCGlxH5JE=
X-Gm-Gg: AYBFou26Eg4graJ5aHKDwMIEHA0XE0oQUKhcSoffCUTRI3edy75cFLjiZGJekzeCan4
	J3S8jBfQNUJZ+ypyzwpI3uC2GTmA895oJzOtK3lkPBs/3z7yXjA3Sl4ceccl94cCVXdpf6Pgo5/
	LJllaKNCNB98erDJ4ABPTz5LD59shK0GBG9xajgj2vhJagDieZJ7JIXccVIHSBjZmXYaltRfzUP
	M8DU1bE/eFGZHe0Wy2XGzwCn34MMXSKRXSc+gEHtz8X67P1BHqIdHD0UdKnkCbdeiv/7zH6CEyS
	5Uaxi2Tl5VAZ8OI6y2AgKxTZfs6dSt2BkZbkR/dLrPe0solxfunf3zFDnR9OtrrQEXy/c38xqwA
	73Q1ndO990cVkMzsGY53WyKViznBcVIMYWiIUvIzHkwNVYIlrtjjmI1Y079gSER/8se8RXyUSF8
	up6p4qvNUjgGhvFM26aC8btG7gH5dKeUGALpGHsGefnZVk3e05D5oIvtFiceSH7LAlQ8uIqixNy
	5Y6LfpC0SfwTEsgGou07jr6RnIAA6zsCJttV5sViowNCBOmCvXolesYAk9krA37qpiUegxO8Nq+
	lg/PppKXSKeJPpDE2N9W/HvleSHy04c98HmLn/FBNpiyivzOjYwsMECXbK05czJLFrfEo8tX9JH
	JZCpwWbkA4Wo=
X-Received: by 2002:a05:622a:313:b0:51c:1590:8e13 with SMTP id d75a77b69052e-555257c5f22mr54402921cf.4.1794335250028;
        Tue, 10 Nov 2026 10:27:30 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-555093d9c3fsm30362981cf.3.2026.11.10.10.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:27:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xQqZ5-00000006j4S-49JU;
	Tue, 10 Nov 2026 14:27:27 -0400
Date: Tue, 10 Nov 2026 14:27:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Peter Fang <peter.fang@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>,
	"aik@amd.com" <aik@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"Xing, Cedric" <cedric.xing@intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"ankita@nvidia.com" <ankita@nvidia.com>,
	"jiri@resnulli.us" <jiri@resnulli.us>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Quigley, David" <david.quigley@intel.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"lukas@wunner.de" <lukas@wunner.de>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	"jic23@kernel.org" <jic23@kernel.org>,
	"ksinyuk@kernel.org" <ksinyuk@kernel.org>,
	"sameo@meta.com" <sameo@meta.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"qinkun@google.com" <qinkun@google.com>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <20261110182727.GA663069@ziepe.ca>
References: <20261023220030.GM3977851@ziepe.ca>
 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
 <20261103005851.GH3889730@ziepe.ca>
 <au5LCE1jau0yDo5S@intel.com>
 <20261109171236.GP663069@ziepe.ca>
 <cbef9bda9241ffe98652172edb67fab3eb1c35ee.camel@intel.com>
 <20261109234252.GR663069@ziepe.ca>
 <4c75b369b68c98c5c35e296895b6935342dc7dc1.camel@intel.com>
 <20261110131114.GV663069@ziepe.ca>
 <avNfZ0lLl-OrkCHs@intel.com>
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
In-Reply-To: <avNfZ0lLl-OrkCHs@intel.com>

On Tue, Nov 10, 2026 at 10:16:07AM -0800, Peter Fang wrote:
> > It is not local quote processing. This is labeling data properly so a
> > verifier is possible without the user having to manually and directly
> > inform the system what versions of Intel CPUs and TDX modules it
> > should expect to have.
> 
> With labeling like tdx-quote-sgx-1.0 and tdx-quote-eat-cwt-1.0, and
> enough knowledge of these labels, I think this can be achieved.

Yeah, that's all I'm asking for here, and it sounds like the magic
bytes are enough for the kernel to deduce it and pass it to userspace.

In future please transfer labels along with the blobs through out all
your paths so we don't have to parse magic bytes to know what data we
are holding.

Jason
