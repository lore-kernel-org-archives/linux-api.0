Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795443551;
	b=GLiPvfn2BaFyJb+hKhT7nyWxFuwu/3JAxtfE+CPhyjLYjtnEJwegCUOE/0K+FwKiorh3
	 JAj6Gvd9QRgbX7psKFKLIOa/+9F9h+t48Aad0PzdrRKdDhfg+H9PudHJLElaWHWBna+if
	 uQHtIx5Tl1gBGT06hY5gDR8VxOmeDg9JqRoO8EEKUTu1tTZIs3ey29wSSqH28XXQsWcqH
	 1WtamqhV9CqWcDpCUybKE08qEw/VEOzXztpbwIyWxaxOksMgJgPNN0LaK7LvLFf+sKf+d
	 uiPqF0ZGt+y8mulVQwRDjveK9wtvmZZFvHJB9rg8QkymAIh71xZ3YfXkyJYWrQGy3hQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443551;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SGqpzMMXOxhLnysXHPX7ervAuuBOMpPxjnvIFfmSlbo=;
	b=gTnQsUILqpbZFnNjLCDm/rgQZNW6YnoHzJ62/9xwdVwaj4TcjdM6GI451HBsTOUrUlKx
	 P+xhwI072dDcd12uZsWrkw1HjpYtvZ2xvTQrJygEd+9/qo7U4BTHdgklKK2YXuSKOu+5e
	 ivs0YARTxLe9VKzqSBeCzdEpKMj2d/ad2JKKPZ2XBIr43S1LjtqU6cvgA8e14x/eNr3l+
	 ysw/M9dsRlLn+vPjCcc3TrPNigrQHcfJuAFsEByx1zzGy5gE4nMmmtHjPnPavNDnazqOa
	 isxNr75jcaCtXWg+1XiE/V4kvjDhraKc2f0IOyScp6VJ2orGNdYWDgV5VA/aYt3oFRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ia/9bOu8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DF0606A32A
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 14:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81DF0606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ia/9bOu8
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so5364018a12.2
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 06:19:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795443550; cv=none;
        d=google.com; s=arc-20260327;
        b=sLhwQch6Y/caLb1d4/yJ3kJEWFKvzXTG0H4GCCRB3+QD5Uk+t/Z5zu3y/hkhZO6yln
         vp7zvsAAf1UPcwvZ7VxXr36OIMlfkD3FPMhgwZbIpymXCNsoPZSpF5NYrt1rLg00xKEL
         6VwEpUhW5irNzuLBsgEf9LGg4Nl9WuX1CWUWS73ILw6Hs2snZ/RlY6nddG0sj6gsobRB
         +C0z9udkyAqn3BOsNpjCGyNSGVfWEym5aaCEu1MJxs09c/YP29iebs81b2cw7/KQlMlE
         sloHS0V4dkAZr5MONYiYpjnkO935sTEket420R9aGkdAI22CaUi90NhD0r/sxs25q8RH
         qFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SGqpzMMXOxhLnysXHPX7ervAuuBOMpPxjnvIFfmSlbo=;
        fh=Ed9dxZO1z0quVT3XjY0gdtjRdi6buOvDMlICWxipX7s=;
        b=YIq+NOphDOarvv4j4xOqn0pX0lSpRH45Djkr9J55bJZ4Rwq5NkxUWUGT0NCrkxYlK1
         6GMIuYZ+rGVw305K/gg+ty6eGtz88MUjCLGCqFcEd/u127HP6S4s+riXLxwzF2oAv8s6
         GS27v+OxqVEMDllJjJkLEqSY2zZMKlvWeVn18i7a9SqNinXlMy/+HolCwYxx8pv3OeML
         ijVHMHD7ajMu8UmouvKrnRCad1WElvT+usl8zSzWXeBrQIAq5hqU0FZDIQlwUPb09oZY
         nSZ1aqFno6QbTX9ubtoyU8wlE+jnOPAcrM/z8iqrsL0xdaruCzlEUPVLNom1gbI+rJQj
         jsvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443550; x=1796048350; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SGqpzMMXOxhLnysXHPX7ervAuuBOMpPxjnvIFfmSlbo=;
        b=ia/9bOu8jSdEcdklu7sre/wKzZoFdki81W2YJr5dws7NTbMa6eVh8vfd8h7EZAJ14D
         zJ0mFNzTG9vSV7EDC7ZzObA4FfyyFHJFmlg2OfQnE1GzlKJYEiaPGS+81TXDzscV3Lmf
         e1X/UPfaxn/OuM29vOeBkbikjniBtlasyUheiBxZBmZndMWZEYV/NoVgu4CKY5knEIJ4
         FHLmL5+7Zqnk0SKhO1f5Rpk1eEaOfaYiP0nRtrE5LwUEhOM5CmVruhmq/q9f3TExFydB
         fjuNhxX5EXWG9T9dmW5z9mMjNIKUvdWzXZN1cU45mM7c3rZLJkxX3+ShE2gwYEV7l3VB
         J4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443550; x=1796048350;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SGqpzMMXOxhLnysXHPX7ervAuuBOMpPxjnvIFfmSlbo=;
        b=UC50wRhcEjDhrchxWPxLbHB0ZlgLklNSsedKkYBQDebb6Mirr76au00SLnKMLnJ/zN
         0gpCQ+FssTIbZ7i2NTlwV4RbLNdGL1+fvFZRG6W0HOGIe9+qTHr6alWQONYu0kYZUZn3
         rDG5TXqBaEq7TcWTSEOsFvqAFFHUhi25LzkiwXLS2rJEWOiQADDf0v1yoKJcLqSPCaqk
         tF21MizHyhJvpiK3i5sEYK6YDIzRqOI1X1GsaZSqZJBkt3K9jqlaxLfqAnGHICY81tUQ
         jU7TZhnQn/6ulorBMKKTLuytTHg/WDE6Yrzb+1r5DwYRnAQBRJ3FCf02p2Cgi69tdiAr
         wrZQ==
X-Forwarded-Encrypted: i=1; AL+hErEP1Q7yapoZiQY9ev45j9J1IPBisMyrIxkyZzO4Vu1tTW9lBz7VG84cm0hVEdbTsNhh+T3pvdQvaMY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9hGqXGcAbkr3RLsVNQZ3eCo+yFi9i90CB8DdnfYZOWx340WR2j
	pmpwypQclRVdkBBFM43nMci6RDKbdsb55Sn86j3hYiwPjQJcBabik6wgUDmeTuxuWyWEetRe+Am
	I2qherEiIk7ARvPxiCoyye4gWE2y0fUI=
X-Gm-Gg: AZFdTZesyp1ZDn8r11e6nKVlYasjMhZkkYkYqmNXvcaIAkQY9w5EQbrDOKRTxuNP3Xz
	0GmKVYz8Za4q5TBRc5lfrM/EFdX7yPDjcNqN9F8AqQRpB/HRu5k/HIG1JN3MR+rY3+SJ0Ip8t0C
	MvrTDQhmbi7zFWefgzTKNykC+e38zerYhuJqmLi76qGlHfWX9bFpEU8hCE3PWpuLGFBJvVwEwBa
	Gd3QVlIm5T+teWdns2LhDHqDS3ikrd+fEAsaUIzUw7UWxoiAsGSJ+8/JSsyKqVrMwnxXaq7cPsG
	aOkEEWmHRRx/fzCZWBhGfgQI5o18cw3bPmVLnmEl3BvXJYg7ALcyCi+Gi7AH/q8OaBZ8/hE7cr2
	EPmGvwu51ZBdDyPOIJFnVp9tfSMCBczrmorUMvEoy9x23sFfgMp7H+RfN+n0FSgXnWv7I0g==
X-Received: by 2002:aa7:c61a:0:b0:6b9:86d:bb5e with SMTP id
 4fb4d7f45d1cf-6ba37e91e14mr6755202a12.41.1795443549130; Mon, 23 Nov 2026
 06:19:09 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-2-koray.fra@gmail.com>
 <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb> <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
In-Reply-To: <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 15:18:57 +0100
X-Gm-Features: Aa3M54qCw9X0Tb0EaHQOCg1GMA-OBfzeB1bXtwNxs39Fn8cRfeeS4nOAW1KHDXc
Message-ID: <CAOQ4uxiREfVU-WKiUVRZLb-uzMXzDEsmG13FVMW7YBoyq10=Nw@mail.gmail.com>
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
To: koraynilay <koray.fra@gmail.com>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 3:15=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 9:42 AM CET, Andrey Albershteyn wrote:
> > On 2026-11-22 01:08:54, koraynilay wrote:
> >> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
> >> in the main body of vfs_fileattr_set().
> >>
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >
> > Looks good to me
> > Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
>
> Thank you, can I add this tag to the v2 version of this patch (since it
> won't be changed, and link to this thread in the comment section of the
> patch)?

You should always keep RVB when re-posting without meaningful
changes to a patch.

That's how reviewing works.

Thanks,
Amir.
