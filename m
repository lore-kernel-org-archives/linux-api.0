Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793764957;
	b=AwObqz9HHeSQ3LYSbIuEbONb2TdcDaVvAJa5f2ZwTc6H6ew1RdRpcGqK5643k6RIv8Hb
	 AexD/ufZ4YDwoFNLYBdjgdI/ilMKbwpft6r1bWDXilcquOOBoNZOH6FG3gwx+fIdFPN95
	 ftVeQS9neId+S4LFCz/o67/r/TIqnE2m54k64POsguWn5Rrrtr8fjl7QSruo5t2zRHjzw
	 99GqFG5qunOwYQPjacD8AvWWFEaRcQY4L6S8nQ1U2T3NL03juDRtVZW5yjq+Z1zwOvNeQ
	 p8JrGZXx2VyyQpD2lnV++7KPMFQATwTDBSSVP7H44daEWw5LSJfTiUkdfS+8104xYKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793764957;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=hfsn3svuSn2UYUgGkIHtdaxh7qZRWlSurHoCxB6ikgI=;
	b=csTUL+UKj+sAB12g11uItGm+aKg5J4ZSI+rXBJrmuwpj1FnS4ydzRYPhNpTtz4kGsuc1
	 lQ+lal+oH9w2K3/8SRB3FxbX99Ppmx3vDi7yg5KuemYhuCWJkE+gtKGH18EBi/IrfKm6z
	 Ij9f9sU+4/wSDa8ltBXJtvZg8c9gPAxINkpk2oGflLxlmeS0FZeZ822kWOvaStB+/qeke
	 uSqpLxI0pth/xCcHYK0HQUYI3scWVdx+r0Ap19b3IgiviMfHjWbWY90Q/JwoX3KOxEZKa
	 Ha8aiWPsOcJEHKKWiZCWuavtrjgTH5+c006XWdR5b8YQBiOSkub4y61UCQKyXb+1dPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.47
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8302606A326
	for <linux-api@vger.kernel.org>; Wed,  4 Nov 2026 04:02:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8302606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5bfc32574e7so197809e87.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 20:02:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793764945; cv=none;
        d=google.com; s=arc-20260327;
        b=sLs0ALgGNIoNFcoIYkGs9CX2J8JOZDC7tZK6E5tZsfBmQtjnQeLPGgQ9zVQz3DSxPb
         5e3rctBvfu8ZH3AZNuNezJE9z+5lkJGRiFTf1SVjAf5K7WsWSEk6UTGXg7tHWDworPRG
         XN0/GGc8jrfcdZEATkVm6ZIXdgg1P7X1ahEWDaZSkuyAcMzKQcL1HzZFCseiHi19Bj9O
         iH1qHB97QccPF+bel2hSRPiTEc67h/Z/+762NQS/p+IH5Pn3SShlMsNeLYix1qAqxI/5
         cQ3y/SaK7XvzvqQFhy36+M8zgluG74c1WFTatOjrgJrI2dfWhSFui+ka4mh3txbgiDWp
         SGVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hfsn3svuSn2UYUgGkIHtdaxh7qZRWlSurHoCxB6ikgI=;
        fh=S4wwpdxn/Ov6AL4ugRjy8d7z0F8khf23AkqkuK6VML4=;
        b=n6E8p38GLE/Ko7JElBoMQKZ1iUQxyGYo7+a1BGmTPWj43hXkH1WLh+4PC8sxd0M93w
         d8j2jkfv4JlhOl+2m/pDeultTxxPna4zFw/yupXnyjFsCfvZwUOZlZa9UR+zYUGTQhTh
         kCAyF55g8tFx6BcF80HKfWBVzX68nOBDAMlQ7ET2FnIWGgFyHsCkHxTrHSFUQbaIB5aI
         3qf6GOW358S5XUexG+YRXrGpFWBN7O4vaNeacnHy6EddoJ4i8wKvUkFZaotwiwB88O2s
         U4O0HMKO/yTpb46OD/gvnvSEWcXa5vdCouDJeGMn5I2x8kSLRTbGx4jhH3z+1tQXy1Li
         5B1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793764945; x=1794369745; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hfsn3svuSn2UYUgGkIHtdaxh7qZRWlSurHoCxB6ikgI=;
        b=H+fmLhXrrkvfDZlWGVHCS/Xgt2ts+HiINeDRjYU1tILKj4uC4FJWvAcHvWxaMOjN23
         D5Gp20WTldXu0tgiNi3OmQ01yoQ/iHN/u95HiOGxM/0mhlJ9XmSDGdMaANAeZER/z8hl
         lGSVn+So/FYWt475DaUOq1ZKlWEURGFfAgN+HKviE9prJCdcEDqocgPIPtR982x1NkmE
         4biZpz1IXWJI32RBxS1TqyQYdpD96O7zfx4wr1NGpzTgyzmNlbr47MLimxivOdoGFygG
         SIL+6Hft1ckhBa7AjBoL1PHXT6Y3VsgLZZYDHnVZ1bRt0zHa6frtr4PHhKHEnJwpV01C
         dMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793764945; x=1794369745;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hfsn3svuSn2UYUgGkIHtdaxh7qZRWlSurHoCxB6ikgI=;
        b=MNDFkW5EARciejywDOClQNuqQnD++X/5qDhynA7FSxMM99eQ498QrKLbKfngcrRsrU
         fl22IDzzyVYh3f9Q0kxAsOLD/Q+p60Vr72AILWI4fvsmXgUaLt56GX0W4HwMBIEkseg9
         k/fQQuHZIg1zzuPCoKZLoRv9MPaeNO/wDHc8jq25sK+WQsvlw5QPHLAIy8d+XB/kCq4X
         98omkKXII2gd0rBS/3ze8bbLo7/C0p7VOaZXQ/sFQaarSeo9sUP8pDVhnJeaM9szb//4
         0tvaCei29tjST/1kdZh1Nw0OX0WNqE4fFL8DcggbOpPhXtT8mCU+LBmF6jaHPFzjEeO9
         eWjw==
X-Forwarded-Encrypted: i=1; AKwUvBwjnEBDP7CJJ5cKHOLAKTPJumI5MYWyG6HL7N2GLnVDQ2FTSeER7TuU6tJNGwUM2QD6pAElh5w0/Ts=@vger.kernel.org
X-Gm-Message-State: APuU4Z9AtSimy5fdFLiAiiK4ARB0AA1BkhR8yk/mIdeQsaxJyNKvW40s
	AiloDBmAX4ck5EZThTNSbj/yHZ0VqZJtR73rVxHXzTMe5oOC7JLHq3yRsm21bh+X4dFh42C4Egp
	X05aS6BF/Q1PAQhkl2VIxgBAta324adYd0r9+7kq0
X-Gm-Gg: AYBFou3ZyntgloG7SyzvCjl2Sflb/rSW9wW7eN5vlkOq/yQCHbdZcJU5gHZCjEaK9gE
	Hy0ffhUY4vj1nTYtngYGBjTfxHUCBjACMswZxTUHpC8uvzZZmUTGrdD4BpxMj+7FZ4igtLlhkYG
	BhEmLdPpMXIjnem0zp6LLF2l/I/tjEYEArPzmCNtQzKpiEeCvvA33GZjR6IiI2M9OYql7v90cNs
	FzhTycJRZYXhzaWpzweTH17vY0b8YmXLjXtkWxh5qzhIcSuraw9kGTdGA3lfcsvs2sR+wlC3vWb
	quep0sppxfaBwvCr44qiz8/2UO4tNSK+53GNePCSKhIkQZpCVlvDmiOal1lUAT90mNOf1TKQ886
	RrgVRP777s1zhHFzriDRFG/meFGIhUe5b9A==
X-Received: by 2002:a05:6512:3599:b0:5bf:d226:a231 with SMTP id
 2adb3069b0e04-5bfd226a2bdmr3558911e87.18.1793764944982; Tue, 03 Nov 2026
 20:02:24 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CALCETrWDJKr=LMzfPjwwRRuKapFKQ_OaYF6qYz-9Cs91xAXUgA@mail.gmail.com>
 <87se1hclmb.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87se1hclmb.fsf@email.froward.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Nov 2026 20:02:12 -0800
X-Gm-Features: AclHuK8Rq1ure5jrSqU1h7Ma_hUjTZc0HgFdGOQhHoCimQVJ-46MEYCIww-2oPs
Message-ID: <CALCETrXnZVq4pcmo=2T2S=yzWuj9Q5tvrpuZTXzU4ptHCDnjBA@mail.gmail.com>
Subject: Re: Accidental mountns/tmpfs API break from 2016?
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 7:37=E2=80=AFPM Eric W. Biederman <ebiederm@xmission=
.com> wrote:
>
> Andy Lutomirski <luto@amacapital.net> writes:
>
> > Hi-
> >
> > I (well, an LLM following my rather explicit instructions) just wrote
> > a little tool to make a tmpfs as an unprivileged user: it unshares
> > userns and mountns, makes a tmpfs, fchdirs to it, and prints
> > /proc/PID/cwd to stdout.  Full source below.
> >
> > I was a bit surprised that trying to create anything in the tmpfs did
> > not work without a uid_map and gid_map.  It looks like it came from:
> >
> > commit 036d523641c66bef713042894a17f4335f199e49
> > Author: Eric W. Biederman <ebiederm@xmission.com>
> > Date:   Fri Jul 1 12:52:06 2016 -0500
> >
> >     vfs: Don't create inodes with a uid or gid unknown to the vfs
> >
> >     It is expected that filesystems can not represent uids and gids fro=
m
> >     outside of their user namespace.  Keep things simple by not even
> >     trying to create filesystem nodes with non-sense uids and gids.
> >
> >     Acked-by: Seth Forshee <seth.forshee@canonical.com>
> >     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >
> >
> > Now my tool won't actually run on a pre-2016 kernel due to use of
> > fsopen, and I'm not about to say that a decade-old commit broke my ABI
> > and needs to be reverted.  But I am rather curious whether this rule
> > actually makes sense.
>
> I am pretty certain it was deliberate at the time.
>
> > I'm not creating an idmapped mount, and I'm
> > using tmpfs, which could not care less about the mapping as far as I
> > know.
> >
> > Would it make sense to only enforce this for filesystems that care?
>
> Interesting question.  You are in a user namespace.  You are
> running as a user that does not exist in your user namespace.
> You want to create files.
>
> You can map a that single uid and gid without privileges.
> So there is no hardship in getting a uid and gid in your user namespace.
>
> Is it just the extra bit of code to perform that write that is the
> problem?
>
> Why would you want to be able to create files as a owned by a user
> from another user namespace?  Even if you created them reading them
> would show an 0xfffe the invalid uid/gid.  I think there are then
> some difficulties in using those files as well.
>
> Why would you want to do much of anything as without having a
> properly setup uid or gid?

Hah, you haven't quite figured out the ridiculous thing I'm doing. :)
What I want is a temporary tmpfs that I can create as an unprivileged
user.  Linux doesn't let me do that directly, so I'm kludging it.
Shell transcript, edited for clarity:

#### Make a tmpfs, keeping the tool running to keep it alive
$ ./temp_shm &
[1] 34157
/proc/34157/cwd

#### cd to the tmpfs, which references it and keeps it alive
$ cd /proc/34157/cwd

#### Kill the tool, since we're done with it
$ fg
bin/lktool temp_shm     (wd: /workspaces/master)
^C

#### cwd is a working tmpfs!
$ echo "Look a tmpfs!" >some_file

#### and it has no '..', as expected :)
$ cd ..                  # and it has
cd: error retrieving current directory: getcwd: cannot access parent
directories: No such file or directory

This whole workflow runs in the init userns and the init mountns,
which is exactly what I wanted.  And now I have a tmpfs that I can use
to run my test suite unprivileged to test some cool code that *needs*
a tmpfs.  (Yes, I could probably use /dev/shm, but that's messy and I
don't want to.)

I'm not actually banging this out in shell, but I am running literally
the C++ code I posted as a subprocess called by my test harness.

The user creating files is not in the mountns or the userns, by design.

>
> At a quick look tmpfs just uses vfs inodes which use kuid_t and kgid_t
> so it theoretically would be ok.
>
> Still what would be the motivation for supporting something so silly?
>

My test suite! :)

> If there is a good use case I could see it making sense to support it.

I think my use case is excellent.

Seriously, though, I think a *much* nicer solution would be to allow
fsconfig and fsmount to be called by an unprivileged user, at least
for some very limited list of filesystems.

>
> Short of a good use case we are talking about having to support weird
> corner cases that no one really cares about that will just bit-rot.
>
> Note.  You can identity map your original uid and gid, instead of
> mapping your uid and gid 0.

Does the inner uid made a sound if there's no running task to observe it? :=
)

--Andy
