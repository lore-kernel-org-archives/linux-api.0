Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.251.196.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493069;
	b=Hj5m4VDlB29AN8fZPCFdV/8S+DMQ24eLE32B1eEVInC22KwNQLh1QhN5Yf9VdpkWUkcw
	 qWrqrcLBmYf/ufp2IDRjdUkVq/XRZqSeMvCE8/Sa5QPePhIUGwYSBIecLB3jkPqxmtyAO
	 GRYgdmQ1fm4YiKVaQCCSnLtxMp6XMGJjvGsvpSZNyA+ex2M56r7zBZSZxPukmM1bMWxhk
	 QV/BGCKxTP5ElWmn0iAv+RNEZ5IYSl5ysB/sQRddtqYFknZx44jINhS9wzJ1UCQaslyee
	 wyErF6p5/fm/IugKds8Y28DGlt5cWc9zyM1lAaKIqmu65wF6VE0h5h0YLknUxZKKMhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493069;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 Received:Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:x-tm-snts-smtp:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-MAIL;
	bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
	b=kdVBoYaM8IyupDFIYpMeOJBAy8I+Z7Te9Dr02ZBqqv5dWXIDLm3bSk1Q/tUpcUMGY1rZ
	 LVNItQIvS+F1o5XpwtNBGf1lW8Gct23b+p7V5z7wAHSrC4g6UN3NgVqlbwEOk6rUhxMML
	 ufPpgTyJe36o+Pw6zRfxO+NP4uFgLPIPLqk4IgIYDRVQulQVz8TXOUOOIo/n645Wi7BDi
	 TmbJYmLB2JJattveVm51ZWFkIPk/5Iy22DMHIFereCpci67j1ZZvcxlFmapw4MkYutGO/
	 J+HzdG38m6Fs94Z0QZuzbit6p+FsoBftMmNeXtSSv9y/DACYYDoa1ZWlFjCJ/Jxc4ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ite.com.tw;
	spf=pass smtp.mailfrom=ite.com.tw;
	dkim=pass header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=Kks62JO3;
	arc=none smtp.remote-ip=60.251.196.230
Received: from ironport.ite.com.tw (itemail.ite.com.tw [60.251.196.230])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962F1606A326;
	Tue, 24 Nov 2026 04:04:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 962F1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ite.com.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ite.com.tw header.i=@ite.com.tw header.a=rsa-sha256 header.s=dkim header.b=Kks62JO3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=ite.com.tw; s=dkim;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dEAWrCcLPoqiH1o+NThWPO02RVOnV+Cf+QRng64jUU0=;
  b=Kks62JO3mqnaHK1RIRr3msZb8a4qYt0+vxLqcM8iAa9idpq8hqJdMn1T
   u0DJIKqVjR/iMhAgLHeAYxsEmGpp+rsa874GLS7FDviTGrBn104ynbUwd
   AvoNRMYZlmAFj63UImIFm8tzsOvzvPe2Ce7/FYuJUTHwiWt3Lr4SLypa2
   heVHrsI0ZaAd9ss8T7pj0NFjGLD2YD8MKW5Yzth1za6RYU3u3SPYf7+m1
   PbZFlILp2IUYoxEIok0L+fPfw8sOsMFfwIGDKUmL/SbGR7l0MqPRemRiN
   kww/BBrMxyqj5q47mCwlM08OHcuChVZRW8ZL6lTQTKEfhBc2MWyntEl4K
   A==;
X-CSE-ConnectionGUID: 7nPmQY9CTQCv5g+SOWqvIQ==
X-CSE-MsgGUID: HOGjvmW4SJuUrE1xCyuStQ==
Received: from unknown (HELO mse.ite.com.tw) ([192.168.35.30])
  by ironport.ite.com.tw with ESMTP; 24 Nov 2026 12:04:25 +0800
Received: from tpemail1.internal.ite.com.tw (TPEMAIL1.internal.ite.com.tw [192.168.15.58])
	by mse.ite.com.tw with ESMTP id 6AO44OSh056372;
	Tue, 24 Nov 2026 12:04:24 +0800 (+08)
	(envelope-from Hermes.Wu@ite.com.tw)
Received: from TPEMAIL1.internal.ite.com.tw (192.168.15.58) by
 TPEMAIL1.internal.ite.com.tw (192.168.15.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 24 Nov 2026 12:04:24 +0800
Received: from TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291]) by
 TPEMAIL1.internal.ite.com.tw ([fe80::63c1:9095:c5a6:3291%3]) with mapi id
 15.02.2562.046; Tue, 24 Nov 2026 12:04:24 +0800
From: <Hermes.Wu@ite.com.tw>
To: <Hermes.Wu@ite.com.tw>, <mchehab@kernel.org>, <robh@kernel.org>,
        <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
        <hverkuil+cisco@kernel.org>, <hverkuil@kernel.org>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-sound@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: RE: [PATCH v2 9/9] media: uapi: it6625: remove the driver-specific
 audio controls
Thread-Topic: [PATCH v2 9/9] media: uapi: it6625: remove the driver-specific
 audio controls
Thread-Index: AQGjzAf29/U6qc1EEeqYH4GUceBqBQHomNqft6C07ZA=
Date: Tue, 24 Nov 2026 04:04:24 +0000
Message-ID: <508a134174154a868ff461aec97000b6@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
 <20261124-upstream-it6625-alsa-i2s-v2-9-a154685f6989@ite.com.tw>
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-9-a154685f6989@ite.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-snts-smtp: 7847B83CBCD3A8A8D30F669BDF4C6B94F7B0C9E1D7BBCDA02E58564A2202C2982002:8
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
X-MAIL:mse.ite.com.tw 6AO44OSh056372

VGhlIFNpZ25lZC1vZmYtYnkgaXMgbWlzc2luZyBmcm9tIHRoaXMgcGF0Y2gsIHNvcnJ5IGFib3V0
IHRoYXQ6DQoNClNpZ25lZC1vZmYtYnk6IEhlcm1lcyBXdSA8SGVybWVzLnd1QGl0ZS5jb20udHc+
DQoNClRoZSBuZXh0IHZlcnNpb24gd2lsbCBjYXJyeSBpdCBpbiB0aGUgcGF0Y2ggaXRzZWxmLg0K
DQpCZXN0IHJlZ2FyZHMsDQpIZXJtZXMNCg==
