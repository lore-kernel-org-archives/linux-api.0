From: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Fri, 13 Mar 2015 12:33:12 -0400
Message-ID: <20150313163312.GA24666@codemonkey.org.uk>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
 <1426046765-19289-4-git-send-email-mpe@ellerman.id.au>
 <5500408B.2070604@osg.samsung.com>
 <1426130144.25936.4.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426130144.25936.4.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 12, 2015 at 02:15:44PM +1100, Michael Ellerman wrote:
 > On Wed, 2015-03-11 at 07:18 -0600, Shuah Khan wrote:
 > > On 03/10/2015 10:06 PM, Michael Ellerman wrote:
 > > > This adds make install support to selftests. The basic usage is:
 > > > 
 > > > v3: Rebase onto 4.0-rc2.
 > > >     Rename all.sh to run_kselftest.sh.
 > > >     Add --no-print-directory to emit_tests invocation.
 > > > v4: Rebase onto 4.0-rc3, add TEST_FILES to efivars and vm tests, remove
 > > >     newlines from echoes.
 > > 
 > > I don't see my comments addressed. If you want me to take
 > > this work, please address the following comments:
 > > 
 > > - Name install directory kselftest. It should work with the
 > >   the use-case.
 > > 
 > >   make INSTALL_PATH=/tmp make install
 > >   The install directory should be /tmp/kselftest
 > > 
 > > - Flatten the directory with all tests under /tmp/kselftest
 > > 
 > > I am wasting lot of time because you don't fully address my
 > > comments and send patches that dont' work correctly. Please
 > > make sure your patches don't generate work for me.
 > 
 > You're wasting a lot of time? You have got to be kidding me. You are wasting a
 > lot of *my* time.
 > 
 > You have my patches, they're signed off, you can do what you wish with them.
 > Good luck.

This is getting silly. We've spent three months arguing over shell
scripts and makefiles for what should be a trivial feature.
We make fundamental changes to the VM code with less contention.

It's not helped that timezones are working against everyone here,
so even minor changes end up taking a while to get reposted, re-reviewed
etc, but the level of pushback because something isn't perfect is absurd,
especially when we're talking about new features.

If you want the in-kernel variant to be perfect every step of the way,
and move slowly and never introduce subtle breakage along the way that then
gets fixed up in subsequent changes, maybe a faster moving external project
that syncs up with the kernel tree is the way forward.

If kselftests is going to evolve into something useful, something has to change.

	Dave
