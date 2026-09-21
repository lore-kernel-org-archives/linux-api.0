Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E0D380FF8
	for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 19:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018463; cv=pass; b=P411+DpP1n4L1+rYq4YQyET6K2mOi51kLAwTKjYsXOXS4HOpAb7+n01oXTQ7XHkNsekj9ac6UX6K/5NyVsa+V1pB0BA+YWMSdaBfK/rQdY2dovOGAuRy8sZM6fhZ4NUnNHOoShxmfn8iJmafcGNPam0rGLf3Tm/hfaUeaTtjxV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018463; c=relaxed/simple;
	bh=qlFdAR0F/wCuIts0PKz0zOO+oD2tVvhCexRQzujbsd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PcTgYFT4LYXf6OE4PELalCVsXhXzr3zWv/bSZ5G0sXn8KrXosUUmb+rsAWo0ZnAXNqrQPkTjv0kbw7qMUzNfriWbVHlHE22qTV2unp33bhO0ggLNzaE47v+dkd3/R5/TlR8rQJGoTjj/Ft0xBZjz+4PBGMn6hRyHpzGrpdb5tRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Old1K8kL; arc=pass smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Old1K8kL"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d3b445a84fso31255ad.1
        for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 12:21:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790018461; cv=none;
        d=google.com; s=arc-20260327;
        b=p/LnJ7dkv7v5nq77oDNKF6xkzAEPm8oDgPl7OVyzj3ZsRYwB3+HbLb/K5twZbq1xbU
         sbf48cHajKNMDhl4RimlRac98RGm5kezsc68dEHztPWwvenLeyFuzzPoJB6T1tUazL0Y
         VWmC0qe3/H49DmBtbXUiAsVBaBvQCkwZkOiB/AJ7G39OrqmyVPUxM1jX2B4nWkIh4Cmb
         nfRiRxplGQ6sphNamBrMfoy984x2K8qyyJ5thN3s1sUWLzS1QBe9UwmOnR68g6QyEBXV
         nbv4HhIHbSE6jzj012P+64doysMb1to8bdkd8G1C/NJ4OYZHc2/FgDpBegExKHLnCD/r
         3qpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MEszMFKCmw9FeOOlcidO7gC0SHQCAcCefilt7YkTj2g=;
        fh=cvbzhZEpXJh3tFa6wJhPzLR166wA74OoLGkOiKN+V6g=;
        b=Y7iVflgm4ifz0FXHZUbqqcnZT23/4oKOeewczqt00A0m62oJCeXxkR8hvac/DOUHqL
         zaF9RdB6IljEQYWxiqBWyY4uDlkGTBu1lY6Cp7DA51OPBW9MVtas216vr6xo7VIAsmZL
         3N4JOAgmzqFGkTRacjCTOFUM/L5qtM5bRUHkJhIfxMksvZasLAYD7kNKe2dHmE7AenZu
         PjKFBVavJE7YUSgu3x+xSeGJlVFif1Il4ECO47yjB7Hw1QVTfGPlg+EACGHXfYR3CRaO
         Rd+yFOA7Z+4fq/z0BXL+Ks63hURa8MvA/TSc9r7JoIb1zYzY3mzNiTbSD/8UZ3K6OnJy
         /f1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790018461; x=1790623261; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MEszMFKCmw9FeOOlcidO7gC0SHQCAcCefilt7YkTj2g=;
        b=Old1K8kLo+/5sZfFxr1yO0b5CJop3DdWOVAx4746I2nslyAdNuiWbTaQeR0omwoiSG
         Zzdq78QuygBtKl2EqTnjPHSDMvlSUiaMYrFD1GTXi2776fM4gZN6IFwAPFqBhJTIKwwx
         LjgbgzLuv9Lmgv85zZhuniAd9okpEBN2dxyPuou+ftK3iTLp6OM768OM2/V+9aZSYW9X
         YzmUlCxYBFrpyfUmvxwcU7S7RyyIMuQBtL5cj8N6yypVhp8KTg0F9aPR2r9+hKVU8Iqp
         9lzRj0ogNKnAim1hY4KHi1x4JoAwPgXcYpV6QzshfWeyinGbLhTI7d9d4CNtfyd1+5EA
         JIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790018461; x=1790623261;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MEszMFKCmw9FeOOlcidO7gC0SHQCAcCefilt7YkTj2g=;
        b=NtD85hb7rGAUK5B9fVXZf4OWntt9mNyX+r1yA3H22dzy8fWYkRsQDlMMbqZzgOvOK1
         3TAwaDi4H8ljKqHEggwFOWBnpiEB6hZVzv2rytrWA9duDJ+t2R9TAjiS4dEvKn6yTgkH
         bP+KTMClMKN7LFCFVyerJkvmkthtlIP2qtaFUmebwnNOOgvArRpsFrpcPa60dm476vem
         mEeWcIHj0k8Osh/sSyxP6KtWTQ8zY8lnoBdk7lf4mRWZ1/gOFRV2/L0Wehg6Rke8saJL
         Z+FH38m6jXREsaNCuSo4+vwUIMxJGC+7udAiMb8dBicYgu10FYSAH7wp6CICSQyJQKOw
         er4Q==
X-Forwarded-Encrypted: i=1; AKwUvBxlNN9MBofMs89xlULGFE9iRmY6cjCrCN0dAIgxQJWrsNP3XCUQ+85rX6nriHhEPqeDQ9mIRkIxurs=@vger.kernel.org
X-Gm-Message-State: AFuF++l79HHAWpId5nFptmiHL1NKoI3bwjLBvKBpxLjkT7QEM/yC+rZA
	gKVM5KU9ZJ/DhrMuli2Aq89MBdWeROkhwMiLl18eF3G/HBnL2hegrtMNeUwqRKfZreMDeMJ+K6s
	9iqLru9gpFfsBoyYuFm7D0ZzAnMt4yrjh+s5eQPdp
X-Gm-Gg: AYBFou2O+7Q+rWHguCknbh1/xjG1Dez2/FwtWE1BMnsj0hJzYFEimFmPvaER0UsSnCG
	6DgumEuOFnvCY5WgdReGJn1MUyh4hiQwYn/f8HzBBJnDgaw6QJHH+ZSEcY1DRN6SUGpIpm9+e0h
	tmHlw+llulCzyV7ayYaREeyAv3xhpdh6rgYu7cKOBdSd9yWzzLnK3SnMzXKUUbTI8NVEMmMOex3
	Pe02XTQAyFJNomt8SizR+ZXCupOVbJzFQnW74CpmUskhOlKvOCwbWEgTwcMIWTh9y+IOWNBoccT
	pqihgIOhtZgO2S9FMyT8zZvXX9UNBZgHJMFhX6VdU3Aee+moIpnQTr7RWorhDbW6iTBD1qTIAPW
	fDu39GWG5oOP6MckeUR+YSGeIy4YynwDd/85ilLjgg53JEIo+t2w=
X-Received: by 2002:a17:903:4b4b:b0:2c9:bd54:cf with SMTP id
 d9443c01a7336-2df5a44e80emr2158055ad.4.1790018460814; Mon, 21 Sep 2026
 12:21:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn> <20260831-pidfd-get-paths-v2-1-c59ea6a21b72@black-desk.cn>
In-Reply-To: <20260831-pidfd-get-paths-v2-1-c59ea6a21b72@black-desk.cn>
From: Jann Horn <jannh@google.com>
Date: Mon, 21 Sep 2026 21:20:24 +0200
X-Gm-Features: AcwNN1U76ul6KsowgCeLOYWUNK5UYTHsLK5_fZAtm1s6K_0yYBp22XKyN_fzxbs
Message-ID: <CAG48ez3vJrbt+qYh5b-PYxmr2txcg3DAKDRwmBwVzNhRB+8Ueg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] fs: Introduce task path helpers
To: me@black-desk.cn
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
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

On Mon, Aug 31, 2026 at 4:59=E2=80=AFAM Chen Linxuan via B4 Relay
<devnull+me.black-desk.cn@kernel.org> wrote:
> Introduce helpers that acquire a referenced struct path for a task's
> executable, root, and working directory. Reuse them for procfs task
> links and AppArmor executable-path handling instead of duplicating file
> and path reference handling at each call site.
[...]
> +/**
> + * get_task_exe_path - acquire a reference to the task's executable path
> + * @task: The task.
> + * @exe_path: The task's executable path.
> + *
> + * Returns 0 if the task has an executable path, or -ENOENT if it does n=
ot.
> + * The caller must release the path through path_put() on success.
> + */
> +int get_task_exe_path(struct task_struct *task, struct path *exe_path)
> +{
> +       struct file *exe_file =3D get_task_exe_file(task);
> +
> +       if (!exe_file)
> +               return -ENOENT;
> +
> +       *exe_path =3D exe_file->f_path;
> +       path_get(exe_path);
> +       fput(exe_file);
> +       return 0;
> +}
[...]
>  static const char *get_current_exe_path(char *buffer, int buffer_size)
>  {
> -       struct file *exe_file;
> -       struct path p;
> +       struct path p __free(path_put) =3D {};
>         const char *path_str;
>
> -       exe_file =3D get_task_exe_file(current);
> -       if (!exe_file)
> +       if (get_task_exe_path(current, &p))
>                 return ERR_PTR(-ENOENT);

This assumes that when get_task_exe_path() fails, it doesn't set
members of the path argument to non-NULL values. That should be noted
in a comment above get_task_exe_path().
