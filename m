Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833920;
	b=caLLStoYfagIuPhMSb8Xwg1y+LzV/6BeETWoIxdJSUYCaLONFwyX/vur801F6/QAF6jn
	 rUohTHR3uNLAOaedRWQk0mKPLaYXElX+JXzjimNnrCA0VXId3pjuwHpDfPLYRf2kR+Be3
	 iLxTbTj1HxDImUcVY7Oyj7ZF5J+Zf8CrHVbc5xKbHzHyZr0of9slnqlEGvhWTfQFCvBKQ
	 RGK2aMOPrhrNmnubJANQRe9C1caUYH5laMaWV2mEr6F46fIUperfJ7Yq+IAaVDmRtELax
	 valD4bSFJ/qkqO34jqUkZ6PdQ6o1mUmbZWAoL9i7e6dv6QhNSj6H+hBz1cAeSy2oWOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833920;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Scanned-By;
	bh=a0eXnU4zCIUpfEz3KZfBfjFrCwZNqPOxDyZIHHOmlwY=;
	b=5Ebrpk53lmzB4Nj3F15+U31V8y1pR0nmbTlx5uLdrPjAbnXeScajbC5osDiFOOFWVOVu
	 j86cLk4+NCRYmgQCx+7u4BHDCQ0CbITMYQZVzNVA5FsN09AxctJzohB/bBT4lPvchZb3h
	 EtKyMp7hCm4BPkJwY8DQAv2MfsBXTFsIdNjd6+Vv6q2arjCJVfAfQpRCvIpUmG+15GgDF
	 TU5wjfy6JdGOEgvHeKcNFUEkDwt2Xgsfc5DQ9mUm4y8Xw0e+ynIudGGt/+a50EkkgvQLr
	 H/SA0eus6TcmfjAIHhqo7mqosviEqvNu512vSxkQNAl9HB8V5WMx7o5iU3UFmLqlb1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=e6RuxerJ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BF0606A32F
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 12:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4BF0606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=e6RuxerJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794833917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a0eXnU4zCIUpfEz3KZfBfjFrCwZNqPOxDyZIHHOmlwY=;
	b=e6RuxerJJh5iWhL22V+Xm+k7OoEzt4XORQ+BAwWn24KGxINltt7DgLKJ5gbMW6Qi3PxCZd
	VwSpfpCzhE8OoEqLtnCPTJNLkoYHn+cknC189IsLX5E0LmnUnJ2dsuVIhOJ4nDD02kbrW9
	AdGM8dF8BCsfZJrlQFFTPRDBBnqCi5o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-BnUPYpnYOaOOHgxB5EYAVA-1; Mon,
 16 Nov 2026 07:58:25 -0500
X-MC-Unique: BnUPYpnYOaOOHgxB5EYAVA-1
X-Mimecast-MFC-AGG-ID: BnUPYpnYOaOOHgxB5EYAVA_1794833894
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AADD180049D;
	Mon, 16 Nov 2026 12:58:13 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 93DC8195B3C0;
	Mon, 16 Nov 2026 12:58:08 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Mon, 16 Nov 2026 13:58:12 +0100 (CET)
Date: Mon, 16 Nov 2026 13:58:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	"Dmitry V . Levin" <ldv@strace.io>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	Shuah Khan <shuah@kernel.org>, strace-devel@lists.strace.io,
	linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/2] ptrace: reject out of range error values in
 PTRACE_SET_SYSCALL_INFO
Message-ID: <avr936G8fLoPm-_E@redhat.com>
References: <20261115152703.416254-1-renzo@cs.unibo.it>
 <20261115152703.416254-2-renzo@cs.unibo.it>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115152703.416254-2-renzo@cs.unibo.it>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 11/15, Renzo Davoli wrote:
>
> With is_error set, PTRACE_SET_SYSCALL_INFO passes info.exit.rval to
> syscall_set_return_value() as an "int" error without checking it: a
> positive value, or on 64-bit one outside the "int" range, turns the
> error into a success or is truncated.
>
> Reject with -ERANGE any error value outside [-MAX_ERRNO, -1].
>
> Fixes: 26bb32768fe6 ("ptrace: introduce PTRACE_SET_SYSCALL_INFO request")
> Reviewed-by: Dmitry V. Levin <ldv@strace.io>
> Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>
> Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
> ---
>  kernel/ptrace.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 3f2fe68ccb14..1ffacfcef8d4 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1111,6 +1111,10 @@ ptrace_set_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
>  	if (rval != info->exit.rval)
>  		return -ERANGE;
>
> +	/* An error must be a negative errno value. */
> +	if (info->exit.is_error && (rval < -MAX_ERRNO || rval >= 0))
> +		return -ERANGE;
> +

	if (info->exit.is_error && !IS_ERR_VALUE(rval))

?

Oleg.

