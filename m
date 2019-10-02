From: Jann Horn <jannh@google.com>
Subject: Re: [RFC][PATCH] sysctl: Remove the sysctl system call
Date: Wed, 2 Oct 2019 02:40:04 +0200
Message-ID: <CAG48ez1Ly26fP3_3DaGGkHgpyG3zmOmeC95jUmpVUwvjnLG8SQ@mail.gmail.com>
References: <8736gcjosv.fsf@x220.int.ebiederm.org> <201910011140.EA0181F13@keescook>
 <87imp8hyc8.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87imp8hyc8.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kostya Serebryany <kcc@google.com>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, Cong Wang <xiyou.wangcong@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>, Apelete Seketeli <apelete@seketeli.net>, Arnd Bergmann <arnd@arndb.de>, Chee Nouk Phoon <cnphoon@altera.com>, Chris Zankel <chris@zankel.net>, Christian Ruppert <christian.ruppert@abilis.com>, Greg Ungerer <gerg@uclinux.org>, Helge Deller <deller@gmx.de>, Hongliang Tao <taohl@lemote.com>, Huacai Chen <chenhc@lemote.com>, Jonas Jensen <jonas.jensen@gmail.com>, Josh Boyer <jwboyer@gmail.com>, Jun
List-Id: linux-api@vger.kernel.org

+Kostya (code owner for LLVM sanitizer_common) as FYI

On Wed, Oct 2, 2019 at 12:54 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
> > On Tue, Oct 01, 2019 at 01:36:32PM -0500, Eric W. Biederman wrote:
[...]
> > I think you can actually take this further and remove (or at least
> > empty) the uapi/linux/sysctl.h file too.
[...]
> I would make it a followup that removes uapi/linux/sysctl.h.  I don't
> see anything in it that isn't about the sysctl system call.  I will keep
> it a separate patch as I can imagine something silly that needs the
> header file to compile.  A separate patch would make a revert easier
> if we find something like that.

Unfortunately, I think that header (or at least parts of it) has to
stay around for now:

Looking through the search results for linux/sysctl.h (ignoring
glibc's sys/sysctl.h, which pulls in linux/sysctl.h, because almost
all of those hits are conditional includes for BSD systems) on
codesearch.debian.net, I noticed that e.g. the ASAN code that GCC and
LLVM use pulls in linux/sysctl.h and uses things from it:

https://github.com/llvm-mirror/compiler-rt/blob/124fd5d9aff57cf47bf077df81ad939b289acc6e/lib/sanitizer_common/sanitizer_platform_limits_posix.cpp#L1063

And indeed, after replacing /usr/include/linux/sysctl.h with an empty
file, a build of LLVM's runtime library component (compiler-rt) (git
HEAD version) falls over with error spew about __sysctl_args:

====================
$ cmake -G Ninja -DCMAKE_BUILD_TYPE=Release
-DLLVM_ENABLE_PROJECTS='clang;compiler-rt' -DCMAKE_C_COMPILER=clang-7
-DCMAKE_CXX_COMPILER=clang++-7 -DLLVM_TARGETS_TO_BUILD="X86"
-DLLVM_USE_LINKER=lld-7 -DBUILD_SHARED_LIBS=Off ../llvm
[...]
$ ninja -j64
FAILED: projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommonNoTermination.i386.dir/sanitizer_platform_limits_posix.cpp.o
[...]
[...]/compiler-rt/lib/sanitizer_common/sanitizer_platform_limits_posix.cpp:1063:17:
error: use of undeclared identifier '__sysctl_args'
CHECK_TYPE_SIZE(__sysctl_args);
                ^
[...]/compiler-rt/lib/sanitizer_common/sanitizer_platform_limits_posix.cpp:1064:23:
error: use of undeclared identifier '__sysctl_args'
CHECK_SIZE_AND_OFFSET(__sysctl_args, name);
                      ^
[...]/compiler-rt/lib/sanitizer_common/sanitizer_platform_limits_posix.cpp:1064:1:
error: expected expression
CHECK_SIZE_AND_OFFSET(__sysctl_args, name);
^
[...]/compiler-rt/lib/sanitizer_common/sanitizer_platform_limits_posix.h:1438:34:
note: expanded from macro 'CHECK_SIZE_AND_OFFSET'
                 sizeof(((CLASS *)NULL)->MEMBER));                \
                                 ^
[...]/compiler-rt/lib/sanitizer_common/sanitizer_platform_limits_posix.cpp:1064:23:
error: unknown type name '__sysctl_args'
CHECK_SIZE_AND_OFFSET(__sysctl_args, name);
                      ^
====================
