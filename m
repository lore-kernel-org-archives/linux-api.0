Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F4E44BCAA;
	Wed,  8 Jul 2026 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515107; cv=none; b=PV0ntNG+c+ajvvAV4U8ViR+gcgcA1raNxXlKG1fSUgGsETyyfxYa02W5+afH3wi2qrUs0g/V0YryDLdEvhfeNGhYcNohJrqdwo79t1KeKnPO7WUC9DLYOOLFO9GL6KBj3so6DTji9JXXy/e8x3H+dOsr4nB5p006p5xIxxjxBfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515107; c=relaxed/simple;
	bh=nmTiZKwDs9TcQIa3cSAR/ovi0Xv61VJEXX+HvkwfSyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhT1Bstss3Jef5r0cXI62C8bWlik7yNiPmJP9ndBKTN6CAYK1c2Fr5tZBPhm9/KLpO3i+/tGI01w2Nk/kiU8Zsn2xL9Hp3wNkQdWEz0iS5l1hhdXCHk2RuIDSqSqefxJYhLeGktTLTTOBY8pyGyu/tCqmoVXk4Aa/1Ri7n8DOoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhaiwETO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhaiwETO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B7C1F000E9;
	Wed,  8 Jul 2026 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783515106;
	bh=QRPUyGPfTdccGwt58sEKWl+IWzR/UejjR9lig5WYGKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QhaiwETOGKXor5vMCHcRg2PzUbS8ZpsAphiuOu4hDThdjT4fkYeCvlap8//EIgiVH
	 JanpHZsLmY2raWY5Nng8QZbIDeFlHvgO2WySttV0Z1DJ8EScCuJdo423CUoVL1a2hA
	 fxio8IRXF24rCoVDe75y1CxkNdQnhbeLG/EG3vjwcXJt/7lAwOqA1Y4p7W6mbXWcKw
	 6eAxHFaynZd+dYfCtLkW8eHhzZg7cTdJ7bCnCFKW1pa3gIELxrLxt1HMgSo+dfgC1N
	 aNgKTnKqKR7mumD4Mnu0qh6/RXcFBy9ikq1wFu64TzzfO3MhGdwgT6sReiz30pSBI7
	 GQqm6ZmV41XBA==
Date: Wed, 8 Jul 2026 20:51:40 +0800
From: Gao Xiang <xiang@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 2/2] erofs: add ioctl to retrieve the backing source file
 descriptor
Message-ID: <ak5H3N5c0ccCwv6i@debian>
Mail-Followup-To: Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, Christian Brauner <brauner@kernel.org>
References: <20260708093446.3370200-1-gscrivan@redhat.com>
 <20260708093446.3370200-3-gscrivan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260708093446.3370200-3-gscrivan@redhat.com>

Hi Giuseppe,

On Wed, Jul 08, 2026 at 11:34:27AM +0200, Giuseppe Scrivano wrote:
> Add EROFS_IOC_GET_SOURCE_FD ioctl that returns a file descriptor to the
> backing image file for file-backed erofs mounts.
> 
> Returns -ENOENT for block-device-backed erofs mounts where there is no
> backing file.
> 
> The UAPI constant is defined in include/uapi/linux/erofs.h.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Thanks for the patch!

The functionality is indeed useful to users, but similar to overlayfs
one, I'm not sure if the interface is the best way. Since after we add
this to EROFS, we will support this way forever.

I wonder if there could be a way as a common vfs uapi to get source
fds, but I don't have better ideas for now... (that is why I suggested
to Cc linux-api too..)

Thanks,
Gao Xiang
