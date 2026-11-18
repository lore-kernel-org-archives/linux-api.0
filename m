Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023477;
	b=kyjnPCMMQXiLy00ZLQ6FCwr2fX62IlGus0R3zvk+gb1aWuEFItng2A+mRtURWgu5oses
	 dLhFSoITlpFyKcXLS+RMNZFLcTWUOD7ve1jwF/IlPobJ4odLB2iMISoQ6Lu63+GTsk0kN
	 aw9GFvaozLvLrNhr7UkZhFzMa4wGy/oFf/SgizwVuGMszp7Yzp7keWGZ3cVC722kj5Q2z
	 9ZrGHeTkY+w16y8ULMX1ZhN5iLWwa+5uXG4HbpeSZcpk97aWWSxthneCyz/7Grq+84pTm
	 5hYqzEYGorvMs+DvmJpSzytxRF2SapoDRvpCiQ35k4Dww4wkyclFcbZIR0gwES9ap6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
	b=4uL1RG5QcE2S2Y5FO5BBeZwZLPAb7Eb0vKVuitr0xOX2NRwHHg6RmwANzrXF4lfp3wem
	 pvMnL5ZF8w5PiJhxm0JYbf+G1xelLMXFRr9qalVKRMn0woGgTMcoA3vHxCAiL6Z/ajXYA
	 wjm2SsGr+Czqzifvi00OlIvuh6K5oknWNf5Wvmp4MwZQeFIWRfYj8mSb6k5pFRLUn6NiX
	 Nec98LJYG8b6OaHuZgJpY1Sf+dx/4bfPOuiD23BchF/I2MvIBEcrFq/X9D33pqi9azdVa
	 URNPePP2dL2eefI9IpqefLkCOUWxbWq/rIUlRapkktfm/+TLPLX9Yo/ynqyoW/xgRBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B4Fx1cvZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BA9606A332
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 17:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1BA9606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B4Fx1cvZ
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso17197866b.0
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 09:37:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795023475; cv=none;
        d=google.com; s=arc-20260327;
        b=P1u5gDFtx5n9GDkAofot45diArKILPzJ5+sVVF3JmQ1QbU351Wosvti9IMY98lntmR
         AonCkt5tWN90s6m/b98tfR0Mur9aRPv6UyxOELWRfDxN+sHfh3xH0hGMH+X5jnSR2fnz
         fHj8hoj3FwXAqHpya5oEvBK9OYUVLZtwYsvJ2i9zq21C9VvVUcWLbpZGlJ4Lm6Mlr+Sc
         cegoO254PHQqK12ZPO0pU4L++bLjF8nZq48tcOuXW2Tk+OvhjvfdpIDlS0xfJ+pnK6VB
         TOI68nE+4DmoVQV0UmdTTQD/293+fTOcRYP38MXtcmhPcU4GHn9Aa/iseIb2UVC5BG/F
         wiOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        fh=ew7IQRILO2gQbXEvBvQ73np+KmD9lRh/GF5k9uIDGIM=;
        b=W6lZZfQXX0oA6IwHTGKONM7s9o2xLch4xgqOIwFwy0a0Q+TXdbe7mmA3ld0pgWHuH6
         fCP5V5bKBTUwzJ3Uayxu4KM+xZNJxtf5KaG2GCXQEzOqSj2gvFftSrZ1EyrKU76IaFls
         ep00GQ/DY6qIlWdAQVRaYBzYCQ6pYuQK38wqPi/gRiu4LVsl64Jz1mzVN4ftnj7tahpX
         aLL1t37LaDFL6jcxkvXzxLgy/E8Afoq+M8YbJNRPCN15R3AmW5UepuYyOC4azXg4XluT
         5SXCNc1kqaw9CEpoD8lfb4NGG3ot+UDGF1QIkmT6PgMHXNQnttzYsBJjOIW5eHDo4QGJ
         Cj4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795023475; x=1795628275; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        b=B4Fx1cvZRSB70oxXa7PXzsQOiKHd8kick7ujHIg5sKZfXngwM/J3md0QrwQw4limgc
         gzD04fGPnUdH4vsdPqK10mZdRL8XnpJIKSo8akWEM5mP1fwpa3D6R1ZVi3kB4ftkkRYT
         t3eglWK1B2yIv1p5oKl1PvLjjuez6SSOZkvKdegYNTew2mBmZIppnHMoZW7XAD514J2T
         Wkz+jc4JDJW+IYh3dYSMGjOQlspp4IYbioQrh478oLfKYgEeEOCfp3zOdH8mfHNwLEAs
         a87jaYO1D21yfJt0MK/CqLT0XQY2LPKrrUvneOLh7WazFrteu6Qq14s3DdjdZZ4eW7Xb
         Uy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795023475; x=1795628275;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        b=FSxeAFkMZ25yyfdRUGtbu0E84GQFgcbILQVI1uRtpeagBsf9PTevWA6z/QlOLwHUFN
         8hNEgbDCCHBUHUi3eE1WsLd89g8Gffz0Kqawzeteg0u1VQOK03PwPtF3pAVDGkTSz4N+
         B/1Dp588jSGYFTGTnp3LKbMZnNr/lXszeiyV9ZEjUpgq73oBjqisZ6P7wuYsf8Re3q1/
         QHMRKtXYsUyCZYYECOKhSjTWDf7L+kq2JD72FG9PAJqpma9/19/w3Q5KjY46sSh8DUKp
         JdpU8p9CxkpCAYuCUbYp4W56XuLlgUO8qaE9+u/rvTqvFKSzM4qNYOXqJJxFFRj9psfa
         Gmxw==
X-Forwarded-Encrypted: i=1; AL+hErGepc6F76WWLms82Tr3tsTfBhasqehwPP7JKk4ERa/hvnufe8MZMVUe3E95UkLVG3WVmjsLK2hJ2Os=@vger.kernel.org
X-Gm-Message-State: APuU4Z/PLcll2IteAtnmRgNof1jFlq36CwMtQQGNIzkmrMvt1ltiqyNu
	tiwc6+HCtl9yl2GIvG1cqd60F21n8+WoJHxvEbN3/otGTtzjiTmMUus4Y6Ukmxi9/5BQFly7JMk
	txvV6urSNmNQv+MApR5KDCrd/Z3js8O0=
X-Gm-Gg: AYBFou0kZ5Xjo0ewgLw/dIgKLnRqUT/dzmiPt+EFfaLrNQTfjQpOdkj1FOyovEiZglh
	cmhNCstx9OZ3vCCA9y/CEv4oUu6+BNKPJZFs7dg/FVB7W77LxBjFxeIQH7xVfJayzzsdA7WLRwb
	mkMPf29UQGGm/hUUtdW47YeD7hsgxFxc431Bs8ccyKzMtJxv2szvjJF6xEe+sv16730E9+eBhrz
	MVVfRHjOUlQOIvfdtP2/93Q7/Tx7m5+AlJsfuqprIjEXt9VZG549PXtLUsvhNPhJ22M1yJILeKT
	xpyL/rA9CCwwq2FiT5ySl7s/1XubdmpBZ2iHPHN1IevPAU5m8/Yls5siuP6VigogyfYfweqLTlK
	uiPDfbqe+ClpivNMaFskj+zreEulsv9T1hTKGuemw5JhvVbjQSORVC+AbnGMPvMbHO2y4Wg==
X-Received: by 2002:a17:907:da1:b0:c49:b6db:1 with SMTP id a640c23a62f3a-c5126364307mr15604866b.12.1795023474965;
 Wed, 18 Nov 2026 09:37:54 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com> <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
 <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com> <CAOQ4uxjme9sJ5LGNDnP6rEKZLTJzX_ZdcMohgu2iLULK96GPOA@mail.gmail.com>
 <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>
In-Reply-To: <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 18:37:42 +0100
X-Gm-Features: AclHuK9j8na9qQXXbOgij3n-j2Bo4JySgielhO0fgIJ-weX9anWXgtr5UxF7Q-Y
Message-ID: <CAOQ4uxguPD+PWEUZtAzSdA-15d_C5cn=34ZmCm0v_b0MWK_sfw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
To: Chuck Lever <cel@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:14=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Wed, Nov 18, 2026, at 11:36 AM, Amir Goldstein wrote:
> > Can't an NFS client be connected to another NFS server
> > implementation which does allow this?
> >
> > I can't wrap my head around the problem.
>
> You already named the problem in a previous email: What happens
> when the NFS server's kernel is upgraded from an NFSD that exposes
> only btime to one that picks either ptime or btime?
>
> Clients will see a file's btime before the server restart, and
> afterwards, they will see a changed TIME_CREATE but the file's
> NFSv4 change attribute will be unchanged.
>
>

Indeed I have.

My newish proposal (on cover letter thread) is that we
abolish the ptime/btime duality and make mutability of btime
a pre-fs decision which is advertised via the get_fileattr() API.
So from the user POV or nfsd POV the values will never diverge.

Thanks,
Amir.
