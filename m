Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924303;
	b=Mxh6YFzWs+5KChwK5nedd9rv1jLHqg1Q7MUUL41Tmiomt7jAbu1ZGaT6nMiM6ogOqFp/
	 0Eh6lcORN8ajp/xZ6GRUlA7/YjJR1Ady8Fjk8GJQgb2Yp90MJT+3v0RcXJwdoi/sPb2GP
	 z823Lfnu3TPppltrP2yxgoY/5ATpJ1xFoTwbP5tOnKvWc3aBg1i/gStaxDGYC4IODbrtt
	 DhYfDUqDNc0fgNcFQB89wbDSP7nBntqLRHXFl2evl8bsqq0e0b4a3xKmoYR3HRYsjOAeR
	 Q+DWem0I8vcte8XHeg+uS/yd3EeypuSHKlZ4PX5DlLofbXovbwddpZoVceY9mCQzLIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924303;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OrI4q83Nj/+lj2o4EIMNcwkzJoh69UNQ1KQ0/cpUzbQ=;
	b=md6pNCEIZJrDDhlcP0LonMz6QAk+uKh/+skqbLai3sqbzRQTYCcJ+wY9ScldkJorB80u
	 CqhwmgNf//WRC9Y75JaKLf2+kWr+YkiX+B9/ID5NfYcQIm/PDVZxzaHuNatrZym+5vQPx
	 rAw5wxZ1+gY3d7OTiOj3uBaFLPeL4kMA8GiaaYghNNljqm42S4wh+YfKHBK5j9aVuRlkz
	 CloBDtGEb+iDAJ82TBYhxzddsk7THxa10Ju3E3JyA0I6llllmV5rtfWl4jsnMzB+NSaEp
	 Sd1REXGqCnr+Br7pdZ9qna268otYDyxA0Ye2jCb13o+ApIakK+qTPV0xXtmGRDty/YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pj7JVLyC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27260606A894;
	Tue, 17 Nov 2026 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pj7JVLyC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0E51F000C6;
	Tue, 17 Nov 2026 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794924303;
	bh=OrI4q83Nj/+lj2o4EIMNcwkzJoh69UNQ1KQ0/cpUzbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pj7JVLyCOMMKiDLxpVsAkhBMfZwYBbWsh9hu+jHLrvZGWAuEE/2aUzsqcN9JDVnuo
	 cfQsjhPIFW4/EaepFMLtAWZOFpKJhlMf/YpYZ+BZVNVA5D55mtlHWr5dUIRzgNKJK7
	 fgJEjoS/4kcszG76+J4fw+oaBLMpR3KLk/Wwu1Ehds8py4kurNxV9LAUmv6MnwKjth
	 1FrBBZ5n+pe4WPrk6V/bR9xXEYxsEC6jpfgKpLg/CmHer+SIrky0p4Jb8sHmn9OVE9
	 XE4UhTLs9iU/s6Z+f7KcYsJIG08bz4UIct0NOBCAcoz9nUrNhfRnBx9d8x/PKdSsBr
	 GrH+RmOmUqvrw==
Date: Tue, 17 Nov 2026 15:04:54 +0100
From: Christian Brauner <brauner@kernel.org>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, 
	Danny Hu <dannyhu@arista.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, 
	Jan Kara <jack@suse.cz>, Victor Kamensky <kamensky@cisco.com>, 
	Taras Kondratiuk <takondra@cisco.com>, Zheng Zengkai <zhengzengkai@huawei.com>, 
	zhangguangzhi <zhangguangzhi3@huawei.com>, Jason Yan <yanaijie@huawei.com>, silviu.vlasceanu@huawei.com, 
	hpa@zytor.com, arnd@arndb.de, james.w.mcmechan@gmail.com, niveditas98@gmail.com, 
	pierre@arista.com, julien@arista.com, kbharathi@arista.com, 
	alexandr.lobakin@intel.com, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, initramfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, bug-cpio@gnu.org
Subject: Re: [PATCH v6 0/4] initramfs: add support for xattrs in the initial
 ram disk
Message-ID: <20261117-makaber-paranoia-gefilde-7d976e97e12a@brauner>
References: <20261105193743.2654656-1-dannyhu@arista.com>
 <20261110-hengst-tontechnik-ausfuhr-265b06d68611@brauner>
 <a9edb8a433e8efcba3d11b2a06fa1063df41a24d.camel@huaweicloud.com>
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
In-Reply-To: <a9edb8a433e8efcba3d11b2a06fa1063df41a24d.camel@huaweicloud.com>

On Wed, Nov 11, 2026 at 02:45:34PM +0100, Roberto Sassu wrote:
> Similarly, the archive can already ship arbitrary binaries that get
> executed as root. If you want, we could restrict it to security.ima and
> security.evm only.

That doesn't change anything about my main objection. It's still
in-band signalling via a magic filename that changes the meaning of
what came before it in the stream and that no cpio tool knows about.
We're not complicating cpio. It's point was to be so dumb that the
kernel can safely unpack it.

> I agree when the image is prebuilt and has a known reference value. As
> far as I know, there is no reference value when the initial ram disk is
> dynamically generated on the host. In the latter case, using finer-
> granularity measurement/appraisal is the only option.

Whatever generates the initrd on the host can sign or measure the image
it produces. That's not a reason to teach the kernel to apply xattrs
from magic files during early boot.

If you want xattrs in the initramfs then that needs to be a proper,
versioned cpio format that userspace tooling understands. I'm not
taking METADATA!!!. So still no, sorry.

And to Mimi's point that nobody maintained initramfs back then: it's
part of the VFS entry in MAINTAINERS now and we maintain it.
