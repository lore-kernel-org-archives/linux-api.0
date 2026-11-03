Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793667535;
	b=4cLYL3pGv64opWYJM3/5/z0R2qtGHPtj2fSrdkFKrjkiSMYP/0bU+dRTIdva9nP7LAtK
	 s7ubEdAG9/FPrKVRo95E489o0fpzrJGgF+BgGzish+IxPl0XMorgCdbEd3yBmwfzbLd+W
	 im6oQtkxAg3EP07hPUJlEB1AEOZ85/q0ZVEd1IpQyxO3GpxDFs8egjQ43HWPzUwGVW1AV
	 MeGSlUMBt/MlrRhl8lYDrPPCuYh+Sw3/3ippjxW8rACBB+ptklUyT3JZRCHAVIVZ/74nb
	 VCkVFRsuGlAV/5RUtt6hv/FQFWggBdjVlB3QQdGSqmobXWQt6LO4+Xjg711LKCcCuTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793667535;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=QoYRJANCltXIHssksq3+ydkfr4I2KVxvqmMBU8nH1QA=;
	b=FqRbLJasJYJA4temknnSakPLjqL3lVumqkCg90iwFFpumBbTKFQB06/qP5E8AtYmjYRu
	 G67CYR4oHTPkC0Ug7N7+fulGlcgQdqeUEvgqdv7J8af7S+NoEM8OJ5bnO2FnlvMj8lohs
	 dCzM5tcfAIeNsEVapcyY7NM0T3y8KaCOgEpU+zjSUOxxu/B2p2S4YiG+1mGCylAKh19GT
	 yLj6UXxM89hMS/WzIt1rGX1U705qvqiM/LUQJ3p/ZxoFEezFnrfKGYJBIpJd0Lsm3WKs/
	 g4yoj+zQQs8v47YX7NZFyQY9HTL2/i3FC6CM68/BENcqDR773lzu5n4B/Pig06RyPpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=H1zPRlIe;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9065F606A327
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 00:58:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9065F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=H1zPRlIe
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-53512cd2f85so49114121cf.1
        for <linux-api@vger.kernel.org>; Mon, 02 Nov 2026 16:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793667533; x=1794272333; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QoYRJANCltXIHssksq3+ydkfr4I2KVxvqmMBU8nH1QA=;
        b=H1zPRlIek7ds8M6NQOXwrD7lOc3bluGthhRv4XKpDgzkRsAQZQ9QpELH7lynxKitrC
         iAK3y/NLEfzWZg/zLhxLIfDoe3wG0Zi0g7uRxjIB5PHRUoAwVJYqdwPM5ma8QgTsDzzE
         A1YlDOQMCvdTjJvkcVq/n8F/g3cxTcOLvq0rFJUC7KCBYjJ3KGXhiwuXhH17l0Swl0ek
         aliTnEwJ2nESBRVL7qU/uR1nVs17I8sEP39YljjfAB04uP1vgKV3xHgqnt9dYYqWPGUi
         9LoVzZmGLFBycgB8TaF7d/PDBIFGxvyUNueK0pVkswaKoLaJV6OK4ikoFARC+YUNYP5F
         F/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667533; x=1794272333;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QoYRJANCltXIHssksq3+ydkfr4I2KVxvqmMBU8nH1QA=;
        b=wYWSFJfX52ZkLWBmQjmRj0jhSt5PtH1/UE30Cs48AvKxHGoqVdf84uDG6NxhEzj4LB
         ENTmKd2FcypUt21nr8EWqpaTgRAUKOJ4WJKgKJUlTvXe4QtrDTscwy9dY4401dErg8lz
         7oqghTVcCxgAwFPj9K1oyY/qQ4d5i577jMBw9pYnh5ZZN/iTII5uowQGfeeREQarr4lH
         0vZTFqqk1v8KcNljDGvuPpTJnZDVhuBWozsKtiEUh8rEo+pVEjlvo++63mVLHEVhgj+1
         7p81Id6griooeEql8Wc3UaZp+eK3TuBi1kqxMOoB+Un0ufn5JoCnTg9h3PvXabnI/GP0
         7UkQ==
X-Forwarded-Encrypted: i=1; AKwUvBzlDkw6QWJHAppzGmI/ujl/ZgiglQMxGxsRHxVP5SpKVVF7jEhTivB7/r11ddQFL+bnWYYMqxge4f8=@vger.kernel.org
X-Gm-Message-State: AFq9FYIPnUKVgj74lionK/O+quu9mogqBvsN2XJO1jeqGzy+Xc03CecZ
	r+TxIcYtUTWDbsJ16Zkndm7yeurscNS8M2huOyUUIa+yrcUq4Pp3K2CxzJ8yigCAbic=
X-Gm-Gg: AYBFou09MnexdMTwXzZNRWjTl/+QQs3V7sN+9QMrfq+lB6j+Q9tyHo+k3mb9FIJ71EN
	sw+eEOdrDEO3oD4smH7wiJQZdUAJ/o3qHKYRe8VdJDg01SzMdalWvF2QFgWxcRNIVNOVPOfpiMd
	SiGZSytaXwhmAPKAQ/DKQPXVt+lEEAlnFfY9HfVcxLhggHOzv7eLhHdsBMc7PPn8hAf01hW9DGp
	OGYWTaCV79BqyUD9FJSolO83e53NumdpbEXblFRVgeHOmH164z6L8BGZnZRKlpDID6NXh2rjHDH
	YQMMrEsmuZTigEevNPuZY4NGjPDZjqtWxcNNN6LaJag14JtPfxYjmIbB4rytCynN9kQLKhIhJ4T
	WntXWFfnDrVn8bS+NCtP90qtuA19eFDSKVMs8X+mQJwW45OtPmsvd0Ws2SHIgHwnl7PZLAOIsnH
	wtI8iT2u+caA6cOm9vVBDM9hlFIwY5xSlc5ucE6ZR3C6c5XHFdN15iIDYMDMBII+lz5zkOpH38G
	Wj+SdlOIFa7vLnxuzQ6bTG2QFlTvp7TbUE+tAf7PNhgaHeWc+ee47clkp6THI3BHvNW86w5u/Pt
	aMCqcikVquh6mtGdBqsOvxUxDgA4JpLoLyD+v8fWR/WUQR08gw57OjHcSNl4ls6aMPCiLMN0KrT
	d8U8ivrgbuA==
X-Received: by 2002:ac8:5f92:0:b0:533:a4a:8826 with SMTP id d75a77b69052e-542b6595288mr197108781cf.19.1793667533172;
        Mon, 02 Nov 2026 16:58:53 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5498b49d8efsm12193441cf.7.2026.11.02.16.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 16:58:52 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xO2rT-0000000BHob-1A7Z;
	Mon, 02 Nov 2026 20:58:51 -0400
Date: Mon, 2 Nov 2026 20:58:51 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"Xing, Cedric" <cedric.xing@intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"ankita@nvidia.com" <ankita@nvidia.com>,
	"jiri@resnulli.us" <jiri@resnulli.us>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Quigley, David" <david.quigley@intel.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"pgonda@google.com" <pgonda@google.com>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	"lukas@wunner.de" <lukas@wunner.de>,
	"Fang, Peter" <peter.fang@intel.com>,
	"jic23@kernel.org" <jic23@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"sameo@meta.com" <sameo@meta.com>, "aik@amd.com" <aik@amd.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"ksinyuk@kernel.org" <ksinyuk@kernel.org>,
	"qinkun@google.com" <qinkun@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <20261103005851.GH3889730@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-21-jiri@resnulli.us>
 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
 <20261023141218.GD3977851@ziepe.ca>
 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
 <20261023220030.GM3977851@ziepe.ca>
 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
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
In-Reply-To: <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>

On Mon, Nov 02, 2026 at 07:02:37PM +0000, Edgecombe, Rick P wrote:
> > Though I am planning/hoping to have a sane admin tool here as we agree
> > to things, so admin can do like:
> > 
> > $ attest report
> >    TDX Report:
> >      Xyz 
> >      Abc
> >    TPM Report:
> >      124
> >      435
> 
> Hmm. TPM report is a signed thing right? But "TDX report" is not. Or "TDX
> report" is really the TDX quote?

Yeah, the signed thing.

Sounds like in the TDX language it is TDX quote. ARM CCA calls their
signed thing report. systemd calls the entire aggregate bundle the
report. I think TPM called it quote. Isn't it nice everyone has their
own words?

Jiri, I suppose we should meditate on what word you use in the schema
to try to be clear.

> I still don't see the need to expose the TDX report (TDX definition
> of report) through a generic interface.

Great, let's not do that. Signed things only is what I was expecting,
because that is what systemd needs when it generates its aggregated
"report" to send to verification.

> Are you thinking about having any kind of community
> call for TSM? Maybe we could walk people through TDX attestation.

If we have to, but it is more inclusive if the mailing list has a
record of such things..

I was thinking of trying to organize some smallish summit type call of
a longer duration when this is more solidified and everyone has time
to digest it so we can go over *everything* and confirm people are
happy. This would be a 'come prepared' kind of call, instead of a
physical conference. Let's see

> > > On the TDX side we would have to work through how to ask for a
> > > specific type of quote. In the initial set we have planned, the host
> > > will decide.
> > 
> > That's fine. Broadly the "default" report format should be set by the
> > VM's instance type, eg defined by the CSP. It should not change
> > launch to launch of the same VM.
> 
> In the attestation space, it seems there are people who want many
> slightly different things. And it has been generating option
> complexity on top of the TDX legacy baggage.

Yeah, I am aware.. Above has been my view as the only logical position
for a CSP to take. If you change the format of the TDX quote from
launch to launch you risk ABI breakage with the customer's
verifier. You will have angry customers if one day their VMs boot and
they don't verify anymore.

> > If you also want to have a way to query specific types, like AMD's
> > guid thing, then that's fine too. But I think integrating into systemd
> > report might be a bit tricky so I'm not sure it is a great idea.
> > 
> > In all cases the format of the report is labled, passed to userspace
> > and given to the verifier. I see Intel already defined DICE format as
> > 'larger than 8k'.
> 
> I'll have to check (or maybe Peter can chime in) if there is some easy label to
> look at.
> 
> > We'd probably want to give that a dedicated label in
> > CTLV land.
> 
> Not following what you mean exactly. A CTLV format that contains the report? Or
> a user ABI way to request a certain format?

The CTVL output will always be something like {label, data blob}, for
everything so it is self described.

Since the DICE and non-DICE TDX quotes sound non-interoperable they
should have different labels.. I guess? I really don't know the
details of TDX enough to say.

> > One of the things I'm quite adament about on the data labeling is that
> > if something sees Blob type A then it should at least be able to
> > verify the signature. Further format variation should be self
> > describing data within the signed payload. If it is so different that
> > you can't verify the signature then you have to give it a different
> > label too.
> 
> I'll make sure this made it back to our attestation people. (probably someone
> already picked it up)

Yeah, I'm quite adament about this. I don't want this to turn into a
funnel for undefined binary blobs that nobody can understand. At a
minimum the signature has to parse, and at the maximum I'd love to
insist on a userspace implementation to dump the contents. We will
see.

This will naturally force people to use the right labels since they
won't be able to make a dumper if they don't.

Jason
