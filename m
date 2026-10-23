Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792792834;
	b=wY97aWKgsSFL1STAqqqIyPDSKoSHfKt/Y32EKB7jx1P9IIlPSA/IzGQQW7WN2Il4a0JX
	 Pn/FdDancTtagA3GK7dIaQLWfSmQKB6UPQ514ZYk+rvW53M3L6LJAoMiJ3uJZYCW+b6LO
	 DCDtBn5iHRPLM0QV22SMya2R8/CCuyBFtB0B6WDeLrfP5AhytZ60FT5PEycgQRwc49UrX
	 QMzHPP/ebHUk2WiLQU9sEknRx5OCaA0+5YH7ZXK9NanvhFkQHiu5j3HA6RhVEKvmTkdel
	 aicf5yNVMyyVzjPOqKNztjzoOKywwuH+HsLwEByzhUhSF24vXy4WJsPiXdb7UFUm2Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792792834;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=cEebfXd9IhliqLZGZPa/idiUUw956gBCSaHIyOjWMY4=;
	b=hS4sF646HrHYz3GvQPjV0YUnE7PnvKq4HK9euscpuB2Kk8fev4CnoOnB+Ts7FU2uMLaS
	 MrDBvqf2MpC/pq6O8ptG1zkYXK894Q2nw5XXyIq82NXMJxL0ttzZgObmy082Xtzcwag1x
	 QeI2AOjo7L11PyuJ/kNmTcFSpFzO158SzHuHO7FBaEOZoNCNb/4TjwtVJpLiKO1yeAyDD
	 QoWvNxQ857O2gmkm6p0rNlN9qDXpM46nz7Z/MoJHO2yaCGV3wjvcgnNTLkACxrs4BwMLB
	 rJrPg5GmpXIEIgzMzlVM7HEITcCR7wNk3VSRJMOKQ4X/O60gSuDdYOOMWg1RGwRC1Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="mYFCnpH/";
	arc=none smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A6E606A320
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 22:00:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1A6E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=mYFCnpH/
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f3c616c84so101357685a.1
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 15:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792792832; x=1793397632; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cEebfXd9IhliqLZGZPa/idiUUw956gBCSaHIyOjWMY4=;
        b=mYFCnpH/zJiQdckRulUKhnu5SyEtSkhTDF8Bg46lU0oHPXc/ePljtCfIqOYv1O3BDa
         FD2pGwRSnsDWPTIfz0AtzVB1gy+S3UNWFL06UjGsVZcKVgCytbkYSRT1b5R6cYpb/3n8
         OrOIINLusiEnyysMOyzQYXOUKbcpWpzVnk7RMIkY+8cBiezHVBKU0wzpQDZbJCZJRhZL
         IA2eHO0GKAHFN24qGYTX5r+2ebGz1+R6fxhEyTdAj74rU+HWeyG1ZQwGTTPMU82lPM2m
         orF9QllcBBN6cTZlOkLTD3Rzl1kVuiDC9LifGBR/gOsjD3/PdE8ddWj0YCtBXOW8x+mY
         BOrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792792832; x=1793397632;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEebfXd9IhliqLZGZPa/idiUUw956gBCSaHIyOjWMY4=;
        b=ZWhKLu5jRLWnehWfOSEALJSMV8+T4fwrJWO2OZ1NR077eLJpqZOs6rapifqYmx2WzG
         5aONmMquqdhQMXOmJvamVVBZVgiAG4LiPMAtE8AITar/jRQ7WcUqEXXJcnppdgicpLEM
         JA7GSZ2RNoOUYcBQHMqNjZGpbxloZbPuS8KufIN4aPROAI+zsZ/rRBSRp3PNnsCtfMR5
         8O6QnRdXZIBJa8M7qb232CDqEqmTRP9ztHKJdHMf0hGOW6OQZIUQvahRdKk2IzKftHx4
         al8VKKtaV88toA1fd51yFLBir2tCqyHo1WY2DvhQSW+6rV6eHcV1DSay445lMtAlw6uB
         oTeA==
X-Forwarded-Encrypted: i=1; AKwUvBy668u1OQP5FRYA1KQ8z44Z5fbe8vVPl618M9a+7lQN84wpxQHIiTDGP5rc511uMXnEkGsgU9wDtWk=@vger.kernel.org
X-Gm-Message-State: AFq9FYLt8HOxuNAPaqsXxFEJ/NKGVbwNurMLOHD38UrAgFc37yos6nSL
	H26wW9pi+ggEXSOH710g5bTLA+PG4ntqWxbi/ROg3XCChWvGyQaCQxjUfG7UUHkc4LQ=
X-Gm-Gg: AYBFou2g7wUkf/NTSv4SSbQvI23+TmD78b813jGbFzwarCDsv5wnKMT2fNfP064xTQU
	uvtf1Z1LEy780feFYIt0JEuh773kZYqprYqt1O1jHpCL8h432bJ0AJSnltrL2xtuvv389RSfJ39
	8749SRbM7xvkF+d/cQRTkM7kV2yBjQDFgvxxGsfgnUi3tWIPpiUluP3JWcuuG6BQ6t8LmAVpCya
	wpZtwCDy9ZhOSZbiesh7t6DGs5dwd8+81GZt2kimw+9jZ8swEoLk74EVwidFxyd0tnQu5uiHMGV
	06KrNWE1bkdOBcSMmK4eRWxekzbcnOMXYoIqlKo1CP8eChsaf62aFSQtuPVOkbu0ppkGFGXOt4Q
	CTufQ4wA2aYxloXQjOjkCqi3EthE7tas91Nbf07AieW7ac6OR011OL6zFecIFPIHK4NRG9q6RKb
	9mNHEwdG+xM/BUtoVgU/94dcJxhQHcIu8KN6AnVz4MFVhLldZsosEgNEhoj8iLMXgZEku/JCNET
	QF8P8F96jgQYehwKQUeXmsVxED6a6zhLYKVi35XL6CPxdQ8nlywDemUaEZ1BcdxzDteESOICJr0
	H4/Ff5WKOxW5jiAVNydAl8U7DrzeADBTZN4ZGjT2QXUFn8sagtV0l7SmcJqU
X-Received: by 2002:a05:620a:27d6:b0:93f:57a3:71ab with SMTP id af79cd13be357-940ef93d248mr49492685a.32.1792792832337;
        Fri, 23 Oct 2026 15:00:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a78c06sm17716585a.35.2026.10.23.15.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 15:00:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKNJO-0000000H7Rz-2dan;
	Fri, 23 Oct 2026 19:00:30 -0300
Date: Fri, 23 Oct 2026 19:00:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"Fang, Peter" <peter.fang@intel.com>,
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>,
	"sameo@meta.com" <sameo@meta.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	"ankita@nvidia.com" <ankita@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jiri@resnulli.us" <jiri@resnulli.us>,
	"kas@kernel.org" <kas@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Xing, Cedric" <cedric.xing@intel.com>,
	"Quigley, David" <david.quigley@intel.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	"lukas@wunner.de" <lukas@wunner.de>, "aik@amd.com" <aik@amd.com>,
	"jic23@kernel.org" <jic23@kernel.org>,
	"ksinyuk@kernel.org" <ksinyuk@kernel.org>,
	"qinkun@google.com" <qinkun@google.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <20261023220030.GM3977851@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-21-jiri@resnulli.us>
 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
 <20261023141218.GD3977851@ziepe.ca>
 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
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
In-Reply-To: <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>

On Fri, Oct 23, 2026 at 07:40:58PM +0000, Edgecombe, Rick P wrote:
> On Fri, 2026-10-23 at 11:12 -0300, Jason Gunthorpe wrote:
> > I think in the way this stuff ended up being used the userspace isn't
> > actually aware. It just wants the VM's ROT to sign a challenge and
> > forward the resulting blobs to a remote verifier. The verifier needs
> > to be aware of the format, but the collection agent should not need
> > special knowledge.
> 
> So the verifier is a standardized endpoint of some kind...? That makes sense
> then. But I think we don't need the report in here then. Just the quote. More
> below...

There is a direction that the collection agent would be standardized,
systemd-report already exists now, and so the verifier would accept
the data blob defined by systemd-report and process it. I think how
the systemd-report output is convayed to the verifier is somewhat more
open.

> > ie from the perspective of systemd-report it doesn't make alot of
> > sense to have it know every single special configfs path and protocol
> > for each CC vendor just to get a 'sign my challenge' operation.
> > 
> > That's the general north star here. We'd like all the vendors to be
> > able to do collection without having to change systemd for every new
> > innovation. Again I'm looking at 5-10 ROTs in our platforms, it is not
> > desirable to go and teach systemd about each of them.
> > 
> > So broadly, this requires a challenge to go in, a signed blob to come
> > out, possibly some suppelmentary blob[s] (like certificates), and then
> > labels for what is inside each.
> > 
> > Userspace would collect all the blobs and the labels then ship them to
> > the verifier which has to understand how the data described by the
> > label is organized.
> > 
> > I don't know what "nonce transport blob" means in the future, nonce
> > without signature sounds like a strange thing.
> 
> Yea, it's strange.
> 
> The initial TDX attestation navigated some platform limitations. It involved an
> SGX enclave on the host. The enclave was the thing that did the signing, but it
> did not have any of the TD details. Only the TDX module did.
> 
> So the process to get a quote starts with getting a nonce from the remote
> attester. Then the TDX module took the nonce and formed it into a MACed "report"
> that included all the TD details it knows about. Then this report is shuffled
> out to host userspace, which gives it to the enclave. The enclave just checks it
> and does the signing. Then the resulting quote makes its way back to the guest.
> 
> In the new attestation, the signing happens through the TDX module instead of in
> an SGX enclave. Since the module already has the TD details, it can just add
> them itself to the quote. So all it needs is the nonce. For legacy reasons the
> original TD report is being used for the nonce delivery to host userspace. New
> TD details are not going to be in the report.

Sounds like stuff the kernel should be hiding right? Userspace gives a
nonce and gets back a report, it doesn't care about these details?

If there is a v1 and v2 report because of this then fine, they can be
labeled that way.

> So I'm still not following why we would provide the TD report through the
> standardized interface. Maybe we don't want it?

My biggest motivator is to get the measurement register stuff brought
together so we can multiplex it intside the kernel. In that world I
think it is pretty important that the signature covering the
measurements be clearly affiliated with the measurement registers
themselves so there is some hope of userspace figuring it all out.

attestation subsystem will describe it as one coherent whole, you get
a single TDX /dev/XX that can do extend and generate a signed quote of
those registers together. With the same interface as every other ROT.

IMHO it makes no sense to pull in measurement register and leave
behind the quote in configfs.

I grant you there will not be a huge amount of value in moving the
quote over besides this consistency and ease of use for userspace.

Though I am planning/hoping to have a sane admin tool here as we agree
to things, so admin can do like:

$ attest report
   TDX Report:
     Xyz 
     Abc
   TPM Report:
     124
     435

> > So from a TDX perspective, what would you want to have as labeled
> > blobs for this kind of operation, now and later and maybe someday with
> > DICE?
> 
> On the TDX side we would have to work through how to ask for a
> specific type of quote. In the initial set we have planned, the host
> will decide.

That's fine. Broadly the "default" report format should be set by the
VM's instance type, eg defined by the CSP. It should not change
launch to launch of the same VM.

If you also want to have a way to query specific types, like AMD's
guid thing, then that's fine too. But I think integrating into systemd
report might be a bit tricky so I'm not sure it is a great idea.

In all cases the format of the report is labled, passed to userspace
and given to the verifier. I see Intel already defined DICE format as
'larger than 8k'. We'd probably want to give that a dedicated label in
CTLV land.

Thus, if you boot instance type V1 you always get the same
systemd-report format and a stable ABI there for your verifier. When
you upgrade to instance type V2, the report format ABI can change and
you have to have a V2 aware verifier to process it. Since everything
is nicely labeled the error reporting should be better 'verifier
failed because Intel DICE not support' is way better than 'signature
failure'.

One of the things I'm quite adament about on the data labeling is that
if something sees Blob type A then it should at least be able to
verify the signature. Further format variation should be self
describing data within the signed payload. If it is so different that
you can't verify the signature then you have to give it a different
label too.

> Do we think there could ever be a usage for the coco guest to
> process the quote itself? If the only use is shuffling a blob to the
> verifier then maybe we don't need this either.

Probably not, but if you wanted to, then same process applies the
verifier, you get the label and the blobs and you do the math.

None of thes concepts are really changing from configfs-tsm-report, it
is just wrapped into CTLV instead of the creative use of configfs with
hopefully a bit more robustness on the data labeling.

Jason
