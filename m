Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1453739CCEA;
	Thu,  8 Oct 2026 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791470283; cv=none; b=HSOFVcE6i0FQY9kDdDcN6ZNazQQx2MlGE2XJzfAHY7aok9EmN5mu1syMY/qv4JRO3PlA9iqSULnUsJtJaBVvHVtOguuBqt3w5k1S4bacSHTAlkY7gzvoHhA5CctfYPfI/rsNLYAej8IahnN3Y9je5COuWF0pYIiVeMftncwT0eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791470283; c=relaxed/simple;
	bh=rA5skIoCPcE42+Tf+tp2deQs6rPoqGyBply0MRs54XA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxVHmU/yKp+awz6Be3OUc2mSCtF3YnCFFatgmcBLX+GHKdLSPX2C/5gLVeoyLAP9bg1hzKH80jBM6p1bRFvYtbevJue27J21EFvBadbwj+Ce2VK2BEhbrYPFlrIfP0o04uTBNV8xXSU0h02MiVJxCcSof2TWR1hRbOt2lyDcau0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHURRbAE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHURRbAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5781F000FF;
	Thu,  8 Oct 2026 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791470281;
	bh=SuXikuDg/o2Bvv984UEjh+nVNNI4IGW7vLUJASo/KyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mHURRbAERL6hsbzO0EGp8LzMrgdikEX61u06/oPEjQbQfE0aHNcdbo9ejcrbdFfsX
	 qk4UT8bfDS3zpZLHFgKwrb6kkcDFSoibGyk1psqW1+m9Z/+UpZP52uM/D0tIIvrWRp
	 jeXok6zLGO8c+DY6OjvNnQFGKU8oUw87I42Zu/OkiVG6ejcOHda7PPqpY637yTh0ht
	 qc9wzIiY3Uod7Wxvoljd335t/GzNQQIlVmY5FOh0m6gtwD6SQw/hKikdRE8OZEmrXv
	 l+sICVjVvZuCjc6szJ962iirblfKDtDpXHd8kTYiwZucDSoRjtS2dQ8Fz18hBIPRAm
	 4p5/IX6FDjrgg==
Date: Thu, 8 Oct 2026 10:37:59 -0400
From: Sasha Levin <sashal@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Gregory Price <gourry@gourry.net>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org,
	tools@kernel.org, x86@kernel.org, Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>, Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v5 05/11] kernel/api: add API specification for sys_open
Message-ID: <aseqx-uc_QySDiiw@laps>
References: <20261008084956.2911790-1-sashal@kernel.org>
 <20261008084956.2911790-6-sashal@kernel.org>
 <aseRXi7hMWBBc0tB@hallyn.com>
 <aseWPV6ZRQM3JOMN@gourry-fedora-PF4VCD3F>
 <asemkQ2v0di0Eea3@hallyn.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <asemkQ2v0di0Eea3@hallyn.com>

On Thu, Oct 08, 2026 at 09:20:01AM -0500, Serge E. Hallyn wrote:
>On Thu, Oct 08, 2026 at 09:13:38AM -0400, Gregory Price wrote:
>> On Thu, Oct 08, 2026 at 07:49:34AM -0500, Serge E. Hallyn wrote:
>> > On Thu, Oct 08, 2026 at 04:49:45AM -0400, Sasha Levin wrote:
>> > > Add KAPI-annotated kerneldoc for the sys_open system call in fs/open.c.
>> > >
>> > > The specification documents parameter constraints (pathname, flags
>> > > bitmask, permission mode), 24 error conditions, locking requirements,
>> > > side effects, required capabilities, and usage examples.
>> > >
>> > > Assisted-by: LLM
>> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> >
>> > I know Kees and Jonathan and others asked for exactly this.  But one
>> > downside to this is it makes just paging through fs/open.c a lot more
>> > painful.  Maybe it's worth it.  Maybe "noone will ever do that again" bc
>> > that's why we have ai and tools.  But a) that's how I've historically
>> > done a lot of code research, b) IMO something like a manpages section 2
>> > under Documentation/ would be a great place for this, and c) we can also
>> > use tools to always sync these, or even show/edit in a single view when
>> > you want  ('kdocedit fs/open.c').
>> >
>>
>> In many, many other projects i've worked on, these docs are placed in
>> the header as opposed to the .c file, but I understand there is some
>> pain that comes with ifdef.
>>
>> Keeping it in the header ties the definition to exactly the location
>> external users import to find the function - so it makes sense.
>>
>> But separating the contracts from the code guarantees they'll go stale,

My plan is to be able to have the more detailed part of these specs somewhere
else, specially as they will grow some more, but I didn't want to add this
complexity right now.

>OTOH these descriptions are so long that IMO they are guaranteed to go
>stale anyway :)  While I'm editing a return value at the bottom of the
>fn, most or all of the description is already going to be off my
>terminal.
>
>> so I don't think shoving it in Documentation/ does anyone any good.
>
>If every build auto-generates an update and then looks for and flags
>meaningful changes (API breakages), then a) that is more reliable and b)
>it doesn't matter where the docs are.
>
>Even if there's just a three line comment above a fn, history proves
>that it will not reliably stay in sync as the fn changes.  An automation
>step/check is needed.

Please see CONFIG_KAPI_RUNTIME_CHECKS added by this series.

-- 
Thanks,
Sasha
