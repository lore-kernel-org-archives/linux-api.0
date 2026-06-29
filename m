Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359E8360ED4
	for <linux-api@vger.kernel.org>; Mon, 29 Jun 2026 21:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782767230; cv=none; b=PWCmtXO1tO2p16IQGVZAfQTYPYsuaCwjNdivaRnLqB8TpYvtutr9xRKPxiElg9gDV0TophzyaCeboBhoHOxhO78CM5nSCtkQaWnnchJTq92/zH968eTVI8hAon6M06ppvkug8VwQlDSL/ZEhwsZshp/A1UdbzgqR2669evzgKhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782767230; c=relaxed/simple;
	bh=uRnAtDwCNO9BhCTtGFk7SnQYQafVVJE2jiS6mFdcqFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pn8to2xV5YTPkPPXz1Ae8n749aJUUkMZ8flpDJ8B+XaZwCRpddKz+VWMx45S1Ukfr70wT0Xbxz53cTlD7FdZ+X+fY+FlczjK2kdQ1ftamVwT/TOdQRLhETC4HPqJ98NlacOwB1NaXDGHa1sYFhsT5OT0J8fgJUND3nz9sHhIBaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvOADvgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvOADvgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8D51F0155C
	for <linux-api@vger.kernel.org>; Mon, 29 Jun 2026 21:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782767228;
	bh=YfIToqSpqLi5Ux4oNUHmwU5C18eq/HPGb1nR21G13hE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WvOADvgwMQCNYf3xVBU8wXEITYw3J0aqr+SQG5z0hR7kHHv31T3mx+T5Jhg0LGYeZ
	 8iiH19VtqFAsKbIV5bjbf4PoiGmK1M8Sd3ryfOPPvReHKLe+POM6Fciz9T5sS32Oo9
	 JKt8bKLaHMYbBaQf5Z9A6MUpdnvfT7W2nuPnUElqMRZTidM96SDR+/YRY5py2Cxjt4
	 b4uhAY6lmTKstfzhg2HJtVqmP7dODriH1JHhMURygo4pajVVeZMIk6QGX5g/P+GQVy
	 FuPHm3LDLqTicDJ2F5RGOT1SM4kce8EUeaGTMu+C9p30g9LrRb9YcHmEexOLM+aC6R
	 w1A3Bsu7h4e3A==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aebba706b3so1125695e87.0
        for <linux-api@vger.kernel.org>; Mon, 29 Jun 2026 14:07:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqVTIqldeVjWlJrffH0PVraCUEVjvDLItaaTrQWj5XieaWcHgO15tlS+QrN7HcVQ8GBQzyHizyvt1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YySPadI4LidHRoa4PrxgoLCPml2OAE11YVdILaN5E4QTvtbBvGp
	9nyKM9yBgg08O7PebP3nM03kMT4XV4PjBH/Btst/PhKiI9A9C9qf/nQOn7LgS0RGt/QgEPSlImi
	Ey/knItJpnoEYrdf+sGthn08RHnObf/j5ePpN5jsG
X-Received: by 2002:a05:6512:401f:b0:5ae:b36d:bbb with SMTP id
 2adb3069b0e04-5aebdbe2840mr201140e87.44.1782767227209; Mon, 29 Jun 2026
 14:07:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com> <20260629-hauer-erhitzen-sobald-96d3dff68707@brauner>
In-Reply-To: <20260629-hauer-erhitzen-sobald-96d3dff68707@brauner>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 29 Jun 2026 14:06:55 -0700
X-Gmail-Original-Message-ID: <CALCETrVuh0-biOw=TgYN9ERTFAoiki57XeZ3S2T3dO2+hL54gA@mail.gmail.com>
X-Gm-Features: AVVi8Cf3LtciGmvZ6gi6NvgR3pE8gOwRXUXdgsUdnKdMuHYPpJ3RHP1m1o_FUek
Message-ID: <CALCETrVuh0-biOw=TgYN9ERTFAoiki57XeZ3S2T3dO2+hL54gA@mail.gmail.com>
Subject: Re: [RFC] Null Namespaces
To: Christian Brauner <brauner@kernel.org>
Cc: John Ericson <mail@johnericson.me>, Li Chen <me@linux.beauty>, 
	Cong Wang <cwang@multikernel.io>, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <kees@kernel.org>, Sergei Zimmerman <sergei@zimmerman.foo>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 4:45=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>

> But I guess the even simpler model would be to copy what I've been doing
> for pidfs:
>
> +static struct path nullfs_root_path =3D {};
> +
> +void nullfs_get_root(struct path *path)
> +{
> +       *path =3D nullfs_root_path;
> +       path_get(path);
> +}
> +
>  static void __init init_mount_tree(void)
>  {
>         struct vfsmount *mnt, *nullfs_mnt;
> @@ -6209,6 +6217,8 @@ static void __init init_mount_tree(void)
>         /* Mount mutable rootfs on top of nullfs. */
>         root.mnt                =3D nullfs_mnt;
>         root.dentry             =3D nullfs_mnt->mnt_root;
> +       nullfs_root_path.mnt    =3D nullfs_mnt;
> +       pidfs_root_path.dentry  =3D nullfs_mnt->mnt_root;
>
>         LOCK_MOUNT_EXACT(mp, &root);
>         if (unlikely(IS_ERR(mp.parent)))
> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index aadfbf6e0cb3..f55c87c70b78 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -124,6 +124,7 @@ struct delegation {
>
>  #define FD_PIDFS_ROOT                  -10002 /* Root of the pidfs files=
ystem */
>  #define FD_NSFS_ROOT                   -10003 /* Root of the nsfs filesy=
stem */
> +#define FD_NULLFS_ROOT                 -10004 /* Root of the nullfs file=
system */
>  #define FD_INVALID                     -10009 /* Invalid file descriptor=
: -10000 - EBADF =3D -10009 */
>
>  /* Generic flags for the *at(2) family of syscalls. */
>
> we then add fchroot() (overdue anyway) and then teach both fchdir() and
> fchroot() to honor FD_NULLFS_ROOT. Then a process may shed its fs state
> and move itself into nullfs. Restrict *chdir() and *chroot() for said
> process via seccomp and it's locked in forever as well.
>

One thing comes to mind that might need a bit of care: this would give
an API for any task to get an fd to a directory that lives in the init
mount namespace.  It's not at all obvious to me that this is dangerous
or even observable (you're not about to find a setuid program in
nullfs), but I think it's at least worth a tiny bit of consideration.

But if this happens, maybe we could finally land one of the patches to
enable unprivileged chroot?  It's been tried a few times.

https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.13278=
58005.git.luto@amacapital.net/

https://lore.kernel.org/all/20210316203633.424794-2-mic@digikod.net/

I think the need for it has reduced a tiny bit with user namespaces,
as you can sort of emulate it by unsharing your user namespace and
thus getting enough privilege, but this is rather heavyweight and
limiting.


If all of the above landed, then the old chroot /var/empty kludge that
security-minded programs have done for decades could finally be
modernized and not require any privilege :)

Hmm, thinking aloud: every now and then someone brings up the idea of
having an fd (really an OFD) that points to a file or a directory but
carries less in the way of permissions/capabilities than the usual
OFDs.  If we had a way to make an OFD to a directory that forced
RESOLVE_BENEATH (or RESOLVE_IN_ROOT) and that propagated that
restriction to anything you open using it, and if an unprivileged
process could chroot itself to nullfs, then we would be getting quite
close to what Capsicum can do.

--Andy
