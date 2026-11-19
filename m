Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795096504;
	b=geCCRXNJXLX2CjMsVPIZFBRSpdwh3R1/B3oZY6D0tJcZZAlkOH4oZO3inPZfEdms62fA
	 TiMpAGrYnaSKpQ/Re/U/w/PK2UADJP8bR0l0jlQntwK7w5982Qyr4kSBxv1RBf5BpSDtb
	 HsahcXtS1aLKfmtzOtIJBZiK6pRU6lOO8943lN/m9Tl162etRLmLhfr2Q3SVNxHwCOVFy
	 wDBuhvn+xAIPG0T7TbZILKm+vQ2ysD7fGAO/GTtQu2HApFIK45gGRqfXfMxZ40DCQL1iI
	 zuBgYBp8KR7NegSqpCjMC6lHHQJywhJq+5Po9csBx5keffRk3Y+7YQ6oMSwzHSgYJow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+RZLDuEn66qi2YdxAFuL7DH1veBrGjXr3VFwAmR19bU=;
	b=s3i/VEnsesWWbuNG4VQm6Hmxzpn3wK8+j9oOYVkTuEjjqZ1T35R7csxy2Hie6a9qOwPv
	 lsBW9TuANc7OFy0dH/g/EWO5+Jd3Kj5yzhAz6ZYmDAhiXPMmGqUxGtgImMEFpJiTGwP12
	 eJycMZjYQcNE4lfWYVF9b0ASD0syWdexErDAUjRMRLAeTPT91Amk1YBYDpLrDqPM7Ye+W
	 oMnCcUIscDFponhMAC/zyWlEbWIOexbktVkKr2b+FQzORV07iF/m5blE/NVOQAxSwK5X9
	 YvkE/QEc7hwuAu3zA+WECQMmtiTzPg9cnM/7fMDeeKD1mWwaOIanb9C18ETlumZwqXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kLOkQS5R;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8912A60A2629
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 13:55:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8912A60A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kLOkQS5R
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f0326b7c07so305125ad.2
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 05:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795096504; x=1795701304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+RZLDuEn66qi2YdxAFuL7DH1veBrGjXr3VFwAmR19bU=;
        b=kLOkQS5RpbJ6rgyY0XMuyR5K/iOBzyUMoQNhQBIHbxDOK53m7LhMV1n9bhG6yE7wDN
         Q2u2IhW00UKCGp5uS1FbFqOF0anJTOY9XG47zlvU3ymFqz3GsoLKPBCOcJvum5ksvv4N
         I1xaDJkS50qpQy7mq/CBuNCILne795NdE3/b7ZHisalPUGDf3czd0/d5nKo9vKwlEdJ2
         Jno62qOYQGmA972JL1XDXDOc7vgZizjC46wTsnpzJRLqwWb5W1sOQ8Ci1SINY3nX5f9L
         6pOrkcVkCUMzcj0r27dj9KqaOt01977uayrWyqnV0+XLNi8GNxf82ppZw1fF3ruCg8Hk
         srcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795096504; x=1795701304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+RZLDuEn66qi2YdxAFuL7DH1veBrGjXr3VFwAmR19bU=;
        b=NQf1dxAsRkLNrlJsK5/dPBwZQhegMPB9QnZz288pxtELBmtOD5wk9tu03sgESCVlTV
         SDmphABTN7yK34D3uxtMSRJ504wCGhMQLFtP+obL2BY6UBVu4rbgkDdGtX1Y0O6MLb+3
         cAGR0EaHBRa9+Gaeo2MekRTONkoP6K0A0R+NEJ9J+v1+PpO/V6XCHbKydAQh9tfQlphw
         JsFwzj3umIps3KCUSGM/6wxpK49ot2GKe0LN9BQneENoT6/FO38aVBy4ZmLlvrAuaaHN
         6pIqfD6V5guf9JO/JS54oCkKKOhQ7+V/vcPC1xmLDYjeKT9gHRdT9T+KnUroMBE18GVn
         SRCg==
X-Forwarded-Encrypted: i=1; AL+hErFldmYirmXbo6swD8vxmGyeASTA2EXpt40EQODlBKIRWbUIuYX8kBbesDA3AWRujO2swaM+pUR/wY0=@vger.kernel.org
X-Gm-Message-State: APuU4Z8L0iV/14wPn2SmbKaY8ERF1o0xozbjSOLYJDgNVBAlpM6CSMVj
	EQgPgQ3MhdpgYtKrZY6+sXn5/fyvTMxmQxq4im8zkVyvb0fsqlEuQR02
X-Gm-Gg: AZFdTZc1U2vnglUEtF+TF4UbPWH5VqwHw53a8hvuDmKKTrV2rvX2taku6TEGfixi/vG
	Ruh87TxxpY+P30wngZzp8JrnMJ6M9xA1uk/GyQyBUrAcp/W8cyJ1US6OvaAaJaAoEwVgpnRr7LB
	wuk4TTz3EPDiAfZ9hhZCHYVZMFotwqmtC1zbt2YfF4ljS8abuTbHJK7FdjN6DODduZLnPyZFmLo
	wV5MSf3DNBNjmX9lfJDhjG70dAwMjdWNuVjjNURzbnINpjMnLcccLs2NViPYxx+tizzpPG0panv
	7CW+84Nl8+H5uQ2YYP2bktUI1flqGXrpTIdwE1cmd1XWNpIYpCEEu4IJ/46vPuFLRiY77AsfSPB
	iVxfJOC8vezKE50ZCFl5zWzqRDNPm5Pgnu3gckT575/EQ7Teo9xVKMRbmL+OEHuRjgTnCkYnRWL
	ex7yv/FEFfnScMQnGmTdoLqjjNNXKoyhP+ZXPuZBclqHTyHu49BXeS2hsf+ok5LnOAq41NVpbIn
	E5B2I97c7UkN8UoLJRRXA0LdBhFRX9iXFHnr/vufnd8T5ooiDCyuNu9nmJBzdL8xanMGCni7giI
	l0dJshtOZsskKAWd9sZgHVX1dBlpK3paDOO5LyXNHxvc95bPl0RpGwQMGRPELQxgY+wgfmRYbKG
	tEeNOW6d8SwMLOl/50TcZldwn
X-Received: by 2002:a17:903:3bd0:b0:2ef:eadc:5c98 with SMTP id d9443c01a7336-2eff6f86b0emr95446435ad.0.1795096503762;
        Thu, 19 Nov 2026 05:55:03 -0800 (PST)
Received: from DESKTOP-CJ1L666.localdomain ([211.198.99.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff62876a6sm30641315ad.63.2026.11.19.05.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:55:03 -0800 (PST)
From: Jiwoo Kim <arpe1618@gmail.com>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Sargun Dhillon <sargun@sargun.me>,
	Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Chen Linxuan <me@black-desk.cn>,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidfd: restrict pidfd_getfd() to the caller's pid namespace
Date: Thu, 19 Nov 2026 22:54:52 +0900
Message-ID: <20261119135452.990-1-arpe1618@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3e4103cbcf7b76535e2f957762174515ef00f08d.camel@amutable.com>
References: <3e4103cbcf7b76535e2f957762174515ef00f08d.camel@amutable.com>
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

On Thu, 2026-11-19 at 14:42 +0100, Alexander Mikhalitsyn wrote:
> It it an interesting point, because pid namespace itself it not a
> security boundary. While user namespace and capabilities are mechanisms
> to manage permissions.

Hi Alex,

thanks for looking at this.

Agreed, and the patch does not try to make it one. I followed the rule
Christian suggested in [1], requiring pid_vnr(pid) != 0 for operations
that grant access to additional resources of the target, which
ee8323fdc827 then applied to the namespace ioctls. pidfd_getfd() hands
out one of the target's open files, so it looked like it belongs to the
same group.

> Currently, you can do something like this on your machine:
[...]
> and this will actually print hello in the Terminal 0, while the process
> doing that lives in nested pid namespace. But this is not a problem
> because this guy is a root:

Right. As far as I can see this also works for an unprivileged task of
the same uid, as long as it can reach the outer task through a procfs
instance of the outer pid namespace. So pidfd_getfd() currently behaves
like procfs here, and the patch would make it stricter than procfs, in
line with the pidfd ioctls and PIDFD_GET_INFO instead.

The case I had in mind is the one Jann described in [2]: a task in a
child pid namespace that gets a pidfd for an outer task over a socket.
When it has no procfs view of the outer task, as in a container with its
own procfs, that pidfd is its only handle to it. There, the ioctls refuse
the pidfd with -EREMOTE, while pidfd_getfd() returns the target's file.

> So please understand me right, I'm not saying that your point is not
> valid, but I'm not sure what was the intention behind pid_getfd() API
> in the first place and we might want to have semantics and model close
> to the one procfs has.

Understood. If pidfd_getfd() should keep following the procfs model, I'm
fine with dropping this patch; the inconsistency would then be on the
ioctl side. I'll leave that to Christian.

> To conclude, it looks like we have a little bit of inconsistencies
> around here :-) [ But please, don't go and change anything in procfs as
> we might break some tricky use-cases like CRIU and SCM_RIGHTS users. ]

No plans to touch procfs.

[1] https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner/
[2] https://lore.kernel.org/all/CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com/

Thanks,
Jiwoo Kim
