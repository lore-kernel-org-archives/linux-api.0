Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792426243;
	b=J0yGnAr2UEHE4xtat97hRc48jdS+j+9LRJ3kDh4nDwROCrcZacCGBPIPEIihfqm06q+p
	 8GYz1CWroa9EPiaMOjFhCpYz79hhOOwbpkv5nSGW6+5Ao7+HFgO3BNJJvLrtsrsxxeBJi
	 5i3+kEEFeciKnLAHpFFqdVOY+AfrSV+sV6VbGz0dRvNHfQLhvL3iTDTv4DSTlvbe8zm3/
	 jg6velbUQirHWcj0aks6JHzuCwBaDhnNlKbynpJsj3P0RLkJWDFT2mOelylhT5AV0LBmo
	 PBSqBxltC7qBb2P08FkDa1mtW/KLNVZJceZAy3alZ68hm1hVyc1Oo7UJrHB8rMR+HUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792426243;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Kf+lbs9v+6E2jWFkaeqWJS3Ibz3SI0AKrIKdFU2DKIc=;
	b=dkyYanCeEJW7as8kAhOB3Cf6Vo8CgaTovjbjdMdV2k9HjGDmlVaS/44R73DbogNv6tfU
	 njEOw3HOFXH8j82rSXNTsw8H3J7l9/+Xvxwo7/IGAM47MyFMkbBgRnJ8RSlCeGANz/Ojj
	 v4IFBq2tUhOUpJVh3kq0GkujxZZAFOeXCorBAM0t7ytPnLxdQy71d76uZ3srI9OGuHop4
	 e+xvmXKsRFB0+ySKaM1QY58AWChvmOR7iN1clU1dNabrUUn+WJleMbNKrOctwRz12ZmiA
	 wwtwW/SdNsu+qcW7XRCVkdlTFUMviSPr9uvj66FIWrCjZr7AGfO2ul+Q0NKmOgnlpCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="nwce7S/v";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA33606A33D
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 16:10:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EA33606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nwce7S/v
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac7c7b3a90so1082570a91.3
        for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 09:10:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792426242; cv=none;
        d=google.com; s=arc-20260327;
        b=kKgt7Xr258/IH2zYn0Guob7aUzVAD9qeYDrnH399WeUsPm9drtbfEvOPXJ5aAQW5T6
         rZdrHkA20JyQSCvE/y5EPXtd2W48EDizjjYq9VIrwC5ofHW9hGVVayt2eLW4Yx+KWjcc
         kAUadtcyAGpVM+GRvWJvMgn3rEqVevbJ3qnStj3ElRT2EUUB/Z4Sd7fZiCCz8wxoHHuJ
         GPLNhkuf0J6gLiH5SmRP1I0FMab6/G33tTNaCeykp3SgTyS2fdIW1bPge/+wDG8c7aSr
         B1stSnm3kYGkQosnk1ecPVJU23LXqz4v92U4A2zYDmVIeFP55JiT1EZpxsYWIRSrzTDe
         T1ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Kf+lbs9v+6E2jWFkaeqWJS3Ibz3SI0AKrIKdFU2DKIc=;
        fh=aIXHdBz8ir412bXHD8kc1upIcdHU/VpnpnRPIuS7D3E=;
        b=lcUH0NTSpDRm2wIBAXWF5JRtKk1QXF1DWuj5rduUAbd3RIPUFBSOVqkEdaiMckOIKP
         EgKEkloGdPM5bZ2TNY8fCv6GnszitBLajHWUOCneDiyEfm4UM1K7Mf78QSMrHkEX8qAv
         l34ElYhdKN10jfxbbQV0jY67RogC0qxNVEz3y0KOs/0blCA8SFflcLA+UJ1mHRr6pMia
         XCmq8Cj6r2Os1EsDPrzGXRXyyUq3TnWJuDLPsBR91K5GIoiS87LuYg0MjnqA2DkNH1km
         Jxgu1SZy7/DDrswCNlKMism8LV2Ta+9HCwdkJWqXpVVVFez4XPPYsI1OBFJzwkmJQH8d
         5u2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792426242; x=1793031042; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kf+lbs9v+6E2jWFkaeqWJS3Ibz3SI0AKrIKdFU2DKIc=;
        b=nwce7S/vTMoqAwf5xtwZ968yrj96v05xwkxb+d9Y46U3mzPEw4km19kPH0dhCTAgYa
         mvEBSm7ZT1Qd73u0W/R/lgY4ohvJK2kJmlP2pDVYZ1dWnjRYo4odiEdm8yIQ9xd1zS2p
         ZQfy4TMY/8l35JpqV3IpDrguh/ZNLDbwOv+FocYxVqScWejzksmBbR6Vln2Bx9mOHGgy
         FO+h9DRY2ZZxAUcYA4MtTPYNl+LjRjZp1gcs91wHRgWSwy8y/D1nIUpP7Rnnx24UiiP2
         SXnWod24OTqySi12VIlVziSl/692SO1pN289VM9uZT95tHHcTwXQ8sv/YWgYqK/9LEKI
         RTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792426242; x=1793031042;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kf+lbs9v+6E2jWFkaeqWJS3Ibz3SI0AKrIKdFU2DKIc=;
        b=yACMN7TkodLnwCpQzBP4gGPJ0KMD1oCpDbLFE0rCi+5FvMBMRK5/Pjxm9QSsXBJ7sJ
         2LdAbf1//D2gwhL2c3HzB3nTiML6eK9Ac1rxg2bE0luvw0C36WPXrS8strOpsnwW/KkG
         SLI3m7jZKLzotla1fvur07+ankiPIUlZP14HbLY+AM7CFXh19dWJI8GZaD3m/ozr33+h
         W3vwdNyi3BRTwNdwDUu4ZzMwkNqCy4MLMUhhvC+S9baKrYMAr29XSe0qiNCXtlqfdpUl
         0tg62Fp4KDAaPQzjydb7RoKNuMe7qeQHXkKHKGnRweSydIGMTLkJZTILXf1fKWY9lACY
         aEuA==
X-Forwarded-Encrypted: i=1; AKwUvBwkAIwzDipuHPEbruWCNre426NsyzDtWTEwFZVzUdwQlh5NLjy/EGbrYqVeuAjxi/AMTzdWR4+95GE=@vger.kernel.org
X-Gm-Message-State: AFq9FYJmb+AnxYjr1ZVxUVHsnOehdLf3rDOIOOUrwLG3CxwBjhWE9qyt
	1uyh7I3/vLNmyyZUr2w8Lp0nnS/2kOwm2CiipXCfSmwCgqtHYr3i9QShShw/wVFS0qeer6lTiS3
	LNys/NuBWH9b6fomWTq9/WnymHXecfGc=
X-Gm-Gg: AYBFou1gqgEdlcmwHKtHlHiGQUFBtcdxv0AJOauDi8+mTv3d7bcID/uEvrLYUQcF6b7
	GQvaou033IWqCd24YQOSy7tMIkMOuFr7NgBjUgm9sGRmAKc6vLjEt84B13/Vg3P5YcdWqyK2duP
	7+QP/swoaOzE0ix6bNewEnig3f0TjfDtN2hg6hsQL0NtmIZuTmSagI3Z/bNILwUWkZ+1z+u3dHc
	sslTqnSXs860hbGzFSxID+1nqGbkh/zz2dSeZzJoHgGC4sN1GmjN8eKV3CpA+4U6ccTB7mQ49kj
	owjK5Stykp8ju1y/TuOu5HBhaCdCgwtVjCNgzj7mTHcFcznx73q+cpEiz5QRigMnjBaRgo5tjvm
	lXhgaBP70CWs/NejvAQ==
X-Received: by 2002:a17:90b:5623:b0:3ac:9a54:e3ce with SMTP id
 98e67ed59e1d1-3acef6391ecmr7235023a91.63.1792426242489; Mon, 19 Oct 2026
 09:10:42 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261015145053.3664509-1-jiri@resnulli.us> <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com> <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com> <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
In-Reply-To: <atX9fugGUsI0hGcA@FV6GYCPJ69>
From: Dionna Glaze <drdeeglaze@gmail.com>
Date: Mon, 19 Oct 2026 09:10:31 -0700
X-Gm-Features: AclHuK-94VeGPXxFeBfuxcNfO58AYvUbUlLP8AwazUPyHejofcyDyE2ymf8gT_k
Message-ID: <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX support
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, david.quigley@intel.com, 
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, James.Bottomley@hansenpartnership.com, 
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com, 
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com, 
	roberto.sassu@huawei.com, zohar@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 5:08=E2=80=AFAM Jiri Pirko <jiri@resnulli.us> wrote=
:
>
> Yeah, I was thinking about this and went back and forth. In the end, the
> only reason for leaving it unbounded is to allow multiple independent
> users of the same register. For example, IMA and systemd could share a
> TDX RTMR. The systemd side would read the journal through the
> attestation device and the IMA side through securityfs, but both are
> views of the same journal. If one side truncated it, the other could no
> longer replay the RTMR. Isn't this the valid usecase? Do you see how to
> resolve this?
>

Bright minds have spent a significant amount of time working on this.

+Roberto Sassu, +Mimi Zohar
IMA logs and systemd logs are both system level concerns that are
relevant to the OS construction, not individual users,
so I would just say to reroute IMA to use ctlv using a kernel config
setting, then make systemd the new system manager of the holistic log.
The securityfs log contents can simply say, "log managed by ctlv" in
this setting, in the form of the template identifier.
For policy violations, only the 0... extend needs to go to ctlv.
IMA can still keep its violation log as a ring buffer when it's not a
1-to-1 violation to extension
https://www.youtube.com/watch?v=3DgyYUYbdiN_4
