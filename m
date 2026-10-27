Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793095400;
	b=k66Ve7saQ1Bhq0D6Z62A4XRLxCIZvleJuM0qvA/juyFbMPh8b8j8Hc1pE03fUr7p6IlH
	 Pp+bVGYmPr90JGbrF++2LUkeMzXe4ewCD7HAL0QwHqoN/dWnRkMZ555jq8q+kkYJWgW73
	 pPpbO36sXgfVw/78ND7ZulaHCJH5WE08MhsVm7rcI8gPxsYOzmLE0rApOn/y9hhxgSPzK
	 1NAtvT7e47cgjjI5lnjd4H1Au7CdvCujBeVTYbUOjNYbUvz8tzLsgH11EwQVDpTseu38t
	 HYxZJcPBl7oQfzba1DHd1Pq79DtvFECQp1utwc04kLyucSnP9v8OJ3X3IqPoQoO02ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793095400;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=B/ZpDq3DjZV/62zmns9uwG24EjevmhON4QmJ/2QUaFc=;
	b=DA0f3648lkU8XCI1d/0SYyDLYsB0bkvS8z3MVR25W8ITPlSz0i1oO2nLNrS5uSr5wq+9
	 9IuYFVgRQGfBlMhh/6SfG/9q7Z0KsUfAJBWfoBbYWwGbV8Qq4OGuMfgtatN3awKimJ0Re
	 YjuuWGFbNxOm4oXdHMCpCW8UplVdtUFeKMaIBElqgzD+ekr01KG6ZRGD3fTR8j05ijjRZ
	 GmEEgZM1m90PgI1rnChY9f3KUthbeGIv4rRKk07P3GwBr1vcz/W3vkgLSM5R2gHt/plvq
	 4sjvteI3I1XoHFBiAMwrdlpz1CV8GLY5/FaLKbttkMXzUMoy9VFW9Jx6Zk9i5Ifa8sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B80606A31F
	for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 10:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74B80606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c423b145922so528124166b.3
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 03:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793095393; x=1793700193; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B/ZpDq3DjZV/62zmns9uwG24EjevmhON4QmJ/2QUaFc=;
        b=EKwpsigzwDmZPRkvIpX1b4c0/rz7uhtPntV0JfCYEz0s3pcwkOGnsL5Nzc3IENmwos
         3sbhs5QgQhWDLpAOwIEmEB+wgVol0pjCngvClscZPLVgXpK6vwt6ozQLK9jHaqZpS7Wx
         UAwHaOAiTlSXV7JOhQYBkg+WaE7NJjWYx0Q2jkUKe51KAl6u7hwDCeM2xNigR7jQ+Esl
         2TD+6FVjssyPooQGV77/khcqAuzCs5MkcZsRcYmk+07Rxjllua9OU3dnOSkEIb4tDpCN
         GKiS0GgWXoNCU/s9g+GrCc6/QeqrtOgD8LLSneSwbAfEJ6r0lK+DJ5aWEsAXcsoc+VP0
         o0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793095393; x=1793700193;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B/ZpDq3DjZV/62zmns9uwG24EjevmhON4QmJ/2QUaFc=;
        b=lA7tUav73vI4tz6pkmJuWuIyMyFUdi8Hf9rnRnXDsS6t0PE3g3tn++WAtxTP8jCloh
         1TsxsbZEDDDRolIg228iWTJMXA7SiS/IaZi1PQnS/tUywpreERYQ7RGBE7Q3ZpKbQHET
         DBj0MyBM86nqrR2r+9ZPj7zR0mCPGzc77LCR6FqTPwJDIbc1Fhj+JG3FotZ8lSxw0GcZ
         nnunOd9DiFC7xfGowddhAj987ZHUAsX1xrj7PDxX2FoiKn07PcHFtz01ZJJJaFvBi7eA
         uiInnUY8QDMCCwrz52E7tcdn1UcZKayuwMpB11qSdsXtbXqeLlbwK74K7iu648WonaFz
         XlKA==
X-Forwarded-Encrypted: i=1; AKwUvBzGtU9G3fGYYhhBS0wFXHeVFCej+7u1nK/wRJgjf1q+0vKGsGWrM/8FJK0agk+mDG1ZabdW//wgCRM=@vger.kernel.org
X-Gm-Message-State: AFq9FYJPkXqsW9BAYd/yavXxDc9Wg49OFO6Bhz2U3WmTB/fZBFcips/F
	Idmiw0xKxLSzEttNtl1kreNCz0cCKqqxeafa5IPDbqg9m5ZLJ9DAD0JerihTLV3XLls=
X-Gm-Gg: AYBFou0nkrK1g0jiVsSotWws3dJUO2c9lZCDM+4+L77ekqptOt4iylaoJivY7zn6N3d
	qbmRURmZqUyDJv14tTECldV/lzVPvPwUMdXbz89xp/9a5zHZYSUy+1AbXmMi7L4GgrRDJR3oZe9
	dEiHaknhvq3wfYtNqD2eX+Kcb/k95fvDsm3ywPi/Ck2h6JW9oanIlkgRdPsqhmAMR8+uIC69tRG
	cQSQ84uSWB7JZMb3FZ9E4VKAgC5rE3xWt1ylUQvsatE+wgrrXHrGq+8kWozxxWJThiYs/OXmZg+
	EY55n60qGj6G3/6kdXnJKaPWvjFPlxnOyX5yKKcSlYwOHgxZlDRHfqveEh8cfMW+SiMeXhOKaPX
	1cB4GsjEdURMjCvhBW4NLCFwJTTv7X56QNvo1F9J071wgTqsPwO03hYK3YsUoQn6/5JVgF3wf8w
	igz7yIizRHa5hLy3HIIX8z3Z8GS5bX+ms/CBobGFfOH9Z1gQjbq1X3/28cGxNbuVbxzs9uhC9Zy
	GrzxPLSdEl0uKroAHyQdaWlsW5Agtgf32Z/cjxm3uSI4pekxR6eV2GuFCXYQHN6
X-Received: by 2002:a17:907:728f:b0:c3e:d18c:1d7d with SMTP id a640c23a62f3a-c46bddc42dcmr1033526666b.22.1793095392233;
        Tue, 27 Oct 2026 03:03:12 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd790afasm420098366b.68.2026.10.27.03.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 03:03:11 -0700 (PDT)
Date: Tue, 27 Oct 2026 11:03:07 +0100
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
Subject: Re: [PATCH RFC 18/20] tdx-guest: Expose the native attestation
 service API
Message-ID: <auB21VZhFg3sDcXz@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-19-jiri@resnulli.us>
 <179302367453.58760.3338436189030317197.b4-review@b4>
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
In-Reply-To: <179302367453.58760.3338436189030317197.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
>> Share TDREPORT, Quote and measurement-register operations with one
>> in-kernel client while preserving the existing misc, TSM report and TSM
>> MR interfaces. Tie clients to service initialization and removal.
>
>The tdx stuff should just be an attestation driver, we don't need to
>make these kinds of linkages..

Okay.
