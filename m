Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB4938A715
	for <linux-api@vger.kernel.org>; Sat,  6 Jun 2026 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780753230; cv=none; b=ebY9vGJhc+cGQGeF94aochKaCAe12LIcq5eFH+P7T9fEakPlOUoG5X9KinsZIiwtQ9gqNZ1ksWr0LPi7mrIfulyEwcaIbu2N5ChnO28nUW9LKfUmH9vu7NXvjW24P3iT/vXiGRjh3KNiPyRuBc3DW2kCvbTczK5wz5qP+s7G3vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780753230; c=relaxed/simple;
	bh=daxTICY9+4oyCPFqZwIDiF2rgI59swk+SqQ5orvTnv4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rgHwP+DKCeWGiyg39MM4r5l62ZnRMcIsS/dtWMQMvanUx74D/zGdzh3tIEYfSj6wMMpUZCgK4rZU+d1szIUTQg9ZaCLhteqPUhTjt1yaG0dI5UNLwGfzrfam2d+NJV09aV4D+aNteNlx4yb1YAOVvOik2fhSF8fejS1KN993mI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A1bJgib1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1bJgib1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780753228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJefgt/1tnzhpscofCHCp7cRfEweqd5NV5/E12R++QY=;
	b=A1bJgib1shnqS8zCdCRBOwgSMn59H3zhT5lwOF5YK5rA6QLWqJowzepjSD85B8mGLy6snQ
	/6TWWiE7eRjGKX+125VwfaES3GncdlvPTINDTRkxsiZ80ddpLXbYKEGmfE9e66LIFtXa7I
	RgOl++C1rxgbLUw9LebArUgpNylrPRA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-IeK5tGREM2SYpCllOs04hQ-1; Sat,
 06 Jun 2026 09:40:23 -0400
X-MC-Unique: IeK5tGREM2SYpCllOs04hQ-1
X-Mimecast-MFC-AGG-ID: IeK5tGREM2SYpCllOs04hQ_1780753220
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA9941956089;
	Sat,  6 Jun 2026 13:40:19 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.44.48.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88A1E1955BC0;
	Sat,  6 Jun 2026 13:40:13 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Richard Patel <ripatel@wii.dev>
Cc: x86@kernel.org,  "H. Peter Anvin" <hpa@zytor.com>,  Peter Zijlstra
 <peterz@infradead.org>,  Rick Edgecombe <rick.p.edgecombe@intel.com>,
  Yu-cheng Yu <yu-cheng.yu@intel.com>,  Dave Hansen
 <dave.hansen@linux.intel.com>,  Thomas Gleixner <tglx@kernel.org>,  Ingo
 Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>,  David Laight
 <david.laight.linux@gmail.com>,  Andy Lutomirski <luto@kernel.org>,  Kees
 Cook <kees@kernel.org>,  Shuah Khan <shuah@kernel.org>,
  linux-kselftest@vger.kernel.org,  linux-kernel@vger.kernel.org,
  libc-alpha@sourceware.org,  linux-api@vger.kernel.org,  Arjun Shankar
 <ashankar@redhat.com>
Subject: Re: [PATCH v2 0/5] Usermode Indirect Branch Tracking
In-Reply-To: <aiMyaJ8zDl76YOVN@wii.dev> (Richard Patel's message of "Fri, 5
	Jun 2026 20:32:40 +0000")
References: <20260605184715.3383415-2-ripatel@wii.dev>
	<lhu1pek4w89.fsf@oldenburg.str.redhat.com> <aiMyaJ8zDl76YOVN@wii.dev>
Date: Sat, 06 Jun 2026 15:40:10 +0200
Message-ID: <lhua4t73hz9.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

* Richard Patel:

> On Fri, Jun 05, 2026 at 09:34:46PM +0200, Florian Weimer wrote:
>
>> How do you detect that handling a signal is complete and IBT can be
>> re-enabled?  Or is it re-enabled before entering the userspace signal
>> handler?
>
> Hi Florian,
>
> In v1, we backed up the IBT CPU state into the (user-accessible) signal
> frame from FRED/XSAVE, then restored it:
> https://lore.kernel.org/lkml/20260517183024.16292-4-ripatel@wii.dev/
>
> In v2, when entering the signal handler, the kernel just context switches
> to the new user rip, bypassing IBT checks (continues executing if the
> signal handler does not begin with endbr).

What's the reason for this?

> Some time in the future, ideally:
> - signal handler is *required* to start with endbr (this is easy)
> - sigreturn as in my asm example enforces endbr after returning from a
>   signal handler to a in-progres indirect branc
> - libc (sig)longjmp is made IBT-compatible

I think the compiler already emits ENDBR markers for returns-twice
functions, which is why longjmp does not use a no-track jump.  Other
architectures require such a proliferation of markers because they do
not support no-track jumps at all.  However, longjmp is arguable a
corner case.  It's not completely safe, like loading a function address
from a RELRO GOT and jumping to it.

> Btw, I had self-tests for the v1 design, and {signal handle,rt_sigreturn,
> siglongjmp} with {success case,violation} works flawlessly with Fedora 44
> glibc amd64. With glibc i686 I ran into PLT issues, probably my fault.

There's no IBT support planned for i686, that's why we dropped all
marker instructions in Fedora.

> It is quite surprised that siglongjmp was working, btw, since the glibc
> longjmp code uses 'jmp *reg' (without notrack prefix). I guess you do an
> endbr64 at the setjmp side?

Yes, compilers generate landing pads for returns-twice functions.  Not
ideal, but it's the only way to get setjmp working on targets without
NOTRACK.

>> Adding the ELF GNU note parsing can be added later, but perhaps not
>> cleanly.  I'm still a bit worried we might have to rev the markup
>> because too many binaries are in circulation that claim compatibility,
>> have never been tested, and are actually broken.  If the kernel does not
>> look at the ELF bits, things a slightly simpler.
>
> Phew, I was hoping you'd say that.
>
> If you want, I can sketch out glibc IBT enabling and test it on Debian
> and Fedora, which IIRC already emit compile with -fcf-protection=branch
> for all OS packages.

For Fedora, please coordinate with Arjun (Cc:ed), who is going through
the motions of enabling SHSTK for real.

>> That's not necessarily a problem because its address cannot be directly
>> overwritten in userspace.  Not all indirect branches need to be checked,
>> only those that have tweakable targets.  In fact, fewer ENDBR64 markers
>> are better (although we wouldn't drop the marker from a signal handler
>> specifically, of course).
>
> Just one concern I have is that people start relying on signal handlers
> not requiring endbr64, and then a future kernel version breaking them once
> we enforce it.

Would software enforcement be a possibility?  The kernel could check if
the landing pad is there.

Thanks,
Florian

