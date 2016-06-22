From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: Documenting ptrace access mode checking
Date: Wed, 22 Jun 2016 23:51:42 +0200
Message-ID: <20160622215142.GA14751@redhat.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com> <87ziqewc3r.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ziqewc3r.fsf@x220.int.ebiederm.org>
Sender: owner-linux-security-module@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Jann Horn <jann@thejh.net>, James Morris <jmorris@namei.org>, linux-man <linux-man@vger.kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, lkml <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 06/21, Eric W. Biederman wrote:
>
> Adding Oleg just because he seems to do most of the ptrace related
> maintenance these days.

so I have to admit that I never even tried to actually understand
ptrace_may_access ;)

> We certainly need something that gives a high level view so people
> reading the man page can know what to expect.   If you get down into the
> weeds we run the danger of people beginning to think they can depend
> upon bugs in the implementation.

Personally I agree. I think "man ptrace" shouldn't not tell too much
about kernel internals.

Perhaps Documentation/security/ makes more sense?

Oleg.

