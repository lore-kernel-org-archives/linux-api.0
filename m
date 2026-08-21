Received: from outbound.ci.icloud.com (ci-2003h-snip4-4.eps.apple.com [57.103.91.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC773A7597
	for <linux-api@vger.kernel.org>; Fri, 21 Aug 2026 08:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.91.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787301244; cv=none; b=mIqslBOJLHgbt9WRA8DJ6cZXnNj8Z/7QZ3lmQUC37bfcKUuzmqt/BlcOex/Mta3JpHcxX39j3eOzH7yO3fX7uoyXkePfJxMeUTPVPl6TAeq1UIlQVfgZQxezybZFflSaSCll1KlCIteQqAhn/J+mLAgGBi4sbzPXWQMhx6SWIWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787301244; c=relaxed/simple;
	bh=iXCXxJfPBv7Xg0/Z0Pk3SU+jdOlp1NtD9Ym+tsv/wQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g91bUzQk5AYY7UC1xmwHWIF8vNWvaTm9MyYv7f+JWRoN4tJyjWqNftBWJydkGqWK5CLsOGpK0fuKkswSX6tK0Sl+GrvKJTmfASGEusoyYdHCo+v/+MmY02ZrJFWgNEbe+GWmOuRJGSA9FmNZchLNl/6SJoY1I1YcGfO/q5+8K9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=me.com; spf=pass smtp.mailfrom=me.com; dkim=pass (2048-bit key) header.d=me.com header.i=@me.com header.b=YAhrFI1c; arc=none smtp.client-ip=57.103.91.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=me.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=me.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=me.com header.i=@me.com header.b="YAhrFI1c"
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-9 (Postfix) with ESMTPS id 6AD6F1800123;
	Fri, 21 Aug 2026 08:33:59 +0000 (UTC)
X-ICL-RepId: 01a02374-9a3c-7600-a890-184f10b43921
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQhABkMAWBxBDkkdXwVaEhVdRVUIRRlTHhccRgxFGVswVB0dDlgGEhZdRV4IGQhdHRkKUFABS1oVVRcOAkIfUB9MFldDVAIcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKBldeWhdeTVoCVk0FSgNfAVsKQghIC14EXgFeDUwHXgdbH0EUHlYfRQpcXl0NUh9FAnIdXFZQAlpVEgRACFZQXgheH0wc
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai; t=1787301241; x=1789893241; bh=fUoCUftrstVlcnL9NxF/v43pA0hTnE6jSGmSRxDyJaw=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=YAhrFI1cznwn7xjPzH7fhrEg1ZAeMgNZHaSFnJ9i/N6XV/l2Ui1RcePSN2IgWD9bA4iMLpgnoKTJ5bWIcJfdis2okpe50IiiQNsNAyH7djBTov181dE6F1xvKU8SYAdkWdGZfIYhdNBms8SwPHC6ZQuB9JqnmBjCUNz7KKpjO90oKBUIgglxHNHvSAZ13jnXgQCL13ZQmJhdYuBvvDoJMcElQOkOr8iVD96YQwiap39snhS9DVHAc5ng8w0iRGbiYgSKhkMg+cuN4B7gbI8QXRh8cr0U5I9pm7qMTFlSVcpvVNzhulOSyZNbKFDRQXH1m5+3RImJImNROaaO9yHttQ==
Received: from ncore (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-9 (Postfix) with ESMTPSA id BCDDC1800139;
	Fri, 21 Aug 2026 08:33:57 +0000 (UTC)
From: Ferran Duarri <ferran.duarri@me.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: linux-pci@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ferran Duarri <ferran.duarri@me.com>
Subject: [PATCH v3] PCI/sysfs: document the link speed and width attributes
Date: Fri, 21 Aug 2026 10:33:50 +0200
Message-ID: <20260821083353.444300-1-ferran.duarri@me.com>
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
X-Authority-Info-Out: v=2.4 cv=ILwPywvG c=1 sm=1 tr=0 ts=6a880d77
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=B9nqV3Rn1-QA:10 a=VkNPw1HP01LnGYTKEx00:22 a=HHGDD-5mAAAA:8 a=VwQbUJbxAAAA:8
 a=QpFEwPX_mTq1ATPw6DEA:9 a=2tbVOfNmyhKY4bXz:21
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDA2MiBTYWx0ZWRfX19iyA6wsguv6
 yjDde3Nrz3TACjHH/06FKdwfxm4jOVCrgxAu5xM5/gWcizf7tYcPsDxh+neSlI6bWujZpC9iNYi
 9uAQPUUQ0b6lRTz+U/etJwpHe10jRFLAF1b8GQFlbBvLgBCUhL6Yp6DAdUq+7B4Vh2jZEta6aDb
 +XwfhxT+3dECyjmydlhcLTCBvOL6V0vduOkp0Yo3Q8dFaPBHllUZqiVRFuIqjAMe2cTWwBcT0gh
 fbK0hWL2Tk9kInSW4eJdLEobm35damd+yT1/SvdkbEmOOD+yEcgz4xWIVvzfqqC/L8TcMcBsJne
 r9dbeXwm7uJcZxZRZE4KuwdycjxtPqGRBbD0cv3FeoUzj/Wwb4Qm6oUcTe4+gg=
X-Proofpoint-GUID: vH7NcVSRJpu8oYOk46tMYO-47bde1VUL
X-Proofpoint-ORIG-GUID: vH7NcVSRJpu8oYOk46tMYO-47bde1VUL
X-JNJ: AAAAAAABdljH6HjDaKFWoPnLMs/GAoDBLQ5tAXozvBHDvSDjCtOjL4FkeP6Z3vDS8FCeiLZaTxf+L0GHljbU5PYni1gpGfdkfEdt2Op19FszOB/4JTuYZwahk+mK6zg+kaQT3KHlMMMVPU09hcPRznycS6b3C906he0iRfJmvhfdFWA25dPIegTznii2yQ//k2XBc1hMh6AKDeRZ0DyESFsI3VeERjjZ0QHfeWH1NOWwHouTo3pUrUbbsIAz7GLHBbu5RswWxwZR2ACuaCgacVgkItAJjTRg0jH4LZxlU6MmOLEyKeCls7KIghNqT415svZCW5pSwaWe+QOZYQsliFSr8VhY6GwRsRUzHrQ3XpaCQh9nUhBk7ZOKEIZaa6PfBEJWitYEFhqxk/ppQzYPrFbojFLePMT1az6TGFtvHaVnhQZLtS0WetdRQgpgaHZr+TXw1Gg0Xcjzm+MySPrMMaqnH/yXMU8AWfsve0/8dAeHB1Uyuse7AIuphrRbbBwoEW47XAlZ2n6R7HsH5EmwLMeU9dYq3hGUPHcJ2P/RPRZ9ziIAh71NHs2p1JJgXm/4TNLEuZA8/mcGrGQLeFdBGEzCQ2YLtjw7pLkYHrhDgOg3iFn8Bccgw1GvZnWkUqlJSGkiZFjA9KDkIINpgHsN2PXQvSsPBnkqHy/Ybu53dPsPKPaWosgmyqvTYWNXGeS77dHEdzp5dA41loYuFZ02AKAxLTwaYDH+XuQDg3nqxgVvvwVyAjkdEmyGhYQZqVySAq+NDhEITAVyry9rRe8eyRXonKDej3rrrjR0llSf0MYeSqSGd56fNaGNm/zEDSuxA4KwzLwdmPCDAc8Wxa9L/wLwUYpFChr5jq+RapAzXqr8HYyQVJ9VFjUYoViNr+7w8defWLU0XFVSJkcrkj9fzMYDTIwY9eQpUvSx7MsohHzKbsRUX6HJAQCLAdOuOuNevmiMuOyTVNGI0t2A2dMSyzttGQleeFW
 SlKpUyqS2hIkmL4NlP9/xHgOKBLayAmbr5K9Lj9JE+sCUxV/50cEIKt/fSry0lrzBUdxCBJehBTRFM9ZMlpRi5g2zYhVSesl7ebzyopi4N4W8CqM+wvOo02/1zqPfhqRGTSMO6+QPdpWA2I264G+7T3UNBL1/gKTrty2Ckv0MVHXvEt7+umBUxP+82nRunYnCiG9YE3tjFbuWGHUpeMiEi6fnb+2xGSmgIpTlwFI=

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
Speed in Link Capabilities, and cached at enumeration. max_link_width is
read from
Maximum Link Width in Link Capabilities on each access.

For current_link_speed, state that it is instantaneous, that comparing it
against max_link_speed at idle is not a valid degradation test, and that
callers wanting what the link will actually deliver should sample under
load -- noting that max_link_speed is not that figure either, being one
end's capability rather than the link's, and that the speed may also be
capped by Target Link Speed in Link Control 2 under bwctrl's control.

No functional change.

Assisted-by: Claude:claude-opus-5 checkpatch patch-audit
Signed-off-by: Ferran Duarri <ferran.duarri@me.com>
---
Changes in v3, all from Ilpo's review of v2:

 - max_link_speed: drop the "synthesized from Max Link Speed alone on
   pre-r3.0 devices" sentence. It was unnecessary detail and imprecise:
   what pcie_get_supported_speeds() synthesizes there is a SET of
   supported speeds, and max_link_speed_show() reports only the maximum
   of that set, which on a sane device equals Max Link Speed anyway.
 - current_link_speed: note that the speed may also be capped by Target
   Link Speed in Link Control 2, managed by the PCIe bandwidth controller
   (bwctrl), and that a link held there is configured, not degraded.
 - Add the Assisted-by: tag. v1 and v2 were written with an AI coding
   assistant and neither said so, which Documentation/process/coding-
   assistants.rst requires. Thanks for catching it. The content is
   unchanged from v2; this exists to carry the tag and to be the single
   v2 replacement, since v2 went out twice by my mistake.

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
+		field in Link Capabilities. Read once during enumeration and
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
+		The speed may also be capped below both ends' capability by
+		the Target Link Speed field in Link Control 2, which the PCIe
+		bandwidth controller (bwctrl) manages. A link held there is
+		operating as configured, not degraded.
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

