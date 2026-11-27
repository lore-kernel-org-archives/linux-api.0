Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795780980;
	b=rH0WDZdK5HNwGdexO/7p1KdJZQZ42MW4yPR8XwK1F6b9nqp8qh6Jy6jHQIhmVcY0ooxG
	 s3jEX2IAo03ROLe03P+FEcgQTZ/ElrGSzBycYAjv/gQe/LMxx0gFnkUxIvB0LP1tTyJsY
	 RCYNqOGVob7Cw3kp07jufhMnf7nRr6FB7okW6AqY1N2LjD6VtNHGdDdZ/rSR1O27Om7k6
	 /NhOESSZki2TcZmLE7cP30P0SByDOODCzTzarduXDVGVgNH+9UDRteQRX7nTVmeSc38RH
	 nsnazqCz0YTLiXKDl/3tsng8pRH4L5ehK5LaJ8WgGChqRkpmbzL4eXCLLhfaLGBXDrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780980;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
	b=XbShwyvU+bOTiuQuJ1xPC6cL6hUUnPLrFzGM5I52iFALMrF9m/djXc712eDpF4aytzm9
	 MMOyrSNC0CK/eNpOWaN/zMPQIgwcAojsQsRS9grpx6vC5jwMCcdV+U6FqnaVFTHdVOPls
	 n9zM501AfyWGivnM0WoRhxNJj8ZRKqP5TXiRLU4mgN4ETnPM689MJWIkJmcLhfUImSr76
	 4gVIJYxbuUdRHZcZA4+r2mV9uACRP/934H6srVn2mFq4GKdogK9nkZIUkAgnqByzbfjDI
	 44wmIyXrDheMe7BInn9ZGPJLVY8vi99fymrUlvC5aETHAlbXUMhJUevpKqs6OOempjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SnFA07cx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.175
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC312606A324
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 12:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC312606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SnFA07cx
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3ab30b3212aso63562821fa.0
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 04:02:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795780978; cv=none;
        d=google.com; s=arc-20260327;
        b=AKJn0Kqn/az5lBLosXyZPq2U4yJM3Uq2E0bn9yaH/DiYEKa1RBn1E4Z3JzG1uHor23
         P7G0KddSmWGBvvXR3qQ6x/BTCSsH/DTgzlEBflgofPpTWPOq1TiF9AoKOmyBXHjBZWYq
         yMVWDlrqiUIlRSpYRWvbaHIVhxG9SVv41ax5GpcpXxcR3RE9i+oyR/b3SuZ/usOBI8gG
         BLqeTdRtlT5RJCunzIS5HVY9ddWT7csXjRlFH7i8e5GL1GPSDk4m791RAO77IwYhu2nx
         noFFgmnZnyhFRy/FYnifXRPjFNUs7Ln5pbInGyo26ahg7AS8JkGZOJBOK20fh+6SFo/0
         SgNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        fh=pklmMw6cmCxrhU9WbQ2bjctKhnoF4hfGRVvFk3hwBcY=;
        b=iUICNuHf8wwqR7FTLmIYO1yqWsrJhBCnIrCtcsbSQU8x1b59iI7MafnpMyqk3ZkTQv
         VO0Kjo+VYUQm+gnsPHmxwAXRj0x3JfX8BhypVPsmUAkelkP8X3qZ5G32zCiNfL/x89Bs
         9fzxjO/sNB0jHsQJwDACGZzR+Lh9lTGb1HCdPo0T0dhtatNq1vyqJ0C/mRHHPPDSiRaU
         h7RC1NRuC9JcDEkAhIWNGCFC7GSmCyGk9Ng3lCF7idjfIZx0RAUJqUJed36XaUaVEG+E
         mhmbEucMieu/WU0IkZYaFBR2Vsnj24ZJ8ZD/d4FuavD4HDNv3x/DEMkBjruEUJeo0Uzr
         hxpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780978; x=1796385778; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        b=SnFA07cxVyuwSSQ2WlqVldYscrENhFj8PVisFe6EUr/u+zjaGcOlyf+NO4/VeKXXX7
         4E5nqOC+Z3I662UCySIHIiaMwrjJK+ZjK9X5FK/V848T+A65ClvPxk5bvJvrsV+MWdo/
         JIM89r7vSI7FFB67/tWpYnfwZs9/cVksgSfXEE4llKDhqleU1ZWfSy+N4AE/zsZMEKkf
         FXtLBubySwAUA91pvO8XAdbubi6E7QFc7BDt/+z27xlpQGmIW0sbpzCnfaiUYkOVUtJK
         S6zwuiZQCA+1rzhAC+jCChTTNWgaEmMmc18deOG2Q+9ze1ubEHLrjAXDP7U1S018fipI
         jn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780978; x=1796385778;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        b=iSlKq4zFaX/nRPjVkeAUqTPR63HEn+ZT10BViPBkPvIpccjBTfI+P8vqYBo2LpP+jC
         u89BCN1yIUvvHfVdfXxW0YV/yPzwD6LnJF/ZZYXBjgAHhoP32yTkKPxMR8IoovcFpC5s
         zW05p1vuIYEfd4BOSD5SvD+e7GR2vIJ+0yzb1/WlfKKuBwrVi49b9xdUpVtnX/PqkQSk
         WOTJ1g2PIB9sBAe9DLEpoGSbOxJxOKlLLQf2+gj5pv2SrnUpGNhHx+dvSG/yP3XTSIQM
         AHLuOyPMtUytMs39biHlLljVEhR1u7gOKKSbPF0ybQM8ML4JJ6C0MloLl32ZASsBx9UC
         d5eA==
X-Forwarded-Encrypted: i=1; AL+hErE/VEIat9kvTW6Xc8FP3anhuqstZf0Bj8Z2dHMYhq9ZNI6TOkyPHHdZmttT8/OjlqaCvYJU5IamuLc=@vger.kernel.org
X-Gm-Message-State: APuU4Z8uEpw/6shL/wi2AZp2WU0Df48AWfiD026loqlYihem9DUdWUxa
	DcPVt6CNW1oPQKEyQHqwgWwBpV7cirjyclSi/yVDzyrFwMYFyfY1q0eI2nlWVtusaJYk0LAWbAZ
	rlivqeUdyzMgugMgWqQGMze9mZkQdCqlZfrYhIfg=
X-Gm-Gg: AZFdTZeWg9AjF1G9Wr6NY9rC4u55tmZiMRStqY/prrLAOCikLK+Oe4nOcU3IhBKzX8A
	myJj+urQZ4N1YSpVDxv+ecv/1Z3CTFFH3DDp15KdPWVDTxxHFW+/U1zrA6FHmph4wBdWlCcCyjV
	jDK2h691zcJ3EnJJw5GlnOEr/kuTypiC4iayaDh6W6cP9iKHB0nqwmitwFS7GpaH6XSVGaKVdI0
	G8Vf4GzyZmePtU+CTGtmdEGTG/0e3mfwXL+maYw41qt2dBG0AHGNnBCMe8crUfspUX7+XD9K59G
	oaL0R6e/uhQ9N4iCjKPP9vlfVQC0LMEJbAPmpcEyQj5H+t240lqtfNXG/kE6pN41yYEoKoBVjFV
	JlXZimzJNFk+rN76kCb3WbYkGbLVPfZOMwvQ44sC3upNnfWtSPu1V4HGuS8z2d+NSIav9yA==
X-Received: by 2002:a05:6512:1148:b0:5bc:cc46:1849 with SMTP id
 2adb3069b0e04-5c1bc874b3cmr6981033e87.54.1795780976912; Fri, 27 Nov 2026
 04:02:56 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126163114.403846-1-koray.fra@gmail.com> <20261126163114.403846-3-koray.fra@gmail.com>
 <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com> <DN5YPR39J7QI.1S1LCFLNUCZNL@gmail.com>
In-Reply-To: <DN5YPR39J7QI.1S1LCFLNUCZNL@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 13:02:44 +0100
X-Gm-Features: Aa3M54ohq34732gC99y698hjwvA-0NF3EsaW7G0zij4KAugMs04c_-FFLASygdQ
Message-ID: <CAOQ4uxgzmB0dEpQCVGKOc8reJ6OFV=BxDMgRW81aKiCMwDSn_Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] fscrypt: update fscrypt_prepare_setflags() to use xflags
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	Alexander Aring <alex.aring@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 12:38=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Fri Nov 27, 2026 at 12:35 PM CET, Amir Goldstein wrote:
> > On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
> >> legacy FS_*_FL flags.
> >>
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/crypto/hooks.c       | 10 +++++-----
> >>  fs/file_attr.c          |  2 +-
> >>  include/linux/fscrypt.h |  6 +++---
> >>  3 files changed, 9 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> >> index 149498bdab94..52d6a33fc9e9 100644
> >> --- a/fs/crypto/hooks.c
> >> +++ b/fs/crypto/hooks.c
> >> @@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *den=
try, struct iattr *attr)
> >>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
> >>
> >>  /**
> >> - * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_S=
ETFLAGS
> >> + * fscrypt_prepare_setflags() - prepare to change xflags
> >
> > prepare to change the file attributes with file_setattr() or one of
> > the legacy ioctls
>
> Ah yes.
>
> >>   * @inode: the inode on which flags are being changed
> >> - * @oldflags: the old flags
> >> - * @flags: the new flags
> >> + * @oldxflags: the old xflags
> >> + * @xflags: the new xflags
> >>   *
> >>   * The caller should be holding i_rwsem for write.
> >>   *
> >> @@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
> >>   *        another error occurs.
> >>   */
> >>  int fscrypt_prepare_setflags(struct inode *inode,
> >> -                            unsigned int oldflags, unsigned int flags=
)
> >> +                            unsigned int oldxflags, unsigned int xfla=
gs)
> >
> > This here is a backporting landmine -
> >
> > Changing the semantics drastically without changing the helper name
> > or signature.
> >
> > Please rename the helper something like fscrypt_prepare_fileattr_set()
> > so that backporting mistakes will be caught at build time.
>
> Yes, though, would it maybe be better to just use xflags_to_flags() in
> the vfs patch instead of changing the fscrypt function at all?

Yes, much better. I agree.

Now looking at the /* initialize missing bits from old_ma */
hunk my reaction is to look away its huge and it should be
using helpers probably called from within fileattr_set_prepare()
itself - because if this is de-facto preparing for a set.

Thanks,
Amir.
