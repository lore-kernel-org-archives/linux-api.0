Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795827359;
	b=XA7rQhGOSa/Nlm8O+2gebqps0QxTTzoyO6iMJwjxgus3yv2IWDQkeqZad/xGmJrEB2iM
	 dbhk+pLAX05MjEQjT3yJJZJk1+SMjsAmbBHjQQueyDChiUNbMQSbP3QZusc2XBVDG9d6p
	 Fl926T0Tpo0mSY0qab33G00RSMjgQHXY94vSFvWP6opZ2LttVvOvcG+2BS84ceN+5B6Jm
	 Htx3flpR3bTf7W0SRLhLVLRYuNQXM+QNRLZDjXQtKTO08ufgIPq204NyPt4b33RRzNDng
	 uQ/pzIpqFm1gRxa1IGfi2UVjXtP2vnSLK9se/CTzJChybTg23US+FX+HjOrO+4E8w/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795827359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M4YJXz2C1qqMpFfvawPlwYq2ZIDKs+0ke0HB93yAMqs=;
	b=Kbzws1d6Oa7r4oSwdDtsrfVKVzvnG72ynkhvt9W8/cDi0dUIs8d+C/UhaNCtE/jngHWV
	 q4ocBysL+SvCTQgcrG0cBwdlh5vU7W2+vWiNWl8KiENCyi+SEcFMMQf3AM8HCMaO8OzUg
	 Y2ubyC7JOqBxZTcV9XfcHi17ImN011ZAkQNr+B5+NWz/ad416ca3lwCHqDoHfGweOZsfC
	 EKvy3AuxTzcN6AS2jSmdZu71eI6aoRsXTVYdamsJzH9kF2+f+DahpmH8vkMHFDcPcL0fD
	 T4q7bhdX+dhr5cfv3yKHGfPXCqeFAyhgdXmaLcyL6o9XSwonYkKp4u5kW0t0fqbVjSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=egc5oRyU;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C9B606A31F
	for <linux-api@vger.kernel.org>; Sat, 28 Nov 2026 00:55:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4C9B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=egc5oRyU
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso105798835e9.1
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 16:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795827352; x=1796432152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M4YJXz2C1qqMpFfvawPlwYq2ZIDKs+0ke0HB93yAMqs=;
        b=egc5oRyUW6VFDIcdxYwZDeGVcRPdqVVcw0/9bUs8kD5ZsjJsFc0wc7Ij4lq+IUwayF
         w2XgNkLL/plAb0xjtXjWDmbgHsj8BbN8y5QH4zabvGdDwwb8xzCpvOiS/FFDQ1pAmNwA
         4uiU6YjDORB86waZuFacytNoIhdLmWlhX93TlunzFDHBxP1tk3JWqemA4JUyNxNFOtfh
         CKwdIz1EOzEmUqFvrYxqw/6yXUkip8rv4zUWrx4HDc3q++gCUskaW4sXZoxU4kXNS894
         nnM8O1l8kivUFX2WTqpxfjbMSvlGbzGIvqyGbP1cvEGn8taKbCLd436XionhZ+TbNkl7
         Tb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795827352; x=1796432152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M4YJXz2C1qqMpFfvawPlwYq2ZIDKs+0ke0HB93yAMqs=;
        b=H5tXAufDcIIKkk+jOWKxBB1Ifl/2VjMGbw6Ef2bgX4JSNLxoE/c0vjWD2fTl+bUNF6
         +AgGT+v41KxsP3tbXp1yHHjqrN/n0tOcKDDI92zoxUGqjl7JCa6gA+BCls65DnQgbDFi
         V/x9BYPfa+dW0yH1/DfGoK7Q49EeF2qAt1fGaJlg2DokMiZyKv+HiRMWiaGkHrAAW/Hq
         9FoKU0SQruKEESEax4Hb2jgCYpVMaAXNccPyBc5nFLdlLPntn0QPn7IeAdWEn7MgkUYU
         KS4+pHmXnrM7tNTLCQ5NcUvrqWIMY33ymmEeMLBp0XcPmY4yeyosW5G51ZlgsnWkw8k1
         Sssw==
X-Forwarded-Encrypted: i=1; AL+hErHpd6ifnW7jrcsjEKlLJwg9CL2xMyvspG0QRCI/thBYlmp1mYYG/0Tq2NkI7ztoy9S6Cm/1Hct6oek=@vger.kernel.org
X-Gm-Message-State: APuU4Z8KDMEvRk1vgI45vm5Rjmt1oaoeu6AVoEekWHbiS+CqbVlNapWC
	iglUAMkuFgVreEcJYLU32VpOPv5Kq07UKCPIjaLGx1c64tXenvETYGao
X-Gm-Gg: AZFdTZfeBm9g7WZN3HZfMaCgh9d4Fc0t4L/jY6ku/qqAIkpFTbQVXhG7gvfau1Ukoht
	tckaRkcKJfVGIOGasHTJFJDhJidcxoQYLyejYBpvqLO40nILW21+RHxRx6mJzSaxmtaMwm3ln3x
	HsPyxbpDhkCvAdSFM/ilLdVm1lbdmoisqxnOlev3mzGzbgjSK3EWqNi5DuWxPD2ZPWbjb1ND+11
	2fj3ywxbSXmDCubBS9tG6V1HEkcdvRy3Tqdvqq3tPEPUXNnAwXlttpScPy9YQWDlF/glz4zaMfR
	f9YVGYU723i+hQIgXuDB1O1WgKijDfkMak7y3RsQU0j5mTz1+0Swbs7p642kfdYHlDek6g6pTLI
	727lqA0Fo7BCjK38/PQBbD0I1oRCknBUlG8YZtX0vbqZe1uL7xM2Yw1Qi0+X3LV5Kq4zNIzuxBl
	CxL3VIc+mWgosO2g1MeN0FTUEYeLvNZwsHPwXrbZOMwZYJDlcaklP1DnqbrFc1FHQacKW0a/Hsu
	4c9YGprOiMXEW5EjD5YnhFtVNG8ev6whBaLEpnYPyIY0RVFtXQoTNXbiZXr7b3fYxh8FmuKKdpc
	OMZVhzMsqAVIcFeesqPDUOwHyg==
X-Received: by 2002:a05:600c:4e0b:b0:49f:e772:6ddf with SMTP id 5b1f17b1804b1-4bb8881ae90mr541218935e9.32.1795827351797;
        Fri, 27 Nov 2026 16:55:51 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4bb8538b09bsm1328407645e9.4.2026.11.27.16.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 16:55:51 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: jarkko@kernel.org
Cc: aleksa@amutable.com,
	alex@amutable.com,
	arnd@arndb.de,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	containers@lists.linux.dev,
	corbet@lwn.net,
	dhowells@redhat.com,
	ebiggers@kernel.org,
	giuseppe@scrivano.org,
	hughd@google.com,
	jack@suse.cz,
	jlayton@kernel.org,
	josef@toxicpanda.com,
	kees@kernel.org,
	kpsingh@kernel.org,
	lennart@poettering.net,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	luto@amacapital.net,
	neal@gompa.dev,
	oleg@redhat.com,
	paul@paul-moore.com,
	ptikhomirov@virtuozzo.com,
	sergeh@kernel.org,
	skhan@linuxfoundation.org,
	viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Date: Sat, 28 Nov 2026 03:55:41 +0300
Message-ID: <20261128005541.873229-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
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

Jarkko Sakkinen <jarkko@kernel.org>:
> Work on this feature started in 2025 after reviewing David Howells'
> container object patch set [1], whose underlying mechanics made sense to

> [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> [2] https://lwn.net/Articles/1102593/

You put wrong link in "[1]". This is not Howells' container patchset. This
is Howells' fsopen/fsmount patchset.

Link "[2]" seems to be wrong, too. It is not something "earlier", this is
very recent LWN article.

> While the patch set is manually written, the original motivation came
> from isolating LLM agents

LLM agents are too strong for Linux containers. They should be isolated
using VMs or using some Linux reimplementation, such as gVisor.

Bacik said that he tested his patchset in Anthropic. But I think it
was tested not for agents themselves, but for something else.

Anyway, I suggest to drop this phrase from your cover letter and think
about some other use case.

-- 
Askar Safin
