Received: from outbound.mr.icloud.com (mr-2003a-snip4-6.eps.apple.com [57.103.69.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF19D3B9616
	for <linux-api@vger.kernel.org>; Thu, 20 Aug 2026 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.69.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787256250; cv=none; b=YfkXs3lwF9mhReU0ULVnr2eYKdKxRw49DdUJHVOOEeF53QGVDJNaM+lGrgSkLrXZxr9cnksJU0A/FUu8UbzP+9uL+1vTnpgZXN1BMqJHVGyktOeTk8LL/ztD3hlAXIKfEswiJl7lkpDOl9uICbhMG3Or/x9psuJDrkDIlsTBNyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787256250; c=relaxed/simple;
	bh=jg0casZhAxprqoE10C7MtAk0ZfADZXgoNnUvUatgdo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgPfolH51pf80eH47zTL0NNv/owoa+dTcxVu4bDVEOOb3IsyHKHKC8XR+axrOFHzAk6NLdalA/TVEJiQZLnEL1KHzOQLsusirbZp73ibnJnc/1VyslatRvOUG1pQCP0NKHMoeLIc6n088QEjCD2dG3C4J/9S+BcRyXb9FYgKjgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=me.com; spf=pass smtp.mailfrom=me.com; dkim=pass (2048-bit key) header.d=me.com header.i=@me.com header.b=sV6iTrCX; arc=none smtp.client-ip=57.103.69.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=me.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=me.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=me.com header.i=@me.com header.b="sV6iTrCX"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-6 (Postfix) with ESMTPS id 19347180112E;
	Thu, 20 Aug 2026 20:04:04 +0000 (UTC)
X-ICL-RepId: 01a020c6-0ae8-7c9b-add5-70d14e590a08
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQhABkMAWBxBDkkdXwZfEhVdRVUIRRlTHhccRgxFGVswVB0dDlgGEhZdRV4IGQhdHRkKUFACS1oVVRcOAkIfUB9MFldDWhkcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKBldeWhdeTVoCVk0FSgNfAVsKQglKA10EXgteC0AAXgReH0EUHlYfRQpcXl0NUh9FAnIdXFZQAlpVEgRACFZQXgheH0wc
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai; t=1787256248; x=1789848248; bh=NOr7/E8MqBGfpagwg3zKjxZh7ki2iDE1ETn97o4WWWI=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=sV6iTrCXmZLWBl548bN9ZsJ3VZe2SQ0ayUdM9PfLG3svVO0R7EXNFE6Ky16w/FcMdav3sUa3ivwf0+2wlzz99yPGd946hjm3Uw+hoZcymBbm2kX7NdtyvWxjuc1AiMr/ylUkVie2syXzKk2xek4T0UpNMH6UwEOORTyniJWSCUhgwM7tzCiYgczZa9iDTFPZ/nAiWQZDJzD7D6id+j8ULOsui2SpxfJAkvCqA8b0quSGEsvFQoU52GKTvLeUbZ5JOgis9LgxEbaa8oOEhAkIJ2MyU4BVPCuRWTK+zWPg/3M3TzIFyfJY/K3HplnsJyLabpz24tyXfuPSPcoxzK3Hyg==
Received: from ncore (unknown [17.156.200.36])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-6 (Postfix) with ESMTPSA id D45CA1800401;
	Thu, 20 Aug 2026 20:04:02 +0000 (UTC)
From: Ferran Duarri <ferran.duarri@me.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ferran Duarri <ferran.duarri@me.com>
Subject: [PATCH v2] PCI/sysfs: document the link speed and width attributes
Date: Thu, 20 Aug 2026 22:03:53 +0200
Message-ID: <20260820200359.283335-1-ferran.duarri@me.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260820184228.166566-1-ferran.duarri@me.com>
References: <20260820184228.166566-1-ferran.duarri@me.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: MPTTA5wnPjJ-9cGoX6doB_fq3BW2zhRu
X-Authority-Info-Out: v=2.4 cv=Sc76t/Ru c=1 sm=1 tr=0 ts=6a875db5
 cx=c_apl:c_pps:t_out a=9mRn2PO/+PIrVdEbaIuMPg==:117
 a=9mRn2PO/+PIrVdEbaIuMPg==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=B9nqV3Rn1-QA:10 a=VkNPw1HP01LnGYTKEx00:22 a=HHGDD-5mAAAA:8 a=VwQbUJbxAAAA:8
 a=rE-s9bnNCZdScJG29WsA:9 a=vUQH8iars7gmROI7:21
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDE1MSBTYWx0ZWRfX5jYa7mlgrxZa
 IuBUfUF/QbUJuGiX3QEj81q6L5J8C3vUj1to4mDY2WYNDJTW8jOmhcmddg7WTX3qHB7MHChA2V8
 A/W+xt4Okx0LCaqkjxTZMtxbDxyRGwe1ORmqOoSIK4VpkeeqDndG6L/gfS9LqfcXxAykNiqFnZw
 MAzZcTbJhbavyefj3ZKnUNiFqnVurjwnvLxpBWWku1hqV/T/fYXwClTOa2Hq2xYx4U6Ym0o6sM9
 KkuMsoh/xKV/n2r5ZQQfZxOHqQebbkVV8AKr/uyHj09jZ9CdeEg8N/lvnX7vWjL7h6qThZx2sPb
 mcvbTRAWON/Pib0G7ZB0cBE+LQT+cLLsbxPdPGDnQbdGB7RAJeuWAatT+KZh+I=
X-Proofpoint-ORIG-GUID: MPTTA5wnPjJ-9cGoX6doB_fq3BW2zhRu
X-JNJ: AAAAAAABRGfCyGZCMG6zdMNDEQEVXR2gGaeyETNr91/CMapOKGAsLnNerO9SxK+3xH285cOrqtv21Q1Fl+Wc1YZv0qFgfCBbuJRcTe+CqlczFyO6J8Ztkw6NjFH5w+vS2ctr/rkYVc4jFpF34bjNpTzHNo+91sC8dOLdHKcFvAfXbrSnz/kWtuuG1zumtVoj0B20S5k55yxx0oWccrhLD13+8BSu0g2TaewTtz6twscwuShh9HMgAZPclPPhMEwF/mJk27+y5UkwXO4//7MixWA1JpXWqUFCWCC1cusWH0O3DG+aWxZQ5Y41akNAKzVqaYJQHDDF4n/v2QeRlGPwePxZ/LRVqiY/kEiGuLUL6Z4Pf7dX2Ku5OwhYMjz4YtQaoyH+sEdytp9p9X56nL0udQpg9g9BX+JuTe3SxD9JE3Ifw41mNgVJJl0/9h/Ewybh6n0ffVEgoIMGoTBefCgtv6VQFSIIng3z53L2FLGwO4NuqDgqkoTR5+zEplolvoRw2slFwK7fJq7+Gbgg5xTYIokOKg633TSUBkyIg5cYHt3i35gqMDpun2lrrBCMmeZgGG4S8rO36fhn7FOH5W2S17/Z62FJ8HciQPEd6soGfqrp2lJ+S6miJgZQY8acoRiZ5oP+WgZWo1sytUu45YzkFGIOLhWhuXojqt/kj+Bav4kEgniEZR2cwL/ns8j6NJLP5cp13DdbDc/ovtvwvWmPD029DyehnGC5eraQDXaKw0y/wjRvO1MVzrLXqerEbP/dH328K4elm6wzrw2QO6VrmmA0Sj8PO/6oa8lNnXQb4Bi8ep6gn4zRjuKFmUyZX45gg6X8ir10OxuXSb4IMIeHsyICzIumAPbFWID1PJw+p9g0en5MFeeDANSZxK19J0/aVFcsdtePdVKquAcOynRQM8GpcFk+7pzcIZ6C5WH0hKZmE/1Um3l/6vxxIx5YDv/olXFislGKNtcm2hpiHNx3OtF2z0G7hLb
 z+W+nMA9OGEk8j5yP5Lr73oxPkGI/UZGpt/zp3G50Y8l7fl/a6YzuC/mWmppXbRCnKqkpxoRWuOqLeoZmdVD3jaqo7uvjIrLIQmn7ONXo5nNkxH5Gwl/eTCKtMrLEYclITl0IoFfVtdDoUIP3d/u9rlVGvHlQK1SAv9Y+CiLNlfvXo/CjiEE3UG1ExvACXMVFFtnL1Qz7OouwfrzfBpLJdqW5r9jw4fd20w==

max_link_speed, max_link_width, current_link_speed and current_link_width
have been exported under /sys/bus/pci/devices/.../ since 2018, by
commit 56c1af4606f0 ("PCI: Add sysfs max_link_speed/width, current_link_speed/width, etc"),
and none of the four appear anywhere in Documentation/ABI.

The gap matters most for current_link_speed. current_link_speed_show()
performs a fresh PCI_EXP_LNKSTA read on every open, so the value reflects
the link state at that instant. Modern GPUs retrain their link continuously
as part of idle power management, which means a single read can legitimately
return any speed the link supports, not the speed the link will use under
load.

Observed on an RTX 5070 in a PCIe 4.0 x16 slot, same boot, no configuration
change between the two reads: 5.0 GT/s while idle, 16.0 GT/s under load.
Comparing current_link_speed against max_link_speed at idle is therefore not
a valid test for a degraded link, though it reads like one.

Document all four. For the max_* pair, state that each reports the
capability of the device it is read from and not a property of the link: a
link trains at the lower of what its two ends support, so an endpoint
capable of more than the port above it reports the higher figure while that
port reports the lower one. Record where each value comes from, which
differs between the two attributes. max_link_speed is derived from the
Supported Link Speeds Vector in Link Capabilities 2, capped by Max Link
Speed in Link Capabilities, synthesized from the latter alone on devices
predating PCIe r3.0, and cached at enumeration. max_link_width is read from
Maximum Link Width in Link Capabilities on each access.

For current_link_speed, state that it is instantaneous, that comparing it
against max_link_speed at idle is not a valid degradation test, and that
callers wanting what the link will actually deliver should sample under
load -- noting that max_link_speed is not that figure either, being one
end's capability rather than the link's.

No functional change.

Signed-off-by: Ferran Duarri <ferran.duarri@me.com>
---
Changes in v2, all corrections to what v1 claimed rather than new material:

 - max_link_speed: v1 called it "the ceiling the link may negotiate, which
   is the lower of what the two ends of the link support". That is wrong,
   and v1 contradicted it one sentence later. max_link_speed_show() calls
   pcie_get_speed_cap(), which returns the capability of the device being
   read and never consults the other end of the link.
 - max_link_speed: v1 said the value is read from the Max Link Speed field
   of Link Capabilities. pcie_get_supported_speeds() derives it from the
   Supported Link Speeds Vector in Link Capabilities 2, masks it against
   Max Link Speed, and synthesizes from Max Link Speed alone only on
   devices predating PCIe r3.0.
 - max_link_speed: v1 did not say the value is read once at enumeration and
   cached in pci_dev->supported_speeds. Since the current_link_speed entry
   states that nothing is cached there, a reader could reasonably infer the
   same of max_link_speed. It does not hold.
 - current_link_speed: v1 advised callers wanting the ceiling to use
   max_link_speed. That overestimates whenever the upstream port is the
   slower end. v2 says to sample under load and warns that max_link_speed
   is one end's capability, not the link's.
 - max_link_width: register attribution was correct and is unchanged in
   substance, reworded only for the same device-versus-link distinction.
 - Dropped a private Forward-Port-Notes: trailer that should not have been
   in the commit message.

 Documentation/ABI/testing/sysfs-bus-pci | 78 +++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index b767db2c52cb..ee1846f3dafa 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -174,6 +174,84 @@ Description:
 		similiar to writing 1 to their individual "reset" file, so use
 		with caution.
 
+What:		/sys/bus/pci/devices/.../max_link_speed
+Date:		September 2018
+Contact:	linux-pci@vger.kernel.org
+Description:
+		The maximum link speed this device is capable of, as a
+		human-readable string such as "16.0 GT/s PCIe".
+
+		Derived from the Supported Link Speeds Vector in the device's
+		Link Capabilities 2 register, capped by the Max Link Speed
+		field in Link Capabilities. Devices predating PCIe r3.0 have no
+		Link Capabilities 2, and for those the value is synthesized
+		from Max Link Speed alone. Read once during enumeration and
+		cached thereafter, so unlike current_link_speed it does not
+		change between reads.
+
+		This is the device's own capability, not a property of the
+		link. A link trains at the lower of what its two ends support,
+		so an endpoint capable of a higher speed than the port above it
+		reports that higher speed here while the port reports the lower
+		one. Reading one end therefore does not tell you what the link
+		will do; read both ends and take the lower.
+
+		Present only for PCI Express devices.
+
+What:		/sys/bus/pci/devices/.../max_link_width
+Date:		September 2018
+Contact:	linux-pci@vger.kernel.org
+Description:
+		The maximum link width this device is capable of, in lanes,
+		e.g. "16". Read from the Maximum Link Width field of the
+		device's Link Capabilities register.
+
+		As with max_link_speed this is the device's own capability, not
+		a property of the link; a link trains at the lower of what its
+		two ends support.
+
+		Present only for PCI Express devices.
+
+What:		/sys/bus/pci/devices/.../current_link_speed
+Date:		September 2018
+Contact:	linux-pci@vger.kernel.org
+Description:
+		The speed the link is operating at right now, as a
+		human-readable string such as "16.0 GT/s PCIe". Read fresh from
+		the device's Link Status register on every read of this file;
+		nothing is cached.
+
+		This value is instantaneous and may change at any time. A link
+		is permitted to retrain to a lower speed and back, and devices
+		with aggressive link power management (GPUs in particular) do so
+		routinely while idle. Two reads seconds apart, with no
+		configuration change in between, can legitimately differ by
+		several generations.
+
+		Consequently, comparing this attribute against max_link_speed is
+		not by itself a test for a degraded link: an idle device will
+		frequently report a lower speed and is working correctly.
+		Callers that need a figure representing what the link will
+		actually deliver should sample while the device is under load.
+		max_link_speed is not that figure either: it reports one end's
+		capability, and the link is limited by the lower of its two
+		ends.
+
+		Present only for PCI Express devices.
+
+What:		/sys/bus/pci/devices/.../current_link_width
+Date:		September 2018
+Contact:	linux-pci@vger.kernel.org
+Description:
+		The width the link is operating at right now, in lanes, e.g.
+		"16". Read fresh from the device's Link Status register on every
+		read of this file.
+
+		As with current_link_speed, this is instantaneous. Links may
+		also narrow and re-widen under link power management.
+
+		Present only for PCI Express devices.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bwh@kernel.org>
-- 
2.53.0

