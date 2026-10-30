Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793354009;
	b=vJHooA+W01aaxEHucdItbjgp7jFgiiM/DikDM1vShAnGrW7Jfwww0NQBoEpTFoMblVfk
	 f1KqugbNt6ar+BBLHNVJd2t3L96DWMzG9RUa5uaVVGLOD4JERuDcEnu9ntaaNtaXszlbI
	 yYQJgyR3bYDlH6UBdmQmdSoXYfbMPEHExRhkPqJ7sD2fcKEugM9TH+rpgmzUhkgkDb9TT
	 q0KFe6xnBqMoMmGpIauL+lgh1xf+8GufMox+GQ7q7gyGOUBcTyK9a+ttltrdHCI0MHjae
	 CEYky06zJtCoIDlKARAM6IKYPWu5Yl7hkWcCytbX5DJB2GCc37FAxHakhsu+cikxBMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793354009;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=2sVz2kekigEwFuAjOAkuOKnCrnayEOdl/QGk0rPw5eA=;
	b=QyhMZd7ThVZ0NqxSu5KalPiDvN6pmHATNza4LZFXsafuMwVSVDIaMGvf6l1RsZdwI0IM
	 lo0nJGqO+1iYTqEjtehFzRiGQIa4DFRpIUUT3QEZb3MjvCFc0o50TaA2ac8/5b/8Cpm++
	 F2KbEK7E6tHZCgFVdtKPbPYPN5l7vUZrxyTaDu0218SxxmRzYvixOEhp9J2wK8SMEy5Nf
	 j3e4ey56XFLdgQcWdiC/ts7rjUplaDJHKDe0apJKgseAGWdrF0MAdZJ6GNfGCITbhHF8w
	 bnfRHyyH9MmzDxwgjHlKgmISFWamEZjQYrTpmu82FKYMVWQ0gOBmXFfZb7nMhpqENKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790C3606A33D
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 09:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 790C3606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso5108215e9.3
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 02:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793353997; x=1793958797; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2sVz2kekigEwFuAjOAkuOKnCrnayEOdl/QGk0rPw5eA=;
        b=jfCUPK9sZBoRtj2E+Alb9yXH9e9oEAKo6O5FdNMtEtjfbqrv2VRaYVXKp3gzMIsb45
         sd5OuL+bpBjiYZ5XwMFZwC4lARId+a+AiPW3kCH52zurleBtox0FUUeoLFox5UZbALIX
         iKhkw0WljBZZ7vq1pKhyJKVBXZVsAGRnFlj9YEJ71eTohu3oCRaJIaiPjZ+ONR0FrkN7
         9FWaY5PjdmumcBgOVAnQAZYOrvX2In4f41fMgf6TycYk0f0XDQq32zX+826jUXH5Tntc
         GM244THgeu1VuSeiZn0SWIzmXDYSOnmv4iLsdz10MK0iILCHIe5p/kNUpjENpypGm5IQ
         jgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793353997; x=1793958797;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2sVz2kekigEwFuAjOAkuOKnCrnayEOdl/QGk0rPw5eA=;
        b=FjVAev5U2ycI1JCAZZK4e1I4FUwOk6+N+h5oM/D3p24eyGK7+bfsvtaA5mL4wykGFv
         ycmxltJZqfpWo9LbQyHJHpQcXeDqzn71LsoZ3/8zQPcJRVm/Xcv5vFHW3aYE67FI5Pmr
         hxAPQaJ4hGuJUB1YtBBzRhsHzBT4/w/oxjXSGcgYh8aySemqnBlOSZNW+PLUc9+o5oat
         hD39YVNHj+cxzoB+ICgevMEjSaaCIPrr3j/nSpsnLOADvcZ0McK5jRcIE32E48EDPL1/
         vHpTdeeLg3o/pHGTkgyHj8BcXKpc7DOWsHwFna9Y1wiU1MWG27Gnw+ZvSqxBkJ/r+hQH
         rlpA==
X-Forwarded-Encrypted: i=1; AKwUvBxU9zssHkPh9LqGlcBECLNXGojes+F8nV7aneD9s1NsUeZpm65HdCSaHy4pHdJc17djqgYXxJCZhzU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ21J72ynA/mR0Rkz4eUJ18xou+pX+fIwSeEUnl5u/sQLWAlB5p
	/VgovvSc0mRLQ+Ju5ndRLBfbKtvzIcyLgjdogqKRN/XzOaOtrA4t56QROUOaaiTwqHc=
X-Gm-Gg: AYBFou2oWVFWradoMwBQFR6fuK6KXyPuWq1npx1BOOX5I36goIEMMxtwm1esIg1XW4T
	+HVerr29JcRte9JSIQHtnu/1iMhWvBjOcf3oryujzo2aTxL4kFXWoDBO2R6EDqZyGhaemucLqyc
	N9IMUEdajhvNDud25Qr25/8WpaMROxYPuq+ma9nE0Ed7Vm8twcdVDYiDhGqieYnhgT+ymYaKtvQ
	RhkscO4266IAmHWYDGyxI5z4/QBnggbXL4pNQLpyA8iWwnIFqKLigxUPRM7uOpgGrtWi+Bu4o5k
	la13XMcRHQYeWP1S5xeWMF5iM8O2gnuRz2BYTQ08nlDyTF9PYeweZA/FSnUyuAiTzXifZVnQLVZ
	yvWVQSGhJnSBRSdgvDroC233bNHqS2nJLEdrgRmS4HXNQh3Bf9isMkxgLdnROZK0ytoZCbCF9NU
	+Y1TUI4hdxyLqpjyhhGLtbSNqE5eJul2JQF3OReijZ+F3tD2xpDh/F+++rvxyyavNKtTARf+t+H
	UtdAil0vxVcnMHtyX6UrWBnvTRSTNqxVRdRQg+Prkg1aU4W/0SquEYYMsophpDS2tXwL2vyqSsC
	TeJdz+t1zFIdvBP8kK1PgZixjzFQxIzyluEhvpubc7DllDhxGSFcVJd+Lmw=
X-Received: by 2002:a05:600c:524d:b0:49f:e772:6ddf with SMTP id 5b1f17b1804b1-4ac18993ca7mr37419475e9.32.1793353996568;
        Fri, 30 Oct 2026 02:53:16 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04785sm127578065e9.4.2026.10.30.02.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 02:53:16 -0700 (PDT)
Date: Fri, 30 Oct 2026 10:53:11 +0100
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
Subject: Re: [PATCH RFC 11/20] ctlv: Prepare runtime introspection
Message-ID: <auRmMPfaFINUIchi@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-12-jiri@resnulli.us>
 <179302367452.58760.11808905856343064399.b4-review@b4>
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
In-Reply-To: <179302367452.58760.11808905856343064399.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:

[..]

>
>This isn't even that complicated, if I ask AI to explain it in a C ish
>language:
>
>struct device_get_reply {
>	struct {
>		optional struct {
>			uint min_challenge_length;
>			uint max_challenge_length;
>			uint max_total_output_length;
>			struct {
>				enum blob_class;
>				string format;
>				enum representation;
>				uint max_length;
>			} objects[];
>		} evidence;
>
>		optional struct {
>			flags mr_flags; /* read, extend */
>		} mr;
>	} caps;
>
>	struct {
>		/* device-info: filled by the derived family */
>	} info;
>};
>
>I think the yaml names are not helping, calling everything attrs
>everywhere is really confusing. At least the transition into a nest
>and an attr-set should be more clearly marked in the yaml..
>
>The yaml would be significantly better if it was layed out according
>to the actual semantic flow instead of artificially being twisted into
>this need to put everything into a linear list. AI invented this:
>
>device-get:
>  request: {}
>  reply:
>    caps:
>      evidence?:
>        min-challenge-length: uint
>        max-challenge-length: uint
>        max-total-output-length: uint
>        objects[]:
>          blob-class: evidence-blob-class
>          format: string
>          representation: evidence-representation
>          max-length: uint
>      mr?:
>        mr-flags: mr-device-caps
>    info:
>      $extend: device-info
>

I have it implemented like this (with small changes). Looks great!


>So.. how about could we drop the sets, use a direct description of the
>layout and do something else for the ID numbering? Maybe the numbering
>can be solved directly by only listing the names in:
>
>numbering:
>  - device-get.reply
>  - device-get.reply.caps
>  - device-get.caps.evidence
>  -[..]
>
>?

I'm still committed to implicit numbering. For "inline records" I
resolved it by having it encoded as a tree with 4 levels:

 63         48 47 46 45        32 31  28 27  24 23  20 19  16 15               0
+-------------+-----+------------+------+------+------+------+------------------+
|   family    |kind |   index    |  L1  |  L2  |  L3  |  L4  |      field       |
+-------------+-----+------------+------+------+------+------+------------------+
              |<------------------ record ------------------>|

Renamed "attr" to "field" - I agree that the original implementation had
attr everywhere. I got rid of it.
"group" is now "record". I enlarged it to 32 bits to accomodate:
1) kind is one of: named, request, reply - request and reply is used for
   inline op records,
2) index for named records (pre defined)
3) L1-L4 for inline records

rfc2 will show it in more details
>
>-- 
>Jason
