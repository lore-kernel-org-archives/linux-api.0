Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792782811;
	b=4EwRpIQe/gDzd4/AAEkwd6EyhNC46VxdZzaQEMpC/TKSsUhI0ORIkiGzTWyqrD9mqdN6
	 vTFiK0X4ct9kn30x6Nu64DMeJRwpWZBnX3eRZvQSLiIwZmJfWALeByLQKRLwiuP7C6siF
	 vs7blA/JEQBU0NvgZXBxlqU/p+ub8iY2MJlAbdPleq/cqF5ePaX0EFZvHlTvExynmh4Ur
	 UOOYP6kASCrLT08lOAVL7CroHgXISEIj+JYJjonKyqxxPtrt/fO0RoFRciAvRooQwoKvW
	 q20oZMPs6oEFhhnk6OaTuAdULqt9ZQ8Q++DXA5KbylsWVpWNYojBN6wPA6Mk3cD3/Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782811;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=t522+3IlYdy/u4Q5HErllLdbaQLXOCv14ZlTAoFuGZw=;
	b=xsmttUsBhQTx8j4LLr0I4oBn2D8zHZPHmKFc34GxH9Lx+j7nmp3V+EAxfYiRrVkJ8sRJ
	 2drDXM5SyqWBvjWHiKJ5ap/G2AskKozZe30RUdoJAifs6kQE8MP6BEPK3NHoQKHFhEwSe
	 fCxzxTi0l+aCHlWBxJ5B7EBc73fJZNj8n3XpKe0lckBBGaf4o9dohe5FLSMx8PSD9IfHT
	 Lkn5ayL5Q+HP9snoXwzfyVpwYKynoP8ZpGr50R/r6JCQ2K5B/ia1B6kBclNt8fjqEcAh9
	 +xXA5fwTqESB8hbHkHMRhToIGjE2EXwe8nmCkilyvpiOkaeGTpEc2poIkGC2fCV9RUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJtwbrMe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F92A606A31B;
	Fri, 23 Oct 2026 19:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJtwbrMe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EA51F01828;
	Fri, 23 Oct 2026 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792782810;
	bh=t522+3IlYdy/u4Q5HErllLdbaQLXOCv14ZlTAoFuGZw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NJtwbrMeiQWFML7+qWMPFMCURJwsbvJdQxKxCUHuLhviYM44oiRrpuXFVezLloypW
	 9Xl0RK1OUQQZH54H2T+6altLAjFAL3T5RzPncDYW1VO+xQm1FVT8aQVQFhXTYzHZ0E
	 8JRSKBDdaf/C/CW9z+OQAouyGtTh6RBxqMpLwNm95SVGZGNg1mnQPxd40nr5K7Q3ow
	 dUZkVqHM/qnpHswLjCx11ebJvM0boYbo4RFw0dJ5405sGfUpq+dgkOf90ttluzpUMY
	 A6fBOajfKz3BXd+nQ1PfOxZJFafoFTp6tcFdyjj8q7A9hu6JyIdxB4BTWyNuf0Rz+6
	 gW1IhaS49hG9w==
Date: Fri, 23 Oct 2026 20:13:19 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Jiri Pirko
 <jiri@resnulli.us>, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, alistair.francis@wdc.com,
 ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261023201319.1bc44cfa@jic23-hlaptop>
In-Reply-To: <20261023154212.GJ3977851@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<yq5a7bjajaco.fsf@kernel.org>
	<atooh7uO2RauUTfY@FV6GYCPJ69>
	<yq5av76sj10a.fsf@kernel.org>
	<20261023142038.GE3977851@ziepe.ca>
	<yq5ase1wiggs.fsf@kernel.org>
	<20261023154212.GJ3977851@ziepe.ca>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Oct 2026 12:42:12 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Oct 23, 2026 at 08:58:35PM +0530, Aneesh Kumar K.V wrote:
> > Jason Gunthorpe <jgg@ziepe.ca> writes:
> >   
> > > On Fri, Oct 23, 2026 at 01:34:53PM +0530, Aneesh Kumar K.V wrote:
> > >  
> > >> CCA currently takes the device identity index during pdev_create. I am
> > >> investigating how to retrieve the certificate chains for all slots. For
> > >> now, I have implemented the sequence below.  
> > >
> > > Yeah, I think the consensus at LPC was this may be a gap in CCA.  
> > 
> > I checked with Alexey, and if I understand him correctly, TIO also needs
> > to establish eight separate connections to retrieve the certificate
> > chains.  
> 
> Lovely!
> 
> > For now, I am trying Jiri's suggestion: use Rust SPDM to fetch the
> > certificate chain and return it via evidence-get. evidence-accept then
> > does pdev-create with the specified slot number and compares the
> > evidence data returned by the RMM with the value cached by Rust SPDM. If
> > they match, it uses the cached value for set_pub_key. This seems to be
> > working. (FVP only supports slot 0, hence only one blob-instance)  
> 
> That's a pretty good idea, and works for every arch! Maybe that is
> the best long term direction.

We discussed doing similar a long time back..  As long as
we use the DOE before the TSM gets hold of it we can have any
conversation we like with the device.

At the time the idea was do the full flow native and if the host
was happy with what it saw, then it could decide to let the TSM
have a play.  The lesser step here (IIUC) is just grab the certs
(so first chunk of typical SPDM flow) seems enough for now
as only a config picking step.

Sounds good to me.

...

> 
> It certainly seems like it should be all sketched out and the uAPI
> confirmed. Given the state of things I don't see an issue with a slot
> 0 only initial configuration (ie EOPNOTSUPP the certificate gets) so
> long as the long term resolution is clear.

Agreed - baby steps is fine.

Jonathan

