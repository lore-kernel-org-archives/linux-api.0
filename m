Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792592814;
	b=0joCJiI4zo6LuT8PAisbH4IkMmp8f87BKw2CuzR9HdZq9gV9KgwXSkdd6+ExLUeHS1U1
	 VH81YWDjV/ixN6HOHG92YGZ+iSjg1jQGWbZWw47rl8l3tvbAp8XR3HCidygEaNh7t1MfH
	 TU0mbl47DeAXiRoQlU9RSTCFBF9H0DYmeT4+wVfd/uhVuIVSBhsjPpT5gx6PlH2T6WojM
	 N1GwVdh/nPY4L5d07mvXldblLNuP932SR5fj+zLk5Klatjcq4/GYAmr/NWsSDLqrCd60F
	 1IGMPiG/WqsvZWxWHM3izV9ZA+udv6U8zmcSYsfBujocciTnZiSRCZ9ESee28nbJFtQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592814;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
	b=Oqso6O6Sw3BG+QIvTjWjHD2xPm7Ja7VXML8AM0xAhOBtA6luL6prspKmQVqqBCq4AT6O
	 1j2xzqrYZsjp7OzUmyffWOtH4OY07Js0f3TmV02Em8SlVmIwZOBHXCzhJDltV/ApIqlSC
	 e7Vvd5PdDEF18cxLb90iskOzqh9+p8TgwGwBfXuT/DSHqkuJ/QV4PwmMOp6ftt8KpTw/C
	 SrAaV+/hCQn6wY3lwGOQtzKKy3V+dlT9Ep5iuwvfUvUoCTnV73hT5MQCpA446rCh6/rZy
	 HZR0SojjR/K1wUpNFqvgio7K85lw+7OKT7wVxJrbIDCkMX7228Kq0WxMWS3eifzgs8g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BRqHAhOJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A66D606A31F
	for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 14:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A66D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BRqHAhOJ
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c445c95d553so101781466b.1
        for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 07:26:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792592812; cv=none;
        d=google.com; s=arc-20260327;
        b=kZgNY4sjCY7VDhF6Lrz6pRMmjdlUHY4c1EpXQCWGQpBIYW/4d8Wv2xPNAodiayqiCK
         3Mmd147Tu8LgmT/wY8BmY9lsbgm8VD81XQngZQ7G99f7SX3c+y0lFc8D4XjexMngoCMA
         N6jOtnJp0j1GekLz4k857yAQFMgCWh6wLY2Q/Q6pmikfnrsY8B9/BoHCY3JLcvton42C
         AV+HTpUBfUcvotk8mbXJtrScJHDzr/TKV6sDs1FDXwB6kL9LqgL+3gsrm397MxHqGZgC
         PeIIkKWYpOgEYr1HBY1Ps/cfTdQd3q5qjPGsP/OhiHSgoNzNwpY4oImOF7tfBGiF0ZAl
         4i9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        fh=gsXabcqd91Zeze4077bGKjk+PHUBNNoKLdD7HXxjOaI=;
        b=b7S3CWDYVFOXLXLY6Z/VSx/1YwwJz4Mpi6ICSpI4D5N1jCtafY+FgJDnaZvFfXIMx9
         1dsEYiB51IR7D1n4kHsGaIYZOzgC/WeB8ZuiMHw3Q3Eapud/JYYMlZlgIOyf+WCifkyZ
         xJNwogyD1awErEOMaQbkVZn/w5RW1Xa9i8WRwSh7dDhrhfMr/tk459ENUa+jkVyGAZ/r
         kFjfFVF03lIg1RckFshpbFDCL5Q1C3ooT4ITDuf5W0eDMhAmolDkzvYmqYBCqrmdfnMh
         Y0wUb9zPnP88KjSYOAYz4wi/F09oozPuu8vhpwl451FONjp46evCiwx4EJjI4cwnsmfr
         hRQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792592812; x=1793197612; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        b=BRqHAhOJRFQGCZ0436cerbXsvDGcjOTtcEFCOpJRV+nbVKbSAKMl662tBLFTfb2Sg5
         NFxQNyHoxxgYHQR13h13k71ankQp/N0fxgwfPZdFZZwD0LZwBvhOQiky2tnvBNcGVE92
         vpRJ7hzp6lhKrZveGyDGkQ94JZjS5rrim4/SQCOenhyqo5st97RuKWVFwTkWZQ5bTbIw
         iWX7FjROAHIvHplEaKREmJYGpSp7sUQFKLAPhXVjYlSpM8WQnUK4iSviJf2DCzgxJwf5
         mmlBS+ISZT3vDsrX9Xx3+f3KYgz6TnHUVdIwJP9bY9OfNIdfJdTh5lFsIo+qwhCRzOmH
         nAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792592812; x=1793197612;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        b=mAsjtieL9fOM1sL8SDXuX4R1VrLMZCQTQuuUrPoj3yKfF2Q6LbvOngtuBatBu7PVke
         rcCkQMrvqvxaV/p+gUJqc81ZPe/xS6QcMZYu4OSgllVySyB1OQigsyVfBhk3gpZLjhde
         D71TRuwlnLy0fP01W2HLlj166rRxS/1zd9qMMA53cwMCrg0TQwTOI8GFPP2UiqujcmaH
         Xmdbf4sgcdMdxhdU7Y4LfUBljC2/MLVomctaR5C4W4RFYU3JCGi8ja3HH3oE6ZlcHF5T
         mc2Ch0zDV+A9e7ZrgseDhnM263E0vAHgQyoYjnYhpxHYAoHq3e8Ku+rv0C7wT3u6ylNc
         zDHw==
X-Forwarded-Encrypted: i=1; AKwUvBwT89pafSKPkJZ76jdOeWLX5UFLeiG34gHefXR3jMh+zYEcSTfNFAhnVkxqi5cqijx9+ShsJZCAwwo=@vger.kernel.org
X-Gm-Message-State: AFq9FYIuKMsR365Bgh68IrBE+xszyeIEiM4IlceGmLdEc94DfJwq663/
	eCR1vyLzcw72jzVGUiGPgr6XbUip1h1jDovXjWSOm4gyQ3EDSx7T45UghPQ68tXQAU1sY8bLw5E
	fkrFzcF0e+yHfLOM0IQMZhQjJfg1fSFc=
X-Gm-Gg: AYBFou1V2nGXIpSKGbWTPZxVBFpLgOqwHSh/ELQ+M/blEkZ131C/GabVBfcMR6pLgji
	kJsxbdjXa5iVskPQFRHHUdkljs8q23V5LhFaEQkLoSh9XHAXfbHkfsQJbxL0+aJdvOCRfL5CNP9
	quivufaoFIVuWEtpE5IVuNLN4wdJ4diLKU/IhLeHr9ijIv3IAfdfbrCJSgfUUy4ppZSvvZxwExV
	kcRD0yFffytjrjnphCLBwvuNUzAaZ9Xpy3o/0+aqTI9eUbUt1NR5/SnFBzOq6Nepfh9zfpX5jkQ
	df9aQ5VOswajowG9MZycdQbs8kPHR4zO0fuOf/PLMnDSLToP09U7tlbYzGeZNR/EZcPQ/gfWdoB
	SrVdhdAodHKgzQSV2zofFHQf/uz/hj/MFwrvb
X-Received: by 2002:a17:906:c105:b0:c33:ca5e:8ddb with SMTP id
 a640c23a62f3a-c46796b58cdmr190770166b.28.1792592812271; Wed, 21 Oct 2026
 07:26:52 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1792552161.git.jan.koester@tuxist.de>
In-Reply-To: <cover.1792552161.git.jan.koester@tuxist.de>
From: Lionel Cons <lionelcons1972@gmail.com>
Date: Wed, 21 Oct 2026 16:26:15 +0200
X-Gm-Features: AclHuK9oo5ZYObAiFZur0ih7xDKEBxlKdO-BvoDx6w0mXhpoTx1_PdEXJcogV54
Message-ID: <CAPJSo4UJPnhLFAYRXE-_M2_Nin6=Ff02AjayD10cB7946MvJDQ@mail.gmail.com>
Subject: Adding dreaded Windows SID-style, or. Repeating history, the bad
 chapters. UUID/GUIDRe: [RFC PATCH v2 00/41] UUID and GUID user and group ids
 (*_r system calls)
To: Jan Koester <jan.koester@tuxist.de>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, 
	netdev@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Oct 2026 at 13:24, Jan Koester <jan.koester@tuxist.de> wrote:
>
> Hi,
>
> this RFC series lets a user or group id be a UUID (RFC 9562, version 4)
> or a Microsoft GUID as well as a classic 32-bit number. Processes can run
> as such a user, files can be owned by one, and credentials, ACLs, keys,
> System V IPC, sockets, signals, audit and procfs carry the whole id.

Are you Linnux guys aware that this is just a variation of the
*DREADED* Windows SID that this patch tries to introduce, just with a
new name?
Maybe, before doing this, read about Windows SIDs, and why they are so hated.

Secondly, the whole idea of doing 128bit hashes as UUID is not new,
IBM DFS had it, and had many iterations of security issues via hash
collision exploits. 40 years later all this horror comes back. Does
history really have to repeat itself?

Lionel
