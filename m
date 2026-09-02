Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F243AE712
	for <linux-api@vger.kernel.org>; Wed,  2 Sep 2026 06:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788332005; cv=none; b=UZsw8jkgbX5CD06DEsiyH05UjQEnMo/3HrD+qSLxEerut6pxvYQ2K2PEXyeickIkNV0AYFs0ujUnNvdY1gHv1m9tr3nQJ/ZeVO1puRtp0ML5/AiL/rj538a1lrWYdnEzXXBTCPQAV6rIW0m00/vnnimIReNE32oBQLY29hLZxYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788332005; c=relaxed/simple;
	bh=ixlWqFuSFl+kXQc/tcrrAFQiec5rJ4PZr781QjNJjcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hXhDez4eWy3PoJ8UTUptSEqVWFcS2rW+zUAV7ir94iYz5cew9ngFSmTLDa+f6L0Kc5QPx0LhxL3zNAkCuvw5n7VRwFYmifG9K0YPAys0H6iv4X2KNXm1SNYt5E4ICsPzNBL7V6Jm9ZCJegdjixjozRdDXs2I2Z/YrOIP033mfxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b457a0b4e5so594514e87.1
        for <linux-api@vger.kernel.org>; Tue, 01 Sep 2026 23:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788331990; x=1788936790;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CtlpH4A/FsfIicKK/MMLWRSJhN08nYCVAAoP5yOKMSg=;
        b=PtobwnvkzZaUZ5NHO+ImHC+SvVfO1LZ26I0ar9Lt3HZzC09OriZL+tKYTJGQddSooe
         0y/MQiJk/+OFD/DfGuSUbtPruFc9oSTJqZ08lI6gn1gkNT2fvFSMi5R/nRdQPmjYVfbB
         20awRJDYP8tCyGou7YeWu9YbIpD7oClUD7ur0UyOqX/YNYIJhXJ1sivzRkcFso5dtpPJ
         Vk3QwsDYN+gng4/PGO6JmVKOdwaR3YeR8ezwvgq666LbosBh7XGr4caBjwRZXutVRza/
         jIGynF7AUyAbKmv0GbYwrEnQ8YugIqzCgqXvRg7o81Iw+w4PhXck5NeBeicZT/yJajox
         /Wmw==
X-Forwarded-Encrypted: i=1; AKwUvBxaBnruyjKV9HpQ/hS3OcuRpA0UKfcA2bDCeJwDzU69xq3151kML1kv1ees1Wc7F/bFz3IhlVKHrzY=@vger.kernel.org
X-Gm-Message-State: AFuF++k1tQcgSzBaTfSOLEIzYbT7a4qZ86SbuoUBxlN8F/qwV9MHX05j
	u4ZQs5eyB5ALlgek43r3U/iC7R+kETNb/Enql5IrbzMayi76Qq1T0fy6ejTfP2tJd3WXEA==
X-Gm-Gg: AYBFou3LqoV3Ug8+MzfRTFkqxbq0UDd7qqBXfEChbN+Ad8Frgo7WtKuVGFQjp8ZGTKL
	EerYh6bKM+BbMYb9HhL9K6uA56//D09xLB2HZhffNDHFNPzu0nOVx8KKzKBodKKclJT11vY5Ucu
	7NPrszDBqdWpHvzbcSvlc3A369oVHgzY1VOQXXtSLy9In2jSf0SMqeokySEId7rCQSwhUduduG4
	q7YX6KT0p/YxW37lDAZw64XkAv70e+3aHHEM1GFK326tJJdrB4MgLAr0VRdHn/Pfwx3ZgXBnqb+
	bk/j4YUEwoZPkSaX2H0KwG+Xqxas4PYcQWCQafg6M/QKMg5pETZSaX5L+3fnCVYxMkNDmasaMXl
	b4TCZhrWh++/rDuXdP7iaKXQHMwQ6CQGx7sLpxxZrVr89yS8Jk6xid7rIpciZyr55GMQJhehcAs
	MK6wLKnJMu148S2ZiEKDID6km1Vmto9uCy+6ScQungw7oZyUY+gPNEyBxaIijehdL8RGWY/QPSa
	f5+sXitkomjpaBihV8gRBDLJ85Imw0K2JqWAR4XWQ7O8o9pB/PUZnj3zj2rnq/L
X-Received: by 2002:a05:6512:239d:b0:5b4:24a3:ecf9 with SMTP id 2adb3069b0e04-5b60868c97dmr856306e87.21.1788331989718;
        Tue, 01 Sep 2026 23:53:09 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b606b2627fsm358835e87.37.2026.09.01.23.53.09
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 23:53:09 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b457a0b4e5so594508e87.1
        for <linux-api@vger.kernel.org>; Tue, 01 Sep 2026 23:53:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx9530gH+tC5+S2XVai4sVJS32ac2MXNJYfTV6DTooIjcn8DtEK4lkt/ZTn9VQEnNUeULSeg1tgheM=@vger.kernel.org
X-Received: by 2002:a05:6512:32c9:b0:5b5:e8af:a5f6 with SMTP id
 2adb3069b0e04-5b60831e880mr829854e87.3.1788331663502; Tue, 01 Sep 2026
 23:47:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn> <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner>
In-Reply-To: <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner>
From: Chen Linxuan <me@black-desk.cn>
Date: Wed, 2 Sep 2026 14:47:31 +0800
X-Gmail-Original-Message-ID: <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
X-Gm-Features: AcwNN1WESqzlj5-w8dgp1OujQBVwB04y72AI-TKWGXGM1Ob33MtgcQyu2-BCfjY
Message-ID: <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Christian Brauner <brauner@kernel.org>
Cc: Chen Linxuan <me@black-desk.cn>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 4:49=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> > Obtaining a target task's executable, working directory, or root
> > currently requires walking procfs symlinks such as /proc/<pid>/exe,
> > /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
> > on procfs being mounted and visible to the caller, even when it already
> > holds a pidfd for the target.
> >
> > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> > ioctl takes no argument and returns a close-on-exec O_PATH file
> > descriptor referencing the corresponding task path.  The new ioctls use
> > the same ptrace permission check and nonzero-argument rejection as the
> > existing pidfd namespace ioctls.
> >
> > The target task is sampled while holding its exec_update_lock. This
> > keeps the access decision and the task-state read in the same exec
> > critical section, preventing a concurrent execve() from changing the
> > credentials or target state between the check and the use.
> >
> > The first patch factors out helpers for acquiring referenced task paths
> > and reuses them in procfs and AppArmor.  The second patch introduces
> > scoped cleanup for privileged pidfd task access and separates namespace
> > lookup from namespace fd creation.  The final patch uses these pieces t=
o
> > implement the three new ioctls.
> >
> > Signed-off-by: Chen Linxuan <me@black-desk.cn>
> > ---
>
> I really have difficulties forming an opinion on this. So this sounds
> very useful but it has implications.
>
> Right now, pidfd ioctls are available even in situations where the task
> in question would not be accessible via procfs, e.g., when procfs is
> mounted with "hidepid" options or similar. So this would expand the

One point regarding hidepid: for callers that can pass
PTRACE_MODE_READ_FSCREDS, hidepid does not provide an additional
restriction. With hidepid=3D1 or hidepid=3D2, has_pid_permissions() falls
back to ptrace_may_access(..., PTRACE_MODE_READ_FSCREDS), and
hidepid=3Dptraceable uses that check directly. In addition, the
/proc/<pid>/{exe,cwd,root} links independently perform the same
PTRACE_MODE_READ_FSCREDS check in call_proc_get_link(), regardless of
the hidepid mode.

So for these specific path lookups, hidepid does not block a caller who
would already pass the check used by the proposed pidfd ioctls.

> surface of operations you could potentially do.
>
> But again, I do think it is actually useful. Adding Jann.
>
>
