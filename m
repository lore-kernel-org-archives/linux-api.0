Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.251.196.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493052;
	b=ccvWGOrr7SHHo1DvrVOJeXLwTFYUcnvyGYzYzqQBrA1Ym+8AaRI3jA10PFWVg0zB25HZ
	 fQp6ZjNJjiL0dagynRCxu1+2VS5jXQwvd9mC7c8kfSmuOXOYPft2h5G8CsHkmVdWFlZF8
	 OsP7Bq1AaF45Yb6O8TnkMxuwCJdpTFMPCmyB34gs24nRMU+Q5xjEQvTqClNef8sSa8Ixj
	 DM8td5iRUmJvdD/nt197lThOR3r9sJqvfzsVIzpHCwg3OVE0C71lGtV5Q6HNGnobQtzuv
	 JiZTjwUEeN61FzvxiWt/Om+8K1tVLiL8OslIDCzosefxVR9QNwSTTCXYVMQ2Vmmz1oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493052;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
	b=Y14SRL9j7vXq9yBZYER+fmpkjHe8EDMG8VonPgTkGl+10MeS3oO8jisyxVeQalmOQ0Zf
	 NYTqyh/35tCwuKx7fTVkBt60b4+lzL0UMozMYtaltMuWlXmPZtxWSiu/ybm8Q1DhRUGXH
	 cUQwcIXSXJof227jG5EJmJEPTI13atvvm2UdO1WmkKNeOX/KY6ElU00pHHmugt0f+Tn3p
	 XbPDKsShdH/Dq8V81KhjKR4XSnSps4LPUSV8vpGnXNhXDZhzeML2ZYGxUpIyTvfQ2cKgG
	 nAwwwxuFXBpHY1tbDzGrxBIcD2mDvLlfg2daeavHKJ1PcOyGPFmWNK6yCkmYwYLq4Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=Lx+Oh0lP;
	arc=none smtp.remote-ip=60.251.196.230
Received: from ironport.ite.com.tw (itemail.ite.com.tw [60.251.196.230])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD59A606A33C;
	Tue, 24 Nov 2026 04:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD59A606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=Lx+Oh0lP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
  b=Lx+Oh0lPIpiAVg2OqcYtmduGol+VbwQcH5CAT2c+fSrayMVLlUuebkp+
   LTwMdQKWZpPtgbU/EHBZPMVfbhqdT7WlIJyWPQPFUUu01SzY+vAEhQ/rl
   8W+q4dYNgy+E80qMgJLburTkdHgqUEIf2RuSa4sjSZ23D4SJg88z1C5Np
   l09jEdISbI2oT9rSZxIZaEa1qWTcayFBolJhcjHtDKoPVbfLPQafHudxQ
   6QSwIsYJjkgKhdoSqiFYznX3QmwAF/RkswOV801HFQuoqDziJdpPu/QbX
   lJJqSmsltCC00prwnHd8TkVp6f7IGxholkf643NQf1ibvS2Ytvlx3iB4o
   g==;
X-CSE-ConnectionGUID: U2BbtQTVSN6Y8CCYKwZrug==
X-CSE-MsgGUID: /l928s8qSh+MFgsmk6j4yw==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 24 Nov 2026 12:04:10 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6AO447e4056248;
	Tue, 24 Nov 2026 12:04:07 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 24 Nov 2026 12:04:07 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Tue, 24 Nov 2026 12:04:07 +0800
From: <Hermes.Wu@ite.com.tw>
To: <Hermes.Wu@ite.com.tw>, <mchehab@kernel.org>, <robh@kernel.org>,
        <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
        <hverkuil+cisco@kernel.org>, <hverkuil@kernel.org>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH v2 3/9] media: i2c: tc358743: also report the standard
 audio controls
Thread-Topic: [PATCH v2 3/9] media: i2c: tc358743: also report the standard
 audio controls
Thread-Index: AQGjzAf29/U6qc1EEeqYH4GUceBqBQHELQtVt6HYN1A=
Date: Tue, 24 Nov 2026 04:04:07 +0000
Message-ID: <54180fa36b6e4ca48bb377ce7db8872f@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-3-a154685f6989@ite.com.tw>
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-3-a154685f6989@ite.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: 2058F32C71F519262AC5E91E2F85B6DA899FC6477BE04B61F05A7EDE380CA4EB2002:8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MAIL:mse.ite.com.tw 6AO447e4056248

VGhlIFNpZ25lZC1vZmYtYnkgaXMgbWlzc2luZyBmcm9tIHRoaXMgcGF0Y2gsIHNvcnJ5IGFib3V0
IHRoYXQ6DQoNClNpZ25lZC1vZmYtYnk6IEhlcm1lcyBXdSA8SGVybWVzLnd1QGl0ZS5jb20udHc+
DQoNClRoZSBuZXh0IHZlcnNpb24gd2lsbCBjYXJyeSBpdCBpbiB0aGUgcGF0Y2ggaXRzZWxmLg0K
DQpCZXN0IHJlZ2FyZHMsDQpIZXJtZXMNCg==
