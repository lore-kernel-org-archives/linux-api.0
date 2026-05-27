Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337223D25BC;
	Wed, 27 May 2026 08:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779869597; cv=none; b=ZjcX/1mUFSQGrs48Z9XCxO3LaUDtqnK5irhmDdolVUEl37Uay/yzWEoOGTAGaHghKwKrmO4f+mUs2YCSrgPWcsXE7TsX+UzziTwprg7LcXwYJyNT4EYTjRH4O5mTp5dd3uOcunqjiyGDu1zqzcpxKmyOpoAFDB65XB6PwGDBbno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779869597; c=relaxed/simple;
	bh=GhKDKXXyIH4kIr3JVOhFU06kiXOMzOSHjbQQZ/ZbR5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gPY+1kyTkfJ8M4/QRGa9EjFYF38FrQM+MbEcn91xYJwtAphFqe3VlN0+9LsxN3b05E+RpBEv410fdvy8hURdN7RUBSBXFHz0tgQrHoG/SG13tzIH2tg7xUpBYndL0E1Z5S7DSOzRgVcNDP6B10zWqd9jBbwJIAqyD+8KCr7BqK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fUL444P1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fUL444P1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FrPMCYt0RVmsLS2gLqKLKdA3THwEriMb+/HgR8lhLd0=; b=fUL444P1egWomb3h+0tbz+HT7t
	r3EeUqQeOMKRBmzoHgNsg6yN6mhDLCZ7CMxmp5BDiHloG+QrrBrXrHhmMrQXGg9kBLgCeLOzwRsgB
	bt6LFVqw/LYIGtdH9dQtBnQrc7BZWxuIoM6ZV3rAI+cdC4X1+j5/LMCUlX7wAGN86E6v6J9t0sVEe
	r6A8GqDChv86NFPfeqxMal8ed55t/wh2MbgFgboHXjGj7nUydYj/kTCXHpGjbUTxn1y/R6LqfNr26
	7tlzbWI99zEY9evZ4k0/MVJayfRgv66EZR7p6z2KUMNtmDRVpWDr0b/1sRtT1JULbZckcEq9S3gAm
	EB0QgEAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS9Nt-00000003Wbb-2WV1;
	Wed, 27 May 2026 08:13:01 +0000
Date: Wed, 27 May 2026 01:13:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, demiobenour@gmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/3] net: Remove support for AIO on sockets
Message-ID: <ahanjVfIDlCmeCUE@infradead.org>
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
 <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
 <ahQCZQNoyO8GQt3H@infradead.org>
 <92db3ff0-8f0b-4b61-a167-5004ffcf9025@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92db3ff0-8f0b-4b61-a167-5004ffcf9025@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 26, 2026 at 09:58:27AM -0600, Jens Axboe wrote:
> > The current TCP zerocopy implementation provides completion notification
> > through the socket error code, which is freaking weird and doesn't
> > integrate well with either io_uring or in-kernel callers.
> 
> We already have that via io_uring

Where?  And how do make that available to in-kernel users like
storage protocols and network file system, which really suffer from
the current MSG_SPLICE_PAGES semantics.

> , and without needing msg_kiocb or the

What do you think is the downside of using a kiocb here like for
everything else with async notifications?

