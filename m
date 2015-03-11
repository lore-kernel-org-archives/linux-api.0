From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/9] selftests: Add install target
Date: Wed, 11 Mar 2015 14:20:19 +1100
Message-ID: <1426044019.23148.2.camel@ellerman.id.au>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
	 <1425358302-16680-2-git-send-email-mpe@ellerman.id.au>
	 <20150305185326.GA30620@codemonkey.org.uk>
	 <54FDAC4A.9080703@osg.samsung.com> <54FE1EC0.6000201@osg.samsung.com>
	 <54FF098D.7020106@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54FF098D.7020106@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>, mmarek@suse.cz
List-Id: linux-api@vger.kernel.org

On Tue, 2015-03-10 at 09:11 -0600, Shuah Khan wrote:
> On 03/09/2015 04:29 PM, Shuah Khan wrote:
> > On 03/09/2015 08:20 AM, Shuah Khan wrote:
> >> On 03/05/2015 11:53 AM, Dave Jones wrote:
> >>> On Tue, Mar 03, 2015 at 03:51:35PM +1100, Michael Ellerman wrote:
> >>>  > This adds make install support to selftests. The basic usage is:
> >>>  > 
> >>>  > $ cd tools/testing/selftests
> >>>  > $ make install
> >>>  > 
> >>>  > That installs into tools/testing/selftests/install, which can then be
> >>>  > copied where ever necessary.
> >>>  > 
> >>>  > The install destination is also configurable using eg:
> >>>  > 
> >>>  > $ INSTALL_PATH=/mnt/selftests make install
> >>>
> >>>  ...
> >>>
> >>>  > +	@# Ask all targets to emit their test scripts
> >>>  > +	echo "#!/bin/bash\n\n" > $(ALL_SCRIPT)
> >>>
> >>> $ ./all.sh 
> >>> -bash: ./all.sh: /bin/bash\n\n: bad interpreter: No such file or directory
> >>>
> >>> Removing the \n\n fixes it.
> >>>
> >>>  > +		echo "cd \$$ROOT\n" >> $(ALL_SCRIPT); \
> >>>
> >>> ditto
> >>>
> >>> 	Dave
> >>
> >> Michael,
> >>
> >> Could you please fix these problems and send the patch.
> >>
> > 
> > Michael,
> > 
> > Did you happen to run run_kselftest.sh from the install
> > directory to make sure all the dependent executables
> > are installed? You are missing a few required dependencies.
> > efivars test for example.
> > 
> > Please run kselftest_install.sh I sent out for review and
> > compare the following:
> > 
> > - contents of install directory created with your patch vs.
> >   my kselftest_install.sh tool
> > - Compare your run_kselftest.sh run with the one that gets
> >   generated with my kselftest_install.sh tool
> > 
> > General rule is all tests that get run when run_tests target
> > is run should run from the install directory using the
> > run_kselftest.sh generated during install.
> > 
> 
> Couple more things. Please change the install directory name
> to kselftest
> 
> tools/testing/selftests/kselftest
> instead of
> tools/testing/selftests/install

I prefer install, that's what it is after all. I don't know why you're so
obsessed with the "kselftest" name.

> Also please flatten the directory structure under the install
> directory. I don't see any value in creating directory for each
> test for install. Also it is makes it cumbersome for users
> to navigate and work with after the install. This would mean cpu
> and memory hot-plug scripts need unique names.

That's not a good idea. To start with different tests might the same name, as
already happens with the memory & cpu hot-plug tests. They may also have data
files that would clobber each other. We'd need to make sure all files used in
all tests have different names, that would be a total mess.

cheers
