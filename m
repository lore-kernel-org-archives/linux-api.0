Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0FF42086A
	for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 20:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790022171; cv=pass; b=TfWdT2F6INq8E5OTq8a5I5Sq5EYrOs2BaXjLB8ZfzOqB9bRz5XP5a2y4lw6ed08Tn/Z/4wDVz9/cmYGyv0E02bS6bmWJY+oh3a/HXqj4vHk+2WzhWWSYpCZr56RFpFyUeHkxSK2zsmO9libtq0RE5pXC65OU9UIusXmg61zYjAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790022171; c=relaxed/simple;
	bh=5AoAm7kCydoLQsr+i6jrfa1JthOko596jNaE8bcwdh0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n/9jz6YVjsCdggChRCezG4hHihsKWJfem5hZy14ivhSmm7t8D/sRdqf/kmtjpZKmzHVWKfE9JWJKW56dwhgpSeDd0katxr5wAU/GLaXdNmOfxVppLzrWnZRxiSggy/fGGSzjJ35dlGfO6Rqnqdb3P7fa0qzIfQK95ea3UMMes9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NZPUSklz; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NZPUSklz"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so7085ad.1
        for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 13:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790022169; cv=none;
        d=google.com; s=arc-20260327;
        b=Y+AHCbFFV7Ovsy3PdxWymYtkj+N8iuw4o3enl5C8RBX0JPh8wY+Y2ErJK9cgSoEFv2
         0urTynRRw5ViQfxpFV5WAO2Goxtlcl3N3qEszoViph6IG8BOTfZsUBh2RJyxplAbwc8U
         XyOco71zM7l/yl2M56KQrgJSWNHzXz4PJKJFSoz6NCKe8+eaaCR18441jZI6MMPRydvx
         5F5olvZLxv/39UUVONsKPlLHU6TST9UdzEgrO0CEfWKAce7UNLV+i202BWyrUk4H2ddt
         f4A2UEryDOGbI/Uks2td/mv+UaFMpK7ivDyqScZgoH9VnLV1BrGDUh7ak7HYRQqr8pmO
         Q/8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZZjuQxZbTYuwf9RVKp56gufP8tt1Juurh+o7CdzjxoY=;
        fh=GlnMh4/ntLDbAJFRKNuBSKNrsAx5Gibd7PAItVlZy2Y=;
        b=pcXO3r8AHvUJQLKZlrSvrk07tvqr5VMVBYJhzhOWhJmoEad2jei2BMAlWn5bjl0PGw
         OPP+ber6zrxwI52zhge3F7nREPJTPy9NibjL48+h9LCJQbJXsOcHraXPeriGCLI61MxH
         pb2FV1qza8ZmExAi1lcHqipdwKM1yoYxAhXnsxNb/pDI0izktxsxNVrp1IUR3CpYIm6x
         hCO4wAL1xXD3ig+23QLifNYJyp5u7/v7qU93bKmOad51GHAhNtiA3DHa7ahIkj1otMxq
         m7aLHFO2S7NLn3/t5WJGaCTphnri7dxFBFtWtNuNmtWlzzYY/9A3EWnevPzHCa38JYhF
         dmNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790022169; x=1790626969; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZZjuQxZbTYuwf9RVKp56gufP8tt1Juurh+o7CdzjxoY=;
        b=NZPUSklzX91cqloY9UWtg2FDsu0QfMamuJIYh37mCQ9uf8iUvDG0RLPZntzjk1dmtD
         j30Y3/Xf33ZxYFl6lIwIMluHu7nOiazNqy/dpeU9I8gUZtgdHC3CXbY6//v3bB87r+08
         grxj/3LDypylKj77WsDYjH5dtlSXr6AJWE24kb1caw3yYTfO0IQjz7vGOeCV1cSNR3E0
         JHrAj6AIC+7RYM+jMWLd0KQJ2JdAucmtx5xouyALxCr2ybiboglaHeksRYJhqo5wClAs
         UBu7Y6CRvu0ujbQHCqQIoHNsMpTGP6QF7M2O4Vjso6zCq4anfXZgyG2Wyn6sY/32aSCv
         m8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790022169; x=1790626969;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZjuQxZbTYuwf9RVKp56gufP8tt1Juurh+o7CdzjxoY=;
        b=T8YCbFwFvmMfGBZXhK81ETfQtla8wV/ln+gdbi+4yTUSHTNX3IUNSyFPftGUWMJ4r1
         /bddMqrzbWu6OsIPLrC+SXYLEztVJiKZbyYgfLr4Mshenw6KuPsNNS2RtXq6vWUmdaRc
         xHf2K4f2aiFgipk5mRB9u5z0rFOXyYpKec07E22H/1s558kVNcwvmqBSvUGpwwkHxtom
         RIck16hMx94Pj/cueAvsQXaX/K9e0kuc5JMyVUQ2PWvzPsTjg30HGlRUyjY4gj3EYxnF
         ea5hUyv5WDX3OtSf+vdbzwygxp+ZrihGVTXK2yUDtAI4bxqV110kB/ZdPVghe7i1ow3J
         aQyA==
X-Forwarded-Encrypted: i=1; AKwUvBwHLjH3vMtlnh1geTuOcvUQpEbEv6J1qbv+MWS4D18zbmodO3ZxhXaiX5jSZkJ1xYqcKSkNn2biy3g=@vger.kernel.org
X-Gm-Message-State: AFuF++lIW+Fugk4W0+peX5vS6E5PtzWjJEOfFSU/DWv4+mklY0g9p0jJ
	F8f4ZFic8xSWnmUQIBFfM/IJQOImBhHWc9v6X8kp3stdf7kuXTQAv4TKGmoXe8DTv6BqZIiziwk
	oS6EqkbNrIpi1E7CPA2MPo8kJYIHRchMPeDQDpdyN
X-Gm-Gg: AYBFou3E/1zwgmhyhzZTC6yzxTBGSePCkCjLibHRmllKwMHSwjA9oh5r5j8ffMZfgoA
	4d5Z1YNawXiodVtTi7l2+tVdA7nluPhZQhlLfIy85UnvBggSL5ZiKHaaP0MOSt5+ku+THNR4zWs
	XxoVbYvwdOdQxrrsv74oPDGErKtBDq8PwNFffNDyfBKphE0o0Zi01b7LT3TYwwjZWkmNuoHIAgp
	hPMuk4D+9/TbGg5x1A3dazahckxFbtbOgXJ2Xtk2Otb3gDZ1E7xRmo7yDtbUR3+VKGzJI+7HfYy
	Z1tRm+s6NUAWFGxaidld2Cu6EyxE95F0UiJUFXsojSMixqfj94aQM+4pL+Yc1NQaJUe+QayUJXq
	9KBkXoCWrx2qmxntTKF3UnS4m0l82mp0dgyfqjyJR
X-Received: by 2002:a17:902:d98b:b0:2dd:280b:cdfc with SMTP id
 d9443c01a7336-2df5b83676fmr449455ad.17.1790022168357; Mon, 21 Sep 2026
 13:22:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner> <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
In-Reply-To: <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 21 Sep 2026 22:22:11 +0200
X-Gm-Features: AcwNN1UtR6M4RsRB1V4M9ZXr6hSPfcvgRf-Sf3BDBnWgXtSIC5rk0Yng7pQuhSw
Message-ID: <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Chen Linxuan <me@black-desk.cn>, Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
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
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 8:47=E2=80=AFAM Chen Linxuan <me@black-desk.cn> wrot=
e:
> On Mon, Aug 31, 2026 at 4:49=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> > On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> > > Obtaining a target task's executable, working directory, or root
> > > currently requires walking procfs symlinks such as /proc/<pid>/exe,
> > > /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depe=
nd
> > > on procfs being mounted and visible to the caller, even when it alrea=
dy
> > > holds a pidfd for the target.
> > >
> > > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Ea=
ch
> > > ioctl takes no argument and returns a close-on-exec O_PATH file
> > > descriptor referencing the corresponding task path.  The new ioctls u=
se
> > > the same ptrace permission check and nonzero-argument rejection as th=
e
> > > existing pidfd namespace ioctls.
> > >
> > > The target task is sampled while holding its exec_update_lock. This
> > > keeps the access decision and the task-state read in the same exec
> > > critical section, preventing a concurrent execve() from changing the
> > > credentials or target state between the check and the use.
> > >
> > > The first patch factors out helpers for acquiring referenced task pat=
hs
> > > and reuses them in procfs and AppArmor.  The second patch introduces
> > > scoped cleanup for privileged pidfd task access and separates namespa=
ce
> > > lookup from namespace fd creation.  The final patch uses these pieces=
 to
> > > implement the three new ioctls.
> > >
> > > Signed-off-by: Chen Linxuan <me@black-desk.cn>
> > > ---
> >
> > I really have difficulties forming an opinion on this. So this sounds
> > very useful but it has implications.
> >
> > Right now, pidfd ioctls are available even in situations where the task
> > in question would not be accessible via procfs, e.g., when procfs is
> > mounted with "hidepid" options or similar. So this would expand the
>
> One point regarding hidepid: for callers that can pass
> PTRACE_MODE_READ_FSCREDS, hidepid does not provide an additional
> restriction. With hidepid=3D1 or hidepid=3D2, has_pid_permissions() falls
> back to ptrace_may_access(..., PTRACE_MODE_READ_FSCREDS), and
> hidepid=3Dptraceable uses that check directly. In addition, the
> /proc/<pid>/{exe,cwd,root} links independently perform the same
> PTRACE_MODE_READ_FSCREDS check in call_proc_get_link(), regardless of
> the hidepid mode.
>
> So for these specific path lookups, hidepid does not block a caller who
> would already pass the check used by the proposed pidfd ioctls.

Agreed, I think with regards to hidepid there should be no issue here.

If I try to come up with scenarios in which this could introduce
additional danger, the main one I can think of would be: A task T1 is
running inside a pid namespace and has a unix domain socket connection
to a task T2 outside the namespace, with both running as the same
EUID; T1 sets SO_PASSPIDFD on its socket to obtain a pidfd pointing to
T2 on the next message sent by T2, then T1 uses that to get access to
the mount namespace of T2.

Christian, is there some mechanism that already protects against using
something like SO_PASSPIDFD to get a pidfd to a process in a parent
namespace?
Otherwise, should we add something like a "pid_vnr(pid) !=3D 0" check
either in these new operations or in SO_PASSPIDFD?
