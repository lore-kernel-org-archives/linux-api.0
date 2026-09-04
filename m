Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44A4471273
	for <linux-api@vger.kernel.org>; Fri,  4 Sep 2026 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788541241; cv=none; b=bkQN3E2aMV+v2qz6WjMz+9dJodKH5C2953Go3HWYuZqascFOyTMQOXJ5WBHwCjz03O/GJLPA1GQbVAAWVzeqFpAu71kT5dygIyIbS1YYhALShdph6fnIIPz0FiPwdPcEOciTVMlVz3x7lR3JLS7sqGYGoL0Igcsi8ljnZYzj4Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788541241; c=relaxed/simple;
	bh=ZdzwbYcSxFp1YM2NzyKteD8bxTtEzteMVXqKaxQGfHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GyeLoR3a8SBIflvITtaVHQYk5uoFYGrLTr6BDW+/GKuQc9MF5N03Msi+ntEvnhyN29YimVgTrvoNqu35piVwPMuCsDRhR9/XEg1EhFwo3rDlgYokWepaBXoIrPaCtAhkpXVrb+BUXPJyS1IZWxYSyzseaDak/C774F45axlS5wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a682579c72so1657991a12.1
        for <linux-api@vger.kernel.org>; Fri, 04 Sep 2026 10:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788541238; x=1789146038;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GyJwn4+ssjywZb/F3JjOY0S6/aIo0tP90S69DFDLuSQ=;
        b=LA+klc7te3P7V63Hk8zVIedS4QWXYpf5ImrLfZezzfVsjsMSM6oHDBMwA0ZqzaUMLP
         rAFC/hNUNzH4L1kT+fuVZGbT8KdLT2myVUoZIYUBPTD9J4yxtmz7KMxByMVVNZqbmR3O
         G2cPYEkZLtlUz4Q13qrLOU1UT4fLhUp2gfuUg8AzXVFPO5iBAPP8ONdIIxtTF/g/C86I
         xSmtpZhSodz/sue10ha/GWn9rfnyp3eyYYrINkLYG9VgjNnkCOQL6qMYImkSNBOvbmWO
         5xc2aTRLc9srIztHeop5RdMNPPrErl4j6rx28TrIjD1JVYm+IWFdZP3lbvmA0GkbT8zf
         m5jg==
X-Forwarded-Encrypted: i=1; AKwUvBxzYvzPjaoXWGWG63EjZ/MINy9+u+URFpvibGBbqiZ4vohum5hqcuoS+sG+G3sKsWqH9uYOEu1q5ak=@vger.kernel.org
X-Gm-Message-State: AFuF++lbyyhCbDT8daYjw2qPPS6Ll/pZC3yK/NnFn3G48nB+e1HC642R
	/lwRVmhVI2V+9J+F5P6KIRSXPdSt+bBbxofKuqLr0sqO3hH3KFpfMa6N2ALnVuKT3TDqPA==
X-Gm-Gg: AYBFou0gwu2Cv26sfjvivN2tfzZrPXhLy1hkNr2IP8TqKVID2rC8Q/DH7YnLdwipR9P
	s37i6Vi+3Xgi/ICn5JuT2frWs0Un/DzQo42UxWRtDSDEodBCSPXAfEZadsBOItLHs9u5RGYYE6G
	/TQo99trVpnsK1uNBKYOR/UU0ZcajewTCnaN2YwkbE1oUrMzJybiJYE9rv4b/XcGWpdvRTcrFJm
	axfQj8rY3u1NTsR4KfK+qi2USwBpZJjLFJuj/+9VTNA/6xFe1EEzGlnhrbpHY4403a9GxNjgaQZ
	Z0ztn9DttBPeW9V9lzJZNf32MWmX5GbFK9HynVnycp/EFth3UrmhwC8aruhh92a48LnIosdcxKO
	z6TA5bNRRPJGBQYYtsbnQVgsYzXYupAcPHU5fB06nASHBX/UFIY1qjznSSSoLdKfMwhnWrxs4Ka
	y01wZYoQCumRaKt69ZSN4IE5UZBBUXcBxCWA7YPS+C/+Dk66zGPYxyfxx9bkJlN8ur3iN+gnhx9
	tkA8xM/8Y2zq6NNEZyRhEy+TWfRtN6H5htRvLgeoG1ndw7MmmR5EFiLzGO2RLHq
X-Received: by 2002:a05:6402:304c:b0:6a6:32f9:e9f2 with SMTP id 4fb4d7f45d1cf-6a7e8f94792mr4011824a12.21.1788541237776;
        Fri, 04 Sep 2026 10:00:37 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e66ec5e1sm1500273a12.1.2026.09.04.10.00.36
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 10:00:36 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49cdc81f40eso8839245e9.2
        for <linux-api@vger.kernel.org>; Fri, 04 Sep 2026 10:00:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxS6h7xwWQaFHvy2SQJyokUyRqXow1oYDCMY8ghUBBDzng3O96q/cJZiJ3pBwDpzt2/XYzSIGxeivM=@vger.kernel.org
X-Received: by 2002:a05:6512:3502:b0:5b0:23b4:be97 with SMTP id
 2adb3069b0e04-5b616ed4b1dmr2357411e87.6.1788540878064; Fri, 04 Sep 2026
 09:54:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn> <lhuecf9cbl8.fsf@oldenburg.str.redhat.com>
In-Reply-To: <lhuecf9cbl8.fsf@oldenburg.str.redhat.com>
From: Chen Linxuan <me@black-desk.cn>
Date: Sat, 5 Sep 2026 00:54:26 +0800
X-Gmail-Original-Message-ID: <CAC1kPDPu41RxMLHpPtz4VqfkEZeu-fYXG76XVZMh8bbQa3okaw@mail.gmail.com>
X-Gm-Features: AcwNN1UgBltmpHY5GDpzTdve1vmhfclnbN_NvQgKzWwvr0zbygpAGe7Eg-teU9E
Message-ID: <CAC1kPDPu41RxMLHpPtz4VqfkEZeu-fYXG76XVZMh8bbQa3okaw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Florian Weimer <fweimer@redhat.com>
Cc: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
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
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, me@black-desk.cn, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 10:53=E2=80=AFPM Florian Weimer <fweimer@redhat.com>=
 wrote:
>
> * Chen Linxuan via:
>
> > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> > ioctl takes no argument and returns a close-on-exec O_PATH file
> > descriptor referencing the corresponding task path.  The new ioctls use
> > the same ptrace permission check and nonzero-argument rejection as the
> > existing pidfd namespace ioctls.
>
> How would one upgrade the O_PATH descriptor to a full descriptor without
> a mounted /proc?

For PIDFD_GET_CWD and PIDFD_GET_ROOT, the returned O_PATH descriptor is
typically used directly as a base directory for openat(2) or passed to
fchdir(2), so upgrading it to a full descriptor is usually unnecessary.

For cases where upgrading an O_PATH descriptor to a full descriptor is
required without /proc mounted (such as inspecting the executable binary
from PIDFD_GET_EXE), users can use the newly added O_EMPTYPATH flag with
openat2(2) (introduced in Linux 7.2) to reopen the O_PATH descriptor.

>
> Thanks,
> Florian
>
>
