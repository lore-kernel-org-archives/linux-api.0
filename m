Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794802439;
	b=Y70UyouiNqKFVerdu5Czf9IufD1h4I6WSVL27cpxFlLBil8XyTDSe3B+zF8JjonLsLEs
	 /jaXBEiDes4OkF8Pj7iFKkUGEXT8xgScy5ZjD2B0cLH/xHQcLEe/+jo0lMWuR/yurtoSG
	 sDG0FK5QXKu98ejn4Rhc/yD3kf6BMJcC4GFaKwW5d/BsAWtalYj/WIe+Pa+4G6q+9D6NO
	 9QaPTtSzIth16mCF5PHhpaEaqw01scLQrYPNwiepLskiLopyV5uRc+wUdz3zdE2Q2yhlG
	 PYeRR/pWSMFfaLZzpMV/xDoO8//nUicMAWp8+RpN7fuV5HvBIWDAMHEyFn7auqaOdtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794802439;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FHvuJtluF3E17fuD17Qr8YtY6RUeccc6EGa69X2cBYQ=;
	b=DDtruH4F0RReCTq1saFom3d9ghQlMZzK2ZtojrQxg3i3oqhHUVftgZxqTD8lZdXRO/Kt
	 WjxF336u1Zk7N5kGXnG+tTSQBeiXUJi8e2HkCLvzjSle5FGGSnKyuWlIFNMQyk5X5rIHm
	 gUAvRJibf+zTn2MMHjYn4jONbQLD3/HIbZunD112bjGMMrgbIz61S6ShjS64nOG5GNASn
	 3jzJpLJ8+XnkET7bCzAUaXHARjY7IEXeamrzckq8Xq1VfUhCjMj7xxnf0FLFW+RH3e70x
	 DGfiBkkBoN841UmSJy6HDJxTKH7tRx5215X9NVz4DOafJNeLLj5mgXQqe5dGRY4mPZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZNtryHMX;
	arc=none smtp.remote-ip=91.218.175.155
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2E0606A321
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 04:13:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF2E0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZNtryHMX
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UeR2OVY7Ll0L67nI5WQ8q8etyrOik3DMQLuEe3vfhjU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794802435; v=1; x=1795407235;
 b=ZNtryHMXk2646niLSKQLkzDyvLxIcw/w5qBDbvmZxvsBpQAhb/6/66FKmcGmbzGGLl3NnPD4
 LYryBZcguBNcIEkJiA2BSxfK2AtMYpXCksMLs5vUK5EVnIGOHe9G9Q+HvSLlHjRsowkscnkdO1B
 0me0s/O9q2PczDxQ9sZCxzyQ=
X-Envelope-To: linux-api@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 43362223296a28e1;
	Mon, 16 Nov 2026 04:13:55 +0000
X-Mizu-Trace-ID: 43362223296a28e1
X-Migadu-Flow: FLOW_OUT
Date: Sun, 15 Nov 2026 20:13:50 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yingjie Wang <x-professor@outlook.com>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate
 SEMOPM
Message-ID: <avqC4DnjkMZHjRrq@linux.dev>
References: <cover.1793250194.git.x-professor@outlook.com>
 <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
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
In-Reply-To: <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>

On Sun, Nov 15, 2026 at 02:12:06PM -0800, Andrew Morton wrote:
> On Thu, 29 Oct 2026 05:03:24 +0000 Yingjie Wang <x-professor@outlook.com> wrote:
> 
> > Shakeel, thanks for the suggestion.
> 
> Thanks.  Shakeel, please review [1/3]?
> 

This fell through the cracks. I will take a look at the series soon.

