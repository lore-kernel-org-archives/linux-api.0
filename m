Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4683DAABF
	for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 23:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792367621; cv=pass; b=GZ74uJaW43QN4RMCr7KW09veo2s1o68F/zjUSsU/2hrEoRwmc5b5HSgwiJYz3OljfprvhjLNwpN72QCXGT5/Iy9RJ4nGzCM94kH1hjARCeh0P5nwi5gsdDRaV80awu+UyVHHTJyuztx9S1KrFwIPHgPMefbCsEfK14QkdL3KINU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792367621; c=relaxed/simple;
	bh=ikcStFONhfs5hokFZ9u0J5DwZzPFduPyuFeHVqSmKog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pful3PwyDJZ67DSsFUNXjDR3auRM52vkqHc58eQe3UdypUYksg3c7Z2t+kbUWj/ZZ23A709GvMYkbNDzz2Dd3EDTOVCxG80pRIyQ11sreuoF2fkUvugl3wm4IqVQ3fd8BQezLMdsnmXKtSXkqTbthU2NSNokSAe7eShQmhNsl/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZDgA8XP; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZDgA8XP"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so881282b3a.0
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 16:53:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792367620; cv=none;
        d=google.com; s=arc-20260327;
        b=RD82vU1cmzG5CBzhu70JmyxxcEiMTo4+nhy6aoNi02uoHtVmC9q5FQQwy+cj1Td00E
         xpIY4+CmPniAzhnLhmq9+yvquGWgKvZa0EBayyyCqfNC28luFBiSN26MRmAdbRRvA6Bk
         pShg7FD/ulTq0d1pSogtD/Yn0gvzgo2+HE86caCzz7AjIDy0sF1nZWW+WhKZtEpD3Gbb
         DI5wefLcOj19WxtJaQ/wpXMHjGNHeqfSLMs1cQJp7B1U+WM37i4DZi/NFeU8p43h/JBN
         lX4fYBrP+Scc5P04cAlVRGVHkZhuiTCXrT/IBEBySUsa81Wv0WRy/I302xQei4fSjBgx
         Z40Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ikcStFONhfs5hokFZ9u0J5DwZzPFduPyuFeHVqSmKog=;
        fh=hU76SRw3Ju6sua35Qq6h6dYIhbACXv4kxVRK6WstiQQ=;
        b=cm++lHvwjbLdkUqIz4fTnNReeOUTXdeEMR3PNIO+dp8SwjjSccVWix48IFiWj8gqCp
         vHUB/tFoZyAHud+x1lpQo9QEIHPx4faEKAqiOs+yrwxsUX8tleCX/woCiTF91M3o5qnU
         b3w1nCRCA+B6vAiLYEcQ4Zz8/9U3IYTygU0JhyRB1I75njg6esb64wOeqnbXj7u0jXge
         wkfzF2WsmYWgTyFmFPmGlKe6ZBaT8aIInmZF2cYTC8J+/7dB46PgmnnklStcg3+jG1Zs
         b+Lcil5hYn+fEh3tDRy+c8w66If8QEbC0VefAonO1eGxqftZsHK7tmQkQImeRlBE28qs
         Lvmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792367620; x=1792972420; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ikcStFONhfs5hokFZ9u0J5DwZzPFduPyuFeHVqSmKog=;
        b=IZDgA8XPxtSh5SmNztAw9myhG61BrYOUczUp3QyZ3U4M+b/31OnoF0hdpSfL5a9W5k
         SpPaQA4NCvjY+GWzDVkjQV69DzntUDS4Ha/r+7fZn86vIwu+VmFE45/Ck7dzcO+W0JVn
         x/My9Pz7dv+WqOzz/StA6xrhvATJoLdO01IcgioEpSnVnJWn8Ogdya6qJUpGNhte2N+Q
         GBJYQQYzLlELK87jq34hmdd7p69WK4c2g3UfEFkmE/G5EmOvx3d/9U2LaVcqjo1YUb9j
         XX4j1xByvqrIP//XQuoJ6Uby3mYfgTjlMF2qCNt9T/2+eRhh6IqYmuOcrMis2cTt/Bhr
         8w6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792367620; x=1792972420;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ikcStFONhfs5hokFZ9u0J5DwZzPFduPyuFeHVqSmKog=;
        b=y21h81GsegiE2iGWzQcAtwl6CVOBAoF0SkIQJK+PvovwAa3hbSP8O31XsNbfaz6Z+e
         ttoYzFFDc57S5FAF8kO30axw+aN1htptq3souHAAxMHR5ZYM1MW8DLaG0pWq5ovqeRwz
         raQHs+nOzp2YE9H4IetCgZp01w0FInumcjtibCRn/8pFzYmiJHh08BjDzcXbIvu2jYXm
         oW2LM+tnOCUuIdI9Pt5P1UimbXsXkW5mRPfWSWaJ2qKSbak5g6qPMdTl2t8pbI7Hrzi0
         tKrcCQvToAAUSAilbQONbcGFnJv5qkGtRRpqRNUr27gN6Xnz7NmpC66HqeQ6cMoM+u0W
         82uw==
X-Forwarded-Encrypted: i=1; AKwUvBy4XfcWz2tMMzaYHK9jdnPUL+7RTy1J4w0iWUaJ6a5JP2Vygro6R4sHcakBsG9socmN4WgRUzDO/tE=@vger.kernel.org
X-Gm-Message-State: AFq9FYIq4hhbJLEsxlkIy7cSH0am20jv1McUE35sKlpdEQhbkXcsl8gv
	ect4lTglz9AJUxVhNzguHTPHjnrZl03ewIph9AJSk1BQNk7uy3L4PCzVkvhI0yecmM5b7VntuXd
	L6X3WRm0KXjyMWokFt5SZn7KqHazXJu4=
X-Gm-Gg: AYBFou3CNCYwNruh0UjC+RTC/kwFwlJqGSYkKo6/RwpvNlcpHZ8GRpkjGB4t0/SBNr5
	Ajr+qWYBr1SE8R/Yr0sVoMaNaIPiFzs2MV0UmwFdGP/DFce8kHHYzfizI/dJG2LBEO8HvSXdtul
	tOhpLg18B5ykhJNW2aLEP3X0dGfWVI+LRmIqwcoILcMMoAvc9g4e/9aTOrgThKxEM9zHtq47MWB
	fuD8RiYCaGfckxm05cU94hEo2o3dOn2Pd4h1Se48KstlNICdp90j968cxQYKFTvjRucSTgXrx6C
	BjjFzgpVR13BvISOBJ1F2Hy9NxDxaTUpX63cXqII/0eK1QRymZY8lkjKc/+ctikEHML2sb3hgWS
	0wVPC5Z0ZY42Ut0xTjQ==
X-Received: by 2002:a05:6a00:1806:b0:892:597f:37d8 with SMTP id
 d2e1a72fcca58-8a04ba18454mr4779902b3a.15.1792367619719; Sun, 18 Oct 2026
 16:53:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261015145053.3664509-1-jiri@resnulli.us> <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com> <atPgqROZZxnihYfC@kernel.org> <20261017231007.GP13920@nvidia.com>
In-Reply-To: <20261017231007.GP13920@nvidia.com>
From: Dionna Glaze <drdeeglaze@gmail.com>
Date: Sun, 18 Oct 2026 16:53:28 -0700
X-Gm-Features: AclHuK9GuI1sFp98b1K0khmGUju9GL5ycOOU8Mt4euoyLz8UHj6wifrtGgAMHK0
Message-ID: <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX support
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, david.quigley@intel.com, 
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, James.Bottomley@hansenpartnership.com, 
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com, 
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Content-Type: text/plain; charset="UTF-8"

> On Sat, Oct 17, 2026 at 11:55:05PM +0300, Jarkko Sakkinen wrote:
> > I wish I had a better picture what is going on.

Me too. I've spent my Sunday with Claude trying to build some
understanding of all this stuff, and put together a static site about
this series.

https://deeglaze.github.io/scratch/ctlv-site/index.html

It includes a review that I've personally walked through to ensure it
wasn't off base, but of course we're all fallible here.
I haven't decided to email the review comments to the list yet because
it's pretty thorough for something posted here as an RFC.

I think something to be really careful about with this series is how
it's managing kernel memory.

* https://deeglaze.github.io/scratch/ctlv-site/review-02.html#reply-7
* https://deeglaze.github.io/scratch/ctlv-site/review-04.html#reply-27
* https://deeglaze.github.io/scratch/ctlv-site/review-07.html#reply-7
* https://deeglaze.github.io/scratch/ctlv-site/review-11.html#reply-8
* https://deeglaze.github.io/scratch/ctlv-site/review-16.html#reply-30
* https://deeglaze.github.io/scratch/ctlv-site/review-18.html#reply-19

Something I and some others dislike about IMA is the unbounded log. I
don't know how many stalled proposals there have been so far to permit
some model of "snapshot/endorse and truncate" to allow a remote
attestation verification service to store existing logs in object
storage, measure the reference and/or trusted signature that the log
was "good", and then drop everything in the log prior to the
pointer/endorsement event, but we have a chance to start with the
right model here. I liked Tushar's talk in 2024
https://www.youtube.com/watch?v=5cXDrIx8Qgo
IMA carries its log through kexec and this log doesn't, which is a
hazard to later attestations that don't have some other out of band
protocol to associate its boot instance with some off-box cache of the
rest of the log.

>
> Currently we don't have an intention to flow TPM command packets
> through this. Anything would be a high level operation like 'extend'
>

If you're not intercepting all extends through other interfaces to the
registers (e.g., /dev/tpmrm0), then it needs to be clearer in the
documentation that users not using the interface will break users of
the interface when they both target overlapping sets of registers.
