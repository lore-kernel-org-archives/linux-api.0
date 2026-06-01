Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AB51C5F13;
	Mon,  1 Jun 2026 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780330606; cv=none; b=P8PrGsSkoEifxw8HLgJZME2F2nZyP+95dT903uJ7uidwoUw8H7K1w0V7K4QMK7Tk/COQ0Cc9tByKrnJCgnaPAy1Qa64WFndrFk3pgM37PJlcgQxLrMf1ZCRjhPPTpE4/GxQcfYLfBnY9DW56OCGVExA2tV9ZaIjNFAwMZPUYKz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780330606; c=relaxed/simple;
	bh=9PKVWhCQBLY1DnMif+SX6mAvCPztWlKczkmKYCWedA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/CWj9C8ba9i2g7BkeNC1yuM6Now7iCBVut5meij6zm9wQM15IIt1XOB//kauc0xIXVGjYGAWcx24OJIVXGfN/6VpEyfnO3m4SKB+Gec9SrBGVCQZK1WP6Y8fV/hgL3XOLfA7uZ+q2OdMFT273i2ajXA4jsMIQIRBYBwIqPXX/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SC2lQoFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SC2lQoFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ECF1F00893;
	Mon,  1 Jun 2026 16:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780330604;
	bh=2bpASveTKRhnnK7RqHQ/gb28QgUflHaWAOnJOmldcic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SC2lQoFOOIhfLyd8tXQdxDdmqlHh9UsZzkKnvBXZS7YH1EDA3xXwa0KDVHF+d8axL
	 M5OfrFlp/JDROL+rcPjrEQfZNvvu2lJCW4q4otdgrG5bSTil3DuJHrrXiZ6jMSqh6F
	 xiM7NvDLMyrWbZjwVrzJHvPYzokqTNRWMq9ZiRTCoyvNfPIGyxNXa8S5LV0bqwbNX3
	 0UbA0pJw8sUDVj/FpSxjv8EzfPaQBHDnkbeWB2cAypMoH0ecPMwpwP3KS/YcKN7/DD
	 W+sun6C4ZP+KZgsptnq+BlE4ePLceTcwCoPYnW0thVe15UfLkVST4AEGucAmLSqgJQ
	 DzaspGX/nifJA==
Date: Mon, 1 Jun 2026 18:16:37 +0200
From: Christian Brauner <brauner@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, 
	David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260601-geldentwertung-aufdecken-aussehen-1502bfad440d@brauner>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <ahv16ogY8Zx3Rtox@pedro-suse.lan>
 <CAPnZJGD5QR5jrNMAem7FjMRTtw+Ue+jm7Dc2Kp8Lcjj+9TDw_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnZJGD5QR5jrNMAem7FjMRTtw+Ue+jm7Dc2Kp8Lcjj+9TDw_Q@mail.gmail.com>

On Mon, Jun 01, 2026 at 12:21:06AM +0300, Askar Safin wrote:
> On Sun, May 31, 2026 at 11:54 AM Pedro Falcato <pfalcato@suse.de> wrote:
> > So, you took an ongoing discussion with an ongoing RFC patchset, and you
> > decided to reimplement part of the idea on your own, as a concurrent patchset.
> 
> Yes. But I propose an alternative solution to this problem.

So I think this is a case where no explicit rules have been broken. But
if you know that someone has been posting patches and is working on a
problem just racing them to get your own stuff merged is very likely to
unnecessarily ruffle feathers. So sync with the person next time.

The discussion wasn't at an impasse and Pedro is expected to follow-up.
It's not very nice to just have someone else's work be for naught.

> Brauner said in discussion for your patchset:
> "So I'm not very likely to pick this up as is".
> So, I decided to submit another solution.

This lacks quite some context... I said "in its current form" and the a
long discussion ensued.

> If my patchset is applied, then I will try to deal
> with splice-pagecache-to-pipe somehow,
> probably by removing it, too. :) I decided first

So ok, but this is literally what Pedro is working on. This just wastes
people's time.
