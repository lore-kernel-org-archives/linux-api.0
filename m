Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693243;
	b=jMV1jAv0sENMev6wE5C3DMktEq8YY+b/uWeJNAZoOoyG22fVUXxlTernMu2OJu9PeBQB
	 hcv0uyMgbrg4XNTcaiE4bChWH6bUG1+A36LSiyGLmksisgBAmiidORQ8MDU1MK1q1XTXy
	 DV98wMfa1cx7GUdvmDxhhJ8Wel8FJOoxvgQ+k6UFfz5Cds0H8nC7I+YSm8024LVUPgoK8
	 xzepNFdbXCRdK2V2P2nmN3tyng1SMYB8TRTJK3ioxF5LjPurPB7/UW6k4mVJsQoVQrb5N
	 F1gbNHM46eWc4vG/Po50nYtjwLlVtePDqnNvsk9oVS/fxPQyMOM4Uw+SlOnv36X167A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693243;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=784f43koehz1U6ssZYrMx3Yza3MQ/G3aMjXccWvMOmY=;
	b=znOwSQLutj836ZTRydhVC/W5WNXVuYNd2SQeBtlRXdh2nBzxErq0R2wZLc7oiWJP/ruS
	 em6lBMdYkJk2+aVq7ZrfZValrM0rXa7VtPvvctPTNMaywLmp7iUOi04PR0VlJfBPznoKB
	 Eaw5vQeoijsYZA/zUSn80UM2uWokJS6i5Vj4MSk47jIGr0vDVJGD2pR8a6B3vcFFmh7tW
	 q+qYzv6ky8aWTZLmyPXUJkd+gxfdmzQrW9eORnzkOyMHFkgKjDg4oYFD3Ihh6H+sVaARO
	 jBq+rcdB1yfVezeDAscFdWE/XFNYiSw9rDYjISeG7EtbrBDCJj8rtrpZ74JRPa0/Cog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A18606A324;
	Tue,  3 Nov 2026 08:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59A18606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ECCCC68B05; Tue,  3 Nov 2026 09:07:18 +0100 (CET)
Date: Tue, 3 Nov 2026 09:07:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>, Christoph Hellwig <hch@lst.de>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	io-uring@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] fs: add RWF_DIRECT for preadv2/pwritev2/io_uring to
 set IOCB_DIRECT per io
Message-ID: <20261103080718.GA4109@lst.de>
References: <20261012184642.558349-1-metze@samba.org> <20261021-kontakt-hauen-albern-9053a385d79e@brauner>
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
In-Reply-To: <20261021-kontakt-hauen-albern-9053a385d79e@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 21, 2026 at 01:04:06PM +0200, Christian Brauner wrote:
> On Mon, Oct 12, 2026 at 08:46:42PM +0200, Stefan Metzmacher wrote:
> > It's useful to control this per io request instead of using O_DIRECT
> > for the file descriptor.
> 
> @Christoph thoughts on this?

Puh.  This goes right into a big discussion right now.  We've
traditionally said mixing buffered and direct I/O is madness, and
that's certainly not untrue.  On the other hand people find this
useful - nfsd is now making heavy use of it, and a few year ago
there was a paper on how the lustre backend really gained by doing
that.  So while some folks like Dave Chinner still get really angry
at the idea of mixing the modes, I feel the ship has sailed and we
need to make it work as good as possible.  For some cases like
mmap'ed I/O it will always introduce data corruption, but we'd at
least make sure there's nothing exploitable.  And the direct user
exposed flag would open lots of these exploit vectors.

There's also issues where file systems still check O_DIRECT for
behavior and not IOCB_DIRECT, and this would increase the problems
with that compared to the existing in-kernel only users.
NFS for example has quite a few O_DIRECT checks, and some of them
feel wrong for this.

