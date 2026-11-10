Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316282;
	b=vMecjAlDQm8Cxy1YGSmQiP2VoI5qLrjE85qxKDXJhtXt6qFhVkg3vWzrMap01p6vJvix
	 lxGBOcTPA/CFmqkQ1WSIGSsEZSzqXRxE0gW4iiL5zlXFFGRuISf+JcB4aTWWi8wjxiGpN
	 2rcPyJ9rGVfSWhl+jfDWsHz3Wbre4DnOQqNde3L2xihsbAIEjIbc05ba9eLSxmwQdLG1S
	 wyywonFZ74PVwpKieMGLTbl+ZAeQ1PhYvAm71FyQNjfIjFu8DvJRvH/yz4a9108w7Ft49
	 ylT4TwjILfeIKkc7+StXokbbuEliWjtugs8S4OECQg6OEIGEc5/iZUzipKlej0kvc+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316282;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=hv46jG8uHZHn78TEQV5LM7K76EVF6QARAJT1M8iUKJw=;
	b=PWvaoyA9yogqp7sKk+4zC/6w9Hzbnb88C71HEYXmeTUZI8q0he3nCUVNFC1s12SZnBTF
	 VzfSM8ZE2fFd7x/tzfesw/IefKlVSV7sPwHRaMPPwKa7prtAj+NSn8c7b51DrX6AJ/twF
	 AAqpF6onavGlbTtyHSJFSWnukdKHuKjVIUnjigcgxmDBHw0axMfgVg7h2AbP+T1x3g8Xy
	 IihLSy4CzoBZRyB/Ly7NkbnEUh3eNJ00jQyVoC3kPxqZlhGg9gd0zwRyfCNTQXMHcEjAX
	 F2amDz07mv0lFN5UIzTYUyTBGblA4+4v8nlwXhkLa7tHmn9lquVSSvOkvi2c8Q7cegQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFAE606A774
	for <linux-api@vger.kernel.org>; Tue, 10 Nov 2026 13:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BFAE606A774
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91eb3ac1875so19660976d6.1
        for <linux-api@vger.kernel.org>; Tue, 10 Nov 2026 05:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794316276; x=1794921076; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hv46jG8uHZHn78TEQV5LM7K76EVF6QARAJT1M8iUKJw=;
        b=e4PFNw24vmEx9e6XM/cUzCvRERvJabuTvhno9Gz/JzeZWoLyAEqlwt+PiN7PsREzDe
         nbBIpkI6JTuornnBm7/42NrL/w4IdXPpgJMXAMUPCFd7jbdDVIEmKh/jdZ+I+dzViXSB
         H2p2NQNLx9ne0cV1aFkGD5AsPCtzbh2oXhKE+mtPHEk6ablNOVM/G42JAjOhvFRRvEdt
         SknBoahXSauvPineguU97Ohz82cWAZt6yPRa0ML5YUk7kVUMnIDJn8DUcWsiXLLwSwNl
         eFseGz8JV2OEeli+2NBdOH9OYZhu03xI/lkGEnFQ2GC/c8NKeMa66k6Yl0PwfnR2fGbK
         Y+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794316276; x=1794921076;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hv46jG8uHZHn78TEQV5LM7K76EVF6QARAJT1M8iUKJw=;
        b=HkB1MfZdBY2wfbVHwYYswqpq3qWOfH2tpFmq3rFlZRuI5YODAZbGRm1SJZbYK8qKOh
         PUJqHQC2m8sxxVAIh6zr88kDkQMzOT6OoNhGOEOyAbWFc/2t5VfwEBrTjQeb99uYlLsD
         PXVC7Z/7Mobl9wpV1MNKsZQdSl8G9SIPo8QgwTqApioiW4RwGfJV09M8+FYluYTUbeyf
         j7xTYApAuWxs62E+jUw6W66jEiL+UIz0QsnFHmqrBdMP61BFyxPaIeSSOp9Gj4WQ5EY6
         X0h0t5aKZQ8pIq+7CRF0WNDKEKmVGuWpQUEqMqRRQ641fVV2w5vGYeeJcNyM/dMT7uD0
         k0KQ==
X-Forwarded-Encrypted: i=1; AL+hErFzE79AbVOPmF9/z0ibHJs+hLGFCcqzUiktzYM7yoSFC44ufJatmgaLzaNnI9XGrDowO/L4PCE+lDk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Qz9+GTVWpmYjPAZnCprOYt45+CdMkxjxlwzNdeKpAuU5RnnM6
	TMT/M3/kxjmf+deS4si9qZHoOp9LgbBk0gKlphfDM5bVPDvJokzh9tnkcW+onwDlLbw=
X-Gm-Gg: AYBFou17LnnSPKpX6qQTHt64fl8+OuQpqExtiAXsDPxV9FhrOYeOEOcoJqs5jL3Sy+l
	wmfcAGfknVNgBe1kjJfZP8B+rVQ7GjyLg6PC7bmTRQ/ZjEOsJ7QDHRceBpF7pFPnNnhGyRQa8js
	XSa3apt1CMs7jdLQQS066r/e9wUwPeY2V4aXwjUSonYkf4XOc3JC1Dy6bPltLkTnyP04jN9M80n
	A3psGryCEYJYJOTIJCnq455yOV3XhQ9vvvArGbeP338eJHtOM/2k7GiptSPzyvG4VLf/XVyd9x4
	Y3v9CriGAAYTh7FrAHuC+HWg6lFvpxpYhcAuyIdE/7Zjz3pMY14XO1pOWIChxlUdbhp3LeGYt5N
	Y6pZmuHbiRZv/qKn8KvP1hx/zyngWXgISjz+CC5vY5C9m/90jYwgAM/hYVCiLP7nFBCRWJwfK+O
	7aZMAdjCzdMF8FIueymUBQVe5L3xulaBh315ffEVRIEvXPoDEIrzCrM59RNQy4VNKOuOveHq88g
	IIbRecvJ6aXhon5QxYFYfqgWpeA6iOpLK3vsz1zQp8iAnywdxPVKyQ3bQYFxWm8q/ghn9s14gmE
	lNRQ1/ZUGfe+Ljn+GgfcbFuKeqyIWtMlKanLgRkHmr+sHhvCVdo/+DVonoopfQ0XYEa+KshQtMY
	3JJQb//5ZYII=
X-Received: by 2002:ad4:5cc4:0:b0:91e:96f8:f369 with SMTP id 6a1803df08f44-91eef913f53mr42602176d6.36.1794316275746;
        Tue, 10 Nov 2026 05:11:15 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef052360asm20821916d6.38.2026.11.10.05.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 05:11:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xQld4-00000005faP-2KGJ;
	Tue, 10 Nov 2026 09:11:14 -0400
Date: Tue, 10 Nov 2026 09:11:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>,
	"aik@amd.com" <aik@amd.com>,
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
	"x86@kernel.org" <x86@kernel.org>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"lukas@wunner.de" <lukas@wunner.de>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	"Fang, Peter" <peter.fang@intel.com>,
	"jic23@kernel.org" <jic23@kernel.org>,
	"ksinyuk@kernel.org" <ksinyuk@kernel.org>,
	"sameo@meta.com" <sameo@meta.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"qinkun@google.com" <qinkun@google.com>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <20261110131114.GV663069@ziepe.ca>
References: <20261023141218.GD3977851@ziepe.ca>
 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
 <20261023220030.GM3977851@ziepe.ca>
 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
 <20261103005851.GH3889730@ziepe.ca>
 <au5LCE1jau0yDo5S@intel.com>
 <20261109171236.GP663069@ziepe.ca>
 <cbef9bda9241ffe98652172edb67fab3eb1c35ee.camel@intel.com>
 <20261109234252.GR663069@ziepe.ca>
 <4c75b369b68c98c5c35e296895b6935342dc7dc1.camel@intel.com>
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
In-Reply-To: <4c75b369b68c98c5c35e296895b6935342dc7dc1.camel@intel.com>

On Tue, Nov 10, 2026 at 01:30:16AM +0000, Edgecombe, Rick P wrote:
> On Mon, 2026-11-09 at 19:42 -0400, Jason Gunthorpe wrote:
> > > So we have this SGX based quote format that is fixed because it already
> > > exists
> > > in the wild. Going forward we are moving to DICE, but that is a standard
> > > format.
> > > So also somewhat fixed. I guess the question is: is there some combo of bits
> > > in
> > > each blob we could check that could deterministically distinguish between
> > > the
> > > two? To do this we would need to analyze the quote formats.
> > 
> > You guys really didn't make it discoverable when you added DICE? :( :(
> 
> Like influence the DICE spec to interop with legacy SGX based attestation? I'm
> out of my depth to try to say how possible that is.

No, I mean just have the SGX firmware tell the OS if it produced a
DICE or legacy blob :(

> I'm also under the impression that the quote was not designed for local
> processing in the guest. But rather remote attestation which, usually involves a
> helper service that processes the quote. I've never been clear on why that was
> desired. But it probably is part of the reason attestation doesn't fit this use
> case perfectly.

Even the remote helper needs to tell the two cases apart so it can
parse them

Again if you expected the user to pre-tell the helper that this is a
legacy vs DICE VM then that's exactly the bad user experiance I want
to avoid.

> > > If there isn't, I'm not sure what we could do at this point. There is a
> > > library
> > > Intel publishes (right Peter?) that can verify the quotes. I'd guess it must
> > > have some way to distinguish between the two. Can you check how it does it
> > > Peter?
> > 
> > See this is exactly what I'm talking about, I don't want to repeatedly
> > get into this situation down the road over the next decade.
> 
> I'm not sure if I'm missing something. New incompatible standards seem pretty
> normal? Sometimes there is a container to specify which type of blob, and
> sometimes it is just discoverable by clues in the bits.

Yes, completely normal. The thing that generates the data should have
an unambiguous contract with the OS on what kind of data it will
generate.

If you want to change it, thats fine, but the OS participates in the
change and is aware of it.

> I think the thing that is a bit dicey (no pun) with this, is that there is kind
> of a backwards compatibility adjacent change for systems giving the new DICE
> quotes. This came up in in both discussions with Dave/x86 and Sean/KVM. The
> reason why it was considered grumble-ok in the end, was because the full
> verification depends on updates to the library for each new platform due to
> needing to be aware of new keys. So to actually attest even SGX quotes on a new
> platform, library updates are needed to whatever tool or service is being used.
> Since the library needs to be updated in any case, it can also understand the
> new formats without any impact to the user.

I don't know what you guys have done here. There are IETF standards
for all of this and well defined container formats. Sure to parse
every bit of the token you might need a new library, but you should at
least be able to get a signature verified and parse the generic
information reliably.

If your plan is TDX releases are ABI incompatible with the verifiers,
then thats a horrible plan and *much* worse than what ARM is doing,
for instance.

But it sounds like your library can somehow parse the blob and figure
it out, so maybe it is just a matter of describing how that works.

> But this didn't take into account this generic API, local quote processing use
> case. Which is kind of a surprise and I'm actually still not 100% clear on how
> it will be used.

It is not local quote processing. This is labeling data properly so a
verifier is possible without the user having to manually and directly
inform the system what versions of Intel CPUs and TDX modules it
should expect to have.

> I think we would have to circle back with everyone that pushed for the host
> controlled quote type. Let's see if the library can distinguish them already
> too. This attestctl tool... is that something that could consume a library like
> this? Or something that would have a no dependency implementation?

I would hope for no dependency, the idea would be to provide
references for anyone wanting to make verifier software, and a tool
for the admin that wants to debug/understand their systems..

As well as a point to have a strict injection of sanity into what
people are doing so we don't get repeated ABI breaking instances in
future.

Jason
