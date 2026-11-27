Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795796335;
	b=i9nAdD+36EidwJPwPCZYBDjc4wsREdJVY99sY1DINALwk+3hspr6v1nQ7+8WShwqc/RE
	 pQH6Gdb3Ed83FZAQRgRGVMOMp42eaCDWxUtJbaEpySmZaHgc5cNq88Ma43fr8sFusuIZv
	 Eatide7mHK64JzP9TCx2IVcsBMYwHUsd/NmgztZC/9l0Qggv/AejUDsLgYGn08As1g1d3
	 Fn8NWNSa0kQgVmtItLWE1tSyo2sLiFJgSAg1HBIadXE/zwuUBtl7i3zR8GroOPBGT99XY
	 yU7bhBl6hvHEdOa4JCFwFau2ldRVt9BJbn7MdAPWyFBTPTIQcZ0KuKnF7TEnLRgu1Lw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
	b=0gMVtHVH11zqsy0QKrT6HK3lXlbgxyybUA/CvTIJbfN4oUKGRp28tUKKRKuFvGeZu00+
	 XVIUN+gDxsj7rca8g8tWoxEM0TnleInxxUl4c2enVteMFxRdZ6C7i25olSdPmpfgfl4IZ
	 hpsir9UQXSWkZhEQb+iUVyhPchKlWRVe+/4/VCk8PG+7x6Ah41aE9jb4vd3qNEW/1yPmq
	 hWL15gL6wVCYdiMNk6615e95pQ5wULVAYvwtscSfGz8xdL6ol2LtG0aIeQahTWxdID17P
	 ZPc7hY2episi6GHs2zhdeB4BITarWJuX685PYIPxLpADdtYOKDaNuqLMPZatJ0i7axQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="naloy12/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D68606A31F
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 16:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9D68606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=naloy12/
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b8c60e0d39so10628738a12.2
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 08:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795796333; cv=none;
        d=google.com; s=arc-20260327;
        b=nTYUf4IRi+yTpwYyFFRKW4IBiIu3k02EvSltDyS6N8m3If5o0JEVGHCMt3ZsAgrUBe
         8kKJslUB553z9bqzb0aXco5kyV7sLeoXLNoNogjz7lJPLyB4RvvBpcaWaPS8t7yUdeke
         do5JvS5Cr1OQJ8sHcy4gwFxdoKal2t+FhIVzggzQ0e6Xx5VyJRMbzmjv+beuiVIsbyjT
         P4WDcxxAWgoaVydS13zrcJHzdylGpHkycnxpxLbW47lS++lwJ442oGuzLiM3KEMG+GTA
         UDp2R0dtUsQ2vtaHdDhFR39AbRDkbIN2DkHrhYczeRLKX8BVoQb2gRroxHhMUUuF39+L
         AzvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        fh=9R1abdLBk5qLeAZocouiUD+fh5VoOe+8eVPAJw2ls8s=;
        b=VZnbyLtU9Jwmq24Vm4jy+2tWGIhRFIbVcfwdGH6R24oF7kgZ2Vgoj2m3JwR7I4UXuJ
         QvI67cNSQG9YsBPjcXkoCFyHfu2F/JWgUQ14ppWftX/465NG+jwlUGxY95ZZGOdYSl8R
         H4Yy+csHqLzzB0PnHzlA7RBKOFe26QbbzWPSp0+OD52gJPXXsTR5DwKQHCLN4UPidef9
         oytj+KakL+JY5Wxdn053NMBbXUybunOEbFzSgI29CGRjS9/J9Mkb9WqeQkTBDlDnwuQp
         cjqLjac8aDXvsPfkUU9V94vyZ00ELlEld9/pramnAFl6JAHkPKAMvVdd1EEng1szp/SM
         FXYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795796333; x=1796401133; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=naloy12//Z/JEicfOBVG7/emu8n6hsVyuTwhG/APX5YJILPJ+Ejhpn8jBE4NDP7/lK
         g0UksYAE6Bdao6mTsS9kfqJqJTBy4iSLcQUfz2p6ydY9idCCIBNNnumqk9ahTewMQrhJ
         T08f33nweDrOyw3pKSkr1Qkrkked0vr7ZHwRDHta+TN6WG0oGzqsuhDrEOx72fBh5WU0
         oYgUXVXd1tU/mzTeQ0mzsTJviZuAX74N/jPwzeSjBiwxnyK0h0TealYMchARBmDUZIOX
         ViMp+AC7Q+jtL9fE4jDvp/Jor7sArB0DX5YSBPvQ3+fL8nmRlQu5cAOGwV0tlnPOhQ6L
         rUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795796333; x=1796401133;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=z6PJqH50cOWS7BLdYAFGLqknQ+QtPWwlpdgAFrJGMbUEVN3BUPXxKbUd6/AMmQTuRC
         NrnDT9L8YYJJAAVx/JBAwwiduOVuB2xq3BIZugohqd+VAj8iRWGSQrC4sVpwuXYjbvyC
         sYAzbjkH7YaB6wgL6hDlnA1RqIIokXIYQQclTZhobFwL24UQRbEoo5KSd1f3o8evnLGW
         IxqkFPVwpg+ZpyFkoZZdLr8UZ7BzNOIqk6rgSd1SNaIMhNDVIOPXCDNQjxew7NdqbSXy
         m0v14QrQyEvYf/RqCJSZeE0FUnrkB56N2HBw99JHJIbbn2GxgwxSuF/EqnYMQ/jPwNIz
         cVCA==
X-Forwarded-Encrypted: i=1; AL+hErEYwWWwJyMjaWB8fHMd9LW01MuL51CfZewtIQFGd5V0NYUFsWhrx6Z2F2TXFa36PXF4wnnZ8bV/oWk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+q2R99RYGMiLCjCis8b51EbDKUb+d+1ISQB+Aq7qetvgVAoGm8
	5JvAjmW+Wn5E35sRGWMUSSzHZ8dSDGXV6TbPpY4fovQfrrqLT9Sda0mkEdBRxe1cmdXzTmEa05v
	vTs7sWeNGdfBWKnUb2SAAKmcB6bRuN3o=
X-Gm-Gg: AZFdTZem8ceT9H1/1kynG+XQqgrNNn4ru7IkqMqAy2c1L5fzRj7Fxbim0bJyx8q90KR
	prAHpTzAjWaClhVMlnLoHPRi+4iTOCSzjIGFud3qqWoVi/jKIZUleXKIK0zx9c0kcZeuiZnx6+3
	cx8Re5ATaHZpCUBQPOSx05231JXOjIFfDDzOWzK0TOnJBo6e871/NIIU2S0R+TriitYRwifjIBU
	xpJE5PhG7NHYshJbjB2PDbEgMp8mYrhUmErLnoatPS5DtpzizH46Zvfr4D8Vjv9vEvpAX7sGbG7
	Yld0LUrPt3yksQUH8yDWViih0RSZx3iC8RYBpe0hIgeZ9TCh/Qjs3nifWWhdXB+8OOx9OJC80UJ
	kxSqgPTQ9hlMUnfMur3u5/g4LmHxY0RLb3ntPyUSnOZTZdxxYPYVAJHgM3yDdOZAaETDokg==
X-Received: by 2002:a05:6402:e05:b0:6af:80c4:8981 with SMTP id
 4fb4d7f45d1cf-6ba37e890fcmr19985269a12.26.1795796332918; Fri, 27 Nov 2026
 08:18:52 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <20261119153222.65195-1-lauri.gates@gmail.com>
 <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
In-Reply-To: <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 17:18:39 +0100
X-Gm-Features: Aa3M54qCjcbbYjv0mzgNqjSQ7Sw_WVEr_GJN4PX5Bm9lrA0JqzVoRsl7zVlER60
Message-ID: <CAOQ4uxhE38TnXseMOyWY1OvidBWew2hAYAV+rYeTPaqRYZb45g@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: Christian Brauner <brauner@kernel.org>
Cc: Lauri Gates <lauri.gates@gmail.com>, koraynilay <koray.fra@gmail.com>, 
	Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 1:44=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Nov 19, 2026 at 05:32:22PM +0200, Lauri Gates wrote:
> > One constraint for that case: the flag has to stay out of
> > FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
> > FS_XFLAGS_MASK is reported as supported on every filesystem, so a
> > plain flag there would read as "supported, not shared" on btrfs.
>
> Right.
>
> > Christian, with this mask on the way, would you take a plain flag
> > (say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
> > that filesystems advertise through fsx_xflags_mask? If so, I'll build
> > the RFC on top of koraynilay's series instead of using the inverted
> > FS_XFLAG_NOSHARED.
>
> Yes, a plain flag is fine. It's simply the stx_attributes_mask model.
> Filesystems that have support raise the flag in the mask and everyone
> else just doesn't. I see that Amir's busy discussing some details in v2
> so maybe base the RFC on that series, I guess.

FWIW, I think the v2 posted API is a solid candidate wrt the UAPI -
The AT_FILEATTR_ opt-in and the struct extension leave very little
open questions - the remaining discussion over v2 and obviously needed v3
is around implementation and the fine details of the contract, but for a si=
mple
readonly flag like FS_XFLAG_MAYSHARE, it is very clear how it behaves.

Thanks,
Amir.
