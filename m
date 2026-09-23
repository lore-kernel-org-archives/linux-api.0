Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542AD4195D2;
	Wed, 23 Sep 2026 05:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142535; cv=none; b=C08uPs6GxONvABXgUwV023yjKtDcN8lhrGf7UX0J72gaFHt2Jg7lmlJCufffTzN3gVjdiaOhU6igAVlxrItkqUdus20FWKvyWqg1qO2gnN7BZGzXlLzmkpxMtpuzQw6iO+feO7ROryTDC84ZI9p03GiHPohFMZSDnsZcRbtPerk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142535; c=relaxed/simple;
	bh=yfaHH9y4TD4RLwNpbO5aRcWTU8ZDYKKdTwShcCInq4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HcCinutmbqwVtWk8ypLrfO6BhVfLawU2XVUoLqAte23Rr9b8x4kmUa5F9/gz6LfZcGawtgDwpdFLY8nJyoNtrLCZpLF7oDxxKKN7HoGmGAQ2Z/Vd8eZO456kFuX7WtU1rw83Hkm76pebHbykyp6DJpzBWCnNjX1iOEHT8vR7BDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Qeok1GQV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Qeok1GQV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+wFBYWTN50BPqgwOPE62LNDyMYzj9FtzyJ9AasR97Kc=; 
	b=Qeok1GQVXgdvYIOKp3NODlwoaLUwEcJt1tfzdFmCPYCno90Uh4yJyLy8dLz6CLlWpKbiRv9MSRg
	9P5BF5YATaKzNSdHdEfwZ43BFho7U/J67i9IoCg4C2yt7nwWj2Zo3sCWJaLzaomu0HRkEyxH+l0FL
	0Yh/QWv3zNek+AIOKb0gkquxrijSVa6tH2yFU9gw3IiE/cY+Xrxs0L39sTTffbUThVZRx1qCJHrnd
	HMdlRnBhdyxJVp4eIO/oSw+h02NPfrzelBijUB7zSd409r2rqSd/8OBXzKlVrd2TibKLkv/oiEBkX
	8IMqVLL5RGxW2w6VcTNPWAbIST5x7ygnfm4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9FqX-0000000Guqf-1nBQ;
	Wed, 23 Sep 2026 13:48:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 15:48:45 +1000
Date: Wed, 23 Sep 2026 15:48:45 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alex Ousherovitch <aousherovitch@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH v5 00/19] crypto: cmh - add Rambus CryptoManager Hub
 driver
Message-ID: <arNoPcxJqrE7BwK9@gondor.apana.org.au>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917225929.2494111-1-aousherovitch@rambus.com>

On Thu, Sep 17, 2026 at 03:59:09PM -0700, Alex Ousherovitch wrote:
> crypto: cmh - add Rambus CryptoManager Hub hardware crypto accelerator

Please check the Sashiko review, it is not happy with your
patches:

https://sashiko.dev/#/patchset/20260917225929.2494111-1-aousherovitch%40rambus.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
