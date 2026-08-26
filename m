Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [83.166.143.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EDE48381A
	for <linux-api@vger.kernel.org>; Wed, 26 Aug 2026 20:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787775816; cv=none; b=imd2HgXiG6iGI5uI6LGGlSmS5tFbJ8EYFtzJuX6jpe6IX2C+aZjjWTEThyk6NcZn3FfbJ4bFpcuISSilc2z5XxUPswPpFa2NqXzHxRqzV0fXT0+ATz5J/fh41rnQ8g23UGNZ/0DrX2QYnYyX7E8gHXMGDwq0qCl1+sDNsiW6V+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787775816; c=relaxed/simple;
	bh=RB9TzG0Q1eRtmVhwIJQ6ZaQRLJ+sLLM+rx40gMOiRKg=;
	h=Subject:Message-ID:Date:From:To:Cc:MIME-Version:Content-Type; b=sCi4fTrPQ91I8GvAggH12lvyOXXtSjHDO8bbiCz95hKdu73p/MHHv8y8MqmlryTcrSvLlifoUcP8h+MJwunlHPOby9hpiywlKkkQ3tfsnobIRypup6/aP7TlMcaqeBbTF6VhHtpz5YnpAISphcri7U/FfLR1UEBdGnQ+P4THAYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ikmail.com; spf=pass smtp.mailfrom=ikmail.com; dkim=pass (1024-bit key) header.d=ikmail.com header.i=@ikmail.com header.b=aNrCOEne; arc=none smtp.client-ip=83.166.143.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ikmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ikmail.com header.i=@ikmail.com header.b="aNrCOEne"
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246c])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hVbgx2KJlzKQK;
	Wed, 26 Aug 2026 22:23:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ikmail.com;
	s=20210927; t=1787775805;
	bh=RB9TzG0Q1eRtmVhwIJQ6ZaQRLJ+sLLM+rx40gMOiRKg=;
	h=Subject:Date:From:To:Cc:Reply-To:From;
	b=aNrCOEnemcvGX4jYAAzyMN9TrGs2RaJ6IhsCB+Bg2iPDIZLXd6qTKnrutv2Q9viIT
	 MyeEyIsTXzsDhi5IIvWc9LNAxnAJd9ptgAHW8wVSQ5e69r0kvYYV95tLiLdtEIjWyk
	 x8xcKzTl/RJn74AZLUyiMdzXARSMHGUWElsP4DHw=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4hVbgw69kMzT8t;
	Wed, 26 Aug 2026 22:23:24 +0200 (CEST)
Subject: [RFC] statx: Define a generic OFFLINE file attribute
Message-ID: <e06bdbf8-3727-425c-9a82-150848613a6b@mail.infomaniak.com>
Date: Wed, 26 Aug 2026 22:23:24 +0200
From: Lukas Mathis <lukas.mathis@ikmail.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Reply-To: Lukas Mathis <lukas.mathis@ikmail.com>
X-WS-Location: eJxzKUpMKykGAAfpAmU-
X-Mailer: Infomaniak Workspace (1.3.1341)
X-WS-User-Origin: eyJpdiI6ImJ5Q1M4RDNzU1FtY25vRFE1R08xK3c9PSIsInZhbHVlIjoiTDFjN1NYWGZBZTJVQjViSHovYmtFdz09IiwibWFjIjoiZjliNDk2ODEyZTNiMzc4MDMzMzY0MzBiZDljNGJmZmQyMzAyNDRkODI3MDJiNjFjMDRiMDhmOTBjYzk2MjMyOSIsInRhZyI6IiJ9
X-WS-User-Mbox: eyJpdiI6InpxQWd4dVB4Wkk1U0o5ZFpMSkpCa3c9PSIsInZhbHVlIjoiNmF3N0JrbW9XVGgxK2RIQ3F6ajhWQT09IiwibWFjIjoiOTQ2OWI3MWZjYjcwMWM3YzgzMTVmNzhmYzM5YzA4NDQ3YjFkMGU4M2Y2ZTI2MDBjZjhmNjRkY2E0ODdlMTI2MCIsInRhZyI6IiJ9
X-WS-LOCALE: de_DE
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Feedback-ID: :925ebc4067698a7:ham:e9714dfc98c1edc
X-Infomaniak-Routing: alpha

Background:
During the 2024 discussion on additional statx() attributes, the introducti=
on of a generic STATX_ATTR_OFFLINE attribute was proposed and discussed as =
a potentially useful cross-filesystem property. The discussion highlighted =
use cases in HSM systems, network filesystems, and userspace tools that nee=
d to distinguish fully available files from files whose content is not imme=
diately accessible.

Since then, Linux has gained support for pre-content access notifications t=
hrough FAN_PRE_ACCESS, which provides a mechanism for userspace to supply f=
ile data before read access proceeds. This addresses a significant part of =
the data access path for content that is not immediately available locally.

However, userspace still lacks a standardized way to determine whether a fi=
le's contents are currently available without triggering access.

This RFC revisits the earlier discussion and proposes a minimal and filesys=
tem-agnostic solution.

Problem Statement:
Today, userspace applications can determine many file properties through st=
atx(), but there is no generic mechanism to discover whether file content i=
s immediately available.

As a result:
General-purpose tools cannot distinguish between available and unavailable =
file content.
Filesystems may implement similar semantics differently.
Userspace software lacks a common API for querying content availability.
The recently introduced pre-content access infrastructure can hydrate conte=
nt when accessed, but applications cannot discover the state beforehand.
Proposal

Introduce a new statx() attribute:
STATX_ATTR_OFFLINE

Semantic definition
A file marked with STATX_ATTR_OFFLINE satisfies the following condition:

The file's metadata is available, but the file's content is not currently g=
uaranteed to be immediately accessible without additional retrieval, restor=
ation, hydration, or staging work.

This definition intentionally avoids any assumptions regarding:
- storage technology
- retrieval mechanism
- userspace implementation
- caching policy
- filesystem type

The attribute describes the current availability of file content and nothin=
g more.

Intended Usage:
Examples of applications that may benefit from a standardized OFFLINE attri=
bute include:

- search tools
- backup software
- indexing services
- archiving software
- HSM implementations
- filesystem management utilities

Example:
statx file.dat

could return:
Attributes OFFLINE

allowing userspace applications to make informed decisions before opening t=
he file.

Non-Goals:
This proposal does not attempt to standardize:
- synchronization status
- upload status
- conflict states
- caching policies
- retention policies
- provider-specific metadata
- graphical user interface behavior

In particular, this RFC intentionally does not propose attributes such as:
- PINNED
- SYNC_PENDING
- ERROR

as these describe userspace policy decisions rather than generic filesystem=
 content availability.

The proposed attribute only answers one question:

Is the file content currently offline?

Filesystem Support

Filesystems may expose STATX_ATTR_OFFLINE if they can reliably determine th=
at file data is not immediately available.

Implementation details remain filesystem specific.

A filesystem may map the attribute to:

- persistent inode flags
- internal metadata
- remote state information
- HSM state information

The RFC intentionally does not mandate how the state is stored.

Relationship to Existing Work

This proposal is intended as a direct continuation of the 2024 STATX_ATTR_O=
FFLINE discussion and follows the same general direction suggested there. T=
he goal is not to introduce a new subsystem but to define a common userspac=
e-visible semantic that can be implemented across filesystems and consumed =
by generic tools.

The proposal is complementary to the recently introduced pre-content access=
 infrastructure (FAN_PRE_ACCESS). While FAN_PRE_ACCESS addresses content re=
trieval before access, STATX_ATTR_OFFLINE provides a mechanism for userspac=
e to determine content availability before attempting access.

Request for Feedback

Is the proposed semantic definition sufficiently generic?

This RFC intentionally focuses on a single, narrowly scoped semantic proper=
ty in order to maximize reuse across filesystems and userspace tools while =
minimizing policy decisions in the kernel.
