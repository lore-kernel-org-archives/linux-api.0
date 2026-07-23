Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB15833D6CA
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784817801; cv=pass; b=KF5OlvdPcegczgB+QLIf+SnLH//3jHxTIHCGiECFA0mLNqp3xvrwfhQlHjgbmzGq20pa+JUKfqTmMnQiJ34MULa9fOYYi06ALZ8Ddp36A4n39UiGpd7eDWycdGIvA4s5nz8v6WHPMWbtFgy3bdYS3a6kIOYu/HyEOVZWXhWAoLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784817801; c=relaxed/simple;
	bh=5Bh13Snw8/LKld3ZLy68siOQFrXb9O9ypzbWa4YekzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q5FpsJ4dzhNPBuxrRPbeGpr5EE4BGKGO/pJs+FjCAvOCcEMJL3l1SDHjrMel4cruH6lmgRu3XJKgSMz3OOl3NL5lEH6n2NjqIoGyhyKwBgJwOS/Dgzq9F2+cUSgOM/fAF6mcdGOAl+ZFoQMc6x6c4ApkWH0TLjyIJY0/EylMyHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PHZkwHD4; arc=pass smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PHZkwHD4"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ccdf36f63dso127225ad.0
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 07:43:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784817799; cv=none;
        d=google.com; s=arc-20260327;
        b=QzKuI53bwbVa6Tj/VqnCVkUrqT89It7qpFr5wP/pmXSaUDhxqwAqJoiX3ihSzGT3AV
         kR8EzR0AWtIyMphRaI/qx/5V9Gr5hWWesbCos95tx5lQos7JoRtpujLltQEzLJUUWgSf
         aD9VC6O8L+P8ssp12NC/Q36DHhC4HLDB9vXHocwDXmHxRStmZVUFqnEOMNQUxmxZbq9E
         V+pubhFoPdykYAYVv1eCd1GTKhX4fC5W3udP/JFZD1B1fPotbNYZkhj7efSXYzn0kHWr
         MiU2TJfvCdeackUCtBsiJnJJnv3I1qQ4tabitF/pjFuiC70hs2rOar323XgE76MwzZ3U
         lx9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kInI0j7PfqNfBfbUd3Pq6xvKYabvTs/AAdV3xhy9+eQ=;
        fh=m6pUU+CEfy5+F+4jCVYpuTeNKPnBBVide10mews907A=;
        b=EgFnd236cT8wSFIcJuKp0927jO45c80WG2/smucumVSCtuxo3SelFV3WLkTRk8ox0Y
         WP6GTM+q01bkZd1eeuNw7EnJ464QikaYvBk6pgkJ7rWbst4omP0XFeECPSJ3NTYL4XZR
         ovMhJ9ZUsd8OWP5VbuLYelBEqidYBYQV1/Z1Dd86kwaTPqR5lGTbZVBkbF3eLOpWqdKP
         ocPxA1LyYzfvcamRcACj2Iqes0KB+V3hQ8yhjcM6Jqyq7R3WnB3jPwZIo1rmiUVFXvEM
         pAkVf0ktswHEIdqTmQoNpt7iZ6qX/N9cYMmtU328l3HxSwDVTcyE9aN6yVTE/0lntTxI
         AKHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784817799; x=1785422599; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kInI0j7PfqNfBfbUd3Pq6xvKYabvTs/AAdV3xhy9+eQ=;
        b=PHZkwHD4AYGECajiX1wdnXWmcGjvn7c7wtZqgmhPWyYprrxSljTAFhoXyKMW0swI5I
         +gtd3hm+CQ1jc8lSGrMIpQVXw0GmVPndI9NGRZx7EvXXCmODyRnDjkNejaU+z2g8D4IQ
         KkTWZnINQOYXUSEwfEEUfp0QnqhdEYFhV024+0IrbZ/MBsdJuXPTaazVxjTyrxkYt8kc
         ln73T37n21iLfDLU4rlqoLZY+d0wSM4V0nYj3XotiyM/WbRgbLX73qknYmoFWQsTsm06
         i2BnQafRhSfLbQBZw1wQeKzTD99shDqMJ9xG5hWya1S1m5Zhf8vCJ0fEEoYfGbU5Qc1r
         Ohwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784817799; x=1785422599;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kInI0j7PfqNfBfbUd3Pq6xvKYabvTs/AAdV3xhy9+eQ=;
        b=JeW/0/8w06Iq/1Opq7XYb5+PbxCUfggwvEQNG5uyJpVW1kU56J7HeYI8VTbTArtzq0
         ZkAxc13KR2bwRTa5vp8SIE1EWCxQg7TmSNj8byXRwcApEyLIEXXDPQz8Y8L1Knv2dUxG
         Ih9brKMOUeXbr4u45j7hzAV/YQZciSti8AEPcYlF6F8tMpKLHmz5UDTiRmdliNcFJCbC
         wcETCs43AxHuEUd0ayqHmdTv59yUAXzRLjzJFfqgU56ywVCSWgEHsJrX+DnZVMDDgDdX
         y849aOSPSuqYcsutKmaYrUSH+1H5DbQOJxwMqmJFFcbuzoHbrhWoxfvxM9StmPbRxmWC
         X3Yg==
X-Forwarded-Encrypted: i=1; AHgh+RqNujys/MSRk91dUFzCh6Xq6LQByhaL0Dyfzp9rhz3jehLf0aOrRZMCr6mnuzUwTy3sfTvX5B9RdsY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmWxKSrSIhe7mQjFrbICQxV4i7ZFpXofHouJ8Y78IPwc2DixVh
	kpjLzSzOwrV2Hfm/+WaE0DM5p/vo2zkVn9Du1qlJCEnnc8mZEye2k5r/A7BTiKwAvatao1subri
	roeS9tNeZuwV5bC/G1ntyLg/sR69jEf37eUpIBjym
X-Gm-Gg: AR+sD13EL/RVFctjjTScsUbk5sf3AFmTuAuYfi0hrYlH9qcgWBEhtchyWrbLq/8uHOL
	UF3lmyL4p9lwBawQOkXE8AwyAGgriXJf7g/uu5tt0+iJiegNK1VTpg0zBzCfROImuVKa0injkMv
	Dd4+aQjvdIrAP/wjCoOHFHjZHngy4pQJZMaI/jz6hQbXzZBK6+wkRyAZxiLye5w9Z7WF1N8v+sL
	EPhS6ztZrKkc9o1eqDrqFcwVd/3SddGcbTzpPOy140YhSJ7X0rrT60xMV4muSu0jPqDLNSdz37c
	x0tJAkFu/CUi7yBYM+k1ry5pybOLzxcJIqkD95hacK0wMcwy5H1rms7x1g==
X-Received: by 2002:a17:902:f0cc:b0:2ca:cbe5:c3af with SMTP id
 d9443c01a7336-2cfa805b497mr2620685ad.7.1784817798592; Thu, 23 Jul 2026
 07:43:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
 <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org> <CALCETrVDX-PcSJoHFwymh7d=oUKotJQQuh+AzmsA7YQySBzD3w@mail.gmail.com>
In-Reply-To: <CALCETrVDX-PcSJoHFwymh7d=oUKotJQQuh+AzmsA7YQySBzD3w@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 23 Jul 2026 16:42:42 +0200
X-Gm-Features: AUfX_mxwR2szFPQcNEOJk5c8uPwGThX-tGJ2GY340PPIRSnfxESd4tzYNTgrDSQ
Message-ID: <CAG48ez0P6baYhaL4_U_S-wjQX7366WkSm83OQ5ZpUjmu1J2BNg@mail.gmail.com>
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
To: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 2:49=E2=80=AFPM Andy Lutomirski <luto@kernel.org> w=
rote:
> On Thu, Jul 23, 2026 at 4:37=E2=80=AFAM Christian Brauner <brauner@kernel=
.org> wrote:
> >
> > Once entered, failfs is a throw-away-the-key moment. The task is
> > considered chrooted so it cannot create user namespaces to regain
> > CAP_SYS_CHROOT. chroot()/fchroot() back out require CAP_SYS_CHROOT.
>
> I kind of alluded to this earlier, but I don't think we should promise
> this.  In particular, I still think we should eventually allow a
> non-chrooted process with no_new_privs to chroot to any valid
> directory, and I think we should consider changing the definition of

FWIW, I kind of like that idea, but I think we need to look out for
how this interacts with path-based security checks and auditing.

Examples I can think of immediately are:

 - bpf_path_d_path() is intended for BPF LSMs that do
security/auditing, but uses d_path() which stops at the chroot.
 - audit_log_d_path() uses d_path()

These are already kinda broken in the face of unprivileged user
namespaces, but adding unprivileged arbitrary chroot() would break
them even more.
