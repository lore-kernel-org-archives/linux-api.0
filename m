Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419D541F378;
	Fri, 25 Sep 2026 06:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.218.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790318254; cv=none; b=QM+A1iX7NA01wcAYoGLuG0NXcvomPb73no+poQgzRMOzTNBONZnH7dWqPUJ1u0IlbwwGlVJY+Ry09drbQgvvRIUM8NhirVtTy/tJaW4I5MmDpuZ1KY1dEi4MWHLmbOBI8OaXJPvhFFD9/sUm3R/ve4d/mQGYA9jeY5AzHKK7Zdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790318254; c=relaxed/simple;
	bh=YGqPYDWhC4i7zOAD3gZF/Wrf24Q2CnyiCjjIhDow910=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Date; b=gWDHM8WbigsZg7eqmhmc9g9KtFAhSJu9ikKQRRLcXi+jID6jRDZybX9pUPckcjEp3JtwWnR4k9RSTqRjcoWiR/usKunDvxoQi4ADiTbUo1y+BmPtM7xic6x5STXyuE/31Uvt1fwndFEFqaHgNX7UPDNav6mbB/5NOCnm1LUWhfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laserology.net; spf=pass smtp.mailfrom=laserology.net; dkim=pass (2048-bit key) header.d=laserology.net header.i=@laserology.net header.b=gDcQ4VYt; arc=none smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laserology.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laserology.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=laserology.net header.i=@laserology.net header.b="gDcQ4VYt"
X-Sender-Id: hostingeremail|x-authuser|admin@laserology.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 75C76461289;
	Fri, 25 Sep 2026 06:37:31 +0000 (UTC)
Received: from fr-int-smtpout20.hostinger.io (100-96-18-208.trex-nlb.outbound.svc.cluster.local [100.96.18.208])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 68A38461940;
	Fri, 25 Sep 2026 06:37:30 +0000 (UTC)
X-Sender-Id: hostingeremail|x-authuser|admin@laserology.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: hostingeremail|x-authuser|admin@laserology.net
X-MailChannels-Auth-Id: hostingeremail
X-Drop-Occur: 0f98f8c6740443f8_1790318251278_451908546
X-MC-Loop-Signature: 1790318251278:1829671893
X-MC-Ingress-Time: 1790318251277
Received: from fr-int-smtpout20.hostinger.io (fr-int-smtpout20.hostinger.io
 [148.222.54.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.18.208 (trex/8.0.2);
	Fri, 25 Sep 2026 06:37:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=laserology.net;
	s=hostingermail1; t=1790318248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YGqPYDWhC4i7zOAD3gZF/Wrf24Q2CnyiCjjIhDow910=;
	b=gDcQ4VYtVpLgNX5EbEoKY6ryv1QIiUxK08Rk+uXL2r5LB32fJz3u0sMIkY+XcJZWWrbjYi
	OOz4KsspSXzcZW4jJXyvLUHhk1CAmlqfWG9vzP6CXPUepGwICp7R+KC6OgYihY/wbzEUN/
	GeZTmGg+DKgvGq+6stkoBCNBYMyY8Ep+OQwVZGLdOd6HGveGChgC9h7Tt/AgMeaU+bNwKo
	oNzmL23lysQl7puSjj5abBCE2hqH8StHdsepdBl9H0CeolYleJRS8LdheycPj2Aavr0KzD
	yl1Ygv/QcBDaiIWdcqDdMEoK/gXkWwN2VyTKP3DPLDmIZIHtEUIVtwKVTUeDFg==
Received: from toolbx (unknown [IPv6:2605:59c0:2068:2608:c60b:fd48:4dc7:1cbd])
	(Authenticated sender: admin@laserology.net)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4hrgx31TwCz1xt7;
	Fri, 25 Sep 2026 06:37:26 +0000 (UTC)
From: Evan Lawrence <development@laserology.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Evan Lawrence <development@laserology.net>,
	linux-input@vger.kernel.org,
	linux-api@vger.kernel.org,
	Miroslav Bendik <miroslav.bendik@gmail.com>
Subject: Re: [PATCH v5] Input: synaptics - add pass-through mode for TrackPoint
Message-ID: <20260925063705.104607-1-development@laserology.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815004214.68767-1-development@laserology.net>
References: <an9ocXI6b7WEI8D2@google.com> <20260815004214.68767-1-development@laserology.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Fri, 25 Sep 2026 06:37:26 +0000 (UTC)
X-CM-Envelope: MS4xfLoINS+pwsDKhhXJER5c105q3C2PcwGDiaOUESddC4EtP/APEAk8kmje9cYXNtL3Ma3b8W2+8a2hBS4FIUygShmM4TivQ+SpJVYsKBKkz0LrHi4LQ7ht W0fiowayWXSyQroQLaHsKMUr4epJDa2ZIsm1gVpy70JgF/y21FtRCC/0Elr+48QHanbC7aY36trHkl1tzUJu8tkXHLFCeFpjk2EF1x1G1lAW+EDUpROFtMti rJr8/0m1oAx36wWPkK/oL0oAR/rLx/qq/9CJhAxCNQIckDXkOAaxgT27NSyKGTG9aIrVSLX7Yyms07mfdQuRv7GO/snOrXjyLHVs9kr6fWSzYP80f3xF3vx7 mt2h/ZgdZkfHJJHZaVO/LvJD8hcUIvnalOJUV8MDlFBpVc4MsDaIgo3HRm3gtaUtqSUzWJ3f
X-CM-Analysis: v=2.4 cv=Gq4Q+V1C c=1 sm=1 tr=0 ts=6ab616a8 a=bXe6bw2OB92olpQ1pPvang==:617 a=xqWC_Br6kY4A:10 a=YAInsrs56s76XBf-yU8A:9
X-AuthUser: admin@laserology.net

Quick clarification: the T14 Gen 1 / P14s Gen 2a RMI4 support is local to my
tree only -- I haven't pushed it to Spencer's repo or submitted it anywhere.
It's early but promising (bring-up works on both machines, no full test matrix
yet). The only things I've filed there are the two hardware inventories, so I
didn't mean to imply this had landed or been fully validated.

Evan
