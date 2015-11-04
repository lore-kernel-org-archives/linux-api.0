From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 selftests 0/6] Fix some broken tests
Date: Tue, 3 Nov 2015 17:00:47 -0700
Message-ID: <56394AAF.9060200@osg.samsung.com>
References: <20151102122048.GA17015@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151102122048.GA17015-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/02/2015 05:20 AM, Ben Hutchings wrote:
> This series fixes some self-tests that are broken, unreliable or 
> produce compiler warnings in 4.3.
> 
> Ben.
> 
> Ben Hutchings (6): selftests: Add missing #include directives 
> selftests: memfd: Stop unnecessary rebuilds selftests: kprobe:
> Choose an always-defined function to probe selftests: Make scripts
> executable selftests: vm: Try harder to allocate huge pages 
> selftests: breakpoint: Actually build it
> 
> tools/testing/selftests/breakpoints/Makefile              |  2 +- 
> .../selftests/ftrace/test.d/kprobe/add_and_remove.tc      |  2 +- 
> .../testing/selftests/ftrace/test.d/kprobe/busy_check.tc  |  2 +- 
> .../testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc |  2 +- 
> .../selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc       | 14
> +++++++------- .../selftests/ftrace/test.d/kprobe/kretprobe_args.tc
> |  2 +- tools/testing/selftests/memfd/Makefile                    |
> 12 ++++++------ tools/testing/selftests/memfd/memfd_test.c
> |  1 + tools/testing/selftests/memfd/run_fuse_test.sh            |
> 0 tools/testing/selftests/mqueue/mq_open_tests.c            |  1 + 
> tools/testing/selftests/mqueue/mq_perf_tests.c            |  1 + 
> tools/testing/selftests/static_keys/test_static_keys.sh   |  0 
> tools/testing/selftests/timers/nanosleep.c                |  1 + 
> tools/testing/selftests/vm/run_vmtests                    | 15
> ++++++++++++++- 14 files changed, 36 insertions(+), 19
> deletions(-) mode change 100644 => 100755
> tools/testing/selftests/memfd/run_fuse_test.sh mode change 100644
> => 100755 tools/testing/selftests/static_keys/test_static_keys.sh
> 

Ben,

Thanks for doing this. Several tests pass now with your patches.
All 6 patches applied to linux-kselftest next for 4.4

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
