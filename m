From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Thu, 12 Mar 2015 14:15:44 +1100
Message-ID: <1426130144.25936.4.camel@ellerman.id.au>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
	 <1426046765-19289-4-git-send-email-mpe@ellerman.id.au>
	 <5500408B.2070604@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5500408B.2070604-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-03-11 at 07:18 -0600, Shuah Khan wrote:
> On 03/10/2015 10:06 PM, Michael Ellerman wrote:
> > This adds make install support to selftests. The basic usage is:
> > 
> > $ cd tools/testing/selftests
> > $ make install
> > 
> > That installs into tools/testing/selftests/install, which can then be
> > copied where ever necessary.
> > 
> > The install destination is also configurable using eg:
> > 
> > $ INSTALL_PATH=/mnt/selftests make install
> > 
> > The implementation uses two targets in the child makefiles. The first
> > "install" is expected to install all files into $(INSTALL_PATH).
> > 
> > The second, "emit_tests", is expected to emit the test instructions (ie.
> > bash script) on stdout. Separating this from install means the child
> > makefiles need no knowledge of the location of the test script.
> > 
> > Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> > ---
> > 
> > v3: Rebase onto 4.0-rc2.
> >     Rename all.sh to run_kselftest.sh.
> >     Add --no-print-directory to emit_tests invocation.
> > v4: Rebase onto 4.0-rc3, add TEST_FILES to efivars and vm tests, remove
> >     newlines from echoes.
> 
> I don't see my comments addressed. If you want me to take
> this work, please address the following comments:
> 
> - Name install directory kselftest. It should work with the
>   the use-case.
> 
>   make INSTALL_PATH=/tmp make install
>   The install directory should be /tmp/kselftest
> 
> - Flatten the directory with all tests under /tmp/kselftest
> 
> I am wasting lot of time because you don't fully address my
> comments and send patches that dont' work correctly. Please
> make sure your patches don't generate work for me.

You're wasting a lot of time? You have got to be kidding me. You are wasting a
lot of *my* time.

You have my patches, they're signed off, you can do what you wish with them.
Good luck.
