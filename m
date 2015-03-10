From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 3/3] selftests: kcmp build fails when invoked from
 kselftest target
Date: Wed, 11 Mar 2015 01:45:00 +0300
Message-ID: <20150310224500.GO30296@moon>
References: <cover.1426022048.git.shuahkh@osg.samsung.com>
 <80f321919d8d1f804c4933acac9b044d4c6626eb.1426022048.git.shuahkh@osg.samsung.com>
 <20150310220954.GL30296@moon>
 <54FF7323.2080603@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54FF7323.2080603@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: akpm@linux-foundation.org, tranmanphong@gmail.com, mpe@ellerman.id.au, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 10, 2015 at 04:41:39PM -0600, Shuah Khan wrote:
> 
> Are you looking for something like this:
> 
> all: kcmp_test
> 
> kcmp_test:
> 	$(CC) $(CFLAGS) kcmp_test.c -o kcmp_test
> 
> I just simplified it and removed the prerequsite.
> If you prefer, I can make the change to keep the
> prereq.

Yes please, and you may use internal make var $@ as well

kcmp_test:
	$(CC) $(CFLAGS) kcmp_test.c -o $@
