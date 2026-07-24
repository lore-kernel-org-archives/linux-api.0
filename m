Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797BC3A4510
	for <linux-api@vger.kernel.org>; Fri, 24 Jul 2026 12:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897645; cv=none; b=kA2+zM6zmvwDlJJ0Z9xPGMhcH3MC1LuWYQkBwuTWyRG0OaIOJQ0pw6gZz2ZWkt7IAS9qqp3TDnrEafBgFYw6n0dJhmgi4onVbVDHdS9namdTAMr10aamB2pvIcLDXkNvXBESxVtPPt8wCIC3VP6VkRGUBPoDGvrd1u5CrJgwN7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897645; c=relaxed/simple;
	bh=FCqp/UwdLoUUdEMxMpQOwxTRk1R8LBkvYFLtfCdnUc4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=L3uT8ETVG8JicPahtVAEtprNWq5Tde+ttqoFpA6BbSgNti5DoX9YxZWqTKxaA9mMJZv5m7b218FR7XWOYSO4mi1CK3wFm71Z1Xna05mL+9cLa/VdPKYEVXNq4hKBZwCS0fm0kTYzFNQv0xBmjJOtWNYthq8XFfXIkYpUIbi7zfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TT7rC+X8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TT7rC+X8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784897642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=igcirK555i4HrlIuKFrv8pMFmfvzTpNlfQp9aKvV0r0=;
	b=TT7rC+X8o7VFOpvcs6R5+bnCRf4dfuPVKIvUk+0UgB5AU1dwwrovDXRa0CEARs3L7j7A1H
	xCPNGaYbJlkn6VXtRTb5s9t+3AiHdGcYDrOKqWb2xfIaoXN3JasD57hzWux/bQMMPmPNN7
	2hIf2nulQC3ON1OrGrrPG7fvuwm6RKY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-eQ3RHwcuOEKExWdCda6N-w-1; Fri,
 24 Jul 2026 08:53:56 -0400
X-MC-Unique: eQ3RHwcuOEKExWdCda6N-w-1
X-Mimecast-MFC-AGG-ID: eQ3RHwcuOEKExWdCda6N-w_1784897634
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58B6E1833481;
	Fri, 24 Jul 2026 12:53:52 +0000 (UTC)
Received: from oldenburg3.str.redhat.com (unknown [10.44.33.62])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7E661956063;
	Fri, 24 Jul 2026 12:53:41 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Andy Chiu <tchiu@tenstorrent.com>
Cc: Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Paul Walmsley <pjw@kernel.org>,  Palmer
 Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Alexandre Ghiti <alex@ghiti.fr>,  linux-doc@vger.kernel.org,
  linux-riscv@lists.infradead.org,  bergner@tenstorrent.com,
  kito.cheng@sifive.com,  dfustini@oss.tenstorrent.com,
  greentime.hu@sifive.com,  Andrew Jones <andrew.jones@oss.qualcomm.com>,
  Nutty Liu <nutty.liu@hotmail.com>,  Pincheng Wang
 <pincheng.plct@isrc.iscas.ac.cn>,  Yao Zihong
 <zihong.plct@isrc.iscas.ac.cn>,  Xu Lu <luxu.kernel@bytedance.com>,
  Aleksa Paunovic <aleksa.paunovic@htecgroup.com>,  Jingwei Wang
 <wangjingwei@iscas.ac.cn>,  Zong Li <zong.li@sifive.com>,  Deepak Gupta
 <debug@rivosinc.com>,  =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?=
 <cleger@rivosinc.com>,
 linux-api@vger.kernel.org
Subject: Re: [PATCH 1/2] riscv: hwprobe: export the availability of vector
 to user
In-Reply-To: <20260723222109.2229089-2-tchiu@tenstorrent.com> (Andy Chiu's
	message of "Thu, 23 Jul 2026 17:20:56 -0500")
References: <20260723222109.2229089-1-tchiu@tenstorrent.com>
	<20260723222109.2229089-2-tchiu@tenstorrent.com>
Date: Fri, 24 Jul 2026 14:53:38 +0200
Message-ID: <87bjbwk0q5.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

* Andy Chiu:

> Userland IFUNC resolvers use hwprobe to decide whether to dispatch to
> vectorized routines. But RISCV_HWPROBE_KEY_IMA_EXT_0 only reports what
> is present in hardware, not what the calling process may actually use:
> when Vector is disabled for a process via
> prctl(PR_RISCV_V_SET_CONTROL, PR_RISCV_V_VSTATE_CTRL_OFF), it is still
> reported as present. A resolver that trusts this and runs a vector
> instruction crashes with SIGILL.
>
> Add RISCV_HWPROBE_KEY_EXT_ENABLED, a positional modifier key that carries
> no value of its own. Within a single request, keys placed after it report
> extensions that are both present and enabled for the calling process,
> while keys before it keep reporting hardware presence. This masks out V
> and its V-dependent sub-extensions when V is disabled for the process, and
> lets userland obtain both views in one query:
>
>       [ {IMA_EXT_0}, {EXT_ENABLED}, {IMA_EXT_0} ]
>           present       modifier       enabled
>
> The enabled view depends on per-process state, so it cannot be served from
> the vDSO's process-independent cache; requests carrying the modifier are
> deferred to the syscall. Unknown keys are still reported as -1, so the
> feature is detectable and existing users are unaffected.

What is the expected behavior if RISCV_HWPROBE_KEY_EXT_ENABLED is not
supported?

We only get a true userspace simplification over hwprobe + prctl if we
can disable vector extension usage if the kernel does not support
RISCV_HWPROBE_KEY_EXT_ENABLED (so a V usage regression for older
kernels).  Otherwise we'd have to use the new approach and, as a
fallback, the old combination of hwprobe and prctl.

Thanks,
Florian

