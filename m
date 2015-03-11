From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2] selftests: kcmp build fails when invoked from kselftest
 target
Date: Wed, 11 Mar 2015 07:30:18 -0600
Message-ID: <5500436A.4010802@osg.samsung.com>
References: <1426032512-10353-1-git-send-email-shuahkh@osg.samsung.com> <1426040377.20917.8.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426040377.20917.8.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: gorcunov@openvz.org, akpm@linux-foundation.org, tranmanphong@gmail.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/10/2015 08:19 PM, Michael Ellerman wrote:
> On Tue, 2015-03-10 at 18:08 -0600, Shuah Khan wrote:
>> kcmp Makefile doesn't have an explicit build rule. As a result,
>> kcmp build fails, when it is run from top level Makefile target
>> kselftest. Without the explicit rule, make works only when it is
>> run in the current directory or from selftests directory. Add an
>> explicit build rule to fix the problem. 
> 
> This should be fixed properly using my patch to filter -rR or similar.

I don't agree with this. Relying on ARCH Makefiles doing the
right thing for individual tests to build makes it difficult
to maintain. We will keep running into problems for each of
the ARCH.

I would rather have this addressed in the individual Makefiles
with an explicit rule and if -rR approach works, great. So it
has to be two pronged approach with individual Makefiles being
able to work irrespective of ARCH Makefiles doing the right
thing.

> 
>> In addition, build fails
>> as it can't find kcmp.h. Fix it by passing CFLAGS.
> 
> That is also wrong. It should *not* be looking in include/uapi.
> 
> If it needs headers then it should be using the *exported* headers, which are
> in ../../../../usr/include as the existing CFLAGS specifiy.
> 
> Those headers are installed as part of 'make headers_install'.
> 

Adding uapi covers both cases where the headers aren't installed yet.
Also make V=1 doesn't show CFLAGS getting passed in. They need to be
passed in explicitly even when run from the kcmp directory.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
