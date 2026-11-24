Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.251.196.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493048;
	b=fdVfF0ZrfnQaRwAXCUl1OIb7xOo/NXM6foB0j0qAMwN2aF+byfh/OvvJtpdmvzoNelG1
	 ep3faVt6FOAwxCaVBEjXun62ji4N7fE30PUdKYVqiUgEe8LXif/a8iroWip8zn7jBHcUh
	 Ouusm/EWpJAPNSdJAGi8CZRhsRK1Rdt4ljPbdX1M6IpdcTXC7irNHHGjjWylGWp1DhuI2
	 zk4C6WdZXHDk8uI95dM5UASDfz/ZKp7BMNOO+I+iWM2JCLeamdt6WGbBkDeZ3LlV9PDyI
	 thxPiIw7SpxPYHYnoXc8Sr1Lh1s8Zflu8yttN2KyDrwtP4ky+RLfm4UdEQC5/hUnlvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493048;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
	b=KueGPe+rp9OzVfIbxDohu0ygXm2UA5vRgk+Fa33cDdwz156esgE9egp9gVkuUma7IAB0
	 240hF1fnq3AIUslltzNAHVyilZm2XxzHDyK2aiN2mK237evBwIKFkiTp6A7fnGoml1igI
	 hsQh68dyHsTpAhR1Pn9RAGG38Uyogtmu96ERGXzKI+ITxq30SNri4191Sj9JuRuZRHHIp
	 vpuJKv1sgztrLnk9m9zVLuVQN3xso56emDyymv7/Qb2VjIM7B3bSrLWlhM9Xk2dJYWvw1
	 uCaxJ72A0TDhBGPjMTFQ1c9KKK+EslXIBp3ELmjh6fFqJZ6Ix2zoHZS/+qorfMmo0kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=ruVeF+1m;
	arc=none smtp.remote-ip=60.251.196.230
Received: from ironport.ite.com.tw (itemail.ite.com.tw [60.251.196.230])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E32606A32A;
	Tue, 24 Nov 2026 04:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10E32606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=ruVeF+1m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
  b=ruVeF+1miRr2dPDPZNEAtu6VNZS26XMmnOWzp4sZ2hkOA1z9DpVAU/A/
   kHH/VLqhC8KYBlf7m435XqR/eKCFwWGLcIEJgELC2cSw+mmFhrrcj5CbG
   KYFBoOibCu+8W+qOz/FUEy2/NoZ6y3LRnrDeuzWP6fpQlZaTF7kfdEqf/
   KQVUjBN/5y3ytO3cYHZJxkbTc59bdATMdQ3aVpx0hzGpmkNQG9AR6gm93
   8IjnjbzQO2CTr3QCs9r9m/7g6SeF2IOYjdRemR/gmzhcm+amgM45FQ1n8
   hF927TfzoySGf85qV4jmbE1xLaMv40OcJ34nospbUU/LvbRts1GewyhQu
   w==;
X-CSE-ConnectionGUID: JDGp/ue2TcaEJrZn3/qw3Q==
X-CSE-MsgGUID: HMyMYaAHS2KQP21f5OgXxA==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 24 Nov 2026 12:04:05 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6AO440Rp055979;
	Tue, 24 Nov 2026 12:04:00 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 24 Nov 2026 12:03:58 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Tue, 24 Nov 2026 12:03:58 +0800
From: <Hermes.Wu@ite.com.tw>
To: <Hermes.Wu@ite.com.tw>, <mchehab@kernel.org>, <robh@kernel.org>,
        <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
        <hverkuil+cisco@kernel.org>, <hverkuil@kernel.org>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH v2 2/9] media: v4l2-ctrls: add the DV RX audio type
 control
Thread-Topic: [PATCH v2 2/9] media: v4l2-ctrls: add the DV RX audio type
 control
Thread-Index: AQGjzAf29/U6qc1EEeqYH4GUceBqBQGCvzP8t6PjmnA=
Date: Tue, 24 Nov 2026 04:03:58 +0000
Message-ID: <cde968fe7a98464b87c5efb15b37fc3d@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-2-a154685f6989@ite.com.tw>
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-2-a154685f6989@ite.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: 711EE0A529B6DACA1E71D2D7090B0AE7E7046030CE5E3622A42CA86EBE14D4332002:8
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
X-MAIL:mse.ite.com.tw 6AO440Rp055979

VGhlIFNpZ25lZC1vZmYtYnkgaXMgbWlzc2luZyBmcm9tIHRoaXMgcGF0Y2gsIHNvcnJ5IGFib3V0
IHRoYXQ6DQoNClNpZ25lZC1vZmYtYnk6IEhlcm1lcyBXdSA8SGVybWVzLnd1QGl0ZS5jb20udHc+
DQoNClRoZSBuZXh0IHZlcnNpb24gd2lsbCBjYXJyeSBpdCBpbiB0aGUgcGF0Y2ggaXRzZWxmLg0K
DQpCZXN0IHJlZ2FyZHMsDQpIZXJtZXMNCg==
