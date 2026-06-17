Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6143A5E72
	for <linux-api@vger.kernel.org>; Wed, 17 Jun 2026 19:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781726255; cv=pass; b=H6v6yL9fszVDAXIQapeHaSDSukfNjKGlIGze08YYbsuSnK4yxm5HXAKoxTmQKl6dlQC1ezN5LBJVW+5vu26R7740AsJcYw+qQU90Ww3cJIomAO5HIShtvWlzm+fvggEL7coDKx2lBzY7HZFNCwV5YEvJkXQELmp3N26NQD3rhBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781726255; c=relaxed/simple;
	bh=zJ0IUeGHsdJdPluNaERbeBaxMQit3LG3hz6ZGuJa0tY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JSm/87zdGKolYrJWiOaJleRim0hohGNrYgeZ7IsUOc12VgPI0sAd6wiZkrRVuyfUbi8zWXFKYpR7a/8UJsnDQaxi1Pm7TdCK4BtficvKX+rZLzMyJymtiwvegs8iqm62i746yD0GuBW2xSlk3oGM0vwSIWuABTheyDzX0PZ128I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oO/cUxIB; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oO/cUxIB"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69e32df92c1so129497eaf.0
        for <linux-api@vger.kernel.org>; Wed, 17 Jun 2026 12:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781726246; cv=none;
        d=google.com; s=arc-20240605;
        b=cUao+azunW91BcYA3Yo9ln+XnVDsEOf+c07pTZ7i5Guuq56JJ5r7shKe6/pUJpcvOt
         cC9O2PqdUfjR05OUNk98GqhMJ7JhoL+Pc2mgxVlOtT+tXJNfBSEJTo2050Y+RY9ddoyy
         jxzrIhuZabl+f9CuZykXfoQhHiwt2K9CtGL5bXI/UBCXN9mRB0UMd3jVsIcLZVdm/MPY
         pq/X97TJK4AbSWp8elEHdNacNFVfpH2GVnIxlNR6yjVMta6rCDLAGT88yTjPlJ5vCV1s
         KY/Xc2qhfVsIwymhY3zrVELHNgzTK6dXn0kP/pSbDI9D1S58Ucm40UUMVwEO1xNX+JQ4
         XHSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        fh=HWAj++wUGryjARYxGmoQegtwPR8UPYdWwp6b33GSQg8=;
        b=AhaneAsEiO66LuweWrOf2EgORDLAZ8pE/7J4gNQ4J8WuNv8xxRoPxslscEVPvLoQQf
         I832d1BVsC2FvyWtu6s6gZ0JXqtdTekpXZoumyCXOd3iGrsriJ6rKxRddRl5d52vG0I7
         Sw3YYUn8dvaFUXLOO8z3R8PaQNpl6GKkhJmNx0bETi7Kdlzu+pWK6fk13FxEUATAJL2/
         1ivtEHb0vxqmTla8kEO4Nd87mgN5mLzjk+d4bpY8CnPnUlxiWheEAzIydOWJuspOxCbf
         nja6pyhwKvAouee5/zyr4CGJpniIga82YNoPRBY+0dmy6Zgr+msByf6XxAnr0cxu078X
         2YPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781726246; x=1782331046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        b=oO/cUxIBVolPAntAAuoSBXmkw4TumAzDD85o96DnyS4iiQj3HZ0dtSJbT0Hpo2vJO2
         /kij/dzjJxhogUHoe5spNaMHiXgh/l09z/0H7K4U5iBnd1KiAqC0g3ykXwnMFMKHpuaJ
         qHCMc7l3xUpj8fNv5TY2YVDcjkTwXuGqIbHBeK+LNDAC/msoX5rlNR0qPMlhNqixpPj4
         4slxXitO3p9gh0FITq06WE4+27Jp30zYL+yVAdJpZb7/YO02yml0dxjYD6HGb0wovww/
         2ghC51srA2wAdk+UjVuCNRZQZaRa1kRyUDb92GtXyhCBGOuFmYIhW08Lzhpiy7NFT/xn
         Qwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781726246; x=1782331046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        b=qRTWx1TQUgEqT6RpMh6//TUkfiR0G0MkHRjyhLq3dryLl8QAuMZUSW+/tEcUE9YACn
         GdSTVbvr1dk452zURcISOWYuhvbrvVXzZd7UhBiPfAvRRnxxGDmIXsk8+xnC63jUX9Su
         pKfl61/HBhnCCMR2ZWKKau06YsjwofGdgZHhckSPOuaEAexBXFaLoVf3tFgzkOtE03DF
         PvQIc9yt0NVNguLi7tFt2zt+EMSVODFSgioVK0YunNjodS+aiantzv7T4g/tScYOG6fl
         e/jvzOk4CwDHIHMohalcY6vB57JvGlL+AbSROt/t82Mwlv6KIhbMnpVMnhmc/Png6+HO
         8KWw==
X-Forwarded-Encrypted: i=1; AFNElJ/1gu16PGdwVFAchW/g3HVxwcewFgnUnKlhsXHyXii+/hrrskzhiEPhlnHX03D8g5IRGkDxLvjIhG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNX520RJhmXBnoXZS2ihy9SQIym2yF1nSop7njwVgLA9jl0Bxi
	6Fx3EqVnZT9RJiA9Jacr465rB7hV14VIB8KireGXXpQXnlrYmCl53ctehggz4YnjrBYTLCD9Mch
	fPmJUY6ifglY9StdoGbPNqt7Tbh4FO70=
X-Gm-Gg: Acq92OFAXxzTS4dNdUZ1ppsM7/fIgJVIjPs694YuT64fHK4ni01HLyJjgB7VjRj/s/R
	v2PdoEiUP2C6pBwOegANlP9uEq+Xi4IPuwg6lBYKQNjTbYpXfgXwiBnBV/l5GTdmDstJGsbmauC
	UXZcxLlXyuviNvuUtyHoZXCRoLg9Fw+WvT7jr90fh/ke04ACDLkS1MGw9bBoDiKCX/5DNjSRfU7
	DARI7hN9EfehY4ejV1nbjX3QAMCjD3pe7pCOY2jnf7SNLIswViXCoztzmWF7oikNmcj5/U=
X-Received: by 2002:a05:6820:1c90:b0:68a:f494:e8fc with SMTP id
 006d021491bc7-6a0b60c0b36mr3762306eaf.33.1781726245995; Wed, 17 Jun 2026
 12:57:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
 <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com> <20260617-attest-gewechselt-tragik-7ed473860051@brauner>
In-Reply-To: <20260617-attest-gewechselt-tragik-7ed473860051@brauner>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 17 Jun 2026 12:57:14 -0700
X-Gm-Features: AVVi8CcHFrVPI3Twv4VAYTkdhufN4WGXszz_j2JUYmYPkPtYdrsmDFCM1RURvTg
Message-ID: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Val Packett <val@packett.cool>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	Bernd Schubert <bernd@bsbernd.com>, Aleksandr Mikhalitsyn <alexander@mihalicyn.com>, 
	"criu@lists.linux.dev" <criu@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 4:08=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> > After this patch, step b) is a straight copy which means step d)'s
> > fixup doesn't modify what's in the pipe. This could be fixed up in
> > libfuse to not depend on modify-after-vmsplice, but I don't think this
> > helps for applications using already-released libfuse versions. I
> > think this patch needs to be reverted.
>
> Note, nothing was merged. I deliberately kept in -next though for a long
> time to see how quickly we'd see regressions.

The bait worked. CRIU wins a prize in this lottery.

The CRIU fifo test fails with this change. The problem is that vmsplice
with SPLICE_F_NONBLOCK to a fifo file descriptor fails with -EOPNOTSUPP.

It seems we need a fix like this one:

diff --git a/fs/pipe.c b/fs/pipe.c
index 429b0714ec57..6fc49e933727 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1253,6 +1253,7 @@ static int fifo_open(struct inode *inode, struct
file *filp)

        /* We can only do regular read/write on fifos */
        stream_open(inode, filp);
+       filp->f_mode |=3D FMODE_NOWAIT;

        switch (filp->f_mode & (FMODE_READ | FMODE_WRITE)) {
        case FMODE_READ:
