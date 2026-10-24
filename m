Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792854748;
	b=Mg/WXEiF1qJd2oOt2+02hK/h6fAtA1uccAheRU9dZowbPH1vXv46jJ5u5FBLCfi/gHlf
	 543i06MOX8vcD5sv+wH7/xcZ2vUiuFXHUg3KNY6QGl/ZKdwin7jfeYDavs9VDqjmj1+Pu
	 oxH0LpaNkBWwUnsvJNYfnRjMILbNAmYLGbgWrVLv+lg5xJ4Q7jAxg804tZpuvIeu0fA9B
	 YEnZ9IK8wDxJhvObgHR03yZ+uFvIRIM28rPyA9li+YDNpsAHmZYXRfMYs4F7vrtTvlOZ3
	 +FkC1r4I6d06kiIQ1omXImeN9F4PaymIMICLAgMkbJ1txQcjQLhJGdiqbVcPik7tKxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854748;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MyY2jy4KUwx/K3rgfa29m+xcrAnt+SzmlWOsNDROzng=;
	b=g0tmFiKFr+NWukRmltvbo303Sztl6b+9yuGB4zYyAS/xfC4w5Mig4/2BTRzf9nlT9rp3
	 G2P66rzYBcWE2bxREu/msdI3XPUAxynJuRgtSBsXtxJwRlLAVlv76Uz1QOUIaPzh0vVyI
	 2BekXp49n9CWzGwq0+ygBp2M/hN9Mdd6Fk0jq4lP2X9uvcQOvEgvq276bzKT1JOs8ZQKS
	 9gQbCh+H5XqzTJcIevg81t6+vCSL1Nr5FNqZVC6AXerypZMVgCHiPaeSZn+LuCbxAh+HE
	 uZeFzVdRDk+eXDq10n5cjINyj0kaJ5XyGZSswPysHRYBqm8KGD4HmK+aA/nYcx3Mo3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=hackers.camp;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CB3606A31B
	for <linux-api@vger.kernel.org>; Sat, 24 Oct 2026 15:12:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24CB3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48df160bb9cso206874f8f.1
        for <linux-api@vger.kernel.org>; Sat, 24 Oct 2026 08:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792854746; x=1793459546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MyY2jy4KUwx/K3rgfa29m+xcrAnt+SzmlWOsNDROzng=;
        b=KooVPblGl+Pfv/QUtJ6izIBSx6lo4KvIxa2NzZkg+dIzh1FHR3Ylu/NLFMFgPlDcww
         IcOqCueZZviyQi+bec0rwUaIxsfO0hfhA+P3OPJL5/kovjyjRI0fTIknTDcw2EM7HSr5
         +EeNzRUZ+hiY8iV7Hzbwq58LnZAJuEw8CXlXGnRMoW2ANAde9/0u9djZpzSQQERgGkf4
         lRd9NbJbP57SJHZdIQaWl4gerwdxhEILS/5Xy9KvZ9mDczTdwwvUVWOqE2k0hUI5aUkC
         1fGhr6ydjtnRqExHMRVrltQ+MQVwl8AW3muaIXGdMZ381EGeOiQc8U9cA5xrbEiyN8fX
         PyTw==
X-Forwarded-Encrypted: i=1; AKwUvBxWwM7Ykf23EGBHGNtB1JnH7KST8IHad9oEVLnjLRPTq9Ux9Pf9RTsR9zCsBzro9eZfE0j1ToGeAD8=@vger.kernel.org
X-Gm-Message-State: AFq9FYKxCOl2YqlGNUyIbS4XZ/+E8VwNbA2pcm7t6WpcJTjzvSRwIE3i
	gRxN3Szxn1EBE0WX8n0FFLUrHQo7HxAFHzx1YNffX8CEOq3xnPXq1475
X-Gm-Gg: AYBFou2gzuEM+MkNnv2bpJ4z8eF7VARAGKSwANkEagdpjw4B7MTQXtUNWHLAjTkJpfc
	LRuNbHJUVyd9OSVDS6cLUKe6ay78TTwSbmez47PFFuLGYfqmm2HzHbEyqKQSe3dixatZGrluEbA
	dkDoyt8do7LHT0hwLXadQwRrbX6dJ2jXGQZOUGqFDC9HddSFcIBpRNITJL8E+szTZJTx+6ygFIy
	kioGcrtCXrAObyGp8wTDzbfRMsHtHoCKlxQw8BlH5uH7UrQQL6Lni6HgU5cDrTr4OvkBYR1L9iq
	jATmwTFrmVe7/r217l02t0y3I9MF7tvmN/d6Ytpx0cbTPbCRdHBSu6wEzKhDMJBLJRKJDDhHrTy
	Rtk+2rIn6WhCsk7mWRJESxKZtqE5lpMVOk07Qe3kiYm3VSMiPHNuaAFVFqP+DMp1H0OeuybwrXd
	Gi9CRqM7GumpPnSLRjQCI3HAv2wqSlk/0S4fxNRpLpYqyoqnAMhbNmUSBTD5zoN9+TjjIIzxw9N
	KnaMyuxXuL3tzKm8VDovwB9YSxj5Ju9vQQHRsxmzwRXiuC/IvtnnCb1LUITRU7O62IsgEvKGl3n
	UoW2Ebcn2EbhH8E5vsBRXCiqAoBYFw/nbtW0ubk=
X-Received: by 2002:a5d:4245:0:b0:48d:f4e6:7b2 with SMTP id ffacd0b85a97d-48e3eb8705bmr2186375f8f.3.1792854746356;
        Sat, 24 Oct 2026 08:12:26 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd8ddasm5353538f8f.48.2026.10.24.08.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 08:12:25 -0700 (PDT)
From: Aurelien DESBRIERES <aurelien@hackers.camp>
To: rdunlap@infradead.org
Cc: corbet@lwn.net,
	skhan@linuxfoundation.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org,
	aurelien.desbrieres@gmail.com
Subject: Re: [RFC PATCH 18/18] MAINTAINERS: add beamfs
Date: Sat, 24 Oct 2026 17:12:24 +0200
Message-ID: <20261024151224.47953-1-aurelien@hackers.camp>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <4ebbbb17-7833-4a2c-9e7e-b3c731873caf@infradead.org>
References: <4ebbbb17-7833-4a2c-9e7e-b3c731873caf@infradead.org>
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

On 10/19/26 11:38 PM, Randy Dunlap wrote:
> Entries in the MAINTAINERS file should be in alphabetical order,
> so between these 2 entries, please:
>
> BDISP ST MEDIA DRIVER
>
> BECKHOFF CX5020 ETHERCAT MASTER DRIVER

Will do, thanks. The tool that places the block stopped at the first
title sorting after BEAMFS, and in this tree that is LPC32XX DMAMUX
SUPPORT, which sits among the ARM/ entries; it now wants two ordered
neighbours. v2 will have the entry between BDISP and BECKHOFF.

Aurelien
