Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [83.166.143.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E6B347FCD
	for <linux-api@vger.kernel.org>; Thu, 27 Aug 2026 19:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787858985; cv=none; b=VcQ3U2phDMtVn7Q0Kh1691RK9YvilgIRCzzlO1a0e8Tl/8+tGYQdThO9iFr9A8PVj0T2p9uaqrr4ztVmVASzLcoSujzvI1ws9aN60XpJblGJyQKUxhy5TySSjJBTvQcVECN/n7KE07S+G8Bpju0TJ3ZXvaIT13SSSjN0aFcgl5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787858985; c=relaxed/simple;
	bh=vlCs3hU/o3QQXNUI1tu9r/P/DX3U2Ia4HzfbgWLpMak=;
	h=Subject:Message-ID:Date:From:To:Cc:References:In-Reply-To:
	 MIME-Version:Content-Type; b=uFmoonedUR53DMAY9OaknZBN6XRR/GQxieanpudlXmKF9ZoaT4N/WS4ph/5UXylyQFst1ZbiJ3KJJLMSkC1KRXok4Y1g8KN9DbKDWHkuDBqigeOYZuF+1XT/tnumja4MPhAABc4XjnuyH6Oy5Zwvj738cPzY8rPQhYyKDKCmYKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ikmail.com; spf=pass smtp.mailfrom=ikmail.com; dkim=pass (1024-bit key) header.d=ikmail.com header.i=@ikmail.com header.b=dWg7CUSD; arc=none smtp.client-ip=83.166.143.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ikmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ikmail.com header.i=@ikmail.com header.b="dWg7CUSD"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hWBRT1kdkzlDk;
	Thu, 27 Aug 2026 21:29:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ikmail.com;
	s=20210927; t=1787858981;
	bh=u6UA2DFmMQiOkWQPPREWb5PeHwV9Yw25wuUksgK97Ds=;
	h=Subject:Date:From:To:Cc:Reply-To:References:In-Reply-To:From;
	b=dWg7CUSDagomi/nFTSxcatYq0dkmLjefVubVo7roJ6c6c8P66sOyJrpgEAUh0mepR
	 k7znoWB8u1NqEjuvf/xJrQZuNpQDpLbDCE3oFITiFIEvYnmrwQPWbaZhplzH2KDjIU
	 /hA9Fv/VOwXL2c4NDGi4LF5AGSyYp1yQI4ESY/mQ=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4hWBRS5pDtzK5W;
	Thu, 27 Aug 2026 21:29:40 +0200 (CEST)
Subject: Re: [RFC] statx: Define a generic OFFLINE file attribute
Message-ID: <29c3a22e-9cf0-4b08-ac22-ccb75f372334@mail.infomaniak.com>
Date: Thu, 27 Aug 2026 21:29:40 +0200
From: Lukas Mathis <lukas.mathis@ikmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Reply-To: Lukas Mathis <lukas.mathis@ikmail.com>
X-WS-Location: eJxzKUpMKykGAAfpAmU-
References: <e06bdbf8-3727-425c-9a82-150848613a6b@mail.infomaniak.com>
 <3F6C9003-B8DE-4CE4-A158-702D29E6CB37@dilger.ca>
In-Reply-To: <3F6C9003-B8DE-4CE4-A158-702D29E6CB37@dilger.ca>
X-Mailer: Infomaniak Workspace (1.3.1342)
X-WS-User-Origin: eyJpdiI6InF0Vy9YN2lCS1hKQTF2UXE5WWVuRHc9PSIsInZhbHVlIjoiYjdENUdES1RCdjlweGQ4TkhwZ3BPQT09IiwibWFjIjoiODk1MjU3MTkyYmJmMTIyMTFmNDdkMzM4NDQxODUyMWI5NzU2ZDkxODlmYTg1ZmE2YzhjZDMwOTA1NGNjZWE3MyIsInRhZyI6IiJ9
X-WS-User-Mbox: eyJpdiI6IlByUlZqM2hsVTNmaXJmdjFweHFKZGc9PSIsInZhbHVlIjoiNjBSZzlWMFNvdStwY3lJRDB3UGZMZz09IiwibWFjIjoiMzg1ZGQ3NDlkODQ4OWI2MzE5N2M5NzYyMDAyZTllMmUyOGEyZDAwYjI0NGM0OWZlOWNiMTIyOWFhMmFmZWEwOSIsInRhZyI6IiJ9
X-WS-LOCALE: de_DE
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Feedback-ID: :58a4a607548b4ca:ham:e9714dfc98c1edc
X-Infomaniak-Routing: alpha

First, I had to figure out exactly what FIEMAP_EXTENT_UNKNOWN is and what i=
t=E2=80=99s intended for. As I understand it, I share the view that the inf=
ormation should always be the same. We=E2=80=99re operating on different le=
vels here, depending on where the information is located. For Sync Services=
, however, it makes sense not to read the explicit blocks every time. It wo=
uld be a clean architectural abstraction.

Cheers, Lukas

On Aug 26, 2026, at 14:23, Lukas Mathis <lukas.mathis@ikmail.com> wrote:

>   =20
>  Background:
>  During the 2024 discussion on additional statx() attributes, the introdu=
ction of a generic STATX_ATTR_OFFLINE attribute was proposed and discussed =
as a potentially useful cross-filesystem property. The discussion highlight=
ed use cases in HSM systems, network filesystems, and userspace tools that =
need to distinguish fully available files from files whose content is not i=
mmediately accessible.
=20
FYI, there is already `FIEMAP_EXTENT_UNKNOWN` which indicates the same info=
rmation,
namely that the file data is inaccessible and cannot be mapped to blocks.

Having a statx() flag pass on the same information seems useful, since it s=
hould be
much lighter weight than calling fiemap to get a single bit of information.=
  However,
it makes sense that if `STATX_ATTR_OFFLINE` is returned for a file then fie=
map
should also consistently return `FIEMAP_EXTENT_UNKNOWN` for that file.

Cheers, Andreas


>    Since then, Linux has gained support for pre-content access notificati=
ons through FAN_PRE_ACCESS, which provides a mechanism for userspace to sup=
ply file data before read access proceeds. This addresses a significant par=
t of the data access path for content that is not immediately available loc=
ally.
> =20
>  However, userspace still lacks a standardized way to determine whether a=
 file's contents are currently available without triggering access.
> =20
>  This RFC revisits the earlier discussion and proposes a minimal and file=
system-agnostic solution.
> =20
>  Problem Statement:
>  Today, userspace applications can determine many file properties through=
 statx(), but there is no generic mechanism to discover whether file conten=
t is immediately available.
> =20
>  As a result:
>  General-purpose tools cannot distinguish between available and unavailab=
le file content.
>  Filesystems may implement similar semantics differently.
>  Userspace software lacks a common API for querying content availability.
>  The recently introduced pre-content access infrastructure can hydrate co=
ntent when accessed, but applications cannot discover the state beforehand.
>  Proposal
> =20
>  Introduce a new statx() attribute:
>  STATX_ATTR_OFFLINE
> =20
>  Semantic definition
>  A file marked with STATX_ATTR_OFFLINE satisfies the following condition:
> =20
>  The file's metadata is available, but the file's content is not currentl=
y guaranteed to be immediately accessible without additional retrieval, res=
toration, hydration, or staging work.
> =20
>  This definition intentionally avoids any assumptions regarding:
>  - storage technology
>  - retrieval mechanism
>  - userspace implementation
>  - caching policy
>  - filesystem type
> =20
>  The attribute describes the current availability of file content and not=
hing more.
> =20
>  Intended Usage:
>  Examples of applications that may benefit from a standardized OFFLINE at=
tribute include:
> =20
>  - search tools
>  - backup software
>  - indexing services
>  - archiving software
>  - HSM implementations
>  - filesystem management utilities
> =20
>  Example:
>  statx file.dat
> =20
>  could return:
>  Attributes OFFLINE
> =20
>  allowing userspace applications to make informed decisions before openin=
g the file.
> =20
>  Non-Goals:
>  This proposal does not attempt to standardize:
>  - synchronization status
>  - upload status
>  - conflict states
>  - caching policies
>  - retention policies
>  - provider-specific metadata
>  - graphical user interface behavior
> =20
>  In particular, this RFC intentionally does not propose attributes such a=
s:
>  - PINNED
>  - SYNC_PENDING
>  - ERROR
> =20
>  as these describe userspace policy decisions rather than generic filesys=
tem content availability.
> =20
>  The proposed attribute only answers one question:
> =20
>  Is the file content currently offline?
> =20
>  Filesystem Support
> =20
>  Filesystems may expose STATX_ATTR_OFFLINE if they can reliably determine=
 that file data is not immediately available.
> =20
>  Implementation details remain filesystem specific.
> =20
>  A filesystem may map the attribute to:
> =20
>  - persistent inode flags
>  - internal metadata
>  - remote state information
>  - HSM state information
> =20
>  The RFC intentionally does not mandate how the state is stored.
> =20
>  Relationship to Existing Work
> =20
>  This proposal is intended as a direct continuation of the 2024 STATX_ATT=
R_OFFLINE discussion and follows the same general direction suggested there=
. The goal is not to introduce a new subsystem but to define a common users=
pace-visible semantic that can be implemented across filesystems and consum=
ed by generic tools.
> =20
>  The proposal is complementary to the recently introduced pre-content acc=
ess infrastructure (FAN_PRE_ACCESS). While FAN_PRE_ACCESS addresses content=
 retrieval before access, STATX_ATTR_OFFLINE provides a mechanism for users=
pace to determine content availability before attempting access.
> =20
>  Request for Feedback
> =20
>  Is the proposed semantic definition sufficiently generic?
> =20
>  This RFC intentionally focuses on a single, narrowly scoped semantic pro=
perty in order to maximize reuse across filesystems and userspace tools whi=
le minimizing policy decisions in the kernel.
> =20
=20

Cheers, Andreas
