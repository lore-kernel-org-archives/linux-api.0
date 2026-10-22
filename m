Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792693715;
	b=4DoEiVaaIXvKTvKRj1U55SKquHzcrJ5Q6d1lO5mg/8xBR1CvZawSWuDZb+j4x9MynoJs
	 ICLKtzv6ZVze2jpGorPMPV1Cu+tCtBE63dupEb9sjUzVmmFwmfbzBjtj0zQCx0DBQdN48
	 BM/DMZzyEEPxHEr714/ZcNjoC9hI6Wthkra5vuASDfG9sJFd6z7N0xTGOc19B26wWlkgD
	 NmfP1nwd5gU5UqGGeYbVDEb/+h6kWyg3v3/7ZXK7IaXbpDJ73NpTegSeWjz9r/0zVuth7
	 7MDjkAisRnZyCJxfmiDWfOYufkFTSyHCZsI3J1B4tmvwtVh0ZAhGenAAEytbZYvh9cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693715;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=JYh+FSmeD5zBdSGmLXfoWsuKx9ehvUO73Rr6qnSc3X8=;
	b=nwPzJ1MHqQm7TJ31wYTVccJA4ItixRSHLmuWL+tUeUwHF00z0tgT4FJiXFncBfEVV4M0
	 tp7eD8jFvTTVg4YaPcyTipsLdgkdKUINJeCbPkwyavNRvHYiJCbWVNrQwoMKJZu6SorFA
	 VhDSY4/EHnwZ5/WZULEzEb8TEe0PkSc+T/BV32tpXcBQgRHZh/rdaF5L2aMjX+9a+ynzw
	 inwSqk1Zrs3K87gZ/1SOigUfvLkG1o1Oz4A7zY104wbhLGHzjxayOnaaoFd7vIaefFEsz
	 vmfdJD7wbCPh0lEBTmAVtox6k0gdWYEBEJkGN+p/5JTt7nkg8vUwuJTN8qDDzRsFMYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=FB4rIzmo;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8578606A319
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 18:28:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8578606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=FB4rIzmo
Received: from macsyma.thunk.org (pool-108-26-156-23.bstnma.fios.verizon.net [108.26.156.23])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69MIRtlq008340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 14:27:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1792693680; bh=JYh+FSmeD5zBdSGmLXfoWsuKx9ehvUO73Rr6qnSc3X8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=FB4rIzmodCuc/ai76PzcPn8NKTCLCBgJQn5lG4OsNurD082LpzxvtWFDvX0WpozMi
	 G5Wxrp5EKZivFppsyR/34R27Liveb8SHZHVPaUoS8ZK0SZqi5QIowbJZ3A3OxbM4VC
	 T6wusZBLcMx4TA37NCtnpi9VcygARe/ydMqEQL+dUU2EOTWaGTS6Vg7HOcXefp/15T
	 d7nP4c/UgU10vdDcWJP9aCfO9onPi6Wq2o/TdsUsdoFN9dfgwzIj5Cp6zqZxHaVWNY
	 x9vDg8JooiFE5P2IxXk6tkIe6BLRPcasmFTfgbGaiWHz4u1SVqCZ6O7DWx0DCQCJGP
	 /VtU8vRIAggOg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 96FCB22114B9; Thu, 22 Oct 2026 14:26:55 -0400 (EDT)
Date: Thu, 22 Oct 2026 14:26:55 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Jan Koester <jan.koester@tuxist.de>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, netdev@vger.kernel.org,
        audit@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/41] UUID and GUID user and group ids (*_r
 system calls)
Message-ID: <atpNJINlFhQ0M3Y6@mit.edu>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <018ca365-ce9b-424c-b600-bd9c8aefc9a1@schaufler-ca.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <018ca365-ce9b-424c-b600-bd9c8aefc9a1@schaufler-ca.com>

On Thu, Oct 22, 2026 at 10:00:16AM -0500, Casey Schaufler wrote:
> 
> I can't see this being acceptable for a variety of reasons, including
> but not limited to performance and configuration complexity. It's a
> general solution for a special case or two, and the impact is significant.

Yeah. I agree it's a non-starter.  For one thing, it requires
replacing every single system call which uses a 32-bit uid or gid ---
either as an input parameter, a return value, or in a structure, such
as, "struct stat".  It also requires making breaking changes into
on-disk file formats that use a uid --- for example, /etc/passwd,
/etc/group, utmp/wtmp, etc.  If it will also break compatibility with
remote file systems that don't use a Windows SID --- e.g., nfsv3, AFS,
etc.  And that's before we even get to breaking things like tar files, etc.

I'll also note that customers that are most likely to need to use the
abominationm of Windows SIDs are also those that are likely to be
using proprietary third party binaries --- you know, silly things like
SAP R/3, Oracle Enterprise Database, db2, etc.  And if you use Windows
SIDs as user id's in your /etc/passwd, then binaries that are still
using the traditional system calls will get the overflow 32-bit number
--- and break.

I suspect it will be much more useful to simply add a supplementary
user id and group id which is only used by those file systems that
*care* about Windows SID's, and assume that everything else will use
true, traditional Unix uids and gids.  I also suspect that we should
be stashing the supplementary id's as extended attributes for the file
systems.  That way we can much more quickly and easily add support to
ext4, xfs, btrfs, etc., as file systems that can be used as backing
stores for NFSv4 and CIFS for those (few) environments that care about
Windows SID's.

						- Ted

P.S., From my perspective, Windows SID's are actually the legacy
ID's. especially as more and more people flee Microslop's Windows 11
and moving to Linux and MacOS.  :-)
