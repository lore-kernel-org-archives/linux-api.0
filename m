From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v2 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Wed, 22 Mar 2017 22:35:03 +1100
Message-ID: <87fui5czo8.fsf@concordia.ellerman.id.au>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com> <20161129115552.8148-7-bamvor.zhangjian@huawei.com> <CALCETrUCbGC5tmzKzYn0qE5w8omk6ZRDj4p9qz5-Ho92+W5McA@mail.gmail.com> <87fui7owls.fsf@concordia.ellerman.id.au> <CAFy1USRoKJ7G9ewLGBa1yy9V5UA+g=jo7O+eU1wV_rjKDYtJWg@mail.gmail.com> <5daf0b79-a000-2adb-0b1e-f528d66ff6df@osg.samsung.com> <CAFy1USRjGvF3iwWa8k54fFzcMaMcN3VCQ1qMpZ3RSqZvT17Atw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFy1USRjGvF3iwWa8k54fFzcMaMcN3VCQ1qMpZ3RSqZvT17Atw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
> Here is a fix. I could build individual test case in x86 and build the whole
> x86 test cases successful respectively. And I do a quick test for all the
> subsets. Please review the patch if it is make sense to you and Michael.
> At the same time, I am buildind and testing all the testcases.
>
> Michael: could you please do me a favor to test the powerpc part? Thanks.

I would but the patch is white spaced damaged, can you resend it?

You can also test powerpc yourself, if you just install a cross compiler:

Fedora $ sudo dnf install gcc-c++-powerpc64-linux-gnu binutils-powerpc64-linux-gnu gcc-powerpc64-linux-gnu
Ubuntu $ sudo apt-get install gcc-powerpc64le-linux-gnu gcc-powerpc-linux-gnu libc-dev-powerpc-cross libc-dev-ppc64el-cross

$ make ARCH=powerpc headers_install
$ make ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- -C tools/testing/selftests


cheers
