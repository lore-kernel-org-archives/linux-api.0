Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A1430569A
	for <linux-api@vger.kernel.org>; Thu,  3 Sep 2026 01:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788399514; cv=pass; b=T7ePMR5ZDPgz7ICSeZtt342J/jB8UYeFXNNIBw2b2oCPKrs3Bk5szNxCQ6gtxyFj39AX6hLswFpg4XC3CbqtoGcWPsG0dXtKVS33QvUTXDzQqmcEI0A+bd10D0FZgbx+7GjiftCV/yFlLsvTDFXMW3uWHQPZVDAuqejPt49AXY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788399514; c=relaxed/simple;
	bh=Az8ML3xziSsQ3jStY9KH6BKlBem4EKxqSIFS0wdqnVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PdQK7lcHHTvCN1M9gkVbP7GnD1zGDv+cDeKVARkomKixl83M3jDIJVPRqIBHmQgI1xoDJUQ/PdEY1buwIxAKKP36+ZvqvIRyqxTqkh7nYOksP04F0kIw3ddjf2MYdSVzv9tqmedxxCFfG6Hi4Dx+3WotRoHPFBparLRzbQi2rZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ieMt5XrW; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ieMt5XrW"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3964dfb5a69so2453064a91.1
        for <linux-api@vger.kernel.org>; Wed, 02 Sep 2026 18:38:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788399512; cv=none;
        d=google.com; s=arc-20260327;
        b=e8Qz/d5DIrxS+Ut7k/+1N6/ImUeL1An5eC17hLHzowLxcV4S6megfE/IKIytqBjKnu
         9a0z2UmNcOu9QXqLpKZI4fSC8VE4XaUqDIRNd6kCkhZ5GGRxlsyuFKDT90OvKwOjNf9g
         vMCQsblnn1vxyPlb4ss016kCWW9VafgEi1yg1o/rTK2jlrDlkL6uYqCIQIFgvUXtaLvb
         qgu0BBuhTpm8U6WShCuvIhzOtTZxIaOcQuf/1HcSnqufXlYQVKBHnM05k+w5tXEYwBl0
         emMSjp9uVD0EeTqyIS206e3hgaCXS+XjeKAOierwRwGaT0nB5K0LGjOuClKnTuNXDxSH
         L5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V64QR1IsR8MyGUl9CMimjz0m+06sJhfAIW6p6kz46nA=;
        fh=IkoQZsivjoFt6L+IIv2wGC/zuQwiUMW/r7vvFYf78+c=;
        b=FhTyt2Al9fq4Wr31/UJovRwOOzX516JeMgsQ7mkaH4lFzg5iushEJ2CTvNjqMvRq69
         xbKrxHJfehBIlTL48ZbpjcHhoFdP3BHGwjWlYoBK8gEQrN8Rd3zDc2E08KB5Ffi6DZlC
         Hh8B1rlPqNRmrdabKcvTLVt+1gTUb+SEkJ7vBbNmdx03lA+j1CbjCIdr4Y3+MxZ9JR6n
         X4Kp8Wr+x67FeMG6G8P0pbm99Kw3OoTVe339JqYUnPLznczORB0fzuY5PBoM3wDvL37B
         +VUabVaaAMxZ7996bO1uMXKBI1BQanCZ1ZrQ0dYcoUMznnWuqkDVY0WpL3gakz6cbDD1
         CHrQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788399512; x=1789004312; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V64QR1IsR8MyGUl9CMimjz0m+06sJhfAIW6p6kz46nA=;
        b=ieMt5XrWd/F2asW2oeONrumun9WGXZFvz32TcoQYBhzLUd9Eous5nDRCsjE1gkIJow
         euZTRZWFfh1FxrazNwawDR2EopRRy9oHytGWh/gperNGNBFMrEygCNVSIY/M8O03STQL
         eH4xRrkIzUObT+5CBkWcSRrg/A8qG4fGUGu9fPS+tuWX+J1Hy2p5Dvq7lGBX750CA7l+
         IN4RmV3hvXc/nVPoY0oc6qpebwGuI3l3JemGo22AowhZclmnZdDEvLNVJ7bi+z7QDCDi
         j3Hgc2lawmfIFkLotCEUhwZur5FI7n/wCNPAUQXa2nvIj1lJugj5MRlCBfoGd+FCzEq7
         nALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788399512; x=1789004312;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V64QR1IsR8MyGUl9CMimjz0m+06sJhfAIW6p6kz46nA=;
        b=SpMAVchQgHyCIF0PxI2QX9qEj3QsLWty3H7m8kso0fcEiLlVgMJh0cQir5/D9w8Yfz
         Y1Bca614JxoXKz5B7rQZ9Bw3BcAx+xUO1RUYKlqZI+O4wrPITlh4etoql0IXuCzmJsjV
         WNuzQJQUOd3ZVH7wDPl1q0UmRdOzmFXwelD1IrDlga5Frivn34OpOcP3w1NRahv3V/2j
         dfJX+NBpFbQxKN5d/PmwIMYGGA5a+YscA7iPrUBTwMG3j6t3+B+L/D0yCMJTmia3yAfn
         cT1pMUMwwlpCZqu5xlpX3G1kAB6HfFX4fFO/DhzP3f1ficMXa2f+wkcgsFfNjm8PKOhY
         mzQQ==
X-Gm-Message-State: AFuF++mgx3nl6vUF/aXm/IGtQUthwPCoM5gOtYuJ5L+oRfvmw6+NVvvk
	tCXUwMTLcsvU4NyBqYlC6objmMttDkOsbli2FA16jQ/2SUyWfQC9yo3rLAf10mY/1UQkxaMBP3X
	auBqG8WU5n1KdpDoOZSMbMv33nFaV3Xcypc5qL7un
X-Gm-Gg: AYBFou36FTqLjCzM23qIxsCfX/Y4YFvT8f+iICblUB916HADB9/WzqPheKnDNrsVbXz
	8lYODx+AdOotppYCkb/VgtZ3tn4XyzmSzBy/M1I0kbx/f9movo5NNy85djjcc3MdawcgSBIVyu4
	OrhJSljSNjwu3E7P5hl2DaZ2gXNxT3a1X/b3U6CAu1cj2hzO1O/SPG/NpoZeLGp80BczR1nA4PT
	LSAJjeUKS28qoSgnPKDe9yPQEElM9/J9lBUkFj+qHiG94M2amY2F09ludDHF8BrCflPb0MseC/W
	RSpoYUDn+dyuFgqPVkmChn16LStbb40P3BnF6fYawRT45ozvvK8MHm+EBi9iSQQgMFER9XLODWX
	FLL/5vcKRF6zrbRjmPaNB0/QvrQNAYm8QCWYHcHh5SpewhBmtpPMsSMFJd78OjYseyEHxtxwAtY
	bhL3afBWNvbVOI
X-Received: by 2002:a17:90b:3fc7:b0:398:9be8:ea69 with SMTP id
 98e67ed59e1d1-39aee251837mr14335412a91.22.1788399511412; Wed, 02 Sep 2026
 18:38:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAE3jtcL0b8YsNiJpcXkUVoZRxFetU9o8z=JVNUCnDXN=seUmg@mail.gmail.com>
In-Reply-To: <CAAE3jtcL0b8YsNiJpcXkUVoZRxFetU9o8z=JVNUCnDXN=seUmg@mail.gmail.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 2 Sep 2026 18:38:18 -0700
X-Gm-Features: AcwNN1V2Dk1ZXSLu1Azh2xjqw6dIZJAN5we8KwxOa0fvJ97gB8WYOupXivWTtro
Message-ID: <CAAVpQUC6RHs+ODtKtgSDy=oxV12azk5QkjO50yUDJpOAHiv3qA@mail.gmail.com>
Subject: Re: [RFC] splice: add wait-all semantics for socket-to-pipe reads
To: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, edumazet@google.com, ncardwell@google.com, 
	alx@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 8:53=E2=80=AFPM =E5=A4=A9=E7=8B=BC <rockeet@gmail.co=
m> wrote:
>
> Hi,
>
> I would like to ask whether splice(2) could gain wait-all semantics for
> blocking socket-to-pipe transfers, analogous to recv(MSG_WAITALL).
>
> The concrete use case is a high-performance S3 FUSE client.  Once an HTTP
> response header has been parsed, the response body length and the exact r=
ange
> requested by FUSE are known.  The body is moved from a TCP socket into a =
pipe
> used for an fd-backed FUSE reply.  No userspace data buffer is needed.
>
> Today userspace has to loop around splice() until the requested length ha=
s
> been transferred.  On a fast local network this commonly turns one logica=
l
> read into several splice syscalls and scheduling transitions.  In one rec=
ent
> profile, 3,475 S3 GET requests caused 25,463 splice syscalls (7.33 per GE=
T).
> The profile contained no poll or setsockopt calls in the hot path, and 80=
.86%
> of the sampled CPU time was in the kernel.
>
> The obvious workarounds all have undesirable properties:
>
>   - looping over splice() in userspace adds syscalls and wakeups for shor=
t
>     positive returns;
>   - poll plus SO_RCVLOWAT waits for data to accumulate in the socket rece=
ive
>     buffer, adds another syscall, and couples latency to an advisory read=
iness
>     threshold;
>   - recv(MSG_WAITALL) requires a userspace buffer and loses the socket-to=
-pipe
>     splice path;
>   - increasing SO_RCVBUF does not make splice wait for the requested leng=
th.
>
> The current TCP implementation is already close to providing the desired
> behavior.  tcp_splice_read() obtains its time budget with sock_rcvtimeo()=
 and
> loops while data remains immediately available.  However, after making an=
y
> positive progress, a later iteration that finds no data returns immediate=
ly
> because of:
>
>         else if (!ret) {
>                 if (spliced)
>                         break;
>                 ...
>                 ret =3D sk_wait_data(sk, &timeo, NULL);
>         }
>
> Would a new flag such as SPLICE_F_WAITALL be acceptable?

The use case makes sense, but I think it depends on the numbers.

Another aspect would be whether we want to add a new (potentially
buggy) feature for a single user in this AI era.

It would be great if the change is proven to improve performance
of the official client that has a lot more users worldwide.
https://github.com/awslabs/mountpoint-s3/


>  For a blocking
> socket-to-pipe splice it would mean:
>
>   - keep transferring until len bytes have entered the pipe;
>   - after a short positive transfer followed by temporary lack of input,
>     wait in the kernel with sk_wait_data() instead of returning;
>   - use the socket's existing SO_RCVTIMEO as the total receive wait budge=
t;
>   - still return early for EOF, shutdown, a pending socket error, or a si=
gnal;
>   - on timeout/error/signal after partial progress, return the partial by=
te
>     count, matching the usual stream-receive convention; otherwise return=
 the
>     corresponding error;
>   - retain the existing behavior when SPLICE_F_WAITALL is absent.
>
> SPLICE_F_NONBLOCK/O_NONBLOCK would remain orthogonal: WAITALL would not c=
ause
> sleeping on a nonblocking descriptor.  The destination pipe must either h=
ave
> enough capacity for len or be drained concurrently, as with blocking spli=
ce
> today.  For the motivating workload the pipe is sized for the FUSE reques=
t.
>
> The important property is that data can be spliced into the pipe immediat=
ely
> as TCP data arrives.  Unlike poll plus SO_RCVLOWAT, this does not require=
 the
> whole range to accumulate in the socket buffer before transfer begins, wh=
ile
> still keeping the wait-and-retry loop inside one syscall.
>
> This appears implementable as a small conditional change in the TCP splic=
e
> read loop plus UAPI documentation and selftests.  I am sending this RFC f=
irst
> to confirm whether a splice flag is the right interface and whether the
> SO_RCVTIMEO-based partial-return semantics are acceptable before preparin=
g a
> patch.
>
> The userspace implementation and CI profile that motivated this request a=
re
> available here:
>
>   https://github.com/topling/ngs3fs/commit/4b8f5a69ceebd9211021a5d1149637=
3d63f2e43d
>   https://github.com/topling/ngs3fs/actions/runs/33586457571
>
> Thanks,
> leipeng
