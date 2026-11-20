Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.59.177.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183347;
	b=IfUGczPyaHXSslLudSflIB7FiuYwrQirLwaUZtW2WObWhHAS0vzjEa+ddBmB+a0b+/Vm
	 HP8Zm/xAn3k7oK++naK3wqgCArIulo5awxhcXh9zTrR/G5Mmh9llE8854q5pd/7yn0BDE
	 1+vumr1HpmxFEbUqfokFanr9B1qXUE5/mQknaVN6w48LDVvaqLN8hlBDjQbvKAIw6C3b4
	 ViwynzUL/56HIZsXeQBrZn5owSq2avimtAozJtykockdLHBx+eLDazJU2kMvrhirBjYA1
	 1Qqat2gE44C3wIjz23Pry7mx0jeRAXphaP7cyfvAqTl6DD0lziUrw1Wq6FHmTmq181w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183347;
	h=DMARC-Filter:X-QQ-mid:X-QQ-Originating-IP:Received:X-QQ-SSF:
	 X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=sebK0A3/eOMXN8mPlDOt9SYhjTonOi08fwNGc+TkCLQ=;
	b=sqZM8vJQYFnzm31FWZhli5AWPdmC8SMAJFfmj5mcjqETSI8IjQ0x9VCZ4YyMJPI558g+
	 59diVGIaPBZTTS7FYPjSYyCVNCBNpLsgWl1Lo6PbZeMJIP5o28ptSw8yA5a+PWzDLshUl
	 PizvlM3m4vONGF4uh31tPvtEQa6sqOs8YbaR18QkIT2gHwRjp7CB/87ZvNOUsVt+zCTMY
	 gQBKmgTGyiakIx0CT/3Pv7IWKWA0tuwnpYK6GpVGAxjtHz24LbGRNwUWpkptRqjOVBgw4
	 eKKYHIrJoZoJZXipJ82zDqt8qRYlHdzGJBgnAr8SwF8q3BQ/m5So9Dyva/W+0T+BYEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=rustsbi.com;
	spf=pass smtp.mailfrom=rustsbi.com;
	arc=none smtp.remote-ip=52.59.177.22
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182D4606A320;
	Fri, 20 Nov 2026 14:02:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 182D4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rustsbi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rustsbi.com
X-QQ-mid: zesmtpsz3t1795183332tc79d3492
X-QQ-Originating-IP: 8MUBfue/CSK9C6Ko0L4h+J8TmiUajD4AQmf5ZXhtkkM=
Received: from LAPTOP-H63V2Q11 ( [36.110.52.2])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 20 Nov 2026 22:00:22 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2838506993678247511
EX-QQ-RecipientCnt: 15
From: Zhouqi Jiang <luojia@rustsbi.com>
To: Conor Dooley <conor@kernel.org>
Cc: linux-riscv@lists.infradead.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Anup Patel <anup@brainfault.org>,
	Andrew Davis <afd@ti.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Alejandro Colomar <alx@kernel.org>,
	contact@rustsbi.com
Subject: Re: [RFC PATCH RESEND] riscv: sbi: expose firmware identity in sysfs
Date: Fri, 20 Nov 2026 22:00:09 +0800
Message-ID: <8E061F1E54130DAD+20261120140009.755-2-luojia@rustsbi.com>
X-Mailer: git-send-email 2.53.0.windows.2
In-Reply-To: <20261119-zoning-appeasing-71d648cfc78c@spud>
References: <A039A2DE1DF8F274+20261119130356.1537-1-luojia@rustsbi.com> <20261119-borough-flap-6481c20b3013@spud> <20261119-zoning-appeasing-71d648cfc78c@spud>
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
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:rustsbi.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: M1JP5WkaVWo/JK7CrDexK/3T8UnQlC1pSI58Tb3okSZJQgbGxVklkUHn
	gfeAgIPei0jw38cTyzzz1YuX2v+h+ZpEG0gVHwqFN1EphgnsUM2UOgOPpTPVlUxLD/J90b6
	3lE37/G5fMwUNLECqgNqfzpT10BqNmoJ9xHJbiNLpDGYm0vmFrQW5CPJli+i0En933/Zo2E
	lkY8e6Fu/XN2kYg1j43ytZZJ+ihkdf1wzQSaXlnCuZRquwjRTEvsGmpFX/QtosJTccd6Cur
	QLhnXGsGoBGbdpSK1jtI/wk/pQjhICYreVYnKhGgT2I36GIHst6//5Kd/hhAWzb6NSv70xu
	wxw3cKdkUHEwcrlsnlO3J71bO8hZcOFRDdmW+RAUwnP5LVVAASbAPA9Yw9IZpaH15zN0tQ8
	rhkfeAXHvNU6FP5AU2uU268SJI3J7269Cv4raZ1Zw0ea9j5SrWXNhXTjsL9oePYByDEckE3
	TyNhYaEIxGSQgPHj2E7L/0O80a80X5EChqDBwI/f289Sv667uvss8DIIHddxxTD7meqvw42
	/qSMJmxd/GuFFfqOPPFJgq4Ke9hwps6bkw5Yw2eyJ4yLtS1IkyXqDxttiD2WlZEg2lnmuTF
	vqRX0T8OQllxzhxFO/lls7KK73WAZ3ciAtuBdEXU8l8pHHvDcjZcVUIeg/kWdGB2LpVYb+T
	Cxco3o44IZ42Ofukoe4Wq4jMgbQKamppqyZUuIb6k1cqkzZ6RNItVtX9LItS5kYivm1ZsNe
	uu/PFKjmSFUNBxz6nTSeqXmkUJz3vkMbxUzG5CR0H8onxUcez0Vax/d9hnjokhP1CTKDcc4
	wyAQXG/5J5kW4PSZ2PKMkm9mb9u3qBPbKik6jj3y35zk45V2MHSsvTzLPVgz+IO5B7RdSb8
	1CAKzjU0LAP3KSaqdm5mdNmHKjLj34n4unA7XJa5+8zOJrQ7xV7lIuVbfBbXxQzTKtGn8kx
	bgf1i6mUwMonvCmxanbdXyPWsGyhNv6vkxVpPZ+kWqh9fdS2ukJPSaYq2KVN1eSyD7FM=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Hi Conor,

Thanks for the review and for testing this on PolarFire HSS.

> FYI, these tags are now deprecated.

I'll drop the tag in v2.

> Should this actually be printed as a decimal?

Yes, I'll use unsigned decimal for impl_id in sysfs to match the SBI
implementation ID table and update the ABI documentation. I'll keep
impl_version in hex because its encoding is implementation-specific.

Thanks,
Zhouqi
