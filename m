Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793025935;
	b=hj+d/jHQkfimHDhiMWi7O4+4XCvTLgdgVeRlDI6mkK4ZuO466hFwHVeAw5qElh99kOO6
	 7l17+m7MCsJcIdh+5L/+XtvFuqcd45xKhkPcOIPW+plhIuVun2OKG6ESIlO0H5XECGVWM
	 0zA2cqWnYwyYYbCR95Ah3Olt/ka6aDt0+rhyotMFFcRVFr+vgo0tCwh4fktKZWhAnBN6f
	 dHy05vY7+MZ6gXIPga9L4a1288WJJot4G/r+m+Hnpu+hayXx9uV5eyFhmUif0pn1yaiDA
	 dS4V+lKHGxCA059N7lV9iAXgElzAZuvpUrtmolcEWdCoco9Nq0Bq/Kk28iDySdhk3Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793025935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=BTyJwIZ3wmc9oIYfv63SnUqHORvshzUvmQqM3M2r5gM=;
	b=sxFqpyFP/A4ezxMRmlqTlUAk8a4sY6yAZoJwVieI+JMhpumewoVYbs5L3WJvzZeUIpEa
	 mQw28e2peAo9szgKoMlM9crJnKQsz6I80FsVdxO+5dMI7qL4cJEAxg7Y9HxcU4kNFoQfo
	 ECF9zsju4MWixsPV/HC3qT5+i6xbIJJViO6VhFS4P19g65/9RC06PI/Yl9AM/mOtwSJbG
	 3MO+3COHjr7dBEw/S4GBb0ubLu86JnPWCSsUIh6nRn9z6Mwiat+PMNrmTSK2fARIWLMS/
	 kmePWOLmcZ7nf+iL4qQ5M+DNjTKqBVAHI7fDOP9rJVsx9yeoy+M6kWIj2aLTcscE8MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AE3606A320
	for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 14:45:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0AE3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c43373ae89aso462968066b.3
        for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 07:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793025927; x=1793630727; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BTyJwIZ3wmc9oIYfv63SnUqHORvshzUvmQqM3M2r5gM=;
        b=NaHhzKNABkMC6wPd56SklKTLcrQYlfIh5spEFmqO7cf478BMxIsRJr4GJdsQzMnSsI
         rdTHhnF71aRCmn/ZbWzRcAHNKccrrw4wdLKTXgtF7lVYmL/I0tNSmfXZGnPPcKVl+2Yl
         x/dU7kIekZQCU2z+mtWPUnGySnvBvr6joKf+sfeGKvdFtmYt9dSLMTJesO7CKx2gOyWj
         F7XkhsdJkfue1Pp3MdFYVpe8zPO/ElN6+Hl27s2XKWj4Ttuwb4puQdX4nJm5KZchfBO/
         R8eFcLnpn2qGsfM3RVIy2yrHCfMIG6pg+Q6Fi66PGXs+F6CEx+JXB0tkqciFCTf+D4JX
         SK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793025927; x=1793630727;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BTyJwIZ3wmc9oIYfv63SnUqHORvshzUvmQqM3M2r5gM=;
        b=spiMuG/ODO/bM5JH+Rz9Vqp66tobSydtM5UKRilzT+eiN+SkXVAEq4GMvROLNy+KAq
         z8LW0M38my908+cE3S5YZbE9AkqgDxn6ceq0jETk0+xiz0kj6lBKMtlNWxqiw8lO+VZo
         ECq6x7aHEA1YjjOw6Bf5TLKVspoThQKm/iBZZDMsEDZYLgsSEt8Lcy6YKFrs6OsSVb0e
         MEdHtqwyuaXd59PzCo5Ml2+DCQ1cCbVdp6czr/a3Xo2HyyoHl6WbtshbTDICbShtzgNV
         SL06uFtVp1zdGPwgKUVm1r5nZIqJf1Pimyl6oGG5hpfbnIj/PsEN2ayfWm9L3xl/DWLH
         PAcA==
X-Forwarded-Encrypted: i=1; AKwUvBwA9kPsIpfQB1hVrmM+looYd/0+8QBAkKFBO8zzlnSAqBE3A0sme4si5AouaE6NUrq8Yv7Dmq/tnkI=@vger.kernel.org
X-Gm-Message-State: AFq9FYKaegXgZ39RGMjZ89fCjvMOEBQUrck61Bdd1txu2RfFMf1IOie/
	aNivrgY3QfYtJzMt4AXD6bTO5i8xx6Ab2xrdz2an9vF5aKjSjJaj8YG5bv9xzG2bg5g=
X-Gm-Gg: AYBFou3CiXL/M077KajXQyr8eCHV74t8lMy5NdXXwa2uo2ENqgTGuzn+dsmHGOq6sMr
	aNUishuGjNYOs9KO8k5/fLoXwj+Coz73X0jSTE34f1rIxZrAThBbp+C2Nw5hfhs+F9RITSoBqVf
	TqluyIZFSXn/ZMbaGchJ9hKiEyXI3H+02FKzXIAR1Ex3mBopy97A13YNVY1vk3dW/GPttsJjF+n
	TChhL/Ins8itrkGyDkF1pIBBkKlBhsm0uKgrV+Lxwu0gpMcY/2RphKj8MiT27fm/9z609+JVfAE
	TOyiF+q6hp/3LnhD87ZPlMbf3/etqbngJ/cDK4d8CYaBx0Xmg4IyIgR0OPaIBMuoAEqAR8xQUuo
	JPRlq5deA8GWN8tQ2BI39DiH/fg5fxXa8OrAFMwNcjMwcbLnmdI6CKObdCMzFDwlRiFuKcd9AzT
	EtkAu/ojXKzSkQly/G71w+1FdgoMOzWSzxj3/9Zoyte9mt+bHNXHo4VRxzv0+XpB9h/kv4oElZ5
	c3FLgOVxQmCHnrx7WXt/Vtj8TCw/wPUs4/Hu2orYaz3/qlcnIqFL4t+chzRzhAs
X-Received: by 2002:a17:906:c111:b0:c29:f5d5:5a97 with SMTP id a640c23a62f3a-c46bde8850amr767885666b.33.1793025926980;
        Mon, 26 Oct 2026 07:45:26 -0700 (PDT)
Received: from localhost ([208.127.45.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd7981a7sm325130766b.72.2026.10.26.07.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 07:45:26 -0700 (PDT)
Date: Mon, 26 Oct 2026 15:45:22 +0100
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
Subject: Re: [PATCH RFC 10/20] ctlv: Prepare event queue support
Message-ID: <at9ncuDFz_vI-0W1@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-11-jiri@resnulli.us>
 <179302367451.58760.3073439917920385955.b4-review@b4>
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
In-Reply-To: <179302367451.58760.3073439917920385955.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
>> Add per-open subscriptions, bounded event queues and event creation for
>> CTLV families. Add the generated root family kernel bindings now that their
>> message and event helpers are available.
>> 
>> The event and generated root objects can be compile-checked here.
>> CONFIG_CTLV remains unwired until device dispatch completes the module.
>> 
>> Assisted-by: Cursor: GPT-5.6 Sol
>> Assisted-by: Cursor: Claude Opus 5.5
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  drivers/ctlv/Makefile       |   2 +-
>>  drivers/ctlv/device.h       |  38 ++
>>  drivers/ctlv/event.c        | 713 ++++++++++++++++++++++++++++++++++++
>>  drivers/ctlv/event.h        |  69 ++++
>>  drivers/ctlv/internal.h     |   7 +
>>  include/linux/ctlv.h        |  27 ++
>>  include/linux/ctlv_family.h |  11 +
>>  7 files changed, 866 insertions(+), 1 deletion(-)
>
>If we are deferring the mr log, then events can be defered too? That
>would save another 1kloc to look at right now.

Okay.
