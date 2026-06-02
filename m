Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF2A3DB992;
	Tue,  2 Jun 2026 12:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780402080; cv=pass; b=ZxRKpFL689MEwRM1y93fFlO0anmx9tan9NqO0HqrfCAIwCumlMLizf5B1Wbcl2XRVWYZqIX7Pmx3g417/tP6AO9vhGFKEaSgcTHKCLg9DawEEcccsqxp1p0/6IVLoylrOaL+/sC3KfxOPH2rg4oNhEGVHKReB0PN+XgtzykVDek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780402080; c=relaxed/simple;
	bh=JWIi1uV6HWE2nLc6dH198CdYDNMVn3Z0Z2egQXY7/C8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=KUidZidoXVaL1RVlcXYlDQ3Vy8r16HTRTsTHABttZGTIVhcw/K+tJKWKC5o34wsbexbEhg/vtDzMtyUCYcAYDzH5nO6DcxZ8sVOtjJk3vB08Q1WPjZWq0NzNv/N8XRBTMf0jFm6ue6KsW2fMku9jhi6D2Jm7IqWfLSI+FucK5NM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Zlt3oNaR; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Zlt3oNaR"
ARC-Seal: i=1; a=rsa-sha256; t=1780402044; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ax36rWt1feL9QcFuFow0giDSRLuo68Ed+YUirk9L9RDYy5YcpVDvlnz+YDM5f92MgRMhVhOZQkyjDM0qb5fYftyvNVrXDy9dsNcd1+FHcDQOlBHVDmDO4OESlg4SXVguCtxbwSftXL5Ac06bmTfEN4u4M41hclFenHdAukEWlbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1780402044; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Vk7eeniepcURlDwWgLQyxmjRbTq5rFiyu0fmscCWkm4=; 
	b=hZcMijGfu7IeE4PygN1oZx6i45maA3Xjumto6BEFB8C9KC9Z0lClj24hK8CCx9dLqvYDZBCo6nc7+Dn1eRzMXA5yP7NylmEIJe61ow9kicins43ih4aBFbnp/fH5uoQK/8TgKgwwCij+W4H+Ip6ptlZ+PqR+GboIvnh1b2YoTik=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1780402044;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Vk7eeniepcURlDwWgLQyxmjRbTq5rFiyu0fmscCWkm4=;
	b=Zlt3oNaRQWUMWb62kC/65uEnsBoYbSOLSdu5qIGlqqsOfY0rg6uaPABoEEcjQH2L
	MWZPJhxzl72HDznRw3AT+bR9LlTFss5C5Kz76bRbZcRLMZ5rwmRuJ7d2zZX5bmT3UDU
	yQ42a4N+U3udh0jbwnmUpHnDrihBmpCWTDZ8yaBE=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1780402040732884.3207521738933; Tue, 2 Jun 2026 05:07:20 -0700 (PDT)
Date: Tue, 02 Jun 2026 20:07:20 +0800
From: Li Chen <me@linux.beauty>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-api" <linux-api@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"x86" <x86@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>
Message-ID: <19e883b2f84.6134d346323880.1325813164715871999@linux.beauty>
In-Reply-To: <CALCETrXqWcqn_79sMKnkyKOSAjg4AmcSHsuyH83oW8zJFoV6Dw@mail.gmail.com>
References: <20260528095235.2491226-1-me@linux.beauty> <CALCETrXqWcqn_79sMKnkyKOSAjg4AmcSHsuyH83oW8zJFoV6Dw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
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

Hi Andy,

 ---- On Fri, 29 May 2026 02:27:00 +0800  Andy Lutomirski <luto@kernel.org>=
 wrote ---=20
 > On Thu, May 28, 2026 at 2:55=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
 > >
 >=20
 > >
 > > The template pins the executable and denies writes to that file while =
the
 > > template fd is alive,
 >=20
 > Please don't.  *Maybe* detect when it gets modified and clear your cache=
.
 >=20
 > Or develop a generic way to open a new fd that's an immutable view
 > into an existing file such that the fd retains its contents even if
 > the file changes.  (Think a reflink that's not persistent and has no
 > name -- you'll need some way to avoid resource exhaustion.)

 I agree that deny-write is not a good long-term invalidation model. I had
 considered clear-cache-on-modify, but kept this RFC smaller.

 > >
 > > Workload     Calls  subprocess  spawn_template  time_s       Delta
 > > (workers)    calls  calls/s     calls/s         seconds
 > > 1x16         6144      411.04          420.32   14.95/14.62  +2.26%
 > > 2x8          6144      666.78          690.08    9.21/8.90   +3.49%
 > > 4x4          6144      955.61         1003.25    6.43/6.12   +4.99%
 > > 8x2          6144     1048.25         1069.18    5.86/5.75   +2.00%
 >=20
 > This is a lot of complexity in the kernel for a teeny tiny gain.
 >=20
 > I'm with Christian -- a better spawn API would be great (and much
 > faster than fork/vfork + exec), but that's a different patch.
=20
 Thanks, I agree. A pidfd/pidfs spawn builder looks like the much better AP=
I shape.

 The cover letter numbers were from a mixed agent-tool workload. For very s=
hort
 single-tool runs I saw larger wins, about +14% for printf-style work.
 I should have called that out separately.

 I will work toward a pidfd_config-style builder next.

Regards,

Li=E2=80=8B

