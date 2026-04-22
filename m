Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C541C301468
	for <linux-api@vger.kernel.org>; Wed, 22 Apr 2026 05:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776835781; cv=none; b=dJBby5UT9gkA30Ord7xCEL9oGknawr3MsSry0DeA2tF9+vfMpl/ZEQtQFAWoV1Ndu1ttUkJ+n1pJD+8UlJcoOTWZXYhbhI4HKkm+Uw5kQLQywApD2jLnbVtmzT7/kW15VLZ4+bvEO7bTzUBySCaYGiQjnt/dtzh9KUm2LZPRVUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776835781; c=relaxed/simple;
	bh=AO/qr4ZBmxttHsAmK4Sm1LCeSSu9UdjH0a27ZnlZO7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoymST5CisfQsbofKTMgOFWkwZS9X6oEqd/XkEPXrRzaAkblUWwchybDATq9Kw3pu3cN73vZVDBVB6/1MewOyW5DSnqWpWuSbiRlQceeDyS4K2mzpD6sQYKD9KMXVpzG1EPACq7wDZdHQytKLuSbyXH+jpWvoofLqLAbnAIxsts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZoMJo8WC; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZoMJo8WC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776835767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ow4+D18ZWkUl57j9KmP14VKxYrneT+CbyOXZWnRtDzM=;
	b=ZoMJo8WCNqywN4UYbvik3hunVupHM0yrl+NKCjXw9n66B4iuoXciRJA2LUROND7CQ4mWeR
	TF9MiC/yCSxVtANx/z+90jeEo0g5YmHUpP0jVBz0h+7nyGgPRNTB15beON+mneLEFcGv38
	XLWCiX6kdr03txBhR5X5r8DIQAqMKDk=
From: Leon Hwang <leon.hwang@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: Leon Hwang <leon.hwang@linux.dev>,
	bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	shuah@kernel.org,
	brauner@kernel.org,
	sforshee@kernel.org,
	yuichtsu@amazon.com,
	aalbersh@redhat.com,
	willemb@google.com,
	kerneljasonxing@gmail.com,
	chen.dylane@linux.dev,
	yatsenko@meta.com,
	memxor@gmail.com,
	a.s.protopopov@gmail.com,
	ameryhung@gmail.com,
	rongtao@cestc.cn,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-patches-bot@fb.com,
	martin.lau@kernel.org,
	clm@meta.com,
	ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v12 5/8] bpf: Add syscall common attributes support for btf_load
Date: Wed, 22 Apr 2026 13:28:49 +0800
Message-ID: <20260422052900.355836-1-leon.hwang@linux.dev>
In-Reply-To: <a007ad07d6c91fc692fe29e0a57f1f6059f27eb4d147cb987d01f955b76d3c36@mail.kernel.org>
References: <20260420141804.27179-6-leon.hwang@linux.dev>  <a007ad07d6c91fc692fe29e0a57f1f6059f27eb4d147cb987d01f955b76d3c36@mail.kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Apr 2026 14:56:31 +0000 (UTC), bot+bpf-ci@kernel.org wrote:=0D
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c=0D
>> index 1eb15a51c7dc..06aea4e499a1 100644=0D
>> --- a/kernel/bpf/syscall.c=0D
>> +++ b/kernel/bpf/syscall.c=0D
>=0D
> [ ... ]=0D
>=0D
>> @@ -6317,7 +6317,12 @@ static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t u=
attr, unsigned int size,=0D
>> err =3D bpf_raw_tracepoint_open(&attr);=0D
>> break;=0D
>> case BPF_BTF_LOAD:=0D
>> -		err =3D bpf_btf_load(&attr, uattr, size);=0D
>> +		if (size >=3D offsetofend(union bpf_attr, btf_log_true_size))=0D
>> +			offsetof_log_true_size =3D offsetof(union bpf_attr, btf_log_true_siz=
e);=0D
>> +		err =3D bpf_log_attr_init(&attr_log, attr.btf_log_buf, attr.btf_log_s=
ize,=0D
>> +					attr.btf_log_level, offsetof_log_true_size, uattr,=0D
>> +					&attr_common, uattr_common, size_common);=0D
>> +		err =3D err ?: bpf_btf_load(&attr, uattr, &attr_log);=0D
>=0D
> Should the log_true_size offset be set only for user space calls? In v10=
=0D
> review, Andrii Nakryiko noted that log_true_size should only be set for=0D
> user space, not kernel space calls.=0D
>=0D
> https://lore.kernel.org/bpf/CAEf4BzY3GA+860RODLaXqqO3j5AgJ24pmKU1yv3+gHJp=
y0DvNA@mail.gmail.com/=0D
>=0D
> The current code does not check uattr.is_kernel before setting=0D
> offsetof_log_true_size. This could cause issues when bpf_sys_bpf() calls=
=0D
> __sys_bpf() with KERNEL_BPFPTR, as it would attempt to write log_true_siz=
e=0D
> to a kernel pointer instead of a user space pointer.=0D
>=0D
=0D
Not true. 'uattr.is_kernel' will be checked in copy_to_bpfptr_offset().=0D
When write log_true_size to a kernel pointer, memcpy() will be used.=0D
=0D
Thanks,=0D
Leon=0D
=0D
>> break;=0D
>> case BPF_BTF_GET_FD_BY_ID:=0D
>> err =3D bpf_btf_get_fd_by_id(&attr);=0D
>=0D
>=0D
> ---=0D
> AI reviewed your patch. Please fix the bug or email reply why it's not a =
bug.=0D
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/READM=
E.md=0D
>=0D
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/246722=
39158=0D
