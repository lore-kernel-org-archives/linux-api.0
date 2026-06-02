Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974AD3CCFCA
	for <linux-api@vger.kernel.org>; Tue,  2 Jun 2026 23:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780441669; cv=none; b=MEzZsFtGZSpSMXAYSens33uuVkhk/Hh3Kts4XG45xqllAChS5W/jZQdUv4Us5jAJQx5HfsZ50MOcHslGQf86ZqV1E0FFvF5hPTUJbsVQbhChXyxjx0TBw6oA/qzFY0Cy4ANikMvbb+4s2AavmPbKGZsLeO7lc3EIN7nmufZaZLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780441669; c=relaxed/simple;
	bh=5chq1ZYL6r9BXlem4E1EUr+5R5J1k5Q21LCWXDRISUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCC1hOjqG+o756LTgjvfhjidXKpoK3F+uHJ0RqRPS/0nNySufaMSxksNj0pBiqwX2hqCn4uTQTQA68xKMP/sMc8hdpMO2ehrkd+PjtJJKhu7ltSe8KwnbL3ldE3Rdk+0rz7MUj5cq04qGsjsPTPM0bwrNtZ/2etcN/uvlTcAmBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0Qeljjj; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0Qeljjj"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b2b037d2so10652965e9.3
        for <linux-api@vger.kernel.org>; Tue, 02 Jun 2026 16:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780441667; x=1781046467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvSaS68IPr55Kp5FHpvrg0n0LohiEL0S8pivrepEpA4=;
        b=g0QeljjjZVRfch0Tv562TmOzSOJBhL8ujFnNlpdXl0x1fHoxAC80hk5vUbqtI6keb5
         dN6GvIY+/6KPLAPt+nptAK3fOIQGMUpyiPeAvndNg/+gozsMl1uKdb38DDTdyjz2CKsf
         P1W6WDQZF1/0B1qBjQ30EqXE7aq0QK9VRgE1FpZeLD09Et0PvqXZGbFjWX/f7K8PBxMZ
         EIMxvsA1XP0bqYi8v7JJpcE8boyJ7SburJV5nC8F1mvObatl+7o9H2Vgt4QQvh86SU5+
         7JLkm69aetHtPhoqjFK62BEHOIb1aItevXjVcnkfBNLI1pVeaxZ2ImvNnqLeOl+s6fnr
         KYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780441667; x=1781046467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IvSaS68IPr55Kp5FHpvrg0n0LohiEL0S8pivrepEpA4=;
        b=rjqDT+a92E+1Zt9aBD/bMLQ7HQCR8yMHtxCMZfgEZrN0+Za58G5l0Z57Ff6AIOFgPn
         LCAAo4hykB5b1DOYoJViuxHyTBDxTFROmDl1rH9UI4Vhi2GyisaI73dTCvTkRP10I19i
         T/U5BRIemBdo+CrCetoRQEFDRJO5zd82ZsM95gS70THUbZiUJQwEYK2bA33Qzd0YGZXH
         Qd5e7Y31PAbkqej6dtXZIiJhABMfiNYPF5BN+r3mypesnS6t9HZItOp3fllHjfB4NdAf
         KxqIzqVxIGSaBAEFC1Xv/rijyFsJyFSTNXdjCxAuK6YpAz3Qtn5Bkz+eu5wJwGMt9M2q
         1AiA==
X-Forwarded-Encrypted: i=1; AFNElJ9WVSDTHpMU8+2joDveLybtl7Kh+u5ERIPotRYr+aS3zyYygu28UIvlumRMZNP7T3FuQMEfU9okFuI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVD36WWE+nphUi7UHP8W0buC9G4OkS6zfGHZQrULrnvQ21V5JB
	zHPzpihWll78V8QI5h5veSavFKWdebCO/Y2IhuEkWoauh2ZSTJrBJBNT
X-Gm-Gg: Acq92OEZvzVps/tRuNdOhQw1K3zExKHDaDH3yIy/j2OCLZRxR/I3is0AzRr7oZnyHBc
	jsK9oQEP4cTRr0GEkZHAoJqW2FAoOCVVjJORpqOsmzxAgOMaSs5ZtQaOBEmj7cYgAi8Qy/n0Kh1
	GnVTKgxX+N4+T2YpSrpqGnTa4ptxUIUxpdlY11zeaTiZYKVwkEhBeT9KFtaJ+ZdhLBl9Hm2YVBW
	cV8buWNCpO+hPpo44oTLFhuGqtwPglRNxWgaTdsCimNDYAbEfHw+unzAD42KJ8YtcES+ezvmF9S
	634hmIxy+vrDGNB0qkgBx3ILnmIkcsNoDJqmFa0eHNo77lSQchx91r4cB/jEFQ72POTCY7HWUIU
	QWTu+7py14pG1XkHb8Rm/1JkuSAhpKqhydUAdYoLdrS/xjkVMLV/ZSFl+mF7MH1D/nxyYn3imwZ
	1TaoG8H5piNkaG+Gt8wWV2x5zagBUuOFXfH8Yu4oXO
X-Received: by 2002:a05:600c:698c:b0:490:44eb:c1e7 with SMTP id 5b1f17b1804b1-490b60fdd10mr11320095e9.30.1780441666946;
        Tue, 02 Jun 2026 16:07:46 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b7a71bb7sm357295e9.10.2026.06.02.16.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 16:07:46 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: pfalcato@suse.de
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 02:07:30 +0300
Message-ID: <20260602230730.138904-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ah9Yle5pd6mD9Ugr@pedro-suse.lan>
References: <ah9Yle5pd6mD9Ugr@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pedro Falcato <pfalcato@suse.de>:
> (Askar, if I was too hostile, I do sincerely apologize.)

You did nothing wrong.

-- 
Askar Safin
