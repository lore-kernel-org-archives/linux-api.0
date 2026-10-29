Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283391;
	b=qRoirueYN2e7K57d6ld05XqaQ2sePItY4mfDzjP1PL0gTyG8DD2XtI1/Hfq9yh0lSO1W
	 HUU2bmAzLEJsr6jZPmrxg2/qTfKWTBCge3Se3y9DCmUSaGzfd8ccco9YeZ0UTyqrv2Ucy
	 AAiwoq4Aun8CAvZ15XlqbBV30BSJcoMbNXWaVpnXMHjYKgjoC8K8hKFLjNpyI5dflLesD
	 KBVW1UxnxA+1+MueOFMg2BUXABOn8oZiBQxYvVIKIWbtGWWSMcQIeAb0NugxU+JIu5sQ5
	 J6ZitAnAPaIkA9joAoGlBddQlnOrpXIT6QLdX+ezIxJXrRxAV2ajq3X5ThxbOEyvA1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=v0w3vTM41MmYY5jFFnm91zARv8a41r8bbrucc1w3RPo=;
	b=NSKvq4nSuYR+8DfzkO24EIvH0GT5HAn3B/imf7cFzhlhh3F8vXoUjcaX1gVR8LxO/DRR
	 xKcc9s2t8J86z3UNHxZa7wncP0o8//ecuCKdCeT6N687kXE+gKqhbfdA9dMP/8dvWnA39
	 9n81qqVnD70ILDqTA+mZd88xjcamFZsOSO0lrMJ96bRQYOhROn3uA2vOGjfQBlZ6/zYvj
	 pCqHdp/bi+6mgPFGOQCMqP+M0sNjOZE/NW/GLzpqOClMtAkDx4jIuZZ/aAbz6qYVPaI+N
	 Gr2QXgSvhohytfTxR/R/hHU4DCHDBlGNuZMg21NosueCmjwU0FFALAdt/C0b6PNUbtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=K3GWWvW6;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A6C606A31F
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 14:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51A6C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=K3GWWvW6
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-533797e72e8so13691791cf.2
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 07:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793283390; x=1793888190; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v0w3vTM41MmYY5jFFnm91zARv8a41r8bbrucc1w3RPo=;
        b=K3GWWvW6rB7cRoFkVogJ2KSZo/0Y/1HCDIRdHzAIwLoLDsyMicRGMjOseGev/J/xTf
         7GktCCuPItsgUn+ypTk60UX0aWoLaz29rDEd+7ry0VKQZgmxJu4rxk9u/82PZO0lHBoj
         a0rS4Qcv1UTo0qCGsLn097FMzPIIosJ6Sq/dM+Cpe88Ee5HToav+cCJFoWYUIenfBqwj
         BfXtQt8E5/J+XaBz+AzHqXbj9Vz+xQWJJQPIA+hvJei/SyQf96CW2nSLK1ee/Y9r1bUI
         sgaZ8c4K2r7GTls+1UpYG7HJCNHiY8m5qhHnc/SvL5F1gGTyDMBNiM4S9pBh3H/k7bQZ
         gG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283390; x=1793888190;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=v0w3vTM41MmYY5jFFnm91zARv8a41r8bbrucc1w3RPo=;
        b=dizkRbfO2uAEGyUfhFz3INKd+rSvL80E6GG3YtB+QSy1hb8r6ZkH/VFnVbKeD3hISB
         FGW6z5nwtPTrjPOHjKL7lWIVrJskkH66gc+AdrS3yFaDVZn3dHZbFwotcUnKIEvpUj/s
         8bc/TbAGy52lOTI2H967Vbsut8lqhIPCzuXuRQCw0T9xMwhW9zFQmN4dscLjy6O0Vk1l
         ATHC5KghUtl/3+3UeDRCLJtYw5O/O3iFrQdgxLACNLnhYtVbuwSRuL/v873xc650a3kK
         4s8kzsZS9m+un4Yx9XpbuiCWg1FE2zgIEsj5HEbTYrLb84oID7mJqDEgqzwskaoTRL7d
         +P8Q==
X-Forwarded-Encrypted: i=1; AKwUvBz6TQPWN2q1V9JtWadWNZvjhDpClby0Xnfhry8bm0CI7+o1FwDjdsPQStS9+kZerhk4VGk6WIG7s+0=@vger.kernel.org
X-Gm-Message-State: AFq9FYK/99BkHwhB0AtZ1CtaMUmQ9f2PI/usz567z+YpXh1FYrPO0EQo
	2ORyEY9nLtzQO97spaFv+h1fCqJdUkZs3ltZpn7723quwq7CnwpTVoUUjMWulJ2dP+g=
X-Gm-Gg: AYBFou3sfxdGM02GhJRfXDkHyrnndHkjGlaVtGfYzDfmkEJkwaa+sZjK5P6pcgH3qvf
	ums33OMaO8uh1Ri1p4Hxld/cdkmYDlyV+YkgEDi7bbOSIiyKeGIknJo5v7gKZE5tDXx6IGpf9Bv
	GSKnsjCZcoSQ9wAGGKvZKr9B3csL210e+IMY30VIMYkrmiAwvaWBFcbscz9uJ06+WAQnZMMxw4J
	I/ryD2q9NNhPNyCCy+u2yqepoteBM+Ar9ft4chydWlSdgQt49dfrJad6+5ikKnQIa/wWQROLSFG
	W6h+PXoHd7zf7HDdEAPfkx0ZT9XmH9jJbcsyJxaQb9v1+v26Od9u9BwxzdiZGhQiPXGSPDejy2K
	9lcTi9S+Pykq4oVf3DhaWAqhcfvgAoL7/Hw6cJGv+bzvROacTyo8dBb2zF1YuajHjIQy36I7wXi
	LBX4tBp0PB1gwX2ZM9rzOkgKNwVwvLHlO8YCbAuyFO6iulP247h+SUfkSTa0j54xyTlv36zY2Ap
	E22m1IZZsgLWPwOjR/ri1ePWEz8FxYrIVkJaXvmVHtkHOAyQ+UXTdud4udGcYzvjWsEEzFF3h8+
	HU6DoDZlyREgR2AppzEYuQSyXn5XtRmbRoiyTgnkSB3/dRdCU2v8BxiQ0xzACCs4V/JgCLAkqTH
	xF+02v9Npi14=
X-Received: by 2002:a05:622a:5c14:b0:533:21c6:f4e2 with SMTP id d75a77b69052e-53fcb20dda0mr85167991cf.20.1793283389957;
        Thu, 29 Oct 2026 07:16:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c7f6ef1b7sm45505406d6.7.2026.10.29.07.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 07:16:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMQvb-0000000FihF-2QML;
	Thu, 29 Oct 2026 11:16:27 -0300
Date: Thu, 29 Oct 2026 11:16:27 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	drdeeglaze@gmail.com, James.Bottomley@hansenpartnership.com,
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
	ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261029141627.GP1685504@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <2a2a5d93-1c10-4533-8709-437ceb6a3f94@suse.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a2a5d93-1c10-4533-8709-437ceb6a3f94@suse.com>

On Thu, Oct 29, 2026 at 09:37:20AM +0200, Nikolay Borisov wrote:
> 
> 
> On 15.10.26 г. 17:50 ч., Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@nvidia.com>
> > 
> > Linux has several attestation interfaces tied to individual technologies.
> > That makes evidence retrieval, measurement registers, device state and
> > kernel consumers provider-specific.
> > 
> > This series introduces a common attestation subsystem. Its goal is to
> > support platform, TEE and device providers through one model, including
> > TPM2, TDX, SEV-SNP, Arm CCA, FIRME, Caliptra and PCI/TSM-backed devices.
> > This first series implements the common subsystem and a TDX provider.
> > Existing native TDX tsm_mr and tsm_report interfaces remain independent.
> 
> Wasn't config-tsm supposed to be this common attestation subsystem? Was this
> discussed when the initial config-tsm was proposed? Why is this coming now?

Maybe but it was far too narrowly scoped to do that. config-tsm
doesn't even include MRs, they were awkwardly pushed off into another
different spot. It just doesn't seem to meet the need, and it can't
sanely fit SPDM.

> > Attestation devices use CTLV, a schema-driven character-device TLV UAPI.
> > Compared with sysfs or configfs, CTLV executes one validated request
> > atomically instead of assembling a transaction through several files.
> > Compared with netlink, an opened device fd directly identifies authority
> > and lifetime, can be delegated normally, and owns its event queue. CTLV
> > also provides:
> 
> Assuming we want to go through the route of CTLV, do we really want an
> attestation-specific  interface, or most of this functionality can
> simply be

CTLV is not attestation specific..

> implemented as a specific genetlink protocol, utilising all the existing
> hardening that has gone into netlink's infrastructure to marshal messages
> from userspace to kernel space?

Been there, seems like a hard no:

https://lore.kernel.org/all/20260721182046.16219426@kernel.org/

And then later this:

https://lore.kernel.org/all/20260921131911.532d81f4@kernel.org/

Plus netlink being based around sockets and net namespaces is a very
poor fit for something that has nothing to do with net namespaces and
really wants a DAC security model.

> >   83 files changed, 18084 insertions(+), 28 deletions(-)
> 
> That's an awful lot of code to just move certain binary blobs around
> (Judging by what config-tsm is doing ATM).

Yeah, netlink is alot of code.

ctlv is trying to solve a bigger more general problem than just
config-tsm.

Attestation is simply the first user as it has some complicated data
structure that suits it well.

Jason
