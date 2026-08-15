Received: from buffalo.birch.relay.mailchannels.net (buffalo.birch.relay.mailchannels.net [23.83.209.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3672836F;
	Sat, 15 Aug 2026 04:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.83.209.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786766997; cv=none; b=gAzWnHV3JGE865ArTsDeg9jhB9EK0hHC3cgCXMzh5ShOrVpyqmLFSr+WQ2M7jm/jEa+7BrOj/tcoWdL4qyV5J2kSwNpklmsIh0trFMPiB4oz2K/maciQ++1W7vQWMoHCJM+CqWZGhS8T+X3Jxp9yqEcGnVYGMg08BCKUJsNLhD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786766997; c=relaxed/simple;
	bh=lc0rq7xR25Ol7sYvMYnfF2oc0o89SQWS3k7iGuZjJ8I=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Date; b=WAn9jDSNuKJFP1YkEUevGZMqvGP313eN+asiY86MOnML9gAf+raDs/aIb2JXZfqScsZDvVhp0meCV6f0HbEqk58xDksAbSqjYjvSrZDm4v/ntAFkPUTlaVkYZFEWcSaPv3pFuBpMyo4nBNnescb8u8RHkIEsW7JdB6zhOY3uwX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laserology.net; spf=pass smtp.mailfrom=laserology.net; dkim=pass (2048-bit key) header.d=laserology.net header.i=@laserology.net header.b=GiJeo+I/; arc=none smtp.client-ip=23.83.209.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=laserology.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laserology.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=laserology.net header.i=@laserology.net header.b="GiJeo+I/"
X-Sender-Id: hostingeremail|x-authuser|admin@laserology.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 519363817EC;
	Sat, 15 Aug 2026 00:42:45 +0000 (UTC)
Received: from fr-int-smtpout22.hostinger.io (trex-green-3.trex.outbound.svc.cluster.local [100.117.167.206])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3C2D5381FE8;
	Sat, 15 Aug 2026 00:42:44 +0000 (UTC)
X-Sender-Id: hostingeremail|x-authuser|admin@laserology.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: hostingeremail|x-authuser|admin@laserology.net
X-MailChannels-Auth-Id: hostingeremail
X-Name-Interest: 26a45b5761f49bcd_1786754565102_351738541
X-MC-Loop-Signature: 1786754565102:712002723
X-MC-Ingress-Time: 1786754565102
Received: from fr-int-smtpout22.hostinger.io (fr-int-smtpout22.hostinger.io
 [148.222.54.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.167.206 (trex/8.0.2);
	Sat, 15 Aug 2026 00:42:45 +0000
Received: from toolbx (unknown [IPv6:2605:59c0:2068:2608:c60b:fd48:4dc7:1cbd])
	(Authenticated sender: admin@laserology.net)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4hML0d0BRkzyP4;
	Sat, 15 Aug 2026 00:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=laserology.net;
	s=hostingermail-a; t=1786754562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lc0rq7xR25Ol7sYvMYnfF2oc0o89SQWS3k7iGuZjJ8I=;
	b=GiJeo+I/BoF3oCsWP3rcVNHRyXlOWvoIdPFZT5DNT0W34GLqxEfhdgl00nCyipWeehCS9a
	mYNrw3xUmvquyuXN8tW8EYlA6KkoQy17vxHDF0NLeudcsn8Oix7R/YoIopd48nbkSgZ+wj
	+21Og8MgbWovZvVGGhOV2SLznPZsT2q101VGZly6pfKWlV/aIVYQYrPgC6peCdj1XPsJDf
	xxAxIJbq76fH3RrA678ZHU/+wi0yTa/6d/qGEwz4NH9pykBeU5yjSHqGZQwt92nBModJoa
	s5v4n0X8Kb8BTJRXCU2xEdJWW8Te7Ufs/XiZBnq09A8vOvlQndZWGxraSARfSw==
From: Evan Lawrence <development@laserology.net>
To: dmitry.torokhov@gmail.com
Cc: development@laserology.net,
	linux-api@vger.kernel.org,
	linux-input@vger.kernel.org,
	miroslav.bendik@gmail.com
Subject: Re: [PATCH v5] Input: synaptics - add pass-through mode for TrackPoint
Message-ID: <20260815004214.68767-1-development@laserology.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <an9ocXI6b7WEI8D2@google.com>
References: <an9ocXI6b7WEI8D2@google.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Sat, 15 Aug 2026 00:42:40 +0000 (UTC)
X-CM-Envelope: MS4xfHF7PoVelKQNVpgYwJwKsRbtshPavORooC9iaHbKTqHDbaDZWM0BOwN9SoOIaxPuEuO7w7NpmruUBpxy5cVU67d3mGesR9tkR0gCZK+ROXLrltmw3ToJ His5lypjVA0l/ND8jAjYkNkGoLkOWZH4BIilqABqBkTD0V/r5BC/XSkwUe3O8FXqmH+F7cHY4654SYDDS6/c1YOvN8y+EaSxSnV1t4VOp0fujOO6ZtBl9ln3 lnQJ9IcEbDG4vur1fsRtoiGHc0W6raUDaEc3q/PaeSOmCXX1SPzyDh5cEnwTMRIvnj4TwDAvn4bM3hHxhvFn7agGEI23oz10gpfmdCaU+llPw6Ca/5/P1k95 p/43IjgwpPs4E9Kne0kNrjotaLBsBo+INd9/ygwqYRnltgMZ/j4Wzd+ExTLu/+d/C2M49Oz4
X-CM-Analysis: v=2.4 cv=V5Av0vni c=1 sm=1 tr=0 ts=6a7fb602 a=bXe6bw2OB92olpQ1pPvang==:617 a=xqWC_Br6kY4A:10 a=0--Fi8ekQfCFXZ83AN0A:9
X-AuthUser: admin@laserology.net

Hi Dmitry,

On Thu, Aug 14, 2026 at 07:13:00PM +0000, Dmitry Torokhov wrote:
> I have not looked at the implementation yet, just a high-level question:
>
> What devices need this? Can they work in SMbus/RMI4 mode instead (which
> should alleviate bandwidth concerns)?

The target devices are ThinkPad T14/P14s Gen 1/2-class Synaptics pass-through touchpads. The primary test hardware is a ThinkPad T14 Gen 1 (AMD), whose touchpad reports firmware id LEN2064 and whose TrackPoint is an Elan PS/2 device connected through the touchpad's pass-through port.

On this device SMBus/RMI4 is not a viable alternative. Even with psmouse.synaptics_intertouch=1 forced and the touchpad re-probed, it stays in PS/2 mode (no RMI4 device is created). The touchpad's own bandwidth isn't problem; it reports at 75-85 Hz in both modes. The bottleneck is specifically the TrackPoint: behind the pass-through port it is serviced at only 35-40 Hz, but with transparent mode enabled it reaches 75-110 Hz. The exact peak rate may vary by model, but the improvement should be consistently positive.

The transparent pass-through mode addresses exactly that PS/2 pass-through bottleneck by relaying the guest's raw byte stream directly instead of encapsulating it.

I'll follow up with a v6 that also reduces the mode-switch latency by avoiding the ACK-waiting ps2_command() calls on the escape sequence; I will send it as soon as I have tested it.

Thanks, Evan
