Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794858124;
	b=TIMMbP3mvS01cXPDDBBt0XE222QpqlfzDyzQT3kv34aKvGFqohFY0r9ZSqD4hysd9zUt
	 QR5DX3hBZSGRZ6xtz/u40xDpWzZMgdI1vqgbC7KkECG5AtOhewESwotk9ZGqRTq3DnQz/
	 MpSWNlUpe+lyI5xOq62duXTJk0iUZHr2o9WIu66JIuBoy96GV6g/gFg+UtpG76+jwlYSR
	 0yklymOIlqsW0T4VOC8QTSjAtl0TSsSqBb1rmjCHFcxbmTmhH6y02clKo9PuxRwJt7aby
	 fjdRALH9WnO0RFImXR3XrPRx3VVQr2MAjgvQBtLCtPa+jgC9abKAaTe/ClDYWZrCJ8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794858124;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=SoqAqmuXv97PmZGFBFFCczoznG+kfpt1kIToyl4KM94=;
	b=gacEwiYoicl5TDW9LP0KkendG2aNLaO1VFSlq9nVR51/ZT9sVraW5nYHbmsWNYkiPD1u
	 8uDLNYGW1QkehMXbSokewY4er7uBhW0MMGphu59wKA1/n+lbbRBPwxKbJIgaaGXWi3CbD
	 LnEx2VZiSsJSu15MCaVAv2SPfKtuqDkKEkpR5O960KQob/dSTiMxGr9dqFp2hCxkpMmJy
	 7wOCzATJIwTvkY6wl13J1rXjgpzf0rbnNChUtQ46nxH1QFb8P8C4Z7i5m/NxfXPYJX93I
	 U3OxC1KJ7P6Qi+GkPXKJZtobRrQ5DWn/WtQYda+ztY19qfI3w0QsCFzEi9L+g4bNwgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=eoWff0YO;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727E5606A332
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 19:42:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 727E5606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=eoWff0YO
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4d581da0aaso466352366b.2
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 11:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794858122; x=1795462922; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SoqAqmuXv97PmZGFBFFCczoznG+kfpt1kIToyl4KM94=;
        b=eoWff0YOlKIoIHjF1NQtRoRnm8FUpD+Y+ES0aboA/2ep5x5Zghx7qc5wWe3xqvFIq5
         tLFABPvvov/AaKN+xXjGw9J7GLBZRa0WfosWqmjeG3+hmpXmqdMIfACR+fKVNwT0aPdR
         3bVvEL53CTKRlo0pUJynlr8GV8cVqYdq2rZXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794858122; x=1795462922;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SoqAqmuXv97PmZGFBFFCczoznG+kfpt1kIToyl4KM94=;
        b=c/PODyaSkN814kIQUDIeeqgmpzdGYJx3tS2e5xjxA8+kUvv+G54AOOeQWP/p5hb5kM
         FvFayRoXOQsEUeEXLX51OOaBiL23xeRHDEA6ZraO9reXn+caUEs6TUwmBCeCjWMKDDmU
         vl2f+tdSduLdamVoK9+pbn2sRXDH9EbIpzss6knCd9yLytYxm6XPcStXThbMUWwvyul6
         uOmns26DHZnZH/lCe4Tqh7GMr+X8eoKzzqVPmagMWNLKhplRQg9uUhJb4Dv3P16+asjH
         gMT5Hu4s8DjMa+4DSgcxQxZFPzZlkECGZblCJ3rEu1KQ+c9gO2qWoI3Jj9l7SaXE10oJ
         rQRQ==
X-Forwarded-Encrypted: i=1; AL+hErEPIhH2xcWQsLLeFx3Zc0QAaNlZfG4GhblkBPBhKcSUYN+/pkUaMZgrq7OTkzptP9Ehm96v1jDWg7Q=@vger.kernel.org
X-Gm-Message-State: APuU4Z/OBbFScXLfXn4rvEISX/8HL+RRwP2UqKmKwrku0MsSGSGn2DZp
	Llb8sW7yyBnnFN4H3Yl6apW+L30utdmP/hGKucCH8Y6ypsteurAJnnwyRRejY6kdv1S6FWaDmOa
	phq59CYcvmg==
X-Gm-Gg: AYBFou1PkBK+ch8xrgkjJpwh7YH2JmB1n9zOI4W94+s6G0wEb4s/k79qt7bqO6Cdo8k
	z9kFDkT7MLTzjFTxnb7jXRajUZ6qbtO/cA1wDUrR7GRBdIdDldBBr3DCqhYD8NbPUYozz5EQyUw
	RTvxccEsNsZP5iHUSjnRK2U9towOPWYmMe7Up2W9R7uAzLbpDT2sc+oPqPa3EXprQG/dBLnufbU
	ThG5P4y/fNf5YKGbr2G8UG7+heKqZvb4sGNU3xCPeo+PZZTeJQoi6Knf5P3dwb/0HaeJv2w0veY
	qg6mmkZ7NL/vTl5rOdtecmdUm4qtx7jns5M4mB1pn48GkcKojGe48YVM+RXVrqpAXi7YBJHFlwX
	JLJZ2behuAwpPdcdXX5hjXDpdSC6gbdaexLB96wY2c7x86/YxPiWVoZLBe4VsBCiNdmdBj4QwPp
	v7C3lyYmn2llJvPXDiBJLxja8nGMw49FgEhfO/0aI4ycHSbgeUKnSM1dD/qaHXE0lnsjjvyGatb
	/t/TjlEFp+WJ5b281D9JatBg+Foy6n8GLNJafTKYCQfHx3rTr+FfXOoyGcme38yRAlhj+1xUTB1
	dXq+veTcWae51bmeIr0qCTu6XnziXjxn/CiQxtCwvEGuZQpUQrWMociq9X7CZZ3TvG1liia18RG
	znEA=
X-Received: by 2002:a17:907:3d44:b0:c40:4965:72c3 with SMTP id a640c23a62f3a-c509637c12emr856455766b.19.1794858122007;
        Mon, 16 Nov 2026 11:42:02 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c50efdb3471sm44571866b.87.2026.11.16.11.42.01
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 11:42:01 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c50e9408873so130665166b.0
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 11:42:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErERgkPQzCLnyns/pW0Xba7JvLzt3R2sOM8eypIM/IuOdK1AgbKW+fRNiTMu4QhMckNWkOjtKSjPwyE=@vger.kernel.org
X-Received: by 2002:a17:907:60cb:b0:c4c:d6a3:f4bb with SMTP id
 a640c23a62f3a-c509634503cmr1008394466b.10.1794858120895; Mon, 16 Nov 2026
 11:42:00 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261025164719.1831477-1-sashal@kernel.org> <CA+1xoqcxAsRij1j10TyhNX9JXNXNkdWO3sMaVRXCqYdEXi45fg@mail.gmail.com>
 <CAHk-=wgCX4=ZSPALxR7VHKKAKipU1nD_Am-Q-0z1SRKxr-VRRQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgCX4=ZSPALxR7VHKKAKipU1nD_Am-Q-0z1SRKxr-VRRQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Nov 2026 11:41:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg-5cWvYgmnE2WH4yys8tB5AwwRQU6kW0r5VoRYBLT7TA@mail.gmail.com>
X-Gm-Features: AclHuK-GW-sq_aqp10QbcNSLO7AtIlmoHSb6NWDtJ770GEzenoCICUrGbvxqol4
Message-ID: <CAHk-=wg-5cWvYgmnE2WH4yys8tB5AwwRQU6kW0r5VoRYBLT7TA@mail.gmail.com>
Subject: Re: [GIT PULL] Kernel API specification framework for v7.4
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Nov 2026 at 11:36, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And I see *no* upside to any /sys/kernel/debug/kapi interface

And yes, the documentation calls this part "human-readable". Nobody
cares. No sane human ever reads and compares specs. We shouldn't
expect humans to do that, and we should not design *any* of this
around "humans will check it". Completely pointless.

I think the specs should be purely for automated checking, and I
suspect any initial spec should probably even be *generated* by tools.
Because the kernel API is not something that has ever been designed
"by spec".

The kernel API has grown over time, and pretending anything else would
make the whole project be just a fever dream. We are *NEVER* going to
change the API _to_ some spec. The spec needs to match reality, we're
not changing reality to match a spec.

Then, once such a "spec matches reality" has been generated, that spec
can then be used to check changes. But neither of those phases are
ever going to involve any humans, because competent humans have better
things to do.

           Linus
