Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C350627CB02;
	Tue, 19 May 2026 20:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223633; cv=none; b=iRK2Zh1mlP2+M5rzu1oErqd4LAfWsouP9CezxCQ0F8JSuaK66tJF/qUveS6GnTmEAwTLT0P4j1Q9NB1N2WXseDH/YqYUZQoQefzPafuLFDZE2WfBx6D4F9/J3LBlkQeUrsTd/M9bHBraNB6EN2awsELMTkxOzRQ1BDxDMI6MKmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223633; c=relaxed/simple;
	bh=D3sY2L4Jo7pnlKUkefYee4ryb2qEYi0Dr6JtJVTiBoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bOSVvSy94tfvw7CypSgciDSUm2nd8Mb2KGJx2+wkciaixfUTHSzG1m/NNBSedgl3cS2haqs/FptGxnVerMI5Uw0/nYFZZgqhKuiRMPXWFTrS2h8NTYBXEkExZO841NlFJ0ANJnkQ7lH+IPJa4pyl78synIdKzwcPzCtTkifgqk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=VB5BaOgf; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="VB5BaOgf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qcDxZYCIBGpWTE6wZCl6deG1Hv22DQPSYPWGbFcmqK8=; b=VB5BaOgfyrAXSSi5m4EFQEb8Aj
	XrLFenIf+dBNd7uulUxeTn5poyR8aKCBNf54YRhg9Au+AIoSbEmXOo4Fy1ZLZhY2qvy3C3mwRDOkt
	y0HRmTY10nZdGq5TMRO0WebFuOAfzbU+/InME9Y662/bkW+dkFZ4hvnmyRpDuiAT90FNQ3ZZIt4Hr
	zIErHqz6AVZUyvQ9cVL3e6zh5WjVNIaoPDxH/jDidiPG+Ef2BQP7jHMK81OWSFFqPnqe3nJb6k7pe
	gQKyEmnExlD2O5yXc6r+6F5wrMnQHtCD9x3tZYvjNKzcITGKVUjFoFLyhOFr7Bq/WGPlDaDSV5QWP
	SOzwRwdA==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1wPRL2-003P3J-6r; Tue, 19 May 2026 22:46:52 +0200
Message-ID: <186dbf31-e5a8-4bb5-a392-0bf3cb4127cb@igalia.com>
Date: Tue, 19 May 2026 17:46:44 -0300
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] string: Introduce strtostr() for safe and performance
 string copies
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
 Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
 <20260517-tonyk-long_name-v1-3-3c282eaa91e2@igalia.com>
 <20260517223419.3262de7c@pumpkin>
 <d4d6cf61-568e-478e-88d6-01b769d7eded@igalia.com>
 <CAHk-=wgBdK5iRf1NdOuMT0-+sjxUc8QAU9vr66jBBzY6EFDtUA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <CAHk-=wgBdK5iRf1NdOuMT0-+sjxUc8QAU9vr66jBBzY6EFDtUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Em 19/05/2026 17:37, Linus Torvalds escreveu:
> On Mon, 18 May 2026 at 09:37, André Almeida <andrealmeid@igalia.com> wrote:
>>
>> The problem is that as I'm expanding current->comm, the source buffer
>> might be bigger than destination, and when we truncate the string, it
>> won't have the termination NUL byte. So we need an extra dest[len-1] =
>> \0 after the memcpy.
> 
> What's wrong with just using strscpy() with 'len' being min(srcsize,dstsize)?
> 
Well, I thought that strscpy() was too expensive for the trace use case, 
but I'm happy to use it in the v2 if it's ok.
