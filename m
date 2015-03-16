From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Mon, 16 Mar 2015 14:12:57 +1100
Message-ID: <1426475577.20210.8.camel@ellerman.id.au>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
	 <1426046765-19289-4-git-send-email-mpe@ellerman.id.au>
	 <55031C78.4040609@osg.samsung.com> <5503577C.9050002@osg.samsung.com>
	 <1426475092.20210.4.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426475092.20210.4.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-03-16 at 14:04 +1100, Michael Ellerman wrote:
> On Fri, 2015-03-13 at 15:32 -0600, Shuah Khan wrote:
> > On 03/13/2015 11:20 AM, Shuah Khan wrote:
> > > On 03/10/2015 10:06 PM, Michael Ellerman wrote:
> > >> This adds make install support to selftests. The basic usage is:
> > >>
> > >> $ cd tools/testing/selftests
> > >> $ make install
> > >>
> > >> That installs into tools/testing/selftests/install, which can then be
> > >> copied where ever necessary.
> > >>
> > >> The install destination is also configurable using eg:
> > >>
> > >> $ INSTALL_PATH=/mnt/selftests make install
> > >>
> > >> The implementation uses two targets in the child makefiles. The first
> > >> "install" is expected to install all files into $(INSTALL_PATH).
> > >>
> > >> The second, "emit_tests", is expected to emit the test instructions (ie.
> > >> bash script) on stdout. Separating this from install means the child
> > >> makefiles need no knowledge of the location of the test script.
> > >>
> > >> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> > > 
> > > Thanks for doing the work. This patch will be applied to next and will
> > > be queued for 4.1
> > > 
> > 
> > ok. linux-kselftest next has both shared logic and install patches
> > now.
> 
> Thanks, looks good to me.

And also 6/9 "selftests: Set CC using CROSS_COMPILE once in lib.mk" would be
nice and is uncontroversial, I think:

https://lkml.org/lkml/2015/3/11/5

cheers
