Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84AF4307AA;
	Fri, 21 Aug 2026 08:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787299768; cv=none; b=hsqwOM8x/VfUpriKgYTBjJt51KDz5O60kR60GPxVC+ycRkUSo5v6RAv5m13vC1tALValhNeQEBAjo+/N+wwrQxrEJi9BdIl8MDInIAqujqCVXyLVZ5b894L0eCmXEGEnbiXGKaLVEHjvBSi4SVazjzBFx+xGW0rQ3oISWiTqqTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787299768; c=relaxed/simple;
	bh=MxzlERkPuv0S2wrHXOHh8O3hT5Ds1q79IcNAEu8Dg1o=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aCA8CFutg3JDp3+ceeqEf9ZOkIq1UsiPijwe0XdiFuDpNqCO94J48leFVDPM51SD4m0ZUr7Fd6pXoGQUZyeFWvSzpW/KevjFWM9bR3hRSak0iTV9STtpWiXYfkfVokfoDC3B4YmHYIgsH8c28oFwOyqIqWDBO+iVmdb2gJXPyvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VtNdP9K+; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VtNdP9K+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787299765; x=1818835765;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=MxzlERkPuv0S2wrHXOHh8O3hT5Ds1q79IcNAEu8Dg1o=;
  b=VtNdP9K+0NCkUFoCZDLk93KE1216e7u7d1c8FSBtWZd1uVz36qurYsCq
   gUwclcNehmMiKN/YckDfSuKLQ3ohkveurcWafWW/4y/IkK83L9uu3aYrT
   f9Q1lv6IlgGpeE3LMKVIEsg2iyrrVAHWK/zdcg/XDGP7HotQzMUrS3DgZ
   Uk5NrxI4io4leV98+9jtFzsfFakh+rIxWmwa6+UiiucK8L4WifVpxYzsq
   f/h2U1tNYWsmOIlkWPUwErTI95WW66DZEwPXXT+93xC5J2QnKdVJRpX4P
   Wrn28zQpSnsU5M7xCvDagv1K5zX9UL7/Ji+dUgot9y0l1Sv63+jGBSQE5
   g==;
X-CSE-ConnectionGUID: bFpP+i+WQxu+a0Y4dipaQA==
X-CSE-MsgGUID: gYKjciQiTSSO5dr4NZASoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="91718917"
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="91718917"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 01:09:24 -0700
X-CSE-ConnectionGUID: mSahNgtURuyo4T47C/1a5A==
X-CSE-MsgGUID: hkBZqoFeTXiXKIHsbTfMfw==
X-ExtLoop1: 1
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.212])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 01:09:21 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 21 Aug 2026 11:09:17 +0300 (EEST)
To: Ferran Duarri <ferran.duarri@me.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, 
    linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PCI/sysfs: document the link speed and width
 attributes
In-Reply-To: <20260820200359.283335-1-ferran.duarri@me.com>
Message-ID: <fc897ad3-ed5e-8755-f5d7-4d6dbe7f57c0@linux.intel.com>
References: <20260820184228.166566-1-ferran.duarri@me.com> <20260820200359.283335-1-ferran.duarri@me.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 20 Aug 2026, Ferran Duarri wrote:

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
> ---
> Changes in v2, all corrections to what v1 claimed rather than new material:
> 
>  - max_link_speed: v1 called it "the ceiling the link may negotiate, which
>    is the lower of what the two ends of the link support". That is wrong,
>    and v1 contradicted it one sentence later. max_link_speed_show() calls
>    pcie_get_speed_cap(), which returns the capability of the device being
>    read and never consults the other end of the link.
>  - max_link_speed: v1 said the value is read from the Max Link Speed field
>    of Link Capabilities. pcie_get_supported_speeds() derives it from the
>    Supported Link Speeds Vector in Link Capabilities 2, masks it against
>    Max Link Speed, and synthesizes from Max Link Speed alone only on
>    devices predating PCIe r3.0.
>  - max_link_speed: v1 did not say the value is read once at enumeration and
>    cached in pci_dev->supported_speeds. Since the current_link_speed entry
>    states that nothing is cached there, a reader could reasonably infer the
>    same of max_link_speed. It does not hold.
>  - current_link_speed: v1 advised callers wanting the ceiling to use
>    max_link_speed. That overestimates whenever the upstream port is the
>    slower end. v2 says to sample under load and warns that max_link_speed
>    is one end's capability, not the link's.
>  - max_link_width: register attribution was correct and is unchanged in
>    substance, reworded only for the same device-versus-link distinction.
>  - Dropped a private Forward-Port-Notes: trailer that should not have been
>    in the commit message.
> 
>  Documentation/ABI/testing/sysfs-bus-pci | 78 +++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index b767db2c52cb..ee1846f3dafa 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -174,6 +174,84 @@ Description:
>  		similiar to writing 1 to their individual "reset" file, so use
>  		with caution.
>  
> +What:		/sys/bus/pci/devices/.../max_link_speed
> +Date:		September 2018
> +Contact:	linux-pci@vger.kernel.org
> +Description:
> +		The maximum link speed this device is capable of, as a
> +		human-readable string such as "16.0 GT/s PCIe".
> +
> +		Derived from the Supported Link Speeds Vector in the device's
> +		Link Capabilities 2 register, capped by the Max Link Speed
> +		field in Link Capabilities. Devices predating PCIe r3.0 have no
> +		Link Capabilities 2, and for those the value is synthesized
> +		from Max Link Speed alone.

IMO it's unnecessary detail to say it's synthetized. For <= PCIe r3.0, 
kernel does indeed synthetize something, but that "supported speeds" which 
is a set of values. pcie_get_speed_cap() used in max_link_speed_show() 
only returns the max value out of that set which, for sane devices, should 
be same as Max Link Speed.

> Read once during enumeration and
> +		cached thereafter, so unlike current_link_speed it does not
> +		change between reads.
> +
> +		This is the device's own capability, not a property of the
> +		link. A link trains at the lower of what its two ends support,
> +		so an endpoint capable of a higher speed than the port above it
> +		reports that higher speed here while the port reports the lower
> +		one. Reading one end therefore does not tell you what the link
> +		will do; read both ends and take the lower.
> +
> +		Present only for PCI Express devices.
> +
> +What:		/sys/bus/pci/devices/.../max_link_width
> +Date:		September 2018
> +Contact:	linux-pci@vger.kernel.org
> +Description:
> +		The maximum link width this device is capable of, in lanes,
> +		e.g. "16". Read from the Maximum Link Width field of the
> +		device's Link Capabilities register.
> +
> +		As with max_link_speed this is the device's own capability, not
> +		a property of the link; a link trains at the lower of what its
> +		two ends support.
> +
> +		Present only for PCI Express devices.
> +
> +What:		/sys/bus/pci/devices/.../current_link_speed
> +Date:		September 2018
> +Contact:	linux-pci@vger.kernel.org
> +Description:
> +		The speed the link is operating at right now, as a
> +		human-readable string such as "16.0 GT/s PCIe". Read fresh from
> +		the device's Link Status register on every read of this file;
> +		nothing is cached.
> +
> +		This value is instantaneous and may change at any time. A link
> +		is permitted to retrain to a lower speed and back, and devices
> +		with aggressive link power management (GPUs in particular) do so
> +		routinely while idle. Two reads seconds apart, with no
> +		configuration change in between, can legitimately differ by
> +		several generations.
> +
> +		Consequently, comparing this attribute against max_link_speed is
> +		not by itself a test for a degraded link: an idle device will
> +		frequently report a lower speed and is working correctly.
> +		Callers that need a figure representing what the link will
> +		actually deliver should sample while the device is under load.
> +		max_link_speed is not that figure either: it reports one end's
> +		capability, and the link is limited by the lower of its two
> +		ends.

The speed may also be capped by Target Link Speed in Link Control 2 that 
is under control of PCIe BW Controller (bwctrl).

> +
> +		Present only for PCI Express devices.
> +
> +What:		/sys/bus/pci/devices/.../current_link_width
> +Date:		September 2018
> +Contact:	linux-pci@vger.kernel.org
> +Description:
> +		The width the link is operating at right now, in lanes, e.g.
> +		"16". Read fresh from the device's Link Status register on every
> +		read of this file.
> +
> +		As with current_link_speed, this is instantaneous. Links may
> +		also narrow and re-widen under link power management.
> +
> +		Present only for PCI Express devices.
> +
>  What:		/sys/bus/pci/devices/.../vpd
>  Date:		February 2008
>  Contact:	Ben Hutchings <bwh@kernel.org>
> 

-- 
 i.

