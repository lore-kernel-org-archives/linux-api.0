From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Wed, 31 Oct 2018 14:04:42 +0100
Message-ID: <20181031130442.GB9007@redhat.com>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181030150254.GB3385@redhat.com>
 <20181030155403.GC7343@cisco>
 <20181030162752.GB7643@redhat.com>
 <20181030163926.GC7643@redhat.com>
 <20181030172143.GD7343@cisco>
 <CAGXu5j+MYbAiSxdhLnQHdOZC-B=FWZoODxzwkYVEUqDc9SHnBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+MYbAiSxdhLnQHdOZC-B=FWZoODxzwkYVEUqDc9SHnBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@tycho.ws>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/30, Kees Cook wrote:
>
> I'd like to avoid changing the return value of __secure_computing() to
> just avoid having to touch all the callers. And I'd prefer not to
> change __seccomp_filter() to a bool, since I'd like the return values
> to be consistent through the call chain.

Sure, please forget.

> I find the existing code more readable than a single-line return, just
> because it's very explicit. I don't want to have to think any harder
> when reading seccomp. ;)

Heh ;) Again, please forget, this is cosmetic.

But I simply can't resist. I asked this question exactly because I was
confused by these 2 lines:

		if (__seccomp_filter(this_syscall, NULL, true))
			return -1;

		return 0;

to me it looks as if we need to filter out some non-zero return values and
turn them into -1. I had to spend some time (and think harder ;) to verify
that this is just the recursive call and nothing more.

nevermind, please ignore.

Oleg.
