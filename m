Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793631257;
	b=HlOflu6A7ETg+uZ22bBIX/EO5CM69ORVIpLae0OO+nMz4NGt6iG8O4ZMiHEQ2osZGak3
	 yPpu1ApMUML/kPU/ldqYg8zB1uOKmECVhaGiDs76dG6FtowJf2zXpvnpQxm3q3uY40kSK
	 abh9IeMs+XoUdyuhf+cOpRMD4HaVs5OeShroHEiorA2z50CVgxxrsWcx0QKDks9jF5KGB
	 76xouJk5TKSFYtZmv45iEo2U5tHBa6zeIGcIGzZgI2wgin7r8vUzZrRzy+POSHD00LoCm
	 izYDd2H6g5NsNw9RB/Vk0UTirD1eJPNYJVXO5C76/3Muw2Jdr0/WY0WsLJjK6GeuCbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631257;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9S45ohuGWD9KQ2+FLxafTobKS8uDh2Gv9DIfHDLQSno=;
	b=mjAu7KFPOmbyHUmarwIZcTszJUnmPC96AVrzP0bG/539QUMdnKizc1rpNwxnG6ntfqfb
	 2vXEnyAsb2EIdYy22DemARiIE8wAAlfIFle7v5kkeJdkqXp0mW4+5h+9KG9g8HnweClUv
	 V+QDuuTGbzVsoAyufq1wrhcyvP9FCK1/uRyin58j3lLwS1ffZkbVWJgdgrAHRdWXeK/Gy
	 vzj2tsWzPshbLhKXd1R+AFviqCm6djDwGnhIU6xMX2YtPL0aFmzUf+siWwJ8B3YMY5zW2
	 SaBMzLYtUY4F7iKoRd+Op0IeDR44HSwG87CXtMRQh8N3BhRH9UcIKVdngQB8q41rVKw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ytXtI9ur;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A16607A8A0
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 14:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99A16607A8A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ytXtI9ur
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c445c95d553so417987966b.1
        for <linux-api@vger.kernel.org>; Mon, 02 Nov 2026 06:54:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793631255; cv=none;
        d=google.com; s=arc-20260327;
        b=Li5MmlYMX98ywka8/FXP8GvO76+8kMVm0/8zcBRSfsgAEcL2vvq465ZuDvfuwvZHrE
         GHPKgX9zzazQqbPPH/gx+gmAkVzJk/KsbIbtLzv2jVmJcG6huo6HKyWprjOQVuVQiuoF
         5g2xT/wuO2KMQym46QQIyZlxGS0QslJy/DL8/mWGlkI4Yc5mlw1tmt3ZEspnUQIMS3yg
         /lbwGXXoZ5p3uferiKS2UvlwZBcdC2UlPSElATto8NeLJjM4w+PNa53J8F4QI1kfwbqV
         XG1bSf4tsttgiBf5yr8sd6G5QRYXZjlIiP6RyVzdv5ASbeT3OFPSxhCGlwTazM/Pv3Wi
         V9Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9S45ohuGWD9KQ2+FLxafTobKS8uDh2Gv9DIfHDLQSno=;
        fh=1QlGlPKKKWjiT9w/7lkAkiEE6ABZGpuIuu6FmrLiaGU=;
        b=dnKR9ze0zh4WN+j9Q2nj0m/fu/KrEcn1Zpe6F7OtbOnUHU1bTDtjzx3lsn2qkv/8Tt
         jwlKIwaTWUafvaZW6dyFnNK8tOF0boQaTX5Tut2N01nOO0RGZTiQUgjKN4uX7AeIDqZi
         CusHNew2fVgRA5XKaj28ZvFblUUWdnr2zpGgY3DYdpMGC08+Ns7XQwojpjUj9qxo0Ezg
         7viAe8X9S6e4AhLIshyHv++WnNOqwje3OuS+Uf6WKlk7ZwmqzXGG2Vi6YA5NOBy/MLHw
         4fUtZyV0aVO5MG785w0kneqrHTkJs3TTjsonpJaCyUHk5M/J2jbmSCkNFFr5TSP31/0M
         Zu/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793631255; x=1794236055; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9S45ohuGWD9KQ2+FLxafTobKS8uDh2Gv9DIfHDLQSno=;
        b=ytXtI9urkBOvMSxNBLZNENQibMB/0gzzBc5DiEZfC6ZXmrvapm+egYYm9kWonaIvc7
         gYzuqpT4m18qhZoQbQrZpb2T+++MNHRQx0q7J3FLCRnOAViXnbf2YyRwymv8LzrKU5ji
         c3hNN+VN0CxAfA3VukdFS8J253OYA/wQYb0p1qfHH4obnQV38SG/fN9Yf7nEhJGmztoi
         1mcZoYTLpkCI+nVXEmAumOVmkqWZlicJwK24ec8XXfAhmX08g++Txd1372FncrDXskXF
         /MXJugsAdWJ1HQWyCTfxIUTUGG1CvKf+kuV8FP63sJZFLKd5uBbCsQI0I5rMlCQAlggs
         AlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793631255; x=1794236055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9S45ohuGWD9KQ2+FLxafTobKS8uDh2Gv9DIfHDLQSno=;
        b=hvVDmjzP+2RnO/AstPMoJTzO6rknkWSWczm6bMii6b7dm9Olm+FwWVZ6v8cl4VT4Ka
         m25Mn0Ut9ubtclNvN8Y0a1Xp1hOYvM8CaBrDp5wxHpXkScFTEN6TLzJpC+uxqqujBH1X
         iCVLjZAdlPW/uRA74rMV2/3Qa+VNcPnuxJsyyNEgNO7GP4Wxop7e0R6VYLEAx7pqmhfF
         mIy7JvGIaFc/o+GyuoUEUTo7mmj9ilndHtKvuIONXH1+EvBbznrB9FZZkVcl6CSDh5aA
         G7pQRJEMpvbOmV1nINN1mXrf/yUfRIYnQ5+1p86dC19JjDQH+WqLT7I64krnUxzzg4Ku
         ZUvg==
X-Forwarded-Encrypted: i=1; AKwUvBzCa+YtcXgpAAlWE7qB/UL3XdYnOei8SQo+zyCUD5RRGPNcJaNwwCXyPpvHo/qiTmnEdqvJCvHtoB4=@vger.kernel.org
X-Gm-Message-State: APuU4Z87XynjOZs+aFxHxlD9H5uLi2HQ1VK/dMW7uM6msiPYocwURJZs
	Pqamq9iTy+CfadppqzD4QoMHok6E2eCLGMy2D7NQoG0pXZiRGNkch7PYEAXSq+wcVYnTRz6I2a0
	iLdVj51u91ToCUbhg8z725/4fphGvkeo=
X-Gm-Gg: AYBFou2uTyIEcEB8fV8oxUZF7tSpKuKbYwq/Es9t5hycHAbcuUCiUx2ct8jJy2WjJgQ
	aMR+f73/wIGgRyYntoBcrCuw5GvHr++GW0kxMjRIRLEHtQ0VXbSDzbEfWCUL4u/fFb+obLvHYoP
	FiExIkk2V6DdpHm7osfA/lr7me0rNfTtOn4i0uFrrwyHDibgGleMp1p2vOOlT92+jEu9qzWaZUM
	Wvc9Ynd3pZfohkqjHh/LdFhMoOcSiKgNAWQzGxkOzcwQk0YNOh45b4Rw3td+CS1CVjDkNhMklSy
	MFvOfJ0KaC7LDEFKZSunDqyQAB7jtYK7L+yt2L67aqo6iJscYo2Wr1CZf5h5HHuBRzirynLH7sY
	FxYXn+BHHxkfpU5XpnArj3HsKrYiw4dYk3Z53ThtCSwoJ9u3J54+BV4bHK+SnMN957Od1BB5lr0
	rlSJjKhtoEcx6qP5U=
X-Received: by 2002:a17:906:eec8:b0:c2e:317e:d711 with SMTP id
 a640c23a62f3a-c4ca7aac250mr889529566b.27.1793631254792; Mon, 02 Nov 2026
 06:54:14 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com>
In-Reply-To: <20261101015551.786044-1-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Nov 2026 15:54:03 +0100
X-Gm-Features: AclHuK8MPfC_dz5RbDokIFz7RFGIRe7sv4kFXfjOWYu6Sb9FQLskiRuGBNP5Y1c
Message-ID: <CAOQ4uxjkG=1j1z==Mv4wzkF042rXstodokKnBfMFBf2e-Eztmw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com> wro=
te:
>
> This is an initial implementation of a new timestamp to indicate the
> time when a file/directory was initially created.
>
> This patch series takes inspiration from the one by Sean Smith
> <defendthedisabled@gmail.com> [1], but using
> file_setattr()/file_getattr() as suggested by Darrick J. Wong
> <djwong@kernel.org> in [2].
>
> The semantics of this new timestamp should be at least these:
> - it should be the same as btime on a newly created file
> - it's user-settable, so it can be preserved for backups, filesystem
>   conversions, archives and any similar operation
> - it should be preserved every time mtime gets preserved
>
> and the correspondence with the other timestamps is as follows:
>
> ctime <-> btime
> mtime <-> ptime
>
> Examples:
> 1) a .zsh_history file created in 2019, then after a few years the user
>    decides to switch to another filesystem, copying the .zsh_history to
>    the new home, in that case btime would have the timestamp of the copy
>    and ptime would have the 2019 timestamp (just like mtime would have
>    been preserved)
> 2) a symlink created in 2020 from the home directory to a /path going
>    through the same process as the .zsh_history, in this case it would
>    also make sense to sync the ptime to the 2020 timestamp instead of
>    keeping only the btime (so the inode creation time).
>
> The proof-of-concept code (for testing) for stat(1) and cp(1) is
> available at https://github.com/koraynilay/coreutils (master branch)
> (Note: these coreutils code changes are a prototype and won't be
> submitted upstream as-is, but they work as expected in simple stat and
> cp -a/--preserve=3Dptime tests)
>
> Lastly, the name "provenance" and "ptime" are not final, I personally
> don't have a strong opinion on any name, but while testing with stat(1)
> I noticed that "Provenance" is definitely too long for the normal
> output, so another option which would fit well is "Origin time",
> abbreviated as "ntime" (OrigiN time) and not as "otime", as that would
> conflict with btrfs' internal naming and create confusion.

FWIW, I agree that given the existing uses of btime and crtime in the
kernel and various XXXprogs, using 'ptime' for kernel code is probably
the lesser evil.

The question of how to display this in stat and tool is a different questio=
n
that can be left to the userspace developers.

The UAPI headers uses Birth time language and stat displays:

Access: 2026-11-02 15:22:27.067329367 +0100
Modify: 2026-11-02 15:22:27.067329367 +0100
Change: 2026-11-02 15:22:27.067329367 +0100
 Birth: 2026-11-02 15:22:27.067329367 +0100

If the UAPI headers will use consistent language:

+       /* provenance (settable creation) time */

+       __s64 fa_ptime_sec;     /* provenance (settable creation) time
(seconds) */

I  think that the man pages could be unambiguous:

stat(1)
       %w     time of file birth (immutable), human-readable; - if unknown
       %W    time of file birth (immutable), seconds since Epoch; 0 if unkn=
own
       %p     time of file creation (mutable), human-readable; - if unknown
       %P     time of file creation (mutable), seconds since Epoch; 0 if un=
known

statx(2)
       stx_btime
              The file's (immutable) creation timestamp.
       stx_ptime
              The file's (mutable) creation timestamp.

And userspace tools could be displaying ptime as:

Access: 2026-11-02 15:22:27.067329367 +0100
Modify: 2026-11-02 15:22:27.067329367 +0100
Change: 2026-11-02 15:22:27.067329367 +0100
Create: 2026-11-02 15:22:27.067329367 +0100
 Birth: 2026-11-02 15:22:27.067329367 +0100

If they want to, without that being more confusing than Provenance.

>
> v2 changes:
> - fix permission bypass leading to ptime update on immutable and
>   append-only files (found by sashiko[3])
> - normalize ptime timestamp as done in fs/attr.c:notify_change() (found
>   by sashiko[3])
> - fix wording in vfs patch to be like the cover-letter
>
> v3 changes:
> - vfs: reject setting ptime with -EOPNOTSUPP on filesystems that do not
>   support it instead of silently ignoring it (found by sashiko[4])

Please see my review on patch 1/5 on exporting the supported mask
to userspace.

> - vfs: fix not being able to clear immutable and append-only on files
>   with ptime, and allow updating immutable/append-only atomically along
>   with ptime (found by sashiko[4])
> - btrfs: validate on-disk ptime nanoseconds and reset to otime if
>   invalid (found by sashiko[4])
> - btrfs: avoid re-assigning ptime on unrelated chattr calls (found by
>   sashiko[4])
> - add ntfs3 and exfat support as suggested by Amir Goldstein[5], but no
>   vfat, smb, or nfs4 yet as they are a bit more complex

Please explain what makes them more complex.
My concern is that I would like to see that the proposed API fits the exist=
ing
fs and we won't need to change the API again later to support them.

Thanks,
Amir.
