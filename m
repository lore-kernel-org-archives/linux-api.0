Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795815676;
	b=k08Xu5Ga2yGBQTXqAsxH4HoFtVkwAXHN3p3GXpRkbulZGluV5xUM34PgvtgqHGGQPiKz
	 2NM4kro/EfcnJCQ7TH9ncdycw7bGXsH4EnSSPD2E3CfzgHftBLyhGcts8Nf+OjFFsscSa
	 4JHojDfOv4K1juBx7O2uclFjrvqlapeLdIuXnthcnWVcUv4BfgHpzS+Hjm2gLfB+LkXfS
	 YwFpBtO96kCoL6vfe/eJtFS34CvpppzxQvfOD214D/TNeRiB2niKijvyhUgDuTA6hzPiv
	 A7FqyS7DSCC3WknGbrrCdLdHMXxQM9SJ7dEVB1Q6ypABxf4k6w5u3zyQ2QPYgHgoUpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795815676;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GNjJtSmgBzeJqa75AyMuB1FfpMIGeExfgQrDDeRI15s=;
	b=MJHIu2JJvJ42Wj2tXoEcVqcUlOb7Aa/MTBhJmpolH5Q76d0sKsWWItDUvqGcnGphYDQ4
	 Fj6PCMfwwT6U+f5a6xQS+mr1CJUh8swreueQ4YGEiRCd6jFjOMQF1LmZzI7WljK4MLm41
	 R5/TNR6GhmtBzA+2X1I2lJCablBVOItiPe+sGXMT06OjHqG5tIQklDvAlM7FhZ/HL5zae
	 YAFXYPdG7CQAS126I5V0Yehm9SBd4z+c0p+MWJkhyuZZUngd1Msr0PXStU+CVGWrGzOCN
	 pzXyRTY5HFpseOqhZT9Gcly8xnqkWdKAkkmrjrJjJq6idmuMuHJFTqOQDqjMtxSf1yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rlJzjc+L;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE6E606A323
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 21:41:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FE6E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rlJzjc+L
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso83007935e9.0
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 13:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795815674; x=1796420474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GNjJtSmgBzeJqa75AyMuB1FfpMIGeExfgQrDDeRI15s=;
        b=rlJzjc+LyIk9Bk0QS6P/I8TDEexyuBC3YqrMNuS8l9ecZxXqzecIXHrsa2+jjLCIkd
         AvdgA+lDcovhfWDGGXxDDTraLo/z7WixYN6CS0WFtDPjvWLKrdb2LmuL8SVsyVcmcUAE
         w7uKvqNGQ6fgCtW1/YqXftDsvKWqzLc/etNTUBIImSolgJ458EFpxfvonhxlMSH2he0w
         gpZYXR2cdjzW3qoLBTUFALao2MhHDceARIdwR8T5fNHKRhO5CZKehhou/RRtD33QzCTW
         J9VxQgQTSkBjmppRZyAfVgxgVnOD9jDbF3HW5K6gfIlLPnr/76nWxRQFxdk3GCbefAfK
         3+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795815674; x=1796420474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GNjJtSmgBzeJqa75AyMuB1FfpMIGeExfgQrDDeRI15s=;
        b=Qa6KTFrtRnkPsfFVUU16QZY5mbMlJ3j8U/w2Q+pCocvCGMzp+BoFiOLYNCfpOL3beg
         g962zMf5hZM9cofZczHPNDCoPOrQfbFsaMTrHnjnDqEKpRHAEFeFDHpcZFpOSfMW9WWt
         tczBILMPET+zt53+acisy8bYSe/Ze3ZjIt9ni4NEX/jpT7v5e7NEoEoJAZblb/KM9eO4
         StOQKz9WvFOZbQtsj4L8Ay4umZsC/h6d40QatAmQjWHqD69aNodrLO1UWojwWGBx0oLz
         1voM+xeSL6R65kVsHjUdESUjKdRbJOVYgOsPbtTdlD7B/15HpwBYhE66sl7fnFB0rYS1
         wLFQ==
X-Forwarded-Encrypted: i=1; AL+hErEL3MUFUjLePqRCTJVzqWu3Ivvclz+yQ48/bnxWDBqQCkd2kWBSNYfDgwcV2S/nIy3iaj7AHP84uSI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/RfC7VUOyHBwqm/aAnIpiET1sR+CCJOV4YOrQm/lg0t5GNoGbA
	dhRXwya8wj2GE+elMotaxxzYBWaSIVXIOdVwZYL1YZaKB2QPyjz3Cdy2
X-Gm-Gg: AZFdTZdx/W/RPLwpYFBYIepJPaLfJe0TYTxUzqqDiadrJD5kDmlNdVcI4ZKksK3IOOW
	a4WAVnbYMfkjfxg3vN5G19rJKJuOA3/LSUnn4Yj6HSWdGrnwq5KQlUZWHchyq+hMSRpsPt4wNrQ
	PDUrcnOIs788jK5ixBiuauis4/DU3wAs0hlROu9cwK4dI3ggVj24Z0Ypb3SAQdzyogluAqfJBCW
	eI3eg2GoErUqFR5wqRd724C1P+fnZGVPVhI94QPWZAogCRdAD/jLWnmKOcAb+NHJMG1xh7a2UKs
	qQPqxXS7NrUHlCqVAbMZ++gJn/vgHAwVWXPtpMnBNV0F10+WxBH9NsaBLhCv8JZUEdGWyNs31HC
	Tb0mqkwdCRgg11huiH6OFMDIEZJ6Smu5lFbf/c0B2RZFqBWZhN6PaFBe2qzNQ+2X/kVcJ11Uz+8
	R2+Y4VH/s9f+CUPXZf8H3S/zAAIEzrCfzisv5zRu7S8qGe4eqyJ042KHXk/iq/oIPtq5uxyMRS1
	kUyH4mWEADYkutxg2yobFCn7Q0cmJjDZOcWUwjBGj/vDbEjUA634pAMDKGuK6yubZtdinRBnB3E
	Aeti4qTW9X+vhtQxQymDLsDbqA==
X-Received: by 2002:a05:600c:a085:b0:4bb:85d9:156e with SMTP id 5b1f17b1804b1-4bb8880fe46mr518939935e9.11.1795815674386;
        Fri, 27 Nov 2026 13:41:14 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4bbb97e5356sm37714445e9.4.2026.11.27.13.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 13:41:13 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: jarkko@kernel.org
Cc: aleksa@amutable.com,
	alex@amutable.com,
	alexei.starovoitov@gmail.com,
	arnd@arndb.de,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	containers@lists.linux.dev,
	corbet@lwn.net,
	dhowells@redhat.com,
	ebiggers@kernel.org,
	giuseppe@scrivano.org,
	hughd@google.com,
	jack@suse.cz,
	jlayton@kernel.org,
	josef@toxicpanda.com,
	kees@kernel.org,
	kpsingh@kernel.org,
	lennart@poettering.net,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	luto@amacapital.net,
	neal@gompa.dev,
	oleg@redhat.com,
	paul@paul-moore.com,
	ptikhomirov@virtuozzo.com,
	sergeh@kernel.org,
	skhan@linuxfoundation.org,
	viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Date: Sat, 28 Nov 2026 00:41:03 +0300
Message-ID: <20261127214103.542291-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <awOQDOel_72Xwjm7@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jarkko Sakkinen <jarkko@kernel.org>:
> I personally think that "getting in" should not be a goal in the first
> place. I care more about that whaever gets in has a high bar of
> quality enough. It can be something different than this but
> when I read the LWN article about Cells I was alarmed enough
> so that I had to do this and prove my point.

I think that Bacik's patchset has better chances than yours.
I think so, because (as Bacik said) it was tested in Anthropic, and also
because Brauner reacted positively:
https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .

So I suggest reading Bacik's patchset and say what you don't like about it.
You will have chance to influence Bacik's proposal before it will be merged.

(Note: I am not kernel developer.)

-- 
Askar Safin
