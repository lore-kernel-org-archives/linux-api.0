Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7693727456;
	Wed, 13 Nov 2024 01:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731462516; cv=none; b=lwlS/zA8jwZlXpEJF7wlz2WRHeTMUDZKT3S9Ry03d1hrDsyHcwIhtmESgmTmrCl5rMYEHTHTGkEYtNjKIHJ/lVxfqeo+zOcyzVzNgYdFsfExeuIAb+sYmFszKEwQ1zLAPI2wcvzGuxoA1qoJIRVhCBWsajPNOg30SNA5lQ8ABmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731462516; c=relaxed/simple;
	bh=xQ1mhHVslmUC2QbY0q+QhNLj6yI8XDQ7rKoBrcQS5pw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucb+wn31H+TJWXXK4BKtc5whYPhngRTkYF3y5njVot7KTReD7WIHjLFLIYKzVKENcOa/fL9KiEUlwrvvt9zbekJBymaa/j0jc/wEQpBAvLTRIxvTCYtiipotvYgTgsNWN6u2+D7HDlCEntRAbjYOn6Sg1LlBnNfkwlq1ZQ6NwJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bwwrLetE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bwwrLetE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AB3C4CECD;
	Wed, 13 Nov 2024 01:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731462516;
	bh=xQ1mhHVslmUC2QbY0q+QhNLj6yI8XDQ7rKoBrcQS5pw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bwwrLetEC737zStk8SaH62f57O/zKIlZ7BIfBSktvbXmg8HeZTjSj5b9g8OsyprOc
	 MTv97nIXAjr67yhBaExbRxE8+wr0D1RQXOeRDLyEZGiQpNXWsKkktieF3GwsZaIY4O
	 y1GnYy6k2bQEFwE0UsQd64ieOXxmF2nD1Jyq+huCLdBZP1Y/qVw7LbZ/zBJOD8RJbq
	 jjIelMoWI6AYp78Xley4pXSEtPxJaYk9M29HOlDPbDlL5BlNuffkcbAY1yVAsE4q+M
	 12WIbJon9P9QPhgTMSr/jhE7jiQaU2kn1DjEBba9PYDUuBDjr6ogimt8raE5rPdmFk
	 0LSphCYDgc4Lg==
Date: Tue, 12 Nov 2024 17:48:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: John Ousterhout <ouster@cs.stanford.edu>
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/12] Begin upstreaming Homa transport
 protocol
Message-ID: <20241112174834.43231a32@kernel.org>
In-Reply-To: <20241111234006.5942-1-ouster@cs.stanford.edu>
References: <20241111234006.5942-1-ouster@cs.stanford.edu>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 11 Nov 2024 15:39:53 -0800 John Ousterhout wrote:
> This patch series begins the process of upstreaming the Homa transport
> protocol. Homa is an alternative to TCP for use in datacenter
> environments. It provides 10-100x reductions in tail latency for short
> messages relative to TCP. Its benefits are greatest for mixed workloads
> containing both short and long messages running under high network loads.
> Homa is not API-compatible with TCP: it is connectionless and message-
> oriented (but still reliable and flow-controlled). Homa's new API not
> only contributes to its performance gains, but it also eliminates the
> massive amount of connection state required by TCP for highly connected
> datacenter workloads.

Hi John!

Thanks for pushing forward! I wanted to give you a heads up that we're
operating at 50% maintainer capacity for the next 2 weeks so the
reviews may be more muted than usual. Don't hesitate to post new
versions (typically ~once a week) if you want to address any incoming
feedback and/or the build issues.

HTH
