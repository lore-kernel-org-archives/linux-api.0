Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAD81A682C
	for <linux-api@vger.kernel.org>; Thu,  6 Aug 2026 06:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785997930; cv=none; b=rO4pc24weCQ7EWtB0FhptgawQkSofxyTCa7Zoy4Nb0fW8ysqelMHrAQLUuXCu+C4M/j2/iin+2T7SulbFtQMduNNg2cyzog4b3B9Mtd7b8tdwqZadpMRzW98PphULQM9aNs0fynq2DL/TfNuhxDrB7ujfhnAw4BnJJQ0hVKMie0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785997930; c=relaxed/simple;
	bh=U99UY9nqamgfVI4HnGKMhpt5HM6LIFsK7fT1lmmLATY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aIQumbiudWNClsq66FXx20RRxzLretTL2+OPrICoB96LFdFIXyOrG7wI1bbU8sZr25hhh/EAZjBy3jjm59tdk0WcYFMkqvyqqRhm9MAmf8548L0K9cHXbRPLkYNMoin7/bRb4qi81gnh2i1fFNlTgN+3BoCh/zVUtNs5edg+dOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OmY/Rxq5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OmY/Rxq5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785997928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4E5y/AkNbZJxw0IkAsjY/ZvET0ucQGZj9LI++HPuzv4=;
	b=OmY/Rxq5E6tnhPB2PL8lHDdvWNET3abV11FByGn3l3VPP3iUCdlsRSvKURtN4Qsj3CKIKg
	vcmtUv3nXXH1DnyzLCyApJT7+Q6O18oOulW/XhcPN9WORgoGT3wpK0UGzNskLOo+p18Fl/
	TPIAT9qra5u7d7cSBK4EXeX4OtPQ99Y=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-AReQfHRvOQSizv01XUWLeg-1; Thu,
 06 Aug 2026 02:32:05 -0400
X-MC-Unique: AReQfHRvOQSizv01XUWLeg-1
X-Mimecast-MFC-AGG-ID: AReQfHRvOQSizv01XUWLeg_1785997921
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44BEA18000A3;
	Thu,  6 Aug 2026 06:31:59 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E85001956049;
	Thu,  6 Aug 2026 06:31:50 +0000 (UTC)
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
Subject: Re: [EXT] Re: [PATCH 1/2] riscv: hwprobe: export the availability
 of vector to user
In-Reply-To: <cc671848-f954-41bf-b7a9-ba34c29593ec@oss.tenstorrent.com> (Peter
	Bergner's message of "Wed, 5 Aug 2026 13:40:27 -0500")
References: <20260723222109.2229089-1-tchiu@tenstorrent.com>
	<20260723222109.2229089-2-tchiu@tenstorrent.com>
	<87bjbwk0q5.fsf@oldenburg.str.redhat.com>
	<cc671848-f954-41bf-b7a9-ba34c29593ec@oss.tenstorrent.com>
Date: Thu, 06 Aug 2026 08:31:48 +0200
Message-ID: <lhuik5n4v57.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

* Peter Bergner:

>> We only get a true userspace simplification over hwprobe + prctl if we
>> can disable vector extension usage if the kernel does not support
>> RISCV_HWPROBE_KEY_EXT_ENABLED (so a V usage regression for older
>> kernels).  Otherwise we'd have to use the new approach and, as a
>> fallback, the old combination of hwprobe and prctl.
>
> Since the kernel ignores unknown keys, we do get a userspace simplification
> over hwprobe + prctl.  The plan is for our GLIBC IFUNC resolvers to just have
> one hwprobe call (as they do now) with RISCV_HWPROBE_KEY_EXT_ENABLED as the
> first key and RISCV_HWPROBE_KEY_IMA_EXT_0 as the second key.

And if RISCV_HWPROBE_KEY_IMA_EXT_0 comes back at -1, we'd turn on V
unconditionally?  That still leaves the existing bug on old kernels, but
at least the bug goes away with a kernel upgrade.  This isn't too bad.

Thanks,
Florian

