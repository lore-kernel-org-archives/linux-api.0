Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793647162;
	b=NRj3hSbQAYmoMZ2J24lV73e046zYyzHTlFkj9oaqz+4LDIXd+ovSCOYkBgG8bUV7sorI
	 px7C8sEtvBYb9SIlcWPD4n2M0kDXrPsbOTXBgtkw+j72ejI4Tq3yqA05VFliIQpfjyWD+
	 zD2wf5fnScuv5ijzblCbN1x7c1S5mnAf1rBnXF75SzlL/ODk6Lk1hGB6nEcL9SONiRMjZ
	 7F/dJRtr1xBoFD82Wx6hbn7p04ydglyOyae4rJJkbl8KL6Jn5ujsL8KfAVTzzPVUpjMYN
	 DTvbM5nOjsVCSpt01LdAnK0dEXBS141vmYi8e9Nt+peTAgNFGADnJakKkVNeJL3PBnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793647162;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=OC/gY15cLyDwevMNUFIaNM4tFLtXDK4Xhw0hL/Ej86M=;
	b=QBYJoqjFgMTAKoJgJli1V55dBQpRgPjOML3gR9m8tRmW574hmlejmMtgu1wZffFksIRt
	 FUrAlq9jMCLCOzTvJnLGTANzyJjBVj+XqrbIPytuNrF5llAeO12ox8+L/NPZDR3+qy3BX
	 Y+QeQmpNEu+VYRYHTVUajMm22/YdCAPKo/D1XBLnITdGvFm4KnF8u0J3N/CLGzPq7fJF2
	 p5sl03wwmnCJpRh1wNSWflmToqgOzLI4mGpR21mz2RUJss19dKMCIzi5Oxth1AFF1cqoY
	 hAf6Gmo4sqWSf8HAtJxV9MgEgVh3UqLt9cJHWnVYB2uvgy3lRq4Q0wDIFAv5yChBsRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=NB74w9rB;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBC4606A329
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 19:19:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDBC4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=NB74w9rB
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so30494145e9.0
        for <linux-api@vger.kernel.org>; Mon, 02 Nov 2026 11:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793647155; x=1794251955; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OC/gY15cLyDwevMNUFIaNM4tFLtXDK4Xhw0hL/Ej86M=;
        b=NB74w9rBrA1Fnaludy1HBowebMeI8FhFmSUNE2JVYGwPjKwXx9TI5xm7WO8KeiOryK
         d702aUwvSY25jzV7QZR4CZoAIzB40eqzwRv478T/lL2sBsDIggpSeSv/QJaU/p0b2Yy+
         tFtTg/CrEe4Qq2P//4lkseZFThzb0EIKz3XbFlWf+AmjBz/htDERW9z6CuHXf9CKGXNh
         e1ltXfcu+/VpD9gV5+5ChwmiHXV0V+iZBHEp/Zpra6wqD8n80ubPh8SWwCTeTBujV8ra
         SZ/lvge5hburvPtLszH8TycgZ9FtOIcKo92fmxORITiMn6Hyrla0+tia6Wa57rORP+Ny
         JvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793647155; x=1794251955;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OC/gY15cLyDwevMNUFIaNM4tFLtXDK4Xhw0hL/Ej86M=;
        b=L40D3MRNN59kxItw3MGaKjK/e44EbklpCk+naZ9jZhzBE191eRQoxK8VajAsNatmUh
         3vTwty1PTgUbYp8YlKtWLmyLFPXw6Xp8F2YAe3hVvApgM5qocoLsXLggBguu1aiamnS9
         j7pivcEGEofoDhtsFY5UfQ8510mkISM1PHcinxM3r3+asO/J8TiiLkLeTnu4+lDuJAdo
         px4XWWu3b712Mjo5xGXU0ilfGXaQOOrEkOJ6taI3eHANmvolsde71Oxt3jYn6KblPTtQ
         eBoAFO6e4ChV7xZj3tSipfCn3dnxV9WVfdgRGjgrxOwnPNtXXNxa8qDioznR74a87SBq
         FBuw==
X-Forwarded-Encrypted: i=1; AKwUvBzOpp0eQPudoeJ75ERHRVWDq9dByh91NWC+m1sSJfwCXrEt+4mRniqgU9SeYU21e+5b0w81S/iQ3Zw=@vger.kernel.org
X-Gm-Message-State: AFq9FYKVh5KnrUnkLNBVFOC0ZSXWyCSitTGXbi+9FmPEeYpN+LXu0mWL
	/ShfsQXyNm8QXEoyEISF34vG01xRv+IxiWER7FWWO1+L6dj0qp4Z0vSve/8YXAGfTpU=
X-Gm-Gg: AYBFou2xG7bh/Gqif+qXWe7U1qtyOfW/VL0YdVQwcO+HUYga6mdFEq1p9uK3n6CBWcC
	FUfSLjSF4qKCmOXAKir2Ywt64Uqyrc8b5xuAeER5q4s+RW/btUhsM7xu/9SnExU9meTIBWRePA6
	CBI+QqKPJsMNllDOcymDS/os7Wp5Ua3fy/RmgfugM/Hzjno1RoNpuA7DVqttu1Zj/5vDLlFl8Pm
	G3gklwFSRkcRWhHx7r0nX6Bxu4WwTGeNTEIXVxznY8NQ3ysgQrYA6ga+K3jWgFWowEtcBcSSmt4
	OIF4CeuxvMJmRFIHpPnXeF5wl6Nx48IMMfDFBPbGZliuZ9TZKdeoXw/e76GEz+alqaXF7guAMj1
	30ZWRZeNb9xQxWNoatZUsSZurW+ggscZyJ6HJhF2b8p43Ykkd6/3yQ8Gdh/QsahiEzkQHgZFWCv
	Elrls63ufoxnVkbGQU3ZcoJnvybEP5NnNjbdm6SoDkjIVmRP6YhffTpfCnzzLk9Ig3DPwNzMIKF
	R8nm9RymhUZE7KE4QtUFA/xGvJazT3hOQdvHh6VDRZ069Kwa2e6xDbOLX3P2MrZJH40lTMULCh+
	Rf7MSDOLWeA/8UssQpwwzt6eOOrAJkC2RW6uWMPQ13CdalJAIDIP6VoczdCM
X-Received: by 2002:a05:600c:6989:b0:4a7:6425:c274 with SMTP id 5b1f17b1804b1-4ac150b38d0mr251477715e9.2.1793647154958;
        Mon, 02 Nov 2026 11:19:14 -0800 (PST)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2aae24b32sm6083675e9.12.2026.11.02.11.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 11:19:14 -0800 (PST)
Date: Mon, 2 Nov 2026 20:19:11 +0100
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
Subject: Re: [PATCH RFC 08/20] ctlv: Prepare message output handling
Message-ID: <aujiKOR-JR9kTMia@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-9-jiri@resnulli.us>
 <179302367451.58760.3909701518454079333.b4-review@b4>
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
In-Reply-To: <179302367451.58760.3909701518454079333.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
>> [ ... 498 lines skipped ... ]
>> +/**
>> + * ctlv_op_query_done - Complete the last query fragment.
>> + * @ctx: query operation context
>> + * @generation: current data generation
>> + *
>> + * Return: 0, or a negative error.
>> + */
>> +int ctlv_op_query_done(struct ctlv_op_ctx *ctx, u64 generation);
>
>Typical kernel style has kdocs in the C files along side the function
>body not the header file

Okay.
