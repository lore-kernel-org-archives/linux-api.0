From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v4 4/9] selftests: Add install target
Date: Thu, 12 Mar 2015 14:11:53 +1100
Message-ID: <1426129913.25936.2.camel@ellerman.id.au>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au>
	 <1426046765-19289-4-git-send-email-mpe@ellerman.id.au>
	 <5500408B.2070604@osg.samsung.com> <5500675A.1000700@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5500675A.1000700-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-03-11 at 10:03 -0600, Shuah Khan wrote:
> On 03/11/2015 07:18 AM, Shuah Khan wrote:
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
> 
> Yes. There is the issue of duplicate executable names and data
> file to be concerned about. It is a name-space problem. It is
> not unique to this case, example /usr/bin. This problem is better
> solved without adding the complexity of hierarchical directory
> structure.
> 
> 1. Individual test Makefiles ensure unique names for their
>    executables and data files. This can be done as a process
>    when new tests are accepted.
> 2. Install process makes sure they are unique - this patch is
>    solving the problem by creating a directory hierarchy. A simpler
>    way to do it is by adding pre-fix to when there is name space
>    conflict.
> 
> The problem with directory hierarchy is for one thing:
> 
> 1. It is complex and way too many directories get created during
>    install and this problem will mushroom as more and more tests
>    get added.

One directory is created for each test directory under selftests. That's not
"way too many" directories.

Why does it make sense to have directories for the selftest sources, but not
the installed tests? Why don't we just put all the tests in one directory under
selftests? A: Because that would be stupid.

$ find tools/testing/selftests/ -maxdepth 1 -type d
tools/testing/selftests/
tools/testing/selftests/size
tools/testing/selftests/memory-hotplug
tools/testing/selftests/ipc
tools/testing/selftests/ptrace
tools/testing/selftests/timers
tools/testing/selftests/efivarfs
tools/testing/selftests/net
tools/testing/selftests/kcmp
tools/testing/selftests/mqueue
tools/testing/selftests/ftrace
tools/testing/selftests/mount
tools/testing/selftests/vm
tools/testing/selftests/firmware
tools/testing/selftests/cpu-hotplug
tools/testing/selftests/user
tools/testing/selftests/sysctl
tools/testing/selftests/powerpc
tools/testing/selftests/exec
tools/testing/selftests/memfd
tools/testing/selftests/breakpoints
tools/testing/selftests/rcutorture

Oh no directories, they're so complex!

> 2. User won't be able to define a simple path variable to invoke
>    individual tests. This is a user experience problem.

Who cares? No one does that. Many of the tests aren't just simple executables
that can be run via $PATH, they require test files in the current directory.

cheers
