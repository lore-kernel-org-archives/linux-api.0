From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Mon, 16 Mar 2015 14:04:52 +1100
Message-ID: <1426475092.20210.4.camel@ellerman.id.au>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
	 <1426046765-19289-4-git-send-email-mpe@ellerman.id.au>
	 <55031C78.4040609@osg.samsung.com> <5503577C.9050002@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5503577C.9050002@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-03-13 at 15:32 -0600, Shuah Khan wrote:
> On 03/13/2015 11:20 AM, Shuah Khan wrote:
> > On 03/10/2015 10:06 PM, Michael Ellerman wrote:
> >> This adds make install support to selftests. The basic usage is:
> >>
> >> $ cd tools/testing/selftests
> >> $ make install
> >>
> >> That installs into tools/testing/selftests/install, which can then be
> >> copied where ever necessary.
> >>
> >> The install destination is also configurable using eg:
> >>
> >> $ INSTALL_PATH=/mnt/selftests make install
> >>
> >> The implementation uses two targets in the child makefiles. The first
> >> "install" is expected to install all files into $(INSTALL_PATH).
> >>
> >> The second, "emit_tests", is expected to emit the test instructions (ie.
> >> bash script) on stdout. Separating this from install means the child
> >> makefiles need no knowledge of the location of the test script.
> >>
> >> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > 
> > Thanks for doing the work. This patch will be applied to next and will
> > be queued for 4.1
> > 
> 
> ok. linux-kselftest next has both shared logic and install patches
> now.

Thanks, looks good to me.

Can you also apply the patch to install the powerpc tests, or was there a
problem with it? It seems to apply cleanly for me.

https://lkml.org/lkml/2015/3/11/9

cheers
