Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE453DE43D
	for <linux-api@vger.kernel.org>; Mon, 27 Jul 2026 10:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785147800; cv=none; b=cbSvrX5J00UQrdi8sA9DWswrjPiLEftcqiL6ddkdV3Hwu/bGN5QYfEJFtrCBKMoi4Yu7OUt1S91j7zuxVb4TM3NQa+W9+WltmmjIi1GU8LZarbMh6WynkWQ0Kh0zBrmR9m26AA+WV9KlnBQzjx6KkDyoQapIcIeNSdHALYgcO7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785147800; c=relaxed/simple;
	bh=ySLRE49fqjCghjhGTQCgjjUKLeszyf+kItNvV97jGWk=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=qC0OMd9IL7oiK/WGzxSL1ZIzkQgI1IuX0rBRXOrHjt/wSSp+jzOC8AepZoPW5g6XweKOJz1pGlR3D1KA20CigjQLRMnlwS+u1bLeoTRQOJG6uBNVEQ3wkNUuEATVbISQZuVEN65M77+YmVYkF6TGdDFVB2YxT5q/xv80JsN8o/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=n3RZuFHF; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="n3RZuFHF"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e533aacf2so130335985a.2
        for <linux-api@vger.kernel.org>; Mon, 27 Jul 2026 03:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1785147798; x=1785752598; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DVZKW/HowHh3JkNN7GvaevWwLFJTPxZKAxBSNREob2s=;
        b=n3RZuFHFoX8306qXYXZTJp6f8uIt0OxGBpWRJ35tZjlslID8evejPeYmVhpFlelXh8
         8+pOCIEhREOj6/kyGf4h8jpOrNdREzJ2XiflS9AE7CMBXLKfiQsj/9PPqZYLOnv/Rlbp
         4t3viLVb+6aOhUevMfuU+r2HY4a60QFcDct0ki8n64WY8dqBLlfO/eaYrT8KNMnNVf9n
         ZDs1cO/yQFp93mcqbWhfOP8ZJugETmcSQlgAezE3pUQlMhxm72rXkjnR//sySO/lV+5/
         o9xNWQlcfqE8wAiqEOrm/DEFg2SiqHeOC3a6LZS/4PVkHxGqdtGlKr4txM16pTw174Om
         099w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785147798; x=1785752598;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DVZKW/HowHh3JkNN7GvaevWwLFJTPxZKAxBSNREob2s=;
        b=OsPwNSOId3WAO9c3H1HuxMjMYa6CVZK2En/19rWHT0PKUuzZoyB+tovCcltsr8X4ql
         mE1fssMDTdnXG+6kC3OFuxxsSKADmW0lUfR8dL0q/I6HX1mz9BXSL8Mrg1oBnF/NP7Vc
         rlFKNQpEI49fmeL/Pi+TRP2iX0ShW0VG0aCXiFDM0QeUTlppK0OOQ/h5qaS8HLsbJGY6
         tKkUj3Nm4n47K8e0jMf1jj0vDtlcuLWXXGOVfHa9T/+4VkZXpyn63PDBzq5tCMS22gRO
         QwWDFsKldbP+/119nvWCgYLrwoOdzhA2XGHjLsMHy8/FAKbcQEVbEqkLM37LBxFkoGbU
         M4qQ==
X-Forwarded-Encrypted: i=1; AHgh+RryLJqr18wQZT0vGkKkn5AkC+927KVUdXs4fq8Tomd3dltWG3Bb9Umac+G8GorKxMGA177H69BNh9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSLXJ9BdvwkF6r81WI12fg2VskV867Vf0y/hfLUOIwvV/S7eTE
	rDLxuDxMScqZThBz6NnAwtlUuRamw7i8dshWZIglDoS6emipwTi8kxaFi+Ltm0S9Og==
X-Gm-Gg: AR+sD11O+tbcCntmNE045qJb0PWV5V0/ve1VPbIA6XbE3FEVbVSEsl8eIG6S8X28eCI
	gsQqg5oha/nCZY+iueIsT4owD7MQ4b94Zj4hCUzA+hTaBMIkfrbC2ruhK4mVIAWQqX3WyM50kxd
	Z9qvL8Bq0wDgMVePIo1rc5gnRn90cuWx+1raRxizcDm/0saM/PFOnlRaGwphxFN12dwMQv6EjLU
	mrMRuj7q6pLQZdO3BKtkOXD0CQzWQBd1uxbPpmIByn6tNhFcJkVMGQZIU+sF2adSDLOK0rWipLM
	pw7rBcQWE06osteZXE+Qv9N+Om0+S8HAoCuo871lyTcIFKykJmd69ojmdyRDo3Gov2IdKqLdYGy
	KqWGXr5vs0Z3SDRsIaNBueVlYnTRRn+lfOgi9wTadCC8SKxE+wBBIIh3dzhAC7gRhyYgribNhW6
	X0Y2QPqsh/KaIyIZiVf4yoCMCiWEgKmoNL
X-Received: by 2002:a05:620a:40c9:b0:92e:c116:befe with SMTP id af79cd13be357-932df75c595mr851097785a.91.1785147797776;
        Mon, 27 Jul 2026 03:23:17 -0700 (PDT)
Received: from smtpclient.apple ([2600:381:b393:15d8:4c70:7d83:4597:b56a])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e86d499dsm61759276d6.42.2026.07.27.03.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:23:16 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Andy Lutomirski <luto@amacapital.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
Date: Mon, 27 Jul 2026 12:23:04 +0200
Message-Id: <3ECEDA35-17D3-472E-A01D-45584CF46B85@amacapital.net>
References: <20260727-nasen-gezweifelt-weitverbreitet-d6c0d9f5d28b@brauner>
Cc: John Ericson <mail@johnericson.me>, Andy Lutomirski <luto@kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Jann Horn <jannh@google.com>, linux-api <linux-api@vger.kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>,
 Farid Zakaria <farid.m.zakaria@gmail.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc <linux-doc@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>
In-Reply-To: <20260727-nasen-gezweifelt-weitverbreitet-d6c0d9f5d28b@brauner>
To: Christian Brauner <brauner@kernel.org>
X-Mailer: iPhone Mail (23F77)



> On Jul 27, 2026, at 10:59=E2=80=AFAM, Christian Brauner <brauner@kernel.or=
g> wrote:
>=20
> =EF=BB=BFOn 2026-07-27 00:57 -0700, Andy Lutomirski wrote:
>>>> On Jul 27, 2026, at 9:43=E2=80=AFAM, Andy Lutomirski <luto@amacapital.n=
et> wrote:
>>>=20
>>> =EF=BB=BF
>>>>=20
>>>> goes along way to getting Capsicum's "capability mode".
>>>=20
>>> One thing I dislike about this is that it=E2=80=99s (approximately) a ta=
sk mode. Why should an fd representing a capability represent one capability=
 (a subtree) to one task but a different capability (dotdot) in a different t=
ask?  Do we need to prevent unsharing a userns if this bit is set?   Do we w=
ant to have to worry about any task that could potentially SCM_RIGHTS and fd=
 to a task without that bit set? I prefer beneathness being an OFD property.=

>>=20
>> Sigh, I keep thinking and typing OFD, and that won=E2=80=99t magically ma=
ke it
>> be correct.  All these privilege restrictions applied to a file or
>> path reference need to follow every user-controllable reference around
>> correctly.  So if I fchdir or fchroot to a restricted OFD, my cwd or
>> root needs to preserve those restrictions, and reopening "/" or "." or
>> any other path (via root or cwd or openat etc) needs to respect the
>> restrictions as well.  Putting it in struct path may or may not be a
>> good idea.
>=20
> I think making struct path carry more meaning than it does right now
> will cause us endless amounts of subtle issues. I fear that change very
> very much. That will have such a fundamental ripple effect across _all_
> corners of the codebase that I'm very unwilling to be led down that
> road. And I think Al had traditionally similar reservations as me. One
> of the really thorny issues with the O_PATH upgrade masks was precisely
> the struct path modification.
>=20

The alternative (I think) is to enumerate all the places in the kernel that a=
 path (or file?) reference exists and would want to carry various restrictio=
n bits.

I can think of:

Resolution (nameidata?)

struct file

cwd

root

optionally, vfsmount

Is that it? If I open a directory with a no-dotdot restriction, what can I p=
ossibly do with it that needs to respect that restriction?  Each such operat=
ion either needs to respect the restriction or fail outright. fchdir really o=
ught to work. fchroot probably should, too.  We could just not allow clone/m=
ount (at first?).  All the /proc links either start at cwd, root, or a struc=
t file, right?

There are things like overlayfs layers, but failing an attempt to use a rest=
rictive reference to a path as an overlayfs layer doesn=E2=80=99t seem to te=
rrible to me.

I think that, logically, we could create a struct path_restrictions and add i=
t to struct file and two copies to fs_struct.  And we wire it up into nameid=
ata. And we carefully make every operation that doesn=E2=80=99t understand t=
his fail if there are restrictions, which could be some new nameidata flag m=
eaning =E2=80=9CI understand path restrictions=E2=80=9D where any attempt to=
 resolve a path starting at root or cwd or a struct file with restrictions t=
hat doesn=E2=80=99t set that flag will fail immediately without even trying t=
o resolve the path.

My intuition is that the implementation wouldn=E2=80=99t be so bad and that p=
eople could chip away at the unsupported bits that annoy them over time.

=E2=80=94Andy



