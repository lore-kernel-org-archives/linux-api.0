From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Fri, 13 Mar 2015 11:08:14 -0600
Message-ID: <5503197E.2010109@osg.samsung.com>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au> <1426046765-19289-4-git-send-email-mpe@ellerman.id.au> <5500408B.2070604@osg.samsung.com> <1426130144.25936.4.camel@ellerman.id.au> <20150313163312.GA24666@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150313163312.GA24666@codemonkey.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@codemonkey.org.uk>, Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org, mmarek@suse.cz, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 03/13/2015 10:33 AM, Dave Jones wrote:
> On Thu, Mar 12, 2015 at 02:15:44PM +1100, Michael Ellerman wrote:
>  > On Wed, 2015-03-11 at 07:18 -0600, Shuah Khan wrote:
>  > > On 03/10/2015 10:06 PM, Michael Ellerman wrote:
>  > > > This adds make install support to selftests. The basic usage is:
>  > > > 
>  > > > v3: Rebase onto 4.0-rc2.
>  > > >     Rename all.sh to run_kselftest.sh.
>  > > >     Add --no-print-directory to emit_tests invocation.
>  > > > v4: Rebase onto 4.0-rc3, add TEST_FILES to efivars and vm tests, remove
>  > > >     newlines from echoes.
>  > > 
>  > > I don't see my comments addressed. If you want me to take
>  > > this work, please address the following comments:
>  > > 
>  > > - Name install directory kselftest. It should work with the
>  > >   the use-case.
>  > > 
>  > >   make INSTALL_PATH=/tmp make install
>  > >   The install directory should be /tmp/kselftest
>  > > 
>  > > - Flatten the directory with all tests under /tmp/kselftest
>  > > 
>  > > I am wasting lot of time because you don't fully address my
>  > > comments and send patches that dont' work correctly. Please
>  > > make sure your patches don't generate work for me.
>  > 
>  > You're wasting a lot of time? You have got to be kidding me. You are wasting a
>  > lot of *my* time.
>  > 
>  > You have my patches, they're signed off, you can do what you wish with them.
>  > Good luck.
> 
> This is getting silly. We've spent three months arguing over shell
> scripts and makefiles for what should be a trivial feature.
> We make fundamental changes to the VM code with less contention.

I really don't think this process has to this contentious. I don't
believe the changes I am asking for are unreasonable.

> 
> It's not helped that timezones are working against everyone here,
> so even minor changes end up taking a while to get reposted, re-reviewed
> etc, but the level of pushback because something isn't perfect is absurd,
> especially when we're talking about new features.

Directory structure might seem like a trivial problem, however it is
important to get the user interface right.

Since Michael doesn't have the bandwidth to make the suggested changes,
I working on applying his patches. There are some conflicts with the

selftests: Introduce minimal shared logic for running tests
selftests: Add install target

patches and timer patches. I can fix the directory hierarchy after
I get these two patches into next.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
