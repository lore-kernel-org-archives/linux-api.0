Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87FB37F730
	for <linux-api@vger.kernel.org>; Tue, 22 Sep 2026 06:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790057063; cv=none; b=eQAyPK1A/kM3gok5ZBY7on9dlRe6gUMZ697kjxcLZYX7Rq2RCGUqmaGoCqOq2VBjMhd8Qk6ISDCFlxxfO6bSrq9rpkuvx+EgWLh/ICYwXtSXd/Gqd9lr1Qh5r11z5mbDge11SiTkDq1mGdmMZNmy5hCMgQsJGwNEF+RNLEFwQew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790057063; c=relaxed/simple;
	bh=Q/oDrKjoLV0PJ7re9Qc+KtJR5UkROXgTJNC/Syw4ETE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o7n8HagXrq8/k7/3QcgOULVPucWdgEQps09Y08NCamb3UxwzixgbSj1oYAFLkzCS09ym9FQGBjC3wCU8Pu66qDeOWG/EfFX0D91nrpkkR4HK+G8hFfVRlOw8rqEQsYDI0tetQVWk3aZtcQHt3hMnec21qSZtIeb3Maiq44H4LiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6aa13a28848so910760a12.1
        for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 23:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790057060; x=1790661860;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zxmsk/EJ4w4QHvprrsLgwa7ofL6yH0BsSIWlOL221Nk=;
        b=fg9js7xHNTdjNdgnkdzjubXx86G4j53+nuzI09Yjvd0ztfj+DabR+6u9CqhSGSMsws
         Tx7Qao3rq1rwSTWzm/Q/6XTFCNJM0UU4kXt8as4Er0m7Dgfe/kGz6UhZs1Lk4gozF8D3
         blqFmAQnxsGeUlW1KAvQzQjPKlMqxf3JLnG18jSW5MZLgChup4kLV8N5tb6D01DufCpt
         zKE3W8ZRb9rVXEgNNm0GHavJJRrEcod57L9nHJ2y/Z0Po+cMDWfMVIn58WYfuaf6fwDh
         566AaF7wTd/ZxNb7fMHvjEUnQ9/EqZ2WCCHLkfOu1OwnvtwmHAQCS4VoUCDLNLMMFRJd
         N39Q==
X-Forwarded-Encrypted: i=1; AKwUvBy5btQy2PXbe9gmaANPCVLXo5DTtMJPtOtZ8hGIwQHKelZEC/B7eJtMOu+IMC7VuL3MdvUKHKVOXl4=@vger.kernel.org
X-Gm-Message-State: AFuF++kqJR/kt6NuTs9h0NlGb0EDplrGdVNbpy6PIy9PLPOiO4MCcDvi
	tojqpfkd02wyb8HE49Yo+dqBbR0xb9uRg+SfApTtN25o+p0mKhMbpKLRa16NaAWpu07TLg==
X-Gm-Gg: AYBFou0DKus5dbx922ihcbBlRARTq7sBpsm1lsQXp37ir243ModkkbLwRnTGV+5ha7Z
	d0ZIQA2k3OoEIuXtGvyBGW+V+l6y76VY9HaeJprJGp4+5Ib7DZ5T3Cf3ZdiBmfqBLedBj5zDX0c
	lLtXYhb6aDNJ5bl0U8jCU3vskkypVXcw5yFW5sbi24qMNj4gDNLuicn2qeyASfZpGBheQaAJOzM
	Q17mJzg/qU/WhFRCcFyx5B1Cy+oeZqDw+1CB8dBTdnmVS6Owz5XIhFNA80FlfLUiXcWkkE6BxSO
	6zwh6kEhaMBygdE6K8Kc0Ih/YGKpomKSkabUnxqwX62x5jiInhBW/DFhg+y8vyDcBku6fjoJh0O
	DxLSUEoHmVJu11Peb8HSanFjGQBhyOwRJ9F9QmAwad1uh9ESzOP7vMGJ1PyHaBkjGF1kLvKFrx1
	Td4iMtcgHqobnF2nkn39+E2Mv4Uq1BlwcWCtJ/Q0WllKBkUpCNIDDnW16xaeJyopY7r5AOboT3R
	lyCyd0FVMXoSf5+mNex7iPNRM2oyq/TRg4fNEwm0ONdHV9Bts1Oc1kC2N+4wxK+Au45c6B9k1I=
X-Received: by 2002:aa7:d392:0:b0:6a9:8863:ada4 with SMTP id 4fb4d7f45d1cf-6aa9fdb3892mr1172565a12.3.1790057059841;
        Mon, 21 Sep 2026 23:04:19 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa44d2ba5sm448534a12.7.2026.09.21.23.04.19
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 23:04:19 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6aa8d04fcddso1150621a12.0
        for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 23:04:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxaQdsDsQruTfDDs7YFjQnKJNMVunBDJyj2jwwq80A4J91hB7Zdxz/gp6tlZezY3pGyHKxC+mcPS7w=@vger.kernel.org
X-Received: by 2002:a05:6512:220f:b0:5aa:62df:cd0f with SMTP id
 2adb3069b0e04-5b8d28f3a47mr500408e87.2.1790056745194; Mon, 21 Sep 2026
 22:59:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <20260831-pidfd-get-paths-v2-1-c59ea6a21b72@black-desk.cn> <CAG48ez3vJrbt+qYh5b-PYxmr2txcg3DAKDRwmBwVzNhRB+8Ueg@mail.gmail.com>
In-Reply-To: <CAG48ez3vJrbt+qYh5b-PYxmr2txcg3DAKDRwmBwVzNhRB+8Ueg@mail.gmail.com>
From: Chen Linxuan <me@black-desk.cn>
Date: Tue, 22 Sep 2026 13:58:53 +0800
X-Gmail-Original-Message-ID: <CAC1kPDMUT6pUarj-ohTGB9=5u=7osk+8bvyyAAjStsJN6Z3sEw@mail.gmail.com>
X-Gm-Features: AclHuK-ZUoiNUpNllD9s0TdWDgkEMFXuDsvm8kdoP44o6gMCMaHAEIjZzTqw_NM
Message-ID: <CAC1kPDMUT6pUarj-ohTGB9=5u=7osk+8bvyyAAjStsJN6Z3sEw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] fs: Introduce task path helpers
To: Jann Horn <jannh@google.com>
Cc: me@black-desk.cn, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
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

On Tue, Sep 22, 2026 at 3:21=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Aug 31, 2026 at 4:59=E2=80=AFAM Chen Linxuan via B4 Relay
> <devnull+me.black-desk.cn@kernel.org> wrote:
> > Introduce helpers that acquire a referenced struct path for a task's
> > executable, root, and working directory. Reuse them for procfs task
> > links and AppArmor executable-path handling instead of duplicating file
> > and path reference handling at each call site.
> [...]
> > +/**
> > + * get_task_exe_path - acquire a reference to the task's executable pa=
th
> > + * @task: The task.
> > + * @exe_path: The task's executable path.
> > + *
> > + * Returns 0 if the task has an executable path, or -ENOENT if it does=
 not.
> > + * The caller must release the path through path_put() on success.
> > + */
> > +int get_task_exe_path(struct task_struct *task, struct path *exe_path)
> > +{
> > +       struct file *exe_file =3D get_task_exe_file(task);
> > +
> > +       if (!exe_file)
> > +               return -ENOENT;
> > +
> > +       *exe_path =3D exe_file->f_path;
> > +       path_get(exe_path);
> > +       fput(exe_file);
> > +       return 0;
> > +}
> [...]
> >  static const char *get_current_exe_path(char *buffer, int buffer_size)
> >  {
> > -       struct file *exe_file;
> > -       struct path p;
> > +       struct path p __free(path_put) =3D {};
> >         const char *path_str;
> >
> > -       exe_file =3D get_task_exe_file(current);
> > -       if (!exe_file)
> > +       if (get_task_exe_path(current, &p))
> >                 return ERR_PTR(-ENOENT);
>
> This assumes that when get_task_exe_path() fails, it doesn't set
> members of the path argument to non-NULL values. That should be noted
> in a comment above get_task_exe_path().

Will be updated in V3.

>
