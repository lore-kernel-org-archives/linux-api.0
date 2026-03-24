Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01CD3E2755;
	Tue, 24 Mar 2026 11:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774352004; cv=none; b=tmJDR9e4+T1lIOnX6qwdyAOrXvI0hMCUKjAkEPx6wMBGLXGoWoMfUfMRYWck69m+VZ9Iw2eWPcjoLD7RpxjWMYze+Kfty1svvzDAtsQeJcwSYDwLg2i6bm8IZP+pdZQ3K9xjWPeovIxQ+zEc7H45S5jjRWZ6q3XhjW8iSDGZ4gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774352004; c=relaxed/simple;
	bh=ePPalIgg9PA9MCfjCpp8oHYfR8UicQpTOa+6XnR0aI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxn2U50pLxJN8c8ckp+3pilKmutCTCFALS4j1u21a5jlxA285LlkI42J7nHBFhNeT8BuuFa51XuLJE84iApOfLLZEyMU7n9r8B1h0i52r/1NUPwzqJT6pfrbbFYIUl8IUki6qx8/TOHF0e4idx2vyFJ0tjHrRnHCMUBgb+Zhagc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2qWxv6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2qWxv6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13859C19424;
	Tue, 24 Mar 2026 11:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774352004;
	bh=ePPalIgg9PA9MCfjCpp8oHYfR8UicQpTOa+6XnR0aI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P2qWxv6K0w5Xbm53d2TWqvQIthrkpHsbYVZ6Z9sWjeq4Bbn79xA3u1A1gQJkAoXsW
	 z80rpTUWyJzQAf4CAtWj8YIqd6AlcGMTlZUVep7sW2iQTTVzJF49cz4NxnFqlc/JPr
	 YWC/NhMBBXhPgY0MfSIMjC346ciyg26qn+oM1mrX4yPtfdxpX6IqKvE0KcXuNulk7C
	 +0staUq/7YmkMUd7t3MNJ3adKH/68nBDba9sTOIUHCA/PV/i0oG1FcJ9o8WX0x4iii
	 /317o9eYcsgYa2k1z4Oh9Lpu9ehuZEXIx3bPTRNi/UOYmiCfFRy5TnCTTmoWCi0OB/
	 Jp4A7svm/HrHQ==
Date: Tue, 24 Mar 2026 07:33:22 -0400
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kselftest@vger.kernel.org,
	workflows@vger.kernel.org, tools@kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>, Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Askar Safin <safinaskar@zohomail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/9] kernel/api: add debugfs interface for kernel API
 specifications
Message-ID: <acJ2gnnA9MP1wO_Z@laps>
References: <20260322121026.869758-1-sashal@kernel.org>
 <20260322121026.869758-4-sashal@kernel.org>
 <2026032309-jargon-stalling-28c2@gregkh>
 <acHTupVGxJR3gmFT@laps>
 <2026032411-paramount-lapdog-41e6@gregkh>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2026032411-paramount-lapdog-41e6@gregkh>

On Tue, Mar 24, 2026 at 09:20:01AM +0100, Greg Kroah-Hartman wrote:
>On Mon, Mar 23, 2026 at 07:58:50PM -0400, Sasha Levin wrote:
>> > But this only works if the kabi stuff is built into the kernel image,
>> > right?  This doesn't work if any of these abi sections are in a module
>> > or am I missing that logic here?
>>
>> That is correct, for now.
>>
>> I'm only trying to tackle syscalls to begin with, and since no syscalls live in
>> modules, we have no need for module support.
>
>We used to support syscalls in modules, but thankfully that is now gone.
>But, how will this work for stuff like usbfs ioctls?  That is a module,
>and our uapi is, by far, in drivers through ioctl "hell" and that would
>be great to be able to document through all of this.  Will that just not
>be in the debugfs api?

It will. I see it working just like how BTF or trace events do it now.

When a module loads, find_module_sections() extracts the .kapi_specs section
pointer and element count into new struct module fields. The COMING notifier
then iterates those specs, registers each via the existing kapi_register_spec()
dynamic registration path, and creates per-spec debugfs files under the
existing /sys/kernel/debug/kapi/specs/ directory. The kapi_list_show() function
is extended to also walk the dynamic_api_specs list (currently it only iterates
the static __start_kapi_specs..__stop_kapi_specs range). On GOING, all specs
owned by that module are removed from the list and their debugfs entries
cleaned up via debugfs_remove().

-- 
Thanks,
Sasha
