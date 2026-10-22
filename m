Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687379;
	b=Nn+iQ0k+3CNfvL1ClYTFYwerJY1szB76rg50i7fcyJWZv8WTjdpFliggd7J3FH2PxS0k
	 7YjtmFGFZXO2V1EZ0YiS0pZvbfJz4AO6zZWtPegR/Js/B1k5+HwhKREyCIEvMkJE51HhL
	 HxD6Nmnd0XHQ+wAmz+WNyuxV7Fr7/Yxhxv34nRqDQ70Xb5r7YLYwgDBh9LZs78BChSe5Y
	 6Mx4YkdesQWnqF55zcVBFEKI8TLam12z0d6k6cTT2l33MRjtMSvXpxJg2iTITvBe4G2P3
	 RgozjSHXuzNUkVCdFaH9kXAYwJmjmGWBvFb2fIAuCJCO+6vyLmUjxlO7g0I5nRr6Yfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687379;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=bb9yPFVCzZYVNrPWeZ2XIQWqfvcxCLSzUADzdeC7Nqs=;
	b=Uyu3TfvV543Sol0B8Oydj6mA1DMImcCQfk83lx29UiFcqG1vo5IwRZRXA+2LGXbcXXGH
	 OtB4oaaAcG/w8Zdc+n5eK3pz0tw/ipyAOmSE0Ii/EEbdNED+Y1WbTVB5b1opyUp3Gg8kN
	 rl25i0spoTSLYmRsjqHUruB/boJ6WvQ974K7fphKXHwE4h6wpVFnpYUiXrqrzBNA5i98C
	 OhFgiqbpMH1JFRXbVsJovex4LHPlGGv+6nNCQ5JerAuGBopiacYErorBKWnGBHj0eImvl
	 sd+NHuFULhKzUCK1GBoKhDI8X753Hd9NscCZHehNx1Jyr6IHdaqIVdv/qQ+DGDS7naA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=XHbnFoHb;
	arc=none smtp.remote-ip=209.85.219.50
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB12606A31B
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 16:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AB12606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=XHbnFoHb
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-9196d8543cbso732326d6.1
        for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 09:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792687378; x=1793292178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bb9yPFVCzZYVNrPWeZ2XIQWqfvcxCLSzUADzdeC7Nqs=;
        b=XHbnFoHbaZMsVLw6MWmIqP2d7qgOxfCHBEepcjJ8Id9E0Eb+q5QzJCpkTQIX9gPT+R
         86fXPk5bXM8iK9x0dOBj1/E2JEn3tDHeoJ6AMdVbgJ1k1N3E3ICq/Q2MPhf+rIAxcnIF
         4+YWBGgJRMzlwe44a5LXp5z+24tXHKxJBq9xrY2xG4eX+Fk5gs/erZ8cIQv0oixJAix3
         455u4iWnpKjwepSQH8FuUSOS67fCspG4I/LkwbzlBZQUxBu3+wbUk5fmbVx/4k9mofae
         MlLjnMWqo8lm6PHNvrktYdzNb19ERFmaMkW8ZJFpc/nZn6Cvx+irDmyLf02/GTWvFBrZ
         RPsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687378; x=1793292178;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bb9yPFVCzZYVNrPWeZ2XIQWqfvcxCLSzUADzdeC7Nqs=;
        b=O4xB86FltOHmkSXLyBL6r2w+J3+4hcRwNDM7qXtgQKbvWjfRhSo8fQIh9nWqNr7GVj
         9FHj1VxHunTu7yCzHBZoC06x57tHWFwmJySndXBJwRokEnUvzfKFFhs+Mq3TmG/cFjdj
         g13oszwoYoEC+VHzqBxcd0gJyPmSAPm+gDm9m4AMqmhuhurSYHAh3zlep3TF2C/F0EQ0
         24HnPYTOssCzKOmghN45pE7meIgKc4pK73iW4OPZSuHXdNXtAiH3v1YlZuPZRzr5RiRz
         eAh0XT/tSevmU0Ie0Iy44b3/nmzg1wr95aFuQu6fuN0osN5uGGZEe13KruGc0On1+Bpb
         3amg==
X-Forwarded-Encrypted: i=1; AKwUvBy8AzDCO6sikRNiaRtURaKddNEXQs0BsaxOHsrmJl/H0/eBCm9skcyWSBUQ6totzmWS0a6QtF39D38=@vger.kernel.org
X-Gm-Message-State: AFq9FYIhwxFxbyPcQtYoesmvusr/92vIIxGfEbkx5gnlfnpbxdqt5vHv
	sl/bJ3EtC9+sAXG/qEzXXvapEynma6+k6w61Xui+Y3TzmgTZQo6rGk+UGQzlBfwF4UiddsO6qf/
	DwQVj
X-Gm-Gg: AYBFou1jX+DA+K+7ArTPoozrsjCxoLnXVd6vwG7OFrD76/r3bvcoUY/Per7YxjEbmmw
	1HtB555mOFi1xFtuUb0RZLnYXpeDHMg9PmHfG418tR7WrIPXmY6KvxBBijkTtALXD4BNRYYs9hv
	VSDB5pdf9sics5JwXbZQYPqjZx2mg29rC3bp2Wv6FoOuLEAvVut+BSJmih05YLPAUC7AFmp6ST3
	QVTdqIAoDVDJuKqEjb6KmXaBVdHhzcOFko3vwqTDXcT7ATS1o7wU7l47DynDVpEmhoRgLy3DJ+0
	b0tJthUHEqDQE2W3zHJHOln3Pc7cuk1T4IoLXkDYIW7W2lsF/IMHd9EDQ4HTK+b4YzNTjSqmOJu
	diO2izP+Zo0aJFrN7h4z9vPlNX7PE22UAdppakF/8YdEk6lTl6dvSFkkzMg3r6O+gmewJwZHpTz
	vg85musz+bk7cEPgurfhzdxeZHcTKEgj5LOmQ2mdx8UjAJLOTh88Rj2Iumxr0CFSBFvzVpCOR7o
	9uvRdTXn+WMxTn+JpNxT1eGggBTpmGTLazs30fvYXjGyBxyGiq4qcur5LytOVsxmeFtIOrd/JPu
	3pgCGqlzJvZzQXewXEKlfsWsQCkQ7S073rPpHA==
X-Received: by 2002:a05:6214:6017:b0:91c:3632:fdc3 with SMTP id 6a1803df08f44-91c3632fe59mr9119646d6.3.1792687377918;
        Thu, 22 Oct 2026 09:42:57 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c37060bb5sm1460126d6.24.2026.10.22.09.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:42:57 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xJvsW-0000000FUPr-2EHZ;
	Thu, 22 Oct 2026 13:42:56 -0300
Date: Thu, 22 Oct 2026 13:42:56 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261022164256.GB3381610@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <yq5a7bjajaco.fsf@kernel.org>
 <atooh7uO2RauUTfY@FV6GYCPJ69>
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
In-Reply-To: <atooh7uO2RauUTfY@FV6GYCPJ69>

On Thu, Oct 22, 2026 at 05:38:22PM +0200, Jiri Pirko wrote:
> >I am using this to understand what the IDE setup flow would look like,
> >but it is unclear whether the connect flow belongs in an attestation
> >framework. I understand the desire to pass the certificate slot number
> >as part of connect, and sysfs is probably not a suitable interface for
> >that. However, is CTLV the interface we want to use for connect?
> 
> I was thinking about this and "connect" really does not belong in the
> attestation CTLV (same applies to "lock"). I was thinking about some
> parallel PCITSM CTLV instance, but that does not really click as well.
> 
> Currently I'm thinking we can maintain existing "connect" in sysfs and
> extend it with "lock" sysfs knob for Realm side. Both would create
> ctlv-attestation-spdm instance. The same spdm instance may be created
> for other non-PCI-backed device.
> 
> The proposed host flow is:
> 
>     sysfs connect: select tsmN and prepare the connection
>         -> negotiate SPDM and discover certificates
>         -> register ctlv-attestation-spdm instance in DISCOVERED state
>
>     SPDM_GET
>         -> populated certificate slots and digests
> 
>     EVIDENCE_GET(CERT_CHAIN, blob-instance=slot) /*optional*/
>         -> retrieve candidate certificate chain for appraisal
> 
>     SPDM_AUTHENTICATE(device-generation, spdm-slot=selected_slot)
>         -> authenticate the selected chain
>         -> complete backend-required session and IDE setup
> 
>     sysfs disconnect
>         -> remove the attestation instance
>         -> destroy the native connection

This made sense to me, I haven't reached all the details of SPDM, but
this is like what we discussed at LPC.

I don't know how much SPDM stuff is done at 'sysfs connect' time vs
how much is done at the first request. None of that leaks to UAPI so
it doesn't matter.

This changes things so IDE does not setup until SPDM_AUTHENTICATE,
which seems reasonable to me given all the constraints.

> The slot is therefore selected after discovery, rather than supplied to
> connect. The attestation instance represents the prepared connection; it
> does not exist beforehand as a controller for a disconnected PCI function.
> 
> This requires a staged native backend. It is not how existing automatic
> sysfs connect behaves today, and those backends would retain their
> existing behavior.

I don't know what we do with the half completed sev stuff. I would
prefer everything align to the same flow, obviously.

> ># ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 connect pci.generation=0 pci.tsm-id=0

It is pretty cool you could just make some edits to the schema and
then use them through this general tool, kinda like sysfs, but not
like sysfs.

Jason
