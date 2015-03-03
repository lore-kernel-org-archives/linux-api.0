From: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Subject: Re: [PATCH] selftests: Add install, generate tar, and run_kselftest
 tools
Date: Tue, 3 Mar 2015 09:49:16 -0500
Message-ID: <20150303144916.GA24111@codemonkey.org.uk>
References: <1425358088-9667-1-git-send-email-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425358088-9667-1-git-send-email-shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 02, 2015 at 09:48:08PM -0700, Shuah Khan wrote:
 > kselftest_install.sh tool adds support for installing selftests
 > at user specified location/kselftest. By default this tool
 > will install selftests in the selftests/kselftest directory.
 > For example, kselftest_install /tmp will install tests under
 > /tmp/kselftest
 
How is this an improvement over having each test install method isolated
to its own Makefile ?

 > +# Installs normal tests and skips special tests and kselftest tools
 > +# gen_kselftesr_tar.sh and kselftes_install.sh
 > +# Also skips problematic xxxx* file that gets created when execveat
 > +# test is built. The file name is too long and resulting in error
 > +# messages.
 > +	find `pwd`/* -type d -name rcutorture -prune -o -type f \
 > +		-executable -print | grep -v 'tar\|install\|xxxx' | \
 > +		xargs install -t $install_dir
 > +# Install shell scripts that aren't executables
 > +	find `pwd`/* -type d -name rcutorture -prune -o -name "*.sh" -print | \
 > +		grep -v 'tar\|install\|run\|on-off' | \
 > +		xargs install -t $install_dir
 > +# Special handling for cpu-hotplug and memory-hotplug .sh with the same name
 > +	install `pwd`/cpu-hotplug/on-off-test.sh \
 > +		$install_dir/cpu-on-off-test.sh
 > +	install `pwd`/memory-hotplug/on-off-test.sh \
 > +		$install_dir/mem-on-off-test.sh
 > +# Special handling for scripts without .sh extension
 > +	install `pwd`/vm/run_vmtests $install_dir
 > +	install `pwd`/net/run_netsocktests $install_dir
 > +	install `pwd`/net/run_afpackettests $install_dir
 > +	install `pwd`/sysctl/common_tests $install_dir
 > +# Install dependent directories for ftrace and exec tests
 > +	cp -r `pwd`/ftrace/test.d $install_dir
 > +	install `pwd`/exec/execveat.denatured $install_dir
 > +	cp -r `pwd`/exec/subdir $install_dir

This already makes my eyes hurt, and is only going to grow as more tests
get added. Additionally when two people are trying to add tests at the
same time, you're guaranteeing future merge conflicts here.

	Dave
