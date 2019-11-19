From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Suggested Patch is not working for 22851 Bugzilla issue
Date: Tue, 19 Nov 2019 10:57:08 +0100
Message-ID: <20191119095708.GB21113@dhcp22.suse.cz>
References: <CAJKzgVtzD7ULwCDVRSLMCmGJNaMqvx+jVO619t3xuv2oiEsPMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJKzgVtzD7ULwCDVRSLMCmGJNaMqvx+jVO619t3xuv2oiEsPMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bala S <balas2380@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Hi
let me add Kees Cook and Linus to the cc list. I didn't have much
time to study the bug report and cannot really comment on the security
aspect of it. But let me point out that a big part of
MAP_FIXED_NOREPLACE usage has been removed from the loader code just
recently because it has caused some regressions
http://lkml.kernel.org/r/20191005233227.GB25745@shell.armlinux.org.uk
b212921b13bd ("elf: don't use MAP_FIXED_NOREPLACE for elf executable mappings").
So you definitely want to look at the current Linus tree for your future
experiments.

On Tue 19-11-19 10:37:44, Bala S wrote:
> Hi Mhocko,
> 
> https://sourceware.org/bugzilla/show_bug.cgi?id=22851
> For the above issue, I have found the patch.
> 
> Patch link:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1561935.html
> 
> Only change i noticed is 'MAP_FIXED_NOREPLACE' is used instead of
> 'MAP_FIXED_SAFE'.
> 
> I ran test case on the following targets with this patch:
> 
> 1. For X86-64, Still i could see the reported issue( 'libevil.so' just
> runs ‘cat /etc/passwd')
> 
> 2. For MIPS-64, i am not seeing the malicious file content as
> reported. But ‘ldd’ could not found ‘libevil.so’.
> 
> root@qemumips64:~/LIN1019-1806# ldd ./main
>         linux-vdso.so.1 (0x000000fff1f20000)
>         libevil.so => not found
>         libc.so.6 => /lib/libc.so.6 (0x0000005e46f70000)
>         /lib/ld.so.1 (0x000000fff7888000)
> 
> I am not clear why this patch is not working for X86-64? But it is
> working for MIPS-64 with some issue.
> Please let me know, if anything is pending on this patch for the reported issue.
> 
> Thanks,
> Bala

-- 
Michal Hocko
SUSE Labs
