Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1733D170E
	for <linux-api@vger.kernel.org>; Mon, 20 Jul 2026 09:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539344; cv=pass; b=DN8QCWOd7MO2txuAh2lorZ0qkwxXpiJJdnARn0QbfBwnv14ZTH2qQR7sk1eJmzTDuXk+tc/39Ban1U7psAkmJkX1YAo+rOgR3u9AqupsWdsvbl4jC40P3hwS00qJmY2JzjOFfjW7gjnmOqpQpqJCUSH7Lq1kknYrmUeFKCNIvuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539344; c=relaxed/simple;
	bh=v1G/U6rYwbjprWYcPlrHGKT0xVAuOYF1UYTXLhSRnAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kTz5W2RvnmLoB0vudFNW2M0ccsRc6kTlN34e6HkDOq1+5NPRzw7i4bteN1+qb2Nd59R/3LVOzMffKnzgRDf1P67efX9+wNMc3Y97V3PjPP6FTvklaC9rwCCmvcGMNA6drZacZ4Gw8UtbCQB7G9bgMuypEhWt6s7qxsavT05DEjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=aebP9PPQ; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="aebP9PPQ"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c1372f84dso63043431cf.2
        for <linux-api@vger.kernel.org>; Mon, 20 Jul 2026 02:22:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784539341; cv=none;
        d=google.com; s=arc-20260327;
        b=JM1Vxbm6vy2eA0uYd6V9oSkaXN9CH6XCOBKwlRghvGN4NCS4V21vgUenGWQb7TWU98
         0F0wzju8fUdO7WIsptcgsU3nr4zmjKw7XCxMKWyXwVMzUshz9aNd6cNr5na5gzpW3KRK
         4No5iJKaRmkGefM9u/E+42I2HSvGTItZBOMacoAG8Vs5MBCxQJFx0/+xfPt6fQajSmCr
         WVWde0LqTtfauTt3PA+SDO/d5elqk3CtIBLiuNxk4f1l7A6RrXJyt/i3rrkt6IWTOj9b
         7TWb5ml64rMN9D2H4tAVv4FZsw+EbxqXCotMLdBKeEE0pov51EBi5Zz2uCrcV0JXQBDM
         ZaSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        fh=AU7jhFgqXpYEB4NIDER0AQdf2TelVJ8TlwGtXNuxN4U=;
        b=dnoVob/dUDi2X3L9m0rX4PITky1cIfD49EQFfMKVOwTF5h0a5OCMyQeh4yP2GDl+RT
         IhNfW6u2fZjN3oQOHL+SNIxn6gcvcdMroT6jy6Sf46U5ucBBSmBiOqPy14vK5/SE8fcE
         a9F5PNPI11R2p5A41oS9wN4F2oyljVyv2SGurAu00npdd5492+qP6TWHIHe4u41znFFi
         IDb4q7e15Sp5iCyUOfEAXzw4Zy46/MCLIVCmg+bSxrPwxSOwpUa8hiGOJxmUADY4r3Py
         IaGEIq6PQY/YB9Ve1lWlmUFGJ6BTdnVPGUnkh7UEk/zYfVqgTULc+E0J67ivQSa5Z2k1
         hwRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784539341; x=1785144141; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        b=aebP9PPQR5pm6N7/qxL7c65gZmz19yeADLMgDCVbA7eBNiQ1p0LOsj+dZU4dBMjHkY
         TYI/0bXSSPxHqc/Th0TyEqYLJLywLtNWBP8SfWlNyozVDr+V17Dw6OwyV2r5IEJqJ1Nz
         CXeTY+f2ynux3DvQ8s/P3CSutNxD05Upp2Ifs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539341; x=1785144141;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ip3jHsFq/3cxVMe2s230B81UAfkN7lmSalsLm8p4Mjs=;
        b=O9ZTsOrwNWj55OxnMJknUlgfMOZG1eLrY/p+8zK8rVSmgs9YfVEqyW2eiWzyfjJkto
         wWYWsyOQtG5b2L5D25haoOMMpqtYuGGnMY4/KNtHyh6NoTdNJeBaOWVrvlWLPBUZoJsR
         4rehS+4/vdNP5iUr1t16elW6yJEOdfLBe/Tfi8gOC5SdqWQrYzBGuXM1chBUEZWzamyl
         PdQvPA5C2ddvF5BTd1a1s5FV6V6zs031XThye7E9/p6I+cDWEwgcJKgx15O7uc3F9FDT
         hUW0cG+2z0YBtJvFmkqmXmIFdW8bye4XOTmqecSAq5c32/FDPtZ3al52SsLawg0m8bFi
         J7Vg==
X-Forwarded-Encrypted: i=1; AHgh+RphKfY2xcys6ca1tmG+ymBFmChJiBrBERrUuHj5ejByUAGe7bG/yDSm6FcwGb2+HHmUFAk4MRy5dVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwD4x7DPR/hiEpXLUiOEHfWZB/cvAO/tiiUwl6Xp2UGYxNUi7l
	ISJYQ0XwCe+TPeH2R1ozVo7B3nzMtn0YLOY2XIydGsjX9mINVrwEiKrlxF36UcBq741Er92/R7Q
	FxgnXVM1o9ualqn91k2RQRlTuBYCvnw9FXjML14YYAw==
X-Gm-Gg: AfdE7clxB6CSLIxlRGQGcY386V/ePTMc3qAX9+Dh0tO2ILkOMhX3n7ltH6v4y35D0WB
	4l8il2fguJbiJ9croy0Dw9AnALwd9ijRpVE0HyXRldaxTRWL3MLvlCuEonq2w4TOgwIg59/qwFa
	wWhwZNG61h99Grnr4//CFRRLQ9YpIoKMPEVA4qZR0Dzh3k77rLe0uZ3LpmKPjPDOXGOOFdbnMZe
	EpOxkEZO9tKUFBlaCbfyO7ZI292HcSr6KfJ0HB2JP+f99BPEC+ZVNpCY3X4E4PgcN17vIGhIls4
	LxyUtDLED9QhkjB+ww==
X-Received: by 2002:a05:622a:1192:b0:51a:8c9b:64a2 with SMTP id
 d75a77b69052e-5213d0c7ca4mr116936831cf.70.1784539341012; Mon, 20 Jul 2026
 02:22:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
In-Reply-To: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 20 Jul 2026 11:22:09 +0200
X-Gm-Features: AUfX_mz0IN3hn5QumsNu3idUZDFLnqeEUQTN9zg17vrQKR01GmrNXzVy6O1zEgw
Message-ID: <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 Jul 2026 at 16:13, Andy Lutomirski <luto@amacapital.net> wrote:

> This gives me the willies a bit.  It's very cool, but it has some
> potential security issues that I think we need to watch out for.  As
> sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
> supported files-as-directories.

I realized that we can keep the creepiness factor minimal by
introducing this first in procfs only.   That way zero changes are
needed in the path lookup code:

sprintf(buf, "/proc/self/fd-alt/%d/%s", base_fd, alt_path);
alt_fd = open(buf, O_PATH);

Thanks,
Miklos
