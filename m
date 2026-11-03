Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692014;
	b=ywwr8dsKNvjn7M5VArerS0kefPGqOggYKCFn+/yorkupBWy0cn33aC5XFADQE87Ooswk
	 nyj9/fx+de5o57i7eOUWT2XU6sWqeWSHF4cTqAHwaUa4Vc1TkUefjhBaf0gU0vN49uWE/
	 5e3hNeRtqpNr4gDZOE/SOEJUkn0nZJYSXGdhw382znH2ql1WXEsdNY0xQeykGsBPUTw9Y
	 Hs/ZWEBM06fD+FefZv1bqaCSvnq121pshiIHZm60wMss2aToz8CMsbvdIzKC4+l6HMwCA
	 rIAoDS+FRHcpyggvyYQavWDO8w50RaFJDJw1o7/RWjsjSppS2FAmxGQCW179I1JPJZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692014;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=T4XnNmwxXQ1d742gOz8xMZW4rqr/Vh8rpF8DpyifFaJqSE8WX/G/+FLv9XtOUiP+zNr0
	 1XucEzJ4P3whNYHvpB5Hh6H+V8qgsDYhoryvBV+bsL2zPbdHM0deBngSbqbfpeS0L3wAe
	 2AteY+rPjQb10YQQiHoBV3EVvi0yyjNSiQrDGb3fLIth7v2xrWMEucAXNGsab3HLTIYaq
	 6InPddDs8AkWI8Txb9LK+MLu9WlhX8Qm8bcbETf1eyGy0Pd3lgFncwRRxsmTVK46Iay9F
	 +MmYcJObr+z8Urg8LLX1PbX9WeW/twSCbgiG86rpFx+HnN/qpp8Ff66FQgTKHRbBPvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F4C606A331;
	Tue,  3 Nov 2026 07:46:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51F4C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 663B768AFE; Tue,  3 Nov 2026 08:46:48 +0100 (CET)
Date: Tue, 3 Nov 2026 08:46:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] statx: add STATX_ATTR_MULTIGRAIN_TIMESTAMP
Message-ID: <20261103074647.GA3678@lst.de>
References: <20261029-mgtime-statx-v1-1-175b5afdf2fb@kernel.org>
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
In-Reply-To: <20261029-mgtime-statx-v1-1-175b5afdf2fb@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

