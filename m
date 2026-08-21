Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190972F0C74;
	Fri, 21 Aug 2026 04:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787286789; cv=none; b=SdaQPuBYu/6+tQxdeudOLNNkVOy3tnfBp4zsUJuwGjC6sQUe/Z/E27GhbEnY0fM/YqExwA7TuBDonEXDBwnrD4hrHctjYBnS/h9WSVFKhdvtkBFnWKut+5o0GtdQRAYLMXvfxKXllOIY2HIUzRCYmFLvF4z83JjAnqiJLIdJC7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787286789; c=relaxed/simple;
	bh=SJj0jHpZ069WHIH9O+AoS7PvXsDUbarusVG20gkwWac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nnkQtOKPsGdETQ29oxiPdplsQIJXSMelOQTzTCqdFx15tqhBYpDtHR4qQTu4EqioSjLv7+w38hsFEF/SphuUKw/83tb42EboTyyt6ni4fHhkttv09MMujzFZGXWLISJIb9Bia6hOm9TSEPN154rY9+FChuNbOWbtRitBA+i012w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbx1tfgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbx1tfgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9701F000E9;
	Fri, 21 Aug 2026 04:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787286787;
	bh=yP6Vu31st+d9L/OLuasf5swuICr3agwTUp66TF/bftE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dbx1tfgrR4raur/KlbyXyWstf4YrmwOk4rJPQbeZ8x+QAl42Ydf2VKN3rKQr3+vzs
	 zeFxrCRrc0mU6T97u77AaSrFIFpeKQj80WQ/qqfSzyO81tG1t2zrn+dmKzmTTAf7bf
	 XFdeSykiEddxDcUIfiofS+tTYJD7Um/nlyHSEWow=
Date: Fri, 21 Aug 2026 06:31:29 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ferran Duarri <ferran.duarri@me.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI/sysfs: document the link speed and width
 attributes
Message-ID: <2026082105-scallion-automatic-1b58@gregkh>
References: <20260820184228.166566-1-ferran.duarri@me.com>
 <20260820200359.283335-1-ferran.duarri@me.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820200359.283335-1-ferran.duarri@me.com>

On Thu, Aug 20, 2026 at 10:03:53PM +0200, Ferran Duarri wrote:
> max_link_speed, max_link_width, current_link_speed and current_link_width
> have been exported under /sys/bus/pci/devices/.../ since 2018, by
> commit 56c1af4606f0 ("PCI: Add sysfs max_link_speed/width, current_link_speed/width, etc"),
> and none of the four appear anywhere in Documentation/ABI.
> 
> The gap matters most for current_link_speed. current_link_speed_show()
> performs a fresh PCI_EXP_LNKSTA read on every open, so the value reflects
> the link state at that instant. Modern GPUs retrain their link continuously
> as part of idle power management, which means a single read can legitimately
> return any speed the link supports, not the speed the link will use under
> load.
> 
> Observed on an RTX 5070 in a PCIe 4.0 x16 slot, same boot, no configuration
> change between the two reads: 5.0 GT/s while idle, 16.0 GT/s under load.
> Comparing current_link_speed against max_link_speed at idle is therefore not
> a valid test for a degraded link, though it reads like one.
> 
> Document all four. For the max_* pair, state that each reports the
> capability of the device it is read from and not a property of the link: a
> link trains at the lower of what its two ends support, so an endpoint
> capable of more than the port above it reports the higher figure while that
> port reports the lower one. Record where each value comes from, which
> differs between the two attributes. max_link_speed is derived from the
> Supported Link Speeds Vector in Link Capabilities 2, capped by Max Link
> Speed in Link Capabilities, synthesized from the latter alone on devices
> predating PCIe r3.0, and cached at enumeration. max_link_width is read from
> Maximum Link Width in Link Capabilities on each access.
> 
> For current_link_speed, state that it is instantaneous, that comparing it
> against max_link_speed at idle is not a valid degradation test, and that
> callers wanting what the link will actually deliver should sample under
> load -- noting that max_link_speed is not that figure either, being one
> end's capability rather than the link's.
> 
> No functional change.
> 
> Signed-off-by: Ferran Duarri <ferran.duarri@me.com>

Did you forget the Assisted-by: tag?

> ---
> Changes in v2, all corrections to what v1 claimed rather than new material:

You sent 2 v2 patches :(

