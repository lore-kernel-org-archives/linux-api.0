Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB4936D51F
	for <linux-api@vger.kernel.org>; Wed, 22 Jul 2026 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784731907; cv=pass; b=TSqIeMubLGzileUAtNJw9KkT0dYX5+EVaivSfcu+bvH62LrY150d7UqiMqNtdVkHCVAStJGlhp0tl5DnjZFFGFuObpQFFiAOnuiEhIt6jOIU6GwMMeAZBApcE2vzcpLWQ4AFiHWc28vd+TUnpfP7UY9TaDo24yydS4LUiLIiUZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784731907; c=relaxed/simple;
	bh=lV6eh0HXQiCHgDZYVsDh7LIE6SZj6q5Drxem6nRIY48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PGZm4+NR5FfLgkiAVAWkd9c0aonkprt9mqAVg/KhxG3toH+1kIRzlcY51Mfzp4BfoMR7DP6ItpImCPkwFi7AQZU9JoWyNYWzTwIPqvF/ylc5wnDzg4iVS76/d+oKsO7t6bzVhw9Zx5UxJ96ufk+EPWu9V/HJc6YIp11jpVhDk7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=I2dFglAI; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="I2dFglAI"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c966b9ee9cbso7422463a12.1
        for <linux-api@vger.kernel.org>; Wed, 22 Jul 2026 07:51:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784731905; cv=none;
        d=google.com; s=arc-20260327;
        b=F3fKsOdtuHTXZkAk/YuW1Fd0yYME0px6KDJZn9yDKyuo7ds0fsNxelp64dB0nrhDLW
         8l11DHC42SUdNyYKUZ0fEt3N12vWgWmmR4KAZezQu+whmhWsAoQ9K8/fFgRALCHs5h3a
         7FDcMHfZ0W5uFXXa0BBpX8lDt5HNPUYs3Nb7CSnPwJ18C4eB5X0be6AgwsjTxw2Koac0
         TeoA8F0mOss1JyaMvSI4kk8MGrmAJFcoXSkZsuUVz3Qbo6o7tNadSNe6x6m27Got5ofZ
         ZUI5wISUxFrbuWEE3I9XhMaZ6ybcNfEay7oze/1gmLFjIFH+/Dzq82bNoj6A54x5z3E0
         r0wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        fh=5Njp0+qiYOOcaKhdUT+x6wjKtGCy2ummhfzaskeqVh4=;
        b=ldAfX7WV8mrpGPdODY0zoI8oWGjQJPPEKddjtwWJs6xJNJUq8PQOb50FYxMJjNuMg8
         Rp5fVvEQjHN86TzgBQXD0tKS50FNcVHf4o8pPbnEqzGiheaMe6HHC0b1w0pZUGZxigLP
         V7iCeKSiRdfVVZ3FQ16sfMD2bU/xiQiTjOmEymgk2vgEp3zJeRd7XrcbdpkkqQ894rTE
         b1iXRU5yHU1jF4yN4u2KZM+wQCS322geX2FhaNgqoF3cp1zCcV/NN/AwbWiow/woR5hR
         6tCAoU8Z2GARJ/Yh3X9qxn5g2fCg8/gOfA9LpxcUD9DStJrqMnALtu1ftwrrow2D76Er
         E/Ow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784731905; x=1785336705; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        b=I2dFglAIhp010TH5i7pnhbqiPHI20Gopztx8yvJ+fhtPOdfoGc7ihZ3cY8/0HWjt8G
         34lm/V6w0WKAgQ2vLZOxKKl0vHL0Ie0p42gSJ3AgP0bS7uCyMGo2W+b9EFIwc/OxLBrt
         rYwnOBD3Z9E2JN7dMSEssLM2HGrfcBVtSYvf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784731905; x=1785336705;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        b=cqGw7EC6JiP6A29cYuWtewTaspr7jyZ7HkaCtPjBx3DhhHHF4OPHIBGtfOl5FeA2MG
         W5AgkwYwlo3S8Mu9v4oYGI4lznyJjtJtPURd1xXCF/RZp+1Il267T0MOJ7lODH0V9LWf
         obCNKC+a0XCPs67XlfPzacmLqQz99AbqnsKrYJTEGN8bBERWKVe8jOZUCbQmQhM2oale
         OGfvjGSShhE4SY4FEdRZEzAVGdiD3JgUa+ZLJy0j8Byd/JRyIs4DQJpGmKpepVTXxY8t
         gg50VhO6PnFu0PiqtFqV92Zww65GScw6kU+gFO4d3pkB00+5utRwAY/G89JCpfuRPCnH
         4rmA==
X-Forwarded-Encrypted: i=1; AHgh+RqOW+sMwVZEaZGqf3nMT8xGXCJtU+Ps5QlWULB58MaNUoMvqTLuALinJirnEdTBmvnmiPzkxqmU/vs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvCE1djIzSm46T2GBnaDIY1twTB1bvUiTMOWLz1aftTAJ8PTTU
	jR24g1ttbea/1doJ91VYZ4Mvk7MTct2tWB9HVp486XsrllMGXA0hO12gxzk+yZoyK7rOsjAUFgh
	nc+iMHRC9pT0AqF/UPK4FUMJcZ7k6tsWN6bCwyFT8dw==
X-Gm-Gg: AR+sD108xZhOPEWYHYFWH24OOuIR9MxySuOlMbUhYol3ExJfJovdpzY9KTQuTcdzZRS
	PxFOyd6/7vxh0aMPv4haWJ2jwfYTlwWcExS40l/XT05uV2u+19A3dpcLjl4tgL7Z/RJiMvLouop
	DuFJ3lV8JTpf/8rDXjpbMySqq5KKlEEH66VG4ooxKfAmY5nSiEaQvqGNVQlrCTXB9pcibnL3ubz
	yJI32bG28TKU3YEWmXv6MXuSZnGyTvaWXuGDzsW2up+JN5hA0n+rSUJiiP4h2sZ7a4jfVu3qEMg
	PW5zrin3R67QVuClNw==
X-Received: by 2002:a05:6a20:d492:b0:3c3:a1a4:862c with SMTP id
 adf61e73a8af0-3c3ada53e11mr26768547637.68.1784731905213; Wed, 22 Jul 2026
 07:51:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
 <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com> <20260722-erraten-hinblick-erlesen-2520fd1a3726@brauner>
In-Reply-To: <20260722-erraten-hinblick-erlesen-2520fd1a3726@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Jul 2026 16:51:33 +0200
X-Gm-Features: AUfX_myoOxogLBx3AVNQWfe_n3afhoBfiMuTAn8Y0Wpj1xcWwQS0hNa4Avph51g
Message-ID: <CAJfpegu1mzQGQUvRTqLbNOp4B4_QqddUnXyQFs0MLuNFa4xAoA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 16:25, Christian Brauner <brauner@kernel.org> wrote:

> I'm still vehemently opposed to stuffing more creepy apis into procfs.
> So this gets clear opposition from me.

Let's try to leave out loaded terms from a technical discussion.  I
never said this was creepy, Andy was qualifying the O_ALT thing.

Other than that, do you have a specific issue with the proposed interface?

Thanks,
Miklos
