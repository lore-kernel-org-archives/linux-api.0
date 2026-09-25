Received: from iguana.tulip.relay.mailchannels.net (iguana.tulip.relay.mailchannels.net [23.83.218.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3395B39769B;
	Fri, 25 Sep 2026 06:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.218.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790317531; cv=none; b=VxEBtccCJMeXbi39FLsnR9crF2CiMNmQd0l6UY6cCInBvROGNEHZqecwABL/OkdHW9Lkn+d2ojFH/iv64du4xqbLqNH+fU71ZJ9+TnKnfGwqHwGUlLTsykM6J+yf8oJUzeLQOumLtPAW1HqwklHzgNmviHyG1b5FqjhFdDEu+pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790317531; c=relaxed/simple;
	bh=+bBb4vrdFEBTj/JEpOvJ92dorJYIQG317cAM7HY5uLo=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Date; b=t1RhzLOAjw0KDyBbMxMZa0oQHJGoV77sQrCRFm8rrTuaZ2K4T054jE/yZgmYZ6SUYMLgQR9tsHKbawFdW+xz1g4i7toh+QZ9SMF/pVb1bDVptPM9Gfsp1xgYS6vt0hzD4rqlskfrfFinFyS+sup2dfkAjGzKVa8Z3gY3a9f5Ymw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laserology.net; spf=pass smtp.mailfrom=laserology.net; dkim=pass (2048-bit key) header.d=laserology.net header.i=@laserology.net header.b=EIBZOl87; arc=none smtp.client-ip=23.83.218.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laserology.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laserology.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=laserology.net header.i=@laserology.net header.b="EIBZOl87"
X-Sender-Id: hostingeremail|x-authuser|admin@laserology.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id BE37A161399;
	Fri, 25 Sep 2026 06:25:22 +0000 (UTC)
Received: from de-fra-smtpout8.hostinger.io (100-100-68-17.trex-nlb.outbound.svc.cluster.local [100.100.68.17])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 766861610DC;
	Fri, 25 Sep 2026 06:25:21 +0000 (UTC)
X-Sender-Id: hostingeremail|x-authuser|admin@laserology.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: hostingeremail|x-authuser|admin@laserology.net
X-MailChannels-Auth-Id: hostingeremail
X-Bitter-Trouble: 380af66a477ad640_1790317522379_533286278
X-MC-Loop-Signature: 1790317522379:2966743635
X-MC-Ingress-Time: 1790317522379
Received: from de-fra-smtpout8.hostinger.io (de-fra-smtpout8.hostinger.io
 [148.222.55.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.100.68.17 (trex/8.0.2);
	Fri, 25 Sep 2026 06:25:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=laserology.net;
	s=hostingermail1; t=1790317519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WFItyhy/m+4+f9WJC4296gXFOSXIxofLCMgqwpIZSjI=;
	b=EIBZOl87kHhGkp+VuMedN5obDN1PHKXYcEiN/xScZD4sEuwhEHmQuSZEfWm7FwJ54VYGNi
	WtNemkmSIkynJk8DEof4p1bK/3VIjs3AnRqY8kLbFzS2XamsX84Lbz7cYK+p0xFVNFfznT
	fJV84na7ij06ESwW4G4lXy8JclTMFuegp/nWcFP2dMH54zFuY8A/0dfLg43EGjbGyaDzCb
	I4HgfAkIcMwvckReDeUXPw3fFwMbouCQMy/HIviVXoyVl08/iMB4eiHKQVRIyzxSG+ES+C
	g4DH47/6Ykv9mi9noTENsXqMbiW2rHd3gwVFREpUnj8o/3u29wNpEtlGlnG+Xw==
Received: from toolbx (unknown [IPv6:2605:59c0:2068:2608:c60b:fd48:4dc7:1cbd])
	(Authenticated sender: admin@laserology.net)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4hrgg22tWDz3x2G;
	Fri, 25 Sep 2026 06:25:18 +0000 (UTC)
From: Evan Lawrence <development@laserology.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Evan Lawrence <development@laserology.net>,
	linux-input@vger.kernel.org,
	linux-api@vger.kernel.org,
	Miroslav Bendik <miroslav.bendik@gmail.com>
Subject: Re: [PATCH v5] Input: synaptics - add pass-through mode for TrackPoint
Message-ID: <20260925062454.102935-1-development@laserology.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815004214.68767-1-development@laserology.net>
References: <an9ocXI6b7WEI8D2@google.com> <20260815004214.68767-1-development@laserology.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Fri, 25 Sep 2026 06:25:18 +0000 (UTC)
X-CM-Envelope: MS4xfOnlRoYS6G4pB6HKufcKy2kROKC+YQJinOmtr9Z6ajAk0lUNUNCWxV6idVktJb/+ICrTXQyB6blu+4ii8UwiYr6/78SpBvBs13JhDNrBR8poCmzUn769 MJwaWVP/FTPbyXIIpqAiu88raxX9+CPDeiNHxbPhwSkzzCPKdF7U6vFcB2/oy6YCL+Sdw80U+PoLYkhyQy4S0tWiDq7nEXYF4mqdNGBcgXWMVImeN3miF5mB b+79TD2G7d423RulHr4BoRt7iwcFiOT9R8nucmwtTOIBZF85NOniQv54J1a43yypTOcKiCWSG8WCn3gy6uMbbQDU0idNQJYIFXnB32RdV5yHCYOp2QeBuHtC Y/1SO8JxDRKXPF9FQ/LRkw2LnoMNqT7AK+hYBjJPBLzC37fim23ElMUCKBucrPP3HTeEqnwm
X-CM-Analysis: v=2.4 cv=ALriHGRn c=1 sm=1 tr=0 ts=6ab613cf a=bXe6bw2OB92olpQ1pPvang==:617 a=xqWC_Br6kY4A:10 a=NEAV23lmAAAA:8 a=8b8fbwVGRZi1C_-jfXoA:9
X-AuthUser: admin@laserology.net

Hi Dmitry,

Following up on this thread: I am pausing all work on transparent
pass-through mode, including the v6 I mentioned (the ACK-waiting latency
reduction). I'd rather not push a workaround once the real transport works.

The reason is your original question. In my previous reply I said SMBus/RMI4
was not viable on the T14 Gen 1 because it stayed in PS/2 mode. That turned
out to be a transport bug, not a device limitation: the AMD FCH needs the
legacy SMB0001/ASF Host Notify path enabled before rmi_smbus can talk to the
touchpad. With that in place, the T14 Gen 1 AMD now runs the touchpad (F12)
and the TrackPoint (F03) natively on RMI4, with no transparent mode and no
pass-through bandwidth limit. Both devices are working on a T14 Gen 1 AMD and
on a P14s Gen 2a.

That work is being carried in a machine-specific, not-yet-upstream repository
together with Spencer Michaels, who did the original T14 Gen 2a
reverse-engineering:

  https://github.com/SpencerMichaels/t14-amd-gen2-rmi

I'll keep the transparent-mode series archived and would be glad to revive it
for any machine where RMI4 genuinely cannot work -- but that no longer looks
like the general answer to your question.

Thanks for the review feedback along the way, and to Miroslav for the
original transparent-mode work this was based on.

Also, this was my first real foray into kernel work, and parts were
LLM-assisted; I've reviewed and tested everything on the hardware. Thanks for
the patience with a newcomer.

Evan
