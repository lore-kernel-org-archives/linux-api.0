Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795130849;
	b=vRKfAuX/1jKWDKuWUTKADrPxJloP1vVkV9Hj4ATu+7NwFKTo8H8D0tfwtrlh5nnD7zrp
	 VAfgLobIdF7wLQBc4A12UUYbM8MMHMU4uxvfvZNV8g+WzrmzfpMitIE0sApll4G2nsmAy
	 ZBmknE5P8ZTgqV1A+Imfx3UVJY8NmHkDqgJlwICDGr6863QBsAE3FaC/PUt9EMe3dd9dY
	 Q6bDRNUPo/67wVjf8mIA1tc0IwzzAhQQE99MbcOIdAMXxu5eZuAhAMr1cnNLTVuAD9jaw
	 Nrqzu3QafFfje+LYJdCx2kxwbjn/9kFh9hxvpE/sX8PodD8YwaD+6me8WfhO8SElqCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795130849;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=OQjCXUbscPytTNcthMSXFUhQzfR2m/iC2VTnVjvFUQk=;
	b=TJ8Rp/bMr/o2jvu+HFQLple//Sz0y7NzAxDQGy7PKPNscH4gPCdZgOS+bHzQEHuvK2Nb
	 8lUdwklbwvnWNTr72VYUcZjCOYYQok3+35/OzZRkqNIf5iZw9PGDu3IpT8rzZHhwOvutU
	 B5bxNG4lFFuqhp0N5d+wLA4dnIUm6yWwKckLZ3nFops6/rzHZ4PAnyr724Y1ZsTPxXfMz
	 IdLHDcIgSTtFucBFXBk32KGFgJGpaOnYzWKkGJGOogChEtlL1tyt/l8R3EQJ8J1bYJ+wG
	 jJzMIxap4fKQivFdDFQpB9hxU6+CcmF398XgPqDxY3267iBnO2YAo5dD0PGaIb/vhpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hjX4t2Xo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61004606A331
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 23:27:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61004606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hjX4t2Xo
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5c1593fd141so228317e87.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 15:27:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795130847; cv=none;
        d=google.com; s=arc-20260327;
        b=U5X9y5s4E/NwfGS4N7I5UrveGYoKiiVIzP/jZEr587UMdXG7q19ToqjqS8t4b/aG6T
         FFM22Nqcg0HL5r0M0LzrhcDTktmpyPmhaIsaxwziVj7Y54IQql6Ih/Wh6P46w0ML3wkV
         lpsSTKrvgeCkKvdV2822+pwrINqd4DxBVXXwddkxr9MjpiDCYd3hBb/GDOw5JhPNVKTA
         dTnYajhTdB9d/ge+svojnED7S03SikpFFhmth8dpFnE7JIqIJZp70IMqKg0afP39yjRK
         cVxbX2JdDkbc3LO5s8eLNTpRgDHtez/XV9uqw0PcIKyzZ4Erf7wq0WAWt8MWUgYvit70
         HPzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OQjCXUbscPytTNcthMSXFUhQzfR2m/iC2VTnVjvFUQk=;
        fh=EyrOkU5NLOd8HM1YRC/5vqqgZ7kPIzokpRpA/ZSUc2I=;
        b=EAltgj4Yc3RJ888Q2hkyOrJknfZN8w9iPPaefIdsmGNtacYwd+sl5hNBE1FUzi/MJA
         TQnewkCShVFYm6PcYW/wi6/nlr6LhhcqNOgzyj4Fc0n75IkHs5XESzAbsDhwvXjcBmRT
         CtxDVuNxxSWw5iswoWeNOR1PXmphlA3CTDcrvichG0qMFLC+7h26GMR0lirAhd0T1UOf
         Vi10QYQOEqI+StGeng7Jqo3Oms9VeGRWIHa/pjgZcZhNn2gCSlNrY+5RtPA4gxTa7/20
         uhkQVTuiVriM7HNigy15DHw0Bkwt2CIyJ0CfzB9p/B9MZ8Aj3GfQG7wxjpTTDmVbyI+S
         4llA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795130847; x=1795735647; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OQjCXUbscPytTNcthMSXFUhQzfR2m/iC2VTnVjvFUQk=;
        b=hjX4t2Xo0e4RQY2C7GXTldeqYZukwPJ0G0t0eeIIqIxOs+nv/R5cEOi7krUGHcZauR
         vqzkL8y++jDu/is0RF8VMVltWdEd0lyrR1cIBs4FTu4VVQYMJFKG/s1sz43eyqiCcrTX
         Mbg5Ry98V2BB5rY4noROHUppSerOzFFtKwmae0y2na6LMWfxzuzS7JHUleTuTmaHRiow
         9su2Gf++IX3BLOp0vRmJ0CYQlTuqXctSVrAeuH0kMwAL7Ra/++9cvRom3L2AnQl9FlUD
         fl60SeNXa2k2FkgU8xK8tCvQtyjYi99pa5QdP3Pc/FV7HKF68S1o+Utpk9RB7yjgN3SL
         Wk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795130847; x=1795735647;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OQjCXUbscPytTNcthMSXFUhQzfR2m/iC2VTnVjvFUQk=;
        b=jhDs4sW4m/lgfb2sBwqRYsghK+0raCCe/xdsHnMkSbM2FirEwmBamzyx3LSJaqXA3P
         IOnqOxZFXAwPcfQTI4/JL4MSsS29jGHfm6Vm5h3VS/qKCtWJl8tq1M67ySr/B5S6RFkf
         JB3aukBJIuQPBIZNSaycB+VjM6E42mgB1KPRznXwaFeuOySovi3DameLVc2QX3TPlDgb
         i7k//TV9gME0gLpv1Qu68ST7RlDS2h4Lsqoz/eTSVh4xyZhptLth4njx0qP4kdRdQe0B
         A39n+gQi6Z0qxJ3OQLrZA0HZo52wJLmQFaVmlx8d0bqqb+xb1f8k+LC1MitQ8kHueEf/
         BKOg==
X-Forwarded-Encrypted: i=1; AL+hErE0ieTb7WbNyNPomwJlLH3AvK80r2odKI8rMR7Szm5SRT6sFp0KWpXmmC61MBEJiJtnZwfyCq/AU2o=@vger.kernel.org
X-Gm-Message-State: APuU4Z/9xShSJSplvKKWYl4cDWCBjriiGZTNY+RAWDBC3C+UWRhOWuPL
	Jlhv1CXXV4n+wUu0d4QoZg2+42cWp9FfmOMOyJHFZRMdczmetsXsFlzE6FswepBkYV8nTcviYWM
	Fii2omnPGhz7oTzFgdpBgIUjKRXh5+wOdgIbAY7kc
X-Gm-Gg: AYBFou3j0kfVZeBBy6xvrh8769zLgU8u3JyT8F0EJ6B+eVXfrohtdrbBOD8kKflzPap
	dmeaZ/Rt1572bNFQiY9Ys9J7iI428CK/mAOqerd1Fww/zNQS2reLr0SNMiRFaBfVLXFuSUqo9vH
	TFwgoAbXg9u7AU88p0sDuoTkE7Zm/QQ41ATzcLPnAaEft63VUhH+wtFVGI9VHcpSQLaXNRj7fY8
	ZDR154UstFaI5CWlI7KEFyYSwn270n6DROpjwvINkE1Nfajrq1LqLNwtEV17W1zI3qSJMljCkNF
	I/AOo9r4J/2jqqzTxP+GhLm/2L5DJ7iX6f5vtxGb5Oqf41IrGWyIrIw2n8UebC+OA4dJDooESVT
	g01uOP4X8MkmmUbmap1PW8UdkPaUEmsI5Pw==
X-Received: by 2002:a05:6512:1194:b0:5bf:b365:d82c with SMTP id
 2adb3069b0e04-5c1bc89ca7dmr310274e87.57.1795130847409; Thu, 19 Nov 2026
 15:27:27 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117231352.3816603-1-jarkko@kernel.org> <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org> <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
 <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com> <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
In-Reply-To: <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 19 Nov 2026 15:27:15 -0800
X-Gm-Features: Aa3M54pRPzoZRQLZtE8vOKLAtvSp1jFKDAaRmJQa_mjsSLqBguq4HCe2_2_ku5M
Message-ID: <CALCETrUbe8rBoxrC+Q66AMsrJ8Fow7xt5KJKRAmobtXBvHWdqg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
To: Josef Bacik <josef@toxicpanda.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, 
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 2:50=E2=80=AFPM Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>
> On Thu, Nov 19, 2026 at 9:30=E2=80=AFAM Josef Bacik <josef@toxicpanda.com=
> wrote:
> >
> > On Wed, Nov 18, 2026 at 9:46 AM Andy Lutomirski <luto@amacapital.net> w=
rote:
> > > cells: The dance where I create an anonymous mountns, mount stuff int=
o
> > > it, and then attach it to the cell is cute.  But I think the userns
> > > interaction is wrong: you are making me assemble all the mounts in
> > > *my* userns and then clone the entire tree into a fresh, non-anonymou=
s
> > > mountns bound to the current userns.  And that clone operation is not
> > > free and serves no actual practical purpose.
> >
> > The copy buys us nothing, agreed.  That's just what the mount API gives
> > me to work with today, it's not something cells wants.  If I could make
> > an empty mount namespace and fill it by fd I'd use that, the "root" slo=
t
> > takes a mount namespace fd already.  Extending the API for that makes
> > sense to me on its own.
> >
> > The mount namespace staying with the builder's userns is on purpose
> > though, that's what keeps the cell from mounting anything no matter wha=
t
> > capabilities it was given.  The builder sets the tree up and hands it
> > over, so the cell only ever has what it was given, and the mount code
> > isn't something it can attack from the inside.
>
> I don't get it.
>
> Using the builder's user namespace means that the contained processes
> can't be ns_capable on mntns->userns.  But this solves very few
> problems unless you also deny the contained processes the ability to
> unshare userns and make a new mountns, and if you can do that, surely
> you can also deny the ability to modify the mount namespace.
>
> As just one example, a mount namespace could have a little flag to say
> that it's *in* one userns but its owner is a different userns.
>
> >
> > > cells: I find it *incredibly annoying* that one generally cannot put
> > > new mounts into an existing container using most existing container
> > > managers.  I hit this on a surprisingly regular basis.  You seem to b=
e
> > > baking this into the whole cells design.  Why?
> >
> > By design.  Allowing changes to a running container is what causes the
> > problems.  If you need another mount, tear it down and build it again.
>
> What problems?

I'll add:

On a non-container Linux system, you can hot-add a removable drive.
On a Linux-hosted VM, you can hot-add all kinds of devices, with or
without the help of the hypervisor.  (The hypervisor can hot-add a
device, and the guest can mount network devices or newly added USB
devices on a port that was already assigned, etc.)

For some reason, on Docker and its sort-of-clones, approximately the
best you can do is rbind in a directory and then mount things into
that directory from outside.  This is sad.

I get that there are plenty of workloads for which this limitation is
reasonable, and there are more workloads for which this limitation is
silly and people have learned to live with it because everyone
imitates Docker and Docker is limited.  But there are also workloads
that I hit on a surprisingly regular basis for which this limitation
is genuinely annoying.

If you want to write a container manager that shares the same
limitation, fine.  But please don't make it into the kernel without a
compelling reason.

(I personally think that Docker has a *lot* of weird properties that
make little sense.  This is just one of them.)
