From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Suggested Patch is not working for 22851 Bugzilla issue
Date: Wed, 20 Nov 2019 11:45:58 -0800
Message-ID: <CAHk-=wjw=fg5WznKfA+NQP78h8qDkF=t3CzH96fACAfULza_hQ@mail.gmail.com>
References: <CAJKzgVtzD7ULwCDVRSLMCmGJNaMqvx+jVO619t3xuv2oiEsPMQ@mail.gmail.com>
 <20191119095708.GB21113@dhcp22.suse.cz> <201911201032.67566C6BF@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201911201032.67566C6BF@keescook>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Michal Hocko <mhocko@kernel.org>, Bala S <balas2380@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 20, 2019 at 10:39 AM Kees Cook <keescook@chromium.org> wrote:
> Yes, as Michal mentions, there were legitimate binaries that expected to
> overlap mappings

I'm not sure they were really overlapping as much as "the ELF sections
were in a bad order and we don't do the whole "optimize loading"
thing.

It's one of those things that *might* be fixed by first creating a
"simplified/combined map of the ELF sections", and them using mmap()
on that simplified one. But that code is nasty and hairy.

             Linus
