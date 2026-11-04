Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793777483;
	b=0S3oFo+sL/YzRNrPatPYPEePrIh4tLfSfV/tWKvFAhH/9r9dt3Jw/QG3ZCm0dz59sQ0+
	 dzgCWKZzVLpbhLFJKzQ7YLPKumEjy7SGrP5wlQP49jc9wkC2+cA5tUDZZyiJLoY+bfGWI
	 A1rE0uEYX9j0uA4KLpuKIcBm5brftIbzg42KjJhYsTa/uEtWbGRQJKns4ApHe5ubwU1dH
	 k5T6GAubr3uw9nZBT1oThd4wsXrfA5l11LRddXtJKihRJ9dWh90ivcZS5hitSTaG8thlK
	 y92w3z3T+S8YFML8k1Raq5wKlA6bzC+Q0DKxiuDGd1irk3Wsxt4Ap/3SGYNw3nQCHfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793777483;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Gf1SJ60wh6rt1cgDzJ1XsuN+6DsStx0G3H1EPBnHUrc=;
	b=obM+DpgcN0rM16flph/O9/lfickXBQPjiD1XMVDuw8lG/LDS9/imDFzTrNJqME/kPe7W
	 SxB5jFVV1o8X+4IrNgMCGHSd8qOmKhBW19tZ3FjpMoCGo7bBiAyNVSSRIyLXVl8eR4dlX
	 /Ru4KrM9VwE5rz80CKY0n8Cwy+NPmR8k5RRX7pnUJSPgBrUQdc6kaaIJjyup1PzLQVDgt
	 9X8VdC3/NL41rbHbu92VzwVfzHHq1PNdkJNoJ436lQ2iFlCOnVEyCJERzGKmRlNws+HD/
	 2hAWgPsxMDbTfYtbybk0BbruCQb8ScVOnx4F6CPUHvL2e/VuWl6U1dBLLXMA6ebPccA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bHveVmbM;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qPyUMYEP;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAED606A326
	for <linux-api@vger.kernel.org>; Wed,  4 Nov 2026 07:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEAED606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bHveVmbM;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=qPyUMYEP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793777481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gf1SJ60wh6rt1cgDzJ1XsuN+6DsStx0G3H1EPBnHUrc=;
	b=bHveVmbMboFoyV/JO0zO4CZHk0sykT/qOL2/fszQ0zblTFn2wFfP1dTCXlbULjVWuiQ6lA
	hkIAVs4LrV6RSWBM7l4BxUVp6sN22wBPRZbykFsWabZRsqW5MC/L5EyhBomu7kdPVQkQ++
	he3m5V8F58tqHZzmi38LORtin1KHjfY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-byl_PXt1O0WhXB0bxuh44w-1; Wed, 04 Nov 2026 02:31:20 -0500
X-MC-Unique: byl_PXt1O0WhXB0bxuh44w-1
X-Mimecast-MFC-AGG-ID: byl_PXt1O0WhXB0bxuh44w_1793777479
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e0c896d05so391245f8f.1
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 23:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793777479; x=1794382279; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gf1SJ60wh6rt1cgDzJ1XsuN+6DsStx0G3H1EPBnHUrc=;
        b=qPyUMYEPu6QMDw+ynFBXj+Jukdd/b7kY/MwSzggCPBbpqxVgSSKgaPVvCXHszLHMco
         DlChHW+HSdOND+z92arp08ItIKAl5SBxI6sb508qvBIMVvrx5D+CCApcPJ6w2U8LroJm
         r4b2JM0Z5YGcJCNO5bJoyhZPF2SGZUAU5HamlEA3FNIx58qghw1wsKgWyPu6gXbmqnQN
         E+gOashfTRRTa6fbRRxM9NEUCG+fzcXqMLRRTDR5xfCivw/vR7Iab+z/LJZmmRbcob58
         7nPyMK1EcwD+cvreIfJGyM9HJYnIuzgjJgn3rUsVj/grOtz2KJY44lsvT26XeYlcUWSR
         WrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793777479; x=1794382279;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gf1SJ60wh6rt1cgDzJ1XsuN+6DsStx0G3H1EPBnHUrc=;
        b=JlFKVAeoWq007xG4WmtE4R7p6xoVLMr5YcIMPQOzraz+s6i06JD2G9GIv3Mu9HoGWE
         BJsf9ame2GpSsHKkmg3rjkysLD78i3Mq/raXlrKx5sCPEdHhS2tp3mpljPyKN9gTtYnW
         DwReqm/nm+Ch7U6UhNs+box8VowADlhJPRcph+qmn9CCUhKNWtf6Ba2gbhG4VR5/E1m2
         6cvvJkq7so0jKtkOEfwoGTuWnsVaJqq/mL92qYrpPI7k653f304GXwzfATvsqGxwnP7N
         IAeBXiIE4kvB84/VxfooKzCY7aEG1X4wSlWf2o8XsVHGHEBJbqiJzUNKMSKgmRaaYY47
         vjpQ==
X-Forwarded-Encrypted: i=1; AKwUvBx42X2WKsNp8Ylkxbg1OyCtTo47U0dkoCYYYb1Gm92CfIfbkTWhnHkCfWqgBMnQArByFxivD7zsqH8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8vCoyZgdCk9g2DbUgsk3+gU9NSgVuEuVP2R2bt3vHydyClegMG
	pXMq2uiJ4ICyAn9bvRQ7FsNNBOCg5JuDTG7X8g0H2yzfrQfBHH1qLnzgdYYEIoKvRFxpxbzEqtV
	yDlZ/E3IOfVVayD+3ZaMdZf73j7kEBf2SdRMlC6Q6OCyboZ879sOvhzSHZFKrcw==
X-Gm-Gg: AYBFou1Ya87JX9/1TKcER4TZY6Ur1GRRpgzmZgjUFJ/MsWFMjNir8Sf/OHOqcBgNzxw
	uEpsknPgTGVNq/R3vaFmPZk5uQUq0fM7NvgdaYLKbloqtNdW32UBTIZTV9zol2EReJYfprL9nOO
	/UXs9VedXEL/x6a/fzyJW2L2C60kQ3/01DyypjpX9rkObLhtQowBWHFlpW7qlPpcz0q2O2bjTwh
	mrdLCP3d3rVFYzQQ1DcCw6c+rkzq9O/LW9dC7+N9wBVb6X+mxN8PUGbDI8QZTDwjyKRmAvWkLv+
	goVHTV10NHLnQ1sfTByL2EWxOCD6jY0GVzustienEBB4PpQTXLBdf3Jkstqf5aARr27ZVq26QDU
	0+bVmTCNO+TyT4BFiiUU4UkL6DIihFop02XVihgYzA6MzLxfXhcJXma13anhnanrEvkSvLtdwxP
	I+O/RDZijRnH3Ik86OfpXxLlcLHToOnwAvki4BgZ4N8dU=
X-Received: by 2002:a05:600c:19c9:b0:4a1:7c7d:8881 with SMTP id 5b1f17b1804b1-4ac182dcb6fmr342501285e9.13.1793777479224;
        Tue, 03 Nov 2026 23:31:19 -0800 (PST)
X-Received: by 2002:a05:600c:19c9:b0:4a1:7c7d:8881 with SMTP id 5b1f17b1804b1-4ac182dcb6fmr342500785e9.13.1793777478812;
        Tue, 03 Nov 2026 23:31:18 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4532916f2sm29117235e9.5.2026.11.03.23.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 23:31:18 -0800 (PST)
Message-ID: <a323799f-a817-4022-96dd-e6f376fb4d03@redhat.com>
Date: Wed, 4 Nov 2026 08:31:17 +0100
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/2] netlink: add an optional per-netns ROUTE
 multicast index
To: patrick <work_patrick@qq.com>, netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 horms@kernel.org, corbet@lwn.net, rdunlap@infradead.org,
 linux-doc@vger.kernel.org, skhan@linuxfoundation.org,
 linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261104033526.2917590-1-work_patrick@qq.com>
 <tencent_1E208C03035DF063166FD46C1DA1978F6306@qq.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <tencent_1E208C03035DF063166FD46C1DA1978F6306@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 04:35, patrick wrote:
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index fe43e8595..0cda347ed 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -280,6 +280,33 @@ checksums.
>   These messages are now emitted at KERN_DEBUG and can generally be enabled
>   and controlled by the dynamic_debug facility.
>   
> +netlink_route_mc_index
> +---------------------

The above breaks kdoc

/P

