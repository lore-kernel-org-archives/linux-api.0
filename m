Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795438860;
	b=OwzE/T4C6gH86hFyjTkMjnSuNUkJPciWNCQpQcLD3HYDVm7VcKGfe4lsIuhzN1ate23D
	 C9Pb2AN/u3xTuudxPS2ebTnIyWu/cOIvQmM0THONwGFqEnCpRHfmADlEcWKCWfa/O1TGQ
	 nooQBeAjjGjvpK90UrFSY5W8ydX6kxRvKJNonEMHWbSZThvYsSL4cnF5mpxG20RecFpzf
	 QefbFHGzB9DJZX54TOnU0/Hc0mLj2uFX3qwi9XsJLweTrt8tKUm3CH7DSyia8zgVDd+hA
	 kCP/bXA2Sn0TS9pIZjHDqAbKl+GqfhRssuscxqj1SLFvSsIU0xyifrS6+eGJUs4lDgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795438860;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
	b=Kn/w8Qmp2/v+Ird+MUnXIkWFG72bVwuiL9Dg0tYuqZy0eRq8woDN+tJ1zbvnALCfGPm2
	 NOUWWHAIu3VxrMeeRam8yre1QysEXRUrsbFBW2PNXUZFPN4C1eMj77Z7U9LjSjzONEjht
	 U72n03ec+lmtD12nwCeH1g9AZ6hJpcWg9Aq8JsQv8/cnWuCVA8WPG5Sxe3vvmVBS9lXTi
	 xmgQVmtyOvUf4C61HTETk/RG0b3RRfXdsFZSpVS07P8u6Fyy4vXlm6ZE52FVWpORSFBTX
	 Pzuo7Ztth7eswhNRpjPKpudBSQqS+Mh6Fau0vMPmc4sQCgGbRd4y4wXJyK7XbVF0PpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kkson++k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163C6606A327
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 13:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 163C6606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kkson++k
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b8a52db5f9so3828190a12.3
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 05:00:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795438857; cv=none;
        d=google.com; s=arc-20260327;
        b=HJQMuUT8Ez5NApA6EUIBtzJpnCx7TK8/IQrGrQmY6AlGStU0sOCVgbjq7qxf/HNyXf
         5C8oOGX87zW9seMYDWqSjKEo4BIdPEkPxSKz/Y9bpF8L63E+094d6qDTP164Sq5L+U7X
         NThX1ejiALF8CqtRjole9sIVmkZTJhymBz3X2cmSnh9w7/kc6omVmPfOcWlYdWEQjr7k
         bvNXffALLpepOn2wB3DMDsTYlVoHA2RO4dtEwFWd6B+Tsofk1JqenD95mOLFhHl+T2jL
         sP/l6LIl864IUhrO3v7BFG5ami5zY8EFB9f3DMnCKp4y9SV9Vd8+AcfRzIOzKk/RM7qh
         ENRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        fh=FpUKZZidF5gnapH53s8AHtjQN1limDAxVP0mqT2un0c=;
        b=dWJu02LiGWTD5SJzTVUWf179ptesxqYxp5sllPrUG8+YAWZwnYeCEcSVhi3b7blREo
         xNh4JorkAE/2B+WTI1XFb4QxwfaA+S36EafTMf5KN/opYcWPzeUDd7DRqbyFAtS9Lcuk
         IgkRZgs+mLXmgXlieqkAqolMXvzDAyJogSXDrj4+7n9Szlpj5V89QOzf17U0gHvP9PR1
         d7TftxtlLWXQkvAVX0Kz6ju1WzWNO0Yppz0Tkgbjdu9fd44PQ8OfI6pgMToenCp1sxDz
         JZ0h79fwGcv7rbALP89wD9HY5NGb8L2fiSxJ7TNFi33hJfCMlc/A1QKKqPJX+8GmeKJd
         rV7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795438857; x=1796043657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        b=kkson++kiVuuq7GlVJEDUrQHu19KcH/nihH2BzgLa6gbrvy17AZmxY1D1w0dt2h46y
         /xXI9YCF3W8v6AnWEDT8Xid0rKVtto9xbQeFZkRGR+cb5Y8RIC0oMxupLBYaYJC4CQou
         6ZJgLzs7wocf6G/7L1QJdpNwS2lbDAistHwZiRuhKs46qZQI5UTzUa+r+vixCZl4Sxxv
         NpVQv5tq4rxjVYt/Ok4zCR0OsxODa6kreqGz8wEkn4nw5GUASkqE6hP4ExSDLRPowFf2
         0zimep72RFU7EbpYHdPGxIgrdpvUiN+7UnUUrPJ6dRIQHj227oDE5EmUxVXBkiebQasL
         M4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795438857; x=1796043657;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        b=tkOq5kyGk+JCPro5d6XqTHGYP6nRNSEYil1iajOoozoEZuDyE9Gt3ACEAZ2M+nlmnQ
         iJoLliSRV1G3mlM2x9zyEf14a8XlaxMRPpQObrOde66vbQGxU2+lGmcPPHgujaDrJPVJ
         DxR1PYLQAyKouWh6+lFH5IYoc7aCeb07Zar2IM44QmID7jRW8+xTgEWms34tE0DcxErn
         OqMZpdYhtPoPUd+XoRUG9+wFq4zganlYMAi7OiHpjv5cPyhUBG9acdwM6Tv6Blmrg2Qz
         YYYG4c9urJ/VeTN4UQ8tphncqDo/CIYLXCEa+dgqqsixdEzBsO9AODiR4R0SyrK7qxBm
         uapA==
X-Forwarded-Encrypted: i=1; AL+hErHAY4yoltZm17JmFCXcmCUSbo3WLs6BMngx9ztzUPl0p5576FdQQyH4yBO7DVGlpMquYuv2jeL15ow=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Z+aTS286OxzmXGh4Zv7tKbBFHd2icA5huqqZQ0mbX2LaQRQuz
	dYjWGE14y0iH639C++VSHnKWLSljnwaNmgL549jvRjxncqLQ3+kq3Qf1E2wn026VChWaD1Rq2p4
	6pdMg6RrGlB5G3NXKPn2t8V3SvJBDXsQ=
X-Gm-Gg: AZFdTZcmCCPFg6Si0qGednEdkooZAXJdADXKRCzIDg2nlXgKLwHFH/N6+6BfmxLV4Dl
	Cb78XyshkdN4iZleWvl+J4KWjFRADKhTNaRWnEvHZ2ED5lnq9yW8fixUe3ULAzglW9h5FyxNKkj
	iPfgNQg9pEpyEKDgMVuKLKEp2XYg3Ed6be/Jp1ic0ptRgbnpcwH5LU/Lt3YLRMfBraO/GzTxrsK
	UCs/FS23ld65jrUG9qRwILLyWhZA8HfcgILqoxx1sKDrgt1RZv11NTslmTmC1maLXaAx4h7vKGq
	vXCFBePgXL8ch8bckh0oYsXr2eyAnrjG0mmG6kKTpvsefMafcISaElmbxE/Zw2y4vS2t7Pzkxg7
	D76zDMUkx5ZbdFNuZ06xMTnshpKto6OM01nQm75eLa9w4BcDDmTJ7HUIPXVl7FydKBOLwtg==
X-Received: by 2002:a05:6402:501d:b0:6ba:659c:8ca3 with SMTP id
 4fb4d7f45d1cf-6ba659c8fb1mr5474446a12.10.1795438857096; Mon, 23 Nov 2026
 05:00:57 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-4-koray.fra@gmail.com>
In-Reply-To: <20261122000856.536902-4-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 14:00:44 +0100
X-Gm-Features: Aa3M54oIZEz33KQbWl8M_WOYBLraeDplxcWm8_8Bl8KeH9NFv_L8S3OGX6_s9I0
Message-ID: <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> modern xflags (FS_XFLAG_*) fileattr API with masks.
>
> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL)
> to be used in this API switch.
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c           |  8 +++++
>  fs/ntfs/file.c           | 63 +++++++++++++++++++---------------------
>  include/linux/fileattr.h |  6 ++--
>  include/uapi/linux/fs.h  |  2 ++
>  4 files changed, 44 insertions(+), 35 deletions(-)
>
...

> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 50be49f4c913..fde6fb2fe39c 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -155,31 +155,37 @@ int ntfs_file_release(struct inode *vi, struct file=
 *filp)
>   * @dentry: dentry to report the flags of
>   * @fa: filled in with the flags of @dentry
>   */
> +#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | FS_XFLAG_CAS=
EFOLD)
> +#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
> +                       FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)

Nit: checkpatch may allow 100 chars, but this due formatting is not
easy on the eyes
pls break to RO line and indent the broken lines below (


> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 4faa40febf11..219e7c8eb601 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -7,12 +7,14 @@
>  #define FS_COMMON_FL \
>         (FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
>          FS_NODUMP_FL | FS_NOATIME_FL | FS_DAX_FL | \
> -        FS_PROJINHERIT_FL | FS_VERITY_FL)
> +        FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
> +        FS_ENCRYPT_FL)
>
>  #define FS_XFLAG_COMMON \
>         (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
>          FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
> -        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
> +        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
> +        FS_XFLAG_ENCRYPT)


Rule:

You cannot add a flag to common without carefully auditing all
filesystems that support the legacy flag.

FS_XFLAG_ENCRYPT can go into common but must also
go to FS_XFLAG_RDONLY_MASK because it's read-only for
all existing fs.

COMPR is rw for some fs and ro for others.
As with CASEFOLD, you cannot make it COMMON before
converting all casefold fs to new API so that each can say
whether it wants RO or RW.

I think there may be a way to deal with this easily since
ntfs doesn't need to set either but not sure.

>
>  /* Read-only inode flags */
>  #define FS_XFLAG_RDONLY_MASK \
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index e40806b3a69c..09fc7e066485 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -275,6 +275,8 @@ struct file_attr {
>  #define FS_XFLAG_CASENONPRESERVING 0x00080000  /* case not preserved */
>
>  #define FS_XFLAG_PROJID                0x00100000      /* project ID */
> +#define FS_XFLAG_COMPR         0x00200000      /* Compress file */
> +#define FS_XFLAG_ENCRYPT       0x00400000      /* Encrypted file */

This is a mistake of patch 1. the newline should remain above HASATTR
which is allocated from the end.


>  #define FS_XFLAG_HASATTR       0x80000000      /* no DIFLAG for this   *=
/
>
>  /* the read-only stuff doesn't really belong here, but any other place i=
s

Thanks,
Amir.
>
