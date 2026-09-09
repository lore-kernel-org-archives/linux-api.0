Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5081239A056;
	Wed,  9 Sep 2026 20:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788986997; cv=none; b=GEiijRGgUtvCgyLbYv/zjbW8Su4btavXvMuDxnAzEtzKe1JWoc2Fjsa44ZAVjTHuXak/xXKzMQf4baFdPU+4AbzTavPbGTN3VOG96N1lv7wuzkGERLs6LXqegLUjoXm4qFPo0s52crOZ/zMbdtA5nYjSihj/vHTxo7vbA3Lq9d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788986997; c=relaxed/simple;
	bh=lTTeB6gDl5wxcNDxDYFMd4Wyyctv08r0NG5RJtRrmgc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZsWjydSFFN4LJ/lD01SdNcJuCdR8nFjddfGapFTVVWhp2d3ACW0So3S4Wrz/siKdxwx+kC2TeArlSnOKDhDyiYZi+bEMomzHpozmaAWqSdVLCiBPUVp4sK1sfUdVOhE1yMYPLwugOFWxPXxHjcSQJILmhIvAO3IIxVjbCdWukqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE2E1F0089E;
	Wed,  9 Sep 2026 20:49:33 +0000 (UTC)
Received: by venus (Postfix, from userid 1000)
	id E325F183378; Wed, 09 Sep 2026 22:49:31 +0200 (CEST)
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Sebastian Reichel <sre@kernel.org>, 
 "Derek J. Clark" <derekjohn.clark@gmail.com>
Cc: Hans de Goede <hansg@kernel.org>, 
 "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>, 
 linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org
In-Reply-To: <20260803210720.23844-1-derekjohn.clark@gmail.com>
References: <20260803210720.23844-1-derekjohn.clark@gmail.com>
Subject: Re: [PATCH] Documentation: sysfs-class-power: Update Long_Life
 description
Message-Id: <178898697191.883277.11193044392222700510.b4-ty@b4>
Date: Wed, 09 Sep 2026 22:49:31 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0


On Mon, 03 Aug 2026 14:07:20 -0700, Derek J. Clark wrote:
> While adding charge limiting support to the Lenovo WMI drivers, there
> was some back and forth about whether charge_types or
> charge_control_end_threshold was the appropriate attribute to expose a
> battery charge limiting toggle that is fixed in the BIOS. The confusion
> arose because the charge_control_end_threshold description closely
> matches the functional change the hardware is making, while the
> charge_types functionality better suits the actual an on/off toggle that
> occurs in the BIOS. This specific scenario is not explicitly enumerated
> in the documentation, though it is fairly common.
> 
> [...]

Applied, thanks!

[1/1] Documentation: sysfs-class-power: Update Long_Life description
      commit: 801471494b95bb4aa405ec7a6e318a7ca4cbb086

Best regards,
-- 
Sebastian Reichel <sebastian.reichel@collabora.com>

