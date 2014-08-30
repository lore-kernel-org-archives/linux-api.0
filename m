From: Drew Fustini <pdp7pdp7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: kselftest errors: test_num & fw_userhelper
Date: Sat, 30 Aug 2014 12:57:33 -0500
Message-ID: <5402108D.6010508@gmail.com>
References: <540196DD.1080807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540196DD.1080807-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi - I posted this on kernelnewbies and gregkh recommended I post here.  I would appreciate any suggestions.

I ran kselftest and it appears to have not finished due to errors from test_num & fw_userhelper:

afustini@lappy486:~/dev/linux/lappy486/git/kernels/mainline$ sudo make
kselftest
<snip>
== Testing sysctl behavior against /proc/sys/vm/swappiness ==
Writing test file ... ok
Checking sysctl is not set to test value ... ok
Writing sysctl from shell ... ok
Resetting sysctl to original value ... ok
Writing entire sysctl in single write ... ok
Writing middle of sysctl after synchronized seek ... FAIL
Writing beyond end of sysctl ... FAIL
Writing sysctl with multiple long writes ... ok
make[2]: *** [test_num] Error 1
./fw_filesystem.sh: timeout works
./fw_filesystem.sh: filesystem loading works
fw_filesystem: ok
./fw_userhelper.sh: timeout works
./fw_userhelper.sh: firmware interface never appeared
fw_userhelper: [FAIL]
make[2]: *** [fw_userhelper] Error 1
make[1]: *** [run_tests] Error 2
make: *** [kselftest] Error 2

I turned on all the testing kconfig options I could find under the kernel hacking category.  I built the kernel from torvalds linux.git tree on Aug-28:
Linux lappy486 3.17.0-lappy486-00040-gff0c57a-dirty #5 SMP PREEMPT Thu Aug 28 05:08:04 CDT 2014 x86_64 x86_64 x86_64 GNU/Linux

Log files for reference:

make-kselftest-3.17.0-lappy486-00040-gff0c57a-dirty.log:
https://gist.github.com/pdp7/79d511ddf30fa8d0dfee

dmesg-3.17.0-lappy486-00040-gff0c57a-dirty.log:
https://gist.github.com/pdp7/ea3f86dd7dc994189c14

kernel-config-3.17.0-lappy486-00040-gff0c57a-dirty.log:
https://gist.github.com/pdp7/07315ac2aba2ab4c48da

lsmod-3.17.0-lappy486-00040-gff0c57a-dirty.log:
https://gist.github.com/pdp7/c6db7271345afc8a6868

lib-modules-3.17.0-lappy486-00040-gff0c57a-dirty.log:
https://gist.github.com/pdp7/a297c5aa246cd2b1ac9f

find-sys-fs-3.17.0-lappy486-00040-gff0c57a-dirty.log:
https://gist.github.com/pdp7/9238072c1630e0995749

git-status-3.17.0-lappy486-00040-gff0c57a-dirty.log:
https://gist.github.com/pdp7/c300ced047d1fa7fc696

git-diff-3.17.0-lappy486-00040-gff0c57a-dirty.log:
https://gist.github.com/pdp7/686ab164c55a25fcb5f8


thanks,
drew
