From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH RFC 1/6] selftests: remove duplicated all and clean target
Date: Fri, 18 Nov 2016 21:31:21 +1100
Message-ID: <87mvgxgjuu.fsf@concordia.ellerman.id.au>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com> <1477047694-24122-2-git-send-email-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477047694-24122-2-git-send-email-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Bamvor,

bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org writes:

> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Currently, kselftest use TEST_PROGS, TEST_PROGS_EXTENDED, TEST_FILES to
> indicate the default test program, extended test program and test files.
> These lead to duplicated all and clean targets.
>
> In order to remove them, introduce TEST_GEN_PROGS,
> TEST_GEN_PROGS_EXTENDED, TEST_GEN_FILES to indicate the compiled
> objected.

It's nice to be able to drop the clean rules, but renaming all those
variables causes a lot of churn.

I think it would be better if we add a new variable, maybe NO_CLEAN,
which can be used to specify anything in TEST_PROGS/EXTENDED which
should *not* be cleaned.

And then the default clean rule will just do:

clean:
	$(RM) -fr $(filter-out $(NO_CLEAN),$(TEST_PROGS))


I think that would require less changes overall, because most tests just
want to build some files, run them, and then clean them. The tests that
need to do more elaborate things are the exception.

cheers
