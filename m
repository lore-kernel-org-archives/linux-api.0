Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795448444;
	b=do081+G1LkoYHPDPkPvjLEpchDDuPBx6xmJnl7lwTgfwog977xXH5twqWOCsg2BF+EOf
	 z8AW58Ovl5ndviJpnPsgqjnHmtW/dqbDnCalrEVAe5+WP0h+JK2LOVmsTKu/FQ3lRcZ9s
	 ii+ELOit7nY8qgY/u0AMjr85+UMOYzjcK6J4j7hk0z+8xZpXHVCyrgasFqOTaLpyWbE6s
	 DIjKRBxzw3YwoWtrOk8wXFtJZ4vs75FFxMUejvZwKZZua2TWyfHuxX8/US+g4xspH+fJy
	 u4ufoyb0+fYsyeZ6x9RE5Cttf9Z51b7o773gdCnlgo7GunlafqLNICPUjOBRpF8jrew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448444;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=YxzVyVE4ai8Ea+LyIq1A/L2q3uxrmhBKTxjVeIPKjac=;
	b=fhravxrySnyyjDUQfgwCgQFAaWK1vHInzujoDtWHrIco1/Hf/wUmPz2EFOeZ06B3kjd2
	 nmKRZyeG7nfSKBXTvh/FWQKdUl/AJHApC3J25zUno/x8BuyWhiTEDmkfHVUgi12sfFGmm
	 oHxOmJyFCDEEx4w+1op4NEAfJs0jpWEh/JcocCm9QdwZJywCemysdboTvNimlcLPYiLiJ
	 2EHiLkbUkYTO2jlY3R0SJxwhHqJxAjF+2T1SzQOfg+F6DoitrYJGVK9VPeCt+JmT8rDhH
	 JkWibYc9MzyKK2UnSQaPgVvZJcHVJs+KoH8834/6kRhzrh6/qxhM51vHr+flnv42MlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=DCWIajyU;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C52860A262F
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 15:40:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C52860A262F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=DCWIajyU
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-53644b28706so58824551cf.3
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 07:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795448443; x=1796053243; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YxzVyVE4ai8Ea+LyIq1A/L2q3uxrmhBKTxjVeIPKjac=;
        b=DCWIajyUd2NrR5Rg5QH4BYrc18jOuaIFNK9krdfrMVuNBFHlfubE8POzOdp0A6zoio
         BK3Jm8Da6025c7dLknh9DJk0+VZH9DV55cQrJ8yJnUw7oCdRMpIHTUv6YgHpYHhqIori
         GGrUVou8pcQMhd9KQWvZXddio3gurupEp+aji/SeMFzVVqTC+CtP/te/WmUVmR+NlGSs
         KmBOlJCgCk0+qX6nR0Aw5RMZqvS6VBJFSdaldgcPjsZr2AoWVUN5puz1Vgd90tEBLzpY
         eAIRonSuZWxNolGYAuXxViEQpSYv2RNGlQkdAhBcBAeO1UcT99mpa3vZgxg4rC/bbjsA
         7Wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795448443; x=1796053243;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YxzVyVE4ai8Ea+LyIq1A/L2q3uxrmhBKTxjVeIPKjac=;
        b=r42It/n8cO8vV/DUlyTIRVBv4iT+sD/L6HpC3NSF0ppVk3DHxojg8Dz4Y70UqK7AAr
         XWVE5BqRkkuHiR73qz84PBOdFAFMm3ETyx8+utIQIgd8pToS3uZcP5YVcmGcPdeX/6IA
         /ZNEYxhJW21ag1Nvj5GNaBrpqfy95EglQ8t37Tm9KWL8m7lBWn56nch1XEe4OAvL7EKh
         JOo4gXyLTF5H14uCdoCIlOnyzSISnMT8+TzJrvMUzGIqXDiI6RPgzN55Ef/n4D69w4BF
         74PWYIH2eajiCsZUlMhluLyuRo/7BDqbxXD7cn5W2qiE9xQ+XkmTrL96llLy+plD4LN3
         bASw==
X-Forwarded-Encrypted: i=1; AL+hErGvK0B+UcTOv1uRD3J0zDDlODI5uMWWdSGAoS32Y04ajEZ+gMqQoTDOvZQErf5rxMZJZ4eyhw099ug=@vger.kernel.org
X-Gm-Message-State: APuU4Z/K/ikWbauK/fE7587RPQYvydAJ4OiqcKfWrjLL4x3Qr3BIZ5gJ
	KNAPt2D2rr8aI1vNsU7RIfl3A96YVcWT9q3giL1KHdLzZnCzeyxsogtAyVh8FibufEE=
X-Gm-Gg: AZFdTZcJLSLY+Myt/GpNwnjvEdaHxzvk5WIx7xCkQhHr5fc/hXbMgFntu4kUsyOXpK7
	alSNvZ0uCyqt9QPh5f5F4ePPuSv/SQ7ca7pPDG9gR8zDaYa37GpGgsjpyO3HnMPOHa7AR9kO4xR
	kij06oVmE4OIdurGDbEjCPWGhOtMP/N9iFHAtm5ElruPE6lqAhzsO9PnVrewx8f+N1RAwogdOFS
	HBs7F++84SgXgyai2V8jvG5nyB2xHAn09SolvJcI38ulVLHH0AKN9p0ebkDrJZMa0HQNUzn9crg
	sQy5vp81Dpe9HaGTOcby7ixsYgPhVkMusMKt++P8WvXc6dEQEUpOIO7R3cNzJPLKH0lIO2ZWoDq
	7eVI4gg7sD6X4bhIK3Jstj0WSqBMbKO6pGJE9Vu0hq6msX3kkQ41zfWMEqy6cjXXb+Oy1fWPYRb
	v8GJIhi//UF/sXD9VZ6h/BrwGmoLDdtMjplVssQmlr4byRq3t9PLIEXy30HxMsrPk4+baiDN4Mr
	clUul07XC9ppCAhfGz5GysL3giapIgRp6vnia2O1nCDlHFl+e7FRG2dvSyNW8QyBseGIn9V+9fZ
	yudgJ/4S2q4pCfGvqtcb95gZYOoJL5G9SSlKJ3qzE5qeohUIau6hDUx9h1Y7a1A9KBGKe7usFNt
	jYtk=
X-Received: by 2002:ac8:570d:0:b0:55c:bc0:63cc with SMTP id d75a77b69052e-55d768a2916mr224280231cf.6.1795448443241;
        Mon, 23 Nov 2026 07:40:43 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134796329sm107324056d6.2.2026.11.23.07.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:40:42 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVW9q-00000000t9u-0g9S;
	Mon, 23 Nov 2026 11:40:42 -0400
Date: Mon, 23 Nov 2026 11:40:42 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jiri Pirko <jiri@resnulli.us>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	zohar@linux.ibm.com, aneesh.kumar@kernel.org, dave.jiang@intel.com,
	nik.borisov@suse.com, sergii.dmytruk@3mdeb.com
Subject: Re: [PATCH RFC v2 9/9] attestation: Add the TDX family implementation
Message-ID: <20261123154042.GI179082@ziepe.ca>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-10-jiri@resnulli.us>
 <awQCrnD5CtEhKRWz@e129823.arm.com>
 <awQz1P6iXYrL8lv0@kernel.org>
 <20261123151128.GD179082@ziepe.ca>
 <awRYr7yB8IWj7S3G@kernel.org>
 <awRan8ZELzpTwduV@kernel.org>
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
In-Reply-To: <awRan8ZELzpTwduV@kernel.org>

On Mon, Nov 23, 2026 at 05:24:15PM +0200, Jarkko Sakkinen wrote:
> > > > As per the function, perhaps tpm2_calc_event_log_size() should be
> > > > relocated to lib and have non-TPM name like firmware_event_log_size()
> > > > or something.
> > > 
> > > Probably under drivers/attestation since that is where all the TCG
> > > formatted logs should end up. It should be 'tcg_event_log_size()' or
> > > something. Maybe a tiny module for it like we would have done in lib/
> > 
> > +1 for the name, as it is obviously more accurate prefix.
> 
> Location, I don't know. I was thinking something like "lib/tcg.c" with
> routines that are plain calculations based on TCG/TPM data.

I think we should not have new users outside attestation subsystem,
but the legacy onces will still exist obviously..

IDK either, but this is my guess..

> And perhaps for tpm_buf (both stack/heap allocatable), if Trenchboot
> ever moves forward.

DRTM users will route through attestation subsystem to do their
extends so the tpm_buf user would be the TPM driver inside
attestation. We definitely need this for ROT agility.

We should be able to build the attestation TPM driver without any
trenchboot stuff to motivate it.

Jason
