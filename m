Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792637633;
	b=lHLht+qwV/SlCfQ6PWR+eL9WLf/mpa0uogBasKfJYUhWZ0yFilKcXQsGS5JV1IJ6VBZG
	 gcvy3CGWFFSOBuUHlwEnNWk3CqZo2PlkIC1qyaVYMOIMKV5xZIz8Mp6vAocKNGqP60jFX
	 YeSEGSTvPaEc9I5IWmgH8w2EC1Ma8lA4ljmYjcviJNw018oiAy1dgX1n+CzHbtiIIh9em
	 xq0g3H8bDs4HkovtpER+prmxmjost215avfIHH3Mqke9rnYhF+IyLDAaiPPQilfC5X0Af
	 4YIL4OH29xr7eWxm7DfuwKACcDSMWFFSboLJ6q0BPNywXk03bOfgBFVb3KyEoC6RPZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792637633;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
	b=KSYfwh0fxs+OGJkrLqjf4EhUXIJRn81gaXFEpXaQ+WuDbw6Pm2e8D0OJM8HlQje5A9PT
	 Xi5PtNiGVrz8aOF+vJAFHV1FxkdMTE/HW0O1wAheer/HLttjOM+3rntcAh+COjEBg8vQt
	 TLfN+yUj3xehK/uWCzMFBqJHYTUGRmDRA3Aim+YTVirhqHszrhkARqN/gMfDGYkudz+8e
	 gns9La3QhmNmFD8WLjIcV9A29aa5JKFCaPT/xwOTDHAHbO+FAfaeY0tI+0G7dr8id2MIs
	 3iUcTJJCj9asHWwjvKX4aVQ0Ks7OjxiBh/zZD/1ouddDPw39OuiMtbfk3VG8b0tNQIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="DTOI/Pek";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEA9606A324
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 02:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DEA9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DTOI/Pek
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so195494066b.3
        for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 19:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792637631; cv=none;
        d=google.com; s=arc-20260327;
        b=h6CYPTypLfnbiivj26yiSzCNrQSvr6jWitMKjlYi7Yc9DVShEN1Qo5ZT4dX1rKGPUM
         Oh6fmNGAsbxCaGlPJ8gSyTaRgcLhrjXJ+Uk8+fOuBXznzArjkTr/hyXwsWLgCa4Q7oLi
         qz8tl6mOnMxoOT7uGITPEzUnq+7U8KlOQTrIvzRbx0kdjSa4fx1o2dM+58Qdb8HK6EQ6
         qMSnhzFwPxC1Ppzl/YPn89i4dEv/Iqv2uS556sCVjG5fqi03q02OFfFzwd2lm3PGsspS
         sUrUot0v53xFmWfIg5WgyXRgrph6oP0lG8jAqMzzPdzMLqrqIqZHyO8r1bHmFjSv5fHM
         gh/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        fh=uQsGCkOYtKm5hjo80I1Vf9ci0A4mk96XoXATH5usaYA=;
        b=YeKt12cH+Y4IbP1iVQC4acomOsWJpUnvpPE5xIogprnQCnybybrot+3hTqjxeDX5oS
         qvCX8N8mJcq1VEpYbt5MjI33cQSDi5HC2N1bdEo3FGpaoHZx1SeeZM/IcVhzI2/MQLNH
         euedZzqXhovf9RYXpVJmB7EnA11dKk4f4dS6GVcOd7zNBOo9Z51sZQcxl+O0IhWin0Cs
         8YB40WhqyR3y6+nDR4NPLwYjMzmEpFpSpLCCnfnu6ipBH4uMERjS7rST986U5QiYaicO
         3DjL8G7v356x1y1hlhMvGAxpFxfcpiO9Vx2aeNSVFYdtpLYrz+vpXCH83ZXFq4hqIP4n
         71rw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792637631; x=1793242431; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        b=DTOI/PekpHCFwbCxS6btLnjWQNCiYVc9jJXCEYwAmPekEK8t/PxBNEKZNgCm5yMo5O
         ZHRqWqq6Sa4prnp5961iu97eKvO2fCe1P/oDhQUuXQyhe3en4gFePLH+ndAycKrOkdLY
         ZBtVPzCtW837QZIUsvIlXqXaajHAOKuqlnaym36x90uyaZGBsQGk0lDoH47TKDdTDSv/
         +bNghojo2jLNQuKI4CGPrg7pLnnWdQfj43K8C91aQyr5qb1zEo8L/J/KSRypGRSRs42E
         gu3hUif099K3NIyvd05k0+GuTWcbFOAPWaSRNh9N1gfC8G9MuampVJBqQHApn7d+PZp0
         CiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637631; x=1793242431;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        b=X9sC8eqUjoZd8qsqbE8gBId3E3KKoIEYwZRWBhN0iWTmZdh0TWPm0+VqumQjskuz2N
         4kUV6ZCZozVg8xNoVrUZvABpv3FHettUUU10Tzqpc8zH9bDg7/F0fPzSFWQ0yPM3r7Z7
         sVin3SqrxtBMj6MfnoO7TEjlJl29XJWjMXShrOPfdI50iL8kXuFwobGfV+g+VmZo/SWe
         gUJi8UADLCquEZvENdT7EJgFXfhu+p3StHw3Roi5D15dtVl9iF+Y23+/Cv/YIKBNVGpG
         dWCy72A3MMy13O/NyqrL1I0eLhEW5SwON10HZdE/BfjkclOO0xtVK5PPa+RwoVxTi0/T
         Oiew==
X-Forwarded-Encrypted: i=1; AKwUvByG0ts1fzZqhM21k/XhWMJQ+DGmTqMgo7Z5CjIMjWZVU7JXq7xLJ/OhLy3ZKMUkPPMKHiFqWqmBDKg=@vger.kernel.org
X-Gm-Message-State: AFq9FYLJtcByLSdyMG7Lbdfw3B0c9wSz6A/w3/2u7n6sA+C2o9ZOFxGM
	ewyeySdaYgOPMEsgk2QuB4Yrm239SlP8mpcSWJSoVSZsZKkaD9Z6IoWLFEBVeRXlSZpmitu69Mo
	GjXxhuxlv6JEqoK67ydPYuz/7A4Z4a4o=
X-Gm-Gg: AYBFou0ADyDV+BgKWGb7jQYguT9/jgfWEyMXzu60lnzGY4xG0BrJX+ogJyumiZ0+Ncf
	QIWM5p5bv+8aE+dcP0LxTotVw3n2ylM89azT6eUQf3qMOX8tm4s1zzDindB0a4rNGlVSuCOkPcN
	c3Nd/iteyBuq8mi1TejQvQIw/gubrmEd1BwEqQfdpw4Dft8L+2z2MrJQaKz88UEyOmpWVWLLbEL
	3q+Q2PqjLukhFY6uVG6FQUnu8l2KksgNVjzxicivWuhnHItoZfPDm89JPa9WXRT4gFCefK/lxhA
	wKBrfaJnzVsOEmiY7mpUsatcZJhIjEk93s3KjP009BjPqRqufoRh3mBKPyOYUY7+5o0q15XBqdM
	xXYcGjVIckUE1cHA30VzqcaLTwIPMoRFwCXCbOo1P5KMXvPS3YxR5/wa4hg==
X-Received: by 2002:a17:906:ba84:b0:c41:8e21:4d60 with SMTP id
 a640c23a62f3a-c46791326c1mr341731966b.1.1792637630664; Wed, 21 Oct 2026
 19:53:50 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1792552161.git.jan.koester@tuxist.de> <f444dffc8e6bf98bf44c02456adc2de40e4ecd95.1792552161.git.jan.koester@tuxist.de>
 <fd20b840-350e-469c-9fd2-008fa0ded62a@slotpi15m67>
In-Reply-To: <fd20b840-350e-469c-9fd2-008fa0ded62a@slotpi15m67>
From: Takeshi Nishimura <takeshi.nishimura.linux@gmail.com>
Date: Thu, 22 Oct 2026 04:52:00 +0200
X-Gm-Features: AclHuK8zMCY_XzKvgZWVeEW29rK2WIKSmZA1a7YbTdfyZ3EtSnPZJ1CNUxd7pQ8
Message-ID: <CALWcw=FYKcDNXeArpsabHiQOAL+cWkF=L3stL6MB0OvVaHei1g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 40/41] nfsd, nfs: carry UUID and GUID owners as
 their text form
To: Chuck Lever <cel@kernel.org>
Cc: Jan Koester <jan.koester@tuxist.de>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, netdev@vger.kernel.org, audit@vger.kernel.org, 
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 7:44=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
> On 10/20/26 11:16 PM, Jan Koester wrote:
> > Encode such an id as its text form -- "xxxxxxxx-xxxx-xxxx-xxxx-
> > xxxxxxxxxxxx" for a UUID, the same in braces for a GUID -- in both
> > directions on the server and the client, and take such a string (it
> > has no '@', so it can't be a user@domain name) as that id again.
>
> A bare UUID in an owner, owner_group, or ACE 'who' string is a new
> owner-string syntax for NFSv4, one that only Linux would recognize.
> Thus it isn't interoperable with other NFSv4 stacks as proposed
> here.
>
> RFC 8881 Section 5.9 says a string without an '@' that is not a
> decimal number means no translation was available and the receiver
> "should not use that string as a basis for translation into its
> own internal format." RFC 8000 Section 6.1 forbids bare numeric
> ids in multi-domain deployments because they collide; the same
> applies to bare UUIDs, and more so to GUIDs.
>
> If you are serious about pursuing this, you'll have to start by
> raising the proposed wire format on nfsv4@ietf.org before the
> Linux kernel's NFS stack commits to it.

I recall rumors of MS wanting to stick Windows SID in text form into
the NFSv4 protocol.

THIS proposal is even worse, in every imaginable way:
Stuff an unreadable 128bit blob everywhere. I am sure people having to
debug that in the kernel will LOVE the idea (compare blob a with blob
b as human,YAY!), and admins facing the 128bit hexdump will send
marriage proposals to the author, for making their lives even more
heartless and miserable.

NAK, -1, for the whole patch series.
--=20
Internationalization&localization dev / =E5=A4=A7=E9=98=AA=E5=A4=A7=E5=AD=
=A6
Takeshi Nishimura <takeshi.nishimura.linux@gmail.com>
