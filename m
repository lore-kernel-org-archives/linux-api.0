Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795204638;
	b=SSwcm/I2oI25eifh/BpuPm8qxGRn62ysdiX/TvWKZAKS+fXzJ5zeaUC+s5SOllg3ulze
	 FYh3Aaw+cSHsk+KTcpjrYP2qHB/Zik9thOALjXicEAxItmoXkXYiUk7yvN7F1BqrZBzgn
	 TNwFAOGT8D/q43mvqSyINoJ1bOlqeH0lCeeaE3tuB+oRwtubkQ5O8sSvhbuBS+MiYZ/2X
	 MIhEeiSV7Fx1+XO8QIijZtXU76E0N7tzXC4Ordw+HXtUbuTyc3lvXBhHU+uf7MqrOzTD/
	 uh8M15mzU+/gU62p+2v5DgSpS+ymzr4SjxS4DsnQcW9QojB2bGJ0jENgm4beNnK0tfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795204638;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=bepP2SIrLZrZLh3YoUhcI7r4qP8FXfE4vnBTwIQ4Skc=;
	b=U4ddiyLCwn6Xu/tzQJFw9HCX58ANWyML0ZdbYUREmHaMN2fBvEQ9vJiVqbMyd5NqzZvH
	 sDdX2DxNDcIUFddkEANHv1ZLQMTLkQ0aY7IwFp1zJ1BMAz5ZjPu0wjJmrqEuof6sN+Dmu
	 CKR/Y2WP54OtBGW6xH4GDwq0EI+7baF34eo0BiL8IKi9dM3Jp3UO4IU1VpmqGNMnq/SNG
	 IP2t084hblFvkqz/5XvV4zsAtf32GNCBjRC39N5qlwMcx/DYqdp2anklJuAHm4+7P8lAg
	 oMnabLr9VQM4XTPENpkbmG+964JKPH2pXJQPDxRHk0kIm4GPUAdk1FZhxBOX60SEXXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YLaDCL7l;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F3F606A33D
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 19:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31F3F606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YLaDCL7l
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4a358881793so717169f8f.0
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 11:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795204631; x=1795809431; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bepP2SIrLZrZLh3YoUhcI7r4qP8FXfE4vnBTwIQ4Skc=;
        b=YLaDCL7l+gBYhphKUE9IjZpDyAduT7RSvK84qheiU40y5Q/34BVNEL4rLRamvarM/C
         mg3kd5tLIfPbaMdf3G9V6BovUh5VkWDYSKjV+RXqGZJx5qLgV/rtXLpHVkyc8mHbAmZO
         VpYESRBLZlq9s9nUmVbzxATZGGbJTGkFIQ6+9yapG8xQO+m0AAuTnlXwpWSndiE2xj+C
         O43okYYfhpEACmMpKGEsoHNbO9ZrnJ9DBqGUmtVs8KzhNnKimKDCOCBF7khsV/wfcH1h
         ZYbExbg1oEs8CwbOGR32Tdjbv5k4phubo41fjM+2YGGD+wQwD9Z1lSShBIurs/95DC7W
         L91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795204632; x=1795809432;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bepP2SIrLZrZLh3YoUhcI7r4qP8FXfE4vnBTwIQ4Skc=;
        b=hw6d/hPgKmJrY+t95SmPIYHerRxOTrN2nIuKpLlCpdIYLkcbKDhK00vxqf0CqWKgAv
         4sr/1knVKkGF479w1xEH3v0qroslN29So6ekOHq3krXaZFjU1fBwA9d+O0ONUo4PP20m
         SVQ9WcsBkGvMqkj0rNCliftH/133QUbzkXTPk58Bjwpk4/DSmaZrQMbb2ukxWJL7fIYD
         zI4lep/xXP5Jk4YKBcLZZwqHzSoVXeP8X/DxMjbua0LVd2CpLHbhYNosL5XuDD1dPOtr
         2tLoTC3jYXG/0pUxkTfpyaFGD3zQ0EgSs7HhGTVXY+FIWHJHL2PZ4QsiY/WyVxw7Y5Zg
         5X6w==
X-Forwarded-Encrypted: i=1; AL+hErHFj8ShvUku/LOWq80x2BzyeiNV/HCxORQgV073Nwy8O7BXca++QAgdhygkIf2jY4O3A6x0dtwNZJM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+UeIdm+Ezf7Xq1H6CyrzGvcZbLZmGKP37TWx5bp+PX8sWDUDOk
	nCvDjZrb+jD3WD02rfRS2DdDNWBHxHLUi7cfb3cdcsvHqm7WM9hzPEvO
X-Gm-Gg: AYBFou0aArVFVEykeweb1zim4I3qND+elflu7M9HmI5Ourwp3Uo8qX5QYvrHgdYcFs2
	6wfdxOGOc4zU8JTMvn+eTM947vmUSUFm3wTuiSDihEFc6wjTePnf5maAELAtU9i0ksfAh/ssGyY
	X70NS3Jelh+HDYJ89KhDWb99oXTihjmsx2RBrohUVG/sLVyMwfi6P0Y6V68PSugzv7OkYZwoNoo
	f/Y8x7gRDbnKM+eQW4wLbXp5ng1n+3MZf39KPv0jQTHuotPhTsf8bC36AQuxs/0R0VpIMvo7JUl
	dHcvPEuGoGrMccynO6B/dZznmTb1P3Ng0+VzkwYCXB4lbzwtnNSDlWaOtxq6BH/4XzMqqX9ug9C
	7F9zmVXvmpUmkgCPwF8ie0ask8Fr8zuS8yCMRIXbDv27lDURkDGtERXY5rpEMTILpr+BElnvsMB
	QIfsbcu8ay3M2rzJfJyK2Ll9nOVx7p3OD8cqwtYy9wC53jH3ip1fkOC+mB24PAr867Afb/DZPB5
	gWCSo7h9MkQdc+0z9cc1viIVAAkGFfKLiMklBUGzctWboIn/zaZIbELpyjV2aNsTxOPQqKzK3ut
	jAL9UtgBTuUy097leqGb9GxzYg==
X-Received: by 2002:a05:600c:638e:b0:4bb:6c5e:b006 with SMTP id 5b1f17b1804b1-4bb887e265fmr93789305e9.3.1795204631450;
        Fri, 20 Nov 2026 11:57:11 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8526cbd0sm177401215e9.0.2026.11.20.11.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 11:57:10 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=0ce1f2737ac23ac54221dfe9ad89c8615ea720b53f7a9f6f6b271bd43f0e;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 20 Nov 2026 20:57:05 +0100
Message-Id: <DN0AXFYCMGXO.1O5VDUA6GJCT4@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 03/10] ntfs3: make crtime user-settable using
 ptime
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-4-koray.fra@gmail.com>
 <CAOQ4uxjdEiuJMQxtSL8XrPYHSamtfMh+BM8kS1wj_PVME4JynQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjdEiuJMQxtSL8XrPYHSamtfMh+BM8kS1wj_PVME4JynQ@mail.gmail.com>

--0ce1f2737ac23ac54221dfe9ad89c8615ea720b53f7a9f6f6b271bd43f0e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 20, 2026 at 4:58 PM CET, Amir Goldstein wrote:
> On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Since NTFS supports user-settable file creation timestamps, map
>> provenance time (ptime) to NTFS file creation time (crtime) by using the
>> newly introduced ptime API (in commit "vfs: add provenance time
>> (ptime)").
>>
>> To do this, update ntfs_fileattr_[gs]et(), ntfs_getattr() and make it
>> persist to disk in ni_write_inode().
>>
>> The timestamp is now retrievable by using file_getattr() or statx(), and
>> is settable by using file_setattr() with the FS_XFLAG_PTIME flag.
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/ntfs3/file.c    | 20 ++++++++++++++++++--
>>  fs/ntfs3/frecord.c |  8 +++++++-
>>  2 files changed, 25 insertions(+), 3 deletions(-)
>
> Please don't change the unmaintained ntfs3 driver.
>
> If you want to include an ntfs patch work on the new fs/ntfs driver.

Huh, I thought ntfs3 was the modern and latest one by Paragon.
But apparently I missed some news[1][2] lol.
I'll use fs/ntfs for the mutable btime patch then.

Thanks,
koraynilay

[1]: https://www.phoronix.com/news/New-NTFS-Driver-Submitted-Linux
[2]: commit 1e9ea7e04472d4e5e12e58c881eaacfb3e49b669

> Thanks,
> Amir.



--0ce1f2737ac23ac54221dfe9ad89c8615ea720b53f7a9f6f6b271bd43f0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawCmEQAKCRDmj22qf5IG
XMFuAP4jbqqWLf0rzRDeTfZI93Ntri5exvb2a4tXBADewtwEHQD+MLXXfUDqNxpu
FJSnl3dfZi2d0aWeniR+psgoM+VAKw0=
=6Hcz
-----END PGP SIGNATURE-----

--0ce1f2737ac23ac54221dfe9ad89c8615ea720b53f7a9f6f6b271bd43f0e--
