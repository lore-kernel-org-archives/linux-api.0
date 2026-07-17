Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DF137267E
	for <linux-api@vger.kernel.org>; Fri, 17 Jul 2026 08:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277382; cv=none; b=iwhAS7haw0sfpi8UrF3yubdHKkwvJyf61eAA7dX65aVlo8TqOJxqDWPLCYm7TnhqgvgsZ69/XhiISgmvNfDecjcjJVeUr8FZ909JMLJvzhL/ENKK82cpAH90ltQwaSXx7SIGZomi2utLGLTbfWYofYMguI16AoTFWMop+E6NGLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277382; c=relaxed/simple;
	bh=ytmJn7WrbkAAS/JcwqWthbo8X8ASYYPjUVH9V9suPaE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=j9kmkK7swI52vnWO5bUCjakZvrGBEjwtxrGyFIQLVJ6qX6z95a1i705uCjujtB0o8oD74qysFn/uqrwsmkSCLMZpr1A1XzVhUYBs1q62ajRtz34Ko96OG3ehyNFIb/ulITsgd1R65vnp+Rqm2wicAl+FafWE+8kePjXkY6vtShY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T+Ma87la; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T+Ma87la"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784277380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DTjHuVxxnucP3oWCaBHjjvq6v3XBpio8ReEJVSd1kMo=;
	b=T+Ma87la/mHzVL8fsxnDG603yuvSkPtyZTvUtbFDH7BUBh8RF5kyXuWPFlWdIGpiDovde2
	eRshmEF55lbH9Aq4EhnXa51SFcX94U39NbYpOpdApQTZASSrbQDJ/I7NtkNTbu2I5ZQ/UD
	HFczVzSVYsuN9bzzr9bPAAYlXnKJPk0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-27-AdeZ7ONNPCaL39GMboB9Dw-1; Fri,
 17 Jul 2026 04:36:16 -0400
X-MC-Unique: AdeZ7ONNPCaL39GMboB9Dw-1
X-Mimecast-MFC-AGG-ID: AdeZ7ONNPCaL39GMboB9Dw_1784277375
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E118D195608E;
	Fri, 17 Jul 2026 08:36:14 +0000 (UTC)
Received: from oldenburg3.str.redhat.com (unknown [10.44.49.96])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA0663004082;
	Fri, 17 Jul 2026 08:36:12 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Carlos O'Donell <carlos@redhat.com>,  libc-alpha@sourceware.org,
 linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] elf: load the main program from AT_EXECFD
In-Reply-To: <20260717-heilpflanzen-mondschein-dackel-bb9dc1dbe965@brauner>
	(Christian Brauner's message of "Fri, 17 Jul 2026 01:00:28 +0200")
References: <20260715-work-glibc-binfmt_misc-v1-0-b3b14336e664@kernel.org>
	<lhucxwoqzlu.fsf@oldenburg.str.redhat.com>
	<20260715-feuilleton-lautlos-anzweifeln-2117c47bf100@brauner>
	<87ik6fymha.fsf@oldenburg.str.redhat.com>
	<20260717-heilpflanzen-mondschein-dackel-bb9dc1dbe965@brauner>
Date: Fri, 17 Jul 2026 10:36:10 +0200
Message-ID: <874ihyypvp.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Summary for kernel list: We are looking for ways to make executables not
loaded by the kernel more compatible with the rest of the system.  That
includes proper /proc/self/exe and auxv values.  The discussion was
triggered by Christian's binfmt_misc patch, which happens to share many
of the problems when /usr/bin/ld.so is used to load programs (instead of
the kernel).

* Christian Brauner:

> On 2026-07-16 17:37:21+02:00, Florian Weimer wrote:
>> * Christian Brauner:
>> 
>> >> What does /proc/self/exe look like for such processes?  Does GDB work?
>> >
>> > Right, I checked that.
>> >
>> > /proc/self/exe is ld.so. The kernel exec'd ld.so, so it names ld.so
>> > whether the program arrived via AT_EXECFD, via --program-fd, or via a
>> > plain "ld.so PROG" command line.
>> 
>> Yeah, and that causes problems with binaries that try to be relocatable.
>> We don't have a very convenient way to get the correct path in those
>> scenarios, so a lot of code uses /proc/self/exe instead.
>> 
>> I'm wondering if we can use the checkpoint-restore facilities (the
>> restore parts) to fix this: load ld.so another time, transfer control to
>> it, and instruct it to unmap the first copy and then invoke the
>> necessary prctls to make the process look exactly like a directly
>> invoked process.
>
> At first I was very confused about this proposal but I think I
> understand what you are after now. Your point is that we shouldn't just
> fix argv like in my proposal but actually even fix the exe file and
> remap.

Not sure about remap.  But I think to turn this into an it-just-works
solution, we need to fix /proc/self/exe and the auxiliary vector.

> So I think doing this purely in userspace isn't doable. The restore
> parts can fix everything except the exe link. PR_SET_MM_MAP requires
> capabilities in the relevant user namespace for the exe file. That makes
> it pretty useless for us. And dropping that capability requirement isn't
> feasible, I think. LSMs and audit trust the exe link, so an uncapped
> exe file would let any process masquerade as an arbitrary executable.

Is the latter really a problem?

Today, it's possible to stop a process that is SUID on disk before it
runs any code: 

$ ls -l /proc/163710/exe
lrwxrwxrwx. 1 fweimer fweimer 0 Jul 17 10:11 /proc/163710/exe -> /usr/bin/su

(gdb) info thread
  Id   Target Id           Frame 
* 1    process 163710 "su" 0x00007f5ae2f24e40 in _start ()
   from /lib64/ld-linux-x86-64.so.2

This is with kernel.yama.ptrace_scope=1.  I assume this gives me full
control over a process that is nominally running /usr/bin/su.  Even
AT_SECURE is set to 1:

Breakpoint 2, main (argc=1, argv=0x7ffd77cfb2e8) at login-utils/su.c:5
5	{
(gdb) print __libc_enable_secure
$1 = 1
(gdb) print (int) getuid ()
$2 = 1000
(gdb) print (int) geteuid ()
$3 = 1000
(gdb) print (long) getauxval(23)
$4 = 1

Of course, the AT_SECURE transition did not actually happen, and the
process is running with the original user privileges.

> Everything else (the entire saved auxv, the start/end_code/data, brk and
> stack markers) is validated but requires no capability at all. So an
> unprivileged ld.so can already repair /proc/<pid>/auxv and the
> stat/statm code accounting, but never /proc/self/exe.

It's good for us if AT_SECURE does not need protecting.  We would like
to use a fake 1 value in our test suite.

> Unmapping the first copy is also not really feasible. Even with
> privilege making this work would be very ugly: The kernel's
> replace_mm_exe_file() refuses with -EBUSY while any vma still maps the
> old exe file. From my research, CRIU works around exactly this by
> copying its restorer blob into an anonymous mapping before it unmaps the
> old address space.

Unmapping the first copy was only my idea to make this work with the
existing kernel facilities.  It's not required for the binfmt_misc case
and most /usr/bin/ld.so scenarios, and actually drives up complexity
considerably.

> So I think the exe link should be fixed up at exec time.
> begin_new_exec() sets mm->exe_file to bprm->file which after the
> binfmt_misc handoff is the interpreter. But bprm->executable is the file
> the kernel access-checked and kept open for AT_EXECFD. We have it right
> there. This is the file that would_dump() uses for it's decision and
> binfmt_misc's 'C' flag derive credentials from.
>
> We simply need an extension to binfmt_misc that sets mm->exe_file to
> bprm->executable. Then it is correct from the start and there's no
> window and no privilege question and existing 'O'/'C' users (qemu-user
> registrations) are unaffected. It then raises AT_FLAGS_PRESERVE_ARGV.
>
> On the userspace side, ld.so now sees this AT_* flag and in response
> issues one uncapped PR_SET_MM_MAP (that's available completely
> unprivileged) to retarget AT_PHDR/AT_ENTRY/AT_BASE and drop the stale
> AT_EXECFD from saved_auxv.
>
> With both in place, attaching gdb to a dispatched process is fully
> correct and /proc/self/exe-based self-location works. As a bonus the
> program file gets the same exe_file write-denial a directly executed
> binary has. Today it is ld.so that gets pinned and the running program's
> file stays writable while its text is mapped.
>
> After this, only uninteresting differences should be left. This would be
> a follow-up series I'm happy to do. Does that sound reasonable?

The proposal looks quite straightforward.  It's a shame that it does not
fix the /usr/bin/ld.so case.  Is there anything we can do to address
that?

I wouldn't mind if we had a system call that triggered the kernel ELF
loader for the main executable.

Thanks,
Florian

