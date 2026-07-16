Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D46412BF4
	for <linux-api@vger.kernel.org>; Thu, 16 Jul 2026 15:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784217495; cv=none; b=aVAnFblkDUKYrB4+1l1mRstfBwsdkPFsHtH7cLG5gzRJIlCXqzm6K9Tqyjf8TSUpZtTotMHw5sZi/fjeXOh9/yvCRhbjsNefK/3/YTiMDAnTf9E+qzbex/8387YkGuFH2On+FSGECWcPFW/0mHZwgG2Y1ik23GFU00cpJIvFAA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784217495; c=relaxed/simple;
	bh=McYMkfK0155RBe/5czA8TEiID0yUFtikbTvaF0Y4F9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LJKvwM9X464mh55meGYnC4zXyp+baeikeE2hpFluNbvNe/Lb9cm7nAvq8R29QwzJ3w0pF++g9NgVmzJsiwSBbjp2Ic1sMAadsVssPrCFZv1WBK6EamexRR422v7epM+j0X7W/peDDEljeRdFnBGXo0VMCPnpG2fOnwAIvEFlI2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWOPc18D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWOPc18D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CAA1F01565
	for <linux-api@vger.kernel.org>; Thu, 16 Jul 2026 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784217492;
	bh=g6oSqoiMEa7OzZXyjPnpquDQDeAESj15pX4ZUB9li/c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OWOPc18DUN5kQHrt+xLBtV2PjEZdVi69MM0+NpTl/NYFqRkmVq7sgKSbBUJyppKyr
	 tktDa2H5OLMRJY9fgw77kBkND0XQCSxoVGfsUWBqMLgr3olYo5q705QCWsC84Kz7lG
	 bUZsYA2uTK72J/d8YIx26+d5PnOEou2YboEW0P33zbpj/HtSFLhu8xtc2dUpHX6AWj
	 QRXBynl87zcZl/2F5t17zJM4hrp9eoKy11agItqqqz6js/nESyrVRp9WLk51YXvVQz
	 GOtXvB96ERTiQKX47jzJjE9WW0kC3MFhVgLi3EWtQgacnVqrN4SdqLaPz4E4GRIxcN
	 sHtsksHvmzyvQ==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39b3931e259so62306101fa.2
        for <linux-api@vger.kernel.org>; Thu, 16 Jul 2026 08:58:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqAYpdnOqLdW5rpHiqBv8Rz/SPcWJMLUL4bKNIVHs/+OXuJ6b414QdCLu1AeivCjf2aMgO15lgD8E0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCu69kKIh/XKMAO0UfyYYGgS7hZ9bZKNK+4eavDu0UydfhAYGG
	2Tssvl0SaGiy9wzEHk9CAJxu8GKBC77rihc/pPivZ3WmHsniFvCBpjG8w5RCS+7Z4sOWlbAJoCa
	sNAjrYu1/uva3A38k6iwyimGIBIf84wO+PgOuV9t+
X-Received: by 2002:a05:6512:64e4:b0:5b0:1b78:497a with SMTP id
 2adb3069b0e04-5b15d7b2ccbmr1132556e87.46.1784217490875; Thu, 16 Jul 2026
 08:58:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784204592.git.me@linux.beauty> <538e494dd8fcc677da24ec985c6e90dde554e7f3.1784204592.git.me@linux.beauty>
In-Reply-To: <538e494dd8fcc677da24ec985c6e90dde554e7f3.1784204592.git.me@linux.beauty>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 16 Jul 2026 08:57:58 -0700
X-Gmail-Original-Message-ID: <CALCETrU2sCf_Ab2oDcUuJV53mhaDHTtf7QNqPJuFxV_ESHkbtg@mail.gmail.com>
X-Gm-Features: AUfX_mxAk_l8G-Iv8v_7CV1_wrfRphfDpCG9qyDjwBEY1AgFD3q_hB2zypmmUZY
Message-ID: <CALCETrU2sCf_Ab2oDcUuJV53mhaDHTtf7QNqPJuFxV_ESHkbtg@mail.gmail.com>
Subject: Re: [RFC PATCH 12/24] fork: let kernel callers create embryonic tasks
To: Li Chen <me@linux.beauty>
Cc: Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
	Gabriel Krisman Bertazi <krisman@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	Mateusz Guzik <mjguzik@gmail.com>, Andy Lutomirski <luto@kernel.org>, John Ericson <mail@johnericson.me>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	audit@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 8:52=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
>
> A kernel-created task can become visible before it has installed a new
> executable image or a valid userspace register frame. Exposing such a tas=
k
> through ptrace can disclose kernel setup state.
>
> Add a task-local embryonic flag and an internal clone argument for caller=
s
> that need this lifecycle. Reject ptrace access until the creator clears t=
he
> flag. Clear it with release ordering and observe it with acquire ordering=
.
> This orders visibility of the completed exec state with the transition.
>
> Existing fork, vfork, clone, and kernel-thread callers leave the argument
> unset and retain their current behavior.
>

> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -56,6 +56,8 @@ bool ptracer_access_allowed(struct task_struct *tsk)
>         guard(rcu)();
>         if (ptrace_parent(tsk) !=3D current)
>                 return false;
> +       if (task_is_embryonic_exec(tsk))
> +               return false;
>         es =3D task_exec_state_rcu(tsk);
>         return READ_ONCE(es->dumpable) =3D=3D TASK_DUMPABLE_OWNER ||
>                ptracer_capable(tsk, es->user_ns);
> @@ -312,6 +314,8 @@ static int __ptrace_may_access(struct task_struct *ta=
sk, unsigned int mode)
>                 WARN(1, "denying ptrace access check without PTRACE_MODE_=
*CREDS\n");
>                 return -EPERM;
>         }
> +       if (task_is_embryonic_exec(task))
> +               return -EPERM;

Would it be better to use a different error code?  -ECONNREFUSED?
After all, this isn't a permission failure per se.

There's a not-locally-obvious gotcha here: reading other process
attributes prior to calling task_is_embryonic_exec may result in
(security-relevant!) data races.  This should at least be documented
-- it's critical to check task_is_embryonic_exec *before* trying to
read credentials.  Also, I think /proc and many pidfd APIs have the
same issue.

--Andy
