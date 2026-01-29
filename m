Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B11233149;
	Thu, 29 Jan 2026 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769694564; cv=none; b=oJs6MRkUUFOyP2tQwf1REE91hm3ZzY5ZL5egZUiJQEgaXKm5ZuIj2skQpKuu8vfcDsrDQheBKwgWOE9FTPk8aWLgS+tmd5m+Ad9hw8xSi7Rmrm7+q8fKlULo04cC0hww5CJJyAILnxgYfyZzxJsEA2meg1u2ui7kMAp0zRX9S9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769694564; c=relaxed/simple;
	bh=PFk8eZzO37OqVya5SZpzpmpEGo5kYqaMCn17kyFtLlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5E7dXJNtu24f8PAyse0DxpIkqZKq6j64Kyo34rcziF5p6+Iwz8cq+Q4YxFvIEiq2XzipUQPTZd4bvKBqzZoTJTtzuDTXsYLfju3klo2SZxkOGmfBNv77DhNCglAF9y1iOTejhLKiVvKxp/SJMpLsRI47ixQcZxPCdWg1X2Wlmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=JdOZB0DA; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="JdOZB0DA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=q6Ug4BpfSSotjJv7bTriGJaezRz6KjojfM1Vr00p55Q=; b=JdOZB0DA+Pm0/mZnnn4AEBjBsU
	R8cojJscVrhP63BC0NCh54K6X5ELbtVZcNLFwQNHbRsdgST1x8YWadtsbFS0C1ehPXkS2idbcfhKO
	ugll0J6ff1pSQNXX797KxRevRy0ToO+TjeAp4viO4y9wzO2w8CuS2IKf15+Yeej9KEIk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vlSOe-005N7y-HZ; Thu, 29 Jan 2026 14:49:20 +0100
Date: Thu, 29 Jan 2026 14:49:20 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next] uapi: net: mii: correct 100BASE4 bit
 descriptions
Message-ID: <268c80bc-e2be-453f-8d03-bf5a5cc1cf9c@lunn.ch>
References: <20260129051736.18986-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129051736.18986-1-enelsonmoore@gmail.com>

On Wed, Jan 28, 2026 at 09:17:35PM -0800, Ethan Nelson-Moore wrote:
> The 100BASE4 bits in MII registers indicate 100BASE-T4, as can be seen
> in Ethernet PHY documentation (such as the datasheet linked below), not
> 4K packets. Correct the comments describing these bits.
> 
> Link: https://www.ti.com/lit/ds/symlink/dp83849c.pdf

It is much better to reference IEEE 802.3, clause 22, section X.Y.Z.

The standard is free to download.

I do wounder where the 4K comment comes from. Did 100BASE-T4 introduce
the concept of jumbo packets?

    Andrew

---
pw-bot: cr
