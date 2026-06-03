Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51140145B3F
	for <linux-api@vger.kernel.org>; Wed,  3 Jun 2026 22:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780526981; cv=pass; b=Vazf1N9f+Lnecl2q/wyAsfD493Fc/ujyM8AbgTLFZzQzlpYHl2yNe4atwV0XTeVzm9RlU0qfxMoScLwmQ83ELi4hhUQZ94lI8dKTwMsdc0EdHMerHqakwZmunhLF2g4YCHoCwKlX/yexu2WoKLITx/d107E5aINmdE2cLeR6PqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780526981; c=relaxed/simple;
	bh=cIMAt4SxZf1p6upEqoxHSHb7RfP9hev2musbsbmwNuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MUCbSImOVojeAatQBa1neDqwOCs/xSyLjWXkqt+gvkKha6lb+tuNReB4g9W9xIA6WjDBU5VF6MTo9g1cARbWPwdPpvsAEHTTJJurmcZFPiEOSkMEvz471p3xXmctEA6RB2pUc2qyBXNtRjt83EyFm8HhKkQRtmfV1lKRh8XcKNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=Yvz/Dfr7; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="Yvz/Dfr7"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aa65a184f2so18864e87.1
        for <linux-api@vger.kernel.org>; Wed, 03 Jun 2026 15:49:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780526979; cv=none;
        d=google.com; s=arc-20240605;
        b=kWBRtkfrdSf+HQfdFh48gDezuBvnYt3Uw7XFn9m50pnYYMlVbAZuc+6GvHZvgw8WO8
         JqP3NsqYpO77xCmSFgf5Nadmv0MwqzXIkgujaqe5TkpdK1uSPkib+68eYs3MUAeNXt51
         wwuJBRVVFdh62HozX9Gs96P/NyOmQEZSQo7po8HXguMxUge2p5OD+vzUj1O0e9rP+Yg9
         3mluucZcJjeDXaeRAtop93b77HsIkS1KTvwTtnJBpV1zYlTY0aYZlOHpIPvpqhe2Qq5R
         MkVO9qzWCtzFrr2Gv9eseVbBvFoIjDppYkYkJyI6PWSjjQ5VoQ5P6IK2LBgBCkPRViXy
         dquA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        fh=hgRlMuUgtlc/GtcI8OeMi8hDElgN1GoqKdOr+WFDwU4=;
        b=PoTy0Q3RU4P03F+MNkGbmRrg+64hIbSYe9P1qOw7H7rFbrMVq+cEdhVxJse/KIfctT
         lRp1KMs/7olgIHZ3aftn8ZMwRJqwR/2S7cLycm3TMRKp2JfKYqwDclbHPRHuqLlpwIv2
         5GyXb2aZMmljbQ22k3MkwYFk91IGhPJuD2ckVcE6jF3g34dNa/72taCYqY6+fNzfKKHh
         aIHiqwigTk4DlCK03RZW5hWHaj11TGRS/LflbihV4+KSLOX33AxC4TnSNcNSK0EniFY7
         WlgqMtBZ/O08d62doUnC1eN2nHGsbGcGi8U2ICDXiYOqgKDwz3taGO/rO0FXZk8fm3Tk
         jk6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780526979; x=1781131779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        b=Yvz/Dfr7RO2sXrSJP1+PBKZaWQbv9Yj1UZbDb9M5lVzXO46ZbxlWsqABai/NptWCvJ
         2mPWVoP7aGv7pBODDhXPHfWedwHWtbqBZ+guxAdmCp8fXyTXsQ38bg4qTnFsHK7XT7Y6
         mZnzWEE78oDQZalRDxNDO4d/Q3Mr0+Ct70i3g0WRV28ce5eZ8dIwoZxjj1uf1gSUnrBL
         rzID1BdWO/WpObQbZOmKyZ8hvA7ZWLT2ipdZuiBvjivU4fcitjtonrrTXAcoB1JWDNR5
         MT7hbf+dRXraXtbsg9npXobz9en89b+0inCLnP2Ls5xFDE2PlShcKSimWnecW+fd2eqG
         7JLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780526979; x=1781131779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        b=ZqErnNa0sne0H3HD7Gy8XFq2Z2GowUpUdj/rt7TCIHohpkT6+csKDX+Bd5gf9ZMplE
         XDqantiBLRaibnLaHcyXX6GdQT2dZbOI1ZIyTqavBQLzFM9i0UEK8U89HkkXQDYe8/ma
         48EcHYWRUXelSJ9ZtixVZ0Ae9JeDwoe2W5T+pYb/zlVuXbaYSjBLSC127bUalsrlL88K
         9KOyP0z6IZ/Nw1l1KbYlk2zJ+dACnfCRpthT2IHoROEP6DTzSoDwPIRYGIaLzDR50XXE
         GJNyQvU03minRI3NEIcpmFnmC14PLB1bdq8BwRIFDB2/RCkIqAPUMk54mPemVjPGWxD8
         douQ==
X-Forwarded-Encrypted: i=1; AFNElJ+w2NA6yQRowrRAUXKk/AkqveOY+EZM5853vUcfXKghyQwbeV8QwWUhnTNw18W4vK0Vk2KWXSIFPCs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP5pDOR+mpAb8ihizMPPYzXcyNd0XPSjapZCLDNRWN+R+GTOrI
	Vo4vJrFu8uTnmSfVlr8Z3jU5rfpuKiXo4AcMq0EMeJ9MdDV+1v/lgHtdEA4U17o4isXIjOJzkeA
	sll2wU5cnGHaQ1fNF+APk5wtzJMwFP/S7ppClUCZl
X-Gm-Gg: Acq92OGHoUkB4XTyv/bSNoQhZNbKJJ6J1KEXbHMSNGusajAqWcTgH+OGsoFzz1+lxi9
	vr4ZTq7Wx2BscnoAtdyodxfce/3Hqjywg3zegqDxM5+MdojvLlWSCNCIjCJA80N5lXEJMzmYWxS
	di0oDoDs7Sa3qS3/xhk/QharoFCn+3sWZNEqf1lJI0ykbgjecBFxBNShjXsiSfjOOHMx6EO6gwn
	awtrgNBgRDQvHOQqmSGD//MpOa/ozvlWXacx6Wt07YmmjwHEIbJ2ggPVmTYKGyM4mWOY9jARzi2
	XgCq+jsphYO0C259Sj8=
X-Received: by 2002:a05:6512:a88:b0:5aa:7126:c661 with SMTP id
 2adb3069b0e04-5aa7c06347emr1703733e87.7.1780526978614; Wed, 03 Jun 2026
 15:49:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
 <20260603224311.834796-1-safinaskar@gmail.com>
In-Reply-To: <20260603224311.834796-1-safinaskar@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jun 2026 15:49:26 -0700
X-Gm-Features: AVHnY4LigDaMGEZAFdtnNoXIyXd96f1pywv43JDsz9J-Er1-wYhHVKm162Sc_xY
Message-ID: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 3:43=E2=80=AFPM Askar Safin <safinaskar@gmail.com> w=
rote:
>
> Andy Lutomirski <luto@amacapital.net>:
> > Maybe we should keep an API that does an optimized copy, from one fd
> > to another, that can send from a file to the network with at most ONE
> > cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> > for one.
>
> Yes, this is what my hypothetical future patch will do.
>
> One copy from pagecache to pipe, and then network uses that buffer
> directly.
>
> > But splice_to_socket involves
> > MSG_SPLACE_PAGES, which I think is a part of the mess that you
> > dislike.  And the path where one does copy_splice_read and then
> > splice_to_socket has to be a bit complex because of tee and (I think)
> > because splice_to_socket cannot assume that the incoming data is just
> > ordinary unshared buffers.
>
> My future patch will provide new guarantee: pipe buffers are always
> stable, i. e. they will not be externally-modified.
>
> So hopefully network code will be adjusted to use this guarantee.
>
> But pipe buffers will not be "ordinary unshared buffers".
>
> They still may be shared with other things because of tee(2).
> (But they are still stable! They will not be randomly modified!)
>
> But network code can do "pipe_buf_try_steal" and thus ensure that
> these buffers are not shared with anything else.
>
> So, network code can be modified to use "pipe_buf_try_steal", and you
> will get "ordinary unshared buffers" exactly as you want. This will
> give you in total exactly one copy.
>
> Also: as well as I understand, previously, pipe_buf_try_steal was
> kind of lie. It may return true for buffers created via vmsplice with
> GIFT. (I did not check this, but I think so.) I. e. pipe_buf_try_steal wi=
ll
> return "true" in this case, but pages are still shared! But, thanks to my
> vmsplice patchset (which is already applied), this is no longer true!
> So now pipe_buf_try_steal is absolutely safe to use!
>
> Finally, we can degrade tee(2) to copy, and hopefully this will
> allow us to always be sure that pipe buffers are not shared with anything=
.
> This is possible future direction.

I'm a bit nervous that, if I've read the code correctly (a big if),
then iscsi and nvme will still send *shared* buffers via
MSG_SPLICE_PAGES, but that normal user code will not be able to do
this, and that something will bitrot.
