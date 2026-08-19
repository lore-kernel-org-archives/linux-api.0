Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF976367B90;
	Wed, 19 Aug 2026 01:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.182.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787102147; cv=pass; b=qj8VgG0xH0UwjR4uB5pYgObcb3qKQSqEWa5yjV1q+lZA/8v8sL+nMDDeQzu8Co7NDlom3xJtLOrgqxXTuo96XQBTAqEZ8wrEH8YBaP1jqesTOV/EnHSw81JJUA2Ci/IxH34VCJilRunTsztCNUynhmvgYyBCwzG3jvkzyOLhgHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787102147; c=relaxed/simple;
	bh=iWF4sj6xmzNEKIMaQBKku5GRthkNL3Wi6iteaBUvH2g=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=qvN7VhPbTnovA9hkY1eOjuvGJ0yJfIIJRQF7FDtOZwL8iuAF0CqL2cE0Vdbipe5YeM//12fD0I9xtzXRFIHzros4wF/TOI/s1iknoqJ29Dt5C4jlnU5zfKLoZwu5c4GVSgj7ZNdFE5QnxNO8K4mNEyO18W6PRIB5gJUiQg/JEsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=iq64qdYC; arc=pass smtp.client-ip=165.173.182.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="iq64qdYC"
ARC-Seal: i=1; a=rsa-sha256; t=1787102084; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Vb7w8BxrWfF9lHwWUjEbzRIx6KBRsUigHB1BIq5oHipa4Sd5jus0nZuCNwSMN16h13U89lzH6ju4G911GghpembRCVMf6Yw1CT8w/E/crZljRwsXmE/Li+OUqGXnCiffP8k9tD//Lp24NVcZUbhP1N5p4BakadY5nnGnGkrKlP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787102084; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Q+1yMs/TAg44PdtgHr4whUenCDXTlH65MGNSP0QkUgg=; 
	b=WzWWhEtFLhl2pB77v6E9NVuvONhpfr1iSWuWwttJmBuNvgr+2o5q3xLfDp00t9v7wxA6TtHtnvNzvU8dXWIOvWkefjmVNqix8VmBZHLHfLyjsAfPFlptN+Qb3+HpTwx+l+7OFJPjiKQdWKN6Hk7kagCTpAvX98Wc1+Uk45k0X3w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787102084;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Q+1yMs/TAg44PdtgHr4whUenCDXTlH65MGNSP0QkUgg=;
	b=iq64qdYCSRkOo6W1o0SCny2QBrEIZAAUw+Q6FRFTCwzUHg5s0qfJmEOfHSz1ivlZ
	DnhE8UtxYhGyGliZxovvaGRIYEAuZhGP9XmhynpPXodH7YfeM+jsfwNR5IstCYJqeee
	qfOU1FA7TEkwqMY9QjgL3LcezQkk/TXcXATx/tvM=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1787102084308142.55088526691668; Tue, 18 Aug 2026 18:14:44 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1787102081175753.1506133241837; Tue, 18 Aug 2026 18:14:41 -0700 (PDT)
Date: Wed, 19 Aug 2026 09:14:41 +0800
From: Li Chen <me@linux.beauty>
To: "Justin Suess" <utilityemal77@gmail.com>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Gabriel Krisman Bertazi" <krisman@kernel.org>,
	"Josh Triplett" <josh@joshtriplett.org>,
	"Mateusz Guzik" <mjguzik@gmail.com>,
	"Andy Lutomirski" <luto@kernel.org>,
	"John Ericson" <mail@johnericson.me>,
	"Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <shuah@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>, "Oleg Nesterov" <oleg@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Paul Moore" <paul@paul-moore.com>, "Eric Paris" <eparis@redhat.com>,
	=?UTF-8?Q?=22Micka=C3=ABl_Sala=C3=BCn=22?= <mic@digikod.net>,
	=?UTF-8?Q?=22G=C3=BCnther_Noack=22?= <gnoack@google.com>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Jan Kara" <jack@suse.cz>, "linux-api" <linux-api@vger.kernel.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"audit" <audit@vger.kernel.org>,
	"linux-security-module" <linux-security-module@vger.kernel.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>
Message-ID: <1a01795b07a.1f456216580426.3401229391386650127@linux.beauty>
In-Reply-To: <anJE8SfBLtkh6QSa@zenbox>
References: <cover.1784204592.git.me@linux.beauty> <anJE8SfBLtkh6QSa@zenbox>
Subject: Re: [RFC PATCH 00/24] pidfd: add a minimal process spawn builder
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Justin,

 ---- On Wed, 05 Aug 2026 04:25:25 +0800  Justin Suess <utilityemal77@gmail=
.com> wrote ---=20
 > On Thu, Jul 16, 2026 at 10:31:26PM +0800, Li Chen wrote:
 > > Hi,
 > >=20
 > > This RFC follows feedback on my earlier spawn_template RFC [1]. That
 > > proposal made caching the primary interface; this one starts with gene=
ral
 > > process construction. Christian suggested a pidfd/pidfs exec builder
 > > modeled after fsconfig(), with enough semantics for userspace to imple=
ment
 > > posix_spawn() [2], and Kees agreed [3].
 > >=20
 > > This RFC is based on linux-next next-20260710 and depends on two pidfs
 > > fixes that I sent separately:
 > >=20
 > >   * pidfs: preserve thread pidfds reopened by file handle
 > >     https://lore.kernel.org/all/20260716052726.1032092-1-me@linux.beau=
ty/
 > >   * pidfs: handle FS_IOC32_GETVERSION in compat ioctl
 > >     https://lore.kernel.org/all/20260716052822.1034228-1-me@linux.beau=
ty/
 > >=20
 > > The initial implementation is source-based. The executable path can be
 > > provided with the final run request:
 > >=20
 > >     struct pidfd_spawn_run_args run =3D {
 > >         .path =3D (unsigned long)"/usr/bin/rg",
 > This should probably be an FD for the path.
 >=20
 > This way it prevents race conditions over multiple configuration steps.

Thanks, that makes sense. Using an fd avoids the pathname race and pins
the executable we actually want to run.

 > >         .argv =3D (unsigned long)argv,
 > >         .envp =3D (unsigned long)envp,
 > >     };
 > >=20
 > >     fd =3D pidfd_open(0, PIDFD_EMPTY);
 > >     pidfd_spawn_run(fd, &run, sizeof(run));
 > >=20
 > > Alternatively, the path can be staged before the final run step:
 > >=20
 > >     struct pidfd_spawn_run_args run =3D {
 > >         .argv =3D (unsigned long)argv,
 > >         .envp =3D (unsigned long)envp,
 > >     };
 > >=20
 > >     fd =3D pidfd_open(0, PIDFD_EMPTY);
 > >     pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
 > >                  PIDFD_CONFIG_KEY_PATH, "/usr/bin/rg", 0);
 > Same here. Should probably be an FD to the binary instead.
 >=20
 > >     pidfd_spawn_run(fd, &run, sizeof(run));
 > I'm worried this pidfd_spawn_run just adds another varient to the existi=
ng
 > myriad of exec* syscalls we already have. Would it be better to just hav=
e this
 > work through execveat(fd, "", argv, envp, AT_EMPTY_PATH) instead?
 >=20
 > (i.e have execveat take a pidfd directly).
 >=20
 > Then you can get rid of pidfd_spawn_run which looks almost structurally
 > identical to execveat (with the argv and envp collapsed).

Thanks, but I'm less sure about using execveat() as the run operation, sinc=
e it
normally replaces the caller while the builder creates a new child and
returns. A separate run operation still seems clearer to me.

Regards,
Li=E2=80=8B


