Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED231F984;
	Thu, 23 Jul 2026 14:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784815519; cv=none; b=cO/zKm9L6zDUhkxKxWUjhLAC9QLACeYFZwt2rSdfVvw+MeDWj51lmG635Wj7UbBKzYT6NsYMdF6n1g201F79VPFqf+Rxovh2/vgvo8eZCfbVIo4VkOwC/ZYBQ10LwTM+z9ImIfT+NNb75yuFhsHSnJoymATB7gqoEBxPAmP/7gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784815519; c=relaxed/simple;
	bh=hEpp5iTqQEGreQG1q+Zq157iqjWxjQ92aIv2+btmp/k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BHcnmzi46osT8LxeeGcgtq6WEUHi2zJA9mgA/UE4etnvVxSX3/WaLGFFXQKAnbNjuR4tN23AIGjb76flph1RIm3TTKbWK7bG0xfE6vqHLagXa5cIYQS2KHMtLpA3BbUq+N5HKytn5ayMSGHAewKm/c3AunNie1iVgJFZgxUAlew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com; spf=fail smtp.mailfrom=mssola.com; dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b=ixFSZbxf; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b="ixFSZbxf"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4h5Xv60FhhzMlG5;
	Thu, 23 Jul 2026 16:05:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1784815506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LdOwfZIf6LUz/efW5SRW6BCEaTri0nMZtJcflE6XZUo=;
	b=ixFSZbxfp71UFyAd1AFfuXYNFUriEnAggoN59d/BMEOUll05K2L0JiIjGuWg/1hihE6Vvt
	zdswmVeTMd3nuip1WDElUwZerFY4MaILToi7JxMp0MbMlvLIY+5eTWLg048r0obOMnwsHV
	hWytHcwxkAqp+saJSF/MuOq41zaJESC91JqZdNuAeOwcOFAo08WrhoipZHKQY4ew5CWefK
	K1S57M+BkIuXx9NFhxq5V32D+r2MKuvvuSTRpAIzVZRGoL9ZC6HRmdkz6hUbFXGvArQqQA
	gQ9uxgr/IEIjKjUu4JX87KdxlAO7OLLwDqpH2T83HJMlZ6R3MeH14pMSyOpoMg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=softfail (outgoing_mbo_mout: 2001:67c:2050:b231:465::202 is neither permitted nor denied by domain of mssola@mssola.com) smtp.mailfrom=mssola@mssola.com
From: =?utf-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,  Andy Lutomirski <luto@kernel.org>,  Jann
 Horn <jannh@google.com>,  John Ericson <mail@johnericson.me>,
  linux-api@vger.kernel.org,  "H. Peter Anvin" <hpa@zytor.com>,  Kees Cook
 <kees@kernel.org>,  Farid Zakaria <farid.m.zakaria@gmail.com>,  Alexander
 Viro <viro@zeniv.linux.org.uk>,  Jan Kara <jack@suse.cz>,
  linux-kernel@vger.kernel.org,  Jonathan Corbet <corbet@lwn.net>,
  linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC 7/7] Documentation: add failfs documentation
In-Reply-To: <20260723-work-failfs-v1-7-3f69b9a9e958@kernel.org> (Christian
	Brauner's message of "Thu, 23 Jul 2026 13:30:26 +0200")
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
	<20260723-work-failfs-v1-7-3f69b9a9e958@kernel.org>
Date: Thu, 23 Jul 2026 16:04:57 +0200
Message-ID: <87ik65vm2e.fsf@>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Rspamd-Queue-Id: 4h5Xv60FhhzMlG5

--=-=-=
Content-Type: text/plain

Christian Brauner @ 2026-07-23 13:30 +02:

> Document the failfs semantics, the FD_FAILFS_ROOT sentinel, the
> fchroot() entry requirements, and the ways back out.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  Documentation/filesystems/failfs.rst | 64 ++++++++++++++++++++++++++++++++++++
>  Documentation/filesystems/index.rst  |  1 +
>  2 files changed, 65 insertions(+)
>
> diff --git a/Documentation/filesystems/failfs.rst b/Documentation/filesystems/failfs.rst
> new file mode 100644
> index 000000000000..46d91525916b
> --- /dev/null
> +++ b/Documentation/filesystems/failfs.rst
> @@ -0,0 +1,64 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +======
> +failfs
> +======
> +
> +failfs is a kernel-internal filesystem that fails every operation
> +reaching it with ``EOPNOTSUPP``. It is the counterpart to nullfs. Where
> +nullfs is a permanently empty failfs means "nothing is supported here". It
> +cannot be mounted from userspace, nothing can be mounted on top of it. It
> +cannot be cloned.

A small change here makes the wording more clear: from 'Where nullfs is
a permanently empty failfs means "nothing is supported here"' to 'Where
nullfs is permanently empty, failfs means "nothing is supported here"'.

> +
> +The only way into it is the ``FD_FAILFS_ROOT`` file descriptor sentinel which
> +is understood by ``fchdir(2)`` and ``fchroot(2)``.
> +
> +Semantics
> +=========
> +
> +Every path walk of a component through failfs fails with
> +``EOPNOTSUPP`` before that component is parsed, including ``.``.
> +
> +The root itself cannot be opened at all not even with ``O_PATH``.
> +
> +A process with its working directory in failfs fails every
> +``AT_FDCWD``-relative lookup. As with any working directory that is
> +unreachable from the process root, the ``getcwd(2)`` system call returns
> +a path prefixed with ``(unreachable)``.
> +
> +A process with its root directory in failfs fails every absolute path
> +lookup including absolute symlinks and the interpreter of dynamically
> +linked binaries. In other words, this fails exec.
> +
> +Lookups anchored at explicit directory file descriptors keep working. It
> +is the ``fs_struct`` equivalent of ``RESOLVE_BENEATH``. The process must
> +anchor every lookup at a file descriptor it explicitly holds.
> +
> +Entering
> +========
> +
> +``fchroot(FD_FAILFS_ROOT, 0)`` requires ``CAP_SYS_CHROOT`` in the
> +caller's user namespace, mirroring ``chroot(2)``. Unprivileged callers
> +may enter if both of the following hold:
> +
> +* ``no_new_privs`` is set: setuid binaries on regular mounts remain
> +  reachable via inherited directory file descriptors and executing them
> +  with an unusable root directory is the classic confused deputy.
> +
> +* The caller is not already chrooted: the root directory is what
> +  confines ``..`` resolution and the failfs root can never be reached by
> +  walking up a real mount tree, so moving the root of a chrooted task to
> +  failfs would allow it to escape its chroot via ``openat(fd, "..")``.
> +
> +Leaving
> +=======
> +
> +A process that entered failfs counts as chrooted. It cannot create user
> +namespaces to regain ``CAP_SYS_CHROOT``, and ``chroot(2)`` or
> +``fchroot(2)`` back out require ``CAP_SYS_CHROOT``. The only other exit
> +is ``setns(2)`` with a mount namespace file descriptor, which requires
> +``CAP_SYS_ADMIN`` over the target mount namespace as well as
> +``CAP_SYS_CHROOT`` and ``CAP_SYS_ADMIN`` in the caller's user namespace
> +and resets both root and working directory. A process that holds no such
> +file descriptor and restricts ``*chdir()``/``*chroot()``/``setns()`` via
> +seccomp has thrown away the key.
> diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
> index 1f71cf159547..734a45e51667 100644
> --- a/Documentation/filesystems/index.rst
> +++ b/Documentation/filesystems/index.rst
> @@ -91,6 +91,7 @@ Documentation for filesystem implementations.
>     ext3
>     ext4/index
>     f2fs
> +   failfs
>     gfs2/index
>     hfs
>     hfsplus

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAEBCgBMFiEEG6U8esk9yirP39qXlr6Mb9idZWUFAmpiH4kbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEhxtc3NvbGFAbXNzb2xhLmNvbQAKCRCWvoxv2J1l
ZYgTD/9KAf4+0eklvUgseLVVsTP5X1oj+k9efgBBejLYCTsIM18lrLVcocsgKvU6
eHqnD1vt+2Q2xX30cBaVxo6YmDTCEUy2X0E2Lzz5+7bzYAoL6eumtp4QxtCWdpq/
LoZaGhj7b/r9qCnde0y3569k2Mprjv3O2he3Ylw+pHHlOJkghWmi/5b4ywaMTY3e
pEy5BxuQwu9PEmz/7cGpiYdkDYoml1chLiOzrgTa4XjorRAXZUb8ldUCer4A+f7I
5bd2shH+LMAPRscsdVrjTdEIlJHzq6aoyl5bNv1QtEv/Ogycav7G3S6meE0DVT2i
/dFVi0ZWdoPxzx7WMMjZJTNIdnfrIoYnoAjjlg8pTN/JptCTVcdEpzn4BmoH0+D6
Z7qoJLZOggARqBrB6abjiKU4ZUfsER5+Mi4s/ZqVHHvZAoF70Bil/KTdorYHLLoH
jPAljPEYdG5zg85AaYjAwCrmyxcvQRWeisOl0hiCaOYTJaVkeeAoK/ddUhipbX2v
VBg275mCzQaJv1L8Pdk+sh++4ocOTPgeWQRN0uSTzN9LwxThV9yxAG8RiN+uXu5p
9Je2N4eX+wP6yG2cWoA4nB9zp+DmqwYRrTGQoCxBboiMursQpDdOMAfq+hKaKrtI
90pqFD/jot51wBpSY0cmXwrvFSwOwmmY3lTxrSg6mGysiuiJnQ==
=XkcE
-----END PGP SIGNATURE-----
--=-=-=--
