Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795185362;
	b=meIOyNxrZlmgy9PQkIyaxGhK3NkED+s6fUGLQTE6BZLSc0/hEcR1TV72/cZQeilwQJhy
	 iGAZpdfIRV1ZIfRhgQ+zrfGLPUoVJO0G7IKFmCaOFIxppLeLQMqbs3qeqWKAHnffxniSw
	 bvux9UjCHfDhqQqQQXkdp7hXiXHBQyuE+hvz4JnJ/ofVnfIsWwQbOK5Qe7k8261ukFTJx
	 h76YwKQjX4zRt9yBiYjc8OHiB6ZwL5EyQuqglPQx5C9BC49kNQHi3Kuu0S0UYprfene/B
	 VxIGGmy0gYhRraeBhCMpilu967QtTz608PZYb7GusvAg2c4tlHcCQk7AZK/Q8QHX4EA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
	b=2/NcNGK6ygxigiIyPf5ja76GRKDTermwugY4vpOQ5It7OGN2fR+HQfRQCnS9BdhN0tSY
	 Hno1984zeAHNE3B8bvDWn1tTPJQM4y4FeKPdKRX0VIG2MYVJqpmnb10RyYBmKI7+Tqigx
	 ngOtFbBjg9sFZpwhPr0feACShVtHgjxEYTZzmsrrlwvqRHXGkz7BArbX+AFNqndII2aXM
	 Qym2on0LtxB6o1Rz9p3cmZkBVLCYfRf30nq+ETsJoE0QlpSo0B4IgRjq8V7hsrsF0YYML
	 vXsMmvMYV40bkiDaob+sowZI4Ryjq0xzhqgS6DUNpz/E2F15nx0zvGmV9BePQ3BF/Gg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmlktTxO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5C0606A325
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 14:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E5C0606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZmlktTxO
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so1691252a12.0
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 06:36:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795185360; cv=none;
        d=google.com; s=arc-20260327;
        b=emTIOE0nkdnn99cGwkCvxBE6zR64YKdFHX9eS7qZMENFIm9fmv2zF3BmNeMitTgMa3
         YZvXZohACcoSN2JAz3nAJbvLDmAZ2VCJcsMK9T/k0O85U1vLZR6+EM4+RdUHjPc2SaLG
         p1DGS/KB0zH0Gg5jClWbbX3jgdAd+OTBlQD8XV4hKkC38B2RBiHEyvOcAFIIM93WdmPz
         bVzCKpdUtCdsQRtb/69KqLT+iOc970rzJCIobtoIJw25BnpBnmZZ4OY2vrTWSDpsGRPr
         IS/lef1Ir2/vgrbtNoDL0KoSLt1weQZt3ONhg+tgX1/LehqJZ0qo3jZnqbBNeinBh+7g
         KOqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        fh=kD04F/E1ARn26c5SSEucTehYBpVGOsRHpQiCC+6wPbM=;
        b=RMps1nY4YQnn/w1H3fnTGhHtZlDxudwzrN68jddKG5HuoljxvWbRWO+KP0ezcYQ0aK
         9N/5QPjMkhClZPAOxTMq44C2Sdwrfs+/O0FTFAcZzvSGuZFKgpcfQZaErewtNf4MqYQe
         73UXclFL9B+VQazTYK19o9VnIqyZjiFMv0ihCp7MdQwBegkerlDGvMZzW9qeI8ooDxlT
         Sn9oFuihs9ri8Qpe45N8un8OLwfWB6bkFt/8/bRRXv0IUBsABQnWNh3K3vMlGU30pVrh
         LTWNENnsAlvIByghe7rTlTU/u5p5dxjMszghK16e/5hhNS+L5TN6fPJWVS39Mg8IbGiV
         DjoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185360; x=1795790160; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=ZmlktTxOJqc0gUgZkQM8tVXb/Y0XP5vIjBlg31tczPuc6Q95f4xzDo/jLK66eDcTRR
         yQXNy421kiJhT7oH9vLVwxVroKGeg4J9z03nrEStYvsVMA3xboXgWcwA2+JIMTGITaZ1
         038E81NLDLzYcW4o0qQ4SonrTGr0vzYZ8MzGW8HkM5d16we7L+/rT4b4KMUSsfEHVibx
         uS8nmmaGxZ1wTgmldg9y07wcPtmMKFly5bIu+HgpUAR6RPvU1IG7Ma4/oDa4cuosYPJr
         k7UPz9VVFyx4nQjmDqMOy5HZQrVCpdYWfBCELvWA6ZL08iBITG0L9mhiTPT1o4IF12kK
         cWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185360; x=1795790160;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5uzUR4nNL6/gBE9a0npJTMPxychcKuNTT6IfVRtsMA4=;
        b=AaFCb+uTvoDL9i4ohec0P34OKl+e61o9qOO8YSajEF5npNEBQ8N751pN4NLtk8B/AD
         NCw8e6MoScu1j3K3+RUn+XPd4mweNhiwqO4o0GOBhrk1W3W0hlcuPMQvFsH2+Dck2HwN
         fsB6UH29CljWxDySRRpwYJaCrGqflKtlbSTyKPIHKwozrZtfiOIBOSZTyql7hZUJsJCe
         7ibHQRHy+Fgnt/K8UWSfBl2IcezzzdcbbutYoS3FWU9RBECmCrgkvIwhI7i+GoeQLDN+
         vkqhOFw/N2ucLCpbERy6NOA9WxsHt/sKa2g3t9BFoywxdAmu68Knpepepu6S7XdTz6j8
         CIHQ==
X-Forwarded-Encrypted: i=1; AL+hErEdAhBXhh/zleZIucIUNiMsv1nKfxhKye8MJCwE3N9y4ANWmO3uIspjNoXb5NrDecF1qXozMecFS5g=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Dyd5GQLAXP5yWCxSgTERPTJaHLkUonMiRlU+ousXhuMVrHLdI
	HNxeTCTSJS3F7YYqqQujGhjbaEl7xSV83JMuoVTU5kU+kIz/bY4+MZ24l4Gsxiv+3FnY437XuxX
	6w27TdizkKV/Md37s9XVRVJhkTeVhaU8=
X-Gm-Gg: AZFdTZeKt1ZAVqxmjHlkRTosYhW7aEoEM/RPDPi9lwLNdad8jpKzqDZREhrYWke+ckz
	Mw9IAe1cs5W5Dv9TrRqnLQ8JXmoQXuUVSTGRXmKhW3XNzU8Pnnn9fnyjDB74jRCnmpFFugahrxp
	rvKYGmYFufn/GCWsfHieBKmGZ6K7846hJVIigZFyrcAsI3dXGAIUYrEtgfPhCLMKY5Ojnmo75WS
	dRiKHKVoxpG4LoarowOPTy5pL3rgVTGVPs8Uj2AtDs5F5+H5lYzINJ+0VzRbO9rfJrr+UcSZRoX
	G4gnbyBhBq73Pp+JpMMoXiN7y3xIs/J5amneFnuEE8r8+9AVLGg1TnkQQdsmyleogKYcGSDqw8N
	L2qg2oKMmH6lYhekZR6cJxXUhAIzm4GPwVpQQYr8nOQTJrOTFvqZILVAacPtOXbzXAOq93g==
X-Received: by 2002:a05:6402:448e:b0:6b8:7769:ffea with SMTP id
 4fb4d7f45d1cf-6ba37ece3efmr2475801a12.45.1795185359456; Fri, 20 Nov 2026
 06:35:59 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <av4Hn9u80fs8iHZ6@dread> <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com> <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
In-Reply-To: <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 15:35:47 +0100
X-Gm-Features: Aa3M54oxXjJW5NIYEP5VP8q0nzSYgFKLfJAws7Wa7snJYDGBmmJmUUUXbQQ7PSo
Message-ID: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
> > With non-zero xflags_mask, internal contact masks
> > can be used for -EINVAL not for silent ignoring.
>
> What do you mean by "internal contact masks"?
>

I mean that users do file_setattr() with a bunch of flags
some of them are just ignored randomly without any any way
for user to know about it, because this logic is some internal kernel const=
ant,
which cannot and should not be documented in the API.

Thanks,
Amir.
