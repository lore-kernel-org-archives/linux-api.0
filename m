From: Kees Cook <keescook@chromium.org>
Subject: Re: Suggested Patch is not working for 22851 Bugzilla issue
Date: Wed, 20 Nov 2019 10:39:40 -0800
Message-ID: <201911201032.67566C6BF@keescook>
References: <CAJKzgVtzD7ULwCDVRSLMCmGJNaMqvx+jVO619t3xuv2oiEsPMQ@mail.gmail.com>
 <20191119095708.GB21113@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191119095708.GB21113@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Bala S <balas2380@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 19, 2019 at 10:57:08AM +0100, Michal Hocko wrote:
> let me add Kees Cook and Linus to the cc list. I didn't have much
> time to study the bug report and cannot really comment on the security
> aspect of it. But let me point out that a big part of
> MAP_FIXED_NOREPLACE usage has been removed from the loader code just
> recently because it has caused some regressions
> http://lkml.kernel.org/r/20191005233227.GB25745@shell.armlinux.org.uk
> b212921b13bd ("elf: don't use MAP_FIXED_NOREPLACE for elf executable mappings").
> So you definitely want to look at the current Linus tree for your future
> experiments.

Hi!

Yes, as Michal mentions, there were legitimate binaries that expected to
overlap mappings, so we had to revert the MAP_FIXED_NOREPLACE logic for
now. At the time I added a TODO item for fixing this up correctly here:
https://github.com/KSPP/linux/issues/17

Speaking to the ldd issue (not the kernel binfmt_elf.c loader, which
is very separate), there isn't a security issue here: ldd can in many
cases _execute_ the binaries it is examining. This is a well known flaw
(as Florian points out in the bug report).

Is there some other piece of this puzzle you're trying to solve? I'm
always open to hearing new ideas in this space.

Thanks!

-Kees

> 
> On Tue 19-11-19 10:37:44, Bala S wrote:
> > Hi Mhocko,
> > 
> > https://sourceware.org/bugzilla/show_bug.cgi?id=22851
> > For the above issue, I have found the patch.
> > 
> > Patch link:
> > https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1561935.html
> > 
> > Only change i noticed is 'MAP_FIXED_NOREPLACE' is used instead of
> > 'MAP_FIXED_SAFE'.
> > 
> > I ran test case on the following targets with this patch:
> > 
> > 1. For X86-64, Still i could see the reported issue( 'libevil.so' just
> > runs ‘cat /etc/passwd')
> > 
> > 2. For MIPS-64, i am not seeing the malicious file content as
> > reported. But ‘ldd’ could not found ‘libevil.so’.
> > 
> > root@qemumips64:~/LIN1019-1806# ldd ./main
> >         linux-vdso.so.1 (0x000000fff1f20000)
> >         libevil.so => not found
> >         libc.so.6 => /lib/libc.so.6 (0x0000005e46f70000)
> >         /lib/ld.so.1 (0x000000fff7888000)
> > 
> > I am not clear why this patch is not working for X86-64? But it is
> > working for MIPS-64 with some issue.
> > Please let me know, if anything is pending on this patch for the reported issue.
> > 
> > Thanks,
> > Bala
> 
> -- 
> Michal Hocko
> SUSE Labs

-- 
Kees Cook
