Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795573148;
	b=wbyIjMCseD9jcwipHluaN5HhMBqogYTPKUd+OXXClLW8st8q5aSX8WOn0UZYiArVOM5a
	 wolAxJgfg96wsQn3/8jokCJDR5k6wHHo3IvDLCNy/hqJxi0WKv9VJQ2zBS5IvcKI5Xbo4
	 Lrl7CdrPY9DLxdvW1qI7OH3DHR/6FsA8f3WzcSgGAvOzFS6w+MOkT3VkX6WBcJWCejXHX
	 A4IqUe0avOoQhQ04fIKSb0KrvJgsbDb6KAlKVUatPnaJ297DU3cy4CeA3/a6tx5gxvaFp
	 7RAEsLHSAry1CPKLnOyBAdt/xamH7qwQzEB63ZVnbaN4P8o1KdQBO3B2LczJdp/fkfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795573148;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=GYoP/F22Ugc6lgcVzIqTK81cwwtgjlrxX6z9WpK5CTY=;
	b=NjQe2TNCtJriYVBR0nQS5KqFuxQA5+Kf+rhulxLeAurO+nkdLm5SKcULBCxhqWZ4sOF8
	 zjroBYlFIXKS/7nFgCDx8uI6wBtI2IEPP2FxrGx1sySe53YTqX+8oWOUbhA1SxvmPRJTT
	 vwF3e1RrJv7ZUk9a2g/fsmu1h8xQ5XKkAUJqH3oFoJgrmRjJiedguGwRGgXi+s4hmCQBq
	 9VaENRyvTkXzJ4SFU8eSwLKRcO5ba9Gu/+DNJnFJN1XiRjraSHQRy2tlR9jSFKB0Cwz5w
	 lbNccyidY6ZytZDjdZt23IjiqNT3D5qWlWshzfEsd0CoWvkQDLRavC0UwTh+ws0DdXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6tjINWT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163E2606A327
	for <linux-api@vger.kernel.org>; Wed, 25 Nov 2026 02:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6tjINWT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DDC1F000D2
	for <linux-api@vger.kernel.org>; Wed, 25 Nov 2026 02:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795573147;
	bh=GYoP/F22Ugc6lgcVzIqTK81cwwtgjlrxX6z9WpK5CTY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q6tjINWTxW5DThpKjro1fzdg/o1ZQU7XHnEVMC/4QUYLMOI2Meg66g7ftRrhYwjTh
	 d+Xu9fqAC/A3CjrA+7ZzZ60h6GjixTHMDZkaNeTS32pcnmOBoh/Hc2jiV3L0PbKm/m
	 /Zrn9zf4V9O+rRkE1vnrSUDaGsISuwAda9l6nF5ZOztf69jlX8OPNmV1pWIgifJS/s
	 M03CI9JSazWQEcNnePW+hNmaNZv/yftrY+AJ45i+l/2FScRD3Ie96wuI4ddFpeKTUM
	 SPfrdO3oHEUBHHT3bISFTUiI/IYOEv198dY0hfPrnyO5/0QIZGjZmmQ7itqAWNodHK
	 H6uorOufadfag==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6bab10842f8so4959742a12.0
        for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 18:19:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF/k2fdxJiI9Wcy3Q0KK8L+nNOGpNBO8G1TOoZ/WtE4gEc5EIYMCfZMHj4bi+sQKqI2kRwRShLM/YY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+7+acvc18OA+/csL4d17GCA6uwV7VIuZf8HJU8VPP2Zi6rm+nA
	WVWYC3V/eXEpFRZzCSwYSvONldFpQ2FJQewKMHKtsZUuQVWAqEjUQXZCaOZJf4g5s5CYMdMk4n1
	DmTnYT4U2OELQbJzey4hPPdK+PLzPF58=
X-Received: by 2002:a05:6402:a592:10b0:6ba:668c:ad92 with SMTP id
 4fb4d7f45d1cf-6ba668cb3e0mr6721321a12.21.1795573146069; Tue, 24 Nov 2026
 18:19:06 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124230746.850528-1-shaopei_1012@163.com>
In-Reply-To: <20261124230746.850528-1-shaopei_1012@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 25 Nov 2026 11:18:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_ap120uprmarov-GuO0fb1eXEgw-U8G08L1xRJ9bv18A@mail.gmail.com>
X-Gm-Features: Aa3M54phjn4LoQPu6VjS7F5RJeDya9zkDLhO5IKjGgnMkwG9AW2CqozN9PdyGC4
Message-ID: <CAKYAXd_ap120uprmarov-GuO0fb1eXEgw-U8G08L1xRJ9bv18A@mail.gmail.com>
Subject: Re: [PATCH v7] exfat: add EXFAT_IOC_COMBINE to append a file's
 clusters to another
To: Shaopei Zhu <shaopei_1012@163.com>
Cc: Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 8:08=E2=80=AFAM Shaopei Zhu <shaopei_1012@163.com> =
wrote:
>
> Cameras and dashcams recording to exFAT SD cards often write the video
> stream and auxiliary data (e.g. IMU samples) to separate files and merge
> them when recording stops.  Doing that with read()/write() or
> copy_file_range() copies all the data of the source, which takes time
> proportional to its size on such media, wears the flash and needs free
> space for a second copy.
Is there a specific device or product expected to use this feature, or
is it being added as a potentially useful capability without a
concrete use case? If there is a target device or workflow, could you
share some details?

>
> Filesystems supporting reflink can already avoid the copy by cloning
> the source to the end of the destination with FICLONERANGE and then
> unlinking it.  exFAT cannot share clusters between files, so it needs
> an operation that moves them instead.  Its semantics follow from the
> exFAT on-disk format (cluster granularity, a single valid_size per
> file), so it is added as an exfat ioctl rather than a VFS interface;
> fallocate() does not fit either, as it only takes a single file.
>
> Add an ioctl that moves the cluster chain of a source file to the end
> of a destination file and then unlinks the source, so that only
> metadata changes: the FAT, the stream extension entry of the
> destination and the entry set of the source:
I suggest changing EXFAT_IOC_COMBINE to transfer only the source=E2=80=99s
cluster chain to the destination, leaving the source linked as an
empty file. Userspace can unlink it afterward if desired.

Thanks for the patch.
