From: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Subject: Re: [PATCH 2/9] selftests: Add install target
Date: Thu, 5 Mar 2015 13:53:26 -0500
Message-ID: <20150305185326.GA30620@codemonkey.org.uk>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
 <1425358302-16680-2-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425358302-16680-2-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 03, 2015 at 03:51:35PM +1100, Michael Ellerman wrote:
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

 ...

 > +	@# Ask all targets to emit their test scripts
 > +	echo "#!/bin/bash\n\n" > $(ALL_SCRIPT)

$ ./all.sh 
-bash: ./all.sh: /bin/bash\n\n: bad interpreter: No such file or directory

Removing the \n\n fixes it.

 > +		echo "cd \$$ROOT\n" >> $(ALL_SCRIPT); \

ditto

	Dave
