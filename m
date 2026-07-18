Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B3B325490
	for <linux-api@vger.kernel.org>; Sat, 18 Jul 2026 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784403596; cv=none; b=lhOyQec39B4sU9dgFM9GNaPXr/NNZwTJIeOUVv7n1vPCK2pVFf/utUcIBSwXVnyLsVO0FuGWUV63Yv2Jf1+fFw2HHySyrKjStH+sYV3ABZOUUE7KQkjSQ9d/YTwFzOwyW6E1TlieqLnPg/Z0ROLjY3oP0m7TSc9UKgYfXV8YDs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784403596; c=relaxed/simple;
	bh=6HZvEfa/Gg3qLeLXrnqD8wi1HgmNRFlhLvjoQECOQhE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wbf8K7wl6NYK8jnHW/FlvxJY7qKInTJFQHidVhEMMCMT6mJB6ZhjLs1biI2ucolhNkGuwdQsYCnAX4Md+wZGMNJ2yrK5br9Oz8UOroIqVAZZwhilEADMqwCP1OlGelGSWvuSy8gUyKcPeQMpODB8s9DPu/yOWLRO1TIQ4Oi0j/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irAMvTFd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irAMvTFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25571F00A3A
	for <linux-api@vger.kernel.org>; Sat, 18 Jul 2026 19:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784403594;
	bh=wnjvK5TogWv++ZaSJX8JOOWJ2YLUTBtBygq2xMyDmVY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=irAMvTFdoFcWBxEYRqUVJ8XuL60OzDQA4E/tLc87ray6p7SGrW5aZgT/5U0x4yTQ4
	 JllVRuKkq1HwAlfgjdnRPCyK/BQ7uCkjOW3tU45xvYzlB+rNbSlHh1TXBrMe6ZrEHq
	 Yf0Lt6Ec4YPRN2yoQYVt15Ikn3o22SxXh0KoBg8KEArmWloJ7uevrzoM7lwU+oo+L9
	 cTSZsJM2EfVwG/okgH2V2EGOEQXTHlefKd2m7DF0tfehh5HaQ3GqgF6T+XzKrRn6x7
	 72pL1QeG257yNbFOKwvF9SyDPEOmITzq2GLuYlKFsHf7w6NbNH79OehB85sJWuT3qy
	 t53Hd6ArelP6g==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39c7ac9b8c3so51521481fa.0
        for <linux-api@vger.kernel.org>; Sat, 18 Jul 2026 12:39:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpBive+1QlfjgdRg/vJ5BYiFnU11BSG6cdwzF8Q0kKXBn6kMPdpN6CQkUQ5OE1xE4JWKwwnJWQGLxU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3tGC3JL42456sWI7QvF7WgrfcnKu/CTze7sP+KvI0Lfp9NFw7
	rMJnbP+2yLnfM/4ir3gw0ZNUYTGRFWm7FWMNh9HIXDtwy9ktMJ22xWhZ1S4EHScys1T9aPV1grd
	tfyTkKtGIpOlvBHZheGKuhT8OKaMZzmaNOqn9aCbz
X-Received: by 2002:a05:6512:318c:b0:5ae:b7d4:7dd7 with SMTP id
 2adb3069b0e04-5b28f879e58mr1729092e87.24.1784403593038; Sat, 18 Jul 2026
 12:39:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <20260629-hauer-erhitzen-sobald-96d3dff68707@brauner> <CALCETrVuh0-biOw=TgYN9ERTFAoiki57XeZ3S2T3dO2+hL54gA@mail.gmail.com>
 <20260702-entladen-farbkombinationen-klarheit-fe24cb608f23@brauner> <20260706-dabei-radeln-glitzer-71ecb835029c@brauner>
In-Reply-To: <20260706-dabei-radeln-glitzer-71ecb835029c@brauner>
From: Andy Lutomirski <luto@kernel.org>
Date: Sat, 18 Jul 2026 12:39:39 -0700
X-Gmail-Original-Message-ID: <CALCETrVjDtBmB+boCUgd069UpZGUB1TCbEn3k1HZQex-_dPgbQ@mail.gmail.com>
X-Gm-Features: AUfX_mwi8E7EX3ucsAKoGp35lnBZlX3ZZXeZYq3-vf-ZNEwzMurGVJdsjLAABDE
Message-ID: <CALCETrVjDtBmB+boCUgd069UpZGUB1TCbEn3k1HZQex-_dPgbQ@mail.gmail.com>
Subject: Re: [RFC] Null Namespaces
To: Christian Brauner <brauner@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, 
	John Ericson <mail@johnericson.me>, Li Chen <me@linux.beauty>, Cong Wang <cwang@multikernel.io>, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <kees@kernel.org>, Sergei Zimmerman <sergei@zimmerman.foo>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 6, 2026 at 8:31=E2=80=AFAM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Thu, Jul 02, 2026 at 11:34:01AM +0200, Christian Brauner wrote:
> > On Mon, Jun 29, 2026 at 02:06:55PM -0700, Andy Lutomirski wrote:
> > > On Mon, Jun 29, 2026 at 4:45=E2=80=AFAM Christian Brauner <brauner@ke=
rnel.org> wrote:
> > > >
> > >
> > > > But I guess the even simpler model would be to copy what I've been =
doing
> > > > for pidfs:
> > > >
> > > > +static struct path nullfs_root_path =3D {};
> > > > +
> > > > +void nullfs_get_root(struct path *path)
> > > > +{
> > > > +       *path =3D nullfs_root_path;
> > > > +       path_get(path);
> > > > +}
> > > > +
> > > >  static void __init init_mount_tree(void)
> > > >  {
> > > >         struct vfsmount *mnt, *nullfs_mnt;
> > > > @@ -6209,6 +6217,8 @@ static void __init init_mount_tree(void)
> > > >         /* Mount mutable rootfs on top of nullfs. */
> > > >         root.mnt                =3D nullfs_mnt;
> > > >         root.dentry             =3D nullfs_mnt->mnt_root;
> > > > +       nullfs_root_path.mnt    =3D nullfs_mnt;
> > > > +       pidfs_root_path.dentry  =3D nullfs_mnt->mnt_root;
> > > >
> > > >         LOCK_MOUNT_EXACT(mp, &root);
> > > >         if (unlikely(IS_ERR(mp.parent)))
> > > > diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.=
h
> > > > index aadfbf6e0cb3..f55c87c70b78 100644
> > > > --- a/include/uapi/linux/fcntl.h
> > > > +++ b/include/uapi/linux/fcntl.h
> > > > @@ -124,6 +124,7 @@ struct delegation {
> > > >
> > > >  #define FD_PIDFS_ROOT                  -10002 /* Root of the pidfs=
 filesystem */
> > > >  #define FD_NSFS_ROOT                   -10003 /* Root of the nsfs =
filesystem */
> > > > +#define FD_NULLFS_ROOT                 -10004 /* Root of the nullf=
s filesystem */
> > > >  #define FD_INVALID                     -10009 /* Invalid file desc=
riptor: -10000 - EBADF =3D -10009 */
> > > >
> > > >  /* Generic flags for the *at(2) family of syscalls. */
> > > >
> > > > we then add fchroot() (overdue anyway) and then teach both fchdir()=
 and
> > > > fchroot() to honor FD_NULLFS_ROOT. Then a process may shed its fs s=
tate
> > > > and move itself into nullfs. Restrict *chdir() and *chroot() for sa=
id
> > > > process via seccomp and it's locked in forever as well.
> > > >
> > >
> > > One thing comes to mind that might need a bit of care: this would giv=
e
> > > an API for any task to get an fd to a directory that lives in the ini=
t
> > > mount namespace.  It's not at all obvious to me that this is dangerou=
s
> > > or even observable (you're not about to find a setuid program in
> > > nullfs), but I think it's at least worth a tiny bit of consideration.
> >
> > Yes, I thought about this as well. But it doesn't have to be this way.
> > Every mount namespaces has nullfs as it's root ever since I introduced
> > it. Which means FD_NULLFS_ROOT can also just mean "nullfs within that
> > specific mount namespace". That's fine.
> >
> > For my FD_FAILFS_ROOT proposal it would be enough if we make failfs
> > SB_KERNMOUNT which means it's logically distinct from every mount
> > namespace. I think that might be the right thing to do. I need to spend
> > one or more brain cycles on this though.
>
> I had to take a long drive on Sunday and I kept thinking about both
> FD_NULLFS_ROOT and FD_FAILFS_ROOT and ofc there are some things to
> consider/discuss.
>
> I think the straightforward solution to FD_NULLFS_ROOT would be to just:
>
> - make it always available
> - refer to the caller's mount namespace nullfs
> - work with fchroot()/fchdir()
>
> So I considered two chroot() use-cases for the sake of simplicity:
>
> (1) You want to isolate yourself for the sake of lookup
>
> (2) You want to isolate yourself to assemble a "private mount tree" but
>     not really be in a separate namespace (very odd use-case... but it
>     helps to make a point).
>
> The problem with this approach is that everyone who chroots into the
> nullfs root would suffer from the problem that any mount on top of it is
> still visible. So that kinda makes it pointless for both (1) and (2).
>
> Also all mounts that someone else would do would also be visible
> allowing multiple chroot()ers to affect each others state. That also
> would somewhat defeat the purpose of the chroot(). So I'm not convinced
> this is what we should do.
>

After some contemplation and a long place flight: are we talking about
nullfs or failfs?  Because I would expect that it's entirely
impossible to mount anything on top of failfs.  So failfs would be
useless for #2 but would still solve #1.

--Andy
