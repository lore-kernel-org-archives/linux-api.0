Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F159A3D3CED
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 23:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792195087; cv=none; b=KaWg+rWG95lkN/Jt4pdrAFt8zCjepS8h87e1xZRRKhNjhqEVKjaqmVf4PDSgPut8ODCCZp6nKCV5B89ja+BNScE6K2pkxduuIlDAfi9+pkPkYFfXUT16dBwe90WdrxlehihdsKPs2GdpbI/baccPuR+ARzsrDogx/yRE7M5tikU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792195087; c=relaxed/simple;
	bh=Sol7b/YHIC7fBZ3r1UNj405eVEsThuaewoMzP6GaWnY=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=Nb6xHl+/is9hZNA197fRhELS1wfjScK/dmPzv90cyPGYZn4y0lxZsScd0T7adOGzVCdTs5uh02KuHy/QCgOJVI1qvFHTSHvP/ktPq7TXCami8dp+gbK+4zPc4l3fRdQAlwO6EcLd8IXy8ZZryQ1HZ+m6Q2B4rMZoe7VfJrI0IS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=ulsBXqxM; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="ulsBXqxM"
X-KPN-MessageId: 6aa0dac5-c9bd-11f1-bfc1-00505699b430
Received: from mta.kpnmail.nl (unknown [10.31.161.188])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 6aa0dac5-c9bd-11f1-bfc1-00505699b430;
	Sat, 17 Oct 2026 01:58:00 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 6a9f658b-c9bd-11f1-ac19-00505699693e;
	Sat, 17 Oct 2026 01:58:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=nP905omsFDEXnfiXjNt86xtCsoYoZxyqyX9+gdjuAdU=;
	b=ulsBXqxMEkKXsns1ECCv5AxFghkyHl2HTQGrLPX8zAXOsxllIlMbeQMeigZgghOt+f/MeCMCwmlAL
	 HuUzxAaBiucl5xoXzdtw1vCYdIpD18fg1vfLn7JOVnq75AkxOu8F+V6qn22jES2F7iggK3nsK2n6Uh
	 RbUO6Xc9R+4Aipt1mn+V94awoDZPc0T3bRFST2jaGLX/cmLv6Tr5cXDPVogss447QLXeMn43jP9Het
	 U8M5OFlZnIPrOp0PPH2TVt1Ktk5cjIyWMDrJunx5K05Jz5dSldnfy95IdQPweFTlL1mBdGKcyiDxUs
	 R+/zjPqOPBIYVffYmBnOuCrvl1k+HXA==
X-KPN-MID: 33|4KkrTwsmvmLPOjDbP8/4VvjI5Egql+PqJfiQryUT8cMhNzTGJUqLK422dFR66ox
 TYPYn83v2Xzepu18SFQsr4uN+h4W2PfTRxOc6N9g5LOk=
X-CMASSUN: 33|V02M0cnroX7SueAXwXU36SMJsDpH0uyW++JyHN9fUXFj+hzmu1qcBwgy6fsTQRc
 vC7lcEr8X1+WO5p3WZGGBiw==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh04 (cpxoxapps-mh04.personalcloud.so.kpn.org [10.128.135.210])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 6a92e50e-c9bd-11f1-8edd-00505699eff2;
	Sat, 17 Oct 2026 01:57:59 +0200 (CEST)
Date: Sat, 17 Oct 2026 01:57:59 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>
Message-ID: <2059185467.1255949.1792195079917@kpc.webmail.kpnmail.nl>
In-Reply-To: <2026101626-idealist-overshoot-26d6@gregkh>
References: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
 <20261016143806.2946578-8-jkoolstra@xs4all.nl>
 <2026101626-idealist-overshoot-26d6@gregkh>
Subject: Re: [PATCH v7 07/12] kernfs: hold kernfs_iattr_rwsem when
 initializing a new inode
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal


> Op 16-10-2026 10:50 EDT schreef Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> 
>  
> On Fri, Oct 16, 2026 at 04:38:01PM +0200, Jori Koolstra wrote:
> > kernfs_refresh_inode() copies the uid, gid, timestamps and nlink of a
> > kernfs_node into its VFS inode. Since commit 9caf69614225 ("kernfs:
> > Introduce separate rwsem to protect inode attributes.") these are
> > protected by kernfs_iattr_rwsem.
> > 
> > kernfs_init_inode() calls kernfs_refresh_inode(), but was not converted.
> > Its callers in turn hold kernfs_rwsem (kernfs_iop_lookup(),
> > kernfs_fill_super()) or no lock at all (__kernfs_fh_to_dentry()),
> > neither of which excludes a concurrent
> > kernfs_setattr()/kernfs_iop_setattr().
> > 
> > Take kernfs_iattr_rwsem for reading around the refresh in
> > kernfs_init_inode(). This nests inside kernfs_rwsem, which matches
> > kernfs_link_sibling() and kernfs_unlink_sibling().
> > 
> > Also, kernfs_get_inode() then does not need to hold kernfs_rwsem, so
> > drop it from kernfs_fill_super().
> 
> Oh, nice, this fixes the issue of kernfs not keeping the inode like we
> talked about at LPC?  Can't argue with this tiny patch, nice work!

No, that part is included in the patch following this one. This is a bit of
preliminary work to fix the locking around kernfs_refresh_inode(). I think the
memory requirement for the allocated inodes is not a blocker (but you judge, since
you told me that's the primary concern here). The inode allocation only happens
for userspace mkdir(2) calls afaict, and then you probably want to do a lookuo
anyway.

I see there's some work by a Meta team on kernfs. Since I'm in that code now
I'll try to review that soon.

Enjoy the weekend!
Jori.

> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
