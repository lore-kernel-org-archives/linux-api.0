From: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Subject: Re: [PATCH 2/9] selftests: Add install target
Date: Tue, 10 Mar 2015 23:18:48 -0400
Message-ID: <20150311031848.GA7763@codemonkey.org.uk>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
 <1425358302-16680-2-git-send-email-mpe@ellerman.id.au>
 <20150305185326.GA30620@codemonkey.org.uk>
 <1426043710.23148.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426043710.23148.1.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 11, 2015 at 02:15:10PM +1100, Michael Ellerman wrote:
 > On Thu, 2015-03-05 at 13:53 -0500, Dave Jones wrote:
 > > $ ./all.sh 
 > > -bash: ./all.sh: /bin/bash\n\n: bad interpreter: No such file or directory
 > > 
 > > Removing the \n\n fixes it.
 > > 
 > >  > +		echo "cd \$$ROOT\n" >> $(ALL_SCRIPT); \
 > > 
 > > ditto
 > 
 > Weird, I don't see that.
 > 
 >   $ make install
 >   $ head install/run_kselftest.sh
 >   #!/bin/bash
 >   
 >   
 >   cd $(dirname $0)
 > 
 > 
 > Does it depend on the shell? I guess none of the newlines are necessary so I'll
 > just remove them.

Dunno, bash here too. Maybe the version ? My environment at the office is a little
dated. (It's based on ye olde ubuntu lts)

	Dave
