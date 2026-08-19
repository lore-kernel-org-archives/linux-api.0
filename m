Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652AA43C7DF;
	Wed, 19 Aug 2026 10:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787134843; cv=pass; b=euvGaCWwxCcZlsfIkmUuh0AFnlRVi8Pzr4nKZJpru/RocvQFfJcmmeqLvloOdtjHU4fDR7ULPogcWODqBY5kdkjHuOYsiY2tTp9YXII9b9VxLFwDzWu24mAQXcrTokJDw4yJBLpWDAwlJ4namqCRCAOXIvyD4//W4/FZCbrkcas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787134843; c=relaxed/simple;
	bh=UOlxkwCk3cH02PciWDMJUzXhehTpUXfUZwTZLjpkAtM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=e2GEbt43CTvZlz5P4BHMW0dekwCOW77Mg42BT+G8WgBdz3WKFxuVhEslD+ky7GUjtToIthipRDAlpsLlgx7C7bWmWIbB81OYq+8fVkwtJMqJyXZg9SsxGCyyI7qML8xPpruF7fISADOMZZUS23lvpwsrieeTx1i2XMcX9NaxdJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Ip3l/sK0; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Ip3l/sK0"
ARC-Seal: i=1; a=rsa-sha256; t=1787134793; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WNX19sQNfm9NLQmLvSi+kOC6ZCmTbJJ7WAVY89yP7PTkGWzI48mF+DZEo/5SsPfs5tlb4yuNiWbI8whaohcLtGM2LqnZrmG767uXf79yXwmVAB7O77r7oXZGIBJwqMB8isAop3UQDm++jthDlgiG547f9WvjtvGPheZBrO0zZIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787134793; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xVE/TCa3FajtK4vZ9pzEwtCdg70Sj2GwjXUwN4Rwvtg=; 
	b=m1yDPOiyrtBnVbwlCc4yAMvn9OuMq60JTYwKYRz96dPuRsHkh9JWEw9jRJLH3KzrYFhz6ZsgmyU4Ktd4Fnar6xtmdHKBdg+FLg6+i/yGf57NH2YOrjMvHpBZ61cXZLwpIjQKTgbmlC7P0LNCnVBro/Xy32P4nrAZOB7taA09dKM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787134793;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=xVE/TCa3FajtK4vZ9pzEwtCdg70Sj2GwjXUwN4Rwvtg=;
	b=Ip3l/sK0bMz2+Y8wX+yCZDGEhK2CXsJvKXXR7Xd+ofltThaYy/FvuKj3spwT7Ap1
	weE5M/KPPWjWCyFh68NS7xH94NEyG9FJ4Pjo5kahcKAJNReqm9UeS4NZJjb8BVFjZgq
	VGFBd45ONz+KGEc8vertMQ4mjLlGQRozXLe/zm3w=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1787134793322567.9703421532414; Wed, 19 Aug 2026 03:19:53 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1787134791630896.7239743078507; Wed, 19 Aug 2026 03:19:51 -0700 (PDT)
Date: Wed, 19 Aug 2026 18:19:51 +0800
From: Li Chen <me@linux.beauty>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Gabriel Krisman Bertazi" <krisman@kernel.org>,
	"Josh Triplett" <josh@joshtriplett.org>,
	"Mateusz Guzik" <mjguzik@gmail.com>,
	"John Ericson" <mail@johnericson.me>,
	"Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <shuah@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>, "Oleg Nesterov" <oleg@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Paul Moore" <paul@paul-moore.com>, "Eric Paris" <eparis@redhat.com>,
	=?UTF-8?Q?=22Micka=C3=ABl_Sala=C3=BCn=22?= <mic@digikod.net>,
	=?UTF-8?Q?=22G=C3=BCnther_Noack=22?= <gnoack@google.com>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Jan Kara" <jack@suse.cz>, "linux-api" <linux-api@vger.kernel.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"audit" <audit@vger.kernel.org>,
	"linux-security-module" <linux-security-module@vger.kernel.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>
Message-ID: <1a01988cfb7.7f8bf9df842660.5856426206659756785@linux.beauty>
In-Reply-To: <CALCETrU2sCf_Ab2oDcUuJV53mhaDHTtf7QNqPJuFxV_ESHkbtg@mail.gmail.com>
References: <cover.1784204592.git.me@linux.beauty> <538e494dd8fcc677da24ec985c6e90dde554e7f3.1784204592.git.me@linux.beauty> <CALCETrU2sCf_Ab2oDcUuJV53mhaDHTtf7QNqPJuFxV_ESHkbtg@mail.gmail.com>
Subject: Re: [RFC PATCH 12/24] fork: let kernel callers create embryonic
 tasks
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Andy,

 ---- On Thu, 16 Jul 2026 23:57:58 +0800  Andy Lutomirski <luto@kernel.org>=
 wrote ---=20
 > On Thu, Jul 16, 2026 at 8:52=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
 > >
 > > A kernel-created task can become visible before it has installed a new
 > > executable image or a valid userspace register frame. Exposing such a =
task
 > > through ptrace can disclose kernel setup state.
 > >
 > > Add a task-local embryonic flag and an internal clone argument for cal=
lers
 > > that need this lifecycle. Reject ptrace access until the creator clear=
s the
 > > flag. Clear it with release ordering and observe it with acquire order=
ing.
 > > This orders visibility of the completed exec state with the transition=
.
 > >
 > > Existing fork, vfork, clone, and kernel-thread callers leave the argum=
ent
 > > unset and retain their current behavior.
 > >
 >=20
 > > --- a/kernel/ptrace.c
 > > +++ b/kernel/ptrace.c
 > > @@ -56,6 +56,8 @@ bool ptracer_access_allowed(struct task_struct *tsk)
 > >         guard(rcu)();
 > >         if (ptrace_parent(tsk) !=3D current)
 > >                 return false;
 > > +       if (task_is_embryonic_exec(tsk))
 > > +               return false;
 > >         es =3D task_exec_state_rcu(tsk);
 > >         return READ_ONCE(es->dumpable) =3D=3D TASK_DUMPABLE_OWNER ||
 > >                ptracer_capable(tsk, es->user_ns);
 > > @@ -312,6 +314,8 @@ static int __ptrace_may_access(struct task_struct =
*task, unsigned int mode)
 > >                 WARN(1, "denying ptrace access check without PTRACE_MO=
DE_*CREDS\n");
 > >                 return -EPERM;
 > >         }
 > > +       if (task_is_embryonic_exec(task))
 > > +               return -EPERM;
 >=20
 > Would it be better to use a different error code?  -ECONNREFUSED?
 > After all, this isn't a permission failure per se.

Good point. I'm not sure ECONNREFUSED fits outside connection setup,
though. ESRCH may make more sense if the task is meant to appear hidden.
I'll think about this some more.
 =20
 > There's a not-locally-obvious gotcha here: reading other process
 > attributes prior to calling task_is_embryonic_exec may result in
 > (security-relevant!) data races.  This should at least be documented
 > -- it's critical to check task_is_embryonic_exec *before* trying to
 > read credentials.  Also, I think /proc and many pidfd APIs have the
 > same issue.

Agreed. Patch 15 later in the series already applies this ordering to procf=
s,
including cached dentry revalidation, and to PIDFD_GET_INFO.

The ordering requirement still needs to be made more explicit. I'll
document it, move the check ahead of ptrace_parent() in
ptracer_access_allowed(), and audit the remaining pidfd users before the
next version.

Regards,
Li=E2=80=8B

