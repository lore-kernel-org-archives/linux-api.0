From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/9] selftests: Add install target
Date: Mon, 09 Mar 2015 08:20:58 -0600
Message-ID: <54FDAC4A.9080703@osg.samsung.com>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au> <1425358302-16680-2-git-send-email-mpe@ellerman.id.au> <20150305185326.GA30620@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150305185326.GA30620@codemonkey.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@codemonkey.org.uk>, Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/05/2015 11:53 AM, Dave Jones wrote:
> On Tue, Mar 03, 2015 at 03:51:35PM +1100, Michael Ellerman wrote:
>  > This adds make install support to selftests. The basic usage is:
>  > 
>  > $ cd tools/testing/selftests
>  > $ make install
>  > 
>  > That installs into tools/testing/selftests/install, which can then be
>  > copied where ever necessary.
>  > 
>  > The install destination is also configurable using eg:
>  > 
>  > $ INSTALL_PATH=/mnt/selftests make install
> 
>  ...
> 
>  > +	@# Ask all targets to emit their test scripts
>  > +	echo "#!/bin/bash\n\n" > $(ALL_SCRIPT)
> 
> $ ./all.sh 
> -bash: ./all.sh: /bin/bash\n\n: bad interpreter: No such file or directory
> 
> Removing the \n\n fixes it.
> 
>  > +		echo "cd \$$ROOT\n" >> $(ALL_SCRIPT); \
> 
> ditto
> 
> 	Dave

Michael,

Could you please fix these problems and send the patch.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
