Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795546470;
	b=oyu/ibZDj7yKpyPB0p6eiWaKcIdYB5v4NoG8Y9laCJIkA08PmX5ghYBvXlBKGfA6TdKV
	 EYBvIxRDrOkNzie3kL8uVkvW4QbIFCMt/ckEJ7s4pvr7B1CrelKS2jQmo4hOBXn73pbyI
	 7FPampfCW6KW27bZ35paxhw63sjxyQq6JP2I6MALQGAr5OAI+iVkEt3jfF93vWfcW+Mgc
	 cLsbPzJsKthv9eBLn9qx1X+wksCV/DfLL+lRCY/px95UuJbzMS0aw4qADEZ3HSEmQMPsH
	 6jpgkDCBw7IH4k+zQUQ1DzwLi7Pv5MdapdRBaHj2l20L0aJ71wgxncQmy5yVCUH9CGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795546470;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JlXoPCsikAIAHDol8QyOvxuGmdfr1LiWSUW7tFYnhrg=;
	b=W0NMroJAAIz2aFfhs1xS8tuGFWiuYCpQwCRORH9KgHqtZ30V5AOxtbBKJpBx4b/xVb9X
	 jct2hPTARmpvic3ABQrT3kxu4xPCXlIegn0oNK9DMr/G+zdsBcVF5Y/EYPqxBaGR77umN
	 VJXhRofMCiEBAfmeS/qgxDuEAzYg48TxiuHaIJkkTA7FUrHRHepq97NIA523CKRMtg1/o
	 tn22Is0ZwRiMyEzE/FN06i1wKnkvDqRylsUToEeszr2qRQ+OGdfvKWVHvg6eyKWA9SIvk
	 D3ScNsnArNoCHSlTgqgPeoxTDSjFgIp+CbJYCfugAG9kf2pUil1kNXiXhwv8fh55HDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cs25wCsA;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF624606A331
	for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 18:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF624606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cs25wCsA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4b0a307487aso25536955e9.1
        for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 10:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795546468; x=1796151268; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JlXoPCsikAIAHDol8QyOvxuGmdfr1LiWSUW7tFYnhrg=;
        b=cs25wCsAxCYY1cJ6Eg6HcinqoZc4Ui95SsWD9SLhzVgU9u/mUxznVWamPkE2XUy9im
         X/HlL+u7UcI3aNc3FzmSU76n3MgItgzvA6DYEWvBqbHJ89HkiI/ifBOIPcmQsbvm5d4L
         25i7cMtrd5kDP3pE06QF6T/9Zwhqyv55lSL8mQHH/Pcn6HKj3j/D8ReXSupuP0dBhD8n
         jSEJ3wxGu3hy9nNNnai4mTjQzEn5MZceDId9G2WpRaDBJMdBQFG97YOhdsxgPoBif4m6
         Bod4+sfeFwg1WgTpD12YLxcsBTgou/BIqJ74NmyXFx1KPGFl09D/8ejYplf7reCdI7F/
         +5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795546468; x=1796151268;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JlXoPCsikAIAHDol8QyOvxuGmdfr1LiWSUW7tFYnhrg=;
        b=v2CDwTfy+ZI2Mndz4KL/gIk+o/iIbxH4syHiynhYRLu/ZOIK0PdjR2xoNclKdi+Oml
         toyylgnUc2A9AA/h4HPCOD2cSipbhk5gD01LBH5vzahsnYpes3+G2SRDV9/x2t4zAsVz
         TT/T++rMeNIcc9/6a3Qv7S6Oiy2Q5xxUHBkBQD/zOYKaxyQy1ifYqVMTSUxNZRc5xcYb
         jfFSrycI7obSxjh6f5hbkGIhNv1UGexCvnqOhM4z8MJobHTTnjkuiWoApgIBsyppkwe6
         4XjOLpgsNn1glqsxuBn49z6eOiOkFy6TaXwkbYFJfXbdCYHc9JKclZ0P1BuuNhy1BfzS
         hK6A==
X-Forwarded-Encrypted: i=1; AL+hErETvXfNQKnkFmcRYGNLpjhS2J2KoMhY7ubg15TjwInrBTFZbsx+B9MY2jUFOthSRXlEscsORBPwCGo=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4C2MpQIJxI1Kc0MFmiaQbzn8U80SlE66Ff3r6eDthqBQsFIPp
	nWFsULdHs5+frDYVuPG/6lt4bUE+jUHkNdzogQEt59Auj1RR4HEr+yUl5ol6lkuMy0AGNwXy+bj
	/X5Pr6KLIt+xGXDXF6Q==
X-Received: from wmbje17.prod.google.com ([2002:a05:600c:1f91:b0:4bb:5e69:8177])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:82d0:b0:4bb:818d:8d8f with SMTP id 5b1f17b1804b1-4bb88818955mr377886255e9.23.1795546468273;
 Tue, 24 Nov 2026 10:54:28 -0800 (PST)
Date: Tue, 24 Nov 2026 18:54:27 +0000
In-Reply-To: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124185427.3821700-1-aliceryhl@google.com>
Subject: Re: [PATCH] rust: drm: enable standard fdinfo for Rust drivers
From: Alice Ryhl <aliceryhl@google.com>
To: Peder Bergan <peder.bergan@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, "=?UTF-8?q?Onur=20=C3=96zkan?=" <work@onurozkan.dev>, 
	Asahi Lina <lina+kernel@asahilina.net>, Lyude Paul <lyude@redhat.com>, 
	Janne Grunau <j@jannau.net>, dri-devel@lists.freedesktop.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 19, 2026 at 10:48:47AM +0100, Peder Bergan wrote:
> DRM monitoring tools use drm-driver and drm-client-id in procfs fdinfo
> to identify DRM clients. The common Rust DRM file operations leave
> show_fdinfo unset, so these entries are missing for those clients.
>
> Set show_fdinfo to drm_show_fdinfo. The DRM core helper emits the
> standard client information and calls the separate driver statistics
> hook if the driver provides one.
>
> Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
> Closes: https://github.com/Rust-for-Linux/linux/issues/1266
> Signed-off-by: Peder Bergan <peder.bergan@gmail.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Alice
