Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1E03603EB
	for <linux-api@vger.kernel.org>; Fri, 13 Mar 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773424166; cv=none; b=RNoA9Q0KG81PigeiLbM0hm48rTcKpvFreCaFGdZuyTxX0qpA4OZxEPCXiTuF5nCSnWv++miBakA0hjIRGO9SMmeD6Z4ZFORChGSUEdvIlQ9+wAlwkuXek20H46JLMfB6F9o+LL6/qYwo/xuTXSKkG4g4YHBpEI7U1U41Nq5wRlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773424166; c=relaxed/simple;
	bh=jiQQcjdZ3RmJlj3rSZZ5hfm4vJpvPPyDRtyiT0auJzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aipKf5h83Oa7RMX1gDjqVGhJIWCLWJlu7kjsmb8i0Y7QWeMpfwz/9+Bytnzo87vE0kVa8OVniIkDTGWiJ+f98YivAq7klnwSm84QtOkYr4OZrqHj90pGuaVU5ckT3GRrBXHdZpYc5KQthrwcChApNHenMdDJkfnmIvs32PloueM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1SD4U/s; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1SD4U/s"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so27854395e9.3
        for <linux-api@vger.kernel.org>; Fri, 13 Mar 2026 10:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773424164; x=1774028964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=smbNB81N26gfiTAXqk/YsdxZ2z/tk9SBnFNRELJ+/kU=;
        b=m1SD4U/stEe3uugL61yybyZDYlgofCa2nQ0dENCZa5G/VtmLnDFgvgEtJHmYNGBhcP
         jd8NRi3gHJjuptgMapHMSYisGys/tH8W3O2KpjRcxK0GZDIv+ggBco9cJ1WEkZrKmEUv
         OPkh8e1dZqVHsw0FyTVTWl6NSisBEDA6u73KZayqe3fHDgdOwBtfbquDEVgy+ELerL0K
         kEk3jkmkmUsk0LouqJsHiiG59HjiGzVx2Tk625N77GtoHEaT6f7ydUCRYq4Fy7N8qrPX
         H2km6O/B8ukY0vZH17jOEGM3QKkleTeuQVnpzcrdd1VnogIPqG5HdzdNKugtRq8EmTkL
         KTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773424164; x=1774028964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=smbNB81N26gfiTAXqk/YsdxZ2z/tk9SBnFNRELJ+/kU=;
        b=SSfNRhmw7o60sRlP8LER3nhvQ86mLIz7ENJMIUHuYxTGWsHKRQ18vIYw+6MEtPh5mq
         K1V2N10G2FzcqcCuNcF4qSUtCHnKKTawFNfVm0RHSVP2A1pB72MRYEwbRM0UAcXFqyZq
         swduRni9GG/PRPUD1hUIHBAzPfGdw3bnP+hkfd+79xLx6vGSCSCZxPjI/9pN2EFNk1Ao
         ABlNbK8pLNOwnuzhDrQzcDzLI7nbHyFQd4dtRughI9XHixEJ/QmOKtZKs03ws6CWXeln
         XSEq8fd6EBIb4oigF7DAquSZRQZRnhPCa5gaNVrPuetazrRfxZASesWPpUNDprKgRacA
         gaoA==
X-Forwarded-Encrypted: i=1; AJvYcCUNoSRvhjAgxNHExv9BXOlo7GgzKgt6cM4sKO1RXrojiL73mkQ/k04g8+n64tFrcGUGya9FcJOhe88=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvCcLHt6izTkfjsu+Bx/KEv/hTVmcX5sQxNVumSiAXU5XEIdIj
	GYbtDpMhPKZUyRc5vTSeSQfSagzo3xrg0qjiFGXwfC7VTUQUXD8MKJfb
X-Gm-Gg: ATEYQzwHnBz45j9Aj0UhcW9YrtdYeDVtypFBWPQoyQyoDdnTuc/Yvjd1ikZjW5SNKs9
	UkxhVYKULO5ZelNBfYHz+SXfmwK25pFiNj24w62E4rzJRHqzsmRUS8Fp1xKdIH2gpN8lzLgyDhH
	edNP+gsvPO/35KZhdo0Qyh2YgJCcW/lQ8G8bfzIh3u21VVuzN+xyvppxth0vJo22kiJg2/UPuC2
	IyjSU6g0IcmXE3XVnD+/HMBcJfqjz2q23S9pREZ3wLJE2mQpYs7L6prhyfp9Oqgz/qrm7NC1YVk
	yfMQuTxiTOx1QpAsFZDJLYYTHbyabdARnsJtaVepgS8ptYWkXbBiXlpo739KjLwaXS85NpzT7kv
	Ib2u+YLLVxYO6yGQrEcDTGEbiDsmIW/9Mxdj05YoIIdAJ+jlUb4KHpT1hP0uVmVvPk/RZ8YBPCD
	Gn+TigLQJHyJZLtatnV6rKy3HsrNGQG3EgdZOEaUmT3WFzUq6n9R9FJdZOec8ixoIj/v2EfGRV1
	Pq2s4Ov
X-Received: by 2002:a05:600c:19d2:b0:483:703e:4ad9 with SMTP id 5b1f17b1804b1-485567027e6mr73766635e9.19.1773424163760;
        Fri, 13 Mar 2026 10:49:23 -0700 (PDT)
Received: from [192.168.1.14] (mm-214-205-122-178.mgts.dynamic.pppoe.byfly.by. [178.122.205.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485563953dbsm52070925e9.0.2026.03.13.10.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 10:49:23 -0700 (PDT)
Message-ID: <d2832130-5512-4a8f-918a-4e20a77df1b0@gmail.com>
Date: Fri, 13 Mar 2026 20:49:22 +0300
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Modernizing Linux authentication logs (lastlog, btmp, utmp,
 wtmp) with SQLite
To: Vincent Lefevre <vincent@vinc17.net>,
 Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
 linux-api@vger.kernel.org, Thorsten Kukuk <kukuk@suse.com>,
 linux-kernel@vger.kernel.org, audit@vger.kernel.org,
 libc-alpha@sourceware.org
References: <660c10e6-f8b5-46e2-a424-e3e052992b3a@gmail.com>
 <2d5de14a-17d2-4d08-992e-cbc5d430e231@linaro.org>
 <20260313144508.GA5446@cventin.lip.ens-lyon.fr>
Content-Language: en-US
From: Roman Bakshansky <bakshansky.lists@gmail.com>
In-Reply-To: <20260313144508.GA5446@cventin.lip.ens-lyon.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/26 5:45 PM, Vincent Lefevre wrote:
> FYI, utmp has been reintroduced in Debian for libutempter (and thus
> applications that use this library), because systemd was not working
> or at least not sufficiently documented:
>
>    https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1125682
Thank you for the link to the Debian bug. This example has further 
convinced me that I am on the right track and that such an RFC is indeed 
needed by the community.
