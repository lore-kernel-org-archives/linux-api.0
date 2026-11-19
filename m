Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795107871;
	b=Kphxa3vAnpcYOpHvw2rnYJ243YaMuQr5HKxNChiVbq8Ehsdf/Y1VES02QjtJEuQ0WNGV
	 bFn0BIiuZLT0ieXGcOP13BbCgUd5oTIwaSeXl5oxJa2xtII+1ok2M6uniISy0D42XypGE
	 lHIxzafPyu09ejXzdsgPYVh9wOffwiHtVW7M9cUqQs6xrdHAZHqr6SpQKV1Q9AQ7ikkqW
	 pPLlE7PZexb7B1lOoMIaU5/HHj+nAbg+HkHLNckUNGNvYMryDPUhEKQZShV1JaCaMI+h1
	 Nx+aHjz9vrlyUxPNwhSSRcrdKwDanMSb4UytSVzBLM2CCE8obJkhRiu4IJwyXZVmpEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107871;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
	b=WaWia7WqGIMCoEmEetN2Qox1qI9sOztcUuYTb9Cva/IMeXObyfoyWBuLEY8am0k7UEZF
	 YVMbclxPZJtBfOhvz738Db1lJpFKtyThwNhvSuQHHbesPDVKPipbzR+7O/wA7pM3WM9OG
	 Hz3awslBqmT3SP7PXcIPHfRVQjLpe8DxcrKGgrJrwOevkAjFS1moL8zrC4wlbe2vck4P6
	 TEWAvhKhWghyg19KCNsWMx6cahw3uao4Xv0HU1ImE8780kt5W9srx3OLYYZY1iGG977Yr
	 rk9sqnBdyzUcgh9/OGVrLktqePbMf4+J3Oac5eXYguLi9MvM2NS/zI28CHGPBJvE6+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s5zc6etq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5213E606A339
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5213E606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s5zc6etq
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6ba12b00c76so1154298a12.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 09:04:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795107869; cv=none;
        d=google.com; s=arc-20260327;
        b=NcZDAieclVyiWYhroSdOKtEPab4BWfCDjuTxSQvSixbmcnjzRoJVAL+qRk0KAtAgs1
         WKjEci0TQJo4kdDkbc9o0dpenKvYum62ZY3evoOj9d5vaZ0rWpCMzxm0Gk9+ZYZ1yuKT
         xGkUhfA8oAUsDJlSrMSqetmt/e9mPR0vhjJr3iM+uo66PZAUOzc6ai/4+OafPGKFn5Rq
         xaImCXL1Cw4xHStHKw1LviDI7YC/aImhGlJDhC9AIoYSf/5e4eWj6HoHLPYGAz+edPVR
         m+F7HK4Wm4aPa7GVjBDt77iBbwALQsbI37Ednu1D1IRJXXk8PjrqGfNuYbzeR7dvJ7Xc
         T1vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        fh=IurH4ZUt1UW3q7RRiNUQYHJ9E5pmu3pkJxfJ3bzLJ68=;
        b=R5bJFucAEWnrDJ8vp+hw60hMGGRynzyVPCU5BvaFvQDVPMLqktX+BnF8N31crzooHZ
         rpfdTpgBVg3ua0q77FdrxuC42FTvnbmPA4sdYUeXPgR0olEXFVV7rFv0mRodoBHbOwfn
         qcYDjpB8fHvC+OBMb1uvi20w07CFwy1htvPmvjHHZGDK11m0Ga7RGP5rL/fC98Fzw458
         DEAfoI2ODMoOV4/A4sRrLmTAQmXSRQom1a+t3wAGT60HyBQUfk1TuvmPBtRHmJRUxsKu
         /5WusxL8kKOCXuLW3LkAr+Cm8U7/yxibhPRR7/c0F8oHUh3y7vvwjTE/kC6/AYaIuzEZ
         i7Vw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795107869; x=1795712669; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        b=s5zc6etqP3GKrfiHHgIM6qRwBj4GIrrYXAc6mNtEDxVzqmttJaHCzBqV1dtIN+vio3
         Bnt6ZD+22BFWnuCnU8EfLslCEzR54XnIaMRCfU4Wp6aReVvOjg7SSEeZ++TPablfbh0l
         nWScX+/5rkWM/Hp/yZ+hSStf6OX4OY+2MyRjQ6hvynNEq3yrt2g+oozsb2uIIRwN9Z0y
         kqeQwucwtBml5gJuvt9l9W1sgy2+Q505qHa2NQnc54/JOh7uClHStUwVlxpUu36xurI8
         7fgIaULXH+3INvDRKkck+rkIPO9DQA/oiLHBMSnEoMnziJpuqf6MgQUtU78WnH6opbGH
         aXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107869; x=1795712669;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        b=xjIqrNx/YzZhdc8Becu655VzWP0Z6pTRW93vgQ8LBd4C1IkMYVByjB6NqU8ug+YZnY
         mG7gQNLitl146jGRPOm9z+pqB0kB44G9UJoynaqICTs+itT4Up+hP+3edGOFQ0ZiA9h2
         C9zJefGTaaAljuWJYksGRPfhku6tZr3znFpTzg5owOu87Uf0pEYaspPpgkR68Rk+VdJI
         otRwINQ5eYFkQwfIh8jwWFFRCN6LBpb3ODzDzV0F6vMRXtvpBG2tBK+Y89FmJFdelQpM
         3a8SXsOCzNsxZvY3I+pihNoKDqX00tbdyoY3BAG12s5iNRnNXwsPz8AvZ36S/g9vlPNK
         gxtQ==
X-Forwarded-Encrypted: i=1; AL+hErFIbUY4Se3zq5aQNhaiQm4cNVWO/NeZpcey/NxFj1X0NIjUSVcuzkuKqzIId9KRGTVwgdbMZP8iuPU=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Ahh+t+Te1YdDQYchE+QKTsAieiO6ZT9V1fYP0bGklTNiXuseu
	An1dl6cD+XilvVfkJjOasdDwX+5oh5lUpxLe0P+EsybYtSRxl2FaXtmxkmQpPRz65CXNIH7eCT1
	lN9KiXQZeYD56sGsVpSVheQ8lkf9EE8g=
X-Gm-Gg: AYBFou3lNkIT7naaEvgq8m3ph+UCvslqV+puLqdiOpXVD+wPvnAyfgf5R0xc1t3AZ/k
	SyuYXRM2JNZ23SpNgtuPpgOG6edoIH8P938a3tOuuce+F8bhXh01i3/KvZRQgjwKtQUTKRrPSMz
	0WtyE/4EvWuwh0s6fOC6CrCNbOG/cWUZTkk1OwpBjdG8GPYL52uMKvqBI+e2cxRgRlYr1GULi/J
	X4Uu2ufNSv5/Zu4h297qFPLoY33bjKXHoVZCeCBDaAcUD2cpQuYk9FBRhykqma3lfosxkThWdlW
	nI0vcG2V56JRlQw2qv0xuvK50Vbb94Svhy6H63077hDgXqpEBXMV6iOshZKLtP8JO0F9Csf4ORV
	JFfaHDn0jTKDWbphXfr5xsoDEXPdhHehCCAt5xIIMI/5cTpnA0yNWFl/6ElKeUi4ECpQDyb8=
X-Received: by 2002:a05:6402:15cb:b0:6b7:b872:27a0 with SMTP id
 4fb4d7f45d1cf-6b887e9b3a2mr4758592a12.21.1795107868285; Thu, 19 Nov 2026
 09:04:28 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <av4Hn9u80fs8iHZ6@dread> <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
In-Reply-To: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 18:04:14 +0100
X-Gm-Features: AclHuK_v3fdGGegcviRdfo5LNeBocqyxiM32rnjQTLwAQD9spb3t-0FSAl1IioM
Message-ID: <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 12:00=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Thu Nov 19, 2026 at 10:59 AM CET, Lauri Gates wrote:
> > On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> >> I really don't care if it is exposed by statx or file_attr; checking
> >> the flag through either interface will be orders of magnitude faster
> >> than using FIEMAP to iterate extents on every file to find shared
> >> extents. My concern with statx is coherency - it runs completely
> >> unlocked and so can race with operations that add/remove the reflink
> >> flag...
> >
> > Thanks, Dave and Christian. Given Christian's preference and the
> > coherency point, I'll write the RFC against file_attr, once the
> > question at the end is settled. xfs_fileattr_get() already reads the
> > flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
> > work. The answer can still go stale right after the call, as with any
> > stat result: a clone that lands after the read is missed, just as one
> > that lands after FIEMAP returns is missed today.
> >
> > As I suggested on the 6th, the flag would take the inverted meaning,
> > so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
> > ("no extents shared with another file"), read-only, in
> > FS_XFLAG_RDONLY_MASK next to the case-folding flags.
>
> Hello, I don't have any say in the FIEMAP issue, but I wanted to let you
> know that, since also a mask was mentioned and your patch would be
> touching the fileattr API, there is work going[1] on for adding a
> fsx_xflags_mask that filesystem use[2][3] to advertise supported flags (o=
n
> get, like stx_attributes_mask) and users use to say what they want to
> change (on set).
> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> change, but I thought it was worth pointing out, especially because this
> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
> to have a way to include both legacy and newly added xflags, so
> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).
>
> > Christian, one question on the shape within file_attr: would you take
> > the inverted flag, or would you rather keep a plain "may share" flag
> > and add a mask to struct file_attr that says which xflags the
> > filesystem reports?
>
> And if Christian chooses the mask approach, then my patch[4] becomes
> relevant.
> (in [4] I put the patch that will be sent in v5 of [1], since in [1]
> it's merged with the ptime change)
>
> (For Amir who I just CC'd, [5] is the main link for this thread)

Thanks for the CC and the link

>
> Thanks,
> koraynilay
>
> [1]: https://lore.kernel.org/all/20261115180343.576773-1-koray.fra@gmail.=
com/T/#u
> [2]: https://lore.kernel.org/all/CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3p=
rytW36j1LgA@mail.gmail.com/
> [3]: https://lore.kernel.org/all/CAOQ4uxiuJ=3DeZu28FZAUz3rpqPKqCimPxJucOn=
YYuBowvD09_Cw@mail.gmail.com/
> [5]: https://lore.kernel.org/linux-xfs/20261102193533.93690-1-lauri.gates=
@gmail.com/T/#u
>
> [4]:
> commit 0efe0de3b5cc2b767aa6e2bb9174eb05b0d818f1
> Author: koraynilay <koray.fra@gmail.com>
> Date:   Tue Nov 17 14:57:47 2026 +0100
>
>     vfs: add xflags mask to file_attr API
>
>     Add fa_xflags_mask to struct file_attr and equivalent fsx_xflags_mask
>     to struct file_kattr.
>
>     This lets filesystems advertise their support for specific xflags and
>     users specify only what they want to change, behaving like
>     statx.stx_attributes_mask:
>     - on GET (file_getattr): each filesystem fills the mask according to
>       its supported xflags, e.g. FS_XFLAG_COWEXTSIZE or FS_XFLAG_EXTSIZE,
>       and provides the values in the corresponding struct fields;
>     - on SET (file_setattr): userspace fills the mask according to which
>       xflags it wants to change, VFS validates this and preserves xflags
>       that were not specified in the mask;
>     - if xflags_mask =3D=3D 0, use legacy full-struct replacement to keep
>       compatibility with older programs.
>
>     Furthermore, add the missing FS_XFLAG_PROJID flag, to allow userspace=
 to
>     set the projid using file_[sg]etattr().

Correction. usersapce can already set projid using file_[sg]etattr().
With FS_XFLAG_PROJID in fsx_xflags_mask, chattr -p <projid>
could set the projid without having to read and set all the other xflags.

>
>     Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accept=
ing
>     FS_XFLAG_PROJID, add an FS_FILE_ATTR_XFLAGS_MASK to support new xflag=
s
>     and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
>     validate that the xflags passed in fa_xflags and fa_xflags_mask field=
s
>     are valid.
>
>     Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
>     Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c           | 46 ++++++++++++++++++++++++++++++++++++++++++=
----
>  include/linux/fileattr.h |  5 +++++
>  include/uapi/linux/fs.h  |  3 +++
>  3 files changed, 50 insertions(+), 4 deletions(-)
>
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 833e03810b24..56ea65f790f1 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -102,10 +102,18 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>                                   struct file_attr *fattr)
>  {
> -       __u32 mask =3D FS_XFLAGS_MASK;
> +       /*
> +        * fsx_xflags_mask contains only flags added after the
> +        * file_[gs]etattr() API, so we need to tell userspace the filesy=
stem
> +        * actually supports all legacy (FS_XFLAGS_MASK and FS_XFLAG_PROJ=
ID,
> +        * which lacked its own bit) and new advertised flags.
> +        */
> +       __u32 mask =3D (FS_XFLAGS_MASK | FS_XFLAG_PROJID | fa->fsx_xflags=
_mask) &
> +                    FS_FILE_ATTR_XFLAGS_MASK;

This is not exactly how I envisioned exporting fa_xflags_mask.

fa_xflags_mask =3D=3D 0 means old kernel or unmodified fs.

For a new kernel with fs that supports flags other than
FS_XFLAGS_MASK it's the fs responsibility to advertise its supported
flags.

Something like:

     __u32 mask =3D (fa->fsx_xflags_mask ?: FS_XFLAGS_MASK) &
                              FS_FILE_ATTR_XFLAGS_MASK;

     memset(fattr, 0, sizeof(struct file_attr));
     fattr->fa_xflags =3D fa->fsx_xflags & mask;
     fattr->fa_xflags_mask =3D fa->fsx_xflags_mask ? mask : 0;

Then you can add filesystems that support get/set of new
attributes without support for legacy attributes.

And specific filesytems could opt-into the set of an individual
attribute like projid by advertising
fa->fsx_xflags_mask =3D FS_XFLAGS_MASK | FS_XFLAG_PROJID
or a subset thereof.

And I am still on the fence wrt should API also advertise the
fsx_xflags_ro_mask in addition to the supported mask.

The advantage being that it makes the interface symmetric.
User can alway setattr() with the buffer they got from getattr()
and instead of randomly ignoring flags in set, the fsx_ro_mask
along with fsx_mask defines the behavior exactly.

Thanks,
Amir.
