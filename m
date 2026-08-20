Received: from outbound.mr.icloud.com (mr-2004g-snip4-11.eps.apple.com [57.103.69.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF2840960D
	for <linux-api@vger.kernel.org>; Thu, 20 Aug 2026 19:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.69.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787255628; cv=none; b=FZdtoW5A8YJwSGsKa/9qphNzIGqkUhL8hDgcS/0lm4i+Gv9jmw//Znlhe3Qf2XBqJM3B5jWZir6UyqySDqvgVFmwA+A7wL0fZetyC+nyhqMiFyT75ioVzzex8RVlW5ouWGWpTU6GtHlGcIsWjvmueErZV0upfRS4WxajIj4Tgbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787255628; c=relaxed/simple;
	bh=jg0casZhAxprqoE10C7MtAk0ZfADZXgoNnUvUatgdo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGW836Nqi9GcOvLrZTNNB9TDZM7p5tDCkpLlG1vLUU6gAOJLIm3wDUAUJdfW1bwBL6Wma3la1BU7OQlqlAEsH6471HKZd/0cZMILQRdBhXvW67BCpT6hNhvBksEDHuBGnyHGgq6YTvgyVPuMunDt6xP1i3fHmCwcb9r8DYYwhaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=me.com; spf=pass smtp.mailfrom=me.com; dkim=pass (2048-bit key) header.d=me.com header.i=@me.com header.b=kNv3/Lqy; arc=none smtp.client-ip=57.103.69.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=me.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=me.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=me.com header.i=@me.com header.b="kNv3/Lqy"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-2 (Postfix) with ESMTPS id 8145D18003E8;
	Thu, 20 Aug 2026 19:53:41 +0000 (UTC)
X-ICL-RepId: 01a020bc-870b-79ae-9c41-dd756a1e98fa
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQhABkMAWBxBDkkdXwZfEhVdRVUIRRlTHhccRgxFGVswVB0dDlgGEhZdRV4IGQhdHRkKUFACS1oVVRcOAkIfUB9MFldDWhkcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKBldeWhdeTVoCVk0FSgNfAVsKQglJClgEWAZeC08GXgBeH0EUHlYfRQpcXl0NUh9FAnIdXFZQAlpVEgRACFZQXgheH0wc
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai; t=1787255624; x=1789847624; bh=NOr7/E8MqBGfpagwg3zKjxZh7ki2iDE1ETn97o4WWWI=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=kNv3/Lqydfv/eqT3MJ6mKtBYBCRnsf18ml3wRLE2QGFbnpfc6tPpGfLLSnPIFuwoKk9PK+GDdrf/ql+Z1u+0pzkplX92sTtfeU8B+a/D2YQIYEr6rJd4VFG1hoSR1vz8CRsam7QJCQF0b/kteaUaco+Ms8w7YITg7HB68GqYJIKnlMbogPyYVskAngRSoWpWn8yYzuXx1fKer5//7WUrplulQ31gwVjH12TYWVEATsakfH/+dO5dFLdsKjVxp0bV5k4uVMJW+GMzsB/ivhdNxbttunJgaIMvbEAfajOvLmzoEmcLhVBfj9bbcLVUdcj60nCRWXsghkU+JCfC6aIkUg==
Received: from ncore (unknown [17.156.200.36])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-2 (Postfix) with ESMTPSA id 473401800127;
	Thu, 20 Aug 2026 19:53:39 +0000 (UTC)
From: Ferran Duarri <ferran.duarri@me.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ferran Duarri <ferran.duarri@me.com>
Subject: [PATCH v2] PCI/sysfs: document the link speed and width attributes
Date: Thu, 20 Aug 2026 21:53:27 +0200
Message-ID: <20260820195334.275375-1-ferran.duarri@me.com>
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
X-Proofpoint-GUID: tJ0h-uGttU9CmxXJWyksxF7uJgVHxGH1
X-Authority-Info-Out: v=2.4 cv=Sc76t/Ru c=1 sm=1 tr=0 ts=6a875b46
 cx=c_apl:c_pps:t_out a=9mRn2PO/+PIrVdEbaIuMPg==:117
 a=9mRn2PO/+PIrVdEbaIuMPg==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=B9nqV3Rn1-QA:10 a=VkNPw1HP01LnGYTKEx00:22 a=HHGDD-5mAAAA:8 a=VwQbUJbxAAAA:8
 a=rE-s9bnNCZdScJG29WsA:9 a=vUQH8iars7gmROI7:21
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDE0OSBTYWx0ZWRfX1L66pPapmYYX
 XSEyY3PWNvj36Y2sV9OjYou3G67fJvgOViJlFslw+VOvpeA4Z7lfUyN+8LnaF6gFLrffSCSMP4L
 Kt4LbRPEpjO6HuXs0XA7OyDkdZLqJLDifVB0WCtoFZt/krrqDRaVr5Tg0imxOwSJAUWiA0v4hsm
 K41bRLpcvBMls1DK9str/g5c/Q3GoIKKj/rNAG10/HQSkiePTTOdwO01ss9wH/4Y4UUQoBRtQ9f
 0cn4llqvBQCOow1JJvGD4GUp+Cj+jwAWGVchk+iyjWmJ6UHBsY3mjtpcjOvJJoLLhaq2unQRlTv
 YshAJkoXiPHR0I2t7amFsRWTyX+Z0xJ0fS+trS5+aK4xiGuLzipZ0ze5vbAUE4=
X-Proofpoint-ORIG-GUID: tJ0h-uGttU9CmxXJWyksxF7uJgVHxGH1
X-JNJ: AAAAAAABACBJhwXEMzJu2eI2m/9bAuL20olfCgmSx/Kr3QnAtDnujEP2Sc1PzEqISX3mTQNDzlXLrsgVyppZOPLWb5BK9nsBdwczbfiIeYDGiWfMfgGTabApc2Iwhu9DJ2SGHFKAri6CMpP9IKaZPJbjL2RcpGs//qtTOK9QqagQOEltwI10Gc6Wv19HV005amgm5goWxFtM5+TBtjVcvGVGinxPwIY+P4kVeQHKywXNwCJxr+i2weZ3yybwSrIju3ZB195vE7ryslyeBz2FYHoaAeBH5O3I2t2p/d22vdW84m67WSAFQCM60PWYsozO5uD4+n2VxC8+pFBZvfPvMHyKFIM2z2CqElU+PcNbIn1D4WahsaQWy7VUso/zO0FZoeJ1Ch78+P2fjcpnhedPJ3mE2YuYPSPymaqn/rhdOaqcgZc4zugPpObVio3ZgG96ZWTTjuZUgKrA4dMMHbDRpF4wZF96RD45Q22nXR8xDWKhwO8x6Te3+GfY+PF2+u2+yA0oHEk25+Qvq3o0MsThQo2OcLJ1KYioWoLccq+754ohN7xHIZ/ojUasoG4IXp/pOvt6fwY654iQsIfRT3Ia9+TzvYU71GgqziHIBQYSxJ5e0JlNEKr98jwqzzonJGLOTJpAdYBGI+aTU/OB2zn4k1+cjGNEtrsU+pFKpAc8WGTEKONn22+F8prTDILno3OJEMu3scKiPCwX9liOUIVTOdSrsaQPD5Ue+LsvRMPpI0lfoDJMj0Av79c2hzP4ssW6D5E4fLwB7WjOMaFWqVxrbBLZW/Y8uuCN76tWqHrpOuGai9KwlpMXNVkyqLdiv5DFuvAM8Om7AT2y5p2t7tNp3okHf0SKpurBySrK5bK1P3W7wEiUrUGaK8wRRv0hoCVClaUsnnxcly4ugJLc4jRzR5USVLYuHdnjvQAw1yoB48BfUpApgSEVIEO/XtK38fiBBDODHCOfptJrUPmLxQDy4Elith1nVW8
 Ljayn6UXFDE34IF7dpIlkLVP3LGSBphz/0uYx/KkcHcC0LmyF4cLl/nL55+6fJSCoctdaSXvN0Ayu/dSASPMmvX76RXhPX9RXAbh0XRyieUwc9XgEsM6e+bwUZXCY5DDMXI28Nq6Oz1k2OQoUoNAGgtXahVtNdlkTC4ipYfz3o0FmvV7S/ysH44DXJ3liBzjdNE49HRsVtw==

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

