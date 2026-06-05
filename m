Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFD73BB67B
	for <linux-api@vger.kernel.org>; Fri,  5 Jun 2026 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780675139; cv=none; b=H9iT5Zu2xfzDERdOYYqXpmgiJT5VzjemB9VGgRCXOTX6efMgucVzUTB4R1OHBR/Z5iTjBcTA79nxK1if7bXtkENUplY4Wr5xgVMcF0FOI8JrInSKcHKKXAC9xTVvRSe4dok/1na7YekCTZWCIrN8Vd9EHFBQf0P29d+x4Gq1uWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780675139; c=relaxed/simple;
	bh=cHDeiU+5q6zHW354GymA6FXFmgmlOGfgwP7cdr1ffak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FWV+YYuo17g5E0HiQVh02bbXHGOz+NmmEBnJToQBLbDvof2Db2Pae+bxOAIolYuegJpP7ROdvAyBo9SfFLVuZ3yYZ7/Y1OqpCESNJCLmPjuH6vNiRBj6hLt95VWh+JtR7tevYAY48jwAJRHYYTw4YsPNiCymA/wFpxbP59JUT3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fsXgSZLb; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fsXgSZLb"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-becfa735b9aso295980766b.1
        for <linux-api@vger.kernel.org>; Fri, 05 Jun 2026 08:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780675137; x=1781279937; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OUZ5QahFiUWTYdBZUTA5YwtlfS/dH2OxVTaDuMHjYEI=;
        b=fsXgSZLbRW45mloYb6Yd+DEQtA3Kxg3kY9bpksU5itbtoudVwrCgj31vokqSDiFbTz
         xb9iTJCFFhdbJL2c9I+z23WgsN+EYza8AWjk6H2tAk/MIbmb//M5hhynpY1axkNrJidE
         TdF3NRsJP1EILxArYOrcLWYn6F5ZEI75EFjU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675137; x=1781279937;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OUZ5QahFiUWTYdBZUTA5YwtlfS/dH2OxVTaDuMHjYEI=;
        b=OQvu3FHiefkiUBgVYa2bzEQv8YCBeRxwkzUashwQsLL8c72xsCtc92FIzQNLhkKnWU
         7I+zDYyP/7NlrOLZbOQJpUESfeM0OHeXi7rVQ64yjd3dfkvzrLIScbG8t7MWKKqpY3C6
         ITMZ9/BT1Q+ClRmj8n0Lo/8fMrXJhMl/zfP68Ee7KvQYjecGvIQe7QtuJ9w7ImfMfhyj
         wvoMF7l0F0gqvZPeX96dRR1THWu90+uvRB/uaMKkBBOapvwiuJVI+FcMiyFZIcWBBjJV
         LfqROaT4Ng6RrDHZuoY1fUdKns7MS8Y3WNhE+PaEIOKVfoBqM/o4s9QrU6b952r2bDW1
         dcNw==
X-Forwarded-Encrypted: i=1; AFNElJ/aMRZ/FSY1Fdr0R2WckSmlOpIzDL/ns3oTbNuQKm3/8EOwAWJe6tNqHETxKkuKCcmTWz97zrXHYXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNyuQoyQmKkd0itCI3XmUyY6F9Rw9meiN1tRh9xILHIF2axY8Z
	/2MEsGPHQ8bixqc9oti/5acyHRge8vYGvbksnFh795tLeZz2V632+eQkV6TsrTVS/90o708c6Eo
	SSsy2br6JjQ==
X-Gm-Gg: Acq92OG0tLANmPhbQmfsfVn+9dehHHIweSRClOivI5nsZX6ykOQWuq+Q3nEMbdGJh3R
	2bPcVucP2IeEIECeQApat0TGdY11W+zYtufI/q/Kr4kxLdt/knoCZ+1UObyn18STC/Ul+fJfVHJ
	m7b6IqkKB9/wZZgZ6207zCsuB/ygfzxsWkTJEJO2eeic59rZ0z16zwX97QIaMPqQVWZ9PSf+sBj
	rDkELPyFPTID413nppI+fjuYgqJNRtUwYGr+2fHjCbAiuZiNQ/flkcOy53CsYkg/kOK1lAfTP7b
	cXH6C11Yt/cEtJVVfc/QcQTttv7S2Ssuxwzm6ukqW2dY9o3A+osNrNiFlUn4NxwZLx6FdbTSLAB
	AFgQSRdlsdqmCChK90GwRTlBCVaeXWXXeDXxdODzrHrGjgr9uNlaWjH5ket0QfsjnQsMHu+C9xs
	e7rGGtzBqYPdHGSXORB6LyzZJahNNLjASTro+4CnqFmw8i/KAsTfPK8aiB8NtIBwpH0xox3LApZ
	M0Uwt2DrQML70X5F5ZxCg==
X-Received: by 2002:a17:906:c107:b0:bd3:32ce:8902 with SMTP id a640c23a62f3a-bf37390389amr244610366b.39.1780675136867;
        Fri, 05 Jun 2026 08:58:56 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0558f3885sm475327266b.54.2026.06.05.08.58.55
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 08:58:56 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-68bd167797dso3173343a12.0
        for <linux-api@vger.kernel.org>; Fri, 05 Jun 2026 08:58:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/gkQqpZi5wfWWAuL9mUnFI4+qYZipfetgyUarMowzg+FDESnSZUyTbhaOYpmJi1VuP13aAEmQJ4vY=@vger.kernel.org
X-Received: by 2002:a17:907:a03:b0:be2:dd37:facd with SMTP id
 a640c23a62f3a-bf370e6211cmr221318066b.20.1780675135190; Fri, 05 Jun 2026
 08:58:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
 <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
 <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
 <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com> <f1c7fbbf-5be1-48b0-8927-2d9b75a35816@samba.org>
In-Reply-To: <f1c7fbbf-5be1-48b0-8927-2d9b75a35816@samba.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 08:58:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
X-Gm-Features: AVVi8Cf0FjZlqJePEzD8bhzCDc_NK8sni3u4Z9RMJefCrCHFLhBrwtWwfg4F_Wo
Message-ID: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Stefan Metzmacher <metze@samba.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Jun 2026 at 08:15, Stefan Metzmacher <metze@samba.org> wrote:
>
> It means the most common workload, e.g. a file only opened for
> file serving (or simple opens in general) would still be able to
> be optimized.

Nope. If your web server opens files with write access, I'd be
extremely surprised.

And if you don't have write access, and you're sending out data from
files you opened just for reading - the onle sane case - you hit all
the existing problems with "I can certainly look up pages, but I damn
well shouldn't pass those pages to the networking code without copying
them".

               Linus
