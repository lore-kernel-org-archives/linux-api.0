Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C5C302146;
	Sun,  6 Sep 2026 10:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788691904; cv=pass; b=ufZWLrdjmcwgcjs/W5WI3Mz/lMkBpuq50JhHW/VwvWj4u9QPPRC7AyM5PtmowZjtDlxqYqWXoAEtCf80To5CKoWri+pV9lD3VsxMbHf21sYLoS4RsTPK3VXmEVorNdJXKwuEB3ImTncisiYzN78hGjMikGdwPiNTPyxy+/kerDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788691904; c=relaxed/simple;
	bh=5DEUFarM9EHefZ0wVYQQBuHqPXjSlIFqm4LAKK6cmFQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=axPeIBzikffWUg/f1juGA8pUU+fNLmZY+zhw5F1YL3KAOpTt4+GMD6/UiTlEEoKWlPJH0Sco4aR0RE1fZrVq2g6Yh7ZZQsePnALL9gpJwrZ7hBZByiEnIqPQcXQcJJfL1uDxfIfzZ7bUg9V911Q6eA+LNt/9qohVC7Vz00POVco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=MrrdizyY; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="MrrdizyY"
ARC-Seal: i=1; a=rsa-sha256; t=1788691854; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=HcHv7QGeAJiTzwkPsLHQtIHDXg+2BOTsRnQz63gL5tKUhmSrb+xsES5fvihLNwX7fRBkNlp/y2e9XWkSUnGxybGoddpScOdoipvFHHNsogDA+nnOriuvZFh9U48Js69etl/8831j0h6BBlQ8Ohq8Jh76aQHkt9reQR+fv2vkO2s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788691854; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rBoSHGzWKBhSuGS8r2av+j/7qxpuVCAqAJc8a/E78no=; 
	b=YpSRvGr0ZzH6qrZ+qbq04ewCgD+HEWhzNGG5niJ8ZdAMrLyqvIClzi2u9fd0xcMGYavMl4X4lNM48aeWNvgiCS8+0OnLSmc4E1FhO3heka1AsDUf6fqFCNKOi6haJEK8WO7mWQUYMKKWpc516Mfn/6aW5rukRx+vHQ8vygDeSys=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788691854;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rBoSHGzWKBhSuGS8r2av+j/7qxpuVCAqAJc8a/E78no=;
	b=MrrdizyYZV3Ev0Xkg+kB7NUWS6PN14cITmMXKJ/oZJt2nUbvveceskVWxdh63bKK
	XGTSGzsGkaH5x094cI7PomrPqnxP47UUqtkux5UkkWnBVmwMPqaEkZCLosN/1nK4l0k
	ajHvJCfYOrDP3LmLFinwkZUG/4RlhaUdwQ6aP/5U=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1788691853878565.2585404132941; Sun, 6 Sep 2026 03:50:53 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1788691851513989.1054873609904; Sun, 6 Sep 2026 03:50:51 -0700 (PDT)
Date: Sun, 06 Sep 2026 18:50:51 +0800
From: Li Chen <me@linux.beauty>
To: "Mateusz Guzik" <mjguzik@gmail.com>
Cc: "Justin Suess" <utilityemal77@gmail.com>,
	"Christian Brauner" <brauner@kernel.org>,
	"Kees Cook" <kees@kernel.org>,
	"Gabriel Krisman Bertazi" <krisman@kernel.org>,
	"Josh Triplett" <josh@joshtriplett.org>,
	"Andy Lutomirski" <luto@kernel.org>,
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
Message-ID: <1a07657a8e1.4ebd8dda3414368.7718440407238274005@linux.beauty>
In-Reply-To: <CAGudoHGoOr8rvhSQK+HQp7LmNyE9vP=xTok9eA1ZbV7uaVnMEg@mail.gmail.com>
References: <cover.1784204592.git.me@linux.beauty> <anJE8SfBLtkh6QSa@zenbox> <1a01795b07a.1f456216580426.3401229391386650127@linux.beauty> <CAGudoHGoOr8rvhSQK+HQp7LmNyE9vP=xTok9eA1ZbV7uaVnMEg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/24] pidfd: add a minimal process spawn builder
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Mateusz,

> First and a foremost apologies for radio silence, I got really busy
> with other stuff.

Thanks for making time to write such a detailed reply despite being busy
with other work. Sorry for taking so long to get back to you.

> I don't understand what race is supposed to be addressed either as
> none of the setup depends on the content binary.

You're right that none of the setup depends on an earlier check of
the executable. My earlier reply mixed up two different requirements:
executing whatever a pathname resolves to at exec time, and executing
a particular file selected earlier.

The posted RFC does the former. It stores the pathname without looking
up or inspecting the executable during configuration.

The caller-side race I had in mind was this:

caller                  another process        child
    |                           |                  |
    | inspect file A via path   |                  |
    | configure builder         |                  |
    |                           | replace path     |
    |                           | with file B      |
    | spawn_run()               |                  |
    |                           |      lookup -> B |
    |                           |      exec B      |

This matters if the caller expects the file it inspected to be the
one executed. Opening A first, inspecting it through that fd, and
using the same fd for execution avoids the pathname substitution.
The fd pins the file's identity, not immutable contents.

> Regardless I don't think this is going to fly as it directly shafts
> NUMA setups. What's needed is a path to the binary + the PATH
> envifornment variable or a collection of paths to try out.

I went back to the spawn_template discussion and realized that you had
already raised these NUMA concerns there, including child-side lookup,
PATH search, and target-node allocation. Sorry, I should have connected
your current comment with that earlier explanation.

> At minimum this will allocate a dentry and an inode for usr, bin and
> coolprog itself.
>
> Afterwards any path lookup going through usr in that that container
> will have to fetch memory from a non-local node to traverse it, same
> thing for the bin subdirectory.
>
> This is a self-induced problem when using a fd.

I see how opening the executable in the parent can populate cold
filesystem metadata on the parent's node, even though the child will
run on a different node. Making an executable fd mandatory would
force that early lookup on callers who could otherwise leave it
to the child.

> A well-known exec-heavy workload where this is fine is compilation.
> Any big project will do, to give you one trivial example, make -j
> $BIGNUM modules in the Linux kernel directory.
>
> [...]
>
> The stock kernel with the fork
> + exec machinery is doing a shitty job here, but the new mechanism can
> assure process-specific allocation to come form the target node as
> long as the scheduler does not mess up.

The compilation example helps too, and this matters even without explicit
affinity. Moving lookup into the child does not by itself address the
initial per-task allocations.

> 1. copy in whatever data it needs from userspace
> 2. if no affinity is specified, ask the scheduler: assuming something
> forks now, where is it going to run? the answer would be speculative
> ofc
> 3. to the minimum allocations needed (task_struct etc.) while passing
> the node number from above
> 4. have the newly spawned task handle everything else

I'll look into using the scheduler's speculative placement for those
initial allocations, then leaving the remaining work to the child
where it actually runs.

> In the real world userspace notoriously performs failed execs as it
> makes its way through dirs in provided in PATH, and while you can
> patch select programs all you want, the mechanism will have to account
> for it.
>
> [...]
>
> This in particular means that a failed exec would be very expensive,
> as it would go through task creation and teardown. Meaning the child
> needs to be able to figure out where to binary to execute is. And
> user-visible part has to account for it from the get-go.

Your point about failed execs during PATH search makes sense too.
Creating and tearing down a task for each candidate would be wasteful.
I plan to have libc build a list of candidate paths without doing any
filesystem lookup, and pass that list to the kernel. The child would
apply its setup once, then try the candidates in order, continuing
after recoverable exec failures in the same task.

That keeps PATH parsing in libc and lookup in the child. Relative paths
would stay relative, so they resolve against the child's cwd after file
actions. A single pathname would just be a one-entry list. This needs
interface support, and I'll need to work through the exec cleanup and
error handling to preserve the expected posix_spawnp() behavior.

I'm still unsure whether supporting both modes is a good interface
design. An fd option seems useful for callers that need to execute
the same file they opened earlier, while child-side pathname lookup
would avoid forcing that early lookup on everyone. I'm leaning
towards keeping both, but haven't settled on that yet.

> I'm going to write more after I go through the patchset, should be next week.

Thanks again for taking the time to explain this. I look forward to
your further comments.

Regards,
Li


