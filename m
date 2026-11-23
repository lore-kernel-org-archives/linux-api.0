Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393279;
	b=UBxwHE5HeBUyd+uQc7JJS1+NJIMRrqoSGv8wHHv3KnNcY60afUE4UTxnR+WC5EMPRyye
	 4FewecnqULzu7e/LE7/MnZ7Ll+8Ujfab3P1aoPeAoASkTqh8EVC+FBU0ePN4XxxhwJ85b
	 rWfr2Ux3dRsO2217ebYg0WJnYcs3NAcAHgCiZmgvxh5p+/TxoiFi4OSuyvbV5Ojp21MbF
	 9lNtHaDvXdtk+Pg03TsjLVMZzqO2satIvZdIKIj1MZFP3rm7IA6QJSQ/3aY4tqKtaZ3nt
	 CB3So0aNvMYSZHDqsTpxwjO5p7IqoYYIacw9FJHE4ZOCP1fUdhjAFaiIlNIuroFfTmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:Cc:Subject:From:To:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=KF23iyWwR5yZnzbUCvNMaMixSGrIyVPB1oghCsOfI4k=;
	b=OOBcBOd8uwKyjrEaSL7lLLn+9m9xar4wkgCp1G63Fvcmy8q//iFp13VWN6lyw9UCI7gU
	 PZMTFDCeiWG5Li2QUZc8ftPVIp3kiU63nb8uRP9zaTZU8oxvnOXY7k3bYR2FGzVnR1imr
	 oWhftS97z1O5MrnxkRtp1h6dBU46sa3re9YPOQdtrRXOUuK5hh8XTdsga60xEkkA+Gxdf
	 mnpUMgdtE9+G9Meo6nRgcVJqiGAgWR6qv+TQQDoRz5E3xUQ5pAO0ClDB26Gg7SFTqNC2A
	 d0kqrwwEwQHor9dSQM2k/645ByibKuYXVSAF+x2tgButiHv4CuRqA4TU6gTrNzu3Lmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ui7qLXEe;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2558B606A327
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 00:21:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2558B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ui7qLXEe
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso970062a12.1
        for <linux-api@vger.kernel.org>; Sun, 22 Nov 2026 16:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795393278; x=1795998078; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KF23iyWwR5yZnzbUCvNMaMixSGrIyVPB1oghCsOfI4k=;
        b=Ui7qLXEe5JZSNGGNnJt8YRoCIU9BozHUuGdwiGGRpRdbVOmZeySJsVDdurWv9z6VuZ
         VmOigNcxpt4gus56H5t3tfeT+jMthzm64QEJc2zAee84tuc3roRSTwD3Kv0m4dUfr0F+
         4ugqeQMPjbgSS4cdMlpNKVGn/lbd6gTEqFW9TDBlFLcgP5yn4h8g99RzjC8XXY/+LFBY
         IwZpe4ZfiOfxC/PDMkHtsl7/7xATK8AceJkZH0IS98SuaBuBBITDhuqsEsnfsOQEZ/PP
         u3myvmJEKPylm9aDUWQ7+IckA8eVXYDNm+iIKJa0jJHfttZyD/rjsrlkR7z95OGmKQPn
         RqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795393278; x=1795998078;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KF23iyWwR5yZnzbUCvNMaMixSGrIyVPB1oghCsOfI4k=;
        b=YojOdTKJW0/D4CTRf12qGq77i2OP37tlDXpsVbCF5VUnbeVLphZ+INYJXV9JKQmfYT
         jINj/vJlNe+bnX66sH5UQnQutKOo9+Py1Pg0sAoZ8hN2uI6GG5XMMbymIB/3Eo/E0wOF
         qr3Ne6/Deh95CQZyguAtTSRE3SX9sUeIHweIuWtea/fZ2k35lER58YIvrLvnYfL8wE0F
         Iazf/VA3AN9S7n0z1IujkeOWCdOBtomx9uvdRJtA1PWKQpbgc+IQmL2tG8STMpxXGM/I
         zYo04uqm9fRmlZVgwUXhW+n/8mx4WeSSNaNNACFRQjZXMM600RzLwYjAT5635QR1t1eb
         JHbA==
X-Forwarded-Encrypted: i=1; AL+hErE3ulA8Io2CBqkZEPyneX2B/RDPwcCQac9bX+rT0LyaHzm7JRlcYOSwJkbjzoIzviS64kNfe8nW1Z4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+YL6Gp0HT7OUdwRWzDLsxroSgxfyMGKMjtSIl1SMwPLdI0F/eq
	vEcP2f776JaVu5ihElPYywF2sBtW43BbvYfdL9yKYi+sfSIcAaPLrcpL
X-Gm-Gg: AZFdTZd/sL21oCXE8KWB1BYnZhugM64BYUimC98XdGeZrCzFjX9Lm9CUWxWqb1wsCEX
	ff6uxEozuHHAbAm2aTrKQ/QAoerQMuLqfmSOBOz8P7qrytzQp9FfPQIy5q713ARpV0pVLVBXp0i
	MMzaIzkZ4gGvtUEhoQ88PEbJ2nJmrIdB+O5767YjXwjoXGtMIeVFQizV4ZR7yvGFMkfxefkN6T2
	7XuyShUMwFG0FJZMLH5cxcenGERwrZW1JQ2+8lIZPbTcSa+d3Cawr3ZoznRCmy2utgH8b86h1/w
	2BQ37mIYbPMzm4W9lsrDsCnKSbAMRw3/XB/FdxolGF/DRQIhOwGiDtTX9K7flAKBv0YXg12Hgah
	j2tRC2I1LDInSR38opRdqZLBCfpV+TzrMTEWuc/KRSWlmWrI/5bgobctXhnPHvO/2tzt/HnkuRj
	KlMz+u1n0Je5NpTwk8tc1Mxj+ZSVOBKLY0gBO2X6Fk0UN54aF3psagePV7havF3rkgi9ZJp1hyM
	x74eD0RUBvWg3+VL3Q7LKa/9E1T6x0chsOSzUVNpvvmvcoRDzH6hRnhME/zKr0wAGmx8AqC6c+n
	cgIuhZuoy18/h33R7V84kzAMidK1MgXgitoAaVoB4VZeDOGfg0Y+9wj4Rlp7QPyY5Rm0E+AHTWc
	gJ6N8M/MgVNDvRr8v3ncKE81TI+6PWCHbQbE=
X-Received: by 2002:a17:90b:1801:b0:3b0:9984:18c9 with SMTP id 98e67ed59e1d1-3b41c8e16efmr9088622a91.11.1795393278264;
        Sun, 22 Nov 2026 16:21:18 -0800 (PST)
Received: from localhost ([153.61.198.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b8733e6sm4860403a91.3.2026.11.22.16.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 16:21:17 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 00:21:16 +0000
Message-Id: <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
Cc: <bpf@vger.kernel.org>, <containers@lists.linux.dev>,
 <linux-api@vger.kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-security-module@vger.kernel.org>, "Aleksa Sarai"
 <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski"
 <luto@amacapital.net>, "Arnd Bergmann" <arnd@arndb.de>, "Christian Brauner"
 <brauner@kernel.org>, "David Howells" <dhowells@redhat.com>, "Eric Biggers"
 <ebiggers@kernel.org>, "Giuseppe Scrivano" <giuseppe@scrivano.org>, "Hugh
 Dickins" <hughd@google.com>, "Jan Kara" <jack@suse.cz>, "Jeff Layton"
 <jlayton@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Josef Bacik"
 <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP Singh"
 <kpsingh@kernel.org>, "Lennart Poettering" <lennart@poettering.net>, "Neal
 Gompa" <neal@gompa.dev>, "Oleg Nesterov" <oleg@redhat.com>, "Paul Moore"
 <paul@paul-moore.com>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
 "Serge Hallyn" <sergeh@kernel.org>, "Shuah Khan"
 <skhan@linuxfoundation.org>, "Zygmunt Krynicki"
 <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sun, Nov 22, 2026 at 11:35 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> v6: https://lore.kernel.org/linux-fsdevel/20261122011809.2667684-1-jarkko@kernel.org/

v7 was sent 18 hours after v6. v6 got replies from the bots only.
v1 was +2559 lines. v7 is +5782.
All six findings of sashiko on v6 are still in v7.
None of the seven versions got a reply from the vfs or LSM maintainers.

The way you're spamming people you're only reducing chances of anything going in.

