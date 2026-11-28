Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795830680;
	b=0jF7mea0CoRydo/+hmb0p/1BfUk7BMpyLOcL6+MWra9XvY/KhDp5e2fpMk+lkU+cXc3K
	 C6rByPzMOHTGgyOeoDAD770lE7mBDkfCQVTxrYngaKmiZ+2eEdgbvPpRVsclY05DqjWeQ
	 crbLk9G4QnfjrK3rS+ad5NsLaWyzmnim/EegUI5Dmd2qcg7jcoE1DIJrP3l1VxZWmXDP5
	 onE9vz1wQqrey6YXYgIuwFriX9+2/owKCwCzSiOzqNktCKuxgXnALxCDo7Fzpbb1jfwS0
	 hQnsJaKrL9wgcxrolHZci5ONX8JycNi7FYvjEiYZsonZjdm1osejiYeezWEvQaZO6ow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795830680;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=M+kv6M/MroHXNub3A7PdHe23Ap2KXe5JLqM78W2xjvU=;
	b=fqRZ04U+QX+6/ZmiccpZiVYlP/xHmDaglOnnrw02XCzImE4VgG1uHnKndkiyTLttIC7U
	 TeUtjrZ3EIr2Jvj311rKioEWaAj3e1jCuv4uf7Ues2ch7/QuFC30k8zDUdTTdxNbtMPAI
	 e+pX6C1x7HXA+PUjENG3MsadQpRW2TnjaIcqSNRBCTwV0H086UXaeEMZ3IBDtI3eqO4jB
	 w4uuUShqQzgiZ5m4L2xEy9lWHAHpJXV+XLNyU1icbd+GbwgNrVGtY9yMdTuoK3tPDHEC3
	 P1QAc8NwBJuEmQfh11UyAdzQ3wMG3FSVtMjlAdF0zPV0xc/bHQTiOopjGqTYGJl9bzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XLosXPN4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A216606A321
	for <linux-api@vger.kernel.org>; Sat, 28 Nov 2026 01:51:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A216606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XLosXPN4
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c5127c7abd5so1322752366b.3
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 17:51:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795830679; cv=none;
        d=google.com; s=arc-20260327;
        b=P+ipgQwuGV1WORmfNnC4KqiTAkjAtXztMwamCtVadKq5a5N4V5m8pHDbHjJbdTi8+P
         vUTHv2R19WoWg3hyJB8Op2DWd7nvhIwGX4+hnWUxpom8QoQqif78Q0L7N+c9kQo+Fm55
         N5sD2ktI6zXzYaYxO44jdSZNaDL/H2pAP39FSk3cXi6HIBJDJBmSgkikrvZEOyyhcPiS
         WcVZkad0/GFi5pKyz3w4D5oiF4xMCpJXaboQtgfY+zVkoEL8iijmdxo+I0FTrscdJOuM
         1BWX/xcKq4ElExTp53g/OJMquY49JjBHoI4dwhYxf0/51uV5a/ZWSffeojueolgO49nd
         u9KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M+kv6M/MroHXNub3A7PdHe23Ap2KXe5JLqM78W2xjvU=;
        fh=AQMMEQnlNFUucnQpUNTvcshZzHtliZtPDXDXAAHgu90=;
        b=aYTK/KGeFquj0OmHipYtiEmvTDaFD7RVNTgnj/r3bPKWiz3gY4vYPsI4bUMXTigDvD
         JpxrwGUoK65jUAebf4UqqXBSdjDUyx3OT5W8O7W6is4MGb9h3JNzuzJjifrKnT7GdwP5
         fo/endu6FHF+NxOTKH5FI06SyBFD/dsy4+umxu6G2SQbn1vfNLqRr5KItbyjAMtrxuQ4
         ncAZD6wB+xQPtnqjrJYubBcmOfcEJDWokWX43J5/XPLWj0yuDhx0JneyhUFHHUkDbqvp
         Z40C6Q5Sq2N4EiWtCAKmHXsj0Psb+laYc+6dv7aVxOhre0F9e+L8ULNMNMpxQMOAoaUh
         R9tg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795830679; x=1796435479; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M+kv6M/MroHXNub3A7PdHe23Ap2KXe5JLqM78W2xjvU=;
        b=XLosXPN4XY1X7SNdxkqBL+OmW6RyoS3KUKiJGN6VkhP3L0yhHIWAe9gfCGB7c23JLd
         lHNLLgTgGaPV+ANwny7auVJWhylTPy7tn8Qbd1QmlxO7gDNExEWgSGEhy30NAozJQ+8+
         +xKv07hbVc2PMmC0nQwONM+Snu/fB4CVx2Zu1RVG2ABrNV3bydSS40OT+TsJEZK+JELi
         MFuPTs18dGi6k3X7RKL9C6rS6PY4lyASR9cQGoX1ApSJvF/sCt8fWc54v5qN8Mgd+424
         mRGAbRe9QyqlYYy8UZHrD36MAiba/qdVjAz2hG+uSVag6rBQPtZrBpUV+D6X33j1iq7k
         51pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795830679; x=1796435479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M+kv6M/MroHXNub3A7PdHe23Ap2KXe5JLqM78W2xjvU=;
        b=LoZBT8m4VTGx2S6sbBoRjEe4VoSB8EVsuONUdCIToKaUqQqQSqc0MiGePIXVyqk1KC
         Cnjv4EruvLx+1RLHcBXDSPg+zNAuJIbm8N/odj9xxHvlM11D+Wc5+ymZC1gsNF3EgWmW
         rLHH25WWMw1trdCsiPYJDfRkph5wXIGsUtiY8jlcnMwQgStrVtkjxee+rO+GwC5T4H+g
         bOuJDyuZGyHkXxPe3ogyAPTXa271bBmxUnIl1d9PMS8tEijqQpTtmR10/iKKja9RhRTw
         D9rypTeQybn+UC8wov/cO5ys11nurasf+AI+lQ6CqT7QM8O0bfItj/Ahm86iFLLW4Ohg
         V2rg==
X-Forwarded-Encrypted: i=1; AL+hErG+nBg6ndTalVh599jTd2G67BLzvY0sEeQQ6mA+Geief6dAbKjPnszk8eeHg4/cvROWcmvMnwznQls=@vger.kernel.org
X-Gm-Message-State: APuU4Z/eYdCeLZxnxeF4PHk0QGOCVMMb2iPNp/HXWH3tJKVdSWuBRnU5
	YKQc8dVPyEUHDVB/CnnPJixoZdw9nZUF/uiOmVQThfS+8M6sXR1AX07Dt0CDXK1U6d5zovdXPIh
	XwxhTtj5BlUozNXJwwyhEa0SlvZrXQhQ=
X-Gm-Gg: AZFdTZfdsYBb0To2jSSpAQBrwymihsSJGOwt3etfdi9n/fo7GQMT9nhM50j8zM2kwYQ
	qjcon4lzBRFN9ZQwapWCcbDu6ungbimUwIihjqx96jIsmD2R4R2E0RGgKfcYLfopSmJCzfPMZW9
	ZSMzp6p6ASZkh9q+TzLfdjf+upAEqIwmCyt/byw5oSMnPauJ4JjR/OrW7zNKXoVMFyWUCyo5VsG
	Duh2mMAriLsO43lEA2LOpH0o3TkleusUz17xAYUiiEsscJM2rx8AmbHoya/QTDkEjOkioTqKkpc
	ubSj3s0mu4HpaCfOZOwLDJnn8Tbx3xIkpx+uwZjC0jXn1MSC5CTnwIdfChwcuear+t1erakJPSo
	w0UjElvAezqwtuDTXuwcNHOTlNAKwrxeGFzGI
X-Received: by 2002:a17:906:fa82:b0:c50:4b6e:329 with SMTP id
 a640c23a62f3a-c513a5eaea2mr1724212966b.15.1795830678877; Fri, 27 Nov 2026
 17:51:18 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <awOQDOel_72Xwjm7@kernel.org> <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org> <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org> <awoO9R7YF_5_6dHA@kernel.org>
In-Reply-To: <awoO9R7YF_5_6dHA@kernel.org>
From: Askar Safin <safinaskar@gmail.com>
Date: Sat, 28 Nov 2026 04:50:42 +0300
X-Gm-Features: Aa3M54pCi2p8qLdocdLXd3OCMkn8g_j_UUSVEEax8LAEOxwj1oFmxFAoHI8_4lc
Message-ID: <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com, 
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org, 
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com, 
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com, jack@suse.cz, 
	jlayton@kernel.org, josef@toxicpanda.com, kees@kernel.org, kpsingh@kernel.org, 
	lennart@poettering.net, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com, paul@paul-moore.com, 
	ptikhomirov@virtuozzo.com, sergeh@kernel.org, skhan@linuxfoundation.org, 
	viro@zeniv.linux.org.uk, zygmunt.krynicki@canonical.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 28, 2026 at 2:15=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
> thinking more sequencing than data structures. I.e. I have a game where
> I need to end up to process creation without embryonic state, and add
> just enough weight to kernel to support that outcome, and that leads
> to ~2K'ish LOC of extra kernel complexity.

So you don't have embryonic state? I don't like this.

Let's assume the following situation. Userland's PID 1 is already running.
Our container manager attempts to spawn yet another process into userland.
As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
and then execve.
This creates time hole when there is process, which already runs inside
userland (i. e. its PID namespace and other namespaces), but runs
container manager's binary and have container manager's mm.
This invites for bugs. Other processes, which already run inside userland,
may somehow take advantage of this.
For example, see section "CVE-2019-5736 Is a Very Very Very Bad
Privilege Escalation to Host Root"
of https://brauner.io/2019/02/12/privileged-containers.html .
So, here I like embryos.

--=20
Askar Safin
