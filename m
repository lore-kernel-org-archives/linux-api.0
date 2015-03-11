From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Wed, 11 Mar 2015 07:18:03 -0600
Message-ID: <5500408B.2070604@osg.samsung.com>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au> <1426046765-19289-4-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426046765-19289-4-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/10/2015 10:06 PM, Michael Ellerman wrote:
> This adds make install support to selftests. The basic usage is:
> 
> $ cd tools/testing/selftests
> $ make install
> 
> That installs into tools/testing/selftests/install, which can then be
> copied where ever necessary.
> 
> The install destination is also configurable using eg:
> 
> $ INSTALL_PATH=/mnt/selftests make install
> 
> The implementation uses two targets in the child makefiles. The first
> "install" is expected to install all files into $(INSTALL_PATH).
> 
> The second, "emit_tests", is expected to emit the test instructions (ie.
> bash script) on stdout. Separating this from install means the child
> makefiles need no knowledge of the location of the test script.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
> 
> v3: Rebase onto 4.0-rc2.
>     Rename all.sh to run_kselftest.sh.
>     Add --no-print-directory to emit_tests invocation.
> v4: Rebase onto 4.0-rc3, add TEST_FILES to efivars and vm tests, remove
>     newlines from echoes.

I don't see my comments addressed. If you want me to take
this work, please address the following comments:

- Name install directory kselftest. It should work with the
  the use-case.

  make INSTALL_PATH=/tmp make install
  The install directory should be /tmp/kselftest

- Flatten the directory with all tests under /tmp/kselftest

I am wasting lot of time because you don't fully address my
comments and send patches that dont' work correctly. Please
make sure your patches don't generate work for me.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
