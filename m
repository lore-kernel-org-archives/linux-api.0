Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108295;
	b=IIX5w+VJxtekaylZFX8MShz+cJdDE9k6dG/9WKmPcICpxSVV+s/VE815t3dOll6Nb7Zt
	 pyMgwO8yDOHhzHsh5Pk2fUQ2f3k+c8AjE9e0EiB+fjjwIsxpMFhUF8ertobS9JpLJrK+w
	 YzNG7BNdJpD5MV9Cz9xjHqSpSi9z6CExImxkGJwvANAmWJXxZliavLxy7UfxRUyXxADVp
	 KUwXTFIrY+M6+1JtlWNJq07aYQoDhBwDA+w7DmuEoAxuSEx0DisZX/CRYATu8PoFHN4Fz
	 Xj/WB0HHGvXcKM9/EnEKG+3ahOCeQ50aICM+SdPuiVwG9U+b/M1Q5SI4ilhs16XxJiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108295;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=DwMd1KchjZwzPRTvPjggUQTB5i2EuHCeAYUv5XXUio8=;
	b=xxkIjtDSL/dbhVJe1dUmNGz9DCHs2bagTvvh6whmWCT9c6qOjLPBMC5wX1K143rcOJ4s
	 I3gjPANHxs78i2FIuUwCIOKa62Qaoj0F7cYhz5JKNVs23AOiqA+5gFOfatVp1iELPBWXl
	 D35uf7qhMhlQdkEj4ynshuFrq6CQEou5TaPauOAkGxiwdGlbotoZDzTmY89VOpyOwDsqQ
	 nmsWFmwfE9Mzkq7/98mImSAhrTHO/kuMUZ/xwrCl2jhDVcM7YZyOvxDC47lsHYVLKS0Ho
	 xrTLUchYHsTYAuIx2hVHqx7BPFloy7gQSkfmhicAeYcHZ4sii38yWA3DZnRFD0WmJNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A276606A31A
	for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 13:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A276606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c498e2d623bso267768866b.0
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 06:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793108292; x=1793713092; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DwMd1KchjZwzPRTvPjggUQTB5i2EuHCeAYUv5XXUio8=;
        b=HOzpV+E0YifEMJUFpo0mhCWAcg58n+ExvoMQREREEgzF4MnpcqEWwp8hHHC1tSxLfN
         z3X8Ruqy1Co8/BXgOHUAisorIRYaNYOP0BIFmJ9FkxKXER/FT29XCq/joiXcw1RrrZnD
         WPIfgfExZU1GuArzgbJx1i6zm4Wklz80ifrn5BCu9c0/0BvapHXhOUM6INm7cVcMfxyY
         gGBwyiQLFZBkXK6EM/miMfhP+hz9jUVjz4UUJsk87acHKsWT8HyWojfL3Sd0WEWzl7tG
         hGF/p8MDxJHcPmLDSVizAgqQGx5/u6SHLZ1cR91s832oZbGbyJaZXRE+Ajp9Dtuyv20b
         eIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793108292; x=1793713092;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DwMd1KchjZwzPRTvPjggUQTB5i2EuHCeAYUv5XXUio8=;
        b=nRd6TNXreL4m1aN5OsrxGeeJxTYpbbee3DOPZqMDk8gAJ8MY4IDj9E2n2pp3yAlutM
         mUe1snGCzkfTCVOQL5ZpOXwDt0TcrcacKqNvpvxWQPemkMDq31zI239JKts3WmOObGxE
         4yO4rMCQ/5lRIydRIezGDIWL66QJM/xWFPEloQPjZxjket/Z+kmInSr5s2E41m/wr5/x
         9Xtu/nLbXPknoHSxSO16AQv5FVyTgssqNVWWXfmXe9v32KUN5286vIrlXvsWrlrsoI3+
         za/4jiIYZVk1VYvpSMqToa9f0Gztu1oSMPb6rf2xadxnydG5Axbff3Zweh2HbYQcS/4w
         wpXg==
X-Forwarded-Encrypted: i=1; AKwUvBxj4hQ4mlnRQH91zx27paNJN0b8ncrjS3bbBzWUeHVPpkkcTFVlkZQwzwoKhgd3h+BfhfX7b/ebPyI=@vger.kernel.org
X-Gm-Message-State: AFq9FYLlV8SD3uu/M7ANhuz/ayJbiT1NJ+i/gVPuaYbNtqOa1ytpDtEh
	BI90vJS7R8SU4BQ34jN5rexghSH6zsicPCeriarMu9t3aAvBo/Ok5FlKmnzmczt6t+M=
X-Gm-Gg: AYBFou1HGtVo72AQv2EzzPPOlOipticwCHb7z8AYfHpmBnV03YoK0q8OU0ABRAHhcHI
	fkp2eJEDsLgWDn3NKRfZOLeblkL2adt4XaBOoWUwRIP3h7KT9DCApReY7GulayioPt00onONuxi
	o6wgyZK1Y/gsgjvqCCDZ1zMoygmGJB9TMIVBCGLAkT7Ywiaxpd8zRSyaGazLSHNvE5tuo38IM3z
	6Bc/+jds7pt8qiw+/RoQCyb0lj3UTvjgzb0NZbv6HuYI4I40VwnWPBvwHAvkaT/lrAbbRoHlqm9
	6vMn+F8mbgbMDot3krIXMMF+vb5u6uZvnzVSS+nt1K55oEDW2Di5AHsfbu2QVis10viFNtDymbG
	KZC2YxebeS++BHaozPr+AxMcKeRHk8Vg9o2CcoSM4LW6nC30bMVe4HxX1qzS7QFEfbH5ZQM/IXz
	tlWW8HbSNdEm1emi31aTbck1ZkOfCmO+nywkWVLFuLFqI/yWWOosgfuAljza7CNG732GKNidtYP
	iW+V2P/+ZZ6BA8HuH10VdORrcmvee08E54KfL2C5wrmojZNYdNxk4c/0hyrEy+nPGzrYu+KkSff
	zCRIt7M1L0gpu0CkZjGMzNAtYK7ub8w/rbnA3g==
X-Received: by 2002:a17:906:c14f:b0:c2e:8eb7:53e8 with SMTP id a640c23a62f3a-c46bde6b23cmr1029897066b.30.1793108292179;
        Tue, 27 Oct 2026 06:38:12 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd524271sm468626366b.35.2026.10.27.06.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:38:11 -0700 (PDT)
Date: Tue, 27 Oct 2026 14:38:07 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 12/20] ctlv: Add device and operation dispatch
Message-ID: <auCo3jRQ7p6JjIPF@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-13-jiri@resnulli.us>
 <179302367452.58760.16195458599265885835.b4-review@b4>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179302367452.58760.16195458599265885835.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
>> [ ... 125 lines skipped ... ]
>> +struct ctlv_priv_container {
>> +	struct ctlv_priv_container *parent;
>> +	struct ctlv_priv_container *child;
>> +	u8 priv[] __aligned(CTLV_PRIV_ALIGN);
>> +};
>
>This scheme with priv is very clever, but..
>
>The usage in the tdx driver ends up having both the 
>ctlv_priv_parent() and ctlv_priv_child() calls, but there isn't any
>type safety and it just seems worse off than using the normal
>container_of approach.
>
>I think it is a nice thing to have for someday if we get to a place
>that needs more than two things, but for attestation subsystem I think
>it would be clearer to have the normal container_of relationship and
>some reliable way to get the 'struct attestation'

Yeah, will do.


>
>At the very least the parent/priv functions should take in the family
>ID they are trying to seek too, for an assertin, and many cases are
>probably better off with just a simple:
>   ctlv_priv_get(ctx, family);
>That is slower but always gives the right thing..
>
>-- 
>Jason
