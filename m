Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792539068;
	b=DBvBKbTioDfb4B0phP2NR79kpo+R1Hf6VRKZbLMHqE+ZnQKOOZalKgy2smLG3m5UmXdJ
	 Js5RGvAzYholjr1ta4l/Bdb+dzI5Rsz7Rv8LMkb5rb8/94riqCpEHHJQ3U2paZBnWhJnm
	 mvtFK/2Cd1Km4LhIoL1ydBUepM6aYolN57TqPbzFqlC7QDf10XhSccPAj6QtrxCSV6JwH
	 ncyT2+mFgC1g7U+ui2qppJdfi21bls02loIiopMY9I3ntniahfVzr2yRvbVZM+r9rO2aK
	 VwH5ztpSissSCVjBiYUReR4qAUE8WTGdsDWP+4c8IBbKUosYMgbz5nx1+WftKxdOthg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792539068;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=NQ7Q//r/zh1Th3NpvcNkh5KF9pBS8Ytb4Y1WhggDB7w=;
	b=00f5XcUDyH46mUo8tR5DDBs8eLWyjWjjVhQn58UbDxkMqrkiR9ud7YcTdbFLghbMqP5f
	 HRKS7kJoz4/OLqBYhTlebxmDpyYty3R5KVM4UDUbNE+2ByvCsDMkNXDnMbO8lraGDBCkU
	 F+g7Lm6RqyGOq5U782yu7uC3DXX4yA5DgOeYcIY64IfaAvG+kbCkRd6BQpl8LC3lr0HgB
	 s6lTyhptw48UwNVS80fKyRP9ltTS7YiKI0jGlMzToMToZMsMr8xlIsZ32AclrqfilVzah
	 dOdV0ILAtzDstX/J0oMPYYF/ohMxmT4SokQ6gJUQFgBqslgddPSWbLfWb2sI1CrEd5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAkwyGlt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295F9606A31C;
	Tue, 20 Oct 2026 23:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAkwyGlt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A805B1F000C9;
	Tue, 20 Oct 2026 23:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792539068;
	bh=NQ7Q//r/zh1Th3NpvcNkh5KF9pBS8Ytb4Y1WhggDB7w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WAkwyGlt+bt1fAKH9pe9wYemnWX/5rJ2wCeF3QVo5GV71Y/6pXM0De/SKP26gyzUt
	 86WEx3mK1Igv7o8NSefg9Ya8MIUzSa5rqSEiuRHelbVIvbCNfcJkjIZM6KNHQTJSSM
	 6ESx+/yy0sB5rkPO79zw21fIx54LXZFyaYoRvbPzS3ehTqgd2U/j8FesPKxo93xq6V
	 t3XNItj1TL1+r8hoQ7AmSxdHey+6FZpKMXFMXncWCsAVfwv9KCiM6VZ1vzVUzyiKsp
	 Wq61lZDnDI8HLNk0G+Xnb6Zd/jWXzFX4Q7Y+z3+3CpZgEFBYqdNG0N5rzPWxDxDzVX
	 yqMpaJ+K8A4Ng==
Date: Wed, 21 Oct 2026 00:30:56 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@HansenPartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, alistair.francis@wdc.com,
 ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
Subject: Re: [PATCH RFC 03/20] ctlv: Add the root family specification and
 generated files
Message-ID: <20261021003056.354a40ad@jic23-hlaptop>
In-Reply-To: <20261015145053.3664509-4-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-4-jiri@resnulli.us>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


> diff --git a/Documentation/ctlv/abi/ctlv.yaml b/Documentation/ctlv/abi/ctlv.yaml
> new file mode 100644
> index 000000000000..fa11bce98f46
> --- /dev/null
> +++ b/Documentation/ctlv/abi/ctlv.yaml
> @@ -0,0 +1,186 @@
> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +%YAML 1.2
> +---
> +# Checked-in ABI snapshot of the ctlv family, written by
> +# "make -C tools/ctlv abi-update".
> +#
> +# The checker compares this family's declarations and inherited stub fills
> +# against this file. Updating it is how a UAPI change gets reviewed; an update

Slightly confusing text: 'it' is unclear, checker or this file?

> +# that removes or renumbers anything, narrows a bound, or makes a placement
> +# required is an ABI break, whatever this file says afterwards.


