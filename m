Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A92E388E63
	for <linux-api@vger.kernel.org>; Tue, 18 Aug 2026 07:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038188; cv=none; b=g6eOvPPeAl7iAkzfMxs2XN6/kZlKes9tkNp9cEYSWumJJ588dkpv6UqzIcz8yZah9549ZoN7cxsf7sQ2eEgBT+CbLREqHP2ttk8rctSg2RhB86SEl7z5v0oJro0NsAGpX+Fa4Pji/90lYu5+YigjwQRnSfY5qMN1Z7uzvc9s2Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038188; c=relaxed/simple;
	bh=60jt1hm+Obv8HqD7krRcltxiUWF/V74E0KG9DuRNr/c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZalYLGvpbZYZVQvRaMouJex2VeTeWd8qmTAuEAbWA/1uf6xrk+d3Daisc5Es6S1ABLp67CGSUIQl1h+w5POBEfY8k8vdVmyNXi70WIyUiK+I5CCRblZaQocm0lThvPFaNy0vUrvQNiKJAexxBiCKDch/nuyHBD6tRsS0FnXogu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ONjLXRo+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONjLXRo+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787038186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+x8pfgxpAdfeffVvBTclc7h7taQeubCUNT1m9PIdpe4=;
	b=ONjLXRo+X0cJ2ErBkMlMXu8UVBefyq7fbc5OaDp5y2pGTOjw/yMXZbTWMnq0r7BACBMaIQ
	FUuYOMms0Q0HuuD5oKqInFcNcmykqZs0xwNxtuuwezobtQ3fVf7s8sYmB1BgLqsHySyGe7
	rIg2lBK8TeyxmcMHsZJJjTmcCmY4Fhk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-107-x644BuzUObC3_jznpDetjw-1; Tue,
 18 Aug 2026 03:29:42 -0400
X-MC-Unique: x644BuzUObC3_jznpDetjw-1
X-Mimecast-MFC-AGG-ID: x644BuzUObC3_jznpDetjw_1787038179
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26812180034C;
	Tue, 18 Aug 2026 07:29:37 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7315180034C;
	Tue, 18 Aug 2026 07:29:28 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Peter Bergner <bergner@oss.tenstorrent.com>
Cc: Andy Chiu <tchiu@tenstorrent.com>,  Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,  Paul Walmsley <pjw@kernel.org>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Alexandre Ghiti <alex@ghiti.fr>,  linux-doc@vger.kernel.org,
  linux-riscv@lists.infradead.org,  kito.cheng@sifive.com,
  dfustini@oss.tenstorrent.com,  greentime.hu@sifive.com,  Andrew Jones
 <andrew.jones@oss.qualcomm.com>,  Nutty Liu <nutty.liu@hotmail.com>,
  Pincheng Wang <pincheng.plct@isrc.iscas.ac.cn>,  Yao Zihong
 <zihong.plct@isrc.iscas.ac.cn>,  Xu Lu <luxu.kernel@bytedance.com>,
  Aleksa Paunovic <aleksa.paunovic@htecgroup.com>,  Jingwei Wang
 <wangjingwei@iscas.ac.cn>,  Zong Li <zong.li@sifive.com>,  Deepak Gupta
 <debug@rivosinc.com>,  =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?=
 <cleger@rivosinc.com>,
  linux-api@vger.kernel.org,  Jeffrey Law <jeffrey.law@oss.qualcomm.com>
Subject: Re: [PATCH 1/2] riscv: hwprobe: export the availability of vector
 to user
In-Reply-To: <d889d09d-951e-4414-95bb-625bcab7af9b@oss.tenstorrent.com> (Peter
	Bergner's message of "Thu, 6 Aug 2026 12:09:00 -0500")
References: <20260723222109.2229089-1-tchiu@tenstorrent.com>
	<20260723222109.2229089-2-tchiu@tenstorrent.com>
	<87bjbwk0q5.fsf@oldenburg.str.redhat.com>
	<cc671848-f954-41bf-b7a9-ba34c29593ec@oss.tenstorrent.com>
	<lhuik5n4v57.fsf@oldenburg.str.redhat.com>
	<d889d09d-951e-4414-95bb-625bcab7af9b@oss.tenstorrent.com>
Date: Tue, 18 Aug 2026 09:29:26 +0200
Message-ID: <lhuzeyjanu1.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

* Peter Bergner:

> On 8/6/26 1:31 AM, Florian Weimer wrote:
>> 
>> And if RISCV_HWPROBE_KEY_IMA_EXT_0 comes back at -1, we'd turn on V
>> unconditionally?
>
> No.  The unknown key (RISCV_HWPROBE_KEY_IMA_EXT_0 in this case) field would
> be reset to -1, but the value field (which is what we test for the presence
> of V and other extensions in the resolver) is set to 0, so we would not enable
> any ifuncs in that case.

I assumed, but didn't write, that there would be a separate probe for
the V extension.

> For kernels that know about RISCV_HWPROBE_KEY_IMA_EXT_0, but not the
> new key RISCV_HWPROBE_KEY_EXT_ENABLED, the key field holding
> RISCV_HWPROBE_KEY_EXT_ENABLED will be reset to -1 and its value field
> set to 0, while the value field associated with
> RISCV_HWPROBE_KEY_IMA_EXT_0 will be set to the "extension is present"
> value.  This still suffers from the (already existing) we'll enable V
> ifuncs issue you mentioned if prctl was used to disable V, but as you
> say, it will be fixed with a kernel upgrade.

Okay, that's fair.  I'm happy if there's no difficult-to-test prctl path
that we need to maintain indefinitely.

Thanks,
Florian

