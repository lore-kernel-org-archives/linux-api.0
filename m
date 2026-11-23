Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795447798;
	b=RM/LPRQsnYbCxh+A/BaUVcU3T1CZupxecAAEv8KJr3uKSZejHTGQdxKlrEvctzm9+vjD
	 dKT4IZASc8VOJJsrdOlaQmpjjdTiWDPZTd0QtVDTiiLAjUKsVzMutqIIyDf5C4QiQtore
	 5tzf119fDqshQwmgQfV6e3tG7Rtiz4EOlFem1NGngYOLiacNlc420OJWi3GM3akqN7ptH
	 WxiPmgl8JhgMl6Z27dzczkyQ5cD17zOghHBF/62PRIuaGi9m3z6b6UoFtZUAJaNQM26uW
	 fNreU+19LUCHdaADCPDx/GhUiNrk25vpknJDBB7OrGNrytczOGtPWDElmNUyJPJchvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447798;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
	b=5ZLsMHtxsj5HAI6QQ84tMwxTInH+BlR2Z73IWCmbqGSGuocttZ1XMJUg/fPUrD6L/IP4
	 PnW2mmj2D0v/snrvRX2AdS/sqhAZTXwjxH+hKQJvtJMxQtmP9u09sOzFhoPAgdl7GVnrS
	 h5TlV2ritlej2Hto7a5giO4LVVUuIUddkXcOKbdl+dVMtTuyOzPRguHrrngMJ5hCB74l/
	 LPfpKb/u/QtUt9zZmgexnVO7RyrB0NW5ZeYnD7kgTq/cdItGCOOXDWuR9/SJHGLAfvO9G
	 3bO/GA2TsUDZ7g86BuxvSY2jEtdcKXe0dH/kaLRDN3f/9HhN4qQxy1z/YbfSrZUJYEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U3UavhO0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51121606A327
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 15:29:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51121606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U3UavhO0
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b8784a3284so4984648a12.1
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 07:29:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795447797; cv=none;
        d=google.com; s=arc-20260327;
        b=aPAqZfGOVAFy/9QdTqUBHJL3hreoY2URKyx6vUtIMMkZbDJO1MDXc49fS1N8ULJKXv
         3qiFDMFdZH7c0aiGpZ1vdr/ViMh93hbjRPL/LXc0ssnD/Z3v2h0Vs5MnYJLV+r8sUKT/
         3nFrN3hseTOItfxl1Hv8Wbemtno4phGo5/lMIF8cgbNb4HA8UgdSYc5xWfO0lSvspMQF
         rnG/AXvc2xcVhB5EvTOJ9YLSFY0fuZ9CZVG39c6Pg5/7uXOjBWoBEiea/X4hE7vW+5lo
         RjGrmky5WX8fWkcqS42sL5JfgqzoST+86gmf+mrMWz5L5WZyERKsK0fH20jQagi9Yfl/
         2OmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        fh=c/TmjDvAAuAc6oN+XkjtPwRMpbMK/AQSistnh7uAYgE=;
        b=WqM8556+qEut7oZYtXI+j9bhP9kvyyHLssOxVS1E6EbetIWWcilg5x9WEDrejMqy41
         fPiHxYkJc28OU2WncpIZ78A+iibf4WJA5h1hBcVU8VFfL/ioce59B89Ff5fZ0mUtMeYv
         jfbp2Egz+WcYmcXHPBxj5qxhzoLob8HWdGOogZwsc9dF9cLjb0jj9lPx16Ws2JzqDu65
         SVR0hBnGqhIvz/guHk6BmIz1TcL/2TP72RIw2wQvaEUEl8e7Mto2SJqOPyETgYv2ixmu
         6+KV5AEPzOEKQ7WxAdEJknql4JME+uakll4o3kFZ0FflaP/i10NogirEIhqlwsQoC4VT
         UfdQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795447797; x=1796052597; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        b=U3UavhO0vHfet44jf/aYXoS79W6o76/gvGmauPo8EJm4ak5yEu10LKFJc+bYM6DlNU
         dCfYYbZo4XhCpeXp62rA0WhWPdxwGSBPkk4yinisKQ/3HfliRazobfQ9a7wzP5P/SNIj
         eY6Fkypy+Iu144S/pfklmW+0egIWItbVB08gm8qw5tnR8zDbFxxrzY0hnU6BZ3IwGmbE
         LsikLplsus57/TtIIXYJNnBuJ+PJ0Bp+wTkqaQckcSlNsFqJe0wHdq3V547JgL9TtAhO
         QOlSChEk/jL5J2GuElsY4mHz8m3/NfdWUNuOhXFy5X6AjFyJdiPpdHYlxE7EGBx26kpc
         vI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447797; x=1796052597;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        b=StI/3B1yMyN07SldOOg0svRd4ltiaBZvwjZVrqrgWfKAIoj4Q31TEVQe5BIgZrJBbU
         C/EmPY7l/5q1Ldk2kbhPpVP4vM+uSFYcfzSoUvmUjx7AIm4aJP0E0sI9MWnvRpLA6nvm
         bZQIqunll4F3BGOXfh9S/qPXl4iolkcekhTA1OFmuE4XtdH0zKLWR/EDU9SDIiI9+l6f
         KNEReZJ++e2JP6tUa90+Fwn+I0tYh7hR2N1WWgJluwWynR20DaEBciyJWLhRTm5WNaDa
         AYO6LHCrWViNcOi4PBA0x9RQP90XUa0TLNkkcpyFparC9r2TSYkMf/pwTX3WZxPH0seO
         hjZg==
X-Forwarded-Encrypted: i=1; AL+hErGY4A4Vwrnz4worTTwEeeUpq2rleY36y1KjnmhxOmjz59d9CQVvQf0oaNxKFkPiMn9yN7nSmnbYGxg=@vger.kernel.org
X-Gm-Message-State: APuU4Z/m+8JKasvh2pJTWFVf9iHMEn2kxRbi/PZNHJay1ARBTp9G0sYu
	0stqbUBN3FaWZqyQBGG7O707JNd5PxBQOJxr1jRb0tgSUaT0HESuv0RTikKhmZlRgtAIK0E9xJA
	/ErkojQUuxyhz71MvMXth7yhBWDRx/AQ=
X-Gm-Gg: AZFdTZevyWV1K3ZXn7qzNJK9WutPRKLZ/V3tl3TxuEVd2lI69fcXQ4SaJVo5vj/545K
	sW2IJ8Yt2jCO65au7Lpl5Yn+B4lS7cSS6d6L8zEzBD+0DgZhcbbquuTupnFvDuuTTpsYolE8idF
	qzpcdwXiPS8W2oI3BQNbGl47cK+OLhN5jswjjdrSqy3i09LDRjS3dimZeuIZI+Gwtm1mvbK65x8
	6y/iHVefmqJGoGLJHwhyWm1h3hS1WwnHLlQ34W3f0IvxfQxuy2rjPi/rtrgLvVzDz/l0L2PkcWg
	WjCSQmlIC3ebvcXGLMXw+IICwom/llxhPYRE9U3jZRhrVM/lMPSGZC2LOP6XA1FZ8ucVYflcGVw
	Dx3XNNpB6gYAq21wC0bpbOTNwj5pQLT0Y/aIjHeB4hr6apLpT3ezBp/OSlJAiHW5YrzK00Q==
X-Received: by 2002:a05:6402:e05:b0:6b4:9919:b54 with SMTP id
 4fb4d7f45d1cf-6ba37f04a34mr8166206a12.42.1795447796335; Mon, 23 Nov 2026
 07:29:56 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-3-koray.fra@gmail.com>
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com> <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
In-Reply-To: <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 16:29:44 +0100
X-Gm-Features: Aa3M54rXlfF1ti3csfwg-SOdn_z3DGpZ_P359TQjfteI3PWichkZOxWgdTC23l0
Message-ID: <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>
Subject: Re: [PATCH 2/3] vfs: add xflags mask to fileattr API
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

On Mon, Nov 23, 2026 at 2:58=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 2:24 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr and
> >> equivalent masks to struct file_kattr.
> >>
> >> Also add has_masks selector to struct file_kattr so we can know when a
> >> user of this API (userspace or filesystem) supports them.
> >>
> >> This lets filesystems advertise their support for specific xflags, lik=
e
> >> statx.stx_attributes_mask does, and userspace can specify only which
> >> xflags it wants to change without needing a RMW cycle:
> >> - on GET: each filesystem that wants to support this new API fills the
> >>   masks according to its supported and read-only xflags, then:
> >>   * for boolean xflags: it fills fsx_xflags with the current on-disk v=
alue
> >>   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
> >>     xflag value in the struct field;
> >> - on SET: userspace fills the rw_mask with the bits of the xflags it
> >>   wants to change, then:
> >>   * for boolean xflags: it provides the xflag value as a bit in fa_xfl=
ags
> >>   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
> >>     provides the value in the struct field; if the xflag bit is set to=
 0
> >>     instead, this informs the kernel to unset/clear that value.
> >>
> >> Since fa_xflags_rw_mask means "I want to change the xflags specified i=
n
> >> here", if userspace specifies fa_xflags_rw_mask =3D 0, only check for
> >> permissions and fileattr support without checking any xflags.
> >>
> >> Behaviour of older programs that already use file_[gs]etattr() is
> >> preserved by checking against FILE_ATTR_SIZE_VER*.
> >>
> >> Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to set
> >> the projid using file_[gs]etattr() by leveraging the new masks.
> >>
> >> Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accepti=
ng
> >> FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xflags
> >> and use it to validate/clamp both the _xflags fields and the masks.
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
...
> >>         err =3D fileattr_set_prepare(inode, &old_ma, fa);
> >> @@ -424,6 +504,14 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const cha=
r __user *, filename,
> >>                 return error;
> >>
> >>         fileattr_to_file_attr(&fa, &fattr);
> >> +       /*
> >> +        * Remove xflags added in or after VER1 so userspace programs =
compiled
> >> +        * against VER0 don't try to write xflags they don't know abou=
t (since
> >> +        * they do RMW).
> >> +        */
> >> +       if (usize < FILE_ATTR_SIZE_VER1)
> >> +               fattr.fa_xflags &=3D FS_XFLAGS_MASK;
> >> +
> >
> > This looks odd.
> > old struct size with new flags should be -EINVAL not silently drop them
>
> Right, and the GET path should strip any new flags, so old programs
> doing RMW will never see them, correct?
>

Yes, I think so.

> >
> >>         error =3D copy_struct_to_user(ufattr, usize, &fattr,
> >>                                     sizeof(struct file_attr), NULL);
> >>
> >> @@ -460,10 +548,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const cha=
r __user *, filename,
> >>         if (error)
> >>                 return error;
> >>
> >> -       error =3D file_attr_to_fileattr(&fattr, &fa);
> >> -       if (error)
> >> -               return error;
> >> -
> >>         CLASS(filename_maybe_null, name)(filename, at_flags);
> >>         if (!name && dfd >=3D 0) {
> >>                 CLASS(fd, f)(dfd);
> >> @@ -479,6 +563,30 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const cha=
r __user *, filename,
> >>                         return error;
> >>         }
> >>
> >> +       /*
> >> +        * Userspace said "I don't want to change any flag", so be it =
I guess.
> >> +        * Still check for fileattr support and permissions, also in c=
ase this
> >> +        * is just a probe.
> >> +        */
> >> +       if (usize >=3D FILE_ATTR_SIZE_VER1 && fattr.fa_xflags_rw_mask =
=3D=3D 0) {
> >> +               struct inode *inode =3D d_inode(filepath.dentry);
> >
> >
> > No No this is not what this userspace said!
> >
> > This user space is the same old chattr programs recompiled with a new
> > fs.h header file
> > installed.
>
> Oh, right, I did not think about this case, I hope it doesn't break too
> much of the new code I changed already for v2 :(
>
> > When userspace does not set anything is masks it means "old API"
>
> And so a modern program using masks that passes rw_mask as 0 should be
> also interpreted as "old API", even if it kinda goes against the
> definition of rw_mask right?

Yes, but it is not a problem to describe this backward compat exception:
When (rw_mask | ro_mask) =3D=3D 0, it means "no mask" "set everything"
but then vfs will not accept new xflags that were not supported in v0
syscall.

> And other than VER there is no way to know if it's a SETFLAGS compiled
> against modern fs.h or fileattr VER1 explicitly setting rw_mask to 0,
> right?
>

SETFLAGS with explicit 0 rw_mask is not useful and does not make
sense, so there is no reason to support this in any other meaning than
legacy programs.

Thanks,
Amir.
